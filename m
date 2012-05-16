Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966162Ab2EPCj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:39:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47314 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab2EPCjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:39:55 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v4 4/7] ARM: imx: Enable imx53 low power idle
Date: Tue, 15 May 2012 21:33:33 -0500
Message-Id: <1337135616-8988-5-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add various functionality needed to enable a imx53 low power idle
state.  This includes adding the imx53 gpc_dvfs clock and making a
common imx5_late_init function and initializing all imx53
 MACHINE_STATE late_init calls to imx5_late_init.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/clock-mx51-mx53.c     |    1 +
 arch/arm/mach-imx/imx53-dt.c            |    1 +
 arch/arm/mach-imx/mach-mx53_ard.c       |    1 +
 arch/arm/mach-imx/mach-mx53_evk.c       |    1 +
 arch/arm/mach-imx/mach-mx53_loco.c      |    1 +
 arch/arm/mach-imx/mach-mx53_smd.c       |    1 +
 arch/arm/mach-imx/mm-imx5.c             |    7 ++++++-
 arch/arm/plat-mxc/include/mach/common.h |    1 +
 8 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clock-mx51-mx53.c b/arch/arm/mach-imx/clock-mx51-mx53.c
index 0847050..decedc6 100644
--- a/arch/arm/mach-imx/clock-mx51-mx53.c
+++ b/arch/arm/mach-imx/clock-mx51-mx53.c
@@ -1529,6 +1529,7 @@ static struct clk_lookup mx53_lookups[] = {
 	_REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)
 	_REGISTER_CLOCK("imx-ssi.2", NULL, ssi3_clk)
 	_REGISTER_CLOCK("imx-keypad", NULL, dummy_clk)
+	_REGISTER_CLOCK(NULL, "gpc_dvfs", gpc_dvfs_clk)
 	_REGISTER_CLOCK("pata_imx", NULL, pata_clk)
 	_REGISTER_CLOCK("imx53-ahci.0", "ahci", sata_clk)
 	_REGISTER_CLOCK("imx53-ahci.0", "ahci_phy", ahci_phy_clk)
diff --git a/arch/arm/mach-imx/imx53-dt.c b/arch/arm/mach-imx/imx53-dt.c
index 4172279..39d2ca7 100644
--- a/arch/arm/mach-imx/imx53-dt.c
+++ b/arch/arm/mach-imx/imx53-dt.c
@@ -125,6 +125,7 @@ DT_MACHINE_START(IMX53_DT, "Freescale i.MX53 (Device Tree Support)")
 	.handle_irq	= imx53_handle_irq,
 	.timer		= &imx53_timer,
 	.init_machine	= imx53_dt_init,
+	.init_late	= imx5_init_late,
 	.dt_compat	= imx53_dt_board_compat,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_ard.c b/arch/arm/mach-imx/mach-mx53_ard.c
index 0564198..afb3d14 100644
--- a/arch/arm/mach-imx/mach-mx53_ard.c
+++ b/arch/arm/mach-imx/mach-mx53_ard.c
@@ -266,5 +266,6 @@ MACHINE_START(MX53_ARD, "Freescale MX53 ARD Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_ard_timer,
 	.init_machine = mx53_ard_board_init,
+	.init_late	= imx5_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_evk.c b/arch/arm/mach-imx/mach-mx53_evk.c
index 5a72188..929969f 100644
--- a/arch/arm/mach-imx/mach-mx53_evk.c
+++ b/arch/arm/mach-imx/mach-mx53_evk.c
@@ -174,5 +174,6 @@ MACHINE_START(MX53_EVK, "Freescale MX53 EVK Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_evk_timer,
 	.init_machine = mx53_evk_board_init,
+	.init_late	= imx5_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_loco.c b/arch/arm/mach-imx/mach-mx53_loco.c
index 37f67ca..bc5012b 100644
--- a/arch/arm/mach-imx/mach-mx53_loco.c
+++ b/arch/arm/mach-imx/mach-mx53_loco.c
@@ -316,5 +316,6 @@ MACHINE_START(MX53_LOCO, "Freescale MX53 LOCO Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_loco_timer,
 	.init_machine = mx53_loco_board_init,
+	.init_late	= imx5_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_smd.c b/arch/arm/mach-imx/mach-mx53_smd.c
index 8e972c5..568190b 100644
--- a/arch/arm/mach-imx/mach-mx53_smd.c
+++ b/arch/arm/mach-imx/mach-mx53_smd.c
@@ -163,5 +163,6 @@ MACHINE_START(MX53_SMD, "Freescale MX53 SMD Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_smd_timer,
 	.init_machine = mx53_smd_board_init,
+	.init_late	= imx5_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index bb38747..7740739 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -216,8 +216,13 @@ void __init imx53_soc_init(void)
 					ARRAY_SIZE(imx53_audmux_res));
 }
 
+void __init imx5_init_late(void)
+{
+	imx5_pm_init();
+}
+
 void __init imx51_init_late(void)
 {
 	mx51_neon_fixup();
-	imx5_pm_init();
+	imx5_init_late();
 }
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 5660e1e..6d2e910 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -54,6 +54,7 @@ extern void imx50_soc_init(void);
 extern void imx51_soc_init(void);
 extern void imx53_soc_init(void);
 extern void imx51_init_late(void);
+extern void imx5_init_late(void);
 extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
 extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
 extern int mx1_clocks_init(unsigned long fref);
-- 
1.7.10

