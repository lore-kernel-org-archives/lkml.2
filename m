Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab1KRPT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:19:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35615 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756772Ab1KRPT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:19:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+hbA4Ni7KhcDGGJBgOyMCyLIpFrT17vDCMgbubDR
	j1/Py1acCKyq3w
Subject: [patch 3/6] sched: use rq->avg_event to resurrect nohz ratelimiting
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321629267.7080.13.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:19:22 +0100
Message-ID: <1321629562.7080.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Entering nohz at high frequency eats cycles, ratelimit it
just as we do idle_balance(), and for the same reason.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 include/linux/sched.h    |    2 ++
 kernel/sched.c           |    7 +++++++
 kernel/time/tick-sched.c |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-3.2.git/include/linux/sched.h
===================================================================
--- linux-3.2.git.orig/include/linux/sched.h
+++ linux-3.2.git/include/linux/sched.h
@@ -1979,8 +1979,10 @@ static inline void idle_task_exit(void)
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
 extern void wake_up_idle_cpu(int cpu);
+extern int sched_needs_cpu(int cpu);
 #else
 static inline void wake_up_idle_cpu(int cpu) { }
+static inline void sched_needs_cpu(int cpu) { }
 #endif
 
 extern unsigned int sysctl_sched_latency;
Index: linux-3.2.git/kernel/sched.c
===================================================================
--- linux-3.2.git.orig/kernel/sched.c
+++ linux-3.2.git/kernel/sched.c
@@ -1419,6 +1419,13 @@ static inline bool got_nohz_idle_kick(vo
 	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
 }
 
+#ifdef CONFIG_SMP
+int sched_needs_cpu(int cpu)
+{
+	return cpu_rq(cpu)->avg_event < sysctl_sched_migration_cost;
+}
+#endif
+
 #else /* CONFIG_NO_HZ */
 
 static inline bool got_nohz_idle_kick(void)
Index: linux-3.2.git/kernel/time/tick-sched.c
===================================================================
--- linux-3.2.git.orig/kernel/time/tick-sched.c
+++ linux-3.2.git/kernel/time/tick-sched.c
@@ -352,7 +352,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || sched_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {


