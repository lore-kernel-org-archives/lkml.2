Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1CXRuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:23 -0400
Received: from flusers.ccur.com ([173.221.59.2]:29454 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756607Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:02 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/24] jrcu: tuneable priority
Message-ID: <20110324174802.GA18886@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: make daemon priority a tuneable.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -504,20 +504,42 @@ void __init rcu_scheduler_starting(void)
 #include <linux/param.h>
 #include <linux/kthread.h>
 
+static int rcu_priority;
+static struct task_struct *rcu_daemon;
+
+static int jrcu_set_priority(int priority)
+{
+	struct sched_param param;
+
+	if (priority == 0) {
+		set_user_nice(current, -19);
+		return 0;
+	}
+
+	if (priority < 0)
+		param.sched_priority = MAX_USER_RT_PRIO + priority;
+	else
+		param.sched_priority = priority;
+
+	sched_setscheduler_nocheck(current, SCHED_RR, &param);
+	return param.sched_priority;
+}
+
 static int jrcud_func(void *arg)
 {
-	set_user_nice(current, -19);
 	current->flags |= PF_NOFREEZE;
-
-	pr_info("JRCU: daemon started. Will operate at ~%d Hz.\n", RCU_HZ);
+	rcu_priority = jrcu_set_priority(CONFIG_JRCU_DAEMON_PRIO);
 	rcu_timer_stop();
 
+	pr_info("JRCU: daemon started. Will operate at ~%d Hz.\n", rcu_hz);
+
 	while (!kthread_should_stop()) {
 		usleep_range(rcu_hz_period_us, rcu_hz_period_us + rcu_hz_delta_us);
 		rcu_delimit_batches();
 	}
 
 	pr_info("JRCU: daemon exiting\n");
+	rcu_daemon = NULL;
 	rcu_timer_restart();
 	return 0;
 }
@@ -531,6 +553,7 @@ static __init int jrcud_start(void)
 		pr_warn("JRCU: daemon not started\n");
 		return -ENODEV;
 	}
+	rcu_daemon = p;
 	return 0;
 }
 late_initcall(jrcud_start);
@@ -552,8 +575,13 @@ static int rcu_debugfs_show(struct seq_f
 	msecs = div_s64(sched_clock() - rcu_timestamp, NSEC_PER_MSEC);
 	raw_local_irq_enable();
 
-	seq_printf(m, "%14u: hz\n",
-		rcu_hz);
+	seq_printf(m, "%14u: hz\n", rcu_hz);
+#ifdef CONFIG_JRCU_DAEMON
+	if (rcu_daemon)
+		seq_printf(m, "%14u: daemon priority\n", rcu_priority);
+	else
+		seq_printf(m, "%14s: daemon priority\n", "none, no daemon");
+#endif
 	seq_printf(m, "%14u: #passes seen\n",
 		rcu_stats.npasses);
 	seq_printf(m, "%14u: #batches seen\n",
Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -434,6 +434,17 @@ config JRCU_DAEMON
 	  Required. The context switch when leaving the daemon is needed
 	  to get the CPU to reliably participate in end-of-batch processing.
 
+config JRCU_DAEMON_PRIO
+	int "JRCU Daemon priority"
+	depends on JRCU_DAEMON
+	default 0
+	help
+	  The JRCU daemon priority. If 0 then the daemon runs SCHED_OTHER.
+	  If >0 then the daemon runs SCHED_RR and its priority will be
+	  the value selected.  If <0 then SCHED_RR is again selected, but
+	  now its priority will be the biased downwards from the maximum
+	  possible Posix priority.
+
 config JRCU_LAZY
 	bool "Should JRCU be lazy recognizing end-of-batch"
 	depends on JRCU
