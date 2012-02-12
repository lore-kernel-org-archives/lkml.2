Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2BLRye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:54:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37552 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2BLRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:54:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3] x86: Fix show_msr= debug print out
Date: Sun, 12 Feb 2012 09:53:57 -0800
Message-Id: <1329069237-11483-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F37FCC5.007E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found show_msr=n is broken when try to ask user to get debug info
about broken mtrr. (setting are different between cpus)

Originally we call print_cpu_msr from print_cpu_info(), but

| commit 2eaad1fddd7450a48ad464229775f97fbfe8af36
| Author: Mike Travis <travis@sgi.com>
| Date:   Thu Dec 10 17:19:36 2009 -0800
|
|    x86: Limit the number of processor bootup messages

just remove whole print_cpu_info calling for all APs. So show_msr=n
stop working now.

Try to put back calling of print_cpu_msr, and it will only print msr
when user specify show_msr=n

-v2: Fix one typo found by Ingo.
-v3: fix missing print out for cpu0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   14 +++++++-------
 arch/x86/kernel/smpboot.c        |    5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -162,6 +162,7 @@ extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+void print_cpu_msr(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -933,7 +933,7 @@ static const struct msr_range msr_range_
 	{ 0xc0011000, 0xc001103b},
 };
 
-static void __cpuinit print_cpu_msr(void)
+static void __cpuinit __print_cpu_msr(void)
 {
 	unsigned index_min, index_max;
 	unsigned index;
@@ -997,13 +997,13 @@ void __cpuinit print_cpu_info(struct cpu
 	else
 		printk(KERN_CONT "\n");
 
-#ifdef CONFIG_SMP
+	__print_cpu_msr();
+}
+
+void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
+{
 	if (c->cpu_index < show_msr)
-		print_cpu_msr();
-#else
-	if (show_msr)
-		print_cpu_msr();
-#endif
+		__print_cpu_msr();
 }
 
 static __init int setup_disablecpuid(char *arg)
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -791,9 +791,10 @@ do_rest:
 			schedule();
 		}
 
-		if (cpumask_test_cpu(cpu, cpu_callin_mask))
+		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
+			print_cpu_msr(&cpu_data(cpu));
 			pr_debug("CPU%d: has booted.\n", cpu);
-		else {
+		} else {
 			boot_error = 1;
 			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
 			    == 0xA5A5A5A5)
