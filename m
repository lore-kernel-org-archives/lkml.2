Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1BNW42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:56:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1BNW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:56:25 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: [PATCH v2] ARM: vfp: Always save VFP state in vfp_pm_suspend
Date: Mon, 14 Feb 2011 14:55:47 -0800
Message-Id: <1297724147-6320-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTik_Jey_PtRmr530FVckA6RXHESeX+CyoJC=ZTkR@mail.gmail.com>
References: <AANLkTik_Jey_PtRmr530FVckA6RXHESeX+CyoJC=ZTkR@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfp_pm_suspend should save the VFP state any time there is
a last_VFP_context.  If it only saves when the VFP is enabled,
the state can get lost when, on a UP system:
   Thread 1 uses the VFP
   Context switch occurs to thread 2, VFP is disabled but the
      VFP context is not saved to allow lazy save and restore
   Thread 2 initiates suspend
   vfp_pm_suspend is called with the VFP disabled, but the
      context has not been saved.

Modify vfp_pm_suspend to save the VFP context whenever
last_VFP_context is set.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 66bf8d1..7231d18 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -415,13 +415,13 @@ static int vfp_pm_suspend(struct sys_device *dev, pm_message_t state)
 	struct thread_info *ti = current_thread_info();
 	u32 fpexc = fmrx(FPEXC);
 
-	/* if vfp is on, then save state for resumption */
-	if (fpexc & FPEXC_EN) {
+	/* save state for resume */
+	if (last_VFP_context[ti->cpu]) {
 		printk(KERN_DEBUG "%s: saving vfp state\n", __func__);
-		vfp_save_state(&ti->vfpstate, fpexc);
-
-		/* disable, just in case */
-		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+		fmxr(FPEXC, fpexc | FPEXC_EN);
+		vfp_save_state(last_VFP_context[ti->cpu], fpexc);
+		last_VFP_context[ti->cpu] = NULL;
+		fmxr(FPEXC, fpexc & ~FPEXC_EN);
 	}
 
 	/* clear any information we had about last context state */
-- 
1.7.3.1

