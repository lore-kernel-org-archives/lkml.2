Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1GVOoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:44:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1GVOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:44:20 -0400
Date: Fri, 22 Jul 2011 16:42:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.1
Message-ID: <20110722144236.GA13498@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, msr: Fix typo in ENERGY_PERF_BIAS_POWERSAVE

Len Brown (2):
      x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS
      x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message


 arch/x86/include/asm/msr-index.h |    3 +++
 arch/x86/kernel/cpu/intel.c      |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..d96bdb2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -259,6 +259,9 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSAVE	15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1edf5ba..ed6086e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -456,6 +456,24 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
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
+		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
+			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+				" Set to 'normal', was 'performance'\n"
+				"ENERGY_PERF_BIAS: View and update with"
+				" x86_energy_perf_policy(8)\n");
+			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
