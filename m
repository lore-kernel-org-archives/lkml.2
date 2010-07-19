Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936546Ab0GSShs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:37:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:60118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936439Ab0GSSg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,228,1278313200"; 
   d="scan'208";a="301852507"
Message-Id: <20100719183240.240236054@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 11:35:44 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] x86: use xsaveopt in context-switch path when supported
References: <20100719181941.971215286@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=xsaveopt_support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xsaveopt is a more optimized form of xsave specifically designed
for the context switch usage. xsaveopt doesn't save the state that's not
modified from the prior xrstor. And if a specific feature state gets
modified to the init state, then xsaveopt just updates the header bit
in the xsave memory layout without updating the corresponding memory
layout.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/i387.h                |    2 +-
 arch/x86/include/asm/xsave.h               |    9 ++++++---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   24 +++++++++++++-----------
 arch/x86/kernel/cpu/common.c               |    8 ++++++++
 5 files changed, 29 insertions(+), 15 deletions(-)

Index: tip/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ tip/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -13,6 +13,7 @@ struct cpuid_bit {
 	u16 feature;
 	u8 reg;
 	u8 bit;
+	u32 leaf;
 	u32 level;
 };
 
@@ -30,15 +31,16 @@ void __cpuinit init_scattered_cpuid_feat
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
-		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006 },
-		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
-		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
+		{ X86_FEATURE_IDA,		CR_EAX, 1, 0, 0x00000006 },
+		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0, 0x00000006 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0, 0x00000006 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0, 0x00000006 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0, 0x80000007 },
+		{ X86_FEATURE_NPT,		CR_EDX, 0, 0, 0x8000000a },
+		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0, 0x8000000a },
+		{ X86_FEATURE_SVML,		CR_EDX, 2, 0, 0x8000000a },
+		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0, 0x8000000a },
+		{ X86_FEATURE_XSAVEOPT,		CR_EAX, 0, 1, 0x0000000d },
 		{ 0, 0, 0, 0 }
 	};
 
@@ -50,8 +52,8 @@ void __cpuinit init_scattered_cpuid_feat
 		    max_level > (cb->level | 0xffff))
 			continue;
 
-		cpuid(cb->level, &regs[CR_EAX], &regs[CR_EBX],
-			&regs[CR_ECX], &regs[CR_EDX]);
+		cpuid_count(cb->level, cb->leaf, &regs[CR_EAX], &regs[CR_EBX],
+			    &regs[CR_ECX], &regs[CR_EDX]);
 
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
Index: tip/arch/x86/include/asm/cpufeature.h
===================================================================
--- tip.orig/arch/x86/include/asm/cpufeature.h
+++ tip/arch/x86/include/asm/cpufeature.h
@@ -165,6 +165,7 @@
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_XSAVEOPT	(7*32+4) /* "xsaveopt" Optimized Xsave */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
Index: tip/arch/x86/include/asm/xsave.h
===================================================================
--- tip.orig/arch/x86/include/asm/xsave.h
+++ tip/arch/x86/include/asm/xsave.h
@@ -135,8 +135,11 @@ static inline void fpu_xsave(struct fpu 
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
-			     : : "D" (&(fpu->state->xsave)),
-				 "a" (-1), "d"(-1) : "memory");
+	alternative_input(
+		".byte " REX_PREFIX "0x0f,0xae,0x27",
+		".byte " REX_PREFIX "0x0f,0xae,0x37",
+		X86_FEATURE_XSAVEOPT,
+		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+		"memory");
 }
 #endif
Index: tip/arch/x86/kernel/cpu/common.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/common.c
+++ tip/arch/x86/kernel/cpu/common.c
@@ -140,10 +140,18 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
 
+static int __init x86_xsaveopt_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	return 1;
+}
+__setup("noxsaveopt", x86_xsaveopt_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
Index: tip/arch/x86/include/asm/i387.h
===================================================================
--- tip.orig/arch/x86/include/asm/i387.h
+++ tip/arch/x86/include/asm/i387.h
@@ -60,7 +60,7 @@ extern int restore_i387_xstate_ia32(void
 
 static __always_inline __pure bool use_xsaveopt(void)
 {
-	return 0;
+	return static_cpu_has(X86_FEATURE_XSAVEOPT);
 }
 
 static __always_inline __pure bool use_xsave(void)


