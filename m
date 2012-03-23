Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2CWIbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:31:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2CWIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:31:23 -0400
Date: Fri, 23 Mar 2012 01:30:31 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-5d7be90ed5cfb5dd3c9ab726d7daa91b86b81747@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1332267341-26338-3-git-send-email-jolsa@redhat.com>
References: <1332267341-26338-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix modifier to be applied on correct events
Git-Commit-ID: 5d7be90ed5cfb5dd3c9ab726d7daa91b86b81747
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 01:30:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d7be90ed5cfb5dd3c9ab726d7daa91b86b81747
Gitweb:     http://git.kernel.org/tip/5d7be90ed5cfb5dd3c9ab726d7daa91b86b81747
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 20 Mar 2012 19:15:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Mar 2012 15:11:38 -0300

perf tools: Fix modifier to be applied on correct events

The event modifier needs to be applied only on the event definition it
is attached to.

The current state is that in case of multiple events definition (in
single '-e' option, separated by ',') all will get modifier of the last
one.

Fixing this by adding separated list for each event definition, so the
modifier is applied only to proper event(s). Added automated test to
catch this, plus some other modifier tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1332267341-26338-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c            |  116 ++++++-
 tools/perf/util/parse-events-bison.c |  675 +++++++++++++++++++---------------
 tools/perf/util/parse-events-bison.h |   15 +-
 tools/perf/util/parse-events.c       |   27 +-
 tools/perf/util/parse-events.h       |    7 +-
 tools/perf/util/parse-events.y       |   40 ++-
 6 files changed, 543 insertions(+), 337 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 8687423..1c5b980 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -877,6 +877,58 @@ static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_genhw(evlist);
 }
 
+static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint(evlist);
+}
+
+static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
+static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_r(evlist);
+}
+
+static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_w(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -893,6 +945,47 @@ static int test__checkevent_pmu(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_list(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* r1 */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* syscalls:sys_enter_open:k */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* 1:1:hp */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -975,9 +1068,29 @@ static struct test__event_st {
 		.check = test__checkevent_genhw_modifier,
 	},
 	{
+		.name  = "mem:0:u",
+		.check = test__checkevent_breakpoint_modifier,
+	},
+	{
+		.name  = "mem:0:x:k",
+		.check = test__checkevent_breakpoint_x_modifier,
+	},
+	{
+		.name  = "mem:0:r:hp",
+		.check = test__checkevent_breakpoint_r_modifier,
+	},
+	{
+		.name  = "mem:0:w:up",
+		.check = test__checkevent_breakpoint_w_modifier,
+	},
+	{
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
 		.check = test__checkevent_pmu,
 	},
+	{
+		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
@@ -1003,10 +1116,9 @@ static int test__parse_events(void)
 		}
 
 		ret = e->check(evlist);
+		perf_evlist__delete(evlist);
 		if (ret)
 			break;
-
-		perf_evlist__delete(evlist);
 	}
 
 	return ret;
diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index 4a0fd6d..4a4e02a 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.5.  */
 
-/* Skeleton implementation for Bison's Yacc-like parsers in C
+/* Bison implementation for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -45,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.5"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -74,8 +73,8 @@
 
 /* Copy the first part of user declarations.  */
 
-/* Line 189 of yacc.c  */
-#line 6 "util/parse-events.y"
+/* Line 268 of yacc.c  */
+#line 7 "util/parse-events.y"
 
 
 #define YYDEBUG 1
@@ -96,8 +95,8 @@ do { \
 
 
 
-/* Line 189 of yacc.c  */
-#line 101 "util/parse-events-bison.c"
+/* Line 268 of yacc.c  */
+#line 100 "util/parse-events-bison.c"
 
 /* Enabling traces.  */
 #ifndef YYDEBUG
@@ -145,8 +144,8 @@ do { \
 typedef union YYSTYPE
 {
 
-/* Line 214 of yacc.c  */
-#line 45 "util/parse-events.y"
+/* Line 293 of yacc.c  */
+#line 46 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
@@ -155,8 +154,8 @@ typedef union YYSTYPE
 
 
 
-/* Line 214 of yacc.c  */
-#line 160 "util/parse-events-bison.c"
+/* Line 293 of yacc.c  */
+#line 159 "util/parse-events-bison.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -167,8 +166,8 @@ typedef union YYSTYPE
 /* Copy the second part of user declarations.  */
 
 
-/* Line 264 of yacc.c  */
-#line 172 "util/parse-events-bison.c"
+/* Line 343 of yacc.c  */
+#line 171 "util/parse-events-bison.c"
 
 #ifdef short
 # undef short
@@ -271,11 +270,11 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#     ifndef _STDLIB_H
-#      define _STDLIB_H 1
+#     ifndef EXIT_SUCCESS
+#      define EXIT_SUCCESS 0
 #     endif
 #    endif
 #   endif
@@ -298,24 +297,24 @@ YYID (yyi)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
 #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
 #  endif
-#  if (defined __cplusplus && ! defined _STDLIB_H \
+#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
        && ! ((defined YYMALLOC || defined malloc) \
 	     && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#   ifndef _STDLIB_H
-#    define _STDLIB_H 1
+#   ifndef EXIT_SUCCESS
+#    define EXIT_SUCCESS 0
 #   endif
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
@@ -344,23 +343,7 @@ union yyalloc
      ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
       + YYSTACK_GAP_MAXIMUM)
 
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
+# define YYCOPY_NEEDED 1
 
 /* Relocate STACK from its old location to the new one.  The
    local variables YYSIZE and YYSTACKSIZE give the old and new number of
@@ -380,6 +363,26 @@ union yyalloc
 
 #endif
 
+#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
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
+#endif /* !YYCOPY_NEEDED */
+
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  25
 /* YYLAST -- Last index in YYTABLE.  */
@@ -463,10 +466,10 @@ static const yytype_int8 yyrhs[] =
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
-       0,    54,    54,    54,    57,    62,    64,    65,    66,    67,
-      68,    69,    70,    73,    80,    89,    98,   103,   108,   114,
-     119,   125,   131,   137,   143,   153,   165,   174,   183,   192,
-     200,   208,   208,   210,   210,   210
+       0,    55,    55,    55,    58,    69,    74,    75,    76,    77,
+      78,    79,    80,    83,    90,    99,   108,   113,   118,   124,
+     129,   135,   141,   147,   153,   163,   175,   184,   193,   202,
+     210,   218,   218,   220,   220,   220
 };
 #endif
 
@@ -514,8 +517,8 @@ static const yytype_uint8 yyr2[] =
        1,     1,     0,     1,     1,     0
 };
 
-/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
-   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
+   Performed when YYTABLE doesn't specify something else to do.  Zero
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
@@ -556,8 +559,7 @@ static const yytype_int8 yypgoto[] =
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If zero, do what YYDEFACT says.
-   If YYTABLE_NINF, syntax error.  */
+   number is the opposite.  If YYTABLE_NINF, syntax error.  */
 #define YYTABLE_NINF -1
 static const yytype_uint8 yytable[] =
 {
@@ -568,6 +570,12 @@ static const yytype_uint8 yytable[] =
       38,    54,     0,    43
 };
 
+#define yypact_value_is_default(yystate) \
+  ((yystate) == (-15))
+
+#define yytable_value_is_error(yytable_value) \
+  YYID (0)
+
 static const yytype_int8 yycheck[] =
 {
       14,    15,    16,     0,     3,     4,     5,    16,     7,    18,
@@ -622,13 +630,12 @@ do								\
     {								\
       yychar = (Token);						\
       yylval = (Value);						\
-      yytoken = YYTRANSLATE (yychar);				\
       YYPOPSTACK (1);						\
       goto yybackup;						\
     }								\
   else								\
     {								\
-      yyerror (list, idx, YY_("syntax error: cannot back up")); \
+      yyerror (list_all, list_event, idx, YY_("syntax error: cannot back up")); \
       YYERROR;							\
     }								\
 while (YYID (0))
@@ -664,19 +671,10 @@ while (YYID (0))
 #endif
 
 
-/* YY_LOCATION_PRINT -- Print the location on the stream.
-   This macro was not mandated originally: define only if we know
-   we won't break user code: when these are the locations we know.  */
+/* This macro is provided for backward compatibility. */
 
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
-#  define YY_LOCATION_PRINT(File, Loc)			\
-     fprintf (File, "%d.%d-%d.%d",			\
-	      (Loc).first_line, (Loc).first_column,	\
-	      (Loc).last_line,  (Loc).last_column)
-# else
-#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-# endif
+# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
 #endif
 
 
@@ -708,7 +706,7 @@ do {									  \
     {									  \
       YYFPRINTF (stderr, "%s ", Title);					  \
       yy_symbol_print (stderr,						  \
-		  Type, Value, list, idx); \
+		  Type, Value, list_all, list_event, idx); \
       YYFPRINTF (stderr, "\n");						  \
     }									  \
 } while (YYID (0))
@@ -722,20 +720,22 @@ do {									  \
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list, int *idx)
+yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list_all, struct list_head *list_event, int *idx)
 #else
 static void
-yy_symbol_value_print (yyoutput, yytype, yyvaluep, list, idx)
+yy_symbol_value_print (yyoutput, yytype, yyvaluep, list_all, list_event, idx)
     FILE *yyoutput;
     int yytype;
     YYSTYPE const * const yyvaluep;
-    struct list_head *list;
+    struct list_head *list_all;
+    struct list_head *list_event;
     int *idx;
 #endif
 {
   if (!yyvaluep)
     return;
-  YYUSE (list);
+  YYUSE (list_all);
+  YYUSE (list_event);
   YYUSE (idx);
 # ifdef YYPRINT
   if (yytype < YYNTOKENS)
@@ -758,14 +758,15 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep, list, idx)
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list, int *idx)
+yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct list_head *list_all, struct list_head *list_event, int *idx)
 #else
 static void
-yy_symbol_print (yyoutput, yytype, yyvaluep, list, idx)
+yy_symbol_print (yyoutput, yytype, yyvaluep, list_all, list_event, idx)
     FILE *yyoutput;
     int yytype;
     YYSTYPE const * const yyvaluep;
-    struct list_head *list;
+    struct list_head *list_all;
+    struct list_head *list_event;
     int *idx;
 #endif
 {
@@ -774,7 +775,7 @@ yy_symbol_print (yyoutput, yytype, yyvaluep, list, idx)
   else
     YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
 
-  yy_symbol_value_print (yyoutput, yytype, yyvaluep, list, idx);
+  yy_symbol_value_print (yyoutput, yytype, yyvaluep, list_all, list_event, idx);
   YYFPRINTF (yyoutput, ")");
 }
 
@@ -817,13 +818,14 @@ do {								\
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yy_reduce_print (YYSTYPE *yyvsp, int yyrule, struct list_head *list, int *idx)
+yy_reduce_print (YYSTYPE *yyvsp, int yyrule, struct list_head *list_all, struct list_head *list_event, int *idx)
 #else
 static void
-yy_reduce_print (yyvsp, yyrule, list, idx)
+yy_reduce_print (yyvsp, yyrule, list_all, list_event, idx)
     YYSTYPE *yyvsp;
     int yyrule;
-    struct list_head *list;
+    struct list_head *list_all;
+    struct list_head *list_event;
     int *idx;
 #endif
 {
@@ -838,7 +840,7 @@ yy_reduce_print (yyvsp, yyrule, list, idx)
       YYFPRINTF (stderr, "   $%d = ", yyi + 1);
       yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
 		       &(yyvsp[(yyi + 1) - (yynrhs)])
-		       		       , list, idx);
+		       		       , list_all, list_event, idx);
       YYFPRINTF (stderr, "\n");
     }
 }
@@ -846,7 +848,7 @@ yy_reduce_print (yyvsp, yyrule, list, idx)
 # define YY_REDUCE_PRINT(Rule)		\
 do {					\
   if (yydebug)				\
-    yy_reduce_print (yyvsp, Rule, list, idx); \
+    yy_reduce_print (yyvsp, Rule, list_all, list_event, idx); \
 } while (YYID (0))
 
 /* Nonzero means print parse trace.  It is left uninitialized so that
@@ -876,7 +878,6 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif
 
-
 
 #if YYERROR_VERBOSE
 
@@ -979,115 +980,142 @@ yytnamerr (char *yyres, const char *yystr)
 }
 # endif
 
-/* Copy into YYRESULT an error message about the unexpected token
-   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
-   including the terminating null byte.  If YYRESULT is null, do not
-   copy anything; just return the number of bytes that would be
-   copied.  As a special case, return 0 if an ordinary "syntax error"
-   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
-   size calculation.  */
-static YYSIZE_T
-yysyntax_error (char *yyresult, int yystate, int yychar)
-{
-  int yyn = yypact[yystate];
+/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
+   about the unexpected token YYTOKEN for the state stack whose top is
+   YYSSP.
 
-  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
-    return 0;
-  else
+   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
+   not large enough to hold the message.  In that case, also set
+   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
+   required number of bytes is too large to store.  */
+static int
+yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
+                yytype_int16 *yyssp, int yytoken)
+{
+  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
+  YYSIZE_T yysize = yysize0;
+  YYSIZE_T yysize1;
+  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+  /* Internationalized format string. */
+  const char *yyformat = 0;
+  /* Arguments of yyformat. */
+  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+  /* Number of reported tokens (one for the "unexpected", one per
+     "expected"). */
+  int yycount = 0;
+
+  /* There are many possibilities here to consider:
+     - Assume YYFAIL is not used.  It's too flawed to consider.  See
+       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
+       for details.  YYERROR is fine as it does not invoke this
+       function.
+     - If this state is a consistent state with a default action, then
+       the only way this function was invoked is if the default action
+       is an error action.  In that case, don't check for expected
+       tokens because there are none.
+     - The only way there can be no lookahead present (in yychar) is if
+       this state is a consistent state with a default action.  Thus,
+       detecting the absence of a lookahead is sufficient to determine
+       that there is no unexpected or expected token to report.  In that
+       case, just report a simple "syntax error".
+     - Don't assume there isn't a lookahead just because this state is a
+       consistent state with a default action.  There might have been a
+       previous inconsistent state, consistent state with a non-default
+       action, or user semantic action that manipulated yychar.
+     - Of course, the expected token list depends on states to have
+       correct lookahead information, and it depends on the parser not
+       to perform extra reductions after fetching a lookahead from the
+       scanner and before detecting a syntax error.  Thus, state merging
+       (from LALR or IELR) and default reductions corrupt the expected
+       token list.  However, the list is correct for canonical LR with
+       one exception: it will still contain any token that will not be
+       accepted due to an error action in a later state.
+  */
+  if (yytoken != YYEMPTY)
     {
-      int yytype = YYTRANSLATE (yychar);
-      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
-      YYSIZE_T yysize = yysize0;
-      YYSIZE_T yysize1;
-      int yysize_overflow = 0;
-      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
-      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
-      int yyx;
-
-# if 0
-      /* This is so xgettext sees the translatable formats that are
-	 constructed on the fly.  */
-      YY_("syntax error, unexpected %s");
-      YY_("syntax error, unexpected %s, expecting %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
-# endif
-      char *yyfmt;
-      char const *yyf;
-      static char const yyunexpected[] = "syntax error, unexpected %s";
-      static char const yyexpecting[] = ", expecting %s";
-      static char const yyor[] = " or %s";
-      char yyformat[sizeof yyunexpected
-		    + sizeof yyexpecting - 1
-		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
-		       * (sizeof yyor - 1))];
-      char const *yyprefix = yyexpecting;
-
-      /* Start YYX at -YYN if negative to avoid negative indexes in
-	 YYCHECK.  */
-      int yyxbegin = yyn < 0 ? -yyn : 0;
-
-      /* Stay within bounds of both yycheck and yytname.  */
-      int yychecklim = YYLAST - yyn + 1;
-      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
-      int yycount = 1;
-
-      yyarg[0] = yytname[yytype];
-      yyfmt = yystpcpy (yyformat, yyunexpected);
-
-      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
-	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
-	  {
-	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
-	      {
-		yycount = 1;
-		yysize = yysize0;
-		yyformat[sizeof yyunexpected - 1] = '\0';
-		break;
-	      }
-	    yyarg[yycount++] = yytname[yyx];
-	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-	    yysize_overflow |= (yysize1 < yysize);
-	    yysize = yysize1;
-	    yyfmt = yystpcpy (yyfmt, yyprefix);
-	    yyprefix = yyor;
-	  }
+      int yyn = yypact[*yyssp];
+      yyarg[yycount++] = yytname[yytoken];
+      if (!yypact_value_is_default (yyn))
+        {
+          /* Start YYX at -YYN if negative to avoid negative indexes in
+             YYCHECK.  In other words, skip the first -YYN actions for
+             this state because they are default actions.  */
+          int yyxbegin = yyn < 0 ? -yyn : 0;
+          /* Stay within bounds of both yycheck and yytname.  */
+          int yychecklim = YYLAST - yyn + 1;
+          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+          int yyx;
+
+          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
+                && !yytable_value_is_error (yytable[yyx + yyn]))
+              {
+                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+                  {
+                    yycount = 1;
+                    yysize = yysize0;
+                    break;
+                  }
+                yyarg[yycount++] = yytname[yyx];
+                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+                if (! (yysize <= yysize1
+                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                  return 2;
+                yysize = yysize1;
+              }
+        }
+    }
 
-      yyf = YY_(yyformat);
-      yysize1 = yysize + yystrlen (yyf);
-      yysize_overflow |= (yysize1 < yysize);
-      yysize = yysize1;
+  switch (yycount)
+    {
+# define YYCASE_(N, S)                      \
+      case N:                               \
+        yyformat = S;                       \
+      break
+      YYCASE_(0, YY_("syntax error"));
+      YYCASE_(1, YY_("syntax error, unexpected %s"));
+      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
+      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
+      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
+      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
+# undef YYCASE_
+    }
 
-      if (yysize_overflow)
-	return YYSIZE_MAXIMUM;
+  yysize1 = yysize + yystrlen (yyformat);
+  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+    return 2;
+  yysize = yysize1;
 
-      if (yyresult)
-	{
-	  /* Avoid sprintf, as that infringes on the user's name space.
-	     Don't have undefined behavior even if the translation
-	     produced a string with the wrong number of "%s"s.  */
-	  char *yyp = yyresult;
-	  int yyi = 0;
-	  while ((*yyp = *yyf) != '\0')
-	    {
-	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
-		{
-		  yyp += yytnamerr (yyp, yyarg[yyi++]);
-		  yyf += 2;
-		}
-	      else
-		{
-		  yyp++;
-		  yyf++;
-		}
-	    }
-	}
-      return yysize;
+  if (*yymsg_alloc < yysize)
+    {
+      *yymsg_alloc = 2 * yysize;
+      if (! (yysize <= *yymsg_alloc
+             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
+        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
+      return 1;
     }
+
+  /* Avoid sprintf, as that infringes on the user's name space.
+     Don't have undefined behavior even if the translation
+     produced a string with the wrong number of "%s"s.  */
+  {
+    char *yyp = *yymsg;
+    int yyi = 0;
+    while ((*yyp = *yyformat) != '\0')
+      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
+        {
+          yyp += yytnamerr (yyp, yyarg[yyi++]);
+          yyformat += 2;
+        }
+      else
+        {
+          yyp++;
+          yyformat++;
+        }
+  }
+  return 0;
 }
 #endif /* YYERROR_VERBOSE */
-
 
 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1097,19 +1125,21 @@ yysyntax_error (char *yyresult, int yystate, int yychar)
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 static void
-yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, struct list_head *list, int *idx)
+yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, struct list_head *list_all, struct list_head *list_event, int *idx)
 #else
 static void
-yydestruct (yymsg, yytype, yyvaluep, list, idx)
+yydestruct (yymsg, yytype, yyvaluep, list_all, list_event, idx)
     const char *yymsg;
     int yytype;
     YYSTYPE *yyvaluep;
-    struct list_head *list;
+    struct list_head *list_all;
+    struct list_head *list_event;
     int *idx;
 #endif
 {
   YYUSE (yyvaluep);
-  YYUSE (list);
+  YYUSE (list_all);
+  YYUSE (list_event);
   YYUSE (idx);
 
   if (!yymsg)
@@ -1124,6 +1154,7 @@ yydestruct (yymsg, yytype, yyvaluep, list, idx)
     }
 }
 
+
 /* Prevent warnings from -Wmissing-prototypes.  */
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
@@ -1133,7 +1164,7 @@ int yyparse ();
 #endif
 #else /* ! YYPARSE_PARAM */
 #if defined __STDC__ || defined __cplusplus
-int yyparse (struct list_head *list, int *idx);
+int yyparse (struct list_head *list_all, struct list_head *list_event, int *idx);
 #else
 int yyparse ();
 #endif
@@ -1150,10 +1181,9 @@ YYSTYPE yylval;
 int yynerrs;
 
 
-
-/*-------------------------.
-| yyparse or yypush_parse.  |
-`-------------------------*/
+/*----------.
+| yyparse.  |
+`----------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1169,17 +1199,16 @@ yyparse (YYPARSE_PARAM)
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 int
-yyparse (struct list_head *list, int *idx)
+yyparse (struct list_head *list_all, struct list_head *list_event, int *idx)
 #else
 int
-yyparse (list, idx)
-    struct list_head *list;
+yyparse (list_all, list_event, idx)
+    struct list_head *list_all;
+    struct list_head *list_event;
     int *idx;
 #endif
 #endif
 {
-
-
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
@@ -1334,7 +1363,7 @@ yybackup:
 
   /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
-  if (yyn == YYPACT_NINF)
+  if (yypact_value_is_default (yyn))
     goto yydefault;
 
   /* Not known => get a lookahead token if don't already have one.  */
@@ -1365,8 +1394,8 @@ yybackup:
   yyn = yytable[yyn];
   if (yyn <= 0)
     {
-      if (yyn == 0 || yyn == YYTABLE_NINF)
-	goto yyerrlab;
+      if (yytable_value_is_error (yyn))
+        goto yyerrlab;
       yyn = -yyn;
       goto yyreduce;
     }
@@ -1421,124 +1450,139 @@ yyreduce:
     {
         case 4:
 
-/* Line 1464 of yacc.c  */
-#line 58 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 59 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_modifier(list, (yyvsp[(2) - (2)].str)));
-;}
+	/*
+	 * Apply modifier on all events added by single event definition
+	 * (there could be more events added for multiple tracepoint
+	 * definitions via '*?'.
+	 */
+	ABORT_ON(parse_events_modifier(list_event, (yyvsp[(2) - (2)].str)));
+	parse_events_update_lists(list_event, list_all);
+}
+    break;
+
+  case 5:
+
+/* Line 1806 of yacc.c  */
+#line 70 "util/parse-events.y"
+    {
+	parse_events_update_lists(list_event, list_all);
+}
     break;
 
   case 13:
 
-/* Line 1464 of yacc.c  */
-#line 74 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 84 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_pmu(list, idx, (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].head)));
+	ABORT_ON(parse_events_add_pmu(list_event, idx, (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].head)));
 	parse_events__free_terms((yyvsp[(3) - (4)].head));
-;}
+}
     break;
 
   case 14:
 
-/* Line 1464 of yacc.c  */
-#line 81 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 91 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (4)].num) >> 16;
 	int config = (yyvsp[(1) - (4)].num) & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config, (yyvsp[(3) - (4)].head)));
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, (yyvsp[(3) - (4)].head)));
 	parse_events__free_terms((yyvsp[(3) - (4)].head));
-;}
+}
     break;
 
   case 15:
 
-/* Line 1464 of yacc.c  */
-#line 90 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 100 "util/parse-events.y"
     {
 	int type = (yyvsp[(1) - (2)].num) >> 16;
 	int config = (yyvsp[(1) - (2)].num) & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config, NULL));
-;}
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
+}
     break;
 
   case 16:
 
-/* Line 1464 of yacc.c  */
-#line 99 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 109 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
-;}
+	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (5)].str), (yyvsp[(3) - (5)].str), (yyvsp[(5) - (5)].str)));
+}
     break;
 
   case 17:
 
-/* Line 1464 of yacc.c  */
-#line 104 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 114 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
-;}
+	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), NULL));
+}
     break;
 
   case 18:
 
-/* Line 1464 of yacc.c  */
-#line 109 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 119 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_cache(list, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
-;}
+	ABORT_ON(parse_events_add_cache(list_event, idx, (yyvsp[(1) - (1)].str), NULL, NULL));
+}
     break;
 
   case 19:
 
-/* Line 1464 of yacc.c  */
-#line 115 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 125 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
-;}
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) (yyvsp[(2) - (5)].num), (yyvsp[(4) - (5)].str)));
+}
     break;
 
   case 20:
 
-/* Line 1464 of yacc.c  */
-#line 120 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 130 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
-;}
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) (yyvsp[(2) - (3)].num), NULL));
+}
     break;
 
   case 21:
 
-/* Line 1464 of yacc.c  */
-#line 126 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 136 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_tracepoint(list, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
-;}
+	ABORT_ON(parse_events_add_tracepoint(list_event, idx, (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)));
+}
     break;
 
   case 22:
 
-/* Line 1464 of yacc.c  */
-#line 132 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 142 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
-;}
+	ABORT_ON(parse_events_add_numeric(list_event, idx, (yyvsp[(1) - (3)].num), (yyvsp[(3) - (3)].num), NULL));
+}
     break;
 
   case 23:
 
-/* Line 1464 of yacc.c  */
-#line 138 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 148 "util/parse-events.y"
     {
-	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
-;}
+	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, (yyvsp[(1) - (1)].num), NULL));
+}
     break;
 
   case 24:
 
-/* Line 1464 of yacc.c  */
-#line 144 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 154 "util/parse-events.y"
     {
 	struct list_head *head = (yyvsp[(1) - (3)].head);
 	struct parse_events__term *term = (yyvsp[(3) - (3)].term);
@@ -1546,13 +1590,13 @@ yyreduce:
 	ABORT_ON(!head);
 	list_add_tail(&term->list, head);
 	(yyval.head) = (yyvsp[(1) - (3)].head);
-;}
+}
     break;
 
   case 25:
 
-/* Line 1464 of yacc.c  */
-#line 154 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 164 "util/parse-events.y"
     {
 	struct list_head *head = malloc(sizeof(*head));
 	struct parse_events__term *term = (yyvsp[(1) - (1)].term);
@@ -1561,78 +1605,89 @@ yyreduce:
 	INIT_LIST_HEAD(head);
 	list_add_tail(&term->list, head);
 	(yyval.head) = head;
-;}
+}
     break;
 
   case 26:
 
-/* Line 1464 of yacc.c  */
-#line 166 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 176 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
 	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
 		 (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), 0));
 	(yyval.term) = term;
-;}
+}
     break;
 
   case 27:
 
-/* Line 1464 of yacc.c  */
-#line 175 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 185 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
 	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
 		 (yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
-;}
+}
     break;
 
   case 28:
 
-/* Line 1464 of yacc.c  */
-#line 184 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 194 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
 	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
 		 (yyvsp[(1) - (1)].str), NULL, 1));
 	(yyval.term) = term;
-;}
+}
     break;
 
   case 29:
 
-/* Line 1464 of yacc.c  */
-#line 193 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 203 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
 	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (3)].num), NULL, NULL, (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
-;}
+}
     break;
 
   case 30:
 
-/* Line 1464 of yacc.c  */
-#line 201 "util/parse-events.y"
+/* Line 1806 of yacc.c  */
+#line 211 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
 	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (1)].num), NULL, NULL, 1));
 	(yyval.term) = term;
-;}
+}
     break;
 
 
 
-/* Line 1464 of yacc.c  */
-#line 1634 "util/parse-events-bison.c"
+/* Line 1806 of yacc.c  */
+#line 1678 "util/parse-events-bison.c"
       default: break;
     }
+  /* User semantic actions sometimes alter yychar, and that requires
+     that yytoken be updated with the new translation.  We take the
+     approach of translating immediately before every use of yytoken.
+     One alternative is translating here after every semantic action,
+     but that translation would be missed if the semantic action invokes
+     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
+     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
+     incorrect destructor might then be invoked immediately.  In the
+     case of YYERROR or YYBACKUP, subsequent parser actions might lead
+     to an incorrect destructor call or verbose syntax error message
+     before the lookahead is translated.  */
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
 
   YYPOPSTACK (yylen);
@@ -1660,44 +1715,47 @@ yyreduce:
 | yyerrlab -- here on detecting error |
 `------------------------------------*/
 yyerrlab:
+  /* Make sure we have latest lookahead translation.  See comments at
+     user semantic actions for why this is necessary.  */
+  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);
+
   /* If not already recovering from an error, report this error.  */
   if (!yyerrstatus)
     {
       ++yynerrs;
 #if ! YYERROR_VERBOSE
-      yyerror (list, idx, YY_("syntax error"));
+      yyerror (list_all, list_event, idx, YY_("syntax error"));
 #else
+# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
+                                        yyssp, yytoken)
       {
-	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
-	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
-	  {
-	    YYSIZE_T yyalloc = 2 * yysize;
-	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
-	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
-	    if (yymsg != yymsgbuf)
-	      YYSTACK_FREE (yymsg);
-	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
-	    if (yymsg)
-	      yymsg_alloc = yyalloc;
-	    else
-	      {
-		yymsg = yymsgbuf;
-		yymsg_alloc = sizeof yymsgbuf;
-	      }
-	  }
-
-	if (0 < yysize && yysize <= yymsg_alloc)
-	  {
-	    (void) yysyntax_error (yymsg, yystate, yychar);
-	    yyerror (list, idx, yymsg);
-	  }
-	else
-	  {
-	    yyerror (list, idx, YY_("syntax error"));
-	    if (yysize != 0)
-	      goto yyexhaustedlab;
-	  }
+        char const *yymsgp = YY_("syntax error");
+        int yysyntax_error_status;
+        yysyntax_error_status = YYSYNTAX_ERROR;
+        if (yysyntax_error_status == 0)
+          yymsgp = yymsg;
+        else if (yysyntax_error_status == 1)
+          {
+            if (yymsg != yymsgbuf)
+              YYSTACK_FREE (yymsg);
+            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
+            if (!yymsg)
+              {
+                yymsg = yymsgbuf;
+                yymsg_alloc = sizeof yymsgbuf;
+                yysyntax_error_status = 2;
+              }
+            else
+              {
+                yysyntax_error_status = YYSYNTAX_ERROR;
+                yymsgp = yymsg;
+              }
+          }
+        yyerror (list_all, list_event, idx, yymsgp);
+        if (yysyntax_error_status == 2)
+          goto yyexhaustedlab;
       }
+# undef YYSYNTAX_ERROR
 #endif
     }
 
@@ -1717,7 +1775,7 @@ yyerrlab:
       else
 	{
 	  yydestruct ("Error: discarding",
-		      yytoken, &yylval, list, idx);
+		      yytoken, &yylval, list_all, list_event, idx);
 	  yychar = YYEMPTY;
 	}
     }
@@ -1756,7 +1814,7 @@ yyerrlab1:
   for (;;)
     {
       yyn = yypact[yystate];
-      if (yyn != YYPACT_NINF)
+      if (!yypact_value_is_default (yyn))
 	{
 	  yyn += YYTERROR;
 	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
@@ -1773,7 +1831,7 @@ yyerrlab1:
 
 
       yydestruct ("Error: popping",
-		  yystos[yystate], yyvsp, list, idx);
+		  yystos[yystate], yyvsp, list_all, list_event, idx);
       YYPOPSTACK (1);
       yystate = *yyssp;
       YY_STACK_PRINT (yyss, yyssp);
@@ -1808,15 +1866,20 @@ yyabortlab:
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
 yyexhaustedlab:
-  yyerror (list, idx, YY_("memory exhausted"));
+  yyerror (list_all, list_event, idx, YY_("memory exhausted"));
   yyresult = 2;
   /* Fall through.  */
 #endif
 
 yyreturn:
   if (yychar != YYEMPTY)
-     yydestruct ("Cleanup: discarding lookahead",
-		 yytoken, &yylval, list, idx);
+    {
+      /* Make sure we have latest lookahead translation.  See comments at
+         user semantic actions for why this is necessary.  */
+      yytoken = YYTRANSLATE (yychar);
+      yydestruct ("Cleanup: discarding lookahead",
+                  yytoken, &yylval, list_all, list_event, idx);
+    }
   /* Do not reclaim the symbols of the rule which action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
@@ -1824,7 +1887,7 @@ yyreturn:
   while (yyssp != yyss)
     {
       yydestruct ("Cleanup: popping",
-		  yystos[*yyssp], yyvsp, list, idx);
+		  yystos[*yyssp], yyvsp, list_all, list_event, idx);
       YYPOPSTACK (1);
     }
 #ifndef yyoverflow
@@ -1841,11 +1904,13 @@ yyreturn:
 
 
 
-/* Line 1684 of yacc.c  */
-#line 212 "util/parse-events.y"
+/* Line 2067 of yacc.c  */
+#line 222 "util/parse-events.y"
 
 
-void parse_events_error(struct list_head *list __used, int *idx __used,
+void parse_events_error(struct list_head *list_all __used,
+			struct list_head *list_event __used,
+			int *idx __used,
 			char const *msg __used)
 {
 }
diff --git a/tools/perf/util/parse-events-bison.h b/tools/perf/util/parse-events-bison.h
index c58b765..0be3e5a 100644
--- a/tools/perf/util/parse-events-bison.h
+++ b/tools/perf/util/parse-events-bison.h
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.5.  */
 
-/* Skeleton interface for Bison's Yacc-like parsers in C
+/* Bison interface for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -59,8 +58,8 @@
 typedef union YYSTYPE
 {
 
-/* Line 1685 of yacc.c  */
-#line 45 "util/parse-events.y"
+/* Line 2068 of yacc.c  */
+#line 46 "util/parse-events.y"
 
 	char *str;
 	unsigned long num;
@@ -69,8 +68,8 @@ typedef union YYSTYPE
 
 
 
-/* Line 1685 of yacc.c  */
-#line 74 "util/parse-events-bison.h"
+/* Line 2068 of yacc.c  */
+#line 73 "util/parse-events-bison.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f542a63..5b3a0ef 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -23,7 +23,8 @@ struct event_symbol {
 	const char	*alias;
 };
 
-int parse_events_parse(struct list_head *list, int *idx);
+int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
+		       int *idx);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -671,6 +672,18 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, (char *) "pmu");
 }
 
+void parse_events_update_lists(struct list_head *list_event,
+			       struct list_head *list_all)
+{
+	/*
+	 * Called for single event definition. Update the
+	 * 'all event' list, and reinit the 'signle event'
+	 * list, for next event definition.
+	 */
+	list_splice_tail(list_event, list_all);
+	INIT_LIST_HEAD(list_event);
+}
+
 int parse_events_modifier(struct list_head *list, char *str)
 {
 	struct perf_evsel *evsel;
@@ -736,14 +749,14 @@ int parse_events_modifier(struct list_head *list, char *str)
 
 int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 {
-	struct perf_evsel *evsel, *h;
 	LIST_HEAD(list);
+	LIST_HEAD(list_tmp);
 	YY_BUFFER_STATE buffer;
 	int ret, idx = evlist->nr_entries;
 
 	buffer = parse_events__scan_string(str);
 
-	ret = parse_events_parse(&list, &idx);
+	ret = parse_events_parse(&list, &list_tmp, &idx);
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
@@ -754,9 +767,11 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 		return 0;
 	}
 
-	list_for_each_entry_safe(evsel, h, &list, node)
-		perf_evsel__delete(evsel);
-
+	/*
+	 * There are 2 users - builtin-record and builtin-test objects.
+	 * Both call perf_evlist__delete in case of error, so we dont
+	 * need to bother.
+	 */
 	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
 	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return ret;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 6d7c74b..ca069f8 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -76,8 +76,11 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
-void parse_events_error(struct list_head *list, int *idx,
-			char const *msg);
+void parse_events_update_lists(struct list_head *list_event,
+			       struct list_head *list_all);
+void parse_events_error(struct list_head *list_all,
+			struct list_head *list_event,
+			int *idx, char const *msg);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 3a53019..d9637da 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,6 +1,7 @@
 
 %name-prefix "parse_events_"
-%parse-param {struct list_head *list}
+%parse-param {struct list_head *list_all}
+%parse-param {struct list_head *list_event}
 %parse-param {int *idx}
 
 %{
@@ -56,10 +57,19 @@ events ',' event | event
 event:
 event_def PE_MODIFIER_EVENT
 {
-	ABORT_ON(parse_events_modifier(list, $2));
+	/*
+	 * Apply modifier on all events added by single event definition
+	 * (there could be more events added for multiple tracepoint
+	 * definitions via '*?'.
+	 */
+	ABORT_ON(parse_events_modifier(list_event, $2));
+	parse_events_update_lists(list_event, list_all);
 }
 |
 event_def
+{
+	parse_events_update_lists(list_event, list_all);
+}
 
 event_def: event_pmu |
 	   event_legacy_symbol |
@@ -72,7 +82,7 @@ event_def: event_pmu |
 event_pmu:
 PE_NAME '/' event_config '/'
 {
-	ABORT_ON(parse_events_add_pmu(list, idx, $1, $3));
+	ABORT_ON(parse_events_add_pmu(list_event, idx, $1, $3));
 	parse_events__free_terms($3);
 }
 
@@ -82,7 +92,7 @@ PE_VALUE_SYM '/' event_config '/'
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config, $3));
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, $3));
 	parse_events__free_terms($3);
 }
 |
@@ -91,52 +101,52 @@ PE_VALUE_SYM sep_slash_dc
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list, idx, type, config, NULL));
+	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
 }
 
 event_legacy_cache:
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list, idx, $1, $3, $5));
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, $5));
 }
 |
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list, idx, $1, $3, NULL));
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, NULL));
 }
 |
 PE_NAME_CACHE_TYPE
 {
-	ABORT_ON(parse_events_add_cache(list, idx, $1, NULL, NULL));
+	ABORT_ON(parse_events_add_cache(list_event, idx, $1, NULL, NULL));
 }
 
 event_legacy_mem:
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) $2, $4));
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, $4));
 }
 |
 PE_PREFIX_MEM PE_VALUE sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list, idx, (void *) $2, NULL));
+	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, NULL));
 }
 
 event_legacy_tracepoint:
 PE_NAME ':' PE_NAME
 {
-	ABORT_ON(parse_events_add_tracepoint(list, idx, $1, $3));
+	ABORT_ON(parse_events_add_tracepoint(list_event, idx, $1, $3));
 }
 
 event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
-	ABORT_ON(parse_events_add_numeric(list, idx, $1, $3, NULL));
+	ABORT_ON(parse_events_add_numeric(list_event, idx, $1, $3, NULL));
 }
 
 event_legacy_raw:
 PE_RAW
 {
-	ABORT_ON(parse_events_add_numeric(list, idx, PERF_TYPE_RAW, $1, NULL));
+	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, $1, NULL));
 }
 
 event_config:
@@ -211,7 +221,9 @@ sep_slash_dc: '/' | ':' |
 
 %%
 
-void parse_events_error(struct list_head *list __used, int *idx __used,
+void parse_events_error(struct list_head *list_all __used,
+			struct list_head *list_event __used,
+			int *idx __used,
 			char const *msg __used)
 {
 }
