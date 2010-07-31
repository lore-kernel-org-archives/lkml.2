Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0GaApX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 20:45:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:21373 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0GaApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 20:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,290,1278313200"; 
   d="scan'208";a="540636142"
Message-Id: <20100731004316.177832944@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jul 2010 17:41:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch v2 2/2] x86, ia64, smp: use workqueues unconditionally during do_boot_cpu()
References: <20100731004316.101616883@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=x86_ia64_smpboot_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues are now initialized as part of the early_initcall(). So
they are available for use during cold boot process aswell.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/ia64/kernel/smpboot.c |   15 ++++++---------
 arch/x86/kernel/smpboot.c  |    8 ++------
 2 files changed, 8 insertions(+), 15 deletions(-)

Index: linux-next/arch/x86/kernel/smpboot.c
===================================================================
--- linux-next.orig/arch/x86/kernel/smpboot.c
+++ linux-next/arch/x86/kernel/smpboot.c
@@ -735,12 +735,8 @@ static int __cpuinit do_boot_cpu(int api
 		goto do_rest;
 	}
 
-	if (!keventd_up())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle)) {
 		printk("failed fork for CPU %d\n", cpu);
Index: linux-next/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-next.orig/arch/ia64/kernel/smpboot.c
+++ linux-next/arch/ia64/kernel/smpboot.c
@@ -510,21 +510,18 @@ do_boot_cpu (int sapicid, int cpu)
 		.done	= COMPLETION_INITIALIZER(c_idle.done),
 	};
 
+	/*
+	 * We can't use kernel_thread since we must avoid to
+	 * reschedule the child.
+	 */
  	c_idle.idle = get_idle_for_cpu(cpu);
  	if (c_idle.idle) {
 		init_idle(c_idle.idle, cpu);
  		goto do_rest;
 	}
 
-	/*
-	 * We can't use kernel_thread since we must avoid to reschedule the child.
-	 */
-	if (!keventd_up())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle))
 		panic("failed fork for CPU %d", cpu);


