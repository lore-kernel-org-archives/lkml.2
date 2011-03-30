Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461Ab1C3WV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:21:26 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:38583 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab1C3WVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:21:24 -0400
Date: Wed, 30 Mar 2011 18:21:02 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: x86@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Message-id: <alpine.LFD.2.02.1103301819250.31342@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Since 2.6.35 (23016bf0d25), Linux prints the existence of "epb" in /proc/cpuinfo,
Since 2.6.38 (d5532ee7b40), the x86_energy_perf_policy(8) utility is available
in-tree to update MSR_IA32_ENERGY_PERF_BIAS.

However, the typical BIOS fails to initialize the MSR,
and the typical Linux distro neglects to invoke x86_energy_perf_policy(8).

The result is that some modern hardware is running in hardware default,
which is "performance" mode, rather than the intended design default
of "normal" mode.

Initialize the MSR to the "normal" setting during kernel boot.

Of course, x86_energy_perf_policy(8) is available to change
the default after boot, should the user have a policy preference.

cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/msr-index.h |    3 +++
 arch/x86/kernel/cpu/intel.c      |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 43a18c7..91fedd9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -250,6 +250,9 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSWAVE	15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d16c2c5..48cca4a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -448,6 +448,20 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
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
+			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.4.2.406.gbe91

