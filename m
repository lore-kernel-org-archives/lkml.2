Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab1KJAIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:08:32 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43463
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab1KJAI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:29 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Subject: [RFC PATCH 04/17] powerpc: Allow multiple machine-check handlers
Date: Wed,  9 Nov 2011 19:07:02 -0500
Message-Id: <1320883635-17194-5-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain processor types are co-supportable, and their machine-check
handlers will be referenced if the entries in cputable.c are actually
generated, so allow more than one machine-check handler to be built in.

This fixes a bug where configuring FreeScale E5500 support (P5020DS)
into the kernel would break machine-check handling on PPC64 A2 systems
by using a bogus machine_check_generic() handler that does nothing.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/kernel/traps.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 4e59082..e3113341 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -418,7 +418,8 @@ int machine_check_47x(struct pt_regs *regs)
 
 	return 0;
 }
-#elif defined(CONFIG_E500)
+#endif
+#if defined(CONFIG_FSL_E500MC) || defined(CONFIG_FSL_E5500)
 int machine_check_e500mc(struct pt_regs *regs)
 {
 	unsigned long mcsr = mfspr(SPRN_MCSR);
@@ -517,7 +518,8 @@ silent_out:
 	mtspr(SPRN_MCSR, mcsr);
 	return mfspr(SPRN_MCSR) == 0 && recoverable;
 }
-
+#endif
+#ifdef CONFIG_FSL_E500_V1_V2
 int machine_check_e500(struct pt_regs *regs)
 {
 	unsigned long reason = get_mc_reason(regs);
@@ -557,12 +559,8 @@ int machine_check_e500(struct pt_regs *regs)
 
 	return 0;
 }
-
-int machine_check_generic(struct pt_regs *regs)
-{
-	return 0;
-}
-#elif defined(CONFIG_E200)
+#endif
+#ifdef CONFIG_E200
 int machine_check_e200(struct pt_regs *regs)
 {
 	unsigned long reason = get_mc_reason(regs);
@@ -587,7 +585,8 @@ int machine_check_e200(struct pt_regs *regs)
 
 	return 0;
 }
-#else
+#endif
+
 int machine_check_generic(struct pt_regs *regs)
 {
 	unsigned long reason = get_mc_reason(regs);
@@ -623,7 +622,6 @@ int machine_check_generic(struct pt_regs *regs)
 	}
 	return 0;
 }
-#endif /* everything else */
 
 void machine_check_exception(struct pt_regs *regs)
 {
-- 
1.7.2.5

