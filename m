Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967183Ab0GSXIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:08:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:49884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967133Ab0GSXIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,229,1278313200"; 
   d="scan'208";a="639891713"
Message-Id: <20100719230205.439900717@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:05:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/5] x86: extend init_scattered_cpuid_features() to consider cpuid subleaves
References: <20100719225747.372816924@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=extend_add_one_cpuid_feature.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid features (like xsaveopt) are enumerated using cpuid subleaves.

Extend init_scattered_cpuid_features() to take subleaf into account.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Index: tip-linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ tip-linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -14,6 +14,7 @@ struct cpuid_bit {
 	u8 reg;
 	u8 bit;
 	u32 level;
+	u32 sub_leaf;
 };
 
 enum cpuid_regs {
@@ -30,16 +31,16 @@ void __cpuinit init_scattered_cpuid_feat
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
-		{ 0, 0, 0, 0 }
+		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
+		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
+		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
+		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
+		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ 0, 0, 0, 0, 0 }
 	};
 
 	for (cb = cpuid_bits; cb->feature; cb++) {
@@ -50,8 +51,8 @@ void __cpuinit init_scattered_cpuid_feat
 		    max_level > (cb->level | 0xffff))
 			continue;
 
-		cpuid(cb->level, &regs[CR_EAX], &regs[CR_EBX],
-			&regs[CR_ECX], &regs[CR_EDX]);
+		cpuid_count(cb->level, cb->sub_leaf, &regs[CR_EAX],
+			    &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
 
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);


