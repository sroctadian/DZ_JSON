CREATE OR REPLACE PACKAGE BODY dz_json_test
AS

   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   FUNCTION prerequisites
   RETURN NUMBER
   AS
      num_check NUMBER;
      
   BEGIN
      
      FOR i IN 1 .. C_PREREQUISITES.COUNT
      LOOP
         SELECT 
         COUNT(*)
         INTO num_check
         FROM 
         user_objects a
         WHERE 
             a.object_name = C_PREREQUISITES(i) || '_TEST'
         AND a.object_type = 'PACKAGE';
         
         IF num_check <> 1
         THEN
            RETURN 1;
         
         END IF;
      
      END LOOP;
      
      RETURN 0;
   
   END prerequisites;
   
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   FUNCTION version
   RETURN VARCHAR2
   AS
   BEGIN
      RETURN '{"TFS":' || C_TFS_CHANGESET || ','
      || '"JOBN":"' || C_JENKINS_JOBNM || '",'   
      || '"BUILD":' || C_JENKINS_BUILD || ','
      || '"BUILDID":"' || C_JENKINS_BLDID || '"}';
      
   END version;
   
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   FUNCTION inmemory_test
   RETURN NUMBER
   AS
      num_test     NUMBER;
      num_results  NUMBER := 0;
      clb_results  CLOB;

   BEGIN
   
      --------------------------------------------------------------------------
      -- Step 10
      -- Check 2D Point 
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2001
             ,8265
             ,MDSYS.SDO_POINT_TYPE(-87.845556,42.582222,NULL)
             ,NULL
             ,NULL
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"Point","coordinates":[-87.845556,42.582222]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Point: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 20
      -- Check 2D Point Cluster
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2005
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1
                 ,3
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -72.45454
                 ,42.23232
                 ,-71.78787
                 ,42.989898
                 ,-71.334455
                 ,42.515151
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"MultiPoint","coordinates":[[-72.45454,42.23232],[-71.78787,42.989898],[-71.334455,42.515151]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Point Cluster: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 30
      -- Check 2D Linestring 
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2002
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,2
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -71.160281
                 ,42.258729
                 ,-71.260837
                 ,42.259113
                 ,-71.361144
                 ,42.25932
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"LineString","coordinates":[[-71.160281,42.258729],[-71.260837,42.259113],[-71.361144,42.25932]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Linestring: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 40
      -- Check 2D Polygon 
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2003
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1003
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -77.2903337908711
                 ,41.9901156015547
                 ,-77.2898433240096
                 ,41.9903066678044
                 ,-77.2906707236743
                 ,41.9905902014476
                 ,-77.2903337908711
                 ,41.9901156015547
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"Polygon","coordinates":[[[-77.2903337908711,41.9901156015547],[-77.2898433240096,41.9903066678044],[-77.2906707236743,41.9905902014476],[-77.2903337908711,41.9901156015547]]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Polygon: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 50
      -- Check 2D Rectangle 
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2003
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1003
                 ,3
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -77.2903337908711
                 ,41.9901156015547
                 ,-76.2898433240096
                 ,42.9903066678044
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"Polygon","coordinates":[[[-77.2903337908711,41.9901156015547],[-76.2898433240096,41.9901156015547],[-76.2898433240096,42.9903066678044],[-77.2903337908711,42.9903066678044],[-77.2903337908711,41.9901156015547]]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Rectangle: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 60
      -- Check 2D Polygon with hole
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2003
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1003
                 ,1
                 ,33
                 ,2003
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -69.2352824697095
                 ,46.6621271945153
                 ,-69.2350178693785
                 ,46.6626301943289
                 ,-69.2349856026028
                 ,46.6630875274683
                 ,-69.2353518029427
                 ,46.663589993984
                 ,-69.2354856697272
                 ,46.6641613278839
                 ,-69.2357848696753
                 ,46.6643667941931
                 ,-69.2362164696137
                 ,46.664366327445
                 ,-69.236847003186
                 ,46.6641599941893
                 ,-69.2374438031883
                 ,46.6637707271383
                 ,-69.2376754694467
                 ,46.6634275944089
                 ,-69.237541269913
                 ,46.6627877276724
                 ,-69.2372414692177
                 ,46.6623079942195
                 ,-69.2368756699755
                 ,46.6620111945619
                 ,-69.2363110027499
                 ,46.6618517942258
                 ,-69.2360122695499
                 ,46.6618521944242
                 ,-69.2352824697095
                 ,46.6621271945153
                 ,-69.2364458030307
                 ,46.6628803272662
                 ,-69.2367118692567
                 ,46.6631085940872
                 ,-69.2365794692664
                 ,46.6632915944325
                 ,-69.2361148696049
                 ,46.6633835276286
                 ,-69.2359154692228
                 ,46.6632923273799
                 ,-69.2359150699239
                 ,46.6631093944839
                 ,-69.2364458030307
                 ,46.6628803272662
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"Polygon","coordinates":[[[-69.2352824697095,46.6621271945153],[-69.2350178693785,46.6626301943289],[-69.2349856026028,46.6630875274683],[-69.2353518029427,46.663589993984],[-69.2354856697272,46.6641613278839],[-69.2357848696753,46.6643667941931],[-69.2362164696137,46.664366327445],[-69.236847003186,46.6641599941893],[-69.2374438031883,46.6637707271383],[-69.2376754694467,46.6634275944089],[-69.237541269913,46.6627877276724],[-69.2372414692177,46.6623079942195],[-69.2368756699755,46.6620111945619],[-69.2363110027499,46.6618517942258],[-69.2360122695499,46.6618521944242],[-69.2352824697095,46.6621271945153]],[[-69.2364458030307,46.6628803272662],[-69.2367118692567,46.6631085940872],[-69.2365794692664,46.6632915944325],[-69.2361148696049,46.6633835276286],[-69.2359154692228,46.6632923273799],[-69.2359150699239,46.6631093944839],[-69.2364458030307,46.6628803272662]]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Polygon with hole: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 70
      -- Check 2D Multipoint
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2005
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1
                 ,1
                 ,3
                 ,1
                 ,1
                 ,5
                 ,1
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -72.45454
                 ,42.23232
                 ,-71.78787
                 ,42.989898
                 ,-71.334455
                 ,42.515151
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"MultiPoint","coordinates":[[-72.45454,42.23232],[-71.78787,42.989898],[-71.334455,42.515151]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D MultiPoint: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 80
      -- Check 2D MultiLinestring
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2006
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,2
                 ,1
                 ,5
                 ,2
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -78.3466269890437
                 ,38.83615220656
                 ,-78.3475923887771
                 ,38.8354434067887
                 ,-71.1501673996052
                 ,43.0729051996162
                 ,-71.150759800124
                 ,43.0725619994377
                 ,-71.1507907997549
                 ,43.0723791330914
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"MultiLineString","coordinates":[[[-78.3466269890437,38.83615220656],[-78.3475923887771,38.8354434067887]],[[-71.1501673996052,43.0729051996162],[-71.150759800124,43.0725619994377],[-71.1507907997549,43.0723791330914]]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D MultiLineString: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 90
      -- Check 2D MultiPolygon
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2007
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1003
                 ,1
                 ,71
                 ,1003
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  -87.0000061752442
                 ,38.7082849396991
                 ,-87.0000061752442
                 ,38.7095630067283
                 ,-87.0007041085071
                 ,38.7095636731259
                 ,-87.0012883090076
                 ,38.709724606806
                 ,-87.0015215751599
                 ,38.7099536731244
                 ,-87.0022805750878
                 ,38.7102750062874
                 ,-87.0024263749766
                 ,38.7104582728319
                 ,-87.0023967755901
                 ,38.7106642067886
                 ,-87.0026301757414
                 ,38.7108246728213
                 ,-87.0032729086172
                 ,38.7108254066681
                 ,-87.0036231756684
                 ,38.7110088728621
                 ,-87.0036221090724
                 ,38.7116726732561
                 ,-87.0044399084744
                 ,38.7118566061983
                 ,-87.0047893751289
                 ,38.7124064067312
                 ,-87.005256908379
                 ,38.7124068069295
                 ,-87.0062807757366
                 ,38.7115608731367
                 ,-87.006397708287
                 ,38.7115610736855
                 ,-87.0065151084848
                 ,38.7112178069571
                 ,-87.0063401085085
                 ,38.7110344729634
                 ,-87.0060783752162
                 ,38.7102788733722
                 ,-87.0054359750895
                 ,38.7101408733035
                 ,-87.004706375798
                 ,38.709613673633
                 ,-87.0035383749953
                 ,38.7093378065954
                 ,-87.0030133085168
                 ,38.7089022730224
                 ,-87.0025461089152
                 ,38.708695806667
                 ,-87.0024879758388
                 ,38.7085354728347
                 ,-87.001932908876
                 ,38.7085120733744
                 ,-87.0015533751875
                 ,38.7083972065667
                 ,-87.0008825088201
                 ,38.7077556068367
                 ,-87.0005905753941
                 ,38.7076638067402
                 ,-87.0004733757451
                 ,38.7078696066979
                 ,-87.0006771090607
                 ,38.7083276736841
                 ,-87.0002681090853
                 ,38.708327206936
                 ,-87.0000061752442
                 ,38.7082354068394
                 ,-87.0000061752442
                 ,38.7082849396991
                 ,-87.0000061752442
                 ,38.7095630067283
                 ,-86.9995977751166
                 ,38.7080756063051
                 ,-86.9994811087655
                 ,38.7080986064664
                 ,-86.9994523754261
                 ,38.7084420062944
                 ,-86.9996279752502
                 ,38.7086478062521
                 ,-86.9997459752959
                 ,38.7093114735466
                 ,-87.0000061752442
                 ,38.7095630067283
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"MultiPolygon","coordinates":[[[[-87.0000061752442,38.7082849396991],[-87.0000061752442,38.7095630067283],[-87.0007041085071,38.7095636731259],[-87.0012883090076,38.709724606806],[-87.0015215751599,38.7099536731244],[-87.0022805750878,38.7102750062874],[-87.0024263749766,38.7104582728319],[-87.0023967755901,38.7106642067886],[-87.0026301757414,38.7108246728213],[-87.0032729086172,38.7108254066681],[-87.0036231756684,38.7110088728621],[-87.0036221090724,38.7116726732561],[-87.0044399084744,38.7118566061983],[-87.0047893751289,38.7124064067312],[-87.005256908379,38.7124068069295],[-87.0062807757366,38.7115608731367],[-87.006397708287,38.7115610736855],[-87.0065151084848,38.7112178069571],[-87.0063401085085,38.7110344729634],[-87.0060783752162,38.7102788733722],[-87.0054359750895,38.7101408733035],[-87.004706375798,38.709613673633],[-87.0035383749953,38.7093378065954],[-87.0030133085168,38.7089022730224],[-87.0025461089152,38.708695806667],[-87.0024879758388,38.7085354728347],[-87.001932908876,38.7085120733744],[-87.0015533751875,38.7083972065667],[-87.0008825088201,38.7077556068367],[-87.0005905753941,38.7076638067402],[-87.0004733757451,38.7078696066979],[-87.0006771090607,38.7083276736841],[-87.0002681090853,38.708327206936],[-87.0000061752442,38.7082354068394],[-87.0000061752442,38.7082849396991]]],[[[-87.0000061752442,38.7095630067283],[-86.9995977751166,38.7080756063051],[-86.9994811087655,38.7080986064664],[-86.9994523754261,38.7084420062944],[-86.9996279752502,38.7086478062521],[-86.9997459752959,38.7093114735466],[-87.0000061752442,38.7095630067283]]]]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D MultiPolygon: ' || num_test);
      
      --------------------------------------------------------------------------
      -- Step 100
      -- Check 2D Collection
      --------------------------------------------------------------------------
      clb_results := dz_json_main.sdo2geojson(
          p_input => MDSYS.SDO_GEOMETRY(
              2004
             ,8265
             ,NULL
             ,MDSYS.SDO_ELEM_INFO_ARRAY(
                  1
                 ,1
                 ,1
                 ,3
                 ,2
                 ,1
                 ,7
                 ,1003
                 ,1
                 ,17
                 ,2003
                 ,1
              )
             ,MDSYS.SDO_ORDINATE_ARRAY(
                  4
                 ,6
                 ,4
                 ,6
                 ,7
                 ,10
                 ,3
                 ,10
                 ,45
                 ,45
                 ,15
                 ,40
                 ,10
                 ,20
                 ,35
                 ,10
                 ,20
                 ,30
                 ,35
                 ,35
                 ,30
                 ,20
                 ,20
                 ,30
              )
          )
         ,p_pretty_print => NULL
      );
      
      IF clb_results = '{"type":"GeometryCollection","geometries":[{"type":"Point","coordinates":[4,6]},{"type":"LineString","coordinates":[[4,6],[7,10]]},{"type":"Polygon","coordinates":[[[3,10],[45,45],[15,40],[10,20],[35,10]],[[20,30],[35,35],[30,20],[20,30]]]}]}'
      THEN
         num_test := 0;
      
      ELSE
         num_test := 1;
            
      END IF;
      
      num_results := num_results + num_test;
      dbms_output.put_line('Check 2D Collection: ' || num_test);
      
      RETURN num_results;
      
   END inmemory_test;
   
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   FUNCTION scratch_test
   RETURN NUMBER
   AS
   BEGIN
      RETURN 0;
      
   END scratch_test;

END dz_json_test;
/

