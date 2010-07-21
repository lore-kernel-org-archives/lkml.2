Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab0GUWih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:38:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0GUWie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:38:34 -0400
Date: Wed, 21 Jul 2010 22:38:17 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C476236.1020302@zytor.com>
References: <4C476236.1020302@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Make xstate_enable_boot_cpu() __init, protect on CPU 0
Message-ID: <tip-1cff92d8fdb27684308864d9cdb324bee43b40ab@git.kernel.org>
Git-Commit-ID: 1cff92d8fdb27684308864d9cdb324bee43b40ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:38:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cff92d8fdb27684308864d9cdb324bee43b40ab
Gitweb:     http://git.kernel.org/tip/1cff92d8fdb27684308864d9cdb324bee43b40ab
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 21 Jul 2010 14:23:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 15:33:54 -0700

x86, xsave: Make xstate_enable_boot_cpu() __init, protect on CPU 0

xstate_enable_boot_cpu() is, as the name implies, only used on the
boot CPU; furthermore, it invokes alloc_bootmem(), which is __init;
hence it needs to be tagged __init rather than __cpuinit.

Furthermore, it is *not* safe in the long run to rely on CPU 0 only
coming online during the early boot -- at some point we're going to
support offlining (and re-onlining) the boot CPU, and at that point we
must not call xstate_enable_boot_cpu() again.

The code is a fair bit more obscure than one would like, because the
__ref overrides aren't quite powerful enough.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4C476236.1020302@zytor.com>
---
 arch/x86/kernel/xsave.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index cfc7901..b2549c3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -360,10 +360,10 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-static inline void xstate_enable(u64 mask)
+static inline void xstate_enable(void)
 {
 	set_in_cr4(X86_CR4_OSXSAVE);
-	xsetbv(XCR_XFEATURE_ENABLED_MASK, mask);
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
 /*
@@ -421,7 +421,7 @@ static void __init setup_xstate_init(void)
 /*
  * Enable and initialize the xsave feature.
  */
-static void __cpuinit xstate_enable_boot_cpu(void)
+static void __init xstate_enable_boot_cpu(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -444,7 +444,7 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
 
-	xstate_enable(pcntxt_mask);
+	xstate_enable();
 
 	/*
 	 * Recompute the context size for enabled features
@@ -462,16 +462,22 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 	       pcntxt_mask, xstate_size);
 }
 
+/*
+ * For the very first instance, this calls xstate_enable_boot_cpu();
+ * for all subsequent instances, this calls xstate_enable().
+ *
+ * This is somewhat obfuscated due to the lack of powerful enough
+ * overrides for the section checks.
+ */
 void __cpuinit xsave_init(void)
 {
+	static __refdata void (*next_func)(void) = xstate_enable_boot_cpu;
+	void (*this_func)(void);
+
 	if (!cpu_has_xsave)
 		return;
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
-	if (!smp_processor_id())
-		xstate_enable_boot_cpu();
-	else
-		xstate_enable(pcntxt_mask);
+	this_func = next_func;
+	next_func = xstate_enable;
+	this_func();
 }
