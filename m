Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DONlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab2DONlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:41:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/6] perf, tool: Add hardcoded name term for pmu events
Date: Sun, 15 Apr 2012 15:40:34 +0200
Message-Id: <1334497234-5441-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
References: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a new hardcoded term 'name' allowing to specify a name
for the pmu event. The term is defined along with standard
pmu terms. If no 'name' term is given, the event name become
the pmu name itself ('cpu' for the example below).

running:
  perf stat -e cpu/config=1,name=krava1/u ls

will produce following output:
 ...
 Performance counter stats for 'ls':

                 0 krava1

       0.009779735 seconds time elapsed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |   25 +++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   12 +++++++++++-
 tools/perf/util/parse-events.h      |    2 ++
 tools/perf/util/parse-events.l      |    1 +
 tools/perf/util/parse-events.y      |    8 ++++++++
 tools/perf/util/pmu.c               |   15 +++++++++++++--
 tools/perf/util/pmu.h               |    2 ++
 7 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index c1d41ba..5b50780 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -386,6 +386,27 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	/* cpu/config=1,name=krava1/u */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "krava"));
+
+	/* cpu/config=2/" */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "cpu"));
+
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -491,6 +512,10 @@ static struct test__event_st {
 		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
 		.check = test__checkevent_list,
 	},
+	[25] = {
+		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
+		.check = test__checkevent_pmu_name,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 59324e7..d628d01 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -634,6 +634,9 @@ do {								\
 		 * attr->branch_sample_type = term->val.num;
 		 */
 		break;
+	case PARSE_EVENTS__TERM_TYPE_NAME:
+		CHECK_TYPE_VAL(STR);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -693,7 +696,9 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+	name = perf_pmu__event_name(name, head_config);
+
+	return add_event(list, idx, &attr, name);
 }
 
 void parse_events_update_lists(struct list_head *list_event,
@@ -1046,6 +1051,11 @@ int parse_events__is_hardcoded_term(struct parse_events__term *term)
 	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
 }
 
+int parse_events__is_name_term(struct parse_events__term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
+}
+
 static int new_term(struct parse_events__term **_term, int type_val,
 		    int type_term, char *config,
 		    char *str, long num)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 5633b32..4b4f803 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -46,6 +46,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_CONFIG,
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
@@ -62,6 +63,7 @@ struct parse_events__term {
 };
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
+int parse_events__is_name_term(struct parse_events__term *term);
 int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
 int parse_events__term_str(struct parse_events__term **_term,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 84644dd..956e995 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -105,6 +105,7 @@ misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
 config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+name			{ return term(PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 126fad0..362cc59 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -237,6 +237,14 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_TERM '=' PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_str(&term, $1, NULL, $3));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8ee219b..5526446 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -258,9 +258,9 @@ static int pmu_config_term(struct list_head *formats,
 static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 		      struct list_head *head_terms)
 {
-	struct parse_events__term *term, *h;
+	struct parse_events__term *term;
 
-	list_for_each_entry_safe(term, h, head_terms, list)
+	list_for_each_entry(term, head_terms, list)
 		if (pmu_config_term(formats, attr, term))
 			return -EINVAL;
 
@@ -308,6 +308,17 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 		set_bit(b, bits);
 }
 
+char *perf_pmu__event_name(char *name, struct list_head *head_terms)
+{
+	struct parse_events__term *term;
+
+	list_for_each_entry(term, head_terms, list)
+		if (parse_events__is_name_term(term))
+			return term->val.str;
+
+	return name;
+}
+
 /* Simulated format definitions. */
 static struct test_format {
 	const char *name;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..f602745 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -37,5 +37,7 @@ int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits);
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
 
+char *perf_pmu__event_name(char *name, struct list_head *head_terms);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.7.6

