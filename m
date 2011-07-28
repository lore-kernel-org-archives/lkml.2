Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1G1Xv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:51:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:29723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1G1Xoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352051"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: len.brown@intel.com, ak@linux.intel.com, rjw@sisk.pl, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [25/50] x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Message-Id: <20110728234429.BB4CD2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Len Brown <len.brown@intel.com>

[ upstream commit abe48b108247e9b90b4c6739662a2e5c765ed114 ]

Since 2.6.36 (23016bf0d25), Linux prints the existence of "epb" in /proc/cpuinfo,
Since 2.6.38 (d5532ee7b40), the x86_energy_perf_policy(8) utility has
been available in-tree to update MSR_IA32_ENERGY_PERF_BIAS.

However, the typical BIOS fails to initialize the MSR, presumably
because this is handled by high-volume shrink-wrap operating systems...

Linux distros, on the other hand, do not yet invoke x86_energy_perf_policy(8).
As a result, WSM-EP, SNB, and later hardware from Intel will run in its
default hardware power-on state (performance), which assumes that users
care for performance at all costs and not for energy efficiency.
While that is fine for performance benchmarks, the hardware's intended default
operating point is "normal" mode...

Initialize the MSR to the "normal" by default during kernel boot.

x86_energy_perf_policy(8) is available to change the default after boot,
should the user have a different preference.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1107140051020.18606@x980
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>

Index: linux-2.6.35.y/arch/x86/include/asm/msr-index.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/msr-index.h
+++ linux-2.6.35.y/arch/x86/include/asm/msr-index.h
@@ -231,6 +231,11 @@
 #define THERM_INT_LOW_ENABLE		(1 << 0)
 #define THERM_INT_HIGH_ENABLE		(1 << 1)
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSWAVE	15
+
 #define MSR_IA32_THERM_STATUS		0x0000019c
 
 #define THERM_STATUS_PROCHOT		(1 << 0)
Index: linux-2.6.35.y/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/intel.c
@@ -450,6 +450,24 @@ static void __cpuinit init_intel(struct 
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/*
+	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if BIOS did not.
+	 * x86_energy_perf_policy(8) is available to change it at run-time
+	 */
+	if (cpu_has(c, X86_FEATURE_EPB)) {
+		u64 epb;
+
+		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		if ((epb & 0xF) == 0) {
+			printk_once(KERN_WARNING, "x86: updated energy_perf_bias"
+				" to 'normal' from 'performance'\n"
+				"You can view and update epb via utility,"
+				" such as x86_energy_perf_policy(8)\n");
+			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
