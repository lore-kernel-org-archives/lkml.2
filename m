Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab0FQRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:58534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760355Ab0FQRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:07:19 -0400
Date: Thu, 17 Jun 2010 17:07:00 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1276681733-10872-2-git-send-email-hans.rosenfeld@amd.com>
References: <1276681733-10872-2-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Clean up AMD erratum 400 workaround
Message-ID: <tip-63946e5f5436b1f30f9680ea877c6fdff0e2e177@git.kernel.org>
Git-Commit-ID: 63946e5f5436b1f30f9680ea877c6fdff0e2e177
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 17:07:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63946e5f5436b1f30f9680ea877c6fdff0e2e177
Gitweb:     http://git.kernel.org/tip/63946e5f5436b1f30f9680ea877c6fdff0e2e177
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 16 Jun 2010 11:48:53 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Jun 2010 17:28:15 -0700

x86, cpu: Clean up AMD erratum 400 workaround

Remove check_c1e_idle() and use the new AMD errata checking framework
instead.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1276681733-10872-2-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |    4 +++
 arch/x86/kernel/process.c        |   39 +------------------------------------
 2 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 09fb3a1..dd89042 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1053,6 +1053,10 @@ extern bool cpu_has_amd_erratum(const struct cpuinfo_x86 *, bool, ...);
 #define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
 #define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
 
+#define AMD_ERRATUM_400							\
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf), \
+			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf))
+
 #endif /* CONFIG_CPU_SUP_AMD */
 
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3521..c288239 100644
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
+	} else if (cpu_has_amd_erratum(c, AMD_ERRATUM_400)) {
+		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		printk(KERN_INFO "using C1E aware idle routine\n");
 		pm_idle = c1e_idle;
 	} else
