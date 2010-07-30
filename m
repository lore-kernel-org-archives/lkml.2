Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab0G3AWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:22:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:20012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab0G3AWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,283,1278313200"; 
   d="scan'208";a="591131108"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Huaxu Wan" <huaxu.wan@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH V3 1/5] Package Level Thermal Control and Power Limit Notification: enable features
Date: Thu, 29 Jul 2010 17:13:42 -0700
Message-Id: <1280448826-12004-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280448826-12004-1-git-send-email-fenghua.yu@intel.com>
References: <1280448826-12004-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add package level thermal and power limit feature support in the kernel.

The two MSRs and features are new starting with Intel's Sandy Bridge processor.

Please check Intel 64 and IA-32 Architectures SDMV Vol 3A 14.5.6 Power Limit
Notification and 14.6 Package Level Thermal Management.

This patch also fixes a bug which defines reverse THERM_INT_LOW_ENABLE bit and
THERM_INT_HIGH_ENABLE bit.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/cpufeature.h          |    2 ++
 arch/x86/include/asm/msr-index.h           |   17 +++++++++++++++--
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 ++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..79517b5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -162,6 +162,8 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_PLN		(7*32+ 3) /* Intel Power Limit Notification */
+#define X86_FEATURE_PTS		(7*32+ 4) /* Intel Package Thermal Status */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 8c7ae43..f3c8a7a 100644
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
 
@@ -239,6 +241,17 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
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
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 10fa568..c1f4b98 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -32,6 +32,8 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006 },
+		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
 		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
-- 
1.6.0.3

