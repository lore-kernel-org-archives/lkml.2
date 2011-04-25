Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1DYJe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:34:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45602 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab1DYJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:34:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH] alpha: replace with new cpumask APIs
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110425183556.2686.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:34:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to remove cpu_xx() old APIs. Thus convert them.
This patch has no functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/process.c   |    2 +-
 arch/alpha/kernel/setup.c     |    2 +-
 arch/alpha/kernel/smp.c       |    7 ++++---
 arch/alpha/kernel/sys_dp264.c |    2 +-
 arch/alpha/kernel/sys_titan.c |   13 +++++++------
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 3ec3506..838eac1 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -121,7 +121,7 @@ common_shutdown_1(void *generic_ptr)
 	/* Wait for the secondaries to halt. */
 	set_cpu_present(boot_cpuid, false);
 	set_cpu_possible(boot_cpuid, false);
-	while (cpus_weight(cpu_present_map))
+	while (cpumask_weight(cpu_present_mask))
 		barrier();
 #endif
 
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index d2634e4..fc89785 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -1257,7 +1257,7 @@ show_cpuinfo(struct seq_file *f, void *slot)
 #ifdef CONFIG_SMP
 	seq_printf(f, "cpus active\t\t: %u\n"
 		      "cpu active mask\t\t: %016lx\n",
-		       num_online_cpus(), cpus_addr(cpu_possible_map)[0]);
+		       num_online_cpus(), cpumask_bits(cpu_possible_mask)[0]);
 #endif
 
 	show_cache_size (f, "L1 Icache", alpha_l1i_cacheshape);
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 5a621c6..d739703 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -451,7 +451,7 @@ setup_smp(void)
 	}
 
 	printk(KERN_INFO "SMP: %d CPUs probed -- cpu_present_map = %lx\n",
-	       smp_num_probed, cpu_present_map.bits[0]);
+	       smp_num_probed, cpumask_bits(cpu_present_mask)[0]);
 }
 
 /*
@@ -629,8 +629,9 @@ smp_send_reschedule(int cpu)
 void
 smp_send_stop(void)
 {
-	cpumask_t to_whom = cpu_possible_map;
-	cpu_clear(smp_processor_id(), to_whom);
+	cpumask_t to_whom;
+	cpumask_copy(&to_whom, cpu_possible_mask);
+	cpumask_clear_cpu(smp_processor_id(), &to_whom);
 #ifdef DEBUG_IPI_MSG
 	if (hard_smp_processor_id() != boot_cpu_id)
 		printk(KERN_WARNING "smp_send_stop: Not on boot cpu.\n");
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 5ac00fd..f885682 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -140,7 +140,7 @@ cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 
 	for (cpu = 0; cpu < 4; cpu++) {
 		unsigned long aff = cpu_irq_affinity[cpu];
-		if (cpu_isset(cpu, affinity))
+		if (cpumask_test_cpu(cpu, &affinity))
 			aff |= 1UL << irq;
 		else
 			aff &= ~(1UL << irq);
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index fea0e46..6994407 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -65,10 +65,11 @@ titan_update_irq_hw(unsigned long mask)
 	register int bcpu = boot_cpuid;
 
 #ifdef CONFIG_SMP
-	cpumask_t cpm = cpu_present_map;
+	cpumask_t cpm;
 	volatile unsigned long *dim0, *dim1, *dim2, *dim3;
 	unsigned long mask0, mask1, mask2, mask3, dummy;
 
+	cpumask_copy(&cpm, cpu_present_mask);
 	mask &= ~isa_enable;
 	mask0 = mask & titan_cpu_irq_affinity[0];
 	mask1 = mask & titan_cpu_irq_affinity[1];
@@ -84,10 +85,10 @@ titan_update_irq_hw(unsigned long mask)
 	dim1 = &cchip->dim1.csr;
 	dim2 = &cchip->dim2.csr;
 	dim3 = &cchip->dim3.csr;
-	if (!cpu_isset(0, cpm)) dim0 = &dummy;
-	if (!cpu_isset(1, cpm)) dim1 = &dummy;
-	if (!cpu_isset(2, cpm)) dim2 = &dummy;
-	if (!cpu_isset(3, cpm)) dim3 = &dummy;
+	if (!cpumask_test_cpu(0, &cpm)) dim0 = &dummy;
+	if (!cpumask_test_cpu(1, &cpm)) dim1 = &dummy;
+	if (!cpumask_test_cpu(2, &cpm)) dim2 = &dummy;
+	if (!cpumask_test_cpu(3, &cpm)) dim3 = &dummy;
 
 	*dim0 = mask0;
 	*dim1 = mask1;
@@ -137,7 +138,7 @@ titan_cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 	int cpu;
 
 	for (cpu = 0; cpu < 4; cpu++) {
-		if (cpu_isset(cpu, affinity))
+		if (cpumask_test_cpu(cpu, &affinity))
 			titan_cpu_irq_affinity[cpu] |= 1UL << irq;
 		else
 			titan_cpu_irq_affinity[cpu] &= ~(1UL << irq);
-- 
1.7.3.1



