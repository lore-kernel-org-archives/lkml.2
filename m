Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0G3WAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:00:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:65461 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab0G3WAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:00:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,289,1278313200"; 
   d="scan'208";a="823393918"
Message-Id: <20100730215751.783526464@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jul 2010 14:57:38 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [patch 2/2] x86, smp: use workqueues unconditionally during do_boot_cpu()
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=x86_smpboot_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues are now initialized as part of the early_initcall(). So
they are available for use during cold boot process aswell.

And also ACPI hotplug notifier no longer calls do_boot_cpu() in the keventd_wq
context.  So we can unconditionally use workqueues in do_boot_cpu()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/kernel/smpboot.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -735,12 +735,8 @@ static int __cpuinit do_boot_cpu(int api
 		goto do_rest;
 	}
 
-	if (!keventd_up() || current_is_keventd())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle)) {
 		printk("failed fork for CPU %d\n", cpu);


