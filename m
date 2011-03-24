Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1CXRv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:51:57 -0400
Received: from flusers.ccur.com ([173.221.59.2]:41750 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756057Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:02 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/24] jrcu: add a stallout detector
Message-ID: <20110324174802.GA18900@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: create a stallout detector.

Tickle stalled-out cpus whenever too much time has
passed since the last time a batch has been retired.

For efficiency, and to protect the dedicated cpu model as
much as possible, only cpus contributing to the stallout
are tickled.

If the tickle is not effective, then JRCU will remain
stalled out forever.  This will eventually lead to an
out-of-memory condition.

On the other hand, if the tickle is not effective,
that means some CPU is broken. It isn't leaving
preempt-protected code, and as long as that is true we
cannot retire batches with a clear conscience.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1903,6 +1903,8 @@ extern void wake_up_idle_cpu(int cpu);
 static inline void wake_up_idle_cpu(int cpu) { }
 #endif
 
+extern void force_cpu_resched(int cpu);
+
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1183,6 +1183,16 @@ static void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+void force_cpu_resched(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	resched_task(cpu_curr(cpu));
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 #ifdef CONFIG_NO_HZ
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -1288,6 +1298,11 @@ static void sched_rt_avg_update(struct r
 static void sched_avg_update(struct rq *rq)
 {
 }
+
+void force_cpu_resched(int cpu)
+{
+	set_need_resched();
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -324,26 +324,29 @@ static void __rcu_delimit_batches(struct
 
 	/*
 	 * Force end-of-batch if too much time (n seconds) has
-	 * gone by.  The forcing method is slightly questionable,
-	 * hence the WARN_ON.
+	 * gone by.
 	 */
 	rcu_now = sched_clock();
 	if (!eob && !rcu_timestamp
 	&& ((rcu_now - rcu_timestamp) > (s64)rcu_wdog * NSEC_PER_SEC)) {
 		rcu_stats.nforced++;
-		WARN_ON_ONCE(1);
-		eob = 1;
+		for_each_online_cpu(cpu) {
+			if (rcu_data[cpu].wait)
+				force_cpu_resched(cpu);
+		}
+		rcu_timestamp = rcu_now;
 	}
-
 	/*
 	 * Just return if the current batch has not yet
-	 * ended.  Also, keep track of just how long it
-	 * has been since we've actually seen end-of-batch.
+	 * ended.
 	 */
 
 	if (!eob)
 		return;
 
+	/*
+	 * Batch has ended.  First, restart watchdog.
+	 */
 	rcu_timestamp = rcu_now;
 
 	/*
