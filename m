Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1DZVO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:35825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab1DZVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483653"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: hans.rosenfeld@amd.com, ak@linux.intel.com, hpa@linux.intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [64/106] x86, cpu: Clean up AMD erratum 400 workaround
Message-Id: <20110426211345.1AD213E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans Rosenfeld <hans.rosenfeld@amd.com>

commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.

Remove check_c1e_idle() and use the new AMD errata checking framework
instead.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1280336972-865982-2-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/amd.c        |    5 +++++
 arch/x86/kernel/process.c        |   39 ++-------------------------------------
 3 files changed, 8 insertions(+), 37 deletions(-)

Index: linux-2.6.35.y/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/processor.h
+++ linux-2.6.35.y/arch/x86/include/asm/processor.h
@@ -1006,6 +1006,7 @@ unsigned long calc_aperfmperf_ratio(stru
  * AMD errata checking
  */
 #ifdef CONFIG_CPU_SUP_AMD
+extern const int amd_erratum_400[];
 extern bool cpu_has_amd_erratum(const int *);
 
 #define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -627,6 +627,11 @@ cpu_dev_register(amd_cpu_dev);
  *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
  */
 
+const int amd_erratum_400[] =
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
+
+
 bool cpu_has_amd_erratum(const int *erratum)
 {
 	struct cpuinfo_x86 *cpu = &current_cpu_data;
Index: linux-2.6.35.y/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/process.c
+++ linux-2.6.35.y/arch/x86/kernel/process.c
@@ -525,42 +525,6 @@ static int __cpuinit mwait_usable(const 
 	return (edx & MWAIT_EDX_C1);
 }
 
-/*
- * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
- * For more information see
- * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
- * - Erratum #365 for family 0x11 (not affected because C1e not in use)
- */
-static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
-{
-	u64 val;
-	if (c->x86_vendor != X86_VENDOR_AMD)
-		goto no_c1e_idle;
-
-	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0F && c->x86_model >= 0x40)
-		return 1;
-
-	if (c->x86 == 0x10) {
-		/*
-		 * check OSVW bit for CPUs that are not affected
-		 * by erratum #400
-		 */
-		if (cpu_has(c, X86_FEATURE_OSVW)) {
-			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
-			if (val >= 2) {
-				rdmsrl(MSR_AMD64_OSVW_STATUS, val);
-				if (!(val & BIT(1)))
-					goto no_c1e_idle;
-			}
-		}
-		return 1;
-	}
-
-no_c1e_idle:
-	return 0;
-}
-
 static cpumask_var_t c1e_mask;
 static int c1e_detected;
 
@@ -638,7 +602,8 @@ void __cpuinit select_idle_routine(const
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (check_c1e_idle(c)) {
+	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
