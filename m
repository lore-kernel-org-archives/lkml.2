Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0DOBlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:41:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab0DOBlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:41:21 -0400
From: Mike Chan <mike@android.com>
Cc: khilman@deeprootsystems.com, tony@atomide.com, paul@pwsan.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Mike Chan <mike@android.com>
Subject: [PATCH 1/2] omap: pm34xx: Enable IO / IO-CHAIN wakeups for PER
Date: Wed, 14 Apr 2010 18:41:04 -0700
Message-Id: <1271295665-26187-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO events can also come from GPIO modules, which reside in the PER domain.
It is possible for the PER to enter RET while CORE is still in ON.
If GPIO 2-6 are enabled for IO-pad wakeups, the PER domain will not
wakeup in this case, unless we enable it.

Signed-off-by: Mike Chan <mike@android.com>
---
 arch/arm/mach-omap2/pm34xx.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index ea0000b..4ef322a 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -398,10 +398,15 @@ void omap_sram_idle(void)
 			omap3_core_save_context();
 			omap3_prcm_save_context();
 		}
-		/* Enable IO-PAD and IO-CHAIN wakeups */
+	}
+
+	/* Enable IO-PAD and IO-CHAIN wakeups */
+	if (per_next_state < PWRDM_POWER_ON ||
+			core_next_state < PWRDM_POWER_ON) {
 		prm_set_mod_reg_bits(OMAP3430_EN_IO, WKUP_MOD, PM_WKEN);
 		omap3_enable_io_chain();
 	}
+
 	omap3_intc_prepare_idle();
 
 	/*
@@ -463,7 +468,8 @@ void omap_sram_idle(void)
 	}
 
 	/* Disable IO-PAD and IO-CHAIN wakeup */
-	if (core_next_state < PWRDM_POWER_ON) {
+	if (per_next_state < PWRDM_POWER_ON ||
+			core_next_state < PWRDM_POWER_ON) {
 		prm_clear_mod_reg_bits(OMAP3430_EN_IO, WKUP_MOD, PM_WKEN);
 		omap3_disable_io_chain();
 	}
-- 
1.7.0.1

