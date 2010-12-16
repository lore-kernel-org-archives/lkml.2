Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LPMcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:32:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:36375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab0LPMcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:32:53 -0500
Date: Thu, 16 Dec 2010 12:31:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jason.wessel@windriver.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Detect broken BIOSes that corrupt the PMU
Message-ID: <tip-4407204c5c9037763aadce39b025529dfbfcac9e@git.kernel.org>
Git-Commit-ID: 4407204c5c9037763aadce39b025529dfbfcac9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:31:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4407204c5c9037763aadce39b025529dfbfcac9e
Gitweb:     http://git.kernel.org/tip/4407204c5c9037763aadce39b025529dfbfcac9e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Dec 2010 15:56:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:42 +0100

perf, x86: Detect broken BIOSes that corrupt the PMU

Some BIOSes use PMU resources, which can cause various bugs:

 - Non-working or erratic PMU based statistics - the PMU can end up
   counting the wrong thing, resulting in misleading statistics

 - Profiling can stop working or it can profile the wrong thing

 - A non-working or erratic NMI watchdog that cannot be relied on

 - The kernel may disturb whatever thing the BIOS tries to use the
   PMU for - possibly causing hardware malfunction in extreme cases.

 - ... and other forms of potential misbehavior

Various forms of such misbehavior has been observed in practice - there are
BIOSes that just corrupt the PMU state, consequences be damned.

The PMU is a CPU resource that is handled by the kernel and the BIOS
stealing+corrupting it is not acceptable nor robust, so we detect it,
warn about it and further refuse to touch the PMU ourselves.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   48 +++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 817d2b1..ce27c54 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -375,15 +375,53 @@ static void release_pmc_hardware(void) {}
 static bool check_hw_exists(void)
 {
 	u64 val, val_new = 0;
-	int ret = 0;
+	int i, reg, ret = 0;
+
+	/*
+	 * Check to see if the BIOS enabled any of the counters, if so
+	 * complain and bail.
+	 */
+	for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu.eventsel + i;
+		ret = rdmsrl_safe(reg, &val);
+		if (ret)
+			goto msr_fail;
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
+			goto bios_fail;
+	}
+
+	if (x86_pmu.num_counters_fixed) {
+		reg = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		ret = rdmsrl_safe(reg, &val);
+		if (ret)
+			goto msr_fail;
+		for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
+			if (val & (0x03 << i*4))
+				goto bios_fail;
+		}
+	}
 
+	/*
+	 * Now write a value and read it back to see if it matches,
+	 * this is needed to detect certain hardware emulators (qemu/kvm)
+	 * that don't trap on the MSR access and always return 0s.
+	 */
 	val = 0xabcdUL;
-	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
+	ret = checking_wrmsrl(x86_pmu.perfctr, val);
 	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
 	if (ret || val != val_new)
-		return false;
+		goto msr_fail;
 
 	return true;
+
+bios_fail:
+	printk(KERN_CONT "Broken BIOS detected, using software events only.\n");
+	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
+	return false;
+
+msr_fail:
+	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
+	return false;
 }
 
 static void reserve_ds_buffers(void);
@@ -1378,10 +1416,8 @@ int __init init_hw_perf_events(void)
 	pmu_check_apic();
 
 	/* sanity check that the hardware exists or is emulated */
-	if (!check_hw_exists()) {
-		pr_cont("Broken PMU hardware detected, software events only.\n");
+	if (!check_hw_exists())
 		return 0;
-	}
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
