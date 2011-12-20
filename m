Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1LTB1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:27:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1LTB12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:27:28 -0500
Date: Mon, 19 Dec 2011 17:27:18 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-2023bae21ec13d12cdaf877809a17ee75190649b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1324338394-4670-4-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/autoprobe] x86, intel-idle:
  convert to x86_cpu_id auto probing
Git-Commit-ID: 2023bae21ec13d12cdaf877809a17ee75190649b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 17:27:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2023bae21ec13d12cdaf877809a17ee75190649b
Gitweb:     http://git.kernel.org/tip/2023bae21ec13d12cdaf877809a17ee75190649b
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 19 Dec 2011 15:46:29 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 15:49:38 -0800

x86, intel-idle: convert to x86_cpu_id auto probing

With this it should be automatically loaded on suitable systems by
udev.

The old switch () is replaced with a table based approach, this
also cleans up the code.

Cc: lenb@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1324338394-4670-4-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/idle/intel_idle.c |  114 +++++++++++++++++++++++++-------------------
 1 files changed, 65 insertions(+), 49 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d2f8e1..a0b292a 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -62,6 +62,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <asm/cpu_device_id.h>
 #include <asm/mwait.h>
 #include <asm/msr.h>
 
@@ -81,6 +82,17 @@ static unsigned int mwait_substates;
 /* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
 static unsigned int lapic_timer_reliable_states = (1 << 1);	 /* Default to only C1 */
 
+struct idle_cpu {
+	struct cpuidle_state *state_table;
+
+	/*
+	 * Hardware C-state auto-demotion may not always be optimal.
+	 * Indicate which enable bits to clear here.
+	 */
+	unsigned long auto_demotion_disable_flags;
+};
+
+static const struct idle_cpu *icpu;
 static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
 static int intel_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv, int index);
@@ -88,12 +100,6 @@ static int intel_idle(struct cpuidle_device *dev,
 static struct cpuidle_state *cpuidle_state_table;
 
 /*
- * Hardware C-state auto-demotion may not always be optimal.
- * Indicate which enable bits to clear here.
- */
-static unsigned long long auto_demotion_disable_flags;
-
-/*
  * Set this flag for states where the HW flushes the TLB for us
  * and so we don't need cross-calls to keep it consistent.
  * If this flag is set, SW flushes the TLB, so even if the
@@ -320,27 +326,72 @@ static void auto_demotion_disable(void *dummy)
 	unsigned long long msr_bits;
 
 	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-	msr_bits &= ~auto_demotion_disable_flags;
+	msr_bits &= ~(icpu->auto_demotion_disable_flags);
 	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
 }
 
+static const struct idle_cpu idle_cpu_nehalem = {
+	.state_table = nehalem_cstates,
+};
+
+static const struct idle_cpu idle_cpu_westmere = {
+	.state_table = nehalem_cstates,
+	.auto_demotion_disable_flags = NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE,
+};
+
+static const struct idle_cpu idle_cpu_atom = {
+	.state_table = atom_cstates,
+};
+
+static const struct idle_cpu idle_cpu_lincroft = {
+	.state_table = atom_cstates,
+	.auto_demotion_disable_flags = ATM_LNC_C6_AUTO_DEMOTE,
+};
+
+static const struct idle_cpu idle_cpu_snb = {
+	.state_table = snb_cstates,
+};
+
+#define ICPU(model, cpu) \
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
+
+static const struct x86_cpu_id intel_idle_ids[] = {
+	ICPU(0x1a, idle_cpu_nehalem),
+	ICPU(0x1e, idle_cpu_nehalem),
+	ICPU(0x1f, idle_cpu_nehalem),
+	ICPU(0x25, idle_cpu_westmere),
+	ICPU(0x2c, idle_cpu_westmere),
+	ICPU(0x2f, idle_cpu_westmere),
+	ICPU(0x1c, idle_cpu_atom),
+	ICPU(0x26, idle_cpu_lincroft),
+	ICPU(0x2f, idle_cpu_westmere),
+	ICPU(0x2a, idle_cpu_snb),
+	ICPU(0x2d, idle_cpu_snb),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
+
 /*
  * intel_idle_probe()
  */
 static int intel_idle_probe(void)
 {
 	unsigned int eax, ebx, ecx;
+	const struct x86_cpu_id *id;
 
 	if (max_cstate == 0) {
 		pr_debug(PREFIX "disabled\n");
 		return -EPERM;
 	}
 
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
-		return -ENODEV;
-
-	if (!boot_cpu_has(X86_FEATURE_MWAIT))
+	id = x86_match_cpu(intel_idle_ids);
+	if (!id) {
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+		    boot_cpu_data.x86 == 6)
+			pr_debug(PREFIX "does not run on family %d model %d\n",
+				boot_cpu_data.x86, boot_cpu_data.x86_model);
 		return -ENODEV;
+	}
 
 	if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
 		return -ENODEV;
@@ -353,43 +404,8 @@ static int intel_idle_probe(void)
 
 	pr_debug(PREFIX "MWAIT substates: 0x%x\n", mwait_substates);
 
-
-	if (boot_cpu_data.x86 != 6)	/* family 6 */
-		return -ENODEV;
-
-	switch (boot_cpu_data.x86_model) {
-
-	case 0x1A:	/* Core i7, Xeon 5500 series */
-	case 0x1E:	/* Core i7 and i5 Processor - Lynnfield Jasper Forest */
-	case 0x1F:	/* Core i7 and i5 Processor - Nehalem */
-	case 0x2E:	/* Nehalem-EX Xeon */
-	case 0x2F:	/* Westmere-EX Xeon */
-	case 0x25:	/* Westmere */
-	case 0x2C:	/* Westmere */
-		cpuidle_state_table = nehalem_cstates;
-		auto_demotion_disable_flags =
-			(NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE);
-		break;
-
-	case 0x1C:	/* 28 - Atom Processor */
-		cpuidle_state_table = atom_cstates;
-		break;
-
-	case 0x26:	/* 38 - Lincroft Atom Processor */
-		cpuidle_state_table = atom_cstates;
-		auto_demotion_disable_flags = ATM_LNC_C6_AUTO_DEMOTE;
-		break;
-
-	case 0x2A:	/* SNB */
-	case 0x2D:	/* SNB Xeon */
-		cpuidle_state_table = snb_cstates;
-		break;
-
-	default:
-		pr_debug(PREFIX "does not run on family %d model %d\n",
-			boot_cpu_data.x86, boot_cpu_data.x86_model);
-		return -ENODEV;
-	}
+	icpu = (const struct idle_cpu *)id->driver_data;
+	cpuidle_state_table = icpu->state_table;
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
@@ -470,7 +486,7 @@ static int intel_idle_cpuidle_driver_init(void)
 		drv->state_count += 1;
 	}
 
-	if (auto_demotion_disable_flags)
+	if (icpu->auto_demotion_disable_flags)
 		smp_call_function(auto_demotion_disable, NULL, 1);
 
 	return 0;
