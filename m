Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0DFT4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:56:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab0DFT4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:56:15 -0400
Date: Tue, 6 Apr 2010 19:54:58 GMT
From: tip-bot for Carsten Emde <C.Emde@osadl.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       pradysam@gmail.com, arjan@infradead.org, akpm@linux-foundation.org,
       tglx@linutronix.de, C.Emde@osadl.org
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, pradysam@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, C.Emde@osadl.org
In-Reply-To: <20100402204331.167439615@osadl.org>
References: <20100402204331.167439615@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimers: Provide schedule_hrtimeout for CLOCK_REALTIME
Message-ID: <tip-351b3f7a21e413a9b14d0393171497d2373bd702@git.kernel.org>
Git-Commit-ID: 351b3f7a21e413a9b14d0393171497d2373bd702
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 19:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  351b3f7a21e413a9b14d0393171497d2373bd702
Gitweb:     http://git.kernel.org/tip/351b3f7a21e413a9b14d0393171497d2373bd702
Author:     Carsten Emde <C.Emde@osadl.org>
AuthorDate: Fri, 2 Apr 2010 22:40:19 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 6 Apr 2010 21:50:03 +0200

hrtimers: Provide schedule_hrtimeout for CLOCK_REALTIME

The current version of schedule_hrtimeout() always uses the
monotonic clock. Some system calls such as mq_timedsend()
and mq_timedreceive(), however, require the use of the wall
clock due to the definition of the system call.

This patch provides the infrastructure to use schedule_hrtimeout() 
with a CLOCK_REALTIME timer.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Veen <arjan@infradead.org>
LKML-Reference: <20100402204331.167439615@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/hrtimer.h |    2 +
 kernel/hrtimer.c        |   67 ++++++++++++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 5d86fb2..fd0c1b8 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -422,6 +422,8 @@ extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 
 extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 						const enum hrtimer_mode mode);
+extern int schedule_hrtimeout_range_clock(ktime_t *expires,
+		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..b9b134b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1749,35 +1749,15 @@ void __init hrtimers_init(void)
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
+int __sched
+schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
+			       const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
 
@@ -1799,7 +1779,7 @@ int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 		return -EINTR;
 	}
 
-	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	hrtimer_init_on_stack(&t.timer, clock, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 
 	hrtimer_init_sleeper(&t, current);
@@ -1818,6 +1798,41 @@ int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 
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
+				     const enum hrtimer_mode mode)
+{
+	return schedule_hrtimeout_range_clock(expires, delta, mode,
+					      CLOCK_MONOTONIC);
+}
 EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 
 /**
