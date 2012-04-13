Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2DMMLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:11:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:41482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2DMMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:11:18 -0400
Date: Fri, 13 Apr 2012 14:11:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.4-rc2-rt4
Message-ID: <alpine.LFD.2.02.1204131033240.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.4-rc2-rt4 release. -rt3 is an
intermediate release which has an earlier version of the RCU build
wreckage fix.

Changes since 3.4-rc2-rt2:

  * Fix RCU build wreckage (jkacur)

  * Remove the _GPL restriction from a few exports

    This restores the status quo of pre 3.0 RT versions. 
	  
    I fundamentally hate this change, but the point is, that RT
    replaces non GPL exports with GPL ones and therefor breaks
    "legitimate" abuses of the kernel.

    OTOH I've been exposed to source code of some secret sauce
    drivers. That makes me believe that in a lot of cases the reason
    for not disclosing the driver code is that publishing might put
    the innocent and unprepared reader in danger of gastric ulcer and
    eyecancer.

    So I commit this change for health protection reasons.


The delta patch to 3.4-rc2-rt2 is appended below and can be found
here as incremental patches:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4-rc2-rt2-rt3.patch.xz
  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4-rc2-rt3-rt4.patch.xz


The RT patch against 3.4-rc2 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4-rc2-rt4.patch.xz


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4-rc2-rt4.tar.xz


Enjoy,

	tglx
---
Index: linux-3.4/kernel/rcutree_plugin.h
===================================================================
--- linux-3.4.orig/kernel/rcutree_plugin.h
+++ linux-3.4/kernel/rcutree_plugin.h
@@ -1914,6 +1914,9 @@ int rcu_needs_cpu(int cpu)
 {
 	return rcu_cpu_has_callbacks(cpu);
 }
+#endif	/* !defined(CONFIG_RCU_FAST_NO_HZ) || defined(CONFIG_PREEMPT_RT_FULL) */
+
+#if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
  * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
@@ -1984,6 +1987,7 @@ static DEFINE_PER_CPU(struct hrtimer, rc
 static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
 static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
  * callbacks on this CPU, (2) this CPU has not yet attempted to enter
@@ -2001,6 +2005,7 @@ int rcu_needs_cpu(int cpu)
 	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
 	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
 }
+#endif	/* #ifndef CONFIG_PREEMPT_RT_FULL */
 
 /*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
Index: linux-3.4/kernel/rtmutex.c
===================================================================
--- linux-3.4.orig/kernel/rtmutex.c
+++ linux-3.4/kernel/rtmutex.c
@@ -1282,7 +1282,7 @@ void __rt_mutex_init(struct rt_mutex *lo
 
 	debug_rt_mutex_init(lock, name);
 }
-EXPORT_SYMBOL_GPL(__rt_mutex_init);
+EXPORT_SYMBOL(__rt_mutex_init);
 
 /**
  * rt_mutex_init_proxy_locked - initialize and lock a rt_mutex on behalf of a
Index: linux-3.4/kernel/sched/core.c
===================================================================
--- linux-3.4.orig/kernel/sched/core.c
+++ linux-3.4/kernel/sched/core.c
@@ -3206,7 +3206,7 @@ void migrate_disable(void)
 	p->migrate_disable = 1;
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_disable);
+EXPORT_SYMBOL(migrate_disable);
 
 void migrate_enable(void)
 {
@@ -3258,7 +3258,7 @@ void migrate_enable(void)
 	unpin_current_cpu();
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_enable);
+EXPORT_SYMBOL(migrate_enable);
 #else
 static inline void update_migrate_disable(struct task_struct *p) { }
 #define migrate_disabled_updated(p)		0
Index: linux-3.4/localversion-rt
===================================================================
--- linux-3.4.orig/localversion-rt
+++ linux-3.4/localversion-rt
@@ -1 +1 @@
--rt2
+-rt4
