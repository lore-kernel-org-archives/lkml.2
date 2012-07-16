Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2GPSRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:17:33 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49824 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2GPSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:17:31 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, Barry Song <bs14@csr.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Ido Yariv <ido@wizery.com>,
        Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v6] ARM: vfp: Always save VFP state in vfp_pm_suspend on UP
Date: Mon, 16 Jul 2012 11:17:20 -0700
Message-Id: <1342462640-18410-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfp_pm_suspend should save the VFP state in suspend after
any lazy context switch.  If it only saves when the VFP is enabled,
the state can get lost when, on a UP system:
  Thread 1 uses the VFP
  Context switch occurs to thread 2, VFP is disabled but the
     VFP context is not saved
  Thread 2 initiates suspend
  vfp_pm_suspend is called with the VFP disabled, and the unsaved
     VFP context of Thread 1 in the registers

Modify vfp_pm_suspend to save the VFP context whenever
vfp_current_hw_state is not NULL.

Includes a fix from Ido Yariv <ido@wizery.com>, who pointed out that on
SMP systems, the state pointer can be pointing to a freed task struct if
a task exited on another cpu, fixed by using #ifdef CONFIG_SMP in the
new if clause.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Barry Song <bs14@csr.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ido Yariv <ido@wizery.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 58696192..ce55f05 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -457,6 +457,12 @@ static int vfp_pm_suspend(void)
 
 		/* disable, just in case */
 		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+	} else if (vfp_current_hw_state[ti->cpu]) {
+#ifndef CONFIG_SMP
+		fmxr(FPEXC, fpexc | FPEXC_EN);
+		vfp_save_state(vfp_current_hw_state[ti->cpu], fpexc);
+		fmxr(FPEXC, fpexc);
+#endif
 	}
 
 	/* clear any information we had about last context state */
-- 
1.7.7.3

