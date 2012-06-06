Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab2FFVxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:53:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:52294 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2FFVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:53:25 -0400
Message-Id: <20120606215116.684169600@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:53:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 4/5] x86: mce: Remove the frozen cases in the hotplug code
References: <20120606214941.104735929@linutronix.de>
Content-Disposition: inline; filename=x86-mce-remove-frozen-cases.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having double cases if we can simply mask the FROZEN bit
out.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: tip/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2260,34 +2260,32 @@ mce_cpu_callback(struct notifier_block *
 	unsigned int cpu = (unsigned long)hcpu;
 	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		mce_device_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
 		break;
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		mce_start_timer(cpu, t);
 		break;
-	case CPU_POST_DEAD:
+	}
+
+	if (action == CPU_POST_DEAD) {
 		/* intentionally ignoring frozen here */
 		cmci_rediscover(cpu);
-		break;
 	}
+
 	return NOTIFY_OK;
 }
 


