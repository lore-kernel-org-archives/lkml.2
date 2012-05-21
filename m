Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2EUWut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:50:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60928 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2EUWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:50:45 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v5 4/7] ARM: imx: Enable imx53 low power idle
Date: Mon, 21 May 2012 17:50:27 -0500
Message-Id: <1337640630-29176-5-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
References: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add various functionality needed to enable a imx53 low power idle
state.  This includes adding the imx53 gpc_dvfs clock and making a
common imx5_late_init function and initializing all imx53
 MACHINE_STATE late_init calls to imx5_late_init.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/clk-imx51-imx53.c     |    2 +-
 arch/arm/mach-imx/clock-mx51-mx53.c     |    1 +
 arch/arm/mach-imx/imx53-dt.c            |    1 +
 arch/arm/mach-imx/mach-mx53_ard.c       |    1 +
 arch/arm/mach-imx/mach-mx53_evk.c       |    1 +
 arch/arm/mach-imx/mach-mx53_loco.c      |    1 +
 arch/arm/mach-imx/mach-mx53_smd.c       |    1 +
 arch/arm/mach-imx/mm-imx5.c             |    5 +++++
 arch/arm/mach-imx/pm-imx5.c             |    5 +++++
 arch/arm/plat-mxc/include/mach/common.h |    3 +++
 10 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index 66633d5..834a87d 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -245,6 +245,7 @@ static void __init mx5_clocks_common_init(unsigned long rate_ckil,
 	clk_register_clkdev(clk[dummy], NULL, "imx-keypad");
 	clk_register_clkdev(clk[tve_gate], NULL, "imx-tve.0");
 	clk_register_clkdev(clk[ipu_di1_gate], "di1", "imx-tve.0");
+	clk_register_clkdev(clk[gpc_dvfs], "gpc_dvfs", NULL);
 
 	/* Set SDHC parents to be PLL2 */
 	clk_set_parent(clk[esdhc_a_sel], clk[pll2_sw]);
@@ -302,7 +303,6 @@ int __init mx51_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 	clk_register_clkdev(clk[mx51_mipi], "mipi_hsp", NULL);
 	clk_register_clkdev(clk[vpu_gate], NULL, "imx51-vpu.0");
 	clk_register_clkdev(clk[fec_gate], NULL, "imx27-fec.0");
-	clk_register_clkdev(clk[gpc_dvfs], "gpc_dvfs", NULL);
 	clk_register_clkdev(clk[ipu_gate], "bus", "imx51-ipu");
 	clk_register_clkdev(clk[ipu_di0_gate], "di0", "imx51-ipu");
 	clk_register_clkdev(clk[ipu_di1_gate], "di1", "imx51-ipu");
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
index 4172279..c502619 100644
--- a/arch/arm/mach-imx/imx53-dt.c
+++ b/arch/arm/mach-imx/imx53-dt.c
@@ -125,6 +125,7 @@ DT_MACHINE_START(IMX53_DT, "Freescale i.MX53 (Device Tree Support)")
 	.handle_irq	= imx53_handle_irq,
 	.timer		= &imx53_timer,
 	.init_machine	= imx53_dt_init,
+	.init_late	= imx53_init_late,
 	.dt_compat	= imx53_dt_board_compat,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_ard.c b/arch/arm/mach-imx/mach-mx53_ard.c
index 0564198..f1e83d6 100644
--- a/arch/arm/mach-imx/mach-mx53_ard.c
+++ b/arch/arm/mach-imx/mach-mx53_ard.c
@@ -266,5 +266,6 @@ MACHINE_START(MX53_ARD, "Freescale MX53 ARD Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_ard_timer,
 	.init_machine = mx53_ard_board_init,
+	.init_late	= imx53_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_evk.c b/arch/arm/mach-imx/mach-mx53_evk.c
index 5a72188..8387496 100644
--- a/arch/arm/mach-imx/mach-mx53_evk.c
+++ b/arch/arm/mach-imx/mach-mx53_evk.c
@@ -174,5 +174,6 @@ MACHINE_START(MX53_EVK, "Freescale MX53 EVK Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_evk_timer,
 	.init_machine = mx53_evk_board_init,
+	.init_late	= imx53_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_loco.c b/arch/arm/mach-imx/mach-mx53_loco.c
index 37f67ca..e266f3f 100644
--- a/arch/arm/mach-imx/mach-mx53_loco.c
+++ b/arch/arm/mach-imx/mach-mx53_loco.c
@@ -316,5 +316,6 @@ MACHINE_START(MX53_LOCO, "Freescale MX53 LOCO Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_loco_timer,
 	.init_machine = mx53_loco_board_init,
+	.init_late	= imx53_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mach-mx53_smd.c b/arch/arm/mach-imx/mach-mx53_smd.c
index 8e972c5..4f4c1b9 100644
--- a/arch/arm/mach-imx/mach-mx53_smd.c
+++ b/arch/arm/mach-imx/mach-mx53_smd.c
@@ -163,5 +163,6 @@ MACHINE_START(MX53_SMD, "Freescale MX53 SMD Board")
 	.handle_irq = imx53_handle_irq,
 	.timer = &mx53_smd_timer,
 	.init_machine = mx53_smd_board_init,
+	.init_late	= imx53_init_late,
 	.restart	= mxc_restart,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
index ff7fa61..85bc52a 100644
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@ -221,3 +221,8 @@ void __init imx51_init_late(void)
 	mx51_neon_fixup();
 	imx51_pm_init();
 }
+
+void __init imx53_init_late(void)
+{
+	imx53_pm_init();
+}
diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index baf9321..b3dcd8e 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -166,3 +166,8 @@ void __init imx51_pm_init(void)
 	if (!ret)
 		suspend_set_ops(&mx5_suspend_ops);
 }
+
+void __init imx53_pm_init(void)
+{
+	imx5_pm_common_init();
+}
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index f65d068..3314e69 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -54,6 +54,7 @@ extern void imx50_soc_init(void);
 extern void imx51_soc_init(void);
 extern void imx53_soc_init(void);
 extern void imx51_init_late(void);
+extern void imx53_init_late(void);
 extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
 extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
 extern int mx1_clocks_init(unsigned long fref);
@@ -146,9 +147,11 @@ extern void imx6q_clock_map_io(void);
 #ifdef CONFIG_PM
 extern void imx6q_pm_init(void);
 extern void imx51_pm_init(void);
+extern void imx53_pm_init(void);
 #else
 static inline void imx6q_pm_init(void) {}
 static inline void imx51_pm_init(void) {}
+static inline void imx53_pm_init(void) {}
 #endif
 
 #ifdef CONFIG_NEON
-- 
1.7.10

