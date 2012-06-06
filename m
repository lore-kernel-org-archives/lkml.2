Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab2FFV2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:28:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:52067 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab2FFV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:16 -0400
Message-Id: <20120606212334.773764908@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:27:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 5/6] x86: mce: Remove the frozen cases in the hotplug code
References: <20120606211746.693649684@linutronix.de>
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
 arch/x86/kernel/cpu/mcheck/mce.c     |   12 +++++-------
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    6 ++----
 2 files changed, 7 insertions(+), 11 deletions(-)

Index: tip/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2260,34 +2260,32 @@ mce_cpu_callback(struct notifier_block *
 	unsigned int cpu = (unsigned long)hcpu;
 	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
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
 
Index: tip/arch/x86/kernel/cpu/mcheck/mce_amd.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -748,13 +748,11 @@ static void threshold_remove_device(unsi
 static void __cpuinit
 amd_64_threshold_cpu_callback(unsigned long action, unsigned int cpu)
 {
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
 		threshold_create_device(cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		threshold_remove_device(cpu);
 		break;
 	default:


