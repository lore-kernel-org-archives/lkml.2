Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0HRBJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:09:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0HRBJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:09:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.36-rc1: Doesn't boot on an AMD-based machine
Date: Wed, 18 Aug 2010 03:07:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
References: <201008172206.14349.rjw@sisk.pl>
In-Reply-To: <201008172206.14349.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008180307.42504.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 17, 2010, Rafael J. Wysocki wrote:
> Hi,
> 
> The subject says it all, the last message printed is:
> 
> CPU0: AMD Athlon(tm) X2 Dual Core Processor L310 stepping 02
> 
> so I guess the AMD C1E detection is broken.
> 
> I'm going to identify the offending commit.

There you go:

commit 9d8888c2a214aece2494a49e699a097c2ba9498b
Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
Date:   Wed Jul 28 19:09:31 2010 +0200

    x86, cpu: Clean up AMD erratum 400 workaround
    
    Remove check_c1e_idle() and use the new AMD errata checking framework
    instead.
    
    Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
    LKML-Reference: <1280336972-865982-2-git-send-email-hans.rosenfeld@amd.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

It doesn't revert cleanly so appended is the revert patch I used for the
verification if this commit is really responsible for the boot failure.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Revert commit  9d8888c2a214aece2494a49e699a097c2ba9498b
(x86, cpu: Clean up AMD erratum 400 workaround) that causes my Acer
Ferrari One, based on AMD Athlon(tm) X2 Dual Core Processor L310
stepping 02, to hang solid during boot (while configuring the CPU).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/include/asm/processor.h |    1 -
 arch/x86/kernel/cpu/amd.c        |    5 -----
 arch/x86/kernel/process.c        |   39 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -1031,7 +1031,6 @@ unsigned long calc_aperfmperf_ratio(stru
  */
 #ifdef CONFIG_CPU_SUP_AMD
 extern const int amd_erratum_383[];
-extern const int amd_erratum_400[];
 extern bool cpu_has_amd_erratum(const int *);
 
 #define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -628,11 +628,6 @@ cpu_dev_register(amd_cpu_dev);
  *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
  */
 
-const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
-			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
-EXPORT_SYMBOL_GPL(amd_erratum_400);
-
 const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_383);
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -529,6 +529,42 @@ static int __cpuinit mwait_usable(const 
 bool c1e_detected;
 EXPORT_SYMBOL(c1e_detected);
 
+/*
+ * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
+ * For more information see
+ * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
+ * - Erratum #365 for family 0x11 (not affected because C1e not in use)
+ */
+static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
+{
+	u64 val;
+	if (c->x86_vendor != X86_VENDOR_AMD)
+		goto no_c1e_idle;
+
+	/* Family 0x0f models < rev F do not have C1E */
+	if (c->x86 == 0x0F && c->x86_model >= 0x40)
+		return 1;
+
+	if (c->x86 == 0x10) {
+		/*
+		 * check OSVW bit for CPUs that are not affected
+		 * by erratum #400
+		 */
+		if (cpu_has(c, X86_FEATURE_OSVW)) {
+			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+			if (val >= 2) {
+				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+				if (!(val & BIT(1)))
+					goto no_c1e_idle;
+			}
+		}
+		return 1;
+	}
+
+no_c1e_idle:
+	return 0;
+}
+
 static cpumask_var_t c1e_mask;
 
 void c1e_remove_cpu(int cpu)
@@ -605,8 +641,7 @@ void __cpuinit select_idle_routine(const
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
-		/* E400: APIC timer interrupt does not wake up CPU from C1e */
+	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
