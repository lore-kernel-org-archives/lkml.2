Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0EQWGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:06:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0EQWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:06:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] lockup_detector: convert per_cpu to __get_cpu_var for readability
Date: Mon, 17 May 2010 18:06:04 -0400
Message-Id: <1274133966-18415-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
References: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a bunch of conversions as suggested by Frederic W.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e53622c..91b0b26 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -115,7 +115,7 @@ static unsigned long get_sample_period(void)
 /* Commands for resetting the watchdog */
 static void __touch_watchdog(void)
 {
-	int this_cpu = raw_smp_processor_id();
+	int this_cpu = smp_processor_id();
 
 	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
 }
@@ -157,21 +157,21 @@ void touch_softlockup_watchdog_sync(void)
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
-static int is_hardlockup(int cpu)
+static int is_hardlockup(void)
 {
-	unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
+	unsigned long hrint = __get_cpu_var(hrtimer_interrupts);
 
-	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
+	if (__get_cpu_var(hrtimer_interrupts_saved) == hrint)
 		return 1;
 
-	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+	__get_cpu_var(hrtimer_interrupts_saved) = hrint;
 	return 0;
 }
 #endif
 
-static int is_softlockup(unsigned long touch_ts, int cpu)
+static int is_softlockup(unsigned long touch_ts)
 {
-	unsigned long now = get_timestamp(cpu);
+	unsigned long now = get_timestamp(smp_processor_id());
 
 	/* Warn about unreasonable delays: */
 	if (time_after(now, touch_ts + softlockup_thresh))
@@ -206,8 +206,6 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
-	int this_cpu = smp_processor_id();
-
 	if (__get_cpu_var(watchdog_nmi_touch) == true) {
 		__get_cpu_var(watchdog_nmi_touch) = false;
 		return;
@@ -219,7 +217,9 @@ void watchdog_overflow_callback(struct perf_event *event, int nmi,
 	 * fired multiple times before we overflow'd.  If it hasn't
 	 * then this is a good indication the cpu is stuck
 	 */
-	if (is_hardlockup(this_cpu)) {
+	if (is_hardlockup()) {
+		int this_cpu = smp_processor_id();
+
 		/* only print hardlockups once */
 		if (__get_cpu_var(hard_watchdog_warn) == true)
 			return;
@@ -247,7 +247,6 @@ static inline void watchdog_interrupt_count(void) { return; }
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
-	int this_cpu = smp_processor_id();
 	unsigned long touch_ts = __get_cpu_var(watchdog_touch_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
@@ -262,12 +261,12 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
 
 	if (touch_ts == 0) {
-		if (unlikely(per_cpu(softlockup_touch_sync, this_cpu))) {
+		if (unlikely(__get_cpu_var(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
 			 * make sure the scheduler tick is up to date.
 			 */
-			per_cpu(softlockup_touch_sync, this_cpu) = false;
+			__get_cpu_var(softlockup_touch_sync) = false;
 			sched_clock_tick();
 		}
 		__touch_watchdog();
@@ -280,14 +279,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 * indicate it is getting cpu time.  If it hasn't then
 	 * this is a good indication some task is hogging the cpu
 	 */
-	duration = is_softlockup(touch_ts, this_cpu);
+	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
 		/* only warn once */
 		if (__get_cpu_var(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
 		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
-			this_cpu, duration,
+			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
 		print_modules();
 		print_irqtrace_events(current);
@@ -309,10 +308,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 /*
  * The watchdog thread - touches the timestamp.
  */
-static int watchdog(void *__bind_cpu)
+static int watchdog(void *unused)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, (unsigned long)__bind_cpu);
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
@@ -328,7 +327,7 @@ static int watchdog(void *__bind_cpu)
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 60 seconds then the
-	 * debug-printout triggers in softlockup_tick().
+	 * debug-printout triggers in watchdog_timer_fn().
 	 */
 	while (!kthread_should_stop()) {
 		__touch_watchdog();
-- 
1.7.0.1

