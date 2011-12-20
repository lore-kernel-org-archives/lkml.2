Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1LTK3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:29:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1LTK3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:29:33 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 2/2] perf, tool: Add more automated tests for event parsing
Date: Tue, 20 Dec 2011 11:29:15 +0100
Message-Id: <1324376955-3187-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1324376955-3187-1-git-send-email-jolsa@redhat.com>
References: <1324044159.18942.104.camel@twins>
 <1324376955-3187-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated tests for event parsing to include testing
for modifier and ',' operator.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |  276 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 275 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 6173f78..c45e2ae 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -603,7 +603,7 @@ out_free_threads:
 
 #define TEST_ASSERT_VAL(text, cond) \
 do { \
-	if (!cond) { \
+	if (!(cond)) { \
 		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
 		return -1; \
 	} \
@@ -649,6 +649,34 @@ static int test__checkevent_raw(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config2);
+	return 0;
+}
+
+static int test__checkevent_raw_config1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 2 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config2);
+	return 0;
+}
+
+static int test__checkevent_raw_config12(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config", 2 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config", 3 == evsel->attr.config2);
 	return 0;
 }
 
@@ -759,6 +787,196 @@ static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
 	return 0;
 }
 
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
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
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
+	TEST_ASSERT_VAL("wrong config", 2 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config2);
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
@@ -777,6 +995,14 @@ static struct test__event_st {
 		.check = test__checkevent_raw,
 	},
 	{
+		.name  = "r1-2",
+		.check = test__checkevent_raw_config1,
+	},
+	{
+		.name  = "r1-2-3",
+		.check = test__checkevent_raw_config12,
+	},
+	{
 		.name  = "1:1",
 		.check = test__checkevent_numeric,
 	},
@@ -808,6 +1034,54 @@ static struct test__event_st {
 		.name  = "mem:0:w",
 		.check = test__checkevent_breakpoint_w,
 	},
+	{
+		.name  = "syscalls:sys_enter_open:k",
+		.check = test__checkevent_tracepoint_modifier,
+	},
+	{
+		.name  = "syscalls:*:u",
+		.check = test__checkevent_tracepoint_multi_modifier,
+	},
+	{
+		.name  = "r1:kp",
+		.check = test__checkevent_raw_modifier,
+	},
+	{
+		.name  = "1:1:hp",
+		.check = test__checkevent_numeric_modifier,
+	},
+	{
+		.name  = "instructions:h",
+		.check = test__checkevent_symbolic_name_modifier,
+	},
+	{
+		.name  = "faults:u",
+		.check = test__checkevent_symbolic_alias_modifier,
+	},
+	{
+		.name  = "L1-dcache-load-miss:kpp",
+		.check = test__checkevent_genhw_modifier,
+	},
+	{
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
+		.name  = "r1-2,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
-- 
1.7.4

