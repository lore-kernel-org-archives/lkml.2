Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2F1VTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab2F1VTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:19:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: namhyung@kernel.org, bookjovi@gmail.com, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] perf, tool: Fix hw breakpoint's type modifier parsing
Date: Thu, 28 Jun 2012 23:18:48 +0200
Message-Id: <1340918329-3012-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340918329-3012-1-git-send-email-jolsa@redhat.com>
References: <20120628103223.GA1055@krava.redhat.com>
 <1340918329-3012-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the hw breakpoint's type modifier parsing to allow all
possible combinations of 'rwx' characters.

Adding automated tests to the parsing test suite.

Original-patch-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |   37 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   16 ++++++++++++--
 tools/perf/util/parse-events.l      |    2 +-
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 229af6d..50e6a94 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -181,6 +181,22 @@ static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+		(HW_BREAKPOINT_R|HW_BREAKPOINT_W) == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
 static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -352,6 +368,19 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 	return test__checkevent_breakpoint_w(evlist);
 }
 
+static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -584,6 +613,14 @@ static struct test__event_st test__events[] = {
 		.name  = "instructions:H",
 		.check = test__checkevent_exclude_guest_modifier,
 	},
+	[26] = {
+		.name  = "mem:0:rw",
+		.check = test__checkevent_breakpoint_rw,
+	},
+	[27] = {
+		.name  = "mem:0:rw:kp",
+		.check = test__checkevent_breakpoint_rw_modifier,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0cc27da..7ae76af 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -383,21 +383,31 @@ parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 		if (!type || !type[i])
 			break;
 
+#define CHECK_SET_TYPE(bit)		\
+do {					\
+	if (attr->bp_type & bit)	\
+		return -EINVAL;		\
+	else				\
+		attr->bp_type |= bit;	\
+} while (0)
+
 		switch (type[i]) {
 		case 'r':
-			attr->bp_type |= HW_BREAKPOINT_R;
+			CHECK_SET_TYPE(HW_BREAKPOINT_R);
 			break;
 		case 'w':
-			attr->bp_type |= HW_BREAKPOINT_W;
+			CHECK_SET_TYPE(HW_BREAKPOINT_W);
 			break;
 		case 'x':
-			attr->bp_type |= HW_BREAKPOINT_X;
+			CHECK_SET_TYPE(HW_BREAKPOINT_X);
 			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+#undef CHECK_SET_TYPE
+
 	if (!attr->bp_type) /* Default */
 		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 488362e..a066894 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -76,7 +76,7 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 modifier_event	[ukhpGH]{1,8}
-modifier_bp	[rwx]
+modifier_bp	[rwx]{1,3}
 
 %%
 
-- 
1.7.7.6

