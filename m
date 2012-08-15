Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2HOULJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:11:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63044 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2HOTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 113/165] hrtimer: Provide clock_was_set_delayed()
Date: Wed, 15 Aug 2012 15:47:37 -0400
Message-ID: <1345060109-9187-114-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f55a6faa384304c89cfef162768e88374d3312cb upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/hrtimer.h |  7 +++++++
 kernel/hrtimer.c        | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 5d86fb2..0325598 100644
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
index 3c727aa..dc41268 100644
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
1.7.12.rc2

