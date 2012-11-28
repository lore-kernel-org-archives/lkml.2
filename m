Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2K1Twy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:52:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab2K1Tuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:50:55 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 5/8] x86, 386 removal: Remove CONFIG_INVLPG
Date: Wed, 28 Nov 2012 11:50:27 -0800
Message-Id: <1354132230-21854-6-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

All 486+ CPUs support INVLPG, so remove the fallback 386 support
code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig.cpu              | 4 ----
 arch/x86/include/asm/cpufeature.h | 6 ------
 arch/x86/include/asm/tlbflush.h   | 3 ---
 arch/x86/kernel/cpu/amd.c         | 3 ---
 arch/x86/kernel/cpu/intel.c       | 4 ----
 arch/x86/mm/tlb.c                 | 8 +++-----
 6 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8e5867c..d3bdc18 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -328,10 +328,6 @@ config X86_INVD_BUG
 config X86_WP_WORKS_OK
 	def_bool y
 
-config X86_INVLPG
-	def_bool y
-	depends on X86_32
-
 config X86_POPAD_OK
 	def_bool y
 	depends on X86_32
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..ff8dd62 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -312,12 +312,6 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 
-#if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
-# define cpu_has_invlpg		1
-#else
-# define cpu_has_invlpg		(boot_cpu_data.x86 > 3)
-#endif
-
 #ifdef CONFIG_X86_64
 
 #undef  cpu_has_vme
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 74a4433..0fee48e 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -56,10 +56,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-	if (cpu_has_invlpg)
 		__flush_tlb_single(addr);
-	else
-		__flush_tlb();
 }
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1b7d165..a025d8c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -753,9 +753,6 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 
 static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has_invlpg)
-		return;
-
 	tlb_flushall_shift = 5;
 
 	if (c->x86 <= 0x11)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 198e019..fcaabd0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -612,10 +612,6 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
 
 static void __cpuinit intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has_invlpg) {
-		tlb_flushall_shift = -1;
-		return;
-	}
 	switch ((c->x86 << 8) + c->x86_model) {
 	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
 	case 0x616: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 60f926c..13a6b29 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -104,7 +104,7 @@ static void flush_tlb_func(void *info)
 		return;
 
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-		if (f->flush_end == TLB_FLUSH_ALL || !cpu_has_invlpg)
+		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
 		else if (!f->flush_end)
 			__flush_tlb_single(f->flush_start);
@@ -337,10 +337,8 @@ static const struct file_operations fops_tlbflush = {
 
 static int __cpuinit create_tlb_flushall_shift(void)
 {
-	if (cpu_has_invlpg) {
-		debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
-			arch_debugfs_dir, NULL, &fops_tlbflush);
-	}
+	debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
+			    arch_debugfs_dir, NULL, &fops_tlbflush);
 	return 0;
 }
 late_initcall(create_tlb_flushall_shift);
-- 
1.7.11.7

