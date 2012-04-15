Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2DONly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:41:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2DONky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:40:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/6] perf, tool: Move parse event automated tests to separated object
Date: Sun, 15 Apr 2012 15:40:30 +0200
Message-Id: <1334497234-5441-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
References: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving event parsing specific tests into separated file:
  util/parse-events-test.c

Also changing the code a bit to ease running separate tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                 |    1 +
 tools/perf/builtin-test.c           |  522 +----------------------------------
 tools/perf/util/parse-events-test.c |  535 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h      |    4 +
 4 files changed, 541 insertions(+), 521 deletions(-)
 create mode 100644 tools/perf/util/parse-events-test.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c..5f5bc9c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -319,6 +319,7 @@ LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
+LIB_OBJS += $(OUTPUT)util/parse-events-test.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b980..7c61eef 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -604,526 +604,6 @@ out_free_threads:
 #undef nsyscalls
 }
 
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-static int test__checkevent_tracepoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_TRACEPOINT == evsel->attr.type);
-		TEST_ASSERT_VAL("wrong sample_type",
-			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
-			== evsel->attr.sample_type);
-		TEST_ASSERT_VAL("wrong sample_period",
-			1 == evsel->attr.sample_period);
-	}
-	return 0;
-}
-
-static int test__checkevent_raw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_numeric(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong period",
-			100000 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong config1",
-			0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",
-			1 == evsel->attr.config2);
-	return 0;
-}
-
-static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_genhw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_breakpoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
-					 evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
-					evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_X == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_R == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_W == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_tracepoint(evlist);
-}
-
-static int
-test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong exclude_user",
-				!evsel->attr.exclude_user);
-		TEST_ASSERT_VAL("wrong exclude_kernel",
-				evsel->attr.exclude_kernel);
-		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	}
-
-	return test__checkevent_tracepoint_multi(evlist);
-}
-
-static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_raw(evlist);
-}
-
-static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_numeric(evlist);
-}
-
-static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_alias(evlist);
-}
-
-static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_genhw(evlist);
-}
-
-static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint(evlist);
-}
-
-static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_x(evlist);
-}
-
-static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_r(evlist);
-}
-
-static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_w(evlist);
-}
-
-static int test__checkevent_pmu(struct perf_evlist *evlist)
-{
-
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
-
-	return 0;
-}
-
-static int test__checkevent_list(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* r1 */
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* syscalls:sys_enter_open:k */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* 1:1:hp */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static struct test__event_st {
-	const char *name;
-	__u32 type;
-	int (*check)(struct perf_evlist *evlist);
-} test__events[] = {
-	{
-		.name  = "syscalls:sys_enter_open",
-		.check = test__checkevent_tracepoint,
-	},
-	{
-		.name  = "syscalls:*",
-		.check = test__checkevent_tracepoint_multi,
-	},
-	{
-		.name  = "r1a",
-		.check = test__checkevent_raw,
-	},
-	{
-		.name  = "1:1",
-		.check = test__checkevent_numeric,
-	},
-	{
-		.name  = "instructions",
-		.check = test__checkevent_symbolic_name,
-	},
-	{
-		.name  = "cycles/period=100000,config2/",
-		.check = test__checkevent_symbolic_name_config,
-	},
-	{
-		.name  = "faults",
-		.check = test__checkevent_symbolic_alias,
-	},
-	{
-		.name  = "L1-dcache-load-miss",
-		.check = test__checkevent_genhw,
-	},
-	{
-		.name  = "mem:0",
-		.check = test__checkevent_breakpoint,
-	},
-	{
-		.name  = "mem:0:x",
-		.check = test__checkevent_breakpoint_x,
-	},
-	{
-		.name  = "mem:0:r",
-		.check = test__checkevent_breakpoint_r,
-	},
-	{
-		.name  = "mem:0:w",
-		.check = test__checkevent_breakpoint_w,
-	},
-	{
-		.name  = "syscalls:sys_enter_open:k",
-		.check = test__checkevent_tracepoint_modifier,
-	},
-	{
-		.name  = "syscalls:*:u",
-		.check = test__checkevent_tracepoint_multi_modifier,
-	},
-	{
-		.name  = "r1a:kp",
-		.check = test__checkevent_raw_modifier,
-	},
-	{
-		.name  = "1:1:hp",
-		.check = test__checkevent_numeric_modifier,
-	},
-	{
-		.name  = "instructions:h",
-		.check = test__checkevent_symbolic_name_modifier,
-	},
-	{
-		.name  = "faults:u",
-		.check = test__checkevent_symbolic_alias_modifier,
-	},
-	{
-		.name  = "L1-dcache-load-miss:kp",
-		.check = test__checkevent_genhw_modifier,
-	},
-	{
-		.name  = "mem:0:u",
-		.check = test__checkevent_breakpoint_modifier,
-	},
-	{
-		.name  = "mem:0:x:k",
-		.check = test__checkevent_breakpoint_x_modifier,
-	},
-	{
-		.name  = "mem:0:r:hp",
-		.check = test__checkevent_breakpoint_r_modifier,
-	},
-	{
-		.name  = "mem:0:w:up",
-		.check = test__checkevent_breakpoint_w_modifier,
-	},
-	{
-		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
-		.check = test__checkevent_pmu,
-	},
-	{
-		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
-		.check = test__checkevent_list,
-	},
-};
-
-#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
-
-static int test__parse_events(void)
-{
-	struct perf_evlist *evlist;
-	u_int i;
-	int ret = 0;
-
-	for (i = 0; i < TEST__EVENTS_CNT; i++) {
-		struct test__event_st *e = &test__events[i];
-
-		evlist = perf_evlist__new(NULL, NULL);
-		if (evlist == NULL)
-			break;
-
-		ret = parse_events(evlist, e->name, 0);
-		if (ret) {
-			pr_debug("failed to parse event '%s', err %d\n",
-				 e->name, ret);
-			break;
-		}
-
-		ret = e->check(evlist);
-		perf_evlist__delete(evlist);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
 					 size_t *sizep)
 {
@@ -1644,7 +1124,7 @@ static struct test {
 	},
 	{
 		.desc = "parse events tests",
-		.func = test__parse_events,
+		.func = parse_events__test,
 	},
 #if defined(__x86_64__) || defined(__i386__)
 	{
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
new file mode 100644
index 0000000..c1d41ba
--- /dev/null
+++ b/tools/perf/util/parse-events-test.c
@@ -0,0 +1,535 @@
+
+#include "parse-events.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "../../../include/linux/hw_breakpoint.h"
+
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+static int test__checkevent_tracepoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_TRACEPOINT == evsel->attr.type);
+		TEST_ASSERT_VAL("wrong sample_type",
+			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
+			== evsel->attr.sample_type);
+		TEST_ASSERT_VAL("wrong sample_period",
+			1 == evsel->attr.sample_period);
+	}
+	return 0;
+}
+
+static int test__checkevent_raw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_numeric(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	return 0;
+}
+
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
+static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_genhw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_breakpoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
+					evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_X == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_R == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_W == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_tracepoint(evlist);
+}
+
+static int
+test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong exclude_user",
+				!evsel->attr.exclude_user);
+		TEST_ASSERT_VAL("wrong exclude_kernel",
+				evsel->attr.exclude_kernel);
+		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	}
+
+	return test__checkevent_tracepoint_multi(evlist);
+}
+
+static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_raw(evlist);
+}
+
+static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_numeric(evlist);
+}
+
+static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_alias(evlist);
+}
+
+static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_genhw(evlist);
+}
+
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
+static struct test__event_st {
+	const char *name;
+	__u32 type;
+	int (*check)(struct perf_evlist *evlist);
+} test__events[] = {
+	[0] = {
+		.name  = "syscalls:sys_enter_open",
+		.check = test__checkevent_tracepoint,
+	},
+	[1] = {
+		.name  = "syscalls:*",
+		.check = test__checkevent_tracepoint_multi,
+	},
+	[2] = {
+		.name  = "r1a",
+		.check = test__checkevent_raw,
+	},
+	[3] = {
+		.name  = "1:1",
+		.check = test__checkevent_numeric,
+	},
+	[4] = {
+		.name  = "instructions",
+		.check = test__checkevent_symbolic_name,
+	},
+	[5] = {
+		.name  = "cycles/period=100000,config2/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	[6] = {
+		.name  = "faults",
+		.check = test__checkevent_symbolic_alias,
+	},
+	[7] = {
+		.name  = "L1-dcache-load-miss",
+		.check = test__checkevent_genhw,
+	},
+	[8] = {
+		.name  = "mem:0",
+		.check = test__checkevent_breakpoint,
+	},
+	[9] = {
+		.name  = "mem:0:x",
+		.check = test__checkevent_breakpoint_x,
+	},
+	[10] = {
+		.name  = "mem:0:r",
+		.check = test__checkevent_breakpoint_r,
+	},
+	[11] = {
+		.name  = "mem:0:w",
+		.check = test__checkevent_breakpoint_w,
+	},
+	[12] = {
+		.name  = "syscalls:sys_enter_open:k",
+		.check = test__checkevent_tracepoint_modifier,
+	},
+	[13] = {
+		.name  = "syscalls:*:u",
+		.check = test__checkevent_tracepoint_multi_modifier,
+	},
+	[14] = {
+		.name  = "r1a:kp",
+		.check = test__checkevent_raw_modifier,
+	},
+	[15] = {
+		.name  = "1:1:hp",
+		.check = test__checkevent_numeric_modifier,
+	},
+	[16] = {
+		.name  = "instructions:h",
+		.check = test__checkevent_symbolic_name_modifier,
+	},
+	[17] = {
+		.name  = "faults:u",
+		.check = test__checkevent_symbolic_alias_modifier,
+	},
+	[18] = {
+		.name  = "L1-dcache-load-miss:kp",
+		.check = test__checkevent_genhw_modifier,
+	},
+	[19] = {
+		.name  = "mem:0:u",
+		.check = test__checkevent_breakpoint_modifier,
+	},
+	[20] = {
+		.name  = "mem:0:x:k",
+		.check = test__checkevent_breakpoint_x_modifier,
+	},
+	[21] = {
+		.name  = "mem:0:r:hp",
+		.check = test__checkevent_breakpoint_r_modifier,
+	},
+	[22] = {
+		.name  = "mem:0:w:up",
+		.check = test__checkevent_breakpoint_w_modifier,
+	},
+	[23] = {
+		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
+		.check = test__checkevent_pmu,
+	},
+	[24] = {
+		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
+};
+
+#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
+
+static int test(struct test__event_st *e)
+{
+	struct perf_evlist *evlist;
+	int ret;
+
+	evlist = perf_evlist__new(NULL, NULL);
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	ret = parse_events(evlist, e->name, 0);
+	if (ret) {
+		pr_debug("failed to parse event '%s', err %d\n",
+			 e->name, ret);
+		return ret;
+	}
+
+	ret = e->check(evlist);
+	perf_evlist__delete(evlist);
+
+	return ret;
+}
+
+int parse_events__test(void)
+{
+	u_int i;
+	int ret = 0;
+
+	for (i = 0; i < TEST__EVENTS_CNT; i++) {
+		struct test__event_st *e = &test__events[i];
+
+		pr_debug("running test %d '%s'\n", i, e->name);
+		ret = test(e);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index a39e15d..6f1f86c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,6 +4,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+#include <linux/list.h>
+#include <stdbool.h>
+#include "types.h"
 #include "../../../include/linux/perf_event.h"
 
 struct list_head;
@@ -84,6 +87,7 @@ void parse_events_update_lists(struct list_head *list_event,
 void parse_events_error(struct list_head *list_all,
 			struct list_head *list_event,
 			int *idx, char const *msg);
+int parse_events__test(void);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
-- 
1.7.7.6

