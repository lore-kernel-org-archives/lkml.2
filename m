Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2A0Of5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599Ab2A0Ofk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:35:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 9/9] perf, tool: Add support to specify pmu style event
Date: Fri, 27 Jan 2012 15:34:28 +0100
Message-Id: <1327674868-10486-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327674868-10486-1-git-send-email-jolsa@redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added new event rule to the event definition grammar:

event_def: event_pmu |
           ...
event_pmu: PE_NAME '/' event_config '/'

Using this rule, event could be now specified like:
  cpu/config=1,config1=2,config2=3/u

where pmu name 'cpu' is looked up via following path:
  ${sysfs_mount}/bus/event_source/devices/${pmu}

and config options are bound to the pmu's format definiton:
  ${sysfs_mount}/bus/event_source/devices/${pmu}/format

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c            |   18 ++++
 tools/perf/util/parse-events-bison.c |  187 ++++++++++++++++++----------------
 tools/perf/util/parse-events.c       |   19 ++++
 tools/perf/util/parse-events.h       |    2 +
 tools/perf/util/parse-events.y       |   10 ++-
 5 files changed, 149 insertions(+), 87 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1969d3f..ecfbf20 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -873,6 +873,20 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_genhw(evlist);
 }
 
+static int test__checkevent_pmu(struct perf_evlist *evlist)
+{
+
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 2 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config2);
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -954,6 +968,10 @@ static struct test__event_st {
 		.name  = "L1-dcache-load-miss:kp",
 		.check = test__checkevent_genhw_modifier,
 	},
+	{
+		.name  = "cpu/config=1,config1=2,config2=3/u",
+		.check = test__checkevent_pmu,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index 32adc40..d3f4e62 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -380,18 +380,18 @@ union yyalloc
 #endif
 
 /* YYFINAL -- State number of the termination state.  */
-#define YYFINAL  23
+#define YYFINAL  25
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   35
+#define YYLAST   43
 
 /* YYNTOKENS -- Number of terminals.  */
 #define YYNTOKENS  19
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  14
+#define YYNNTS  15
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  30
+#define YYNRULES  32
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  50
+#define YYNSTATES  54
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -437,34 +437,34 @@ static const yytype_uint8 yytranslate[] =
    YYRHS.  */
 static const yytype_uint8 yyprhs[] =
 {
-       0,     0,     3,     7,     9,    12,    14,    16,    19,    21,
-      24,    27,    30,    35,    38,    44,    48,    50,    56,    60,
-      64,    68,    70,    74,    76,    80,    84,    86,    87,    89,
-      91
+       0,     0,     3,     7,     9,    12,    14,    16,    18,    21,
+      23,    26,    29,    32,    37,    42,    45,    51,    55,    57,
+      63,    67,    71,    75,    77,    81,    83,    87,    91,    93,
+      94,    96,    98
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
       20,     0,    -1,    20,    14,    21,    -1,    21,    -1,    22,
-       7,    -1,    22,    -1,    23,    -1,    24,    31,    -1,    25,
-      -1,    26,    31,    -1,    27,    31,    -1,    28,    31,    -1,
-       4,    15,    29,    15,    -1,     4,    32,    -1,     9,    16,
-      10,    16,    10,    -1,     9,    16,    10,    -1,     9,    -1,
-      11,     3,    17,     8,    31,    -1,    11,     3,    31,    -1,
-       6,    17,     6,    -1,     3,    17,     3,    -1,     5,    -1,
-      29,    14,    30,    -1,    30,    -1,     6,    18,     6,    -1,
-       6,    18,     3,    -1,    17,    -1,    -1,    15,    -1,    17,
-      -1,    -1
+       7,    -1,    22,    -1,    23,    -1,    24,    -1,    25,    32,
+      -1,    26,    -1,    27,    32,    -1,    28,    32,    -1,    29,
+      32,    -1,     6,    15,    30,    15,    -1,     4,    15,    30,
+      15,    -1,     4,    33,    -1,     9,    16,    10,    16,    10,
+      -1,     9,    16,    10,    -1,     9,    -1,    11,     3,    17,
+       8,    32,    -1,    11,     3,    32,    -1,     6,    17,     6,
+      -1,     3,    17,     3,    -1,     5,    -1,    30,    14,    31,
+      -1,    31,    -1,     6,    18,     6,    -1,     6,    18,     3,
+      -1,    17,    -1,    -1,    15,    -1,    17,    -1,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
        0,    53,    53,    53,    56,    61,    63,    64,    65,    66,
-      67,    68,    71,    80,    89,    94,    99,   105,   110,   116,
-     122,   128,   134,   144,   156,   165,   174,   174,   176,   176,
-     176
+      67,    68,    69,    72,    79,    88,    97,   102,   107,   113,
+     118,   124,   130,   136,   142,   152,   164,   173,   182,   182,
+     184,   184,   184
 };
 #endif
 
@@ -477,7 +477,7 @@ static const char *const yytname[] =
   "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP", "PE_NAME_CACHE_TYPE",
   "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM", "PE_PREFIX_RAW", "PE_ERROR",
   "','", "'/'", "'-'", "':'", "'='", "$accept", "events", "event",
-  "event_def", "event_legacy_symbol", "event_legacy_cache",
+  "event_def", "event_pmu", "event_legacy_symbol", "event_legacy_cache",
   "event_legacy_mem", "event_legacy_tracepoint", "event_legacy_numeric",
   "event_legacy_raw", "event_config", "event_term", "sep_dc",
   "sep_slash_dc", 0
@@ -498,18 +498,18 @@ static const yytype_uint16 yytoknum[] =
 static const yytype_uint8 yyr1[] =
 {
        0,    19,    20,    20,    21,    21,    22,    22,    22,    22,
-      22,    22,    23,    23,    24,    24,    24,    25,    25,    26,
-      27,    28,    29,    29,    30,    30,    31,    31,    32,    32,
-      32
+      22,    22,    22,    23,    24,    24,    25,    25,    25,    26,
+      26,    27,    28,    29,    30,    30,    31,    31,    32,    32,
+      33,    33,    33
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     3,     1,     2,     1,     1,     2,     1,     2,
-       2,     2,     4,     2,     5,     3,     1,     5,     3,     3,
-       3,     1,     3,     1,     3,     3,     1,     0,     1,     1,
-       0
+       0,     2,     3,     1,     2,     1,     1,     1,     2,     1,
+       2,     2,     2,     4,     4,     2,     5,     3,     1,     5,
+       3,     3,     3,     1,     3,     1,     3,     3,     1,     0,
+       1,     1,     0
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -517,37 +517,39 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,    30,    21,     0,    16,     0,     0,     3,     5,
-       6,    27,     8,    27,    27,    27,     0,    28,    29,    13,
-       0,     0,    27,     1,     0,     4,    26,     7,     9,    10,
-      11,    20,     0,     0,    23,    19,    15,    26,    18,     2,
-       0,     0,    12,     0,    27,    25,    24,    22,    14,    17
+       0,     0,    32,    23,     0,    18,     0,     0,     3,     5,
+       6,     7,    29,     9,    29,    29,    29,     0,    30,    31,
+      15,     0,     0,     0,    29,     1,     0,     4,    28,     8,
+      10,    11,    12,    22,     0,     0,    25,     0,    21,    17,
+      28,    20,     2,     0,     0,    14,    13,     0,    29,    27,
+      26,    24,    16,    19
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
       -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
-      33,    34,    27,    19
+      16,    35,    36,    29,    20
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -14
+#define YYPACT_NINF -15
 static const yytype_int8 yypact[] =
 {
-       1,    -3,    -2,   -14,    -1,     6,    17,     3,   -14,    14,
-     -14,     7,   -14,     7,     7,     7,    20,    19,   -14,   -14,
-      21,    16,    11,   -14,     1,   -14,   -14,   -14,   -14,   -14,
-     -14,   -14,    12,     4,   -14,   -14,    13,    24,   -14,   -14,
-       5,    19,   -14,    23,     7,   -14,   -14,   -14,   -14,   -14
+       2,   -13,    -1,   -15,     4,    11,    12,     3,   -15,    13,
+     -15,   -15,     1,   -15,     1,     1,     1,    23,    22,   -15,
+     -15,    22,    24,    19,    14,   -15,     2,   -15,   -15,   -15,
+     -15,   -15,   -15,   -15,    15,     8,   -15,    10,   -15,    16,
+      27,   -15,   -15,     6,    22,   -15,   -15,    26,     1,   -15,
+     -15,   -15,   -15,   -15
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -14,   -14,    10,   -14,   -14,   -14,   -14,   -14,   -14,   -14,
-     -14,    -6,   -13,   -14
+     -15,   -15,    17,   -15,   -15,   -15,   -15,   -15,   -15,   -15,
+     -15,    18,    -7,   -14,   -15
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -557,18 +559,20 @@ static const yytype_int8 yypgoto[] =
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
-      28,    29,    30,    23,     1,     2,     3,     4,    45,    38,
-       5,    46,     6,    17,    16,    18,    20,    24,    41,    42,
-      22,    25,    21,    31,    26,    32,    36,    35,    37,    43,
-      40,    49,    44,    48,    39,    47
+      30,    31,    32,    25,    17,     1,     2,     3,     4,    49,
+      41,     5,    50,     6,    18,    24,    19,    26,    28,    21,
+      27,    22,    44,    45,    44,    46,    33,    23,    34,    39,
+      38,    40,    47,    43,    53,    48,    52,    51,     0,    37,
+       0,     0,     0,    42
 };
 
-static const yytype_uint8 yycheck[] =
+static const yytype_int8 yycheck[] =
 {
-      13,    14,    15,     0,     3,     4,     5,     6,     3,    22,
-       9,     6,    11,    15,    17,    17,    17,    14,    14,    15,
-       3,     7,    16,     3,    17,     6,    10,     6,    17,    16,
-      18,    44,     8,    10,    24,    41
+      14,    15,    16,     0,    17,     3,     4,     5,     6,     3,
+      24,     9,     6,    11,    15,     3,    17,    14,    17,    15,
+       7,    17,    14,    15,    14,    15,     3,    16,     6,    10,
+       6,    17,    16,    18,    48,     8,    10,    44,    -1,    21,
+      -1,    -1,    -1,    26
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
@@ -576,10 +580,11 @@ static const yytype_uint8 yycheck[] =
 static const yytype_uint8 yystos[] =
 {
        0,     3,     4,     5,     6,     9,    11,    20,    21,    22,
-      23,    24,    25,    26,    27,    28,    17,    15,    17,    32,
-      17,    16,     3,     0,    14,     7,    17,    31,    31,    31,
-      31,     3,     6,    29,    30,     6,    10,    17,    31,    21,
-      18,    14,    15,    16,     8,     3,     6,    30,    10,    31
+      23,    24,    25,    26,    27,    28,    29,    17,    15,    17,
+      33,    15,    17,    16,     3,     0,    14,     7,    17,    32,
+      32,    32,    32,     3,     6,    30,    31,    30,     6,    10,
+      17,    32,    21,    18,    14,    15,    15,    16,     8,     3,
+       6,    31,    10,    32
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1421,10 +1426,20 @@ yyreduce:
 ;}
     break;
 
-  case 12:
+  case 13:
+
+/* Line 1464 of yacc.c  */
+#line 73 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_pmu(list, idx, (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].head)));
+	parse_events__free_terms((yyvsp[(3) - (4)].head));
+;}
+    break;
+
+  case 14:
 
 /* Line 1464 of yacc.c  */
-#line 72 "util/parse-events.y"
+#line 80 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (4)].num) >> 16;
 	int config = (yyvsp[(1) - (4)].num) & 255;
@@ -1434,10 +1449,10 @@ yyreduce:
 ;}
     break;
 
-  case 13:
+  case 15:
 
 /* Line 1464 of yacc.c  */
-#line 81 "util/parse-events.y"
+#line 89 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (2)].num) >> 16;
 	int config = (yyvsp[(1) - (2)].num) & 255;
@@ -1446,82 +1461,82 @@ yyreduce:
 ;}
     break;
 
-  case 14:
+  case 16:
 
 /* Line 1464 of yacc.c  */
-#line 90 "util/parse-events.y"
+#line 98 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
 ;}
     break;
 
-  case 15:
+  case 17:
 
 /* Line 1464 of yacc.c  */
-#line 95 "util/parse-events.y"
+#line 103 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
 ;}
     break;
 
-  case 16:
+  case 18:
 
 /* Line 1464 of yacc.c  */
-#line 100 "util/parse-events.y"
+#line 108 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
 ;}
     break;
 
-  case 17:
+  case 19:
 
 /* Line 1464 of yacc.c  */
-#line 106 "util/parse-events.y"
+#line 114 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
 ;}
     break;
 
-  case 18:
+  case 20:
 
 /* Line 1464 of yacc.c  */
-#line 111 "util/parse-events.y"
+#line 119 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
 ;}
     break;
 
-  case 19:
+  case 21:
 
 /* Line 1464 of yacc.c  */
-#line 117 "util/parse-events.y"
+#line 125 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
 ;}
     break;
 
-  case 20:
+  case 22:
 
 /* Line 1464 of yacc.c  */
-#line 123 "util/parse-events.y"
+#line 131 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
 ;}
     break;
 
-  case 21:
+  case 23:
 
 /* Line 1464 of yacc.c  */
-#line 129 "util/parse-events.y"
+#line 137 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
 ;}
     break;
 
-  case 22:
+  case 24:
 
 /* Line 1464 of yacc.c  */
-#line 135 "util/parse-events.y"
+#line 143 "util/parse-events.y"
     {
 	struct list_head *head = (yyvsp[(1) - (3)].head);
 	struct parse_events__term *term = (yyvsp[(3) - (3)].term);
@@ -1532,10 +1547,10 @@ yyreduce:
 ;}
     break;
 
-  case 23:
+  case 25:
 
 /* Line 1464 of yacc.c  */
-#line 145 "util/parse-events.y"
+#line 153 "util/parse-events.y"
     {
 	struct list_head *head = malloc(sizeof(*head));
 	struct parse_events__term *term = (yyvsp[(1) - (1)].term);
@@ -1547,10 +1562,10 @@ yyreduce:
 ;}
     break;
 
-  case 24:
+  case 26:
 
 /* Line 1464 of yacc.c  */
-#line 157 "util/parse-events.y"
+#line 165 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1560,10 +1575,10 @@ yyreduce:
 ;}
     break;
 
-  case 25:
+  case 27:
 
 /* Line 1464 of yacc.c  */
-#line 166 "util/parse-events.y"
+#line 174 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1576,7 +1591,7 @@ yyreduce:
 
 
 /* Line 1464 of yacc.c  */
-#line 1580 "util/parse-events-bison.c"
+#line 1595 "util/parse-events-bison.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -1788,7 +1803,7 @@ yyreturn:
 
 
 /* Line 1684 of yacc.c  */
-#line 178 "util/parse-events.y"
+#line 186 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7423049..cce8b7a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,7 @@
 #include "header.h"
 #include "debugfs.h"
 #include "parse-events-flex.h"
+#include "pmu.h"
 
 #define MAX_NAME_LEN 100
 
@@ -632,6 +633,24 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 			 (char *) __event_name(type, config));
 }
 
+int parse_events_add_pmu(struct list_head *list, int *idx,
+			 char *name, struct list_head *head_config)
+{
+	struct perf_event_attr attr;
+	struct perf_pmu *pmu;
+
+	pmu = perf_pmu__find(name);
+	if (!pmu)
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+
+	if (perf_pmu__config(pmu, &attr, head_config))
+		return -EINVAL;
+
+	return add_event(list, idx, &attr, (char *) "pmu");
+}
+
 int parse_events_modifier(struct list_head *list, char *str)
 {
 	struct perf_evsel *evsel;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2737f1e..0ebc68c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -65,6 +65,8 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
+int parse_events_add_pmu(struct list_head *list, int *idx,
+			 char *pmu , struct list_head *head_config);
 void parse_events_error(struct list_head *list, int *idx,
 			char const *msg);
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 0be12dc..588f115 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -60,13 +60,21 @@ event_def PE_MODIFIER_EVENT
 |
 event_def
 
-event_def: event_legacy_symbol |
+event_def: event_pmu |
+	   event_legacy_symbol |
 	   event_legacy_cache sep_dc |
 	   event_legacy_mem |
 	   event_legacy_tracepoint sep_dc |
 	   event_legacy_numeric sep_dc |
 	   event_legacy_raw sep_dc
 
+event_pmu:
+PE_NAME '/' event_config '/'
+{
+	ABORT_ON(parse_events_add_pmu(list, idx, $1, $3));
+	parse_events__free_terms($3);
+}
+
 event_legacy_symbol:
 PE_VALUE_SYM '/' event_config '/'
 {
-- 
1.7.4.4

