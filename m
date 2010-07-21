Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0GURWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:22:02 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:23062
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750986Ab0GURV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:21:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X430-02-2Z8-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/7] x86, xsave: introduce xstate enable functions
Date: Wed, 21 Jul 2010 19:03:53 +0200
Message-ID: <1279731838-1522-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch renames xsave_cntxt_init() and __xsave_init() into
xstate_enable_boot_cpu() and xstate_enable() as this names are more
meaningful.

It also removes the duplicate xcr setup for the boot cpu.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.1.1


