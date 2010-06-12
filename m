Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0FLHfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:35:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53099 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0FLHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=s64ucA2hSf9atcqleSK/S4Be5ljBIp8gi+pxVl6YSKS511ZtMvfgwB5IUiObsbE3rt
         kfcwLpCGM7e0QZq86JMuVfPe8eAypxiCg0q++YtkK52GWM96udS7PBVVlee3ynG/nmxY
         i7U1AWTyvspQ/w8zVnNSM/8umEVAeJCk/cqJg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/5] perf: Ability to enable in a paused mode
Date: Sat, 12 Jun 2010 09:34:56 +0200
Message-Id: <1276328098-24114-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to provide task context exclusion, we need to be able
to schedule an event in a "paused" mode. This is what does the
new pmu->reserve callback. It means the event must have its place
reserved in the cpu but it won't actually start until an explicit
call to the pmu->start() callback.

To maintain this paused state, we also introduce a new
PERF_EVENT_STATE_PAUSED internal state.

PMUs that don't implement the reserve callback won't fully support
the task context exclusion.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event.c |    7 +++++--
 include/linux/perf_event.h       |   10 +++++++++-
 kernel/hw_breakpoint.c           |    1 +
 kernel/perf_event.c              |   34 ++++++++++++++++++++++------------
 4 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..7ee299f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -839,7 +839,8 @@ void hw_perf_enable(void)
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			x86_pmu_stop(event);
+			if (event->state != PERF_EVENT_STATE_PAUSED)
+				x86_pmu_stop(event);
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
@@ -851,7 +852,8 @@ void hw_perf_enable(void)
 			else if (i < n_running)
 				continue;
 
-			x86_pmu_start(event);
+			if (event->state != PERF_EVENT_STATE_PAUSED)
+				x86_pmu_start(event);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
@@ -1452,6 +1454,7 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
+	.reserve	= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.start		= x86_pmu_start,
 	.stop		= x86_pmu_stop,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63b5aa5..cea69c9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -560,6 +560,12 @@ struct perf_event;
  */
 struct pmu {
 	int (*enable)			(struct perf_event *event);
+	/*
+	 * Reserve acts like enable, except the event must go in a "pause"
+	 * state. Ie: it is scheduled but waiting to be started
+	 * with the ->start() callback.
+	 */
+	int (*reserve)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
 	int (*start)			(struct perf_event *event);
 	void (*stop)			(struct perf_event *event);
@@ -598,7 +604,8 @@ enum perf_event_active_state {
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
-	PERF_EVENT_STATE_ACTIVE		=  1,
+	PERF_EVENT_STATE_PAUSED		=  1,
+	PERF_EVENT_STATE_ACTIVE		=  2,
 };
 
 struct file;
@@ -931,6 +938,7 @@ static inline int is_software_event(struct perf_event *event)
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
+extern int perf_swevent_int(struct perf_event *event);
 
 #ifndef perf_arch_fetch_caller_regs
 static inline void
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 7a56b22..739a8e6 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -587,6 +587,7 @@ core_initcall(init_hw_breakpoint);
 
 struct pmu perf_ops_bp = {
 	.enable		= arch_install_hw_breakpoint,
+	.reserve	= perf_swevent_int,
 	.disable	= arch_uninstall_hw_breakpoint,
 	.read		= hw_breakpoint_pmu_read,
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c5f2306..e440f21 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -407,7 +407,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_PAUSED)
 		return;
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
@@ -433,7 +433,7 @@ group_sched_out(struct perf_event *group_event,
 {
 	struct perf_event *event;
 
-	if (group_event->state != PERF_EVENT_STATE_ACTIVE)
+	if (group_event->state < PERF_EVENT_STATE_PAUSED)
 		return;
 
 	event_sched_out(group_event, cpuctx, ctx);
@@ -617,7 +617,7 @@ void perf_event_disable(struct perf_event *event)
 	/*
 	 * If the event is still active, we need to retry the cross-call.
 	 */
-	if (event->state == PERF_EVENT_STATE_ACTIVE) {
+	if (event->state >= PERF_EVENT_STATE_PAUSED) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -810,7 +810,7 @@ static void __perf_install_in_context(void *info)
 	 * it is in a group and the group isn't on.
 	 */
 	if (event->state != PERF_EVENT_STATE_INACTIVE ||
-	    (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE))
+	    (leader != event && leader->state < PERF_EVENT_STATE_PAUSED))
 		goto unlock;
 
 	/*
@@ -955,7 +955,7 @@ static void __perf_event_enable(void *info)
 	 * If the event is in a group and isn't the group leader,
 	 * then don't put it on unless the group is on.
 	 */
-	if (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE)
+	if (leader != event && leader->state < PERF_EVENT_STATE_PAUSED)
 		goto unlock;
 
 	if (!group_can_go_on(event, cpuctx, 1)) {
@@ -1135,7 +1135,7 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	case PERF_EVENT_STATE_ACTIVE:
 		event->pmu->read(event);
 		/* fall-through */
-
+	case PERF_EVENT_STATE_PAUSED:
 	case PERF_EVENT_STATE_INACTIVE:
 		update_event_times(event);
 		break;
@@ -1541,21 +1541,22 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		bool software_event = is_software_event(event);
+		bool reprogram = !is_software_event(event) &&
+				 event->state != PERF_EVENT_STATE_PAUSED;
 
 		/*
 		 * Only hardware events need their irq period to be
 		 * reprogrammed. And stopping and restarting software
 		 * events here would be dangerously racy.
 		 */
-		if (!software_event) {
+		if (reprogram) {
 			perf_disable();
 			perf_event_stop(event);
 		}
 
 		local64_set(&hwc->period_left, 0);
 
-		if (!software_event) {
+		if (reprogram) {
 			perf_event_start(event);
 			perf_enable();
 		}
@@ -1763,7 +1764,7 @@ static u64 perf_event_read(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_ACTIVE) {
 		smp_call_function_single(event->oncpu,
 					 __perf_event_read, event, 1);
-	} else if (event->state == PERF_EVENT_STATE_INACTIVE) {
+	} else if (event->state >= PERF_EVENT_STATE_INACTIVE) {
 		struct perf_event_context *ctx = event->ctx;
 		unsigned long flags;
 
@@ -2339,7 +2340,7 @@ int perf_event_task_disable(void)
 
 static int perf_event_index(struct perf_event *event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_PAUSED)
 		return 0;
 
 	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
@@ -2371,7 +2372,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	barrier();
 	userpg->index = perf_event_index(event);
 	userpg->offset = perf_event_count(event);
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
+	if (event->state >= PERF_EVENT_STATE_PAUSED)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
 	userpg->time_enabled = event->total_time_enabled +
@@ -4299,8 +4300,14 @@ static void perf_swevent_void(struct perf_event *event)
 {
 }
 
+int perf_swevent_int(struct perf_event *event)
+{
+	return 0;
+}
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
+	.reserve	= perf_swevent_int,
 	.disable	= perf_swevent_disable,
 	.read		= perf_swevent_read,
 	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
@@ -4412,6 +4419,7 @@ static void cpu_clock_perf_event_read(struct perf_event *event)
 
 static const struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
+	.reserve	= perf_swevent_int,
 	.disable	= cpu_clock_perf_event_disable,
 	.read		= cpu_clock_perf_event_read,
 };
@@ -4469,6 +4477,7 @@ static void task_clock_perf_event_read(struct perf_event *event)
 
 static const struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
+	.reserve	= perf_swevent_int,
 	.disable	= task_clock_perf_event_disable,
 	.read		= task_clock_perf_event_read,
 };
@@ -4583,6 +4592,7 @@ static int swevent_hlist_get(struct perf_event *event)
 
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
+	.reserve	= perf_swevent_int,
 	.disable	= perf_trace_disable,
 	.read		= perf_swevent_read,
 	.unthrottle	= perf_swevent_void,
-- 
1.6.2.3

