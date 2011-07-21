Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1GUSLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:11:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1GUSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:11:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=uaDsez9XeLiLBfSld+KukE+mNPudDKf5lNU3gN+zH6Ndl3FF66zkd9RwxffHHe/MV
	AK3ur8BkwN/I45icJTH/w==
From: Alex Neronskiy <zakmagnus@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@google.com>
Subject: [PATCH v3 2/2] Make hard lockup detection use timestamps
Date: Thu, 21 Jul 2011 11:11:13 -0700
Message-Id: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard lockup detector is made to work more like the soft lockup
detector by using timestamps to compare how long it's been since
an event happened. Specifically, when the period function that checks
for soft lockups fires, it touches a timestamp, and the hard lockup
detector now checks if the timer is late, based on when it last fired.
Hard stalls are now sub-hardlock threshold delays in the timer's
firing which are nonetheless notable.

Signed-off-by: Alex Neronskiy <zakmagnus@google.com>
---
 kernel/watchdog.c |   83 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index bf26810..17bcded 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -40,30 +40,28 @@ static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
+static DEFINE_PER_CPU(unsigned long, hrtimer_touch_ts);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 
 unsigned long worst_hardstall;
 static DEFINE_SPINLOCK(hardstall_lock);
 
-/* The number of consecutive hard check failures before it's a lockup */
-#define hardlockup_thresh (5)
+/* How often to check for hard lockups compared to watchdog_thresh */
+#define hardlockup_freq (5)
 
-/*
- * The minimum expected number of missed interrupts in a normal hard
- * lockup check.
- */
-#define hardstall_thresh (2)
-
-#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+/* How late (in ms) a timer could be while still being ignored as "normal" */
+#define hardstall_thresh (200)
 
 /*
  * The number of milliseconds by which a stall must be worse than the
  * current worst in order to be recorded. This prevents bursts of near-
  * identical stalls.
  */
+#define hardstall_diff_thresh (100)
+
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
+/* Difference threshold for soft stalls (ms) */
 #define softstall_diff_thresh (100)
 
 /* boot commands */
@@ -156,6 +154,11 @@ static unsigned long get_sample_period(void)
 	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
 
+static inline unsigned long get_sample_period_ms(void)
+{
+	return get_sample_period() >> 20LL;
+}
+
 /* Commands for resetting the watchdog */
 static void __touch_watchdog(void)
 {
@@ -211,11 +214,11 @@ void touch_softlockup_watchdog_sync(void)
 static void update_hardstall(unsigned long stall, int this_cpu)
 {
 	int update_stall = 0;
-
-	if (stall > hardstall_thresh && stall > worst_hardstall) {
+	if (stall > hardstall_thresh &&
+			stall > worst_hardstall + hardstall_diff_thresh) {
 		unsigned long flags;
 		spin_lock_irqsave(&hardstall_lock, flags);
-		update_stall = stall > worst_hardstall;
+		update_stall = stall > worst_hardstall + hardstall_diff_thresh;
 		if (update_stall)
 			worst_hardstall = stall;
 		spin_unlock_irqrestore(&hardstall_lock, flags);
@@ -223,7 +226,7 @@ static void update_hardstall(unsigned long stall, int this_cpu)
 
 	if (update_stall) {
 		printk(KERN_WARNING "LOCKUP may be in progress!"
-			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
+			"Worst hard stall seen on CPU#%d: %lums\n",
 			this_cpu, stall);
 		dump_stack();
 	}
@@ -231,21 +234,27 @@ static void update_hardstall(unsigned long stall, int this_cpu)
 
 static int is_hardlockup(int this_cpu)
 {
-	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
-	unsigned long hrint_saved = __this_cpu_read(hrtimer_interrupts_saved);
-	unsigned long ints_missed = 0;
+	unsigned long touch_ts = __this_cpu_read(hrtimer_touch_ts);
+	unsigned long next_touch = touch_ts + get_sample_period_ms();
+	unsigned long now = get_timestamp(this_cpu);
+	unsigned long delay = now - next_touch;
 
-	__this_cpu_write(hrtimer_interrupts_saved, hrint);
+	/* the timer has never fired; no data to go on yet */
+	if (unlikely(!touch_ts))
+		return 0;
 
-	if (hrint_saved == hrint)
-		ints_missed = per_cpu(hrtimer_interrupts_missed, this_cpu)++;
-	else
-		__this_cpu_write(hrtimer_interrupts_missed, 0);
+	/*
+	 * If the next touch is supposed to be in the future, then
+	 * everything is fine. If it's not, that means it was missed
+	 * and something's wrong.
+	 */
+	if (time_after(next_touch, now))
+		return 0;
 
-	if (ints_missed >= hardlockup_thresh)
+	if (delay >= (watchdog_thresh << 10L))
 		return 1;
 
-	update_hardstall(ints_missed, this_cpu);
+	update_hardstall(delay, this_cpu);
 	return 0;
 }
 #endif
@@ -311,10 +320,10 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 	}
 
 	/* check for a hardlockup
-	 * This is done by making sure our timer interrupt
-	 * is incrementing.  The timer interrupt should have
-	 * fired multiple times before we overflow'd.  If it hasn't
-	 * then this is a good indication the cpu is stuck
+	 * This is done by making sure our timer interrupts
+	 * are firing. It is known approximately when the timer
+	 * should fire and if it hasn't by then this is a good
+	 * indication the cpu is stuck.
 	 */
 	lockup = is_hardlockup(this_cpu);
 	if (lockup) {
@@ -334,12 +343,12 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 	__this_cpu_write(hard_watchdog_warn, false);
 	return;
 }
-static void watchdog_interrupt_count(void)
+static void watchdog_interrupt_touch(int this_cpu)
 {
-	__this_cpu_inc(hrtimer_interrupts);
+	__this_cpu_write(hrtimer_touch_ts, get_timestamp(this_cpu));
 }
 #else
-static inline void watchdog_interrupt_count(void) { return; }
+static inline void watchdog_interrupt_touch(int this_cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* watchdog kicker functions */
@@ -350,15 +359,15 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	int duration;
 	int this_cpu = smp_processor_id();
 
-	/* kick the hardlockup detector */
-	watchdog_interrupt_count();
-
 	/* kick the softlockup detector */
 	wake_up_process(__this_cpu_read(softlockup_watchdog));
 
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
 
+	/* kick the hardlockup detector now that the timer's been scheduled */
+	watchdog_interrupt_touch(this_cpu);
+
 	if (touch_ts == 0) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
@@ -460,7 +469,7 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
-	do_div(wd_attr->sample_period, hardlockup_thresh);
+	do_div(wd_attr->sample_period, hardlockup_freq);
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
-- 
1.7.3.1

