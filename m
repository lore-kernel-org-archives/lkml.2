Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2GQSIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:08:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53792 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab2GQSIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:08:05 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] 2.6.35.x: hrtimer: Provide clock_was_set_delayed()
Date: Tue, 17 Jul 2012 14:05:36 -0400
Message-Id: <1342548342-19683-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
References: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071718-8974-0000-0000-00000B406BEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a backport of f55a6faa384304c89cfef162768e88374d3312cb

clock_was_set() cannot be called from hard interrupt context because
it calls on_each_cpu().

For fixing the widely reported leap seconds issue it is necessary to
call it from hard interrupt context, i.e. the timer tick code, which
does the timekeeping updates.

Provide a new function which denotes it in the hrtimer cpu base
structure of the cpu on which it is called and raise the hrtimer
softirq. We then execute the clock_was_set() notificiation from
softirq context in run_hrtimer_softirq(). The hrtimer softirq is
rarely used, so polling the flag there is not a performance issue.

[ tglx: Made it depend on CONFIG_HIGH_RES_TIMERS. We really should get
  rid of all this ifdeffery ASAP ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-2-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/hrtimer.h |    7 +++++++
 kernel/hrtimer.c        |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0c1b8..39d5222 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -159,6 +159,7 @@ struct hrtimer_clock_base {
  *			and timers
  * @clock_base:		array of clock bases for this cpu
  * @curr_timer:		the timer which is executing a callback right now
+ * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -171,6 +172,7 @@ struct hrtimer_clock_base {
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
+	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -280,6 +282,8 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
+extern void clock_was_set_delayed(void);
+
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -308,6 +312,9 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 {
 	return 0;
 }
+
+static inline void clock_was_set_delayed(void) { }
+
 #endif
 
 extern ktime_t ktime_get(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 21e0c5e..c1f7d12 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -738,6 +738,19 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+/*
+ * Called from timekeeping code to reprogramm the hrtimer interrupt
+ * device. If called from the timer interrupt context we defer it to
+ * softirq context.
+ */
+void clock_was_set_delayed(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+}
+
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -1409,6 +1422,13 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	if (cpu_base->clock_was_set) {
+		cpu_base->clock_was_set = 0;
+		clock_was_set();
+	}
+
 	hrtimer_peek_ahead_timers();
 }
 
-- 
1.7.9.5

