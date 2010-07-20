Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0GTS7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:59:42 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14389 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab0GTS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0W-02-35S-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/10] x86, xsave: moving boot cpu initialization to xsave_init()
Date: Tue, 20 Jul 2010 20:50:51 +0200
Message-ID: <1279651857-24639-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves boot cpu initialization to xsave_init(). Now all cpus
are initialized in one single function.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/common.c |    6 ------
 arch/x86/kernel/i387.c       |    5 -----
 arch/x86/kernel/xsave.c      |   14 ++++++++++++--
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 433afed..1a053e0 100644
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
-- 
1.7.1.1


