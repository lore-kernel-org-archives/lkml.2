Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab1CXRuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:11 -0400
Received: from flusers.ccur.com ([173.221.59.2]:41751 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756475Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:03 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/24] jrcu: refactor watchdog code
Message-ID: <20110324174803.GA18929@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: refactor watchdog code.

Much too complicated, simplify.

Also, don't use sched_clock(), we don't need that kind
of precision.  Instead, on every jrcu wakeup, we add into
a watchdog counter one RCU_HZ worth of usecs and check that
against the limit.  Another nice thing, if we spend a long
time in NMI (think 'kernel debugger'), this new watchdog
ctr won't increment, which is what we want to happen,
while the old sched_clock() method continues to advance.
Thus the sched_clock version is technically broken unless
compensating code is added.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -139,9 +139,9 @@ int rcu_hz_delta_us = RCU_HZ_DELTA_US;
 
 int rcu_scheduler_active __read_mostly;
 int rcu_nmi_seen __read_mostly;
-static u64 rcu_timestamp;
 
-int rcu_wdog = 30;		/* rcu watchdog interval, in seconds */
+static int rcu_wdog_ctr;	/* time since last end-of-batch, in usecs */
+static int rcu_wdog_lim = 10 * USEC_PER_SEC;	/* rcu watchdog interval */
 
 /*
  * Return our CPU id or zero if we are too early in the boot process to
@@ -299,7 +299,6 @@ static void __rcu_delimit_batches(struct
 	struct rcu_data *rd;
 	struct rcu_list *plist;
 	int cpu, eob, prev;
-	u64 rcu_now;
 
 	/* If an NMI occured then the previous batch may not yet be
 	 * quiescent.  Let's wait till it is.
@@ -325,34 +324,24 @@ static void __rcu_delimit_batches(struct
 		}
 	}
 
-	/*
-	 * Force end-of-batch if too much time (n seconds) has
-	 * gone by.
-	 */
-	rcu_now = sched_clock();
 	rcu_stats.nlast++;
 
-	if (!eob && !rcu_timestamp
-	&& ((rcu_now - rcu_timestamp) > (s64)rcu_wdog * NSEC_PER_SEC)) {
-		rcu_stats.nforced++;
-		for_each_online_cpu(cpu) {
-			if (rcu_data[cpu].wait)
-				force_cpu_resched(cpu);
-		}
-		rcu_timestamp = rcu_now;
-	}
-	/*
-	 * Just return if the current batch has not yet
-	 * ended.
-	 */
-
-	if (!eob)
-		return;
-
 	/*
-	 * Batch has ended.  First, restart watchdog.
+	 * Exit if batch has not ended.  But first, tickle all non-cooperating
+	 * CPUs if enough time has passed.
 	 */
-	rcu_timestamp = rcu_now;
+	if (eob == 0) {
+		if (rcu_wdog_ctr >= rcu_wdog_lim) {
+			rcu_wdog_ctr = 0;
+			rcu_stats.nforced++;
+			for_each_online_cpu(cpu) {
+				if (rcu_data[cpu].wait)
+					force_cpu_resched(cpu);
+			}
+		}
+		rcu_wdog_ctr += rcu_hz_period_us;
+		return eob;
+	}
 
 	/*
 	 * End the current RCU batch and start a new one.
@@ -391,8 +380,10 @@ static void __rcu_delimit_batches(struct
 	 * counter until the results of that xchg are visible on other cpus.
 	 */
 	xchg(&rcu_which, prev); /* only place where rcu_which is written to */
+
 	rcu_stats.nbatches++;
 	rcu_stats.nlast = 0;
+	rcu_wdog_ctr = 0;
 }
 
 static void rcu_delimit_batches(void)
@@ -580,14 +571,14 @@ late_initcall(jrcud_start);
 
 static int rcu_debugfs_show(struct seq_file *m, void *unused)
 {
-	int cpu, q, msecs;
-
-	raw_local_irq_disable();
-	msecs = div_s64(sched_clock() - rcu_timestamp, NSEC_PER_MSEC);
-	raw_local_irq_enable();
+	int cpu, q;
 
 	seq_printf(m, "%14u: hz\n", rcu_hz);
-	seq_printf(m, "%14u: watchdog (secs)\n", rcu_wdog);
+
+	seq_printf(m, "%14u: watchdog (secs)\n", rcu_wdog_lim / (int)USEC_PER_SEC);
+	seq_printf(m, "%14d: #secs left on watchdog\n",
+		(rcu_wdog_lim - rcu_wdog_ctr) / (int)USEC_PER_SEC);
+
 #ifdef CONFIG_JRCU_DAEMON
 	if (rcu_daemon)
 		seq_printf(m, "%14u: daemon priority\n", rcu_priority);
@@ -604,8 +595,6 @@ static int rcu_debugfs_show(struct seq_f
 		rcu_stats.npasses - rcu_stats.nbatches);
 	seq_printf(m, "%14u: #passes since last end-of-batch\n",
 		rcu_stats.nlast);
-	seq_printf(m, "%14u: #msecs since last end-of-batch\n",
-		msecs);
 	seq_printf(m, "%14u: #passes forced (0 is best)\n",
 		rcu_stats.nforced);
 
@@ -698,7 +687,7 @@ static ssize_t rcu_debugfs_write(struct 
 		sscanf(&token[5], "%d", &wdog);
 		if (wdog < 3 || wdog > 1000)
 			return -EINVAL;
-		rcu_wdog = wdog;
+		rcu_wdog_lim = wdog * USEC_PER_SEC;
 	} else
 		return -EINVAL;
 
