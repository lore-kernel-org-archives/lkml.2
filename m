Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2GJWoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:44:04 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43474 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab2GJWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:58 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
Date: Tue, 10 Jul 2012 18:43:19 -0400
Message-Id: <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-4242-0000-0000-000002474F57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock_was_set() cannot be called from hard interrupt context because
it calls on_each_cpu(). For fixing the widely reported leap seconds
issue it's necessary to call it from the timer interrupt context.

Provide a new function which denotes it in the hrtimer cpu base
structure of the cpu on which it is called and raising the timer
softirq.

We then execute the clock_was_set() notificiation in the timer softirq
context in hrtimer_run_pending().

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/hrtimer.h |    5 ++++-
 kernel/hrtimer.c        |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..4c3dac8 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @active_bases:	Bitfield to mark bases with active timers
+ * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -177,7 +178,8 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
-	unsigned long			active_bases;
+	unsigned int			active_bases;
+	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -309,6 +311,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 #endif
 
 extern void clock_was_set(void);
+extern void clock_was_set_delayed(void);
 #ifdef CONFIG_TIMERFD
 extern void timerfd_clock_was_set(void);
 #else
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..7c20cb8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -756,6 +756,19 @@ void clock_was_set(void)
 }
 
 /*
+ * Called from timekeeping code to reprogramm the hrtimer interrupt
+ * device. If called from the timer interrupt context we defer it to
+ * softirq context.
+ */
+void clock_was_set_delayed(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(TIMER_SOFTIRQ);
+}
+
+/*
  * During resume we might have to reprogram the high resolution timer
  * interrupt (on the local CPU):
  */
@@ -1413,6 +1426,13 @@ static inline void __hrtimer_peek_ahead_timers(void) { }
  */
 void hrtimer_run_pending(void)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	if (cpu_base->clock_was_set) {
+		cpu_base->clock_was_set = 0;
+		clock_was_set();
+	}
+
 	if (hrtimer_hres_active())
 		return;
 
-- 
1.7.9.5

