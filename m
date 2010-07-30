Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0G3XeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:34:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0G3XeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:34:09 -0400
Date: Fri, 30 Jul 2010 23:33:50 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
In-Reply-To: <1280448826-12004-2-git-send-email-fenghua.yu@intel.com>
References: <1280448826-12004-2-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Package Level Thermal Control, Power Limit Notification definitions
Message-ID: <tip-9792db6174d9927700ed288e6d74b9391bf785d1@git.kernel.org>
Git-Commit-ID: 9792db6174d9927700ed288e6d74b9391bf785d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 23:33:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9792db6174d9927700ed288e6d74b9391bf785d1
Gitweb:     http://git.kernel.org/tip/9792db6174d9927700ed288e6d74b9391bf785d1
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 Jul 2010 17:13:42 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Jul 2010 16:15:32 -0700

x86, cpu: Package Level Thermal Control, Power Limit Notification definitions

Add package level thermal and power limit feature support.

The two MSRs and features are new starting with Intel's Sandy Bridge processor.

Please check Intel 64 and IA-32 Architectures SDMV Vol 3A 14.5.6 Power Limit
Notification and 14.6 Package Level Thermal Management.

This patch also fixes a bug which defines reverse THERM_INT_LOW_ENABLE bit and
THERM_INT_HIGH_ENABLE bit.

[ hpa: fixed up against current tip:x86/cpu ]

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <1280448826-12004-2-git-send-email-fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/include/asm/msr-index.h  |   17 +++++++++++++++--
 arch/x86/kernel/cpu/scattered.c   |    2 ++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4be50dd..817aa31 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -166,6 +166,8 @@
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
+#define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
+#define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7cc4a02..4ea2a7c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -224,12 +224,14 @@
 #define MSR_IA32_THERM_CONTROL		0x0000019a
 #define MSR_IA32_THERM_INTERRUPT	0x0000019b
 
-#define THERM_INT_LOW_ENABLE		(1 << 0)
-#define THERM_INT_HIGH_ENABLE		(1 << 1)
+#define THERM_INT_HIGH_ENABLE		(1 << 0)
+#define THERM_INT_LOW_ENABLE		(1 << 1)
+#define THERM_INT_PLN_ENABLE		(1 << 24)
 
 #define MSR_IA32_THERM_STATUS		0x0000019c
 
 #define THERM_STATUS_PROCHOT		(1 << 0)
+#define THERM_STATUS_POWER_LIMIT	(1 << 10)
 
 #define MSR_THERM2_CTL			0x0000019d
 
@@ -241,6 +243,17 @@
 
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
 
+#define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
+
+#define PACKAGE_THERM_STATUS_PROCHOT		(1 << 0)
+#define PACKAGE_THERM_STATUS_POWER_LIMIT	(1 << 10)
+
+#define MSR_IA32_PACKAGE_THERM_INTERRUPT	0x000001b2
+
+#define PACKAGE_THERM_INT_HIGH_ENABLE		(1 << 0)
+#define PACKAGE_THERM_INT_LOW_ENABLE		(1 << 1)
+#define PACKAGE_THERM_INT_PLN_ENABLE		(1 << 24)
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 9815364..34b4dad 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -33,6 +33,8 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
+		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
+		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
