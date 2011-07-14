Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1GNExg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:53:36 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:49162 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1GNExf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:53:35 -0400
Date: Thu, 14 Jul 2011 00:53:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH v2] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <4E1E106E.4060408@zytor.com>
Message-id: <alpine.LFD.2.02.1107140051020.18606@x980>
References: <alpine.LFD.2.02.1103301819250.31342@x980>
 <20110414090854.GB9248@elte.hu> <alpine.LFD.2.02.1104150202310.29365@x980>
 <20110415101712.GB28007@elte.hu> <alpine.LFD.2.02.1107131640280.9546@x980>
 <CA+55aFxBkgwBbnqwO7DuizsWiVcULYtPzqr-mYrT6aHmXV0zZw@mail.gmail.com>
 <4E1E106E.4060408@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

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

cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/msr-index.h |    3 +++
 arch/x86/kernel/cpu/intel.c      |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

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
index d16c2c5..7c1ca07 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -448,6 +448,24 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
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
-- 
1.7.6.134.gcf13f


