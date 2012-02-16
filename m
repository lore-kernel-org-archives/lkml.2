Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2BPMBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:01:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab2BPMBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:35 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/8] perf, tool: Add support to specify pmu style event
Date: Thu, 16 Feb 2012 13:00:52 +0100
Message-Id: <1329393652-6055-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
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

The hardcoded config options still stays and have precedence
over any format field defined with same name.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c            |   20 ++++
 tools/perf/util/parse-events-bison.c |  209 ++++++++++++++++++----------------
 tools/perf/util/parse-events.c       |   31 +++++-
 tools/perf/util/parse-events.h       |    2 +
 tools/perf/util/parse-events.y       |   10 ++-
 5 files changed, 172 insertions(+), 100 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index fc7172e..9000268 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -877,6 +877,22 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
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
+	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
+
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -958,6 +974,10 @@ static struct test__event_st {
 		.name  = "L1-dcache-load-miss:kp",
 		.check = test__checkevent_genhw_modifier,
 	},
+	{
+		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
+		.check = test__checkevent_pmu,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index ace593a..4a0fd6d 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -381,18 +381,18 @@ union yyalloc
 #endif
 
 /* YYFINAL -- State number of the termination state.  */
-#define YYFINAL  23
+#define YYFINAL  25
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   38
+#define YYLAST   43
 
 /* YYNTOKENS -- Number of terminals.  */
 #define YYNTOKENS  20
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  14
+#define YYNNTS  15
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  33
+#define YYNRULES  35
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  53
+#define YYNSTATES  57
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -438,34 +438,35 @@ static const yytype_uint8 yytranslate[] =
    YYRHS.  */
 static const yytype_uint8 yyprhs[] =
 {
-       0,     0,     3,     7,     9,    12,    14,    16,    19,    21,
-      24,    27,    30,    35,    38,    44,    48,    50,    56,    60,
-      64,    68,    70,    74,    76,    80,    84,    86,    90,    92,
-      94,    95,    97,    99
+       0,     0,     3,     7,     9,    12,    14,    16,    18,    21,
+      23,    26,    29,    32,    37,    42,    45,    51,    55,    57,
+      63,    67,    71,    75,    77,    81,    83,    87,    91,    93,
+      97,    99,   101,   102,   104,   106
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
       21,     0,    -1,    21,    15,    22,    -1,    22,    -1,    23,
-       8,    -1,    23,    -1,    24,    -1,    25,    32,    -1,    26,
-      -1,    27,    32,    -1,    28,    32,    -1,    29,    32,    -1,
-       4,    16,    30,    16,    -1,     4,    33,    -1,    10,    17,
-      11,    17,    11,    -1,    10,    17,    11,    -1,    10,    -1,
-      12,     3,    18,     9,    32,    -1,    12,     3,    32,    -1,
-       7,    18,     7,    -1,     3,    18,     3,    -1,     5,    -1,
-      30,    15,    31,    -1,    31,    -1,     7,    19,     7,    -1,
-       7,    19,     3,    -1,     7,    -1,     6,    19,     3,    -1,
-       6,    -1,    18,    -1,    -1,    16,    -1,    18,    -1,    -1
+       8,    -1,    23,    -1,    24,    -1,    25,    -1,    26,    33,
+      -1,    27,    -1,    28,    33,    -1,    29,    33,    -1,    30,
+      33,    -1,     7,    16,    31,    16,    -1,     4,    16,    31,
+      16,    -1,     4,    34,    -1,    10,    17,    11,    17,    11,
+      -1,    10,    17,    11,    -1,    10,    -1,    12,     3,    18,
+       9,    33,    -1,    12,     3,    33,    -1,     7,    18,     7,
+      -1,     3,    18,     3,    -1,     5,    -1,    31,    15,    32,
+      -1,    32,    -1,     7,    19,     7,    -1,     7,    19,     3,
+      -1,     7,    -1,     6,    19,     3,    -1,     6,    -1,    18,
+      -1,    -1,    16,    -1,    18,    -1,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
        0,    54,    54,    54,    57,    62,    64,    65,    66,    67,
-      68,    69,    72,    81,    90,    95,   100,   106,   111,   117,
-     123,   129,   135,   145,   157,   166,   175,   184,   192,   200,
-     200,   202,   202,   202
+      68,    69,    70,    73,    80,    89,    98,   103,   108,   114,
+     119,   125,   131,   137,   143,   153,   165,   174,   183,   192,
+     200,   208,   208,   210,   210,   210
 };
 #endif
 
@@ -478,10 +479,10 @@ static const char *const yytname[] =
   "PE_TERM", "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP",
   "PE_NAME_CACHE_TYPE", "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM",
   "PE_PREFIX_RAW", "PE_ERROR", "','", "'/'", "'-'", "':'", "'='",
-  "$accept", "events", "event", "event_def", "event_legacy_symbol",
-  "event_legacy_cache", "event_legacy_mem", "event_legacy_tracepoint",
-  "event_legacy_numeric", "event_legacy_raw", "event_config", "event_term",
-  "sep_dc", "sep_slash_dc", 0
+  "$accept", "events", "event", "event_def", "event_pmu",
+  "event_legacy_symbol", "event_legacy_cache", "event_legacy_mem",
+  "event_legacy_tracepoint", "event_legacy_numeric", "event_legacy_raw",
+  "event_config", "event_term", "sep_dc", "sep_slash_dc", 0
 };
 #endif
 
@@ -499,18 +500,18 @@ static const yytype_uint16 yytoknum[] =
 static const yytype_uint8 yyr1[] =
 {
        0,    20,    21,    21,    22,    22,    23,    23,    23,    23,
-      23,    23,    24,    24,    25,    25,    25,    26,    26,    27,
-      28,    29,    30,    30,    31,    31,    31,    31,    31,    32,
-      32,    33,    33,    33
+      23,    23,    23,    24,    25,    25,    26,    26,    26,    27,
+      27,    28,    29,    30,    31,    31,    32,    32,    32,    32,
+      32,    33,    33,    34,    34,    34
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     3,     1,     2,     1,     1,     2,     1,     2,
-       2,     2,     4,     2,     5,     3,     1,     5,     3,     3,
-       3,     1,     3,     1,     3,     3,     1,     3,     1,     1,
-       0,     1,     1,     0
+       0,     2,     3,     1,     2,     1,     1,     1,     2,     1,
+       2,     2,     2,     4,     4,     2,     5,     3,     1,     5,
+       3,     3,     3,     1,     3,     1,     3,     3,     1,     3,
+       1,     1,     0,     1,     1,     0
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -518,39 +519,39 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,    33,    21,     0,    16,     0,     0,     3,     5,
-       6,    30,     8,    30,    30,    30,     0,    31,    32,    13,
-       0,     0,    30,     1,     0,     4,    29,     7,     9,    10,
-      11,    20,    28,    26,     0,    23,    19,    15,    29,    18,
-       2,     0,     0,     0,    12,     0,    30,    27,    25,    24,
-      22,    14,    17
+       0,     0,    35,    23,     0,    18,     0,     0,     3,     5,
+       6,     7,    32,     9,    32,    32,    32,     0,    33,    34,
+      15,     0,     0,     0,    32,     1,     0,     4,    31,     8,
+      10,    11,    12,    22,    30,    28,     0,    25,     0,    21,
+      17,    31,    20,     2,     0,     0,     0,    14,    13,     0,
+      32,    29,    27,    26,    24,    16,    19
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
       -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
-      34,    35,    27,    19
+      16,    36,    37,    29,    20
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -14
+#define YYPACT_NINF -15
 static const yytype_int8 yypact[] =
 {
-       1,   -11,    -1,   -14,    -6,     8,    20,     3,   -14,    16,
-     -14,    -2,   -14,    -2,    -2,    -2,    23,    13,   -14,   -14,
-      21,    18,     9,   -14,     1,   -14,   -14,   -14,   -14,   -14,
-     -14,   -14,    11,    12,     6,   -14,   -14,    15,    25,   -14,
-     -14,    32,     7,    13,   -14,    26,    -2,   -14,   -14,   -14,
-     -14,   -14,   -14
+       1,    -4,    -9,   -15,    -1,    10,    22,     3,   -15,    18,
+     -15,   -15,    11,   -15,    11,    11,    11,    25,    13,   -15,
+     -15,    13,    23,    20,    14,   -15,     1,   -15,   -15,   -15,
+     -15,   -15,   -15,   -15,    15,    16,     6,   -15,     8,   -15,
+      21,    24,   -15,   -15,    34,     9,    13,   -15,   -15,    28,
+      11,   -15,   -15,   -15,   -15,   -15,   -15
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -14,   -14,    14,   -14,   -14,   -14,   -14,   -14,   -14,   -14,
-     -14,    -7,   -13,   -14
+     -15,   -15,    17,   -15,   -15,   -15,   -15,   -15,   -15,   -15,
+     -15,    19,    -5,   -14,   -15
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -560,18 +561,20 @@ static const yytype_int8 yypgoto[] =
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
-      28,    29,    30,    23,     1,     2,     3,    16,     4,    39,
-      48,     5,    20,     6,    49,    17,    26,    18,    24,    32,
-      33,    43,    44,    22,    25,    21,    31,    38,    36,    37,
-      41,    42,    45,    52,    46,    47,    50,    51,    40
+      30,    31,    32,    25,     1,     2,     3,    18,     4,    19,
+      42,     5,    52,     6,    17,    21,    53,    22,    26,    34,
+      35,    46,    47,    46,    48,    24,    27,    23,    33,    28,
+      39,    40,    41,    50,    44,    45,    56,    51,    49,    55,
+      38,    54,     0,    43
 };
 
-static const yytype_uint8 yycheck[] =
+static const yytype_int8 yycheck[] =
 {
-      13,    14,    15,     0,     3,     4,     5,    18,     7,    22,
-       3,    10,    18,    12,     7,    16,    18,    18,    15,     6,
-       7,    15,    16,     3,     8,    17,     3,    18,     7,    11,
-      19,    19,    17,    46,     9,     3,    43,    11,    24
+      14,    15,    16,     0,     3,     4,     5,    16,     7,    18,
+      24,    10,     3,    12,    18,    16,     7,    18,    15,     6,
+       7,    15,    16,    15,    16,     3,     8,    17,     3,    18,
+       7,    11,    18,     9,    19,    19,    50,     3,    17,    11,
+      21,    46,    -1,    26
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
@@ -579,11 +582,11 @@ static const yytype_uint8 yycheck[] =
 static const yytype_uint8 yystos[] =
 {
        0,     3,     4,     5,     7,    10,    12,    21,    22,    23,
-      24,    25,    26,    27,    28,    29,    18,    16,    18,    33,
-      18,    17,     3,     0,    15,     8,    18,    32,    32,    32,
-      32,     3,     6,     7,    30,    31,     7,    11,    18,    32,
-      22,    19,    19,    15,    16,    17,     9,     3,     3,     7,
-      31,    11,    32
+      24,    25,    26,    27,    28,    29,    30,    18,    16,    18,
+      34,    16,    18,    17,     3,     0,    15,     8,    18,    33,
+      33,    33,    33,     3,     6,     7,    31,    32,    31,     7,
+      11,    18,    33,    22,    19,    19,    15,    16,    16,    17,
+       9,     3,     3,     7,    32,    11,    33
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1425,10 +1428,20 @@ yyreduce:
 ;}
     break;
 
-  case 12:
+  case 13:
 
 /* Line 1464 of yacc.c  */
-#line 73 "util/parse-events.y"
+#line 74 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_pmu(list, idx, (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].head)));
+	parse_events__free_terms((yyvsp[(3) - (4)].head));
+;}
+    break;
+
+  case 14:
+
+/* Line 1464 of yacc.c  */
+#line 81 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (4)].num) >> 16;
 	int config = (yyvsp[(1) - (4)].num) & 255;
@@ -1438,10 +1451,10 @@ yyreduce:
 ;}
     break;
 
-  case 13:
+  case 15:
 
 /* Line 1464 of yacc.c  */
-#line 82 "util/parse-events.y"
+#line 90 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (2)].num) >> 16;
 	int config = (yyvsp[(1) - (2)].num) & 255;
@@ -1450,82 +1463,82 @@ yyreduce:
 ;}
     break;
 
-  case 14:
+  case 16:
 
 /* Line 1464 of yacc.c  */
-#line 91 "util/parse-events.y"
+#line 99 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
 ;}
     break;
 
-  case 15:
+  case 17:
 
 /* Line 1464 of yacc.c  */
-#line 96 "util/parse-events.y"
+#line 104 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
 ;}
     break;
 
-  case 16:
+  case 18:
 
 /* Line 1464 of yacc.c  */
-#line 101 "util/parse-events.y"
+#line 109 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
 ;}
     break;
 
-  case 17:
+  case 19:
 
 /* Line 1464 of yacc.c  */
-#line 107 "util/parse-events.y"
+#line 115 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
 ;}
     break;
 
-  case 18:
+  case 20:
 
 /* Line 1464 of yacc.c  */
-#line 112 "util/parse-events.y"
+#line 120 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
 ;}
     break;
 
-  case 19:
+  case 21:
 
 /* Line 1464 of yacc.c  */
-#line 118 "util/parse-events.y"
+#line 126 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
 ;}
     break;
 
-  case 20:
+  case 22:
 
 /* Line 1464 of yacc.c  */
-#line 124 "util/parse-events.y"
+#line 132 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
 ;}
     break;
 
-  case 21:
+  case 23:
 
 /* Line 1464 of yacc.c  */
-#line 130 "util/parse-events.y"
+#line 138 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
 ;}
     break;
 
-  case 22:
+  case 24:
 
 /* Line 1464 of yacc.c  */
-#line 136 "util/parse-events.y"
+#line 144 "util/parse-events.y"
     {
 	struct list_head *head = (yyvsp[(1) - (3)].head);
 	struct parse_events__term *term = (yyvsp[(3) - (3)].term);
@@ -1536,10 +1549,10 @@ yyreduce:
 ;}
     break;
 
-  case 23:
+  case 25:
 
 /* Line 1464 of yacc.c  */
-#line 146 "util/parse-events.y"
+#line 154 "util/parse-events.y"
     {
 	struct list_head *head = malloc(sizeof(*head));
 	struct parse_events__term *term = (yyvsp[(1) - (1)].term);
@@ -1551,10 +1564,10 @@ yyreduce:
 ;}
     break;
 
-  case 24:
+  case 26:
 
 /* Line 1464 of yacc.c  */
-#line 158 "util/parse-events.y"
+#line 166 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1564,10 +1577,10 @@ yyreduce:
 ;}
     break;
 
-  case 25:
+  case 27:
 
 /* Line 1464 of yacc.c  */
-#line 167 "util/parse-events.y"
+#line 175 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1577,10 +1590,10 @@ yyreduce:
 ;}
     break;
 
-  case 26:
+  case 28:
 
 /* Line 1464 of yacc.c  */
-#line 176 "util/parse-events.y"
+#line 184 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1590,10 +1603,10 @@ yyreduce:
 ;}
     break;
 
-  case 27:
+  case 29:
 
 /* Line 1464 of yacc.c  */
-#line 185 "util/parse-events.y"
+#line 193 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1602,10 +1615,10 @@ yyreduce:
 ;}
     break;
 
-  case 28:
+  case 30:
 
 /* Line 1464 of yacc.c  */
-#line 193 "util/parse-events.y"
+#line 201 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
@@ -1617,7 +1630,7 @@ yyreduce:
 
 
 /* Line 1464 of yacc.c  */
-#line 1621 "util/parse-events-bison.c"
+#line 1634 "util/parse-events-bison.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -1829,7 +1842,7 @@ yyreturn:
 
 
 /* Line 1684 of yacc.c  */
-#line 204 "util/parse-events.y"
+#line 212 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 59f5cf6..bec1cc6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,7 @@
 #include "header.h"
 #include "debugfs.h"
 #include "parse-events-flex.h"
+#include "pmu.h"
 
 #define MAX_NAME_LEN 100
 
@@ -646,6 +647,30 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
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
+	/*
+	 * Configure hardcoded terms first, no need to check
+	 * return value when called with fail == 0 ;)
+	 */
+	config_attr(&attr, head_config, 0);
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
@@ -957,8 +982,12 @@ void print_events(const char *event_glob)
 
 	printf("\n");
 	printf("  %-50s [%s]\n",
-		"rNNN (see 'perf list --help' on how to encode it)",
+	       "rNNN",
+	       event_type_descriptors[PERF_TYPE_RAW]);
+	printf("  %-50s [%s]\n",
+	       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
 	       event_type_descriptors[PERF_TYPE_RAW]);
+	printf("   (see 'perf list --help' on how to encode it)\n");
 	printf("\n");
 
 	printf("  %-50s [%s]\n",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 37a270d..6d7c74b 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -74,6 +74,8 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
+int parse_events_add_pmu(struct list_head *list, int *idx,
+			 char *pmu , struct list_head *head_config);
 void parse_events_error(struct list_head *list, int *idx,
 			char const *msg);
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index c88c08e..3a53019 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -61,13 +61,21 @@ event_def PE_MODIFIER_EVENT
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

