Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967198Ab0GSXJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:09:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:49884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967142Ab0GSXIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,229,1278313200"; 
   d="scan'208";a="536998398"
Message-Id: <20100719230205.604014179@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:05:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/5] x86: use xsaveopt in context-switch path when supported
References: <20100719225747.372816924@sbs-t61.sc.intel.com>
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
 arch/x86/include/asm/i387.h                |    2 +-
 arch/x86/include/asm/xsave.h               |    9 ++++++---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 arch/x86/kernel/cpu/common.c               |    8 ++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

Index: tip-linux-2.6/arch/x86/include/asm/xsave.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/xsave.h
+++ tip-linux-2.6/arch/x86/include/asm/xsave.h
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
Index: tip-linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ tip-linux-2.6/arch/x86/kernel/cpu/common.c
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
Index: tip-linux-2.6/arch/x86/include/asm/i387.h
===================================================================
--- tip-linux-2.6.orig/arch/x86/include/asm/i387.h
+++ tip-linux-2.6/arch/x86/include/asm/i387.h
@@ -60,7 +60,7 @@ extern int restore_i387_xstate_ia32(void
 
 static __always_inline __pure bool use_xsaveopt(void)
 {
-	return 0;
+	return static_cpu_has(X86_FEATURE_XSAVEOPT);
 }
 
 static __always_inline __pure bool use_xsave(void)
Index: tip-linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ tip-linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -35,6 +35,7 @@ void __cpuinit init_scattered_cpuid_feat
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },


