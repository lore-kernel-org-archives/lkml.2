Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2JAXCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35507 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab2JAXCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:11 -0400
Message-Id: <20121001225158.122542529@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 012/180] 2.6.32.x: hrtimer: Provide clock_was_set_delayed()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <johnstul@us.ibm.com>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/hrtimer.h |    7 +++++++
 kernel/hrtimer.c        |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 040b679..a7f48af 100644
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
 	spinlock_t			lock;
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
index a6e9d00..c4acec7 100644
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
@@ -1393,6 +1406,13 @@ void hrtimer_peek_ahead_timers(void)
 
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
1.7.2.1.45.g54fbc



