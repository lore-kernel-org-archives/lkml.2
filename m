Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2F1VTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:19:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2F1VTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:19:02 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: namhyung@kernel.org, bookjovi@gmail.com, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf, tool: Handle hw breakpoints event names via perf_evsel__name
Date: Thu, 28 Jun 2012 23:18:49 +0200
Message-Id: <1340918329-3012-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340918329-3012-1-git-send-email-jolsa@redhat.com>
References: <20120628103223.GA1055@krava.redhat.com>
 <1340918329-3012-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding hw breakpoint events hook to the perf_evsel__name function,
to display event names properly all over the perf.

Updating hw breakpoints events tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c             |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events-test.c |   10 ++++++++++
 tools/perf/util/parse-events.c      |    4 +---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 876f639..9a46487 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,6 +16,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "../../include/linux/perf_event.h"
+#include "../../../include/linux/hw_breakpoint.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
@@ -153,6 +154,31 @@ static int perf_evsel__sw_name(struct perf_evsel *evsel, char *bf, size_t size)
 	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
 }
 
+static int __perf_evsel__bp_name(char *bf, size_t size, u64 addr, u64 type)
+{
+	int r;
+
+	r = snprintf(bf, size, "mem:0x%" PRIx64 ":", addr);
+
+	if (type & HW_BREAKPOINT_R)
+		r += snprintf(bf + r, size - r, "r");
+
+	if (type & HW_BREAKPOINT_W)
+		r += snprintf(bf + r, size - r, "w");
+
+	if (type & HW_BREAKPOINT_X)
+		r += snprintf(bf + r, size - r, "x");
+
+	return r;
+}
+
+static int perf_evsel__bp_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+	int r = __perf_evsel__bp_name(bf, size, attr->bp_addr, attr->bp_type);
+	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
+}
+
 const char *perf_evsel__hw_cache[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_EVSEL__MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
@@ -286,6 +312,10 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 		scnprintf(bf, sizeof(bf), "%s", "unknown tracepoint");
 		break;
 
+	case PERF_TYPE_BREAKPOINT:
+		perf_evsel__bp_name(evsel, bf, sizeof(bf));
+		break;
+
 	default:
 		scnprintf(bf, sizeof(bf), "%s", "unknown attr type");
 		break;
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 50e6a94..5cefbec 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -325,6 +325,8 @@ static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0x0:rw:u"));
 
 	return test__checkevent_breakpoint(evlist);
 }
@@ -338,6 +340,8 @@ static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0x0:x:k"));
 
 	return test__checkevent_breakpoint_x(evlist);
 }
@@ -351,6 +355,8 @@ static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0x0:r:hp"));
 
 	return test__checkevent_breakpoint_r(evlist);
 }
@@ -364,6 +370,8 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0x0:w:up"));
 
 	return test__checkevent_breakpoint_w(evlist);
 }
@@ -377,6 +385,8 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0x0:rw:kp"));
 
 	return test__checkevent_breakpoint_rw(evlist);
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7ae76af..1dc44dc 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -418,7 +418,6 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type)
 {
 	struct perf_event_attr attr;
-	char name[MAX_NAME_LEN];
 
 	memset(&attr, 0, sizeof(attr));
 	attr.bp_addr = (unsigned long) ptr;
@@ -437,8 +436,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 
 	attr.type = PERF_TYPE_BREAKPOINT;
 
-	snprintf(name, MAX_NAME_LEN, "mem:%p:%s", ptr, type ? type : "rw");
-	return add_event(list, idx, &attr, name);
+	return add_event(list, idx, &attr, NULL);
 }
 
 static int config_term(struct perf_event_attr *attr,
-- 
1.7.7.6

