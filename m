Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab0GUWhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:37:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:42834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0GUWhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:37:22 -0400
Date: Wed, 21 Jul 2010 22:37:04 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279731838-1522-3-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Introduce xstate enable functions
Message-ID: <tip-97e80a70db689fb1e876df9f12305cc72f85ca53@git.kernel.org>
Git-Commit-ID: 97e80a70db689fb1e876df9f12305cc72f85ca53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:37:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97e80a70db689fb1e876df9f12305cc72f85ca53
Gitweb:     http://git.kernel.org/tip/97e80a70db689fb1e876df9f12305cc72f85ca53
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 14:06:04 -0700

x86, xsave: Introduce xstate enable functions

The patch renames xsave_cntxt_init() and __xsave_init() into
xstate_enable_boot_cpu() and xstate_enable() as this names are more
meaningful.

It also removes the duplicate xcr setup for the boot cpu.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-3-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 550bf45..2322f58 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -360,15 +360,10 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-static void __cpuinit __xsave_init(void)
+static inline void xstate_enable(u64 mask)
 {
 	set_in_cr4(X86_CR4_OSXSAVE);
-
-	/*
-	 * Enable all the features that the HW is capable of
-	 * and the Linux kernel is aware of.
-	 */
-	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, mask);
 }
 
 /*
@@ -426,7 +421,7 @@ static void __init setup_xstate_init(void)
 /*
  * Enable and initialize the xsave feature.
  */
-static void __cpuinit xsave_cntxt_init(void)
+static void __cpuinit xstate_enable_boot_cpu(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -443,7 +438,8 @@ static void __cpuinit xsave_cntxt_init(void)
 	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
-	__xsave_init();
+
+	xstate_enable(pcntxt_mask);
 
 	/*
 	 * Recompute the context size for enabled features
@@ -470,6 +466,7 @@ void __cpuinit xsave_init(void)
 	 * Boot processor to setup the FP and extended state context info.
 	 */
 	if (!smp_processor_id())
-		xsave_cntxt_init();
-	__xsave_init();
+		xstate_enable_boot_cpu();
+	else
+		xstate_enable(pcntxt_mask);
 }
