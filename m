Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0GVQVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:21:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:10556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab0GVQVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,243,1278313200"; 
   d="scan'208";a="640788213"
Date: Thu, 22 Jul 2010 09:21:48 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Huaxu Wan <huaxu.wan@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: [PATCH 1/5] Package Level Thermal Control and Power Limit Notification: feature enabling
Message-ID: <20100722162148.GA21470@linux-os.sc.intel.com>
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com> <4C485DF1.5050407@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C485DF1.5050407@linux.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add package level thermal and power limit feature support in the kernel.

The two MSRs and features are new starting with Intel's Sandy Bridge processor.

Please check Intel 64 and IA-32 Architectures SDMV Vol 3A 14.5.6 Power Limit
Notification and 14.6 Package Level Thermal Management.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
---

 include/asm/cpufeature.h          |    2 ++
 include/asm/msr-index.h           |    3 +++
 kernel/cpu/addon_cpuid_features.c |    2 ++
 3 files changed, 7 insertions(+)

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
index 8c7ae43..5eaad6f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -239,6 +239,9 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
+#define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
+#define MSR_IA32_PACKAGE_THERM_INTERRUPT	0x000001b2
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
