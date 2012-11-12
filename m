Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2KLReo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2KLReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:34:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf tool: Fix 'disabled' attribute config for record command
Date: Mon, 12 Nov 2012 18:34:01 +0100
Message-Id: <1352741644-16809-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the record command sets all events initially as disabled.

There's non conditional perf_evlist__enable call, that enables
all events before we exec tracee program. That actually screws
whole enable_on_exec logic, because the event is enabled before
the traced program got executed.

What we actually want is:

1) For any type of traced program:
  - all independent events and group leaders are disabled
  - all group members are enabled

   Group members are ruled by group leaders. They need to
   be enabled, because the group scheduling relies on that.

2) For traced programs executed by perf:
   - all independent events and group leaders have
     enable_on_exec set
   - we don't specifically enable or disable any event during
     the record command

   Independent events and group leaders are initially disabled
   and get enabled by exec. Group members are ruled by group
   leaders as stated in 1).

3) For traced programs attached by perf (pid/tid):
   - we specifically enable or disable all events during
     the record command

   When attaching events to already running traced we
   enable/disable events specifically, as there's no
   initial traced exec call.

Fixing appropriate perf_event_attr test case to cover this change.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c              | 15 ++++++++++--
 tools/perf/tests/attr/test-record-group  |  1 +
 tools/perf/tests/attr/test-record-group1 |  1 +
 tools/perf/util/evsel.c                  | 42 +++++++++++++++++++++++++++++++-
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3717027..268b356 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -701,7 +701,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
-	perf_evlist__enable(evsel_list);
+	/*
+	 * When perf is starting the traced process, all the events
+	 * (apart from group members) have enable_on_exec=1 set,
+	 * so don't spoil it by prematurely enabling them.
+	 */
+	if (!perf_target__none(&opts->target))
+		perf_evlist__enable(evsel_list);
 
 	/*
 	 * Let the child rip
@@ -724,7 +730,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			waking++;
 		}
 
-		if (done)
+		/*
+		 * When perf is starting the traced process, at the end events
+		 * die with the process and we wait for that. Thus no need to
+		 * disable events in this case.
+		 */
+		if (done && !perf_target__none(&opts->target))
 			perf_evlist__disable(evsel_list);
 	}
 
diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-record-group
index b945f77..a6599e9 100644
--- a/tools/perf/tests/attr/test-record-group
+++ b/tools/perf/tests/attr/test-record-group
@@ -15,3 +15,4 @@ sample_type=327
 mmap=0
 comm=0
 enable_on_exec=0
+disabled=0
diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
index 013572f..5a8359d 100644
--- a/tools/perf/tests/attr/test-record-group1
+++ b/tools/perf/tests/attr/test-record-group1
@@ -16,3 +16,4 @@ sample_type=327
 mmap=0
 comm=0
 enable_on_exec=0
+disabled=0
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6d4a5f6..fc4faaa 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -404,13 +404,40 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 	return evsel->name ?: "unknown";
 }
 
+/*
+ * The enable_on_exec/disabled value strategy:
+ *
+ *  1) For any type of traced program:
+ *    - all independent events and group leaders are disabled
+ *    - all group members are enabled
+ *
+ *     Group members are ruled by group leaders. They need to
+ *     be enabled, because the group scheduling relies on that.
+ *
+ *  2) For traced programs executed by perf:
+ *     - all independent events and group leaders have
+ *       enable_on_exec set
+ *     - we don't specifically enable or disable any event during
+ *       the record command
+ *
+ *     Independent events and group leaders are initially disabled
+ *     and get enabled by exec. Group members are ruled by group
+ *     leaders as stated in 1).
+ *
+ *  3) For traced programs attached by perf (pid/tid):
+ *     - we specifically enable or disable all events during
+ *       the record command
+ *
+ *     When attaching events to already running traced we
+ *     enable/disable events specifically, as there's no
+ *     initial traced exec call.
+ */
 void perf_evsel__config(struct perf_evsel *evsel,
 			struct perf_record_opts *opts)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->disabled = 1;
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -486,6 +513,19 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	attr->mmap = track;
 	attr->comm = track;
 
+	/*
+	 * XXX see the function comment above
+	 *
+	 * Disabling only independent events or group leaders,
+	 * keeping group members enabled.
+	 */
+	if (!evsel->leader)
+		attr->disabled = 1;
+
+	/*
+	 * Setting enable_on_exec for independent events and
+	 * group leaders for traced executed by perf.
+	 */
 	if (perf_target__none(&opts->target) && (!evsel->leader))
 		attr->enable_on_exec = 1;
 }
-- 
1.7.11.7

