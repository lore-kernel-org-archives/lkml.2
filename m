Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab1GNVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:13:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1GNVNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:13:43 -0400
Date: Thu, 14 Jul 2011 21:12:56 GMT
From: tip-bot for Len Brown <len.brown@intel.com>
Message-ID: <tip-abe48b108247e9b90b4c6739662a2e5c765ed114@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com, len.brown@intel.com
In-Reply-To: <alpine.LFD.2.02.1107140051020.18606@x980>
References: <alpine.LFD.2.02.1107140051020.18606@x980>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Git-Commit-ID: abe48b108247e9b90b4c6739662a2e5c765ed114
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abe48b108247e9b90b4c6739662a2e5c765ed114
Gitweb:     http://git.kernel.org/tip/abe48b108247e9b90b4c6739662a2e5c765ed114
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Thu, 14 Jul 2011 00:53:24 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 12:13:42 -0700

x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS

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
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1107140051020.18606@x980
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>
---
 arch/x86/include/asm/msr-index.h |    3 +++
 arch/x86/kernel/cpu/intel.c      |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..23a9d89 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -259,6 +259,9 @@
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+#define ENERGY_PERF_BIAS_PERFORMANCE	0
+#define ENERGY_PERF_BIAS_NORMAL		6
+#define ENERGY_PERF_BIAS_POWERSWAVE	15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1edf5ba..da0d779 100644
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
