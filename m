Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2LUCxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:53:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:49854 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab2LUCun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:50:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,327,1355126400"; 
   d="scan'208";a="265338735"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v4 03/11] x86/common.c: Make have_cpuid_p() a global function and load ucode or show ucode loading info on AP
Date: Thu, 20 Dec 2012 11:48:05 -0800
Message-Id: <1356032893-2730-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Remove static declaration in have_cpuid_p() to make it a global function. The
function will be called in early loading microcode.

In 64 bit, load ucode on AP in cpu_init(). In 32 bit, show ucode loading info
on AP in cpu_init().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h |  8 ++++++++
 arch/x86/kernel/cpu/common.c     | 17 +++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..3d722fd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -190,6 +190,14 @@ extern void init_amd_cacheinfo(struct cpuinfo_x86 *c);
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
 
+#ifdef CONFIG_X86_32
+extern int have_cpuid_p(void);
+#else
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+#endif
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9c3ab43..d814772 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -37,6 +37,8 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
+#include <asm/microcode.h>
+#include <asm/microcode_intel.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
@@ -213,7 +215,7 @@ static inline int flag_is_changeable_p(u32 flag)
 }
 
 /* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
+int __cpuinit have_cpuid_p(void)
 {
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
@@ -249,11 +251,6 @@ static inline int flag_is_changeable_p(u32 flag)
 {
 	return 1;
 }
-/* Probe for the CPUID instruction */
-static inline int have_cpuid_p(void)
-{
-	return 1;
-}
 static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
 }
@@ -1223,6 +1220,12 @@ void __cpuinit cpu_init(void)
 	int cpu;
 	int i;
 
+	/*
+	 * Load microcode on this cpu if a valid microcode is available.
+	 * This is early microcode loading procedure.
+	 */
+	load_ucode_ap();
+
 	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
 	oist = &per_cpu(orig_ist, cpu);
@@ -1314,6 +1317,8 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
+	show_ucode_info_early();
+
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
 		for (;;)
-- 
1.8.0.1

