Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2EGSBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:01:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:41395 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2EGR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:51 -0400
Message-Id: <20120507175651.980164748@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 1/8] powerpc: Fix broken cpu_idle_wait() implementation
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=power-fix-broken-cpu-idle-wait.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 771dae818 (powerpc/cpuidle: Add cpu_idle_wait() to allow
switching of idle routines) implemented cpu_idle_wait() for powerpc.

The changelog says:
 "The equivalent routine for x86 is in arch/x86/kernel/process.c
  but the powerpc implementation is different.":

Unfortunately the changelog is completely useless as it does not tell
_WHY_ it is different.

Aside of being different the implementation is patently wrong.

The rescheduling IPI is async. That means that there is no guarantee,
that the other cores have executed the IPI when cpu_idle_wait()
returns. But that's the whole purpose of this function: to guarantee
that no CPU uses the old idle handler anymore.

Use the smp_functional_call() based implementation, which fulfils the
requirements.

[ This code is going to replaced by a core version to remove all the
  pointless copies in arch/*, but this one should go to stable ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Trinabh Gupta <g.trinabh@gmail.com>
Cc: Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/idle.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: tip/arch/powerpc/kernel/idle.c
===================================================================
--- tip.orig/arch/powerpc/kernel/idle.c
+++ tip/arch/powerpc/kernel/idle.c
@@ -113,6 +113,9 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
 
 /*
  * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
@@ -123,16 +126,9 @@ void cpu_idle(void)
  */
 void cpu_idle_wait(void)
 {
-	int cpu;
 	smp_mb();
-
-	/* kick all the CPUs so that they exit out of old idle routine */
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		if (cpu != smp_processor_id())
-			smp_send_reschedule(cpu);
-	}
-	put_online_cpus();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 


