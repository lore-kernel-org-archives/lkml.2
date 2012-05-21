Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2EUHlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:41:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2EUHlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:41:16 -0400
Date: Mon, 21 May 2012 00:40:49 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-16fa7e8200fb9066b77a3f27cbed8e4a9fc71998@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1335371102-11358-2-git-send-email-jolsa@redhat.com>
References: <1335371102-11358-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Split term type into value type and term type
Git-Commit-ID: 16fa7e8200fb9066b77a3f27cbed8e4a9fc71998
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:40:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16fa7e8200fb9066b77a3f27cbed8e4a9fc71998
Gitweb:     http://git.kernel.org/tip/16fa7e8200fb9066b77a3f27cbed8e4a9fc71998
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 25 Apr 2012 18:24:57 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 18 May 2012 12:15:32 -0300

perf tools: Split term type into value type and term type

Introducing type_val and type_term for term instead of a single type
value. Currently the term type marked out the value type as well.

With this change we can have future string term values being specified
by user and translated into proper number along the processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1335371102-11358-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   45 +++++++++++++++++++------
 tools/perf/util/parse-events.h |   21 +++++++-----
 tools/perf/util/parse-events.y |   16 ++++----
 tools/perf/util/pmu.c          |   70 ++++++++++++++++++++++++----------------
 4 files changed, 96 insertions(+), 56 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..c7fc18a 100644
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
@@ -615,7 +625,9 @@ static int config_term(struct perf_event_attr *attr,
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
+#undef CHECK_TYPE_VAL
 }
 
 static int config_attr(struct perf_event_attr *attr,
@@ -1015,11 +1027,12 @@ void print_events(const char *event_glob)
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term)
 {
-	return term->type <= PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX;
+	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
 }
 
-int parse_events__new_term(struct parse_events__term **_term, int type,
-			   char *config, char *str, long num)
+static int new_term(struct parse_events__term **_term, int type_val,
+		    int type_term, char *config,
+		    char *str, long num)
 {
 	struct parse_events__term *term;
 
@@ -1028,15 +1041,11 @@ int parse_events__new_term(struct parse_events__term **_term, int type,
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
@@ -1051,6 +1060,20 @@ int parse_events__new_term(struct parse_events__term **_term, int type,
 	return 0;
 }
 
+int parse_events__term_num(struct parse_events__term **term,
+			   int type_term, char *config, long num)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
+			config, NULL, num);
+}
+
+int parse_events__term_str(struct parse_events__term **term,
+			   int type_term, char *config, char *str)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR, type_term,
+			config, str, 0);
+}
+
 void parse_events__free_terms(struct list_head *terms)
 {
 	struct parse_events__term *term, *h;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 5cb0028..3fddd61 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -36,16 +36,17 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
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
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
-	PARSE_EVENTS__TERM_TYPE_NUM,
-	PARSE_EVENTS__TERM_TYPE_STR,
-
-	PARSE_EVENTS__TERM_TYPE_HARDCODED_MAX =
-		PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
 struct parse_events__term {
@@ -54,14 +55,16 @@ struct parse_events__term {
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
-int parse_events__new_term(struct parse_events__term **term, int type,
-			   char *config, char *str, long num);
+int parse_events__term_num(struct parse_events__term **_term,
+			   int type_term, char *config, long num);
+int parse_events__term_str(struct parse_events__term **_term,
+			   int type_term, char *config, char *str);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d9637da..936913e 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -176,8 +176,8 @@ PE_NAME '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
-		 $1, $3, 0));
+	ABORT_ON(parse_events__term_str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -185,8 +185,8 @@ PE_NAME '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 $1, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -194,8 +194,8 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
-		 $1, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1));
 	$$ = term;
 }
 |
@@ -203,7 +203,7 @@ PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, $3));
 	$$ = term;
 }
 |
@@ -211,7 +211,7 @@ PE_TERM
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, $1, NULL, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, 1));
 	$$ = term;
 }
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb08a11..8ee219b 100644
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
@@ -324,49 +329,58 @@ static struct test_format {
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
