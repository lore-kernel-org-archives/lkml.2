Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1B1Dw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:52:27 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:34937 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1B1DwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:25 -0500
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="335905757"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 1/6] perf events: Introduce realtime clock event
Date: Sun, 27 Feb 2011 20:52:26 -0700
Message-Id: <1298865151-23656-2-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The motivation for this event is to correlate perf_clock() time stamps
to wall-clock (gettimeofday()) equivalents for comparing perf events
to other log files.

This patch is based on the monotonic patch by Arnaldo Carvalho de Melo
<acme@redhat.com>.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 include/linux/perf_event.h     |    1 +
 kernel/perf_event.c            |   66 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c |    2 +
 3 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8ceb5a6..51a2f34 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -105,6 +105,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_REALTIME_CLOCK		= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64a018e..a25a63d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5432,6 +5432,7 @@ static int perf_swevent_init(struct perf_event *event)
 	switch (event_id) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 	case PERF_COUNT_SW_TASK_CLOCK:
+	case PERF_COUNT_SW_REALTIME_CLOCK:
 		return -ENOENT;
 
 	default:
@@ -5770,6 +5771,70 @@ static struct pmu perf_cpu_clock = {
 };
 
 /*
+ * Software event: realtime wall time clock
+ */
+
+static void realtime_clock_event_update(struct perf_event *event)
+{
+	u64 now = ktime_to_ns(ktime_get_real());
+	local64_set(&event->count, now);
+}
+
+static void realtime_clock_event_start(struct perf_event *event, int flags)
+{
+	realtime_clock_event_update(event);
+	perf_swevent_start_hrtimer(event);
+}
+
+static void realtime_clock_event_stop(struct perf_event *event, int flags)
+{
+	perf_swevent_cancel_hrtimer(event);
+	realtime_clock_event_update(event);
+}
+
+static int realtime_clock_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		realtime_clock_event_start(event, flags);
+
+	return 0;
+}
+
+static void realtime_clock_event_del(struct perf_event *event, int flags)
+{
+	realtime_clock_event_stop(event, flags);
+}
+
+static void realtime_clock_event_read(struct perf_event *event)
+{
+	realtime_clock_event_update(event);
+}
+
+static int realtime_clock_event_init(struct perf_event *event)
+{
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	if (event->attr.config != PERF_COUNT_SW_REALTIME_CLOCK)
+		return -ENOENT;
+
+	perf_swevent_init_hrtimer(event);
+
+	return 0;
+}
+
+static struct pmu perf_realtime_clock = {
+	.task_ctx_nr	= perf_sw_context,
+
+	.event_init	= realtime_clock_event_init,
+	.add		= realtime_clock_event_add,
+	.del		= realtime_clock_event_del,
+	.start		= realtime_clock_event_start,
+	.stop		= realtime_clock_event_stop,
+	.read		= realtime_clock_event_read,
+};
+
+/*
  * Software event: task time clock
  */
 
@@ -7296,6 +7361,7 @@ void __init perf_event_init(void)
 	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
+	perf_pmu_register(&perf_realtime_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 54a7e26..c40bfef 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -41,6 +41,7 @@ static struct event_symbol event_symbols[] = {
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
+  { CSW(REALTIME_CLOCK),	"clock-realtime",	"clkr"		},
   { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
   { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
@@ -78,6 +79,7 @@ static const char *sw_event_names[] = {
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"realtime-clock-msecs",
 };
 
 #define MAX_ALIASES 8
-- 
1.7.4

