Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1GUKNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:13:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:54156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1GUKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:13:14 -0400
Date: Thu, 21 Jul 2011 10:13:03 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-13b62567e909125145f90e91625b1062196d1258@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com, mingo@elte.hu
In-Reply-To: <1310635534-4013-3-git-send-email-jolsa@redhat.com>
References: <1310635534-4013-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add automated tests for events parsing
Git-Commit-ID: 13b62567e909125145f90e91625b1062196d1258
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:13:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13b62567e909125145f90e91625b1062196d1258
Gitweb:     http://git.kernel.org/tip/13b62567e909125145f90e91625b1062196d1258
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 14 Jul 2011 11:25:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:41:13 +0200

perf tools: Add automated tests for events parsing

Adding builtin test for parse_events function, which is
responsible for parsing/processing "-e" option for
stat/top/record commands.

This new test will run within the builtin test command suite
(perf test).

One or several tests were added for each type of event.
More tests could be added easily if needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Link: http://lkml.kernel.org/r/1310635534-4013-3-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-test.c |  245 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 245 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2da9162..b5cd5f5 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -12,6 +12,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "../../include/linux/hw_breakpoint.h"
 
 static long page_size;
 
@@ -600,6 +601,246 @@ out_free_threads:
 #undef nsyscalls
 }
 
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!cond) { \
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
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
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
+static struct test__event_st {
+	const char *name;
+	__u32 type;
+	int (*check)(struct perf_evlist *evlist);
+} test__events[] = {
+	{
+		.name  = "syscalls:sys_enter_open",
+		.check = test__checkevent_tracepoint,
+	},
+	{
+		.name  = "syscalls:*",
+		.check = test__checkevent_tracepoint_multi,
+	},
+	{
+		.name  = "r1",
+		.check = test__checkevent_raw,
+	},
+	{
+		.name  = "1:1",
+		.check = test__checkevent_numeric,
+	},
+	{
+		.name  = "instructions",
+		.check = test__checkevent_symbolic_name,
+	},
+	{
+		.name  = "faults",
+		.check = test__checkevent_symbolic_alias,
+	},
+	{
+		.name  = "L1-dcache-load-miss",
+		.check = test__checkevent_genhw,
+	},
+	{
+		.name  = "mem:0",
+		.check = test__checkevent_breakpoint,
+	},
+	{
+		.name  = "mem:0:x",
+		.check = test__checkevent_breakpoint_x,
+	},
+	{
+		.name  = "mem:0:r",
+		.check = test__checkevent_breakpoint_r,
+	},
+	{
+		.name  = "mem:0:w",
+		.check = test__checkevent_breakpoint_w,
+	},
+};
+
+#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
+
+static int test__parse_events(void)
+{
+	struct perf_evlist *evlist;
+	u_int i;
+	int ret = 0;
+
+	for (i = 0; i < TEST__EVENTS_CNT; i++) {
+		struct test__event_st *e = &test__events[i];
+
+		evlist = perf_evlist__new(NULL, NULL);
+		if (evlist == NULL)
+			break;
+
+		ret = parse_events(evlist, e->name, 0);
+		if (ret) {
+			pr_debug("failed to parse event '%s', err %d\n",
+				 e->name, ret);
+			break;
+		}
+
+		ret = e->check(evlist);
+		if (ret)
+			break;
+
+		perf_evlist__delete(evlist);
+	}
+
+	return ret;
+}
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -621,6 +862,10 @@ static struct test {
 		.func = test__basic_mmap,
 	},
 	{
+		.desc = "parse events tests",
+		.func = test__parse_events,
+	},
+	{
 		.func = NULL,
 	},
 };
