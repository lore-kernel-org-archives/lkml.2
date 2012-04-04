Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2DDVQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2DDVQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/8] perf, tool: Add modifier support to group event syntax
Date: Wed,  4 Apr 2012 23:16:14 +0200
Message-Id: <1333574176-11388-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to specify the group modifier. Currently it consists
by simple number saying which event inside the group will be group
leader and do the sampling.

The new group syntax is:
  start:     groups
  groups:    groups ';' group
  group:     'group=' events | 'group:' group_mod '=' events
  group_mod: number

It is possible to specify group assignement in event syntax like:
  perf record -e group:1=cycles,faults ls

with meaning: the cycles will sample the faults will be read.

This patch adds only syntax parsing bits. The code doing the actual
group processing follows shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |   26 ++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |    2 +-
 tools/perf/util/parse-events.h      |    2 +-
 tools/perf/util/parse-events.l      |   13 ++++++++++++-
 tools/perf/util/parse-events.y      |   13 +++++++++++--
 5 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index baa4caf..c2f7bd1 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -484,6 +484,28 @@ static int test__checkevent_group(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_group_mod(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+
+	/* cycles */
+	evsel = leader = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* faults */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	return 0;
+}
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -601,6 +623,10 @@ static struct test__event_st {
 		.name  = "group=cycles,faults;r1,mem:0:u;group=cpu/config=2,period=1000/u,instructions:h",
 		.check = test__checkevent_group,
 	},
+	[28] = {
+		.name  = "group:1=cycles,faults",
+		.check = test__checkevent_group_mod,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54bd4d0..d7812bd 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -791,7 +791,7 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-int parse_events__group(struct list_head *list)
+int parse_events__group(struct list_head *list, int mod __used)
 {
 	perf_evlist__group_list(list);
 	return 0;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index a5e1adf..90c3bfa 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -99,7 +99,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
-int parse_events__group(struct list_head *list);
+int parse_events__group(struct list_head *list, int mod);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index aeadbbd..96b9b1b 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -26,6 +26,11 @@ static int value(int base)
 	return __value(parse_events_text, base, PE_VALUE);
 }
 
+static int group_mod(void)
+{
+	return __value(parse_events_text, 10, PE_MODIFIER_GROUP);
+}
+
 static int raw(void)
 {
 	return __value(parse_events_text + 1, 16, PE_RAW);
@@ -51,7 +56,7 @@ static int term(int type)
 
 %}
 
-%x mem
+%x mem group
 
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
@@ -110,6 +115,7 @@ period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
+group:			{ BEGIN(group); return PE_PREFIX_GROUP; }
 group=			{ return PE_PREFIX_GROUP; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
@@ -145,6 +151,11 @@ r{num_raw_hex}		{ return raw(); }
 <<EOF>>			{ BEGIN(INITIAL); }
 }
 
+<group>{
+{num_dec}		{ BEGIN(INITIAL); return group_mod(); }
+.			{ return PE_ERROR; }
+}
+
 %%
 
 int parse_events_wrap(void)
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index a3898d6..8586d87 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -25,7 +25,7 @@ do { \
 
 %token PE_VALUE PE_VALUE_SYM PE_RAW PE_TERM
 %token PE_NAME
-%token PE_MODIFIER_EVENT PE_MODIFIER_BP
+%token PE_MODIFIER_EVENT PE_MODIFIER_BP PE_MODIFIER_GROUP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
@@ -33,6 +33,7 @@ do { \
 %type <num> PE_VALUE_SYM
 %type <num> PE_RAW
 %type <num> PE_TERM
+%type <num> PE_MODIFIER_GROUP
 %type <str> PE_NAME
 %type <str> PE_NAME_CACHE_TYPE
 %type <str> PE_NAME_CACHE_OP_RESULT
@@ -85,11 +86,19 @@ groups ';' group
 group
 
 group:
+PE_PREFIX_GROUP PE_MODIFIER_GROUP '=' events
+{
+	struct list_head *list = $4;
+
+	ABORT_ON(parse_events__group(list, $2));
+	$$ = list;
+}
+|
 PE_PREFIX_GROUP events
 {
 	struct list_head *list = $2;
 
-	ABORT_ON(parse_events__group(list));
+	ABORT_ON(parse_events__group(list, 0));
 	$$ = list;
 }
 |
-- 
1.7.7.6

