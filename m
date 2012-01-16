Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2APMdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:33:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab2APMcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:32:39 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/9] perf, tool: Add config options support for event parsing
Date: Mon, 16 Jan 2012 13:31:41 +0100
Message-Id: <1326717103-10287-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a new rule to the event grammar to be able to specify
values of additional attributes of symbolic event.

The new syntax for event symbolic definition is:

event_legacy_symbol:  PE_NAME_SYM '/' event_config '/' |
                      PE_NAME_SYM sep_slash_dc

event_config:         event_config ',' event_term | event_term

event_term:           PE_NAME '=' PE_NAME |
                      PE_NAME '=' PE_VALUE

sep_slash_dc:         '/' | ':' |

At the moment the code is recognizing only 'period' config
option, which modifies value sample_period event attribute.

Use is now allowed to specify events like:
  cycles/period=100000/

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c            |   18 +++
 tools/perf/util/parse-events-bison.c |  245 +++++++++++++++++++++++-----------
 tools/perf/util/parse-events-bison.h |    6 +-
 tools/perf/util/parse-events.c       |   75 ++++++++++-
 tools/perf/util/parse-events.h       |   22 +++-
 tools/perf/util/parse-events.y       |   66 +++++++++-
 6 files changed, 340 insertions(+), 92 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1fbba0a..081cad7 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -677,6 +677,20 @@ static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong period",
+			100000 == evsel->attr.sample_period);
+	return 0;
+}
+
 static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -884,6 +898,10 @@ static struct test__event_st {
 		.check = test__checkevent_symbolic_name,
 	},
 	{
+		.name  = "cycles/period=100000/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	{
 		.name  = "faults",
 		.check = test__checkevent_symbolic_alias,
 	},
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index 20fca26..32adc40 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -145,15 +145,17 @@ typedef union YYSTYPE
 {
 
 /* Line 214 of yacc.c  */
-#line 42 "util/parse-events.y"
+#line 44 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
 
 
 
 /* Line 214 of yacc.c  */
-#line 157 "util/parse-events-bison.c"
+#line 159 "util/parse-events-bison.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -165,7 +167,7 @@ typedef union YYSTYPE
 
 
 /* Line 264 of yacc.c  */
-#line 169 "util/parse-events-bison.c"
+#line 171 "util/parse-events-bison.c"
 
 #ifdef short
 # undef short
@@ -378,18 +380,18 @@ union yyalloc
 #endif
 
 /* YYFINAL -- State number of the termination state.  */
-#define YYFINAL  20
+#define YYFINAL  23
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   27
+#define YYLAST   35
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  17
+#define YYNTOKENS  19
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  11
+#define YYNNTS  14
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  22
+#define YYNRULES  30
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  39
+#define YYNSTATES  50
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -405,9 +407,9 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,     2,     2,     2,    14,    15,     2,     2,     2,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,    16,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,    14,    16,     2,    15,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,    17,     2,
+       2,    18,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
@@ -435,29 +437,34 @@ static const yytype_uint8 yytranslate[] =
    YYRHS.  */
 static const yytype_uint8 yyprhs[] =
 {
-       0,     0,     3,     7,     9,    12,    14,    17,    20,    22,
-      25,    28,    31,    33,    39,    43,    45,    51,    55,    59,
-      63,    65,    67
+       0,     0,     3,     7,     9,    12,    14,    16,    19,    21,
+      24,    27,    30,    35,    38,    44,    48,    50,    56,    60,
+      64,    68,    70,    74,    76,    80,    84,    86,    87,    89,
+      91
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      18,     0,    -1,    18,    14,    19,    -1,    19,    -1,    20,
-       7,    -1,    20,    -1,    21,    27,    -1,    22,    27,    -1,
-      23,    -1,    24,    27,    -1,    25,    27,    -1,    26,    27,
-      -1,     4,    -1,     9,    15,    10,    15,    10,    -1,     9,
-      15,    10,    -1,     9,    -1,    11,     3,    16,     8,    27,
-      -1,    11,     3,    27,    -1,     6,    16,     6,    -1,     3,
-      16,     3,    -1,     5,    -1,    16,    -1,    -1
+      20,     0,    -1,    20,    14,    21,    -1,    21,    -1,    22,
+       7,    -1,    22,    -1,    23,    -1,    24,    31,    -1,    25,
+      -1,    26,    31,    -1,    27,    31,    -1,    28,    31,    -1,
+       4,    15,    29,    15,    -1,     4,    32,    -1,     9,    16,
+      10,    16,    10,    -1,     9,    16,    10,    -1,     9,    -1,
+      11,     3,    17,     8,    31,    -1,    11,     3,    31,    -1,
+       6,    17,     6,    -1,     3,    17,     3,    -1,     5,    -1,
+      29,    14,    30,    -1,    30,    -1,     6,    18,     6,    -1,
+       6,    18,     3,    -1,    17,    -1,    -1,    15,    -1,    17,
+      -1,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
-       0,    49,    49,    49,    52,    57,    59,    60,    61,    62,
-      63,    64,    67,    76,    81,    86,    92,    97,   103,   109,
-     115,   120,   120
+       0,    53,    53,    53,    56,    61,    63,    64,    65,    66,
+      67,    68,    71,    80,    89,    94,    99,   105,   110,   116,
+     122,   128,   134,   144,   156,   165,   174,   174,   176,   176,
+     176
 };
 #endif
 
@@ -469,10 +476,11 @@ static const char *const yytname[] =
   "$end", "error", "$undefined", "PE_VALUE", "PE_VALUE_SYM", "PE_RAW",
   "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP", "PE_NAME_CACHE_TYPE",
   "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM", "PE_PREFIX_RAW", "PE_ERROR",
-  "','", "'-'", "':'", "$accept", "events", "event", "event_def",
-  "event_legacy_symbol", "event_legacy_cache", "event_legacy_mem",
-  "event_legacy_tracepoint", "event_legacy_numeric", "event_legacy_raw",
-  "sep_dc", 0
+  "','", "'/'", "'-'", "':'", "'='", "$accept", "events", "event",
+  "event_def", "event_legacy_symbol", "event_legacy_cache",
+  "event_legacy_mem", "event_legacy_tracepoint", "event_legacy_numeric",
+  "event_legacy_raw", "event_config", "event_term", "sep_dc",
+  "sep_slash_dc", 0
 };
 #endif
 
@@ -482,24 +490,26 @@ static const char *const yytname[] =
 static const yytype_uint16 yytoknum[] =
 {
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
-     265,   266,   267,   268,    44,    45,    58
+     265,   266,   267,   268,    44,    47,    45,    58,    61
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    17,    18,    18,    19,    19,    20,    20,    20,    20,
-      20,    20,    21,    22,    22,    22,    23,    23,    24,    25,
-      26,    27,    27
+       0,    19,    20,    20,    21,    21,    22,    22,    22,    22,
+      22,    22,    23,    23,    24,    24,    24,    25,    25,    26,
+      27,    28,    29,    29,    30,    30,    31,    31,    32,    32,
+      32
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     3,     1,     2,     1,     2,     2,     1,     2,
-       2,     2,     1,     5,     3,     1,     5,     3,     3,     3,
-       1,     1,     0
+       0,     2,     3,     1,     2,     1,     1,     2,     1,     2,
+       2,     2,     4,     2,     5,     3,     1,     5,     3,     3,
+       3,     1,     3,     1,     3,     3,     1,     0,     1,     1,
+       0
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -507,35 +517,37 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,    12,    20,     0,    15,     0,     0,     3,     5,
-      22,    22,     8,    22,    22,    22,     0,     0,     0,    22,
-       1,     0,     4,    21,     6,     7,     9,    10,    11,    19,
-      18,    14,    21,    17,     2,     0,    22,    13,    16
+       0,     0,    30,    21,     0,    16,     0,     0,     3,     5,
+       6,    27,     8,    27,    27,    27,     0,    28,    29,    13,
+       0,     0,    27,     1,     0,     4,    26,     7,     9,    10,
+      11,    20,     0,     0,    23,    19,    15,    26,    18,     2,
+       0,     0,    12,     0,    27,    25,    24,    22,    14,    17
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
       -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
-      24
+      33,    34,    27,    19
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -12
+#define YYPACT_NINF -14
 static const yytype_int8 yypact[] =
 {
-       7,   -10,   -12,   -12,    -9,    -6,     2,     1,   -12,    10,
-      -2,    -2,   -12,    -2,    -2,    -2,    16,    14,    11,     6,
-     -12,     7,   -12,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
-     -12,     8,    18,   -12,   -12,    17,    -2,   -12,   -12
+       1,    -3,    -2,   -14,    -1,     6,    17,     3,   -14,    14,
+     -14,     7,   -14,     7,     7,     7,    20,    19,   -14,   -14,
+      21,    16,    11,   -14,     1,   -14,   -14,   -14,   -14,   -14,
+     -14,   -14,    12,     4,   -14,   -14,    13,    24,   -14,   -14,
+       5,    19,   -14,    23,     7,   -14,   -14,   -14,   -14,   -14
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -12,   -12,     3,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
-     -11
+     -14,   -14,    10,   -14,   -14,   -14,   -14,   -14,   -14,   -14,
+     -14,    -6,   -13,   -14
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -545,26 +557,29 @@ static const yytype_int8 yypgoto[] =
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
-      25,    20,    26,    27,    28,    19,    16,    17,    33,    18,
-       1,     2,     3,     4,    23,    21,     5,    22,     6,    29,
-      30,    31,    32,    35,    34,    38,    36,    37
+      28,    29,    30,    23,     1,     2,     3,     4,    45,    38,
+       5,    46,     6,    17,    16,    18,    20,    24,    41,    42,
+      22,    25,    21,    31,    26,    32,    36,    35,    37,    43,
+      40,    49,    44,    48,    39,    47
 };
 
 static const yytype_uint8 yycheck[] =
 {
-      11,     0,    13,    14,    15,     3,    16,    16,    19,    15,
-       3,     4,     5,     6,    16,    14,     9,     7,    11,     3,
-       6,    10,    16,    15,    21,    36,     8,    10
+      13,    14,    15,     0,     3,     4,     5,     6,     3,    22,
+       9,     6,    11,    15,    17,    17,    17,    14,    14,    15,
+       3,     7,    16,     3,    17,     6,    10,     6,    17,    16,
+      18,    44,     8,    10,    24,    41
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,     4,     5,     6,     9,    11,    18,    19,    20,
-      21,    22,    23,    24,    25,    26,    16,    16,    15,     3,
-       0,    14,     7,    16,    27,    27,    27,    27,    27,     3,
-       6,    10,    16,    27,    19,    15,     8,    10,    27
+       0,     3,     4,     5,     6,     9,    11,    20,    21,    22,
+      23,    24,    25,    26,    27,    28,    17,    15,    17,    32,
+      17,    16,     3,     0,    14,     7,    17,    31,    31,    31,
+      31,     3,     6,    29,    30,     6,    10,    17,    31,    21,
+      18,    14,    15,    16,     8,     3,     6,    30,    10,    31
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1400,7 +1415,7 @@ yyreduce:
         case 4:
 
 /* Line 1464 of yacc.c  */
-#line 53 "util/parse-events.y"
+#line 57 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_modifier(list, (yyvsp[(2) - (2)].str)));
 ;}
@@ -1409,91 +1424,159 @@ yyreduce:
   case 12:
 
 /* Line 1464 of yacc.c  */
-#line 68 "util/parse-events.y"
+#line 72 "util/parse-events.y"
     {
-	int type = (yyvsp[(1) - (1)].num) >> 16;
-	int config = (yyvsp[(1) - (1)].num) & 255;
+	int type = (yyvsp[(1) - (4)].num) >> 16;
+	int config = (yyvsp[(1) - (4)].num) & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config));
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config, (yyvsp[(3) - (4)].head)));
+	parse_events__free_terms((yyvsp[(3) - (4)].head));
 ;}
     break;
 
   case 13:
 
 /* Line 1464 of yacc.c  */
-#line 77 "util/parse-events.y"
+#line 81 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
+	int type = (yyvsp[(1) - (2)].num) >> 16;
+	int config = (yyvsp[(1) - (2)].num) & 255;
+
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config, NULL));
 ;}
     break;
 
   case 14:
 
 /* Line 1464 of yacc.c  */
-#line 82 "util/parse-events.y"
+#line 90 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
 ;}
     break;
 
   case 15:
 
 /* Line 1464 of yacc.c  */
-#line 87 "util/parse-events.y"
+#line 95 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
 ;}
     break;
 
   case 16:
 
 /* Line 1464 of yacc.c  */
-#line 93 "util/parse-events.y"
+#line 100 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
 ;}
     break;
 
   case 17:
 
 /* Line 1464 of yacc.c  */
-#line 98 "util/parse-events.y"
+#line 106 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
 ;}
     break;
 
   case 18:
 
 /* Line 1464 of yacc.c  */
-#line 104 "util/parse-events.y"
+#line 111 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
 ;}
     break;
 
   case 19:
 
 /* Line 1464 of yacc.c  */
-#line 110 "util/parse-events.y"
+#line 117 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
 ;}
     break;
 
   case 20:
 
 /* Line 1464 of yacc.c  */
-#line 116 "util/parse-events.y"
+#line 123 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
+;}
+    break;
+
+  case 21:
+
+/* Line 1464 of yacc.c  */
+#line 129 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
+;}
+    break;
+
+  case 22:
+
+/* Line 1464 of yacc.c  */
+#line 135 "util/parse-events.y"
+    {
+	struct list_head *head = (yyvsp[(1) - (3)].head);
+	struct parse_events__term *term = (yyvsp[(3) - (3)].term);
+
+	ABORT_ON(!head);
+	list_add_tail(&term->list, head);
+	(yyval.head) = (yyvsp[(1) - (3)].head);
+;}
+    break;
+
+  case 23:
+
+/* Line 1464 of yacc.c  */
+#line 145 "util/parse-events.y"
+    {
+	struct list_head *head = malloc(sizeof(*head));
+	struct parse_events__term *term = (yyvsp[(1) - (1)].term);
+
+	ABORT_ON(!head);
+	INIT_LIST_HEAD(head);
+	list_add_tail(&term->list, head);
+	(yyval.head) = head;
+;}
+    break;
+
+  case 24:
+
+/* Line 1464 of yacc.c  */
+#line 157 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
+		 (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), 0));
+	(yyval.term) = term;
+;}
+    break;
+
+  case 25:
+
+/* Line 1464 of yacc.c  */
+#line 166 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num)));
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 (yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
+	(yyval.term) = term;
 ;}
     break;
 
 
 
 /* Line 1464 of yacc.c  */
-#line 1497 "util/parse-events-bison.c"
+#line 1580 "util/parse-events-bison.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -1705,7 +1788,7 @@ yyreturn:
 
 
 /* Line 1684 of yacc.c  */
-#line 122 "util/parse-events.y"
+#line 178 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
diff --git a/tools/perf/util/parse-events-bison.h b/tools/perf/util/parse-events-bison.h
index 097a632..b73c4bd 100644
--- a/tools/perf/util/parse-events-bison.h
+++ b/tools/perf/util/parse-events-bison.h
@@ -59,15 +59,17 @@ typedef union YYSTYPE
 {
 
 /* Line 1685 of yacc.c  */
-#line 42 "util/parse-events.y"
+#line 44 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
 
 
 
 /* Line 1685 of yacc.c  */
-#line 71 "util/parse-events-bison.h"
+#line 73 "util/parse-events-bison.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6e50b91..7423049 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -588,15 +588,46 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-int
-parse_events_add_numeric(struct list_head *list, int *idx,
-			 unsigned long type, unsigned long config)
+static int config_term(struct perf_event_attr *attr,
+		       struct parse_events__term *term)
+{
+	/* Only period supported so far. */
+	if (strcmp(term->config, "period"))
+		return -EINVAL;
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_NUM)
+		return -EINVAL;
+
+	attr->sample_period = term->val.num;
+	return 0;
+}
+
+static int config_attr(struct perf_event_attr *attr,
+		       struct list_head *head)
+{
+	struct parse_events__term *term;
+
+	list_for_each_entry(term, head, list)
+		if (config_term(attr, term))
+			return -EINVAL;
+
+	return 0;
+}
+
+int parse_events_add_numeric(struct list_head *list, int *idx,
+			     unsigned long type, unsigned long config,
+			     struct list_head *head_config)
 {
 	struct perf_event_attr attr;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.type = type;
 	attr.config = config;
+
+	if (head_config &&
+	    config_attr(&attr, head_config))
+		return -EINVAL;
+
 	return add_event(list, idx, &attr,
 			 (char *) __event_name(type, config));
 }
@@ -923,3 +954,41 @@ void print_events(const char *event_glob)
 
 	print_tracepoint_events(NULL, NULL);
 }
+
+int parse_events__new_term(struct parse_events__term **_term, int type,
+			   char *config, char *str, long num)
+{
+	struct parse_events__term *term;
+
+	term = zalloc(sizeof(*term));
+	if (!term)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&term->list);
+	term->type = type;
+	term->config = config;
+
+	switch (type) {
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		term->val.num = num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		term->val.str = str;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_term = term;
+	return 0;
+}
+
+void parse_events__free_terms(struct list_head *terms)
+{
+	struct parse_events__term *term, *h;
+
+	list_for_each_entry_safe(term, h, terms, list)
+		free(term);
+
+	free(terms);
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 84d3771..2737f1e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,25 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+enum {
+	PARSE_EVENTS__TERM_TYPE_NUM,
+	PARSE_EVENTS__TERM_TYPE_STR,
+};
+
+struct parse_events__term {
+	char *config;
+	union {
+		char *str;
+		long  num;
+	} val;
+	int type;
+
+	struct list_head list;
+};
+
+int parse_events__new_term(struct parse_events__term **term, int type,
+			   char *config, char *str, long num);
+void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event);
@@ -40,7 +59,8 @@ int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
 			 unsigned long config1, unsigned long config2,
 			 char *mod);
 int parse_events_add_numeric(struct list_head *list, int *idx,
-			     unsigned long type, unsigned long config);
+			     unsigned long type, unsigned long config,
+			     struct list_head *head_config);
 int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4b4459e..0be12dc 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -37,11 +37,15 @@ do { \
 %type <str> PE_NAME_CACHE_OP_RESULT
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
+%type <head> event_config
+%type <term> event_term
 
 %union
 {
 	char *str;
 	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
 }
 %%
 
@@ -56,7 +60,7 @@ event_def PE_MODIFIER_EVENT
 |
 event_def
 
-event_def: event_legacy_symbol sep_dc |
+event_def: event_legacy_symbol |
 	   event_legacy_cache sep_dc |
 	   event_legacy_mem |
 	   event_legacy_tracepoint sep_dc |
@@ -64,12 +68,21 @@ event_def: event_legacy_symbol sep_dc |
 	   event_legacy_raw sep_dc
 
 event_legacy_symbol:
-PE_VALUE_SYM
+PE_VALUE_SYM '/' event_config '/'
 {
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config));
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config, $3));
+	parse_events__free_terms($3);
+}
+|
+PE_VALUE_SYM sep_slash_dc
+{
+	int type = $1 >> 16;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events_add_numeric(list, idx, type, config, NULL));
 }
 
 event_legacy_cache:
@@ -108,17 +121,60 @@ PE_NAME ':' PE_NAME
 event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
-	ABORT_ON(parse_events_add_numeric(list, idx, $1, $3));
+	ABORT_ON(parse_events_add_numeric(list, idx, $1, $3, NULL));
 }
 
 event_legacy_raw:
 PE_RAW
 {
-	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, $1));
+	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, $1, NULL));
+}
+
+event_config:
+event_config ',' event_term
+{
+	struct list_head *head = $1;
+	struct parse_events__term *term = $3;
+
+	ABORT_ON(!head);
+	list_add_tail(&term->list, head);
+	$$ = $1;
+}
+|
+event_term
+{
+	struct list_head *head = malloc(sizeof(*head));
+	struct parse_events__term *term = $1;
+
+	ABORT_ON(!head);
+	INIT_LIST_HEAD(head);
+	list_add_tail(&term->list, head);
+	$$ = head;
+}
+
+event_term:
+PE_NAME '=' PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
+		 $1, $3, 0));
+	$$ = term;
+}
+|
+PE_NAME '=' PE_VALUE
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 $1, NULL, $3));
+	$$ = term;
 }
 
 sep_dc: ':' |
 
+sep_slash_dc: '/' | ':' |
+
 %%
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
-- 
1.7.6.5

