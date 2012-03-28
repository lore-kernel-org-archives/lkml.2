Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2C1P6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab2C1P5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:57:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/5] perf, tool: Split term type into value type and term type
Date: Wed, 28 Mar 2012 17:55:50 +0200
Message-Id: <1332950153-8606-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
References: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing type_val and type_term for term, instead of a single
type value. Currently the term type marked out the value type as
well.

With this change we can have future string term values being
specified by user and translated into proper number along the
processing. This is going to be the case for the branch_sample_type
comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-bison.c |   48 ++++++++++++++---------
 tools/perf/util/parse-events.c       |   34 ++++++++++------
 tools/perf/util/parse-events.h       |   19 +++++----
 tools/perf/util/parse-events.y       |   30 ++++++++++----
 tools/perf/util/pmu.c                |   70 ++++++++++++++++++++-------------
 5 files changed, 124 insertions(+), 77 deletions(-)

diff --git a/tools/perf/util/parse-events-bison.c b/tools/perf/util/parse-events-bison.c
index ffa6dd8..d76bb99 100644
--- a/tools/perf/util/parse-events-bison.c
+++ b/tools/perf/util/parse-events-bison.c
@@ -469,8 +469,8 @@ static const yytype_uint8 yyrline[] =
 {
        0,    55,    55,    55,    58,    69,    74,    75,    76,    77,
       78,    79,    80,    83,    90,    99,   108,   113,   118,   124,
-     129,   135,   141,   147,   153,   163,   175,   184,   193,   202,
-     210,   218,   226,   226,   228,   228,   228
+     129,   135,   141,   147,   153,   163,   175,   186,   197,   208,
+     218,   228,   238,   238,   240,   240,   240
 };
 #endif
 
@@ -1616,8 +1616,10 @@ yyreduce:
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
-		 (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), 0));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_STR,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), 0));
 	(yyval.term) = term;
 }
     break;
@@ -1625,12 +1627,14 @@ yyreduce:
   case 27:
 
 /* Line 1806 of yacc.c  */
-#line 185 "util/parse-events.y"
+#line 187 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 (yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (3)].str), NULL, (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
 }
     break;
@@ -1638,12 +1642,14 @@ yyreduce:
   case 28:
 
 /* Line 1806 of yacc.c  */
-#line 194 "util/parse-events.y"
+#line 198 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 (yyvsp[(1) - (1)].str), NULL, 1));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					(yyvsp[(1) - (1)].str), NULL, 1));
 	(yyval.term) = term;
 }
     break;
@@ -1651,11 +1657,13 @@ yyreduce:
   case 29:
 
 /* Line 1806 of yacc.c  */
-#line 203 "util/parse-events.y"
+#line 209 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].str), 0));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_STR,
+					(yyvsp[(1) - (3)].num), NULL, (yyvsp[(3) - (3)].str), 0));
 	(yyval.term) = term;
 }
     break;
@@ -1663,11 +1671,13 @@ yyreduce:
   case 30:
 
 /* Line 1806 of yacc.c  */
-#line 211 "util/parse-events.y"
+#line 219 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (3)].num), NULL, NULL, (yyvsp[(3) - (3)].num)));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					(yyvsp[(1) - (3)].num), NULL, NULL, (yyvsp[(3) - (3)].num)));
 	(yyval.term) = term;
 }
     break;
@@ -1675,11 +1685,13 @@ yyreduce:
   case 31:
 
 /* Line 1806 of yacc.c  */
-#line 219 "util/parse-events.y"
+#line 229 "util/parse-events.y"
     {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, (yyvsp[(1) - (1)].num), NULL, NULL, 1));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					(yyvsp[(1) - (1)].num), NULL, NULL, 1));
 	(yyval.term) = term;
 }
     break;
@@ -1687,7 +1699,7 @@ yyreduce:
 
 
 /* Line 1806 of yacc.c  */
-#line 1691 "util/parse-events-bison.c"
+#line 1703 "util/parse-events-bison.c"
       default: break;
     }
   /* User semantic actions sometimes alter yychar, and that requires
@@ -1918,7 +1930,7 @@ yyreturn:
 
 
 /* Line 2067 of yacc.c  */
-#line 230 "util/parse-events.y"
+#line 242 "util/parse-events.y"
 
 
 void parse_events_error(struct list_head *list_all __used,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3e40c6b..3a05d1b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -593,17 +593,27 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 static int config_term(struct perf_event_attr *attr,
 		       struct parse_events__term *term)
 {
-	switch (term->type) {
+#define CHECK_TYPE_VAL(type)					\
+do {								\
+	if (PARSE_EVENTS__TERM_TYPE_ ## type != term->type_val)	\
+		return -EINVAL;					\
+} while (0)
+
+	switch (term->type_term) {
 	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+		CHECK_TYPE_VAL(NUM);
 		attr->config = term->val.num;
 		break;
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
+		CHECK_TYPE_VAL(NUM);
 		attr->config1 = term->val.num;
 		break;
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
+		CHECK_TYPE_VAL(NUM);
 		attr->config2 = term->val.num;
 		break;
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
+		CHECK_TYPE_VAL(NUM);
 		attr->sample_period = term->val.num;
 		break;
 	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
@@ -615,7 +625,10 @@ static int config_term(struct perf_event_attr *attr,
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
+
+#undef CHECK_TYPE_VAL
 }
 
 static int config_attr(struct perf_event_attr *attr,
@@ -1017,16 +1030,16 @@ void print_events(const char *event_glob)
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term)
 {
-	return term->type <= PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX;
+	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
 }
 
 int parse_events__is_name_term(struct parse_events__term *term)
 {
-	return term->type == PARSE_EVENTS__TERM_TYPE_NAME;
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
 }
 
-int parse_events__new_term(struct parse_events__term **_term, int type,
-			   char *config, char *str, long num)
+int parse_events__new_term(struct parse_events__term **_term, int type_val,
+			   int type_term, char *config, char *str, long num)
 {
 	struct parse_events__term *term;
 
@@ -1035,19 +1048,14 @@ int parse_events__new_term(struct parse_events__term **_term, int type,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&term->list);
-	term->type = type;
+	term->type_val  = type_val;
+	term->type_term = type_term;
 	term->config = config;
 
-	switch (type) {
-	case PARSE_EVENTS__TERM_TYPE_CONFIG:
-	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
-	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
-	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
-	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
+	switch (type_val) {
 	case PARSE_EVENTS__TERM_TYPE_NUM:
 		term->val.num = num;
 		break;
-	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_STR:
 		term->val.str = str;
 		break;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ae0fe60..a5eabe4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -35,17 +35,18 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 #define EVENTS_HELP_MAX (128*1024)
 
 enum {
+	PARSE_EVENTS__TERM_TYPE_NUM,
+	PARSE_EVENTS__TERM_TYPE_STR,
+};
+
+enum {
+	PARSE_EVENTS__TERM_TYPE_USER,
 	PARSE_EVENTS__TERM_TYPE_CONFIG,
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
-	PARSE_EVENTS__TERM_TYPE_NUM,
-	PARSE_EVENTS__TERM_TYPE_STR,
-
-	PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX =
-		PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
 struct parse_events__term {
@@ -54,15 +55,15 @@ struct parse_events__term {
 		char *str;
 		long  num;
 	} val;
-	int type;
-
+	int type_val;
+	int type_term;
 	struct list_head list;
 };
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
 int parse_events__is_name_term(struct parse_events__term *term);
-int parse_events__new_term(struct parse_events__term **term, int type,
-			   char *config, char *str, long num);
+int parse_events__new_term(struct parse_events__term **_term, int type_val,
+			   int type_term, char *config, char *str, long num);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index efa96ce..0d166c4 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -176,8 +176,10 @@ PE_NAME '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
-		 $1, $3, 0));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_STR,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3, 0));
 	$$ = term;
 }
 |
@@ -185,8 +187,10 @@ PE_NAME '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 $1, NULL, $3));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					$1, NULL, $3));
 	$$ = term;
 }
 |
@@ -194,8 +198,10 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 $1, NULL, 1));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					PARSE_EVENTS__TERM_TYPE_USER,
+					$1, NULL, 1));
 	$$ = term;
 }
 |
@@ -203,7 +209,9 @@ PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, $1, NULL, $3, 0));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_STR,
+					$1, NULL, $3, 0));
 	$$ = term;
 }
 |
@@ -211,7 +219,9 @@ PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, $3));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					$1, NULL, NULL, $3));
 	$$ = term;
 }
 |
@@ -219,7 +229,9 @@ PE_TERM
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, 1));
+	ABORT_ON(parse_events__new_term(&term,
+					PARSE_EVENTS__TERM_TYPE_NUM,
+					$1, NULL, NULL, 1));
 	$$ = term;
 }
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7c758ee..5526446 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -225,7 +225,7 @@ static int pmu_config_term(struct list_head *formats,
 	if (parse_events__is_hardcoded_term(term))
 		return 0;
 
-	if (term->type != PARSE_EVENTS__TERM_TYPE_NUM)
+	if (term->type_val != PARSE_EVENTS__TERM_TYPE_NUM)
 		return -EINVAL;
 
 	format = pmu_find_format(formats, term->config);
@@ -246,6 +246,11 @@ static int pmu_config_term(struct list_head *formats,
 		return -EINVAL;
 	}
 
+	/*
+	 * XXX If we ever decide to go with string values for
+	 * non-hardcoded terms, here's the place to translate
+	 * them into value.
+	 */
 	*vp |= pmu_format_value(format->bits, term->val.num);
 	return 0;
 }
@@ -335,49 +340,58 @@ static struct test_format {
 /* Simulated users input. */
 static struct parse_events__term test_terms[] = {
 	{
-		.config  = (char *) "krava01",
-		.val.num = 15,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava01",
+		.val.num   = 15,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava02",
-		.val.num = 170,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava02",
+		.val.num   = 170,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava03",
-		.val.num = 1,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava03",
+		.val.num   = 1,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava11",
-		.val.num = 27,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava11",
+		.val.num   = 27,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava12",
-		.val.num = 1,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava12",
+		.val.num   = 1,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava13",
-		.val.num = 2,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava13",
+		.val.num   = 2,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava21",
-		.val.num = 119,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava21",
+		.val.num   = 119,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava22",
-		.val.num = 11,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava22",
+		.val.num   = 11,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 	{
-		.config  = (char *) "krava23",
-		.val.num = 2,
-		.type    = PARSE_EVENTS__TERM_TYPE_NUM,
+		.config    = (char *) "krava23",
+		.val.num   = 2,
+		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
+		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 };
 #define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
-- 
1.7.6.5

