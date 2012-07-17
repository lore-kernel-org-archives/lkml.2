Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2GQV70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:59:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2GQV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:59:23 -0400
Subject: Patch "hrtimer: Provide clock_was_set_delayed()" has been added to the 3.4-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        jengelh@inai.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        prarit@redhat.com, tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 14:59:18 -0700
In-Reply-To: <1342507196-54327-2-git-send-email-johnstul@us.ibm.com>
Message-ID: <1342562358846@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    hrtimer: Provide clock_was_set_delayed()

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     hrtimer-provide-clock_was_set_delayed.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 14:22:23 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 02:39:50 -0400
Subject: hrtimer: Provide clock_was_set_delayed()
To: stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <1342507196-54327-2-git-send-email-johnstul@us.ibm.com>

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
Link: http://lkml.kernel.org/r/1341960205-56738-2-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |    9 ++++++++-
 kernel/hrtimer.c        |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

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
@@ -286,6 +288,8 @@ extern void hrtimer_peek_ahead_timers(vo
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
+extern void clock_was_set_delayed(void);
+
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -306,6 +310,9 @@ static inline int hrtimer_is_hres_active
 {
 	return 0;
 }
+
+static inline void clock_was_set_delayed(void) { }
+
 #endif
 
 extern void clock_was_set(void);
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -717,6 +717,19 @@ static int hrtimer_switch_to_hres(void)
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
@@ -1395,6 +1408,13 @@ void hrtimer_peek_ahead_timers(void)
 
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
 


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.4/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.4/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.4/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.4/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.4/hrtimer-provide-clock_was_set_delayed.patch
queue-3.4/timekeeping-provide-hrtimer-update-function.patch
queue-3.4/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
