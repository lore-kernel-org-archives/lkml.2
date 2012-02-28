Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2B1IpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:45:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36527 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab2B1IpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:45:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.145.145 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
MIME-Version: 1.0
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [RFC PATCH] hrtimers: system-wide and per-task hrtimer slacks
Date: Tue, 28 Feb 2012 12:46:17 +0400
Message-Id: <1330418777-29597-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes a system-wide sysctl-aware default for the
high-resolution timer slack value, which may be changed from 0
to HRTIMER_MAX_SLACK nanoseconds. Default system-wide and per-task
values are HRTIMER_DEFAULT_SLACK. Per-task value isn't inherited
across fork(); instead, newborn task uses system-wide value by
default, and newborn thread uses it's group leader value.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 Documentation/sysctl/kernel.txt |    8 ++++++++
 include/linux/hrtimer.h         |   11 +++++++++++
 include/linux/init_task.h       |    2 +-
 include/linux/sched.h           |   11 ++++++++---
 kernel/fork.c                   |    9 +++++++--
 kernel/futex.c                  |    4 ++--
 kernel/hrtimer.c                |   10 +++++++---
 kernel/sys.c                    |    8 +++++---
 kernel/sysctl.c                 |   10 ++++++++++
 9 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..83b63ed 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -606,6 +606,14 @@ can be ORed together:
 
 ==============================================================
 
+timer_slack:
+
+This value can be used to query and set the default slack for
+high-resolution timers, in nanoseconds. The default value is 50
+microseconds, and can be changed from 0 nanoseconds to 1 millisecond.
+
+==============================================================
+
 unknown_nmi_panic:
 
 The value in this file affects behavior of handling NMI. When the
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..b9da137 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -24,6 +24,16 @@
 #include <linux/timer.h>
 #include <linux/timerqueue.h>
 
+/*
+ * Default system-wide and per-task hrtimer slack, in nanoseconds.
+ */
+#define HRTIMER_DEFAULT_SLACK 50000
+
+/*
+ * Reasonable limit for hrtimer slack, in nanoseconds.
+ */
+#define HRTIMER_MAX_SLACK 1000000
+
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
 
@@ -323,6 +333,7 @@ extern ktime_t ktime_get_monotonic_offset(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
+extern int default_timer_slack_ns;
 
 /* Exported timer functions: */
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..b29be0d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -178,7 +178,7 @@ extern struct cred init_cred;
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),	\
-	.timer_slack_ns = 50000, /* 50 usec default slack */		\
+	.timer_slack_ns = HRTIMER_DEFAULT_SLACK,			\
 	.pids = {							\
 		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..aa0a806 100644
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
+	 * waiting, etc. timeout values of non-realtime tasks.
 	 */
 	unsigned long timer_slack_ns;
-	unsigned long default_timer_slack_ns;
 
 	struct list_head	*scm_work_list;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -2628,6 +2628,11 @@ static inline int spin_needbreak(spinlock_t *lock)
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
index e2cd3e2..0f9a983 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1167,8 +1167,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
-
-	p->default_timer_slack_ns = current->timer_slack_ns;
+	/* 
+	 * New thread inherits the slack from the group
+	 * leader. New process uses system-default slack.
+	 */
+	p->timer_slack_ns = (clone_flags & CLONE_THREAD) ?
+		current->group_leader->timer_slack_ns :
+		default_timer_slack_ns;
 
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
index ae34bf5..0c56fec 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -51,6 +51,12 @@
 #include <trace/events/timer.h>
 
 /*
+ * Default hrtimer slack value, in nanoseconds. May be changed in
+ * [0..HRTIMER_MAX_SLACK] range through kernel.timer_slack sysctl.
+ */
+__read_mostly int default_timer_slack_ns = HRTIMER_DEFAULT_SLACK;
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
index 4070153..e976540 100644
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
@@ -1919,10 +1920,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
 				current->timer_slack_ns =
-					current->default_timer_slack_ns;
-			else
+					default_timer_slack_ns;
+			else if (arg2 <= HRTIMER_MAX_SLACK)
 				current->timer_slack_ns = arg2;
-			error = 0;
+			else
+				error = -EINVAL;
 			break;
 		case PR_MCE_KILL:
 			if (arg4 | arg5)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..2cd42c6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -136,6 +136,7 @@ static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
+static const int slack_max = HRTIMER_MAX_SLACK;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
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
+		.extra2		= &slack_max,
+	},
 	{ }
 };
 
-- 
1.7.7.6

