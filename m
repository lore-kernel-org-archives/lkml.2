Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2BOFAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:00:21 -0500
Received: from ozlabs.org ([203.10.76.45]:53311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2BOFAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1329281884.28702.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 2/12] arch/arm: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/kprobes.c |    4 ++--
 arch/arm/kernel/smp.c     |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -127,7 +127,7 @@ void __kprobes arch_arm_kprobe(struct kp
 		flush_insns(addr, sizeof(u16));
 	} else if (addr & 2) {
 		/* A 32-bit instruction spanning two words needs special care */
-		stop_machine(set_t32_breakpoint, (void *)addr, &cpu_online_map);
+		stop_machine(set_t32_breakpoint, (void *)addr, cpu_online_mask);
 	} else {
 		/* Word aligned 32-bit instruction can be written atomically */
 		u32 bkp = KPROBE_THUMB32_BREAKPOINT_INSTRUCTION;
@@ -190,7 +190,7 @@ int __kprobes __arch_disarm_kprobe(void 
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	stop_machine(__arch_disarm_kprobe, p, &cpu_online_map);
+	stop_machine(__arch_disarm_kprobe, p, cpu_online_mask);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -359,7 +359,7 @@ void __init smp_prepare_cpus(unsigned in
 		 * re-initialize the map in platform_smp_prepare_cpus() if
 		 * present != possible (e.g. physical hotplug).
 		 */
-		init_cpu_present(&cpu_possible_map);
+		init_cpu_present(cpu_possible_mask);
 
 		/*
 		 * Initialise the SCU if there are more than one CPU
@@ -577,8 +577,9 @@ void smp_send_stop(void)
 	unsigned long timeout;
 
 	if (num_online_cpus() > 1) {
-		cpumask_t mask = cpu_online_map;
-		cpu_clear(smp_processor_id(), mask);
+		struct cpumask mask;
+		cpumask_copy(&mask, cpu_online_mask);
+		cpumask_clear_cpu(&mask, smp_processor_id());
 
 		smp_cross_call(&mask, IPI_CPU_STOP);
 	}

