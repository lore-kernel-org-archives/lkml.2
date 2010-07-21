Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984Ab0GUAlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761910Ab0GUAkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:40:40 -0400
Date: Wed, 21 Jul 2010 00:40:22 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279651857-24639-5-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Move boot cpu initialization to xsave_init()
Message-ID: <tip-82d4150cec83b9775f84810b39a1c0b91585d429@git.kernel.org>
Git-Commit-ID: 82d4150cec83b9775f84810b39a1c0b91585d429
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 00:40:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82d4150cec83b9775f84810b39a1c0b91585d429
Gitweb:     http://git.kernel.org/tip/82d4150cec83b9775f84810b39a1c0b91585d429
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 20 Jul 2010 20:50:51 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 16:21:44 -0700

x86, xsave: Move boot cpu initialization to xsave_init()

This patch moves boot cpu initialization to xsave_init(). Now all cpus
are initialized in one single function.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279651857-24639-5-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    6 ------
 arch/x86/kernel/i387.c       |    5 -----
 arch/x86/kernel/xsave.c      |   14 ++++++++++++--
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 26804b2..4056108 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1270,12 +1270,6 @@ void __cpuinit cpu_init(void)
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
-	if (!smp_processor_id())
-		init_thread_xstate();
-
 	xsave_init();
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 6106af9..2f32ef0 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -93,11 +93,6 @@ void __cpuinit fpu_init(void)
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
-	/*
-	 * Boot processor to setup the FP and extended state context info.
-	 */
-	if (!smp_processor_id())
-		init_thread_xstate();
 	xsave_init();
 
 	mxcsr_feature_mask_init();
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 368047c..ab9ad48 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -360,7 +360,7 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-void __cpuinit xsave_init(void)
+static void __cpuinit __xsave_init(void)
 {
 	if (!cpu_has_xsave)
 		return;
@@ -446,7 +446,7 @@ void __ref xsave_cntxt_init(void)
 	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
-	xsave_init();
+	__xsave_init();
 
 	/*
 	 * Recompute the context size for enabled features
@@ -463,3 +463,13 @@ void __ref xsave_cntxt_init(void)
 	       "cntxt size 0x%x\n",
 	       pcntxt_mask, xstate_size);
 }
+
+void __cpuinit xsave_init(void)
+{
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+	__xsave_init();
+}
