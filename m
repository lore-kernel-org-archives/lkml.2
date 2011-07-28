Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1G1Xv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:51:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:55935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1G1Xo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559478"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [24/50] x86: Look for IA32_ENERGY_PERF_BIAS support
Message-Id: <20110728234428.B6FD82403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Venkatesh Pallipadi <venki@google.com>

[ upstream commit 23016bf0 ]

The new IA32_ENERGY_PERF_BIAS MSR allows system software to give
hardware a hint whether OS policy favors more power saving,
or more performance.  This allows the OS to have some influence
on internal hardware power/performance tradeoffs where the OS
has previously had no influence.

The support for this feature is indicated by CPUID.06H.ECX.bit3,
as documented in the Intel Architectures Software Developer's Manual.

This patch discovers support of this feature and displays it
as "epb" in /proc/cpuinfo.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <alpine.LFD.2.00.1006032310160.6669@localhost.localdomain>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Index: linux-2.6.35.y/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/cpufeature.h
+++ linux-2.6.35.y/arch/x86/include/asm/cpufeature.h
@@ -162,6 +162,7 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
Index: linux-2.6.35.y/arch/x86/include/asm/msr-index.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/msr-index.h
+++ linux-2.6.35.y/arch/x86/include/asm/msr-index.h
@@ -243,6 +243,8 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
Index: linux-2.6.35.y/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -33,6 +33,7 @@ void __cpuinit init_scattered_cpuid_feat
 		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006 },
 		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
