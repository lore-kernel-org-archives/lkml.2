Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0DBUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:48:47 -0400
Received: from toro.web-alm.net ([62.245.132.31]:44744 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0DBUsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:48:33 -0400
Message-Id: <20100402204331.167439615@osadl.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Apr 2010 22:40:19 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Veen <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pradyumna Sampath <pradysam@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 1/2] provide-schedule_hrtimeout-for-wallclock.patch
References: <20100402204018.575140584@osadl.org>
Content-Disposition: inline; filename=provide-schedule_hrtimeout-for-wallclock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of schedule_hrtimeout() always uses the
monotonic clock. Some system calls such as mq_timedsend()
and mq_timedreceive(), however, require the use of the wall
clock due to the definition of the system call.

This patch provides the infrastructure to use schedule_hrtimeout() 
with a wallclock timer.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Veen <arjan@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 include/linux/hrtimer.h |    2 +
 kernel/hrtimer.c        |   66 +++++++++++++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

Index: head/include/linux/hrtimer.h
===================================================================
--- head.orig/include/linux/hrtimer.h
+++ head/include/linux/hrtimer.h
@@ -422,6 +422,8 @@ extern void hrtimer_init_sleeper(struct 
 
 extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 						const enum hrtimer_mode mode);
+extern int schedule_hrtimeout_range_clock(ktime_t *expires,
+		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
Index: head/kernel/hrtimer.c
===================================================================
--- head.orig/kernel/hrtimer.c
+++ head/kernel/hrtimer.c
@@ -1749,35 +1749,14 @@ void __init hrtimers_init(void)
 }
 
 /**
- * schedule_hrtimeout_range - sleep until timeout
+ * schedule_hrtimeout_range_clock - sleep until timeout
  * @expires:	timeout value (ktime_t)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
- *
- * Make the current task sleep until the given expiry time has
- * elapsed. The routine will return immediately unless
- * the current task state has been set (see set_current_state()).
- *
- * The @delta argument gives the kernel the freedom to schedule the
- * actual wakeup to a time that is both power and performance friendly.
- * The kernel give the normal best effort behavior for "@expires+@delta",
- * but may decide to fire the timer earlier, but no earlier than @expires.
- *
- * You can set the task state as follows -
- *
- * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
- * pass before the routine returns.
- *
- * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
- * delivered to the current task.
- *
- * The current task state is guaranteed to be TASK_RUNNING when this
- * routine returns.
- *
- * Returns 0 when the timer has expired otherwise -EINTR
+ * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
  */
-int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
-			       const enum hrtimer_mode mode)
+int __sched schedule_hrtimeout_range_clock(ktime_t *expires,
+	unsigned long delta, const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
 
@@ -1799,7 +1778,7 @@ int __sched schedule_hrtimeout_range(kti
 		return -EINTR;
 	}
 
-	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	hrtimer_init_on_stack(&t.timer, clock, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 
 	hrtimer_init_sleeper(&t, current);
@@ -1818,6 +1797,41 @@ int __sched schedule_hrtimeout_range(kti
 
 	return !t.task ? 0 : -EINTR;
 }
+
+/**
+ * schedule_hrtimeout_range - sleep until timeout
+ * @expires:	timeout value (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t)
+ * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until the given expiry time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * The @delta argument gives the kernel the freedom to schedule the
+ * actual wakeup to a time that is both power and performance friendly.
+ * The kernel give the normal best effort behavior for "@expires+@delta",
+ * but may decide to fire the timer earlier, but no earlier than @expires.
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns.
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task.
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Returns 0 when the timer has expired otherwise -EINTR
+ */
+int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+       const enum hrtimer_mode mode)
+{
+	return schedule_hrtimeout_range_clock(expires, delta, mode,
+	    CLOCK_MONOTONIC);
+}
 EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 
 /**

