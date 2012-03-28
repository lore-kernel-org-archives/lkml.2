Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab2C1P6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445Ab2C1P6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:58:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/5] perf, tool: Add list type for event term parsing
Date: Wed, 28 Mar 2012 17:55:51 +0200
Message-Id: <1332950153-8606-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
References: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding list type for event term to hanle multiple values
for single term. Term values can be now cpecified via
following grammar:

  event_term_list: event_term_list '|' event_term_elem
  event_term_list: event_term_elem '|' event_term_elem
  event_term_elem: PE_NAME | PE_VALUE

eg.:
  ...,term=str1|str2|num1|num2,...

This is going to be used for branch_type term in future.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-bison.c |  808 ++++++++++++++++++----------------
 tools/perf/util/parse-events-bison.h |   16 +-
 tools/perf/util/parse-events-flex.c  |  545 ++++++++++++------------
 tools/perf/util/parse-events-flex.h  |    2 +-
 tools/perf/util/parse-events.c       |   58 +++-
 tools/perf/util/parse-events.h       |   23 +-
 tools/perf/util/parse-events.l       |    1 +
 tools/perf/util/parse-events.y       |   85 +++-
 8 files changed, 846 insertions(+), 692 deletions(-)

diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index d76bb99..02029ed 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -1,8 +1,9 @@
-/* A Bison parser, made by GNU Bison 2.5.  */
+/* A Bison parser, made by GNU Bison 2.4.3.  */
 
-/* Bison implementation for Yacc-like parsers in C
+/* Skeleton implementation for Bison's Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -44,7 +45,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.5"
+#define YYBISON_VERSION "2.4.3"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -73,7 +74,7 @@
 
 /* Copy the first part of user declarations.  */
 
-/* Line 268 of yacc.c  */
+/* Line 189 of yacc.c  */
 #line 7 "util/parse-events.y"
 
 
@@ -95,8 +96,8 @@ do { \
 
 
 
-/* Line 268 of yacc.c  */
-#line 100 "util/parse-events-bison.c"
+/* Line 189 of yacc.c  */
+#line 101 "util/parse-events-bison.c"
 
 /* Enabling traces.  */
 #ifndef YYDEBUG
@@ -144,18 +145,19 @@ do { \
 typedef union YYSTYPE
 {
 
-/* Line 293 of yacc.c  */
-#line 46 "util/parse-events.y"
+/* Line 214 of yacc.c  */
+#line 48 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
 	struct list_head *head;
 	struct parse_events__term *term;
+	struct parse_events__term_elem *elem;
 
 
 
-/* Line 293 of yacc.c  */
-#line 159 "util/parse-events-bison.c"
+/* Line 214 of yacc.c  */
+#line 161 "util/parse-events-bison.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -166,8 +168,8 @@ typedef union YYSTYPE
 /* Copy the second part of user declarations.  */
 
 
-/* Line 343 of yacc.c  */
-#line 171 "util/parse-events-bison.c"
+/* Line 264 of yacc.c  */
+#line 173 "util/parse-events-bison.c"
 
 #ifdef short
 # undef short
@@ -270,11 +272,11 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
+#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#     ifndef EXIT_SUCCESS
-#      define EXIT_SUCCESS 0
+#     ifndef _STDLIB_H
+#      define _STDLIB_H 1
 #     endif
 #    endif
 #   endif
@@ -297,24 +299,24 @@ YYID (yyi)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
 #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
 #  endif
-#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
+#  if (defined __cplusplus && ! defined _STDLIB_H \
        && ! ((defined YYMALLOC || defined malloc) \
 	     && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#   ifndef EXIT_SUCCESS
-#    define EXIT_SUCCESS 0
+#   ifndef _STDLIB_H
+#    define _STDLIB_H 1
 #   endif
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
@@ -343,7 +345,23 @@ union yyalloc
      ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
       + YYSTACK_GAP_MAXIMUM)
 
-# define YYCOPY_NEEDED 1
+/* Copy COUNT objects from FROM to TO.  The source and destination do
+   not overlap.  */
+# ifndef YYCOPY
+#  if defined __GNUC__ && 1 < __GNUC__
+#   define YYCOPY(To, From, Count) \
+      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#  else
+#   define YYCOPY(To, From, Count)		\
+      do					\
+	{					\
+	  YYSIZE_T yyi;				\
+	  for (yyi = 0; yyi < (Count); yyi++)	\
+	    (To)[yyi] = (From)[yyi];		\
+	}					\
+      while (YYID (0))
+#  endif
+# endif
 
 /* Relocate STACK from its old location to the new one.  The
    local variables YYSIZE and YYSTACKSIZE give the old and new number of
@@ -363,39 +381,19 @@ union yyalloc
 
 #endif
 
-#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
-/* Copy COUNT objects from FROM to TO.  The source and destination do
-   not overlap.  */
-# ifndef YYCOPY
-#  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
-#  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
-      while (YYID (0))
-#  endif
-# endif
-#endif /* !YYCOPY_NEEDED */
-
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  25
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   44
+#define YYLAST   57
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  20
+#define YYNTOKENS  21
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  15
+#define YYNNTS  17
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  36
+#define YYNRULES  41
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  58
+#define YYNSTATES  66
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
@@ -419,7 +417,7 @@ static const yytype_uint8 yytranslate[] =
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
-       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,    20,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
        2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
@@ -444,33 +442,36 @@ static const yytype_uint8 yyprhs[] =
        0,     0,     3,     7,     9,    12,    14,    16,    18,    21,
       23,    26,    29,    32,    37,    42,    45,    51,    55,    57,
       63,    67,    71,    75,    77,    81,    83,    87,    91,    93,
-      97,   101,   103,   105,   106,   108,   110
+      97,   101,   105,   107,   111,   115,   117,   119,   121,   122,
+     124,   126
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      21,     0,    -1,    21,    15,    22,    -1,    22,    -1,    23,
-       8,    -1,    23,    -1,    24,    -1,    25,    -1,    26,    33,
-      -1,    27,    -1,    28,    33,    -1,    29,    33,    -1,    30,
-      33,    -1,     7,    16,    31,    16,    -1,     4,    16,    31,
-      16,    -1,     4,    34,    -1,    10,    17,    11,    17,    11,
+      22,     0,    -1,    22,    15,    23,    -1,    23,    -1,    24,
+       8,    -1,    24,    -1,    25,    -1,    26,    -1,    27,    36,
+      -1,    28,    -1,    29,    36,    -1,    30,    36,    -1,    31,
+      36,    -1,     7,    16,    32,    16,    -1,     4,    16,    32,
+      16,    -1,     4,    37,    -1,    10,    17,    11,    17,    11,
       -1,    10,    17,    11,    -1,    10,    -1,    12,     3,    18,
-       9,    33,    -1,    12,     3,    33,    -1,     7,    18,     7,
-      -1,     3,    18,     3,    -1,     5,    -1,    31,    15,    32,
-      -1,    32,    -1,     7,    19,     7,    -1,     7,    19,     3,
+       9,    36,    -1,    12,     3,    36,    -1,     7,    18,     7,
+      -1,     3,    18,     3,    -1,     5,    -1,    32,    15,    33,
+      -1,    33,    -1,     7,    19,     7,    -1,     7,    19,     3,
       -1,     7,    -1,     6,    19,     7,    -1,     6,    19,     3,
-      -1,     6,    -1,    18,    -1,    -1,    16,    -1,    18,    -1,
-      -1
+      -1,     6,    19,    34,    -1,     6,    -1,    34,    20,    35,
+      -1,    35,    20,    35,    -1,     7,    -1,     3,    -1,    18,
+      -1,    -1,    16,    -1,    18,    -1,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
-static const yytype_uint8 yyrline[] =
+static const yytype_uint16 yyrline[] =
 {
-       0,    55,    55,    55,    58,    69,    74,    75,    76,    77,
-      78,    79,    80,    83,    90,    99,   108,   113,   118,   124,
-     129,   135,   141,   147,   153,   163,   175,   186,   197,   208,
-     218,   228,   238,   238,   240,   240,   240
+       0,    58,    58,    58,    61,    72,    77,    78,    79,    80,
+      81,    82,    83,    86,    93,   102,   111,   116,   121,   127,
+     132,   138,   144,   150,   156,   166,   178,   187,   196,   205,
+     214,   222,   231,   240,   249,   263,   272,   281,   281,   283,
+     283,   283
 };
 #endif
 
@@ -482,11 +483,12 @@ static const char *const yytname[] =
   "$end", "error", "$undefined", "PE_VALUE", "PE_VALUE_SYM", "PE_RAW",
   "PE_TERM", "PE_NAME", "PE_MODIFIER_EVENT", "PE_MODIFIER_BP",
   "PE_NAME_CACHE_TYPE", "PE_NAME_CACHE_OP_RESULT", "PE_PREFIX_MEM",
-  "PE_PREFIX_RAW", "PE_ERROR", "','", "'/'", "'-'", "':'", "'='",
+  "PE_PREFIX_RAW", "PE_ERROR", "','", "'/'", "'-'", "':'", "'='", "'|'",
   "$accept", "events", "event", "event_def", "event_pmu",
   "event_legacy_symbol", "event_legacy_cache", "event_legacy_mem",
   "event_legacy_tracepoint", "event_legacy_numeric", "event_legacy_raw",
-  "event_config", "event_term", "sep_dc", "sep_slash_dc", 0
+  "event_config", "event_term", "event_term_list", "event_term_elem",
+  "sep_dc", "sep_slash_dc", 0
 };
 #endif
 
@@ -496,17 +498,19 @@ static const char *const yytname[] =
 static const yytype_uint16 yytoknum[] =
 {
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
-     265,   266,   267,   268,   269,    44,    47,    45,    58,    61
+     265,   266,   267,   268,   269,    44,    47,    45,    58,    61,
+     124
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    20,    21,    21,    22,    22,    23,    23,    23,    23,
-      23,    23,    23,    24,    25,    25,    26,    26,    26,    27,
-      27,    28,    29,    30,    31,    31,    32,    32,    32,    32,
-      32,    32,    33,    33,    34,    34,    34
+       0,    21,    22,    22,    23,    23,    24,    24,    24,    24,
+      24,    24,    24,    25,    26,    26,    27,    27,    27,    28,
+      28,    29,    30,    31,    32,    32,    33,    33,    33,    33,
+      33,    33,    33,    34,    34,    35,    35,    36,    36,    37,
+      37,    37
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -515,87 +519,88 @@ static const yytype_uint8 yyr2[] =
        0,     2,     3,     1,     2,     1,     1,     1,     2,     1,
        2,     2,     2,     4,     4,     2,     5,     3,     1,     5,
        3,     3,     3,     1,     3,     1,     3,     3,     1,     3,
-       3,     1,     1,     0,     1,     1,     0
+       3,     3,     1,     3,     3,     1,     1,     1,     0,     1,
+       1,     0
 };
 
-/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
-   Performed when YYTABLE doesn't specify something else to do.  Zero
+/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
+   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       0,     0,    36,    23,     0,    18,     0,     0,     3,     5,
-       6,     7,    33,     9,    33,    33,    33,     0,    34,    35,
-      15,     0,     0,     0,    33,     1,     0,     4,    32,     8,
-      10,    11,    12,    22,    31,    28,     0,    25,     0,    21,
-      17,    32,    20,     2,     0,     0,     0,    14,    13,     0,
-      33,    30,    29,    27,    26,    24,    16,    19
+       0,     0,    41,    23,     0,    18,     0,     0,     3,     5,
+       6,     7,    38,     9,    38,    38,    38,     0,    39,    40,
+      15,     0,     0,     0,    38,     1,     0,     4,    37,     8,
+      10,    11,    12,    22,    32,    28,     0,    25,     0,    21,
+      17,    37,    20,     2,     0,     0,     0,    14,    13,     0,
+      38,    30,    29,    31,     0,    27,    26,    24,    16,    19,
+       0,     0,    36,    35,    33,    34
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
       -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
-      16,    36,    37,    29,    20
+      16,    36,    37,    53,    54,    29,    20
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -15
+#define YYPACT_NINF -31
 static const yytype_int8 yypact[] =
 {
-       1,    -4,    -9,   -15,     4,     0,    18,     3,   -15,    19,
-     -15,   -15,    14,   -15,    14,    14,    14,    27,    17,   -15,
-     -15,    17,    24,    22,    16,   -15,     1,   -15,   -15,   -15,
-     -15,   -15,   -15,   -15,    20,    21,    10,   -15,    13,   -15,
-      25,    26,   -15,   -15,     9,    12,    17,   -15,   -15,    30,
-      14,   -15,   -15,   -15,   -15,   -15,   -15,   -15
+       1,    -4,    -9,   -31,     4,    15,    24,     3,   -31,    25,
+     -31,   -31,    16,   -31,    16,    16,    16,    32,    17,   -31,
+     -31,    17,    30,    27,    21,   -31,     1,   -31,   -31,   -31,
+     -31,   -31,   -31,   -31,    22,    23,    10,   -31,    13,   -31,
+      26,    31,   -31,   -31,     9,    12,    17,   -31,   -31,    33,
+      16,    28,    29,    34,    35,   -31,   -31,   -31,   -31,   -31,
+      14,    14,   -31,   -31,   -31,   -31
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -15,   -15,    11,   -15,   -15,   -15,   -15,   -15,   -15,   -15,
-     -15,    23,    -8,   -14,   -15
+     -31,   -31,    19,   -31,   -31,   -31,   -31,   -31,   -31,   -31,
+     -31,    36,     0,   -31,   -30,   -14,   -31
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -1
-static const yytype_uint8 yytable[] =
+   number is the opposite.  If zero, do what YYDEFACT says.
+   If YYTABLE_NINF, syntax error.  */
+#define YYTABLE_NINF -37
+static const yytype_int8 yytable[] =
 {
       30,    31,    32,    25,     1,     2,     3,    18,     4,    19,
-      42,     5,    51,     6,    17,    53,    52,    23,    26,    54,
-      21,    24,    22,    34,    35,    46,    47,    27,    46,    48,
-      33,    39,    28,    40,    41,    50,    57,    43,    55,    44,
-      45,    56,    49,     0,    38
+      42,     5,    51,     6,    17,    55,    52,    62,    26,    56,
+      21,    63,    22,    34,    35,    46,    47,    24,    46,    48,
+      64,    65,    23,    27,    28,    33,    59,    39,    40,    41,
+      50,    44,    45,    49,    58,    43,    57,     0,   -36,   -35,
+       0,     0,     0,     0,    60,    61,     0,    38
 };
 
-#define yypact_value_is_default(yystate) \
-  ((yystate) == (-15))
-
-#define yytable_value_is_error(yytable_value) \
-  YYID (0)
-
 static const yytype_int8 yycheck[] =
 {
       14,    15,    16,     0,     3,     4,     5,    16,     7,    18,
-      24,    10,     3,    12,    18,     3,     7,    17,    15,     7,
-      16,     3,    18,     6,     7,    15,    16,     8,    15,    16,
-       3,     7,    18,    11,    18,     9,    50,    26,    46,    19,
-      19,    11,    17,    -1,    21
+      24,    10,     3,    12,    18,     3,     7,     3,    15,     7,
+      16,     7,    18,     6,     7,    15,    16,     3,    15,    16,
+      60,    61,    17,     8,    18,     3,    50,     7,    11,    18,
+       9,    19,    19,    17,    11,    26,    46,    -1,    20,    20,
+      -1,    -1,    -1,    -1,    20,    20,    -1,    21
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,     4,     5,     7,    10,    12,    21,    22,    23,
-      24,    25,    26,    27,    28,    29,    30,    18,    16,    18,
-      34,    16,    18,    17,     3,     0,    15,     8,    18,    33,
-      33,    33,    33,     3,     6,     7,    31,    32,    31,     7,
-      11,    18,    33,    22,    19,    19,    15,    16,    16,    17,
-       9,     3,     7,     3,     7,    32,    11,    33
+       0,     3,     4,     5,     7,    10,    12,    22,    23,    24,
+      25,    26,    27,    28,    29,    30,    31,    18,    16,    18,
+      37,    16,    18,    17,     3,     0,    15,     8,    18,    36,
+      36,    36,    36,     3,     6,     7,    32,    33,    32,     7,
+      11,    18,    36,    23,    19,    19,    15,    16,    16,    17,
+       9,     3,     7,    34,    35,     3,     7,    33,    11,    36,
+      20,    20,     3,     7,    35,    35
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -631,6 +636,7 @@ do								\
     {								\
       yychar = (Token);						\
       yylval = (Value);						\
+      yytoken = YYTRANSLATE (yychar);				\
       YYPOPSTACK (1);						\
       goto yybackup;						\
     }								\
@@ -672,10 +678,19 @@ while (YYID (0))
 #endif
 
 
-/* This macro is provided for backward compatibility. */
+/* YY_LOCATION_PRINT -- Print the location on the stream.
+   This macro was not mandated originally: define only if we know
+   we won't break user code: when these are the locations we know.  */
 
 #ifndef YY_LOCATION_PRINT
-# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
+# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
+#  define YY_LOCATION_PRINT(File, Loc)			\
+     fprintf (File, "%d.%d-%d.%d",			\
+	      (Loc).first_line, (Loc).first_column,	\
+	      (Loc).last_line,  (Loc).last_column)
+# else
+#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
+# endif
 #endif
 
 
@@ -879,6 +894,7 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif
 
+
 
 #if YYERROR_VERBOSE
 
@@ -981,142 +997,115 @@ yytnamerr (char *yyres, const char *yystr)
 }
 # endif
 
-/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
-   about the unexpected token YYTOKEN for the state stack whose top is
-   YYSSP.
-
-   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
-   not large enough to hold the message.  In that case, also set
-   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
-   required number of bytes is too large to store.  */
-static int
-yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
-                yytype_int16 *yyssp, int yytoken)
+/* Copy into YYRESULT an error message about the unexpected token
+   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
+   including the terminating null byte.  If YYRESULT is null, do not
+   copy anything; just return the number of bytes that would be
+   copied.  As a special case, return 0 if an ordinary "syntax error"
+   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
+   size calculation.  */
+static YYSIZE_T
+yysyntax_error (char *yyresult, int yystate, int yychar)
 {
-  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
-  YYSIZE_T yysize = yysize0;
-  YYSIZE_T yysize1;
-  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
-  /* Internationalized format string. */
-  const char *yyformat = 0;
-  /* Arguments of yyformat. */
-  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
-  /* Number of reported tokens (one for the "unexpected", one per
-     "expected"). */
-  int yycount = 0;
-
-  /* There are many possibilities here to consider:
-     - Assume YYFAIL is not used.  It's too flawed to consider.  See
-       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
-       for details.  YYERROR is fine as it does not invoke this
-       function.
-     - If this state is a consistent state with a default action, then
-       the only way this function was invoked is if the default action
-       is an error action.  In that case, don't check for expected
-       tokens because there are none.
-     - The only way there can be no lookahead present (in yychar) is if
-       this state is a consistent state with a default action.  Thus,
-       detecting the absence of a lookahead is sufficient to determine
-       that there is no unexpected or expected token to report.  In that
-       case, just report a simple "syntax error".
-     - Don't assume there isn't a lookahead just because this state is a
-       consistent state with a default action.  There might have been a
-       previous inconsistent state, consistent state with a non-default
-       action, or user semantic action that manipulated yychar.
-     - Of course, the expected token list depends on states to have
-       correct lookahead information, and it depends on the parser not
-       to perform extra reductions after fetching a lookahead from the
-       scanner and before detecting a syntax error.  Thus, state merging
-       (from LALR or IELR) and default reductions corrupt the expected
-       token list.  However, the list is correct for canonical LR with
-       one exception: it will still contain any token that will not be
-       accepted due to an error action in a later state.
-  */
-  if (yytoken != YYEMPTY)
-    {
-      int yyn = yypact[*yyssp];
-      yyarg[yycount++] = yytname[yytoken];
-      if (!yypact_value_is_default (yyn))
-        {
-          /* Start YYX at -YYN if negative to avoid negative indexes in
-             YYCHECK.  In other words, skip the first -YYN actions for
-             this state because they are default actions.  */
-          int yyxbegin = yyn < 0 ? -yyn : 0;
-          /* Stay within bounds of both yycheck and yytname.  */
-          int yychecklim = YYLAST - yyn + 1;
-          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
-          int yyx;
-
-          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
-            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
-                && !yytable_value_is_error (yytable[yyx + yyn]))
-              {
-                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
-                  {
-                    yycount = 1;
-                    yysize = yysize0;
-                    break;
-                  }
-                yyarg[yycount++] = yytname[yyx];
-                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-                if (! (yysize <= yysize1
-                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-                  return 2;
-                yysize = yysize1;
-              }
-        }
-    }
+  int yyn = yypact[yystate];
 
-  switch (yycount)
+  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
+    return 0;
+  else
     {
-# define YYCASE_(N, S)                      \
-      case N:                               \
-        yyformat = S;                       \
-      break
-      YYCASE_(0, YY_("syntax error"));
-      YYCASE_(1, YY_("syntax error, unexpected %s"));
-      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
-      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
-      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
-      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
-# undef YYCASE_
-    }
+      int yytype = YYTRANSLATE (yychar);
+      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
+      YYSIZE_T yysize = yysize0;
+      YYSIZE_T yysize1;
+      int yysize_overflow = 0;
+      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+      int yyx;
+
+# if 0
+      /* This is so xgettext sees the translatable formats that are
+	 constructed on the fly.  */
+      YY_("syntax error, unexpected %s");
+      YY_("syntax error, unexpected %s, expecting %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
+# endif
+      char *yyfmt;
+      char const *yyf;
+      static char const yyunexpected[] = "syntax error, unexpected %s";
+      static char const yyexpecting[] = ", expecting %s";
+      static char const yyor[] = " or %s";
+      char yyformat[sizeof yyunexpected
+		    + sizeof yyexpecting - 1
+		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
+		       * (sizeof yyor - 1))];
+      char const *yyprefix = yyexpecting;
+
+      /* Start YYX at -YYN if negative to avoid negative indexes in
+	 YYCHECK.  */
+      int yyxbegin = yyn < 0 ? -yyn : 0;
+
+      /* Stay within bounds of both yycheck and yytname.  */
+      int yychecklim = YYLAST - yyn + 1;
+      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+      int yycount = 1;
+
+      yyarg[0] = yytname[yytype];
+      yyfmt = yystpcpy (yyformat, yyunexpected);
+
+      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
+	  {
+	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+	      {
+		yycount = 1;
+		yysize = yysize0;
+		yyformat[sizeof yyunexpected - 1] = '\0';
+		break;
+	      }
+	    yyarg[yycount++] = yytname[yyx];
+	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+	    yysize_overflow |= (yysize1 < yysize);
+	    yysize = yysize1;
+	    yyfmt = yystpcpy (yyfmt, yyprefix);
+	    yyprefix = yyor;
+	  }
 
-  yysize1 = yysize + yystrlen (yyformat);
-  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-    return 2;
-  yysize = yysize1;
+      yyf = YY_(yyformat);
+      yysize1 = yysize + yystrlen (yyf);
+      yysize_overflow |= (yysize1 < yysize);
+      yysize = yysize1;
 
-  if (*yymsg_alloc < yysize)
-    {
-      *yymsg_alloc = 2 * yysize;
-      if (! (yysize <= *yymsg_alloc
-             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
-        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
-      return 1;
-    }
+      if (yysize_overflow)
+	return YYSIZE_MAXIMUM;
 
-  /* Avoid sprintf, as that infringes on the user's name space.
-     Don't have undefined behavior even if the translation
-     produced a string with the wrong number of "%s"s.  */
-  {
-    char *yyp = *yymsg;
-    int yyi = 0;
-    while ((*yyp = *yyformat) != '\0')
-      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
-        {
-          yyp += yytnamerr (yyp, yyarg[yyi++]);
-          yyformat += 2;
-        }
-      else
-        {
-          yyp++;
-          yyformat++;
-        }
-  }
-  return 0;
+      if (yyresult)
+	{
+	  /* Avoid sprintf, as that infringes on the user's name space.
+	     Don't have undefined behavior even if the translation
+	     produced a string with the wrong number of "%s"s.  */
+	  char *yyp = yyresult;
+	  int yyi = 0;
+	  while ((*yyp = *yyf) != '\0')
+	    {
+	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
+		{
+		  yyp += yytnamerr (yyp, yyarg[yyi++]);
+		  yyf += 2;
+		}
+	      else
+		{
+		  yyp++;
+		  yyf++;
+		}
+	    }
+	}
+      return yysize;
+    }
 }
 #endif /* YYERROR_VERBOSE */
+
 
 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1155,7 +1144,6 @@ yydestruct (yymsg, yytype, yyvaluep, list_all, list_event, idx)
     }
 }
 
-
 /* Prevent warnings from -Wmissing-prototypes.  */
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
@@ -1182,9 +1170,10 @@ YYSTYPE yylval;
 int yynerrs;
 
 
-/*----------.
-| yyparse.  |
-`----------*/
+
+/*-------------------------.
+| yyparse or yypush_parse.  |
+`-------------------------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1210,6 +1199,8 @@ yyparse (list_all, list_event, idx)
 #endif
 #endif
 {
+
+
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
@@ -1364,7 +1355,7 @@ yybackup:
 
   /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
-  if (yypact_value_is_default (yyn))
+  if (yyn == YYPACT_NINF)
     goto yydefault;
 
   /* Not known => get a lookahead token if don't already have one.  */
@@ -1395,8 +1386,8 @@ yybackup:
   yyn = yytable[yyn];
   if (yyn <= 0)
     {
-      if (yytable_value_is_error (yyn))
-        goto yyerrlab;
+      if (yyn == 0 || yyn == YYTABLE_NINF)
+	goto yyerrlab;
       yyn = -yyn;
       goto yyreduce;
     }
@@ -1451,8 +1442,8 @@ yyreduce:
     {
         case 4:
 
-/* Line 1806 of yacc.c  */
-#line 59 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 62 "util/parse-events.y"
     {
 	/*
 	 * Apply modifier on all events added by single event definition
@@ -1461,129 +1452,129 @@ yyreduce:
 	 */
 	ABORT_ON(parse_events_modifier(list_event, (yyvsp[(2) - (2)].str)));
 	parse_events_update_lists(list_event, list_all);
-}
+;}
     break;
 
   case 5:
 
-/* Line 1806 of yacc.c  */
-#line 70 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 73 "util/parse-events.y"
     {
 	parse_events_update_lists(list_event, list_all);
-}
+;}
     break;
 
   case 13:
 
-/* Line 1806 of yacc.c  */
-#line 84 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 87 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_pmu(list_event, idx, (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].head)));
 	parse_events__free_terms((yyvsp[(3) - (4)].head));
-}
+;}
     break;
 
   case 14:
 
-/* Line 1806 of yacc.c  */
-#line 91 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 94 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (4)].num) >> 16;
 	int config = (yyvsp[(1) - (4)].num) & 255;
 
 	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, (yyvsp[(3) - (4)].head)));
 	parse_events__free_terms((yyvsp[(3) - (4)].head));
-}
+;}
     break;
 
   case 15:
 
-/* Line 1806 of yacc.c  */
-#line 100 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 103 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (2)].num) >> 16;
 	int config = (yyvsp[(1) - (2)].num) & 255;
 
 	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
-}
+;}
     break;
 
   case 16:
 
-/* Line 1806 of yacc.c  */
-#line 109 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 112 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
-}
+;}
     break;
 
   case 17:
 
-/* Line 1806 of yacc.c  */
-#line 114 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 117 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
-}
+;}
     break;
 
   case 18:
 
-/* Line 1806 of yacc.c  */
-#line 119 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 122 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
-}
+;}
     break;
 
   case 19:
 
-/* Line 1806 of yacc.c  */
-#line 125 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 128 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
-}
+;}
     break;
 
   case 20:
 
-/* Line 1806 of yacc.c  */
-#line 130 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 133 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
-}
+;}
     break;
 
   case 21:
 
-/* Line 1806 of yacc.c  */
-#line 136 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 139 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_tracepoint(list_event, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
-}
+;}
     break;
 
   case 22:
 
-/* Line 1806 of yacc.c  */
-#line 142 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 145 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list_event, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
-}
+;}
     break;
 
   case 23:
 
-/* Line 1806 of yacc.c  */
-#line 148 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 151 "util/parse-events.y"
     {
 	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
-}
+;}
     break;
 
   case 24:
 
-/* Line 1806 of yacc.c  */
-#line 154 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 157 "util/parse-events.y"
     {
 	struct list_head *head = (yyvsp[(1) - (3)].head);
 	struct parse_events__term *term = (yyvsp[(3) - (3)].term);
@@ -1591,13 +1582,13 @@ yyreduce:
 	ABORT_ON(!head);
 	list_add_tail(&term->list, head);
 	(yyval.head) = (yyvsp[(1) - (3)].head);
-}
+;}
     break;
 
   case 25:
 
-/* Line 1806 of yacc.c  */
-#line 164 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 167 "util/parse-events.y"
     {
 	struct list_head *head = malloc(sizeof(*head));
 	struct parse_events__term *term = (yyvsp[(1) - (1)].term);
@@ -1606,113 +1597,160 @@ yyreduce:
 	INIT_LIST_HEAD(head);
 	list_add_tail(&term->list, head);
 	(yyval.head) = head;
-}
+;}
     break;
 
   case 26:
 
-/* Line 1806 of yacc.c  */
-#line 176 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 179 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_STR,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					(yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), 0));
+	ABORT_ON(parse_events__term_str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
 	(yyval.term) = term;
-}
+;}
     break;
 
   case 27:
 
-/* Line 1806 of yacc.c  */
-#line 187 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 188 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					(yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
-}
+;}
     break;
 
   case 28:
 
-/* Line 1806 of yacc.c  */
-#line 198 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 197 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					(yyvsp[(1) - (1)].str), NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (1)].str), 1));
 	(yyval.term) = term;
-}
+;}
     break;
 
   case 29:
 
-/* Line 1806 of yacc.c  */
-#line 209 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 206 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_STR,
-					(yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].str), 0));
+	ABORT_ON(parse_events__term_str(&term,
+			(yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].str)));
 	(yyval.term) = term;
-}
+;}
     break;
 
   case 30:
 
-/* Line 1806 of yacc.c  */
-#line 219 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 215 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					(yyvsp[(1) - (3)].num), NULL, NULL, (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events__term_num(&term, (yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
-}
+;}
     break;
 
   case 31:
 
-/* Line 1806 of yacc.c  */
-#line 229 "util/parse-events.y"
+/* Line 1464 of yacc.c  */
+#line 223 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					(yyvsp[(1) - (1)].num), NULL, NULL, 1));
+	ABORT_ON(parse_events__term_list(&term, (yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].head)));
+	free((yyvsp[(3) - (3)].head));
 	(yyval.term) = term;
-}
+;}
+    break;
+
+  case 32:
+
+/* Line 1464 of yacc.c  */
+#line 232 "util/parse-events.y"
+    {
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_num(&term, (yyvsp[(1) - (1)].num), NULL, 1));
+	(yyval.term) = term;
+;}
     break;
 
+  case 33:
 
+/* Line 1464 of yacc.c  */
+#line 241 "util/parse-events.y"
+    {
+	struct list_head *list = (yyvsp[(1) - (3)].head);
+	struct parse_events__term_elem *elem = (yyvsp[(3) - (3)].elem);
+
+	list_add_tail(&elem->list, list);
+	(yyval.head) = list;
+;}
+    break;
+
+  case 34:
+
+/* Line 1464 of yacc.c  */
+#line 250 "util/parse-events.y"
+    {
+	struct list_head *list = malloc(sizeof(*list));
+	struct parse_events__term_elem *elem1 = (yyvsp[(1) - (3)].elem);
+	struct parse_events__term_elem *elem2 = (yyvsp[(3) - (3)].elem);
+
+	ABORT_ON(!list);
+	INIT_LIST_HEAD(list);
+	list_add_tail(&elem1->list, list);
+	list_add_tail(&elem2->list, list);
+	(yyval.head) = list;
+;}
+    break;
+
+  case 35:
+
+/* Line 1464 of yacc.c  */
+#line 264 "util/parse-events.y"
+    {
+	struct parse_events__term_elem *elem;
+
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_STR,
+					 (yyvsp[(1) - (1)].str), 0));
+	(yyval.elem) = elem;
+;}
+    break;
+
+  case 36:
+
+/* Line 1464 of yacc.c  */
+#line 273 "util/parse-events.y"
+    {
+	struct parse_events__term_elem *elem;
 
-/* Line 1806 of yacc.c  */
-#line 1703 "util/parse-events-bison.c"
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_NUM,
+					 NULL, (yyvsp[(1) - (1)].num)));
+	(yyval.elem) = elem;
+;}
+    break;
+
+
+
+/* Line 1464 of yacc.c  */
+#line 1752 "util/parse-events-bison.c"
       default: break;
     }
-  /* User semantic actions sometimes alter yychar, and that requires
-     that yytoken be updated with the new translation.  We take the
-     approach of translating immediately before every use of yytoken.
-     One alternative is translating here after every semantic action,
-     but that translation would be missed if the semantic action invokes
-     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
-     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
-     incorrect destructor might then be invoked immediately.  In the
-     case of YYERROR or YYBACKUP, subsequent parser actions might lead
-     to an incorrect destructor call or verbose syntax error message
-     before the lookahead is translated.  */
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
 
   YYPOPSTACK (yylen);
@@ -1740,10 +1778,6 @@ yyreduce:
 | yyerrlab -- here on detecting error |
 `------------------------------------*/
 yyerrlab:
-  /* Make sure we have latest lookahead translation.  See comments at
-     user semantic actions for why this is necessary.  */
-  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);
-
   /* If not already recovering from an error, report this error.  */
   if (!yyerrstatus)
     {
@@ -1751,36 +1785,37 @@ yyerrlab:
 #if ! YYERROR_VERBOSE
       yyerror (list_all, list_event, idx, YY_("syntax error"));
 #else
-# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
-                                        yyssp, yytoken)
       {
-        char const *yymsgp = YY_("syntax error");
-        int yysyntax_error_status;
-        yysyntax_error_status = YYSYNTAX_ERROR;
-        if (yysyntax_error_status == 0)
-          yymsgp = yymsg;
-        else if (yysyntax_error_status == 1)
-          {
-            if (yymsg != yymsgbuf)
-              YYSTACK_FREE (yymsg);
-            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
-            if (!yymsg)
-              {
-                yymsg = yymsgbuf;
-                yymsg_alloc = sizeof yymsgbuf;
-                yysyntax_error_status = 2;
-              }
-            else
-              {
-                yysyntax_error_status = YYSYNTAX_ERROR;
-                yymsgp = yymsg;
-              }
-          }
-        yyerror (list_all, list_event, idx, yymsgp);
-        if (yysyntax_error_status == 2)
-          goto yyexhaustedlab;
+	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
+	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
+	  {
+	    YYSIZE_T yyalloc = 2 * yysize;
+	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
+	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
+	    if (yymsg != yymsgbuf)
+	      YYSTACK_FREE (yymsg);
+	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
+	    if (yymsg)
+	      yymsg_alloc = yyalloc;
+	    else
+	      {
+		yymsg = yymsgbuf;
+		yymsg_alloc = sizeof yymsgbuf;
+	      }
+	  }
+
+	if (0 < yysize && yysize <= yymsg_alloc)
+	  {
+	    (void) yysyntax_error (yymsg, yystate, yychar);
+	    yyerror (list_all, list_event, idx, yymsg);
+	  }
+	else
+	  {
+	    yyerror (list_all, list_event, idx, YY_("syntax error"));
+	    if (yysize != 0)
+	      goto yyexhaustedlab;
+	  }
       }
-# undef YYSYNTAX_ERROR
 #endif
     }
 
@@ -1839,7 +1874,7 @@ yyerrlab1:
   for (;;)
     {
       yyn = yypact[yystate];
-      if (!yypact_value_is_default (yyn))
+      if (yyn != YYPACT_NINF)
 	{
 	  yyn += YYTERROR;
 	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
@@ -1898,13 +1933,8 @@ yyexhaustedlab:
 
 yyreturn:
   if (yychar != YYEMPTY)
-    {
-      /* Make sure we have latest lookahead translation.  See comments at
-         user semantic actions for why this is necessary.  */
-      yytoken = YYTRANSLATE (yychar);
-      yydestruct ("Cleanup: discarding lookahead",
-                  yytoken, &yylval, list_all, list_event, idx);
-    }
+     yydestruct ("Cleanup: discarding lookahead",
+		 yytoken, &yylval, list_all, list_event, idx);
   /* Do not reclaim the symbols of the rule which action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
@@ -1929,8 +1959,8 @@ yyreturn:
 
 
 
-/* Line 2067 of yacc.c  */
-#line 242 "util/parse-events.y"
+/* Line 1684 of yacc.c  */
+#line 285 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list_all __used,
diff --git a/tools/perf/util/parse-events-bison.h b/tools/perf/util/parse-events-bison.h
index 0be3e5a..0bf9091 100644
--- a/tools/perf/util/parse-events-bison.h
+++ b/tools/perf/util/parse-events-bison.h
@@ -1,8 +1,9 @@
-/* A Bison parser, made by GNU Bison 2.5.  */
+/* A Bison parser, made by GNU Bison 2.4.3.  */
 
-/* Bison interface for Yacc-like parsers in C
+/* Skeleton interface for Bison's Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
+   2009, 2010 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -58,18 +59,19 @@
 typedef union YYSTYPE
 {
 
-/* Line 2068 of yacc.c  */
-#line 46 "util/parse-events.y"
+/* Line 1685 of yacc.c  */
+#line 48 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
 	struct list_head *head;
 	struct parse_events__term *term;
+	struct parse_events__term_elem *elem;
 
 
 
-/* Line 2068 of yacc.c  */
-#line 73 "util/parse-events-bison.h"
+/* Line 1685 of yacc.c  */
+#line 75 "util/parse-events-bison.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
diff --git a/tools/perf/util/parse-events-flex.c b/tools/perf/util/parse-events-flex.c
index 4c0e355..f244420 100644
--- a/tools/perf/util/parse-events-flex.c
+++ b/tools/perf/util/parse-events-flex.c
@@ -378,8 +378,8 @@ static void yy_fatal_error (yyconst char msg[]  );
 	*yy_cp = '\0'; \
 	(yy_c_buf_p) = yy_cp;
 
-#define YY_NUM_RULES 50
-#define YY_END_OF_BUFFER 51
+#define YY_NUM_RULES 51
+#define YY_END_OF_BUFFER 52
 /* This struct is not used in this scanner,
    but its presence is necessary. */
 struct yy_trans_info
@@ -387,57 +387,57 @@ struct yy_trans_info
 	flex_int32_t yy_verify;
 	flex_int32_t yy_nxt;
 	};
-static yyconst flex_int16_t yy_accept[443] =
+static yyconst flex_int16_t yy_accept[444] =
     {   0,
-        0,    0,   51,   50,   44,   47,   46,   45,   40,   40,
+        0,    0,   52,   51,   44,   47,   46,   45,   40,   40,
        48,   49,   44,   44,   44,   44,   44,   44,   44,   44,
        44,   44,   42,   44,   44,   44,   44,   44,   42,   43,
-       44,   44,   43,   43,   44,   40,    0,   44,   44,   44,
-       21,   44,   44,   44,   44,   44,   44,   44,   44,   44,
-       44,   44,   15,   44,    0,   44,   44,   44,   42,    0,
-       44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
-       44,   44,   44,   44,   39,   39,   44,   44,   44,   44,
-       41,   44,   44,    0,   44,   44,   44,   24,   44,   44,
-       44,   44,   44,   44,    0,   44,   44,   44,   42,    0,
-
-       44,   44,   44,    0,   19,   20,   44,   44,   44,   44,
-       44,   44,   44,   44,   30,   44,   44,   44,   39,   39,
-       44,   44,   44,   44,   44,   44,   44,    0,    0,   44,
-       44,   44,   44,    0,   44,   44,   44,    0,   44,    0,
-       22,   44,   44,   42,    0,   23,   44,   44,   19,   20,
-       26,   44,   38,   44,   44,   31,   35,   25,   44,   44,
-       44,   26,   44,   44,   44,   44,   44,    0,   44,    0,
-        0,    0,    0,   44,   44,   44,   44,    0,   44,   44,
-       44,    0,    0,   44,   22,   44,   44,   42,   23,    0,
-       44,   26,   44,   44,   44,   44,    0,   44,   44,   44,
-
-       44,   27,    0,   27,    0,   44,    0,    0,    0,    0,
-       44,   44,   24,    0,    0,   32,   44,    0,    0,    0,
-        1,   44,   12,    0,   44,    0,   44,    0,   31,    0,
-       36,   44,   44,   44,    0,    0,   44,    0,    0,    0,
-       44,   44,    0,   44,   44,    0,    0,    0,   33,   34,
-       44,    0,    0,    0,   44,    0,   44,    0,   44,    0,
-        0,   44,   44,   44,    0,   44,    0,    0,    0,   44,
-       44,    0,    0,   44,    7,    0,    0,    0,    0,    0,
-        0,    0,   44,    0,   44,    0,   44,    0,    0,   28,
-       44,    0,    0,   44,    0,   44,    0,    0,   44,    0,
-
-        0,    0,    0,   10,    0,    0,   44,    0,   44,    0,
-       44,    0,    0,   44,   44,    0,    0,   44,    0,    0,
-        0,    0,   44,    9,    0,    0,    0,    1,    0,    0,
-        0,   44,    0,   16,    0,    0,   28,   44,    0,   11,
-       44,    0,    0,    0,    0,   37,    0,    0,    0,    0,
-        0,    0,   44,    0,    0,   12,   44,    0,    0,    0,
-        0,    0,    0,    6,    0,    0,    0,    0,    0,    4,
-       14,   13,    0,    0,    0,    0,    0,    0,    8,    0,
+       44,   44,   43,   43,   50,   44,   40,    0,   44,   44,
+       44,   21,   44,   44,   44,   44,   44,   44,   44,   44,
+       44,   44,   44,   15,   44,    0,   44,   44,   44,   42,
+        0,   44,   44,   44,   44,   44,   44,   44,   44,   44,
+       44,   44,   44,   44,   44,   39,   39,   44,   44,   44,
+       44,   41,   44,   44,    0,   44,   44,   44,   24,   44,
+       44,   44,   44,   44,   44,    0,   44,   44,   44,   42,
+
+        0,   44,   44,   44,    0,   19,   20,   44,   44,   44,
+       44,   44,   44,   44,   44,   30,   44,   44,   44,   39,
+       39,   44,   44,   44,   44,   44,   44,   44,    0,    0,
+       44,   44,   44,   44,    0,   44,   44,   44,    0,   44,
+        0,   22,   44,   44,   42,    0,   23,   44,   44,   19,
+       20,   26,   44,   38,   44,   44,   31,   35,   25,   44,
+       44,   44,   26,   44,   44,   44,   44,   44,    0,   44,
+        0,    0,    0,    0,   44,   44,   44,   44,    0,   44,
+       44,   44,    0,    0,   44,   22,   44,   44,   42,   23,
+        0,   44,   26,   44,   44,   44,   44,    0,   44,   44,
+
+       44,   44,   27,    0,   27,    0,   44,    0,    0,    0,
+        0,   44,   44,   24,    0,    0,   32,   44,    0,    0,
+        0,    1,   44,   12,    0,   44,    0,   44,    0,   31,
+        0,   36,   44,   44,   44,    0,    0,   44,    0,    0,
+        0,   44,   44,    0,   44,   44,    0,    0,    0,   33,
+       34,   44,    0,    0,    0,   44,    0,   44,    0,   44,
+        0,    0,   44,   44,   44,    0,   44,    0,    0,    0,
+       44,   44,    0,    0,   44,    7,    0,    0,    0,    0,
+        0,    0,    0,   44,    0,   44,    0,   44,    0,    0,
+       28,   44,    0,    0,   44,    0,   44,    0,    0,   44,
+
+        0,    0,    0,    0,   10,    0,    0,   44,    0,   44,
+        0,   44,    0,    0,   44,   44,    0,    0,   44,    0,
+        0,    0,    0,   44,    9,    0,    0,    0,    1,    0,
+        0,    0,   44,    0,   16,    0,    0,   28,   44,    0,
+       11,   44,    0,    0,    0,    0,   37,    0,    0,    0,
+        0,    0,    0,   44,    0,    0,   12,   44,    0,    0,
+        0,    0,    0,    0,    6,    0,    0,    0,    0,    0,
+        4,   14,   13,    0,    0,    0,    0,    0,    0,    8,
         0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-        0,    0,    0,   16,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,   16,    0,    0,    0,    0,    0,
 
         0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-       17,    0,    5,   15,   18,    0,    0,   29,    0,    0,
+        0,   17,    0,    5,   15,   18,    0,    0,   29,    0,
         0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
-        7,    3,    0,    0,    0,    2,    0,    0,    0,    0,
-        0,    0
+        0,    7,    3,    0,    0,    0,    2,    0,    0,    0,
+        0,    0,    0
     } ;
 
 static yyconst flex_int32_t yy_ec[256] =
@@ -455,7 +455,7 @@ static yyconst flex_int32_t yy_ec[256] =
 
        25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
        35,   36,    2,   37,   38,   39,   40,   41,   42,   43,
-       44,    2,    1,    1,    1,    1,    1,    1,    1,    1,
+       44,    2,    1,   45,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
@@ -472,249 +472,249 @@ static yyconst flex_int32_t yy_ec[256] =
         1,    1,    1,    1,    1
     } ;
 
-static yyconst flex_int32_t yy_meta[45] =
+static yyconst flex_int32_t yy_meta[46] =
     {   0,
         1,    2,    1,    1,    1,    3,    3,    3,    3,    1,
         1,    3,    3,    3,    3,    2,    2,    2,    2,    2,
         3,    3,    3,    3,    3,    3,    2,    2,    2,    2,
         2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
-        2,    2,    2,    2
+        2,    2,    2,    2,    1
     } ;
 
-static yyconst flex_int16_t yy_base[445] =
+static yyconst flex_int16_t yy_base[446] =
     {   0,
-        0,    0,  513,  514,    0,  514,  514,  514,   39,   43,
-      514,  514,  491,  477,   46,  485,   32,   20,   37,   57,
-      476,  487,   34,   64,   59,   64,   56,  471,   78,  113,
-       48,  485,  468,    0,    0,  104,    0,  465,  465,  498,
-        0,  487,  474,  476,  469,   46,  476,  474,  457,  471,
-      459,  452,    0,  468,  451,  472,  448,  447,   64,  447,
-      468,  452,  445,  119,  461,  451,  447,   63,  446,  454,
-      439,  449,  438,  449,  448,  119,  447,   81,  433,  441,
-        0,  448,  429,  100,  442,  441,  438,    0,  430,  459,
-      434,   41,  457,  428,  427,  445,  425,  424,  118,  423,
-
-      441,  428,  413,  118,    0,    0,  427,  415,  439,  411,
-      412,  408,  420,  419,    0,  418,  413,  415,   54,   92,
-      417,  407,  401,  406,  397,  431,  397,   84,  118,  396,
-      394,  397,  407,  406,  403,  398,  401,  127,  400,  402,
-        0,  402,  383,  125,  399,    0,  416,  382,  514,  514,
-      380,  380,  514,  395,  378,  389,    0,    0,  409,  377,
-      386,  385,  369,  376,  382,  402,  380,  385,  363,  363,
-      380,  379,  361,  373,  359,  363,  367,  350,  389,  365,
-      348,   64,  361,  351,  514,  349,  349,    0,  514,  363,
-      345,    0,  380,  344,  378,  343,  354,  355,  339,  345,
-
-      351,  337,  351,    0,  356,  349,  350,  347,  346,  329,
-      333,  341,  147,  342,  122,  124,  325,  328,  339,  334,
-        0,  331,    0,  315,  335,  331,  327,  329,    0,  333,
-        0,  330,  331,  327,  318,  336,  309,  319,  318,  308,
-      321,  309,  133,  303,  303,  308,  310,  313,    0,    0,
-      333,  313,  303,  297,  298,  309,  292,  309,  294,  307,
-      287,  298,  286,  320,  288,  293,  296,  295,  279,  293,
-      278,  282,  286,  270,    0,  288,  274,  285,  272,  278,
-      283,  286,  272,  273,  275,  263,  268,  261,  268,  274,
-      269,  274,  273,  260,  271,  289,  254,  253,  254,  251,
-
-      250,  262,  244,  514,  247,  245,  279,  257,  246,  248,
-      241,  246,  238,  238,  234,  230,  242,  238,  232,  244,
-      230,  230,  242,  514,  241,  228,  235,  514,  234,  236,
-      223,  226,  220,    0,  219,  219,    0,  231,  232,  514,
-      250,  224,  231,  214,  225,    0,  211,  223,  208,  211,
-      224,  240,  205,  204,  203,  514,  236,  207,  219,  202,
-      196,  195,  196,  514,  199,  209,  197,  190,  142,    0,
-      514,  514,  137,  204,  211,  193,  194,  202,  514,  201,
-      195,  184,  189,  199,  182,  183,  192,  178,  202,  175,
-      174,  187,  186,  514,  171,  186,  173,  186,  185,  201,
-
-      166,  174,  164,  163,  162,  168,  164,  173,  172,  149,
-      514,  160,  514,  514,  514,  169,  154,  514,  171,  154,
-      156,  155,  163,  164,  151,  147,  160,  149,  151,  147,
-      514,  514,  156,  154,  139,  514,  139,  145,  139,  123,
-      109,  514,  174,   68
+        0,    0,  514,  515,    0,  515,  515,  515,   40,   44,
+      515,  515,  492,  478,   47,  486,   33,   21,   38,   58,
+      477,  488,   35,   65,   60,   65,   57,  472,   79,  114,
+       49,  486,  469,    0,  515,    0,  105,    0,  466,  466,
+      499,    0,  488,  475,  477,  470,   47,  477,  475,  458,
+      472,  460,  453,    0,  469,  452,  473,  449,  448,   65,
+      448,  469,  453,  446,  120,  462,  452,  448,   64,  447,
+      455,  440,  450,  439,  450,  449,  120,  448,   82,  434,
+      442,    0,  449,  430,  101,  443,  442,  439,    0,  431,
+      460,  435,   42,  458,  429,  428,  446,  426,  425,  119,
+
+      424,  442,  429,  414,  119,    0,    0,  428,  416,  440,
+      412,  413,  409,  421,  420,    0,  419,  414,  416,   55,
+       93,  418,  408,  402,  407,  398,  432,  398,   85,  119,
+      397,  395,  398,  408,  407,  404,  399,  402,  128,  401,
+      403,    0,  403,  384,  126,  400,    0,  417,  383,  515,
+      515,  381,  381,  515,  396,  379,  390,    0,    0,  410,
+      378,  387,  386,  370,  377,  383,  403,  381,  386,  364,
+      364,  381,  380,  362,  374,  360,  364,  368,  351,  390,
+      366,  349,   65,  362,  352,  515,  350,  350,    0,  515,
+      364,  346,    0,  381,  345,  379,  344,  355,  356,  340,
+
+      346,  352,  338,  352,    0,  357,  350,  351,  348,  347,
+      330,  334,  342,  148,  343,  123,  125,  326,  329,  340,
+      335,    0,  332,    0,  316,  336,  332,  328,  330,    0,
+      334,    0,  331,  332,  328,  319,  337,  310,  320,  319,
+      309,  322,  310,  134,  304,  304,  309,  311,  314,    0,
+        0,  334,  314,  304,  298,  299,  310,  293,  310,  295,
+      308,  288,  299,  287,  321,  289,  294,  297,  296,  280,
+      294,  279,  283,  287,  271,    0,  289,  275,  286,  273,
+      279,  284,  287,  273,  274,  276,  264,  269,  262,  269,
+      275,  270,  275,  274,  261,  272,  290,  255,  254,  255,
+
+      252,  251,  263,  245,  515,  248,  246,  280,  258,  247,
+      249,  242,  247,  239,  239,  235,  231,  243,  239,  233,
+      245,  231,  231,  243,  515,  242,  229,  236,  515,  235,
+      237,  224,  227,  221,    0,  220,  220,    0,  232,  233,
+      515,  251,  225,  232,  215,  226,    0,  212,  224,  209,
+      212,  225,  241,  206,  205,  204,  515,  237,  208,  220,
+      203,  197,  196,  197,  515,  200,  210,  198,  191,  143,
+        0,  515,  515,  138,  205,  212,  194,  195,  203,  515,
+      202,  196,  185,  190,  200,  183,  184,  193,  179,  203,
+      176,  175,  188,  187,  515,  172,  187,  174,  187,  186,
+
+      202,  167,  175,  165,  164,  163,  169,  165,  174,  173,
+      150,  515,  161,  515,  515,  515,  170,  155,  515,  172,
+      155,  157,  156,  164,  165,  152,  148,  161,  150,  152,
+      148,  515,  515,  157,  155,  140,  515,  140,  146,  140,
+      124,  110,  515,  175,   69
     } ;
 
-static yyconst flex_int16_t yy_def[445] =
+static yyconst flex_int16_t yy_def[446] =
     {   0,
-      442,    1,  442,  442,  443,  442,  442,  442,  442,  442,
-      442,  442,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,    1,  443,  443,  444,  443,  443,  443,  443,  443,
+      443,  443,  444,  444,  444,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  444,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  443,  444,  443,  445,  444,  444,
+      444,  444,  444,  444,  444,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  444,  443,  444,  444,  444,  444,
+      443,  444,  444,  444,  444,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  444,   30,   30,  444,  444,  444,
+      444,  445,  444,  444,  443,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  444,  443,  444,  444,  444,  444,
+
+      443,  444,  444,  444,  443,  444,  444,  444,  444,  444,
+      444,  444,  444,  444,  444,  444,  444,  444,  444,   30,
+       30,  444,  444,  444,  444,  444,  444,  444,  443,  443,
+      444,  444,  444,  444,  443,  444,  444,  444,  443,  444,
+      443,  444,  444,  444,  444,  443,  444,  444,  444,  443,
+      443,  444,  444,  443,  444,  444,  444,  444,  444,  444,
+      444,  444,   30,  444,  444,  444,  444,  444,  443,  444,
+      443,  443,  443,  443,  444,  444,  444,  444,  443,  444,
+      444,  444,  443,  443,  444,  443,  444,  444,  444,  443,
+      443,  444,  444,  444,  444,  444,  444,  443,  444,  444,
+
+      444,  444,  444,  443,  444,  443,  444,  443,  443,  443,
+      443,  444,  444,  444,  443,  443,  444,  444,  443,  443,
+      443,  444,  444,  444,  443,  444,  443,  444,  443,  444,
+      443,  444,  444,  444,  444,  443,  443,  444,  443,  443,
+      443,  444,  444,  443,  444,  444,  443,  443,  443,  444,
+      444,  444,  443,  443,  443,  444,  443,  444,  443,  444,
+      443,  443,  444,  444,  444,  443,  444,  443,  443,  443,
+      444,  444,  443,  443,  444,  444,  443,  443,  443,  443,
+      443,  443,  443,  444,  443,  444,  443,  444,  443,  443,
+      444,  444,  443,  443,  444,  443,  444,  443,  443,  444,
+
+      443,  443,  443,  443,  443,  443,  443,  444,  443,  444,
+      443,  444,  443,  443,  444,  444,  443,  443,  444,  443,
+      443,  443,  443,  444,  443,  443,  443,  443,  443,  443,
+      443,  443,  444,  443,  444,  443,  443,  444,  444,  443,
+      443,  444,  443,  443,  443,  443,  444,  443,  443,  443,
+      443,  443,  443,  444,  443,  443,  443,  444,  443,  443,
       443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
-      443,  443,  443,  443,  443,  442,  444,  443,  443,  443,
+      444,  443,  443,  443,  443,  443,  443,  443,  443,  443,
       443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
-      443,  443,  443,  443,  442,  443,  443,  443,  443,  442,
       443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
-      443,  443,  443,  443,   30,   30,  443,  443,  443,  443,
-      444,  443,  443,  442,  443,  443,  443,  443,  443,  443,
-      443,  443,  443,  443,  442,  443,  443,  443,  443,  442,
-
-      443,  443,  443,  442,  443,  443,  443,  443,  443,  443,
-      443,  443,  443,  443,  443,  443,  443,  443,   30,   30,
-      443,  443,  443,  443,  443,  443,  443,  442,  442,  443,
-      443,  443,  443,  442,  443,  443,  443,  442,  443,  442,
-      443,  443,  443,  443,  442,  443,  443,  443,  442,  442,
-      443,  443,  442,  443,  443,  443,  443,  443,  443,  443,
-      443,   30,  443,  443,  443,  443,  443,  442,  443,  442,
-      442,  442,  442,  443,  443,  443,  443,  442,  443,  443,
-      443,  442,  442,  443,  442,  443,  443,  443,  442,  442,
-      443,  443,  443,  443,  443,  443,  442,  443,  443,  443,
-
-      443,  443,  442,  443,  442,  443,  442,  442,  442,  442,
-      443,  443,  443,  442,  442,  443,  443,  442,  442,  442,
-      443,  443,  443,  442,  443,  442,  443,  442,  443,  442,
-      443,  443,  443,  443,  442,  442,  443,  442,  442,  442,
-      443,  443,  442,  443,  443,  442,  442,  442,  443,  443,
-      443,  442,  442,  442,  443,  442,  443,  442,  443,  442,
-      442,  443,  443,  443,  442,  443,  442,  442,  442,  443,
-      443,  442,  442,  443,  443,  442,  442,  442,  442,  442,
-      442,  442,  443,  442,  443,  442,  443,  442,  442,  443,
-      443,  442,  442,  443,  442,  443,  442,  442,  443,  442,
-
-      442,  442,  442,  442,  442,  442,  443,  442,  443,  442,
-      443,  442,  442,  443,  443,  442,  442,  443,  442,  442,
-      442,  442,  443,  442,  442,  442,  442,  442,  442,  442,
-      442,  443,  442,  443,  442,  442,  443,  443,  442,  442,
-      443,  442,  442,  442,  442,  443,  442,  442,  442,  442,
-      442,  442,  443,  442,  442,  442,  443,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  443,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,    0,  442,  442
+
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,    0,  443,  443
     } ;
 
-static yyconst flex_int16_t yy_nxt[559] =
+static yyconst flex_int16_t yy_nxt[561] =
     {   0,
         4,    5,    6,    7,    8,    9,   10,   10,   10,   11,
        12,    5,    5,    5,   13,   14,   15,   16,    5,    5,
        17,   18,   19,   20,   21,   22,    5,   23,   24,    5,
        23,   25,   26,   27,   28,   29,   30,   31,   32,   23,
-        5,   33,   34,    5,   36,   36,   36,   36,   36,   36,
-       36,   36,   40,   41,   44,   46,   47,   50,   48,   49,
-       55,   59,   42,   45,   59,   64,  136,   60,   88,   59,
-       81,   51,   52,   59,   53,   56,   69,  162,   75,  137,
-       54,   37,   61,   77,   66,   88,   78,   62,   67,  110,
-       70,   99,   68,   65,   99,  218,  111,   63,   72,   99,
-
-      112,  122,   73,   99,  170,   59,  171,  219,   59,   36,
-       36,   36,   36,   59,   74,  123,   75,   59,   75,   75,
-       75,   75,  104,  128,   75,   75,   75,   75,  129,  115,
-      249,  250,  436,   75,   75,   75,   75,   76,   75,  119,
-      172,  149,  105,   75,  120,  144,  150,  106,  144,  182,
-      243,  173,  188,  144,  247,  188,  441,  144,  248,  183,
-      188,  272,  432,  384,  188,  273,  244,  385,  386,  440,
-      419,  245,  439,  387,  420,   35,   35,  438,  437,  436,
-      435,  434,  433,  432,  431,  430,  429,  428,  427,  426,
-      425,  424,  423,  422,  421,  418,  418,  417,  416,  415,
-
-      414,  413,  412,  411,  410,  409,  408,  407,  406,  405,
-      404,  403,  402,  401,  189,  400,  399,  398,  397,  396,
-      395,  394,  393,  392,  391,  390,  150,  389,  388,  383,
-      382,  381,  380,  379,  378,  377,  376,  375,  374,  373,
-      372,  371,  370,  369,  368,  367,  366,  365,  364,  363,
-      362,  361,  360,  359,  358,  357,  356,  355,  354,  353,
-      352,  351,  350,  349,  348,  347,  346,  345,  344,  343,
-      342,  341,  340,  339,  338,  337,  336,  335,  334,  333,
-      332,  331,  330,  329,  328,  327,  326,  325,  324,  323,
-      322,  321,  320,  319,  318,  317,  316,  315,  314,  313,
-
-      312,  311,  310,  309,  308,  307,  306,  305,  304,  303,
-      302,  301,  300,  299,  298,  297,  296,  115,  295,  150,
-      149,  294,  293,  292,  291,  290,  289,  288,  287,  286,
-      285,  284,  283,  282,  281,  280,  279,  278,  277,  276,
-      275,  274,  271,  270,  269,  268,  267,  266,  185,  265,
-      264,  263,  262,  261,  260,  259,  258,  257,  256,  255,
-      254,  253,  252,  251,  246,  242,  241,  240,  239,  238,
-      149,  237,  236,  235,  204,  234,  233,  232,  231,  230,
-      229,  228,  227,  226,  225,  224,  223,  222,  221,  220,
-      217,  216,  215,  214,  213,  212,  115,  211,  210,  209,
-
-      208,  207,  206,  205,  204,  203,  202,  201,  200,   75,
-      199,  198,  197,  196,  195,  194,  193,  192,  191,  190,
-      189,  187,  186,  185,  184,  181,  180,  179,  178,  177,
-      176,  175,  174,  169,  168,  167,  166,  165,  164,  163,
-      161,  160,  159,  158,  157,  156,  155,  154,  153,  152,
-      151,  148,  147,  146,  145,  143,  142,  141,  140,  139,
-      138,  135,  134,  133,  132,  131,  130,  127,  126,  125,
-      124,  121,   75,  118,  117,  116,  115,  114,  113,  109,
-      108,  107,  103,  102,  101,  100,   98,   97,   96,   95,
-       94,   93,   92,   91,   90,   88,   89,   87,   86,   85,
-
-       41,   84,   83,   82,   80,   79,   71,   58,   57,   43,
-       39,   38,  442,    3,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442
+        5,   33,   34,    5,   35,   37,   37,   37,   37,   37,
+       37,   37,   37,   41,   42,   45,   47,   48,   51,   49,
+       50,   56,   60,   43,   46,   60,   65,  137,   61,   89,
+       60,   82,   52,   53,   60,   54,   57,   70,  163,   76,
+      138,   55,   38,   62,   78,   67,   89,   79,   63,   68,
+      111,   71,  100,   69,   66,  100,  219,  112,   64,   73,
+
+      100,  113,  123,   74,  100,  171,   60,  172,  220,   60,
+       37,   37,   37,   37,   60,   75,  124,   76,   60,   76,
+       76,   76,   76,  105,  129,   76,   76,   76,   76,  130,
+      116,  250,  251,  437,   76,   76,   76,   76,   77,   76,
+      120,  173,  150,  106,   76,  121,  145,  151,  107,  145,
+      183,  244,  174,  189,  145,  248,  189,  442,  145,  249,
+      184,  189,  273,  433,  385,  189,  274,  245,  386,  387,
+      441,  420,  246,  440,  388,  421,   36,   36,  439,  438,
+      437,  436,  435,  434,  433,  432,  431,  430,  429,  428,
+      427,  426,  425,  424,  423,  422,  419,  419,  418,  417,
+
+      416,  415,  414,  413,  412,  411,  410,  409,  408,  407,
+      406,  405,  404,  403,  402,  190,  401,  400,  399,  398,
+      397,  396,  395,  394,  393,  392,  391,  151,  390,  389,
+      384,  383,  382,  381,  380,  379,  378,  377,  376,  375,
+      374,  373,  372,  371,  370,  369,  368,  367,  366,  365,
+      364,  363,  362,  361,  360,  359,  358,  357,  356,  355,
+      354,  353,  352,  351,  350,  349,  348,  347,  346,  345,
+      344,  343,  342,  341,  340,  339,  338,  337,  336,  335,
+      334,  333,  332,  331,  330,  329,  328,  327,  326,  325,
+      324,  323,  322,  321,  320,  319,  318,  317,  316,  315,
+
+      314,  313,  312,  311,  310,  309,  308,  307,  306,  305,
+      304,  303,  302,  301,  300,  299,  298,  297,  116,  296,
+      151,  150,  295,  294,  293,  292,  291,  290,  289,  288,
+      287,  286,  285,  284,  283,  282,  281,  280,  279,  278,
+      277,  276,  275,  272,  271,  270,  269,  268,  267,  186,
+      266,  265,  264,  263,  262,  261,  260,  259,  258,  257,
+      256,  255,  254,  253,  252,  247,  243,  242,  241,  240,
+      239,  150,  238,  237,  236,  205,  235,  234,  233,  232,
+      231,  230,  229,  228,  227,  226,  225,  224,  223,  222,
+      221,  218,  217,  216,  215,  214,  213,  116,  212,  211,
+
+      210,  209,  208,  207,  206,  205,  204,  203,  202,  201,
+       76,  200,  199,  198,  197,  196,  195,  194,  193,  192,
+      191,  190,  188,  187,  186,  185,  182,  181,  180,  179,
+      178,  177,  176,  175,  170,  169,  168,  167,  166,  165,
+      164,  162,  161,  160,  159,  158,  157,  156,  155,  154,
+      153,  152,  149,  148,  147,  146,  144,  143,  142,  141,
+      140,  139,  136,  135,  134,  133,  132,  131,  128,  127,
+      126,  125,  122,   76,  119,  118,  117,  116,  115,  114,
+      110,  109,  108,  104,  103,  102,  101,   99,   98,   97,
+       96,   95,   94,   93,   92,   91,   89,   90,   88,   87,
+
+       86,   42,   85,   84,   83,   81,   80,   72,   59,   58,
+       44,   40,   39,  443,    3,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443
     } ;
 
-static yyconst flex_int16_t yy_chk[559] =
+static yyconst flex_int16_t yy_chk[561] =
     {   0,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
-        1,    1,    1,    1,    9,    9,    9,    9,   10,   10,
-       10,   10,   15,   15,   17,   18,   18,   19,   18,   18,
-       20,   23,   15,   17,   23,   25,   92,   24,   46,   23,
-      444,   19,   19,   23,   19,   20,   27,  119,  119,   92,
-       19,    9,   24,   31,   26,   46,   31,   24,   26,   68,
-       27,   59,   26,   25,   59,  182,   68,   24,   29,   59,
-
-       68,   78,   29,   59,  128,   29,  128,  182,   29,   36,
-       36,   36,   36,   29,   29,   78,  120,   29,   30,   30,
-       30,   30,   64,   84,   30,   30,   30,   30,   84,  120,
-      216,  216,  441,   30,   30,   30,   30,   30,   30,   76,
-      129,  104,   64,   76,   76,   99,  104,   64,   99,  138,
-      213,  129,  144,   99,  215,  144,  440,   99,  215,  138,
-      144,  243,  439,  369,  144,  243,  213,  369,  373,  438,
-      410,  213,  437,  373,  410,  443,  443,  435,  434,  433,
-      430,  429,  428,  427,  426,  425,  424,  423,  422,  421,
-      420,  419,  417,  416,  412,  409,  408,  407,  406,  405,
-
-      404,  403,  402,  401,  400,  399,  398,  397,  396,  395,
-      393,  392,  391,  390,  389,  388,  387,  386,  385,  384,
-      383,  382,  381,  380,  378,  377,  376,  375,  374,  368,
-      367,  366,  365,  363,  362,  361,  360,  359,  358,  357,
-      355,  354,  353,  352,  351,  350,  349,  348,  347,  345,
-      344,  343,  342,  341,  339,  338,  336,  335,  333,  332,
-      331,  330,  329,  327,  326,  325,  323,  322,  321,  320,
-      319,  318,  317,  316,  315,  314,  313,  312,  311,  310,
-      309,  308,  307,  306,  305,  303,  302,  301,  300,  299,
-      298,  297,  296,  295,  294,  293,  292,  291,  290,  289,
-
-      288,  287,  286,  285,  284,  283,  282,  281,  280,  279,
-      278,  277,  276,  274,  273,  272,  271,  270,  269,  268,
-      267,  266,  265,  264,  263,  262,  261,  260,  259,  258,
-      257,  256,  255,  254,  253,  252,  251,  248,  247,  246,
-      245,  244,  242,  241,  240,  239,  238,  237,  236,  235,
-      234,  233,  232,  230,  228,  227,  226,  225,  224,  222,
-      220,  219,  218,  217,  214,  212,  211,  210,  209,  208,
-      207,  206,  205,  203,  202,  201,  200,  199,  198,  197,
-      196,  195,  194,  193,  191,  190,  187,  186,  184,  183,
-      181,  180,  179,  178,  177,  176,  175,  174,  173,  172,
-
-      171,  170,  169,  168,  167,  166,  165,  164,  163,  162,
-      161,  160,  159,  156,  155,  154,  152,  151,  148,  147,
-      145,  143,  142,  140,  139,  137,  136,  135,  134,  133,
-      132,  131,  130,  127,  126,  125,  124,  123,  122,  121,
-      118,  117,  116,  114,  113,  112,  111,  110,  109,  108,
-      107,  103,  102,  101,  100,   98,   97,   96,   95,   94,
-       93,   91,   90,   89,   87,   86,   85,   83,   82,   80,
-       79,   77,   75,   74,   73,   72,   71,   70,   69,   67,
-       66,   65,   63,   62,   61,   60,   58,   57,   56,   55,
-       54,   52,   51,   50,   49,   48,   47,   45,   44,   43,
-
-       42,   40,   39,   38,   33,   32,   28,   22,   21,   16,
-       14,   13,    3,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
-      442,  442,  442,  442,  442,  442,  442,  442
+        1,    1,    1,    1,    1,    9,    9,    9,    9,   10,
+       10,   10,   10,   15,   15,   17,   18,   18,   19,   18,
+       18,   20,   23,   15,   17,   23,   25,   93,   24,   47,
+       23,  445,   19,   19,   23,   19,   20,   27,  120,  120,
+       93,   19,    9,   24,   31,   26,   47,   31,   24,   26,
+       69,   27,   60,   26,   25,   60,  183,   69,   24,   29,
+
+       60,   69,   79,   29,   60,  129,   29,  129,  183,   29,
+       37,   37,   37,   37,   29,   29,   79,  121,   29,   30,
+       30,   30,   30,   65,   85,   30,   30,   30,   30,   85,
+      121,  217,  217,  442,   30,   30,   30,   30,   30,   30,
+       77,  130,  105,   65,   77,   77,  100,  105,   65,  100,
+      139,  214,  130,  145,  100,  216,  145,  441,  100,  216,
+      139,  145,  244,  440,  370,  145,  244,  214,  370,  374,
+      439,  411,  214,  438,  374,  411,  444,  444,  436,  435,
+      434,  431,  430,  429,  428,  427,  426,  425,  424,  423,
+      422,  421,  420,  418,  417,  413,  410,  409,  408,  407,
+
+      406,  405,  404,  403,  402,  401,  400,  399,  398,  397,
+      396,  394,  393,  392,  391,  390,  389,  388,  387,  386,
+      385,  384,  383,  382,  381,  379,  378,  377,  376,  375,
+      369,  368,  367,  366,  364,  363,  362,  361,  360,  359,
+      358,  356,  355,  354,  353,  352,  351,  350,  349,  348,
+      346,  345,  344,  343,  342,  340,  339,  337,  336,  334,
+      333,  332,  331,  330,  328,  327,  326,  324,  323,  322,
+      321,  320,  319,  318,  317,  316,  315,  314,  313,  312,
+      311,  310,  309,  308,  307,  306,  304,  303,  302,  301,
+      300,  299,  298,  297,  296,  295,  294,  293,  292,  291,
+
+      290,  289,  288,  287,  286,  285,  284,  283,  282,  281,
+      280,  279,  278,  277,  275,  274,  273,  272,  271,  270,
+      269,  268,  267,  266,  265,  264,  263,  262,  261,  260,
+      259,  258,  257,  256,  255,  254,  253,  252,  249,  248,
+      247,  246,  245,  243,  242,  241,  240,  239,  238,  237,
+      236,  235,  234,  233,  231,  229,  228,  227,  226,  225,
+      223,  221,  220,  219,  218,  215,  213,  212,  211,  210,
+      209,  208,  207,  206,  204,  203,  202,  201,  200,  199,
+      198,  197,  196,  195,  194,  192,  191,  188,  187,  185,
+      184,  182,  181,  180,  179,  178,  177,  176,  175,  174,
+
+      173,  172,  171,  170,  169,  168,  167,  166,  165,  164,
+      163,  162,  161,  160,  157,  156,  155,  153,  152,  149,
+      148,  146,  144,  143,  141,  140,  138,  137,  136,  135,
+      134,  133,  132,  131,  128,  127,  126,  125,  124,  123,
+      122,  119,  118,  117,  115,  114,  113,  112,  111,  110,
+      109,  108,  104,  103,  102,  101,   99,   98,   97,   96,
+       95,   94,   92,   91,   90,   88,   87,   86,   84,   83,
+       81,   80,   78,   76,   75,   74,   73,   72,   71,   70,
+       68,   67,   66,   64,   63,   62,   61,   59,   58,   57,
+       56,   55,   53,   52,   51,   50,   49,   48,   46,   45,
+
+       44,   43,   41,   40,   39,   33,   32,   28,   22,   21,
+       16,   14,   13,    3,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443,
+      443,  443,  443,  443,  443,  443,  443,  443,  443,  443
     } ;
 
 static yy_state_type yy_last_accepting_state;
@@ -1016,13 +1016,13 @@ yy_match:
 			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 				{
 				yy_current_state = (int) yy_def[yy_current_state];
-				if ( yy_current_state >= 443 )
+				if ( yy_current_state >= 444 )
 					yy_c = yy_meta[(unsigned int) yy_c];
 				}
 			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
 			++yy_cp;
 			}
-		while ( yy_base[yy_current_state] != 514 );
+		while ( yy_base[yy_current_state] != 515 );
 
 yy_find_action:
 		yy_act = yy_accept[yy_current_state];
@@ -1266,10 +1266,15 @@ YY_RULE_SETUP
 	YY_BREAK
 case 50:
 YY_RULE_SETUP
-#line 122 "util/parse-events.l"
+#line 121 "util/parse-events.l"
+{ return '|'; }
+	YY_BREAK
+case 51:
+YY_RULE_SETUP
+#line 123 "util/parse-events.l"
 ECHO;
 	YY_BREAK
-#line 1273 "<stdout>"
+#line 1278 "<stdout>"
 case YY_STATE_EOF(INITIAL):
 	yyterminate();
 
@@ -1561,7 +1566,7 @@ static int yy_get_next_buffer (void)
 		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 			{
 			yy_current_state = (int) yy_def[yy_current_state];
-			if ( yy_current_state >= 443 )
+			if ( yy_current_state >= 444 )
 				yy_c = yy_meta[(unsigned int) yy_c];
 			}
 		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
@@ -1589,11 +1594,11 @@ static int yy_get_next_buffer (void)
 	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 		{
 		yy_current_state = (int) yy_def[yy_current_state];
-		if ( yy_current_state >= 443 )
+		if ( yy_current_state >= 444 )
 			yy_c = yy_meta[(unsigned int) yy_c];
 		}
 	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
-	yy_is_jam = (yy_current_state == 442);
+	yy_is_jam = (yy_current_state == 443);
 
 	return yy_is_jam ? 0 : yy_current_state;
 }
@@ -2267,7 +2272,7 @@ void parse_events_free (void * ptr )
 
 #define YYTABLES_NAME "yytables"
 
-#line 122 "util/parse-events.l"
+#line 123 "util/parse-events.l"
 
 
 
diff --git a/tools/perf/util/parse-events-flex.h b/tools/perf/util/parse-events-flex.h
index 413aebb..29f1905 100644
--- a/tools/perf/util/parse-events-flex.h
+++ b/tools/perf/util/parse-events-flex.h
@@ -308,7 +308,7 @@ extern int parse_events_lex (void);
 #undef YY_DECL
 #endif
 
-#line 122 "util/parse-events.l"
+#line 123 "util/parse-events.l"
 
 
 #line 315 "util/parse-events-flex.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a05d1b..29892c0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1038,8 +1038,9 @@ int parse_events__is_name_term(struct parse_events__term *term)
 	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
 }
 
-int parse_events__new_term(struct parse_events__term **_term, int type_val,
-			   int type_term, char *config, char *str, long num)
+static int new_term(struct parse_events__term **_term, int type_val,
+		    int type_term, char *config,
+		    char *str, long num, struct list_head *list)
 {
 	struct parse_events__term *term;
 
@@ -1059,6 +1060,10 @@ int parse_events__new_term(struct parse_events__term **_term, int type_val,
 	case PARSE_EVENTS__TERM_TYPE_STR:
 		term->val.str = str;
 		break;
+	case PARSE_EVENTS__TERM_TYPE_LIST:
+		INIT_LIST_HEAD(&term->val.list);
+		list_splice_tail(list, &term->val.list);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1067,6 +1072,55 @@ int parse_events__new_term(struct parse_events__term **_term, int type_val,
 	return 0;
 }
 
+int parse_events__term_num(struct parse_events__term **term,
+			   int type_term, char *config, long num)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
+			config, NULL, num, NULL);
+}
+
+int parse_events__term_str(struct parse_events__term **term,
+			   int type_term, char *config, char *str)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR, type_term,
+			config, str, 0, NULL);
+}
+
+int parse_events__term_list(struct parse_events__term **term,
+			    int type_term, char *config,
+			    struct list_head *list)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_LIST, type_term,
+			config, NULL, 0, list);
+}
+
+int parse_events__term_elem(struct parse_events__term_elem **_elem,
+				     int type_val, char *str, long num)
+{
+	struct parse_events__term_elem *elem;
+
+	elem = zalloc(sizeof(*elem));
+	if (!elem)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&elem->list);
+	elem->type_val = type_val;
+
+	switch (type_val) {
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		elem->val.num = num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		elem->val.str = str;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_elem = elem;
+	return 0;
+}
+
 void parse_events__free_terms(struct list_head *terms)
 {
 	struct parse_events__term *term, *h;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index a5eabe4..cabcbc1 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -37,6 +37,7 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
+	PARSE_EVENTS__TERM_TYPE_LIST,
 };
 
 enum {
@@ -49,11 +50,22 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
+
+struct parse_events__term_elem {
+	union {
+		char *str;
+		long  num;
+	} val;
+	int type_val;
+	struct list_head list;
+};
+
 struct parse_events__term {
 	char *config;
 	union {
 		char *str;
 		long  num;
+		struct list_head list;
 	} val;
 	int type_val;
 	int type_term;
@@ -62,8 +74,15 @@ struct parse_events__term {
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
 int parse_events__is_name_term(struct parse_events__term *term);
-int parse_events__new_term(struct parse_events__term **_term, int type_val,
-			   int type_term, char *config, char *str, long num);
+int parse_events__term_num(struct parse_events__term **_term,
+			   int type_term, char *config, long num);
+int parse_events__term_str(struct parse_events__term **_term,
+			   int type_term, char *config, char *str);
+int parse_events__term_list(struct parse_events__term **_term,
+			    int type_term, char *config,
+			    struct list_head *list);
+int parse_events__term_elem(struct parse_events__term_elem **_e,
+			    int type_val, char *str, long num);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 01c3679..0967d55 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -118,6 +118,7 @@ r{num_raw_hex}		{ return raw(); }
 ,			{ return ','; }
 :			{ return ':'; }
 =			{ return '='; }
+\|			{ return '|'; }
 
 %%
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 0d166c4..f106945 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -41,6 +41,8 @@ do { \
 %type <str> PE_MODIFIER_BP
 %type <head> event_config
 %type <term> event_term
+%type <head> event_term_list
+%type <elem> event_term_elem
 
 %union
 {
@@ -48,6 +50,7 @@ do { \
 	unsigned long num;
 	struct list_head *head;
 	struct parse_events__term *term;
+	struct parse_events__term_elem *elem;
 }
 %%
 
@@ -176,10 +179,8 @@ PE_NAME '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_STR,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $3, 0));
+	ABORT_ON(parse_events__term_str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -187,10 +188,8 @@ PE_NAME '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -198,10 +197,8 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1));
 	$$ = term;
 }
 |
@@ -209,9 +206,8 @@ PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_STR,
-					$1, NULL, $3, 0));
+	ABORT_ON(parse_events__term_str(&term,
+			$1, NULL, $3));
 	$$ = term;
 }
 |
@@ -219,9 +215,16 @@ PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					$1, NULL, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, $3));
+	$$ = term;
+}
+|
+PE_TERM '=' event_term_list
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_list(&term, $1, NULL, $3));
+	free($3);
 	$$ = term;
 }
 |
@@ -229,12 +232,52 @@ PE_TERM
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					$1, NULL, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, 1));
 	$$ = term;
 }
 
+event_term_list:
+event_term_list '|' event_term_elem
+{
+	struct list_head *list = $1;
+	struct parse_events__term_elem *elem = $3;
+
+	list_add_tail(&elem->list, list);
+	$$ = list;
+}
+|
+event_term_elem '|' event_term_elem
+{
+	struct list_head *list = malloc(sizeof(*list));
+	struct parse_events__term_elem *elem1 = $1;
+	struct parse_events__term_elem *elem2 = $3;
+
+	ABORT_ON(!list);
+	INIT_LIST_HEAD(list);
+	list_add_tail(&elem1->list, list);
+	list_add_tail(&elem2->list, list);
+	$$ = list;
+}
+
+event_term_elem:
+PE_NAME
+{
+	struct parse_events__term_elem *elem;
+
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_STR,
+					 $1, 0));
+	$$ = elem;
+}
+|
+PE_VALUE
+{
+	struct parse_events__term_elem *elem;
+
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_NUM,
+					 NULL, $1));
+	$$ = elem;
+}
+
 sep_dc: ':' |
 
 sep_slash_dc: '/' | ':' |
-- 
1.7.6.5

