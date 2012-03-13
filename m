Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2CMAW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:47644 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565Ab2CMAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 066/196] x86, cpu: Clean up AMD erratum 400 workaround
Date: Mon, 12 Mar 2012 20:19:39 -0400
Message-Id: <1331598109-31424-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Rosenfeld <hans.rosenfeld@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.

Remove check_c1e_idle() and use the new AMD errata checking framework
instead.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1280336972-865982-2-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/amd.c        |    5 +++++
 arch/x86/kernel/process.c        |   39 ++------------------------------------
 3 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b213059..7eb1dd7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1035,6 +1035,7 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
  * AMD errata checking
  */
 #ifdef CONFIG_CPU_SUP_AMD
+extern const int amd_erratum_400[];
 extern bool cpu_has_amd_erratum(const int *);
 
 #define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1d0c58e..08dd1be 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -628,6 +628,11 @@ cpu_dev_register(amd_cpu_dev);
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
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 0415c3e..efabf8f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -525,42 +525,6 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
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
 
@@ -638,7 +602,8 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
-	} else if (check_c1e_idle(c)) {
+	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
-- 
1.7.9.3

