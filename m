Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1IGQBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:01:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50793 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab1IGQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:01:19 -0400
Date: Wed, 7 Sep 2011 20:24:21 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinned
Message-ID: <20110907145421.GA32577@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
 <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
 <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
 <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-06-21 12:48:17]:

> Hi Kamalesh,
> 
> Can you see what things look like under v7?
> 
> There's been a few improvements to quota re-distribution that should
> hopefully help your test case.
> 
> The remaining idle% I see on my machines appear to be a product of
> load-balancer inefficiency.

which is quite a complex problem to solve! I am still surprised that
we can't handle 32 cpuhogs on a 16-cpu system very easily. The tasks seem to
hop around madly rather than settle down as 2 tasks/cpu. Kamalesh, can you post
the exact count of migrations we saw on latest tip over a 20-sec window?

Anyway, here's a "hack" to minimize the idle time induced due to load-balance
issues. It brings down idle time from 7+% to ~0% ..I am not too happy about
this, but I don't see any other simpler solutions to solve the idle time issue
completely (other than making load-balancer completely fair!).

--

Fix excessive idle time reported when cgroups are capped.  The patch
introduces the notion of "steal" (or "grace") time which is the surplus
time/bandwidth each cgroup is allowed to consume, subject to a maximum
steal time (sched_cfs_max_steal_time_us). Cgroups are allowed this "steal"
or "grace" time when the lone task running on a cpu is about to be throttled.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Index: linux-3.1-rc4/include/linux/sched.h
===================================================================
--- linux-3.1-rc4.orig/include/linux/sched.h	2011-09-07 14:57:49.529602231 +0800
+++ linux-3.1-rc4/include/linux/sched.h	2011-09-07 14:58:49.952418107 +0800
@@ -2042,6 +2042,7 @@ static inline void sched_autogroup_exit(
 
 #ifdef CONFIG_CFS_BANDWIDTH
 extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+extern unsigned int sysctl_sched_cfs_max_steal_time;
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
Index: linux-3.1-rc4/kernel/sched.c
===================================================================
--- linux-3.1-rc4.orig/kernel/sched.c	2011-09-07 14:57:49.532854588 +0800
+++ linux-3.1-rc4/kernel/sched.c	2011-09-07 14:58:49.955453578 +0800
@@ -254,7 +254,7 @@ struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
 	raw_spinlock_t lock;
 	ktime_t period;
-	u64 quota, runtime;
+	u64 quota, runtime, steal_time;
 	s64 hierarchal_quota;
 	u64 runtime_expires;
 
Index: linux-3.1-rc4/kernel/sched_fair.c
===================================================================
--- linux-3.1-rc4.orig/kernel/sched_fair.c	2011-09-07 14:57:49.533644483 +0800
+++ linux-3.1-rc4/kernel/sched_fair.c	2011-09-07 15:16:09.338824132 +0800
@@ -101,6 +101,18 @@ unsigned int __read_mostly sysctl_sched_
  * default: 5 msec, units: microseconds
   */
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
+
+/*
+ * "Surplus" quota given to a cgroup to prevent a CPU from becoming idle.
+ *
+ * This would have been unnecessary had the load-balancer been "ideal" in
+ * loading tasks uniformly across all CPUs, which would have allowed
+ * all cgroups to claim their "quota" completely. In the absence of an
+ * "ideal" load-balancer, cgroups are unable to utilize their quota, leading
+ * to unexpected idle time. This knob allows a CPU to keep running a
+ * task beyond its throttled point before becoming idle.
+ */
+unsigned int sysctl_sched_cfs_max_steal_time = 100000UL;
 #endif
 
 static const struct sched_class fair_sched_class;
@@ -1288,6 +1300,11 @@ static inline u64 sched_cfs_bandwidth_sl
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+static inline u64 sched_cfs_max_steal_time(void)
+{
+	return (u64)sysctl_sched_cfs_max_steal_time * NSEC_PER_USEC;
+}
+
 /*
  * Replenish runtime according to assigned quota and update expiration time.
  * We use sched_clock_cpu directly instead of rq->clock to avoid adding
@@ -1303,6 +1320,7 @@ static void __refill_cfs_bandwidth_runti
 		return;
 
 	now = sched_clock_cpu(smp_processor_id());
+	cfs_b->steal_time = 0;
 	cfs_b->runtime = cfs_b->quota;
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }
@@ -1337,6 +1355,12 @@ static int assign_cfs_rq_runtime(struct 
 			cfs_b->runtime -= amount;
 			cfs_b->idle = 0;
 		}
+
+		if (!amount && rq_of(cfs_rq)->nr_running == 1 &&
+				cfs_b->steal_time < sched_cfs_max_steal_time()) {
+			amount = min_amount;
+			cfs_b->steal_time += amount;
+		}
 	}
 	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
@@ -1378,7 +1402,8 @@ static void expire_cfs_rq_runtime(struct
 	 * whether the global deadline has advanced.
 	 */
 
-	if ((s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0) {
+	if ((s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0 ||
+		(rq_of(cfs_rq)->nr_running == 1 && cfs_b->steal_time < sched_cfs_max_steal_time())) {
 		/* extend local deadline, drift is bounded above by 2 ticks */
 		cfs_rq->runtime_expires += TICK_NSEC;
 	} else {
Index: linux-3.1-rc4/kernel/sysctl.c
===================================================================
--- linux-3.1-rc4.orig/kernel/sysctl.c	2011-09-07 14:57:49.534454409 +0800
+++ linux-3.1-rc4/kernel/sysctl.c	2011-09-07 14:58:49.958452846 +0800
@@ -388,6 +388,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &one,
 	},
+	{
+		.procname	= "sched_cfs_max_steal_time_us",
+		.data		= &sysctl_sched_cfs_max_steal_time,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
 #endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
