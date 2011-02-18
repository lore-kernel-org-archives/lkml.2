Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1BRFyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:54:02 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:29254 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1BRFx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:53:58 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.62,185,1297036800"; 
   d="scan'208";a="265626818"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@ghostprotocols.net,
        paulus@samba.org, David Ahern <daahern@cisco.com>
Subject: [PATCH 2/3] perf events: Introduce realtime clock event
Date: Thu, 17 Feb 2011 22:53:52 -0700
Message-Id: <1298008433-22911-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298008433-22911-1-git-send-email-daahern@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The motivation for this event is to convert perf_clock() time stamps
to wall-clock (gettimeofday()) equivalents, including adjustments made
by NTP (e.g., for comparing perf events to other log files).

This patch is based on the monotonic patch by Arnaldo Carvalho de Melo
<acme@redhat.com>.

(NOTE: Comments from the last review of the timehist patch series
suggested calling this a monotonic clock. I am not trying to be
dense here; since gettimeofday maps to realtime clock I think that
is the better name for it.)

Signed-off-by: David Ahern <daahern@cisco.com>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   72 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

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
index 3280671..4b6d29c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5413,6 +5413,7 @@ static int perf_swevent_init(struct perf_event *event)
 	switch (event_id) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 	case PERF_COUNT_SW_TASK_CLOCK:
+	case PERF_COUNT_SW_REALTIME_CLOCK:
 		return -ENOENT;
 
 	default:
@@ -5599,6 +5600,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	struct perf_sample_data data;
 	struct pt_regs *regs;
 	struct perf_event *event;
+	struct perf_raw_record raw;
 	u64 period;
 
 	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
@@ -5610,6 +5612,13 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) 
+	{
+		raw.size = sizeof(u64);
+		raw.data = &event->count;
+		data.raw = &raw;
+	}
+
 	regs = get_irq_regs();
 
 	if (regs && !perf_exclude_event(event, regs)) {
@@ -5751,6 +5760,68 @@ static struct pmu perf_cpu_clock = {
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
 
@@ -7285,6 +7356,7 @@ void __init perf_event_init(void)
 	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
+	perf_pmu_register(&perf_realtime_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
-- 
1.7.3.4

