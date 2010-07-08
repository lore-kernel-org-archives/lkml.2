Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0GHHS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:18:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:51585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0GHHS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:18:57 -0400
Date: Thu, 8 Jul 2010 07:18:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <tip-*@vger.kernel.org>
References: <tip-*@vger.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Support the features flags in new CPUID leaf 7
Message-ID: <tip-bdc802dcca1709b01988d57e91f9f35ce1609fcc@git.kernel.org>
Git-Commit-ID: bdc802dcca1709b01988d57e91f9f35ce1609fcc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:18:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdc802dcca1709b01988d57e91f9f35ce1609fcc
Gitweb:     http://git.kernel.org/tip/bdc802dcca1709b01988d57e91f9f35ce1609fcc
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 7 Jul 2010 17:29:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 7 Jul 2010 17:29:18 -0700

x86, cpu: Support the features flags in new CPUID leaf 7

Intel has defined CPUID leaf 7 as the next set of feature flags (see
the AVX specification, version 007).  Add support for this new feature
flags word.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@vger.kernel.org>
---
 arch/x86/include/asm/cpufeature.h        |   13 +++++++++----
 arch/x86/include/asm/required-features.h |    2 ++
 arch/x86/kernel/cpu/common.c             |   10 ++++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index aeb6f3f..3ec9275 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -159,14 +159,14 @@
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
- * CPUID levels like 0x6, 0xA etc
+ * CPUID levels like 0x6, 0xA etc, word 7
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 
-/* Virtualization flags: Linux defined */
+/* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
 #define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
@@ -177,6 +177,9 @@
 #define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
 #define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
 
+/* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
+#define X86_FEATURE_FSGSBASE	(9*32+0)  /* {RD/WR}{FS/GS}BASE instructions*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <asm/asm.h>
@@ -197,7 +200,9 @@ extern const char * const x86_power_flags[32];
 	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
 	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
-	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
+	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
 	  ? 1 :								\
 	 test_cpu_cap(c, bit))
 
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 64cf2d2..6c7fc25 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -84,5 +84,7 @@
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
+#define REQUIRED_MASK8	0
+#define REQUIRED_MASK9	0
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 68e4a6f..c735830 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -551,6 +551,16 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[4] = excap;
 	}
 
+	/* Additional Intel-defined flags: level 0x00000007 */
+	if (c->cpuid_level >= 0x00000007) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
+
+		if (eax > 0)
+			c->x86_capability[9] = ebx;
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
