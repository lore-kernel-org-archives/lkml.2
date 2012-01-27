Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2A0KbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:31:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2A0KbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:31:03 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] hrtimers: move default_timer_slack_ns to system-wide sysctl
Date: Fri, 27 Jan 2012 14:30:58 +0400
Message-Id: <1327660258-27544-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - moving default_timer_slack_ns from per-task field to global variable
   controlled via sysctl() in [0..1000000] range (usecs) provides some
   more system-wide control beyond per-task prctl();

 - task_time_slack() should be used to get default timer slack if no
   special requirements exists.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 include/linux/hrtimer.h |    1 +
 include/linux/sched.h   |   11 ++++++++---
 kernel/fork.c           |    3 ---
 kernel/futex.c          |    4 ++--
 kernel/hrtimer.c        |   10 +++++++---
 kernel/sys.c            |    3 ++-
 kernel/sysctl.c         |   10 ++++++++++
 7 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..855d45e 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -323,6 +323,7 @@ extern ktime_t ktime_get_monotonic_offset(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
+extern int default_timer_slack_ns;
 
 /* Exported timer functions: */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..4f475aa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1551,11 +1551,11 @@ struct task_struct {
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
 	/*
-	 * time slack values; these are used to round up poll() and
-	 * select() etc timeout values. These are in nanoseconds.
+	 * High-resolution timer slack value, in nanoseconds.
+	 * Used to round up poll()/select(), nanosleep, futex
+	 * waiting, etc. timeout values for non-realtime tasks.
 	 */
 	unsigned long timer_slack_ns;
-	unsigned long default_timer_slack_ns;
 
 	struct list_head	*scm_work_list;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -2622,6 +2622,11 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+static inline unsigned long task_timer_slack(struct task_struct *tsk)
+{
+	return rt_task(tsk) ? 0 : tsk->timer_slack_ns;
+}
+
 /*
  * Thread group CPU time accounting.
  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 051f090..b0e8f63 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1144,9 +1144,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
-
-	p->default_timer_slack_ns = current->timer_slack_ns;
-
 	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 1614be2..a0d302d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1887,7 +1887,7 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+					     task_timer_slack(current));
 	}
 
 retry:
@@ -2281,7 +2281,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+					     task_timer_slack(current));
 	}
 
 	/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..0704559 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -51,6 +51,12 @@
 #include <trace/events/timer.h>
 
 /*
+ * Default hrtimer slack value, in nanoseconds. May be
+ * changed via sysctl within [0..1000000] range.
+ */
+int default_timer_slack_ns = 50000;
+
+/*
  * The timer bases:
  *
  * There are more clockids then hrtimer bases. Thus, we index
@@ -1564,9 +1570,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	int ret = 0;
 	unsigned long slack;
 
-	slack = current->timer_slack_ns;
-	if (rt_task(current))
-		slack = 0;
+	slack = task_timer_slack(current);
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..db36543 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/key.h>
 #include <linux/times.h>
+#include <linux/hrtimer.h>
 #include <linux/posix-timers.h>
 #include <linux/security.h>
 #include <linux/dcookies.h>
@@ -1919,7 +1920,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
 				current->timer_slack_ns =
-					current->default_timer_slack_ns;
+					default_timer_slack_ns;
 			else
 				current->timer_slack_ns = arg2;
 			error = 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..c9a731b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -122,6 +122,7 @@ static int __maybe_unused two = 2;
 static int __maybe_unused three = 3;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+static int million = 1000000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -1004,6 +1005,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "timer_slack",
+		.data		= &default_timer_slack_ns,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &million,
+	},
 	{ }
 };
 
-- 
1.7.7.5

