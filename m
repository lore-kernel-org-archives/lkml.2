Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2BPMDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab2BPMBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/8] perf, tool: Add config options support for event parsing
Date: Thu, 16 Feb 2012 13:00:50 +0100
Message-Id: <1329393652-6055-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
References: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
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
                      PE_NAME

sep_slash_dc: '/' | ':' |

At the moment the config options are hardcoded to be used for legacy
symbol events to define several perf_event_attr fields. It is:

  'config'   to define perf_event_attr::config
  'config1'  to define perf_event_attr::config1
  'config2'  to define perf_event_attr::config2
  'period'   to define perf_event_attr::sample_period

Legacy events could be now specified as:
  cycles/period=100000/

If term is specified without the value assignment, then 1 is
assigned by default.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c            |   22 +
 tools/perf/util/parse-events-bison.c |  310 +++++++++++-----
 tools/perf/util/parse-events-bison.h |   23 +-
 tools/perf/util/parse-events-flex.c  |  713 ++++++++++++++++++----------------
 tools/perf/util/parse-events-flex.h  |    2 +-
 tools/perf/util/parse-events.c       |   99 +++++-
 tools/perf/util/parse-events.h       |   31 ++-
 tools/perf/util/parse-events.l       |   19 +
 tools/perf/util/parse-events.y       |   94 +++++-
 9 files changed, 866 insertions(+), 447 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index adf959f..c994a9c 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -677,6 +677,24 @@ static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
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
+	TEST_ASSERT_VAL("wrong config1",
+			0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",
+			1 == evsel->attr.config2);
+	return 0;
+}
+
 static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -884,6 +902,10 @@ static struct test__event_st {
 		.check = test__checkevent_symbolic_name,
 	},
 	{
+		.name  = "cycles/period=100000,config2/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	{
 		.name  = "faults",
 		.check = test__checkevent_symbolic_alias,
 	},
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index 20fca26..ace593a 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -127,14 +127,15 @@ do { \
      PE_VALUE = 258,
      PE_VALUE_SYM = 259,
      PE_RAW = 260,
-     PE_NAME = 261,
-     PE_MODIFIER_EVENT = 262,
-     PE_MODIFIER_BP = 263,
-     PE_NAME_CACHE_TYPE = 264,
-     PE_NAME_CACHE_OP_RESULT = 265,
-     PE_PREFIX_MEM = 266,
-     PE_PREFIX_RAW = 267,
-     PE_ERROR = 268
+     PE_TERM = 261,
+     PE_NAME = 262,
+     PE_MODIFIER_EVENT = 263,
+     PE_MODIFIER_BP = 264,
+     PE_NAME_CACHE_TYPE = 265,
+     PE_NAME_CACHE_OP_RESULT = 266,
+     PE_PREFIX_MEM = 267,
+     PE_PREFIX_RAW = 268,
+     PE_ERROR = 269
    };
 #endif
 
@@ -145,15 +146,17 @@ typedef union YYSTYPE
 {
 
 /* Line 214 of yacc.c  */
-#line 42 "util/parse-events.y"
+#line 45 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
 
 
 
 /* Line 214 of yacc.c  */
-#line 157 "util/parse-events-bison.c"
+#line 160 "util/parse-events-bison.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -165,7 +168,7 @@ typedef union YYSTYPE
 
 
 /* Line 264 of yacc.c  */
-#line 169 "util/parse-events-bison.c"
+#line 172 "util/parse-events-bison.c"
 
 #ifdef short
 # undef short
@@ -378,22 +381,22 @@ union yyalloc
 #endif
 
 /* YYFINAL -- State number of the termination state.  */
-#define YYFINAL  20
+#define YYFINAL  23
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   27
+#define YYLAST   38
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  17
+#define YYNTOKENS  20
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  11
+#define YYNNTS  14
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  22
+#define YYNRULES  33
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  39
+#define YYNSTATES  53
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   268
+#define YYMAXUTOK   269
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -405,9 +408,9 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,     2,     2,     2,    14,    15,     2,     2,     2,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,    16,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,    15,    17,     2,    16,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,    18,     2,
+       2,    19,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
@@ -427,7 +430,7 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
-       5,     6,     7,     8,     9,    10,    11,    12,    13
+       5,     6,     7,     8,     9,    10,    11,    12,    13,    14
 };
 
 #if YYDEBUG
@@ -435,29 +438,34 @@ static const yytype_uint8 yytranslate[] =
    YYRHS.  */
 static const yytype_uint8 yyprhs[] =
 {
-       0,     0,     3,     7,     9,    12,    14,    17,    20,    22,
-      25,    28,    31,    33,    39,    43,    45,    51,    55,    59,
-      63,    65,    67
+       0,     0,     3,     7,     9,    12,    14,    16,    19,    21,
+      24,    27,    30,    35,    38,    44,    48,    50,    56,    60,
+      64,    68,    70,    74,    76,    80,    84,    86,    90,    92,
+      94,    95,    97,    99
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
+      21,     0,    -1,    21,    15,    22,    -1,    22,    -1,    23,
+       8,    -1,    23,    -1,    24,    -1,    25,    32,    -1,    26,
+      -1,    27,    32,    -1,    28,    32,    -1,    29,    32,    -1,
+       4,    16,    30,    16,    -1,     4,    33,    -1,    10,    17,
+      11,    17,    11,    -1,    10,    17,    11,    -1,    10,    -1,
+      12,     3,    18,     9,    32,    -1,    12,     3,    32,    -1,
+       7,    18,     7,    -1,     3,    18,     3,    -1,     5,    -1,
+      30,    15,    31,    -1,    31,    -1,     7,    19,     7,    -1,
+       7,    19,     3,    -1,     7,    -1,     6,    19,     3,    -1,
+       6,    -1,    18,    -1,    -1,    16,    -1,    18,    -1,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
-       0,    49,    49,    49,    52,    57,    59,    60,    61,    62,
-      63,    64,    67,    76,    81,    86,    92,    97,   103,   109,
-     115,   120,   120
+       0,    54,    54,    54,    57,    62,    64,    65,    66,    67,
+      68,    69,    72,    81,    90,    95,   100,   106,   111,   117,
+     123,   129,   135,   145,   157,   166,   175,   184,   192,   200,
+     200,   202,   202,   202
 };
 #endif
 
@@ -467,12 +475,13 @@ static const yytype_uint8 yyrline[] =
 static const char *const yytname[] =
 {
   "$end", "error", "$undefined", "PE_VALUE", "PE_VALUE_SYM", "PE_RAW",
-  "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP", "PE_NAME_CACHE_TYPE",
-  "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM", "PE_PREFIX_RAW", "PE_ERROR",
-  "','", "'-'", "':'", "$accept", "events", "event", "event_def",
-  "event_legacy_symbol", "event_legacy_cache", "event_legacy_mem",
-  "event_legacy_tracepoint", "event_legacy_numeric", "event_legacy_raw",
-  "sep_dc", 0
+  "PE_TERM", "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP",
+  "PE_NAME_CACHE_TYPE", "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM",
+  "PE_PREFIX_RAW", "PE_ERROR", "','", "'/'", "'-'", "':'", "'='",
+  "$accept", "events", "event", "event_def", "event_legacy_symbol",
+  "event_legacy_cache", "event_legacy_mem", "event_legacy_tracepoint",
+  "event_legacy_numeric", "event_legacy_raw", "event_config", "event_term",
+  "sep_dc", "sep_slash_dc", 0
 };
 #endif
 
@@ -482,24 +491,26 @@ static const char *const yytname[] =
 static const yytype_uint16 yytoknum[] =
 {
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
-     265,   266,   267,   268,    44,    45,    58
+     265,   266,   267,   268,   269,    44,    47,    45,    58,    61
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    17,    18,    18,    19,    19,    20,    20,    20,    20,
-      20,    20,    21,    22,    22,    22,    23,    23,    24,    25,
-      26,    27,    27
+       0,    20,    21,    21,    22,    22,    23,    23,    23,    23,
+      23,    23,    24,    24,    25,    25,    25,    26,    26,    27,
+      28,    29,    30,    30,    31,    31,    31,    31,    31,    32,
+      32,    33,    33,    33
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
 static const yytype_uint8 yyr2[] =
 {
-       0,     2,     3,     1,     2,     1,     2,     2,     1,     2,
-       2,     2,     1,     5,     3,     1,     5,     3,     3,     3,
-       1,     1,     0
+       0,     2,     3,     1,     2,     1,     1,     2,     1,     2,
+       2,     2,     4,     2,     5,     3,     1,     5,     3,     3,
+       3,     1,     3,     1,     3,     3,     1,     3,     1,     1,
+       0,     1,     1,     0
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -507,35 +518,39 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,    12,    20,     0,    15,     0,     0,     3,     5,
-      22,    22,     8,    22,    22,    22,     0,     0,     0,    22,
-       1,     0,     4,    21,     6,     7,     9,    10,    11,    19,
-      18,    14,    21,    17,     2,     0,    22,    13,    16
+       0,     0,    33,    21,     0,    16,     0,     0,     3,     5,
+       6,    30,     8,    30,    30,    30,     0,    31,    32,    13,
+       0,     0,    30,     1,     0,     4,    29,     7,     9,    10,
+      11,    20,    28,    26,     0,    23,    19,    15,    29,    18,
+       2,     0,     0,     0,    12,     0,    30,    27,    25,    24,
+      22,    14,    17
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
       -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
-      24
+      34,    35,    27,    19
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
+       1,   -11,    -1,   -14,    -6,     8,    20,     3,   -14,    16,
+     -14,    -2,   -14,    -2,    -2,    -2,    23,    13,   -14,   -14,
+      21,    18,     9,   -14,     1,   -14,   -14,   -14,   -14,   -14,
+     -14,   -14,    11,    12,     6,   -14,   -14,    15,    25,   -14,
+     -14,    32,     7,    13,   -14,    26,    -2,   -14,   -14,   -14,
+     -14,   -14,   -14
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -12,   -12,     3,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
-     -11
+     -14,   -14,    14,   -14,   -14,   -14,   -14,   -14,   -14,   -14,
+     -14,    -7,   -13,   -14
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
@@ -545,26 +560,30 @@ static const yytype_int8 yypgoto[] =
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
-      25,    20,    26,    27,    28,    19,    16,    17,    33,    18,
-       1,     2,     3,     4,    23,    21,     5,    22,     6,    29,
-      30,    31,    32,    35,    34,    38,    36,    37
+      28,    29,    30,    23,     1,     2,     3,    16,     4,    39,
+      48,     5,    20,     6,    49,    17,    26,    18,    24,    32,
+      33,    43,    44,    22,    25,    21,    31,    38,    36,    37,
+      41,    42,    45,    52,    46,    47,    50,    51,    40
 };
 
 static const yytype_uint8 yycheck[] =
 {
-      11,     0,    13,    14,    15,     3,    16,    16,    19,    15,
-       3,     4,     5,     6,    16,    14,     9,     7,    11,     3,
-       6,    10,    16,    15,    21,    36,     8,    10
+      13,    14,    15,     0,     3,     4,     5,    18,     7,    22,
+       3,    10,    18,    12,     7,    16,    18,    18,    15,     6,
+       7,    15,    16,     3,     8,    17,     3,    18,     7,    11,
+      19,    19,    17,    46,     9,     3,    43,    11,    24
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,     4,     5,     6,     9,    11,    18,    19,    20,
-      21,    22,    23,    24,    25,    26,    16,    16,    15,     3,
-       0,    14,     7,    16,    27,    27,    27,    27,    27,     3,
-       6,    10,    16,    27,    19,    15,     8,    10,    27
+       0,     3,     4,     5,     7,    10,    12,    21,    22,    23,
+      24,    25,    26,    27,    28,    29,    18,    16,    18,    33,
+      18,    17,     3,     0,    15,     8,    18,    32,    32,    32,
+      32,     3,     6,     7,    30,    31,     7,    11,    18,    32,
+      22,    19,    19,    15,    16,    17,     9,     3,     3,     7,
+      31,    11,    32
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1400,7 +1419,7 @@ yyreduce:
         case 4:
 
 /* Line 1464 of yacc.c  */
-#line 53 "util/parse-events.y"
+#line 58 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_modifier(list, (yyvsp[(2) - (2)].str)));
 ;}
@@ -1409,91 +1428,196 @@ yyreduce:
   case 12:
 
 /* Line 1464 of yacc.c  */
-#line 68 "util/parse-events.y"
+#line 73 "util/parse-events.y"
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
+#line 82 "util/parse-events.y"
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
+#line 91 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
 ;}
     break;
 
   case 15:
 
 /* Line 1464 of yacc.c  */
-#line 87 "util/parse-events.y"
+#line 96 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
 ;}
     break;
 
   case 16:
 
 /* Line 1464 of yacc.c  */
-#line 93 "util/parse-events.y"
+#line 101 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
+	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
 ;}
     break;
 
   case 17:
 
 /* Line 1464 of yacc.c  */
-#line 98 "util/parse-events.y"
+#line 107 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
 ;}
     break;
 
   case 18:
 
 /* Line 1464 of yacc.c  */
-#line 104 "util/parse-events.y"
+#line 112 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
+	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
 ;}
     break;
 
   case 19:
 
 /* Line 1464 of yacc.c  */
-#line 110 "util/parse-events.y"
+#line 118 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
 ;}
     break;
 
   case 20:
 
 /* Line 1464 of yacc.c  */
-#line 116 "util/parse-events.y"
+#line 124 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
+;}
+    break;
+
+  case 21:
+
+/* Line 1464 of yacc.c  */
+#line 130 "util/parse-events.y"
+    {
+	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
+;}
+    break;
+
+  case 22:
+
+/* Line 1464 of yacc.c  */
+#line 136 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num)));
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
+#line 146 "util/parse-events.y"
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
+#line 158 "util/parse-events.y"
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
+#line 167 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 (yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
+	(yyval.term) = term;
+;}
+    break;
+
+  case 26:
+
+/* Line 1464 of yacc.c  */
+#line 176 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 (yyvsp[(1) - (1)].str), NULL, 1));
+	(yyval.term) = term;
+;}
+    break;
+
+  case 27:
+
+/* Line 1464 of yacc.c  */
+#line 185 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (3)].num), NULL, NULL, (yyvsp[(3) - (3)].num)));
+	(yyval.term) = term;
+;}
+    break;
+
+  case 28:
+
+/* Line 1464 of yacc.c  */
+#line 193 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (1)].num), NULL, NULL, 1));
+	(yyval.term) = term;
 ;}
     break;
 
 
 
 /* Line 1464 of yacc.c  */
-#line 1497 "util/parse-events-bison.c"
+#line 1621 "util/parse-events-bison.c"
       default: break;
     }
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
@@ -1705,7 +1829,7 @@ yyreturn:
 
 
 /* Line 1684 of yacc.c  */
-#line 122 "util/parse-events.y"
+#line 204 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
diff --git a/tools/perf/util/parse-events-bison.h b/tools/perf/util/parse-events-bison.h
index 097a632..c58b765 100644
--- a/tools/perf/util/parse-events-bison.h
+++ b/tools/perf/util/parse-events-bison.h
@@ -41,14 +41,15 @@
      PE_VALUE = 258,
      PE_VALUE_SYM = 259,
      PE_RAW = 260,
-     PE_NAME = 261,
-     PE_MODIFIER_EVENT = 262,
-     PE_MODIFIER_BP = 263,
-     PE_NAME_CACHE_TYPE = 264,
-     PE_NAME_CACHE_OP_RESULT = 265,
-     PE_PREFIX_MEM = 266,
-     PE_PREFIX_RAW = 267,
-     PE_ERROR = 268
+     PE_TERM = 261,
+     PE_NAME = 262,
+     PE_MODIFIER_EVENT = 263,
+     PE_MODIFIER_BP = 264,
+     PE_NAME_CACHE_TYPE = 265,
+     PE_NAME_CACHE_OP_RESULT = 266,
+     PE_PREFIX_MEM = 267,
+     PE_PREFIX_RAW = 268,
+     PE_ERROR = 269
    };
 #endif
 
@@ -59,15 +60,17 @@ typedef union YYSTYPE
 {
 
 /* Line 1685 of yacc.c  */
-#line 42 "util/parse-events.y"
+#line 45 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
+	struct list_head *head;
+	struct parse_events__term *term;
 
 
 
 /* Line 1685 of yacc.c  */
-#line 71 "util/parse-events-bison.h"
+#line 74 "util/parse-events-bison.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
diff --git a/tools/perf/util/parse-events-flex.c b/tools/perf/util/parse-events-flex.c
index 9e77ed6..34cfc85 100644
--- a/tools/perf/util/parse-events-flex.c
+++ b/tools/perf/util/parse-events-flex.c
@@ -378,8 +378,8 @@ static void yy_fatal_error (yyconst char msg[]  );
 	*yy_cp = '\0'; \
 	(yy_c_buf_p) = yy_cp;
 
-#define YY_NUM_RULES 44
-#define YY_END_OF_BUFFER 45
+#define YY_NUM_RULES 49
+#define YY_END_OF_BUFFER 50
 /* This struct is not used in this scanner,
    but its presence is necessary. */
 struct yy_trans_info
@@ -387,55 +387,56 @@ struct yy_trans_info
 	flex_int32_t yy_verify;
 	flex_int32_t yy_nxt;
 	};
-static yyconst flex_int16_t yy_accept[425] =
+static yyconst flex_int16_t yy_accept[440] =
     {   0,
-        0,    0,   45,   44,   38,   41,   40,   39,   34,   34,
-       42,   43,   38,   38,   38,   38,   38,   38,   38,   38,
-       38,   38,   36,   38,   38,   38,   38,   38,   36,   37,
-       38,   38,   37,   37,   38,   34,    0,   38,   38,   38,
-       21,   38,   38,   38,   38,   38,   38,   38,   38,   38,
-       38,   38,   15,   38,    0,   38,   38,   38,   36,    0,
-       38,   38,   38,   38,   38,   38,   38,   38,   38,   38,
-       38,   38,   33,   33,   38,   38,   38,   38,   35,   38,
-       38,    0,   38,   38,   38,   24,   38,   38,   38,   38,
-       38,   38,    0,   38,   38,   38,   36,    0,   38,   38,
-
-       38,    0,   19,   20,   38,   38,   38,   38,   38,   38,
-       38,   30,   38,   38,   33,   33,   38,   38,   38,   38,
-       38,   38,   38,    0,    0,   38,   38,   38,   38,    0,
-       38,   38,    0,   38,    0,   22,   38,   38,   36,    0,
-       23,   38,   38,   19,   20,   26,   38,   32,   38,   38,
-       31,   25,   38,   38,   26,   38,   38,   38,   38,   38,
-        0,   38,    0,    0,    0,    0,   38,   38,   38,   38,
-        0,   38,   38,    0,    0,   38,   22,   38,   38,   36,
-       23,    0,   38,   26,   38,   38,   38,   38,    0,   38,
-       38,   38,   27,    0,   27,    0,   38,    0,    0,    0,
-
-        0,   38,   38,   24,    0,    0,   38,    0,    0,    0,
-        1,   38,   12,    0,   38,    0,   38,    0,   31,    0,
-       38,   38,   38,    0,    0,   38,    0,    0,    0,   38,
-       38,    0,   38,    0,    0,    0,   38,    0,    0,    0,
-       38,    0,   38,    0,   38,    0,    0,   38,   38,   38,
-        0,   38,    0,    0,    0,   38,   38,    0,    0,    7,
-        0,    0,    0,    0,    0,    0,    0,   38,    0,   38,
-        0,   38,    0,    0,   28,   38,    0,    0,   38,    0,
-       38,    0,    0,    0,    0,    0,    0,   10,    0,    0,
-       38,    0,   38,    0,   38,    0,    0,   38,   38,    0,
-
-        0,   38,    0,    0,    0,    0,    9,    0,    0,    0,
-        1,    0,    0,    0,   38,    0,   16,    0,    0,   28,
-       38,    0,   11,   38,    0,    0,    0,    0,    0,    0,
-        0,    0,    0,    0,   38,    0,    0,   12,   38,    0,
-        0,    0,    0,    0,    0,    6,    0,    0,    0,    0,
-        0,    4,   14,   13,    0,    0,    0,    0,    0,    0,
-        8,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-        0,    0,    0,    0,    0,   16,    0,    0,    0,    0,
+        0,    0,   50,   49,   43,   46,   45,   44,   39,   39,
+       47,   48,   43,   43,   43,   43,   43,   43,   43,   43,
+       43,   43,   41,   43,   43,   43,   43,   43,   41,   42,
+       43,   43,   42,   42,   43,   39,    0,   43,   43,   43,
+       21,   43,   43,   43,   43,   43,   43,   43,   43,   43,
+       43,   43,   15,   43,    0,   43,   43,   43,   41,    0,
+       43,   43,   43,   43,   43,   43,   43,   43,   43,   43,
+       43,   43,   43,   38,   38,   43,   43,   43,   43,   40,
+       43,   43,    0,   43,   43,   43,   24,   43,   43,   43,
+       43,   43,   43,    0,   43,   43,   43,   41,    0,   43,
+
+       43,   43,    0,   19,   20,   43,   43,   43,   43,   43,
+       43,   43,   30,   43,   43,   43,   38,   38,   43,   43,
+       43,   43,   43,   43,   43,    0,    0,   43,   43,   43,
+       43,    0,   43,   43,   43,    0,   43,    0,   22,   43,
+       43,   41,    0,   23,   43,   43,   19,   20,   26,   43,
+       37,   43,   43,   31,   25,   43,   43,   43,   26,   43,
+       43,   43,   43,   43,    0,   43,    0,    0,    0,    0,
+       43,   43,   43,   43,    0,   43,   43,   43,    0,    0,
+       43,   22,   43,   43,   41,   23,    0,   43,   26,   43,
+       43,   43,   43,    0,   43,   43,   43,   43,   27,    0,
+
+       27,    0,   43,    0,    0,    0,    0,   43,   43,   24,
+        0,    0,   32,   43,    0,    0,    0,    1,   43,   12,
+        0,   43,    0,   43,    0,   31,    0,   35,   43,   43,
+       43,    0,    0,   43,    0,    0,    0,   43,   43,    0,
+       43,   43,    0,    0,    0,   33,   34,   43,    0,    0,
+        0,   43,    0,   43,    0,   43,    0,    0,   43,   43,
+       43,    0,   43,    0,    0,    0,   43,   43,    0,    0,
+       43,    7,    0,    0,    0,    0,    0,    0,    0,   43,
+        0,   43,    0,   43,    0,    0,   28,   43,    0,    0,
+       43,    0,   43,    0,    0,   43,    0,    0,    0,    0,
+
+       10,    0,    0,   43,    0,   43,    0,   43,    0,    0,
+       43,   43,    0,    0,   43,    0,    0,    0,    0,   43,
+        9,    0,    0,    0,    1,    0,    0,    0,   43,    0,
+       16,    0,    0,   28,   43,    0,   11,   43,    0,    0,
+        0,    0,   36,    0,    0,    0,    0,    0,    0,   43,
+        0,    0,   12,   43,    0,    0,    0,    0,    0,    0,
+        6,    0,    0,    0,    0,    0,    4,   14,   13,    0,
+        0,    0,    0,    0,    0,    8,    0,    0,    0,    0,
         0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-        0,    0,   17,    0,    5,   15,   18,    0,    0,   29,
+       16,    0,    0,    0,    0,    0,    0,    0,    0,    0,
 
-        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-        0,    0,    7,    3,    0,    0,    0,    2,    0,    0,
-        0,    0,    0,    0
+        0,    0,    0,    0,    0,    0,    0,   17,    0,    5,
+       15,   18,    0,    0,   29,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    7,    3,    0,
+        0,    0,    2,    0,    0,    0,    0,    0,    0
     } ;
 
 static yyconst flex_int32_t yy_ec[256] =
@@ -449,11 +450,11 @@ static yyconst flex_int32_t yy_ec[256] =
        11,    1,    2,    1,   12,   13,   14,   15,   12,   12,
         2,    2,   16,    2,    2,   17,    2,    2,    2,    2,
         2,   18,    2,   19,    2,    2,    2,    2,    2,    2,
-        1,    1,    1,    1,    2,    1,   20,   21,   22,   23,
+        1,    1,    1,    1,   20,    1,   21,   22,   23,   24,
 
-       24,   25,   26,   27,   28,   29,   30,   31,   32,   33,
-       34,   35,    2,   36,   37,   38,   39,   40,   41,   42,
-       43,    2,    1,    1,    1,    1,    1,    1,    1,    1,
+       25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
+       35,   36,    2,   37,   38,   39,   40,   41,   42,   43,
+       44,    2,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
@@ -470,241 +471,249 @@ static yyconst flex_int32_t yy_ec[256] =
         1,    1,    1,    1,    1
     } ;
 
-static yyconst flex_int32_t yy_meta[44] =
+static yyconst flex_int32_t yy_meta[45] =
     {   0,
         1,    2,    1,    1,    1,    3,    3,    3,    3,    1,
-        1,    3,    3,    3,    3,    2,    2,    2,    2,    3,
-        3,    3,    3,    3,    3,    2,    2,    2,    2,    2,
+        1,    3,    3,    3,    3,    2,    2,    2,    2,    2,
+        3,    3,    3,    3,    3,    3,    2,    2,    2,    2,
         2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
-        2,    2,    2
+        2,    2,    2,    2
     } ;
 
-static yyconst flex_int16_t yy_base[427] =
+static yyconst flex_int16_t yy_base[442] =
     {   0,
-        0,    0,  494,  495,    0,  495,  495,  495,   38,   42,
-      495,  495,  473,  459,   45,  467,   32,   20,   40,   53,
-      458,  469,   34,   62,   58,   58,  454,  452,   64,   98,
-       32,  466,  449,    0,    0,   81,    0,  446,  446,  478,
-        0,  467,  455,  457,  450,   54,  457,  455,  438,  452,
-      440,  433,    0,  449,  432,  452,  429,  428,   97,  428,
-      448,  433,  426,  105,  442,  432,  428,  104,  436,  421,
-      431,  432,  431,   77,  430,   95,  416,  424,    0,  431,
-      412,  103,  425,  424,  421,    0,  413,  441,  417,  405,
-      438,  410,  409,  426,  407,  406,  108,  405,  422,  410,
-
-      395,  111,    0,    0,  409,  397,  420,  393,  394,  390,
-      402,    0,  401,  399,   93,  116,  401,  391,  385,  390,
-      381,  414,  381,   76,   46,  380,  378,  381,  391,  390,
-      387,  386,  120,  385,  387,    0,  387,  368,  119,  384,
-        0,  400,  367,  495,  495,  365,  365,  495,  380,  363,
-      374,    0,  393,  372,  371,  355,  362,  368,  387,  366,
-      370,  349,  349,  366,  365,  347,  359,  345,  349,  353,
-      336,  374,  335,  113,  348,  338,  495,  336,  336,    0,
-      495,  350,  332,    0,  366,  331,  364,  330,  341,  327,
-      333,  339,  325,  339,    0,  343,  337,  338,  335,  334,
-
-      317,  321,  329,  121,  330,  119,  313,  316,  327,  322,
-        0,  319,    0,  303,  323,  319,  315,  317,    0,  321,
-      318,  319,  315,  306,  323,  297,  307,  306,  296,  309,
-      297,  129,  292,  297,  299,  302,  321,  302,  292,  286,
-      287,  298,  281,  298,  283,  296,  276,  287,  275,  308,
-      277,  282,  285,  284,  268,  282,  267,  271,  275,    0,
-      278,  264,  275,  262,  268,  273,  276,  262,  263,  265,
-      253,  258,  251,  258,  264,  259,  264,  263,  250,  261,
-      278,  244,  243,  242,  241,  253,  235,  495,  238,  236,
-      269,  248,  237,  239,  232,  237,  229,  229,  225,  221,
-
-      233,  229,  223,  235,  221,  221,  495,  233,  220,  227,
-      495,  226,  228,  215,  218,  212,    0,  211,  211,    0,
-      223,  224,  495,  241,  216,  223,  206,  217,  203,  215,
-      200,  203,  216,  231,  197,  196,  195,  495,  227,  199,
-      210,  194,  188,  187,  188,  495,  191,  201,  189,  182,
-      138,    0,  495,  495,  129,  196,  202,  185,  186,  194,
-      495,  193,  187,  176,  181,  191,  174,  175,  184,  170,
-      193,  167,  166,  179,  178,  495,  163,  178,  165,  178,
-      177,  192,  158,  166,  156,  155,  154,  160,  156,  165,
-      164,  141,  495,  152,  495,  495,  495,  161,  146,  495,
-
-      163,  146,  148,  147,  155,  156,  143,  139,  152,  141,
-      143,  139,  495,  495,  148,  146,  131,  495,  131,  126,
-      125,   81,   85,  495,  165,   68
+        0,    0,  510,  511,    0,  511,  511,  511,   39,   43,
+      511,  511,  488,  474,   46,  482,   32,   20,   37,   57,
+      473,  484,   34,   64,   59,   64,  469,  467,   78,  113,
+       41,  481,  464,    0,    0,  104,    0,  461,  461,  494,
+        0,  483,  470,  472,  465,   44,  472,  470,  453,  467,
+      455,  448,    0,  464,  447,  468,  444,  443,   64,  443,
+      464,  448,  441,   67,  457,  447,  443,   52,  451,  436,
+      446,  435,  446,  445,   76,  444,   95,  430,  438,    0,
+      445,  426,  100,  439,  438,  435,    0,  427,  456,  431,
+      105,  454,  425,  424,  442,  422,  421,  112,  420,  438,
+
+      425,  410,  117,    0,    0,  424,  412,  436,  408,  409,
+      405,  417,    0,  416,  411,  413,   83,  107,  415,  405,
+      399,  404,  395,  429,  395,  126,  119,  394,  392,  395,
+      405,  404,  401,  396,  399,  100,  398,  400,    0,  400,
+      381,  123,  397,    0,  414,  380,  511,  511,  378,  378,
+      511,  393,  376,  387,    0,  407,  375,  384,  383,  367,
+      374,  380,  400,  378,  383,  361,  361,  378,  377,  359,
+      371,  357,  361,  365,  348,  387,  363,  346,   73,  359,
+      349,  511,  347,  347,    0,  511,  361,  343,    0,  378,
+      342,  376,  341,  352,  353,  337,  343,  349,  335,  349,
+
+        0,  354,  347,  348,  345,  344,  327,  331,  339,  146,
+      340,  123,  150,  323,  326,  337,  332,    0,  329,    0,
+      313,  333,  329,  325,  327,    0,  331,    0,  328,  329,
+      325,  316,  334,  307,  317,  316,  306,  319,  307,  132,
+      301,  301,  306,  308,  311,    0,    0,  331,  311,  301,
+      295,  296,  307,  290,  307,  292,  305,  285,  296,  284,
+      318,  286,  291,  294,  293,  277,  291,  276,  280,  284,
+      268,    0,  286,  272,  283,  270,  276,  281,  284,  270,
+      271,  273,  261,  266,  259,  266,  272,  267,  272,  271,
+      258,  269,  287,  252,  251,  252,  249,  248,  260,  242,
+
+      511,  245,  243,  277,  255,  244,  246,  239,  244,  236,
+      236,  232,  228,  240,  236,  230,  242,  228,  228,  240,
+      511,  239,  226,  233,  511,  232,  234,  221,  224,  218,
+        0,  217,  217,    0,  229,  230,  511,  248,  222,  229,
+      212,  223,    0,  209,  221,  206,  209,  222,  238,  203,
+      202,  201,  511,  234,  205,  217,  200,  194,  193,  194,
+      511,  197,  207,  195,  188,  142,    0,  511,  511,  130,
+      202,  209,  191,  192,  200,  511,  199,  193,  182,  187,
+      197,  180,  181,  190,  176,  200,  173,  172,  185,  184,
+      511,  169,  184,  171,  184,  183,  199,  164,  172,  162,
+
+      161,  160,  166,  162,  171,  170,  147,  511,  158,  511,
+      511,  511,  167,  152,  511,  169,  152,  154,  153,  161,
+      162,  149,  145,  158,  147,  149,  145,  511,  511,  154,
+      152,  137,  511,  138,  145,  131,   53,   54,  511,  172,
+       66
     } ;
 
-static yyconst flex_int16_t yy_def[427] =
+static yyconst flex_int16_t yy_def[442] =
     {   0,
-      424,    1,  424,  424,  425,  424,  424,  424,  424,  424,
-      424,  424,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,  425,  425,  425,  424,  426,  425,  425,  425,
-      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,  425,  425,  424,  425,  425,  425,  425,  424,
-      425,  425,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,   30,   30,  425,  425,  425,  425,  426,  425,
-      425,  424,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,  424,  425,  425,  425,  425,  424,  425,  425,
-
-      425,  424,  425,  425,  425,  425,  425,  425,  425,  425,
-      425,  425,  425,  425,   30,   30,  425,  425,  425,  425,
-      425,  425,  425,  424,  424,  425,  425,  425,  425,  424,
-      425,  425,  424,  425,  424,  425,  425,  425,  425,  424,
-      425,  425,  425,  424,  424,  425,  425,  424,  425,  425,
-      425,  425,  425,  425,   30,  425,  425,  425,  425,  425,
-      424,  425,  424,  424,  424,  424,  425,  425,  425,  425,
-      424,  425,  425,  424,  424,  425,  424,  425,  425,  425,
-      424,  424,  425,  425,  425,  425,  425,  425,  424,  425,
-      425,  425,  425,  424,  425,  424,  425,  424,  424,  424,
-
-      424,  425,  425,  425,  424,  424,  425,  424,  424,  424,
-      425,  425,  425,  424,  425,  424,  425,  424,  425,  424,
-      425,  425,  425,  424,  424,  425,  424,  424,  424,  425,
-      425,  424,  425,  424,  424,  424,  425,  424,  424,  424,
-      425,  424,  425,  424,  425,  424,  424,  425,  425,  425,
-      424,  425,  424,  424,  424,  425,  425,  424,  424,  425,
-      424,  424,  424,  424,  424,  424,  424,  425,  424,  425,
-      424,  425,  424,  424,  425,  425,  424,  424,  425,  424,
-      425,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      425,  424,  425,  424,  425,  424,  424,  425,  425,  424,
-
-      424,  425,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  425,  424,  425,  424,  424,  425,
-      425,  424,  424,  425,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  425,  424,  424,  424,  425,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  425,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,    0,  424,  424
+      439,    1,  439,  439,  440,  439,  439,  439,  439,  439,
+      439,  439,  440,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,  440,  440,  439,  441,  440,  440,  440,
+      440,  440,  440,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,  440,  439,  440,  440,  440,  440,  439,
+      440,  440,  440,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,   30,   30,  440,  440,  440,  440,  441,
+      440,  440,  439,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,  439,  440,  440,  440,  440,  439,  440,
+
+      440,  440,  439,  440,  440,  440,  440,  440,  440,  440,
+      440,  440,  440,  440,  440,  440,   30,   30,  440,  440,
+      440,  440,  440,  440,  440,  439,  439,  440,  440,  440,
+      440,  439,  440,  440,  440,  439,  440,  439,  440,  440,
+      440,  440,  439,  440,  440,  440,  439,  439,  440,  440,
+      439,  440,  440,  440,  440,  440,  440,  440,   30,  440,
+      440,  440,  440,  440,  439,  440,  439,  439,  439,  439,
+      440,  440,  440,  440,  439,  440,  440,  440,  439,  439,
+      440,  439,  440,  440,  440,  439,  439,  440,  440,  440,
+      440,  440,  440,  439,  440,  440,  440,  440,  440,  439,
+
+      440,  439,  440,  439,  439,  439,  439,  440,  440,  440,
+      439,  439,  440,  440,  439,  439,  439,  440,  440,  440,
+      439,  440,  439,  440,  439,  440,  439,  440,  440,  440,
+      440,  439,  439,  440,  439,  439,  439,  440,  440,  439,
+      440,  440,  439,  439,  439,  440,  440,  440,  439,  439,
+      439,  440,  439,  440,  439,  440,  439,  439,  440,  440,
+      440,  439,  440,  439,  439,  439,  440,  440,  439,  439,
+      440,  440,  439,  439,  439,  439,  439,  439,  439,  440,
+      439,  440,  439,  440,  439,  439,  440,  440,  439,  439,
+      440,  439,  440,  439,  439,  440,  439,  439,  439,  439,
+
+      439,  439,  439,  440,  439,  440,  439,  440,  439,  439,
+      440,  440,  439,  439,  440,  439,  439,  439,  439,  440,
+      439,  439,  439,  439,  439,  439,  439,  439,  440,  439,
+      440,  439,  439,  440,  440,  439,  439,  440,  439,  439,
+      439,  439,  440,  439,  439,  439,  439,  439,  439,  440,
+      439,  439,  439,  440,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  440,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,    0,  439,
+      439
     } ;
 
-static yyconst flex_int16_t yy_nxt[539] =
+static yyconst flex_int16_t yy_nxt[556] =
     {   0,
         4,    5,    6,    7,    8,    9,   10,   10,   10,   11,
-       12,    5,    5,    5,   13,   14,   15,   16,    5,   17,
-       18,   19,   20,   21,   22,    5,   23,   24,    5,   23,
-       25,   26,   27,   28,   29,   30,   31,   32,   23,    5,
-       33,   34,    5,   36,   36,   36,   36,   36,   36,   36,
-       36,   40,   41,   44,   46,   47,   55,   48,   49,   50,
-       59,   42,   45,   59,   64,   60,   75,  165,   59,   76,
-       79,   56,   59,   51,   52,   86,   53,   66,  166,   37,
-       61,   67,   54,   71,   62,   68,   36,   36,   36,   36,
-       59,   65,   86,   59,   63,  163,  115,  164,   59,   72,
-
-       73,  116,   59,   73,   73,   73,   73,  418,  102,   73,
-       73,   73,   73,  423,  118,  155,   73,   73,   73,   73,
-       73,   74,   73,   97,  232,  124,   97,  103,  119,  108,
-      125,   97,  104,  144,  139,   97,  109,  139,  145,   73,
-      110,  174,  139,  208,  233,  180,  139,  414,  180,  422,
-      235,  175,  112,  180,  236,  209,  258,  180,  366,  368,
-      259,  401,  367,  421,  369,  402,   35,   35,  420,  419,
-      418,  417,  416,  415,  414,  413,  412,  411,  410,  409,
-      408,  407,  406,  405,  404,  403,  400,  400,  399,  398,
-      397,  396,  395,  394,  393,  392,  391,  390,  389,  388,
-
-      387,  386,  385,  384,  383,  181,  382,  381,  380,  379,
-      378,  377,  376,  375,  374,  373,  372,  145,  371,  370,
-      365,  364,  363,  362,  361,  360,  359,  358,  357,  356,
-      355,  354,  353,  352,  351,  350,  349,  348,  347,  346,
-      345,  344,  343,  342,  341,  340,  339,  338,  337,  336,
-      335,  334,  333,  332,  331,  330,  329,  328,  327,  326,
-      325,  324,  323,  322,  321,  320,  319,  318,  317,  316,
-      315,  314,  313,  312,  311,  310,  309,  308,  307,  306,
-      305,  304,  303,  302,  301,  300,  299,  298,  297,  296,
-      295,  294,  293,  292,  291,  290,  289,  288,  287,  286,
-
-      285,  284,  283,  282,  281,  112,  280,  145,  144,  279,
-      278,  277,  276,  275,  274,  273,  272,  271,  270,  269,
-      268,  267,  266,  265,  264,  263,  262,  261,  260,  257,
-      256,  255,  254,  253,  252,  177,  251,  250,  249,  248,
-      247,  246,  245,  244,  243,  242,  241,  240,  239,  238,
-      237,  234,  231,  230,  229,  228,  227,  144,  226,  225,
-      224,  195,  223,  222,  221,  220,  219,  218,  217,  216,
-      215,  214,  213,  212,  211,  210,  207,  206,  205,  204,
-      203,  112,  202,  201,  200,  199,  198,  197,  196,  195,
-      194,  193,  192,  191,   73,  190,  189,  188,  187,  186,
-
-      185,  184,  183,  182,  181,  179,  178,  177,  176,  173,
-      172,  171,  170,  169,  168,  167,  162,  161,  160,  159,
-      158,  157,  156,  154,  153,  152,  151,  150,  149,  148,
-      147,  146,  143,  142,  141,  140,  138,  137,  136,  135,
-      134,  133,  132,  131,  130,  129,  128,  127,  126,  123,
-      122,  121,  120,  117,   73,  114,  113,  112,  111,  107,
-      106,  105,  101,  100,   99,   98,   96,   95,   94,   93,
-       92,   91,   90,   89,   88,   86,   87,   85,   84,   83,
-       41,   82,   81,   80,   78,   77,   70,   69,   58,   57,
-       43,   39,   38,  424,    3,  424,  424,  424,  424,  424,
-
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424
+       12,    5,    5,    5,   13,   14,   15,   16,    5,    5,
+       17,   18,   19,   20,   21,   22,    5,   23,   24,    5,
+       23,   25,   26,   27,   28,   29,   30,   31,   32,   23,
+        5,   33,   34,    5,   36,   36,   36,   36,   36,   36,
+       36,   36,   40,   41,   44,   46,   47,   50,   48,   49,
+       55,   59,   42,   45,   59,   64,   87,   60,   80,   59,
+      103,   51,   52,   59,   53,   56,   76,  433,  109,   77,
+       54,   37,   61,   87,   66,  110,  438,   62,   67,  111,
+      104,   98,   68,   65,   98,  105,  117,   63,   71,   98,
+
+       74,  118,   72,   98,  215,   59,  159,   74,   59,   36,
+       36,   36,   36,   59,   73,  120,  216,   59,   74,   74,
+       74,   74,  179,  126,   74,   74,   74,   74,  127,  121,
+      134,   74,  180,   74,   74,   74,   74,   75,   74,  142,
+      147,  169,  142,  135,  113,  148,  167,  142,  168,  240,
+      185,  142,  170,  185,  429,  244,  246,  247,  185,  245,
+      269,  383,  185,  381,  270,  241,  384,  382,  416,  437,
+      242,  436,  417,   35,   35,  435,  434,  433,  432,  431,
+      430,  429,  428,  427,  426,  425,  424,  423,  422,  421,
+      420,  419,  418,  415,  415,  414,  413,  412,  411,  410,
+
+      409,  408,  407,  406,  405,  404,  403,  402,  401,  400,
+      399,  398,  186,  397,  396,  395,  394,  393,  392,  391,
+      390,  389,  388,  387,  148,  386,  385,  380,  379,  378,
+      377,  376,  375,  374,  373,  372,  371,  370,  369,  368,
+      367,  366,  365,  364,  363,  362,  361,  360,  359,  358,
+      357,  356,  355,  354,  353,  352,  351,  350,  349,  348,
+      347,  346,  345,  344,  343,  342,  341,  340,  339,  338,
+      337,  336,  335,  334,  333,  332,  331,  330,  329,  328,
+      327,  326,  325,  324,  323,  322,  321,  320,  319,  318,
+      317,  316,  315,  314,  313,  312,  311,  310,  309,  308,
+
+      307,  306,  305,  304,  303,  302,  301,  300,  299,  298,
+      297,  296,  295,  294,  293,  113,  292,  148,  147,  291,
+      290,  289,  288,  287,  286,  285,  284,  283,  282,  281,
+      280,  279,  278,  277,  276,  275,  274,  273,  272,  271,
+      268,  267,  266,  265,  264,  263,  182,  262,  261,  260,
+      259,  258,  257,  256,  255,  254,  253,  252,  251,  250,
+      249,  248,  243,  239,  238,  237,  236,  235,  147,  234,
+      233,  232,  201,  231,  230,  229,  228,  227,  226,  225,
+      224,  223,  222,  221,  220,  219,  218,  217,  214,  213,
+      212,  211,  210,  209,  113,  208,  207,  206,  205,  204,
+
+      203,  202,  201,  200,  199,  198,  197,   74,  196,  195,
+      194,  193,  192,  191,  190,  189,  188,  187,  186,  184,
+      183,  182,  181,  178,  177,  176,  175,  174,  173,  172,
+      171,  166,  165,  164,  163,  162,  161,  160,  158,  157,
+      156,  155,  154,  153,  152,  151,  150,  149,  146,  145,
+      144,  143,  141,  140,  139,  138,  137,  136,  133,  132,
+      131,  130,  129,  128,  125,  124,  123,  122,  119,   74,
+      116,  115,  114,  113,  112,  108,  107,  106,  102,  101,
+      100,   99,   97,   96,   95,   94,   93,   92,   91,   90,
+       89,   87,   88,   86,   85,   84,   41,   83,   82,   81,
+
+       79,   78,   70,   69,   58,   57,   43,   39,   38,  439,
+        3,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439
     } ;
 
-static yyconst flex_int16_t yy_chk[539] =
+static yyconst flex_int16_t yy_chk[556] =
     {   0,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
-        1,    1,    1,    9,    9,    9,    9,   10,   10,   10,
-       10,   15,   15,   17,   18,   18,   20,   18,   18,   19,
-       23,   15,   17,   23,   25,   24,   31,  125,   23,   31,
-      426,   20,   23,   19,   19,   46,   19,   26,  125,    9,
-       24,   26,   19,   29,   24,   26,   36,   36,   36,   36,
-       29,   25,   46,   29,   24,  124,   74,  124,   29,   29,
-
-       74,   74,   29,   30,   30,   30,   30,  423,   64,   30,
-       30,   30,   30,  422,   76,  115,  115,   30,   30,   30,
-       30,   30,   30,   59,  204,   82,   59,   64,   76,   68,
-       82,   59,   64,  102,   97,   59,   68,   97,  102,  116,
-       68,  133,   97,  174,  204,  139,   97,  421,  139,  420,
-      206,  133,  116,  139,  206,  174,  232,  139,  351,  355,
-      232,  392,  351,  419,  355,  392,  425,  425,  417,  416,
-      415,  412,  411,  410,  409,  408,  407,  406,  405,  404,
-      403,  402,  401,  399,  398,  394,  391,  390,  389,  388,
-      387,  386,  385,  384,  383,  382,  381,  380,  379,  378,
-
-      377,  375,  374,  373,  372,  371,  370,  369,  368,  367,
-      366,  365,  364,  363,  362,  360,  359,  358,  357,  356,
-      350,  349,  348,  347,  345,  344,  343,  342,  341,  340,
-      339,  337,  336,  335,  334,  333,  332,  331,  330,  329,
-      328,  327,  326,  325,  324,  322,  321,  319,  318,  316,
-      315,  314,  313,  312,  310,  309,  308,  306,  305,  304,
-      303,  302,  301,  300,  299,  298,  297,  296,  295,  294,
-      293,  292,  291,  290,  289,  287,  286,  285,  284,  283,
-      282,  281,  280,  279,  278,  277,  276,  275,  274,  273,
-      272,  271,  270,  269,  268,  267,  266,  265,  264,  263,
-
-      262,  261,  259,  258,  257,  256,  255,  254,  253,  252,
-      251,  250,  249,  248,  247,  246,  245,  244,  243,  242,
-      241,  240,  239,  238,  237,  236,  235,  234,  233,  231,
-      230,  229,  228,  227,  226,  225,  224,  223,  222,  221,
-      220,  218,  217,  216,  215,  214,  212,  210,  209,  208,
-      207,  205,  203,  202,  201,  200,  199,  198,  197,  196,
-      194,  193,  192,  191,  190,  189,  188,  187,  186,  185,
-      183,  182,  179,  178,  176,  175,  173,  172,  171,  170,
-      169,  168,  167,  166,  165,  164,  163,  162,  161,  160,
-      159,  158,  157,  156,  155,  154,  153,  151,  150,  149,
-
-      147,  146,  143,  142,  140,  138,  137,  135,  134,  132,
-      131,  130,  129,  128,  127,  126,  123,  122,  121,  120,
-      119,  118,  117,  114,  113,  111,  110,  109,  108,  107,
-      106,  105,  101,  100,   99,   98,   96,   95,   94,   93,
-       92,   91,   90,   89,   88,   87,   85,   84,   83,   81,
-       80,   78,   77,   75,   73,   72,   71,   70,   69,   67,
-       66,   65,   63,   62,   61,   60,   58,   57,   56,   55,
-       54,   52,   51,   50,   49,   48,   47,   45,   44,   43,
-       42,   40,   39,   38,   33,   32,   28,   27,   22,   21,
-       16,   14,   13,    3,  424,  424,  424,  424,  424,  424,
-
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424,  424,  424,
-      424,  424,  424,  424,  424,  424,  424,  424
+        1,    1,    1,    1,    9,    9,    9,    9,   10,   10,
+       10,   10,   15,   15,   17,   18,   18,   19,   18,   18,
+       20,   23,   15,   17,   23,   25,   46,   24,  441,   23,
+       64,   19,   19,   23,   19,   20,   31,  438,   68,   31,
+       19,    9,   24,   46,   26,   68,  437,   24,   26,   68,
+       64,   59,   26,   25,   59,   64,   75,   24,   29,   59,
+
+       75,   75,   29,   59,  179,   29,  117,  117,   29,   36,
+       36,   36,   36,   29,   29,   77,  179,   29,   30,   30,
+       30,   30,  136,   83,   30,   30,   30,   30,   83,   77,
+       91,  118,  136,   30,   30,   30,   30,   30,   30,   98,
+      103,  127,   98,   91,  118,  103,  126,   98,  126,  210,
+      142,   98,  127,  142,  436,  212,  213,  213,  142,  212,
+      240,  370,  142,  366,  240,  210,  370,  366,  407,  435,
+      210,  434,  407,  440,  440,  432,  431,  430,  427,  426,
+      425,  424,  423,  422,  421,  420,  419,  418,  417,  416,
+      414,  413,  409,  406,  405,  404,  403,  402,  401,  400,
+
+      399,  398,  397,  396,  395,  394,  393,  392,  390,  389,
+      388,  387,  386,  385,  384,  383,  382,  381,  380,  379,
+      378,  377,  375,  374,  373,  372,  371,  365,  364,  363,
+      362,  360,  359,  358,  357,  356,  355,  354,  352,  351,
+      350,  349,  348,  347,  346,  345,  344,  342,  341,  340,
+      339,  338,  336,  335,  333,  332,  330,  329,  328,  327,
+      326,  324,  323,  322,  320,  319,  318,  317,  316,  315,
+      314,  313,  312,  311,  310,  309,  308,  307,  306,  305,
+      304,  303,  302,  300,  299,  298,  297,  296,  295,  294,
+      293,  292,  291,  290,  289,  288,  287,  286,  285,  284,
+
+      283,  282,  281,  280,  279,  278,  277,  276,  275,  274,
+      273,  271,  270,  269,  268,  267,  266,  265,  264,  263,
+      262,  261,  260,  259,  258,  257,  256,  255,  254,  253,
+      252,  251,  250,  249,  248,  245,  244,  243,  242,  241,
+      239,  238,  237,  236,  235,  234,  233,  232,  231,  230,
+      229,  227,  225,  224,  223,  222,  221,  219,  217,  216,
+      215,  214,  211,  209,  208,  207,  206,  205,  204,  203,
+      202,  200,  199,  198,  197,  196,  195,  194,  193,  192,
+      191,  190,  188,  187,  184,  183,  181,  180,  178,  177,
+      176,  175,  174,  173,  172,  171,  170,  169,  168,  167,
+
+      166,  165,  164,  163,  162,  161,  160,  159,  158,  157,
+      156,  154,  153,  152,  150,  149,  146,  145,  143,  141,
+      140,  138,  137,  135,  134,  133,  132,  131,  130,  129,
+      128,  125,  124,  123,  122,  121,  120,  119,  116,  115,
+      114,  112,  111,  110,  109,  108,  107,  106,  102,  101,
+      100,   99,   97,   96,   95,   94,   93,   92,   90,   89,
+       88,   86,   85,   84,   82,   81,   79,   78,   76,   74,
+       73,   72,   71,   70,   69,   67,   66,   65,   63,   62,
+       61,   60,   58,   57,   56,   55,   54,   52,   51,   50,
+       49,   48,   47,   45,   44,   43,   42,   40,   39,   38,
+
+       33,   32,   28,   27,   22,   21,   16,   14,   13,    3,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439,  439,  439,  439,  439,  439,
+      439,  439,  439,  439,  439
     } ;
 
 static yy_state_type yy_last_accepting_state;
@@ -726,6 +735,7 @@ char *parse_events_text;
 #include <errno.h>
 #include "../perf.h"
 #include "parse-events-bison.h"
+#include "parse-events.h"
 
 static int __value(char *str, int base, int token)
 {
@@ -762,7 +772,13 @@ static int sym(int type, int config)
 	return PE_VALUE_SYM;
 }
 
-#line 766 "<stdout>"
+static int term(int type)
+{
+	parse_events_lval.num = type;
+	return PE_TERM;
+}
+
+#line 782 "<stdout>"
 
 #define INITIAL 0
 
@@ -944,9 +960,9 @@ YY_DECL
 	register char *yy_cp, *yy_bp;
 	register int yy_act;
     
-#line 53 "util/parse-events.l"
+#line 60 "util/parse-events.l"
 
-#line 950 "<stdout>"
+#line 966 "<stdout>"
 
 	if ( !(yy_init) )
 		{
@@ -999,13 +1015,13 @@ yy_match:
 			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 				{
 				yy_current_state = (int) yy_def[yy_current_state];
-				if ( yy_current_state >= 425 )
+				if ( yy_current_state >= 440 )
 					yy_c = yy_meta[(unsigned int) yy_c];
 				}
 			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
 			++yy_cp;
 			}
-		while ( yy_base[yy_current_state] != 495 );
+		while ( yy_base[yy_current_state] != 511 );
 
 yy_find_action:
 		yy_act = yy_accept[yy_current_state];
@@ -1031,192 +1047,223 @@ do_action:	/* This label is used only to access EOF actions. */
 
 case 1:
 YY_RULE_SETUP
-#line 54 "util/parse-events.l"
+#line 61 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
 	YY_BREAK
 case 2:
 YY_RULE_SETUP
-#line 55 "util/parse-events.l"
+#line 62 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
 	YY_BREAK
 case 3:
 YY_RULE_SETUP
-#line 56 "util/parse-events.l"
+#line 63 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
 	YY_BREAK
 case 4:
 YY_RULE_SETUP
-#line 57 "util/parse-events.l"
+#line 64 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
 	YY_BREAK
 case 5:
 YY_RULE_SETUP
-#line 58 "util/parse-events.l"
+#line 65 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
 	YY_BREAK
 case 6:
 YY_RULE_SETUP
-#line 59 "util/parse-events.l"
+#line 66 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
 	YY_BREAK
 case 7:
 YY_RULE_SETUP
-#line 60 "util/parse-events.l"
+#line 67 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
 	YY_BREAK
 case 8:
 YY_RULE_SETUP
-#line 61 "util/parse-events.l"
+#line 68 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
 	YY_BREAK
 case 9:
 YY_RULE_SETUP
-#line 62 "util/parse-events.l"
+#line 69 "util/parse-events.l"
 { return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
 	YY_BREAK
 case 10:
 YY_RULE_SETUP
-#line 63 "util/parse-events.l"
+#line 70 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
 	YY_BREAK
 case 11:
 YY_RULE_SETUP
-#line 64 "util/parse-events.l"
+#line 71 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
 	YY_BREAK
 case 12:
 YY_RULE_SETUP
-#line 65 "util/parse-events.l"
+#line 72 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
 	YY_BREAK
 case 13:
 YY_RULE_SETUP
-#line 66 "util/parse-events.l"
+#line 73 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MIN); }
 	YY_BREAK
 case 14:
 YY_RULE_SETUP
-#line 67 "util/parse-events.l"
+#line 74 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS_MAJ); }
 	YY_BREAK
 case 15:
 YY_RULE_SETUP
-#line 68 "util/parse-events.l"
+#line 75 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES); }
 	YY_BREAK
 case 16:
 YY_RULE_SETUP
-#line 69 "util/parse-events.l"
+#line 76 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
 	YY_BREAK
 case 17:
 YY_RULE_SETUP
-#line 70 "util/parse-events.l"
+#line 77 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
 	YY_BREAK
 case 18:
 YY_RULE_SETUP
-#line 71 "util/parse-events.l"
+#line 78 "util/parse-events.l"
 { return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
 	YY_BREAK
 case 19:
-#line 74 "util/parse-events.l"
+#line 81 "util/parse-events.l"
 case 20:
-#line 75 "util/parse-events.l"
+#line 82 "util/parse-events.l"
 case 21:
-#line 76 "util/parse-events.l"
+#line 83 "util/parse-events.l"
 case 22:
-#line 77 "util/parse-events.l"
+#line 84 "util/parse-events.l"
 case 23:
-#line 78 "util/parse-events.l"
+#line 85 "util/parse-events.l"
 case 24:
-#line 79 "util/parse-events.l"
+#line 86 "util/parse-events.l"
 case 25:
 YY_RULE_SETUP
-#line 79 "util/parse-events.l"
+#line 86 "util/parse-events.l"
 { return str(PE_NAME_CACHE_TYPE); }
 	YY_BREAK
 case 26:
-#line 82 "util/parse-events.l"
+#line 89 "util/parse-events.l"
 case 27:
-#line 83 "util/parse-events.l"
+#line 90 "util/parse-events.l"
 case 28:
-#line 84 "util/parse-events.l"
+#line 91 "util/parse-events.l"
 case 29:
-#line 85 "util/parse-events.l"
+#line 92 "util/parse-events.l"
 case 30:
-#line 86 "util/parse-events.l"
+#line 93 "util/parse-events.l"
 case 31:
 YY_RULE_SETUP
-#line 86 "util/parse-events.l"
+#line 93 "util/parse-events.l"
 { return str(PE_NAME_CACHE_OP_RESULT); }
 	YY_BREAK
+/*
+	 * These are event config hardcoded term names to be specified
+	 * within xxx/.../ syntax. So far we dont clash with other names,
+	 * so we can put them here directly. In case the we have a conflict
+	 * in future, this needs to go into '//' condition block.
+	 */
 case 32:
 YY_RULE_SETUP
-#line 88 "util/parse-events.l"
-{ return PE_PREFIX_MEM; }
+#line 101 "util/parse-events.l"
+{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
 	YY_BREAK
 case 33:
 YY_RULE_SETUP
-#line 89 "util/parse-events.l"
-{ return raw(); }
+#line 102 "util/parse-events.l"
+{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 	YY_BREAK
 case 34:
 YY_RULE_SETUP
-#line 90 "util/parse-events.l"
-{ return value(10); }
+#line 103 "util/parse-events.l"
+{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 	YY_BREAK
 case 35:
 YY_RULE_SETUP
-#line 91 "util/parse-events.l"
-{ return value(16); }
+#line 104 "util/parse-events.l"
+{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 	YY_BREAK
 case 36:
 YY_RULE_SETUP
-#line 93 "util/parse-events.l"
-{ return str(PE_MODIFIER_EVENT); }
+#line 105 "util/parse-events.l"
+{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 	YY_BREAK
 case 37:
 YY_RULE_SETUP
-#line 94 "util/parse-events.l"
-{ return str(PE_MODIFIER_BP); }
+#line 107 "util/parse-events.l"
+{ return PE_PREFIX_MEM; }
 	YY_BREAK
 case 38:
 YY_RULE_SETUP
-#line 95 "util/parse-events.l"
-{ return str(PE_NAME); }
+#line 108 "util/parse-events.l"
+{ return raw(); }
 	YY_BREAK
 case 39:
 YY_RULE_SETUP
-#line 96 "util/parse-events.l"
-{ return '/'; }
+#line 109 "util/parse-events.l"
+{ return value(10); }
 	YY_BREAK
 case 40:
 YY_RULE_SETUP
-#line 97 "util/parse-events.l"
-{ return '-'; }
+#line 110 "util/parse-events.l"
+{ return value(16); }
 	YY_BREAK
 case 41:
 YY_RULE_SETUP
-#line 98 "util/parse-events.l"
-{ return ','; }
+#line 112 "util/parse-events.l"
+{ return str(PE_MODIFIER_EVENT); }
 	YY_BREAK
 case 42:
 YY_RULE_SETUP
-#line 99 "util/parse-events.l"
-{ return ':'; }
+#line 113 "util/parse-events.l"
+{ return str(PE_MODIFIER_BP); }
 	YY_BREAK
 case 43:
 YY_RULE_SETUP
-#line 100 "util/parse-events.l"
-{ return '='; }
+#line 114 "util/parse-events.l"
+{ return str(PE_NAME); }
 	YY_BREAK
 case 44:
 YY_RULE_SETUP
-#line 102 "util/parse-events.l"
+#line 115 "util/parse-events.l"
+{ return '/'; }
+	YY_BREAK
+case 45:
+YY_RULE_SETUP
+#line 116 "util/parse-events.l"
+{ return '-'; }
+	YY_BREAK
+case 46:
+YY_RULE_SETUP
+#line 117 "util/parse-events.l"
+{ return ','; }
+	YY_BREAK
+case 47:
+YY_RULE_SETUP
+#line 118 "util/parse-events.l"
+{ return ':'; }
+	YY_BREAK
+case 48:
+YY_RULE_SETUP
+#line 119 "util/parse-events.l"
+{ return '='; }
+	YY_BREAK
+case 49:
+YY_RULE_SETUP
+#line 121 "util/parse-events.l"
 ECHO;
 	YY_BREAK
-#line 1220 "<stdout>"
+#line 1267 "<stdout>"
 case YY_STATE_EOF(INITIAL):
 	yyterminate();
 
@@ -1508,7 +1555,7 @@ static int yy_get_next_buffer (void)
 		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 			{
 			yy_current_state = (int) yy_def[yy_current_state];
-			if ( yy_current_state >= 425 )
+			if ( yy_current_state >= 440 )
 				yy_c = yy_meta[(unsigned int) yy_c];
 			}
 		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
@@ -1536,11 +1583,11 @@ static int yy_get_next_buffer (void)
 	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 		{
 		yy_current_state = (int) yy_def[yy_current_state];
-		if ( yy_current_state >= 425 )
+		if ( yy_current_state >= 440 )
 			yy_c = yy_meta[(unsigned int) yy_c];
 		}
 	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
-	yy_is_jam = (yy_current_state == 424);
+	yy_is_jam = (yy_current_state == 439);
 
 	return yy_is_jam ? 0 : yy_current_state;
 }
@@ -2214,7 +2261,7 @@ void parse_events_free (void * ptr )
 
 #define YYTABLES_NAME "yytables"
 
-#line 102 "util/parse-events.l"
+#line 121 "util/parse-events.l"
 
 
 
diff --git a/tools/perf/util/parse-events-flex.h b/tools/perf/util/parse-events-flex.h
index b927f9a..ceb9b20 100644
--- a/tools/perf/util/parse-events-flex.h
+++ b/tools/perf/util/parse-events-flex.h
@@ -308,7 +308,7 @@ extern int parse_events_lex (void);
 #undef YY_DECL
 #endif
 
-#line 102 "util/parse-events.l"
+#line 121 "util/parse-events.l"
 
 
 #line 315 "util/parse-events-flex.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6e50b91..59f5cf6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -588,15 +588,60 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-int
-parse_events_add_numeric(struct list_head *list, int *idx,
-			 unsigned long type, unsigned long config)
+static int config_term(struct perf_event_attr *attr,
+		       struct parse_events__term *term)
+{
+	switch (term->type) {
+	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+		attr->config = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
+		attr->config1 = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
+		attr->config2 = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
+		attr->sample_period = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
+		/*
+		 * TODO uncomment when the field is available
+		 * attr->branch_sample_type = term->val.num;
+		 */
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int config_attr(struct perf_event_attr *attr,
+		       struct list_head *head, int fail)
+{
+	struct parse_events__term *term;
+
+	list_for_each_entry(term, head, list)
+		if (config_term(attr, term) && fail)
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
+	    config_attr(&attr, head_config, 1))
+		return -EINVAL;
+
 	return add_event(list, idx, &attr,
 			 (char *) __event_name(type, config));
 }
@@ -923,3 +968,51 @@ void print_events(const char *event_glob)
 
 	print_tracepoint_events(NULL, NULL);
 }
+
+int parse_events__is_hardcoded_term(struct parse_events__term *term)
+{
+	return term->type <= PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX;
+}
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
+	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
+	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
+	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
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
index 84d3771..37a270d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,6 +33,34 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+enum {
+	PARSE_EVENTS__TERM_TYPE_CONFIG,
+	PARSE_EVENTS__TERM_TYPE_CONFIG1,
+	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
+	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_NUM,
+	PARSE_EVENTS__TERM_TYPE_STR,
+
+	PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX =
+		PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
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
+int parse_events__is_hardcoded_term(struct parse_events__term *term);
+int parse_events__new_term(struct parse_events__term **term, int type,
+			   char *config, char *str, long num);
+void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event);
@@ -40,7 +68,8 @@ int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
 			 unsigned long config1, unsigned long config2,
 			 char *mod);
 int parse_events_add_numeric(struct list_head *list, int *idx,
-			     unsigned long type, unsigned long config);
+			     unsigned long type, unsigned long config,
+			     struct list_head *head_config);
 int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 44dbc35..ab9eca1 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -5,6 +5,7 @@
 #include <errno.h>
 #include "../perf.h"
 #include "parse-events-bison.h"
+#include "parse-events.h"
 
 static int __value(char *str, int base, int token)
 {
@@ -41,6 +42,12 @@ static int sym(int type, int config)
 	return PE_VALUE_SYM;
 }
 
+static int term(int type)
+{
+	parse_events_lval.num = type;
+	return PE_TERM;
+}
+
 %}
 
 num_dec		[0-9]+
@@ -85,6 +92,18 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
 
+	/*
+	 * These are event config hardcoded term names to be specified
+	 * within xxx/.../ syntax. So far we dont clash with other names,
+	 * so we can put them here directly. In case the we have a conflict
+	 * in future, this needs to go into '//' condition block.
+	 */
+config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
+config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
+config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
+branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+
 mem:			{ return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4b4459e..c88c08e 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -23,7 +23,7 @@ do { \
 
 %}
 
-%token PE_VALUE PE_VALUE_SYM PE_RAW
+%token PE_VALUE PE_VALUE_SYM PE_RAW PE_TERM
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
@@ -32,16 +32,21 @@ do { \
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM
 %type <num> PE_RAW
+%type <num> PE_TERM
 %type <str> PE_NAME
 %type <str> PE_NAME_CACHE_TYPE
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
 
@@ -56,7 +61,7 @@ event_def PE_MODIFIER_EVENT
 |
 event_def
 
-event_def: event_legacy_symbol sep_dc |
+event_def: event_legacy_symbol |
 	   event_legacy_cache sep_dc |
 	   event_legacy_mem |
 	   event_legacy_tracepoint sep_dc |
@@ -64,12 +69,21 @@ event_def: event_legacy_symbol sep_dc |
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
@@ -108,17 +122,85 @@ PE_NAME ':' PE_NAME
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
+}
+|
+PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+		 $1, NULL, 1));
+	$$ = term;
+}
+|
+PE_TERM '=' PE_VALUE
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, $3));
+	$$ = term;
+}
+|
+PE_TERM
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, 1));
+	$$ = term;
 }
 
 sep_dc: ':' |
 
+sep_slash_dc: '/' | ':' |
+
 %%
 
 void parse_events_error(struct list_head *list __used, int *idx __used,
-- 
1.7.4.4

