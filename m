Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2C1P5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220Ab2C1P5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:57:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/5] perf, tool: Add pmu event parse support for branch_sample_type values
Date: Wed, 28 Mar 2012 17:55:52 +0200
Message-Id: <1332950153-8606-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
References: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a support to specify branch_type as a hardcoded term
inside the pmu event definition.

It is possible to specify pmu event like:
  "cpu/config=1,branch_type=hv|any_ret|1,config2=2/u"

Following string values could be used as value for branch_type:
  u (PERF_SAMPLE_BRANCH_USER)
  k (PERF_SAMPLE_BRANCH_KERNEL)
  hv (PERF_SAMPLE_BRANCH_HV)
  any (PERF_SAMPLE_BRANCH_ANY)
  any_call (PERF_SAMPLE_BRANCH_ANY_CALL)
  any_ret (PERF_SAMPLE_BRANCH_ANY_RETURN)
  ind_call (PERF_SAMPLE_BRANCH_IND_CALL)

Also a number could be specified as value.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c    |   31 +-----------
 tools/perf/builtin-test.c      |   27 +++++++++++
 tools/perf/util/parse-events.c |  100 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/parse-events.h |    1 +
 4 files changed, 127 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be4e1ee..87fc68d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -641,27 +641,6 @@ out_delete_session:
 	return err;
 }
 
-#define BRANCH_OPT(n, m) \
-	{ .name = n, .mode = (m) }
-
-#define BRANCH_END { .name = NULL }
-
-struct branch_mode {
-	const char *name;
-	int mode;
-};
-
-static const struct branch_mode branch_modes[] = {
-	BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
-	BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
-	BRANCH_OPT("hv", PERF_SAMPLE_BRANCH_HV),
-	BRANCH_OPT("any", PERF_SAMPLE_BRANCH_ANY),
-	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
-	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
-	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
-	BRANCH_END
-};
-
 static int
 parse_branch_stack(const struct option *opt, const char *str, int unset)
 {
@@ -671,7 +650,6 @@ parse_branch_stack(const struct option *opt, const char *str, int unset)
 	 PERF_SAMPLE_BRANCH_HV)
 
 	uint64_t *mode = (uint64_t *)opt->value;
-	const struct branch_mode *br;
 	char *s, *os = NULL, *p;
 	int ret = -1;
 
@@ -692,21 +670,18 @@ parse_branch_stack(const struct option *opt, const char *str, int unset)
 			return -1;
 
 		for (;;) {
+			u64 bmode;
 			p = strchr(s, ',');
 			if (p)
 				*p = '\0';
 
-			for (br = branch_modes; br->name; br++) {
-				if (!strcasecmp(s, br->name))
-					break;
-			}
-			if (!br->name) {
+			if (parse_events__branch_type(&bmode, s)) {
 				ui__warning("unknown branch filter %s,"
 					    " check man page\n", s);
 				goto error;
 			}
 
-			*mode |= br->mode;
+			*mode |= bmode;
 
 			if (!p)
 				break;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index d522cf4..2e4dc0a 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1008,6 +1008,29 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_branch_type(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config2", 2 == evsel->attr.config2);
+
+#define BT (PERF_SAMPLE_BRANCH_USER | \
+	    PERF_SAMPLE_BRANCH_HV | \
+	    PERF_SAMPLE_BRANCH_ANY_RETURN)
+
+	TEST_ASSERT_VAL("wrong sample_type",
+		PERF_SAMPLE_BRANCH_STACK && evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong branch_type",
+		BT == evsel->attr.branch_sample_type);
+
+#undef BT
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -1117,6 +1140,10 @@ static struct test__event_st {
 		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
 		.check = test__checkevent_pmu_name,
 	},
+	{
+		.name  = "cpu/config=1,branch_type=hv|any_ret|1,config2=2/u",
+		.check = test__checkevent_pmu_branch_type,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 29892c0..3e99637 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -590,6 +590,99 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
+#define BRANCH_OPT(n, m) { .name = n, .mode = (m) }
+#define BRANCH_END { .name = NULL }
+
+struct branch_mode {
+	const char *name;
+	int mode;
+};
+
+static const struct branch_mode branch_modes[] = {
+	BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
+	BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
+	BRANCH_OPT("hv", PERF_SAMPLE_BRANCH_HV),
+	BRANCH_OPT("any", PERF_SAMPLE_BRANCH_ANY),
+	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
+	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
+	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_END
+};
+
+int parse_events__branch_type(u64 *_type, char *str)
+{
+	const struct branch_mode *br;
+
+	for (br = branch_modes; br->name; br++) {
+		if (!strcasecmp(str, br->name)) {
+			*_type = br->mode;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+typedef int (process_term_list_cb)(struct parse_events__term_elem *elem,
+				   void *arg);
+
+static int branch_type_cb(struct parse_events__term_elem *elem, void *arg)
+{
+	u64 *_type = arg;
+	u64 type;
+
+	switch (elem->type_val) {
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		type = elem->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		if (parse_events__branch_type(&type, elem->val.str))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_type |= type;
+	return 0;
+}
+
+static int process_term_list(struct parse_events__term *term,
+			     process_term_list_cb cb, void *arg)
+{
+	struct parse_events__term_elem *elem;
+
+	list_for_each_entry(elem, &term->val.list, list)
+		if (cb(elem, arg))
+			return -EINVAL;
+
+	return 0;
+}
+
+static int branch_type(struct parse_events__term *term, u64 *_type)
+{
+	u64 type = 0;
+
+	switch (term->type_val) {
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		type = term->val.num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		if (parse_events__branch_type(&type, term->val.str))
+			return -EINVAL;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_LIST:
+		if (process_term_list(term, branch_type_cb, &type))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_type = type;
+	return 0;
+}
+
 static int config_term(struct perf_event_attr *attr,
 		       struct parse_events__term *term)
 {
@@ -617,10 +710,9 @@ do {								\
 		attr->sample_period = term->val.num;
 		break;
 	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
-		/*
-		 * TODO uncomment when the field is available
-		 * attr->branch_sample_type = term->val.num;
-		 */
+		attr->sample_type |= PERF_SAMPLE_BRANCH_STACK;
+		if (branch_type(term, (u64 *)&attr->branch_sample_type))
+			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index cabcbc1..8bb673d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -83,6 +83,7 @@ int parse_events__term_list(struct parse_events__term **_term,
 			    struct list_head *list);
 int parse_events__term_elem(struct parse_events__term_elem **_e,
 			    int type_val, char *str, long num);
+int parse_events__branch_type(u64 *_type, char *str);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
-- 
1.7.6.5

