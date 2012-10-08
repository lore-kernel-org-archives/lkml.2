Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2JHWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:24:14 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:38656 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2JHWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:24:10 -0400
From: Fabio Estevam <festevam@gmail.com>
To: kernel@pengutronix.de
Cc: FlorianSchandinat@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] video: imxfb: Do not crash on reboot
Date: Mon,  8 Oct 2012 19:23:58 -0300
Message-Id: <1349735038-19196-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Issuing a "reboot" command after the LCD times out causes the following
warnings:

Requesting system reboot
------------[ cut here ]------------
WARNING: at drivers/clk/clk.c:471 clk_disable+0x24/0x50()
Modules linked in:
[<c001ad90>] (unwind_backtrace+0x0/0xf4) from [<c0025aac>] (warn_slowpath_common+0x48/0x60)
[<c0025aac>] (warn_slowpath_common+0x48/0x60) from [<c0025ae0>] (warn_slowpath_null+0x1c/0x24)
[<c0025ae0>] (warn_slowpath_null+0x1c/0x24) from [<c03960a0>] (clk_disable+0x24/0x50)
[<c03960a0>] (clk_disable+0x24/0x50) from [<c02695a0>] (imxfb_disable_controller+0x48/0x7c)
[<c02695a0>] (imxfb_disable_controller+0x48/0x7c) from [<c029d838>] (platform_drv_shutdown+0x18/0x1c)
[<c029d838>] (platform_drv_shutdown+0x18/0x1c) from [<c02990fc>] (device_shutdown+0x48/0x14c)
[<c02990fc>] (device_shutdown+0x48/0x14c) from [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c)
[<c003d09c>] (kernel_restart_prepare+0x2c/0x3c) from [<c003d0e4>] (kernel_restart+0xc/0x48)
[<c003d0e4>] (kernel_restart+0xc/0x48) from [<c003d1e8>] (sys_reboot+0xc0/0x1bc)
[<c003d1e8>] (sys_reboot+0xc0/0x1bc) from [<c0014ca0>] (ret_fast_syscall+0x0/0x2c)
---[ end trace da6b502ca79c854f ]---
------------[ cut here ]------------
WARNING: at drivers/clk/clk.c:380 clk_unprepare+0x1c/0x2c()
Modules linked in:
[<c001ad90>] (unwind_backtrace+0x0/0xf4) from [<c0025aac>] (warn_slowpath_common+0x48/0x60)
[<c0025aac>] (warn_slowpath_common+0x48/0x60) from [<c0025ae0>] (warn_slowpath_null+0x1c/0x24)
[<c0025ae0>] (warn_slowpath_null+0x1c/0x24) from [<c0396338>] (clk_unprepare+0x1c/0x2c)
[<c0396338>] (clk_unprepare+0x1c/0x2c) from [<c02695a8>] (imxfb_disable_controller+0x50/0x7c)
[<c02695a8>] (imxfb_disable_controller+0x50/0x7c) from [<c029d838>] (platform_drv_shutdown+0x18/0x1c)
[<c029d838>] (platform_drv_shutdown+0x18/0x1c) from [<c02990fc>] (device_shutdown+0x48/0x14c)
[<c02990fc>] (device_shutdown+0x48/0x14c) from [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c)
[<c003d09c>] (kernel_restart_prepare+0x2c/0x3c) from [<c003d0e4>] (kernel_restart+0xc/0x48)
[<c003d0e4>] (kernel_restart+0xc/0x48) from [<c003d1e8>] (sys_reboot+0xc0/0x1bc)
[<c003d1e8>] (sys_reboot+0xc0/0x1bc) from [<c0014ca0>] (ret_fast_syscall+0x0/0x2c)
---[ end trace da6b502ca79c8550 ]---
------------[ cut here ]------------

This happens because "reboot" triggers imxfb_shutdown(), which calls
imxfb_disable_controller with the clocks already disabled.

To prevent this, add a clock enabled status so that we can check if the clocks
are enabled before disabling them. 

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Protect the whole function instead of only the clocks
 drivers/video/imxfb.c |   63 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index cf2688d..32c71e5 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -134,6 +134,7 @@ struct imxfb_info {
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
 	struct clk		*clk_per;
+	int			enabled;
 
 	/*
 	 * These are the addresses we mapped
@@ -513,47 +514,53 @@ static void imxfb_exit_backlight(struct imxfb_info *fbi)
 
 static void imxfb_enable_controller(struct imxfb_info *fbi)
 {
-	pr_debug("Enabling LCD controller\n");
+	if (!fbi->enabled) {
+		pr_debug("Enabling LCD controller\n");
 
-	writel(fbi->screen_dma, fbi->regs + LCDC_SSA);
+		writel(fbi->screen_dma, fbi->regs + LCDC_SSA);
 
-	/* panning offset 0 (0 pixel offset)        */
-	writel(0x00000000, fbi->regs + LCDC_POS);
+		/* panning offset 0 (0 pixel offset)        */
+		writel(0x00000000, fbi->regs + LCDC_POS);
 
-	/* disable hardware cursor */
-	writel(readl(fbi->regs + LCDC_CPOS) & ~(CPOS_CC0 | CPOS_CC1),
-		fbi->regs + LCDC_CPOS);
+		/* disable hardware cursor */
+		writel(readl(fbi->regs + LCDC_CPOS) & ~(CPOS_CC0 | CPOS_CC1),
+						fbi->regs + LCDC_CPOS);
 
-	/*
-	 * RMCR_LCDC_EN_MX1 is present on i.MX1 only, but doesn't hurt
-	 * on other SoCs
-	 */
-	writel(RMCR_LCDC_EN_MX1, fbi->regs + LCDC_RMCR);
+		/*
+		 * RMCR_LCDC_EN_MX1 is present on i.MX1 only, but doesn't hurt
+		 * on other SoCs
+		 */
+		writel(RMCR_LCDC_EN_MX1, fbi->regs + LCDC_RMCR);
 
-	clk_prepare_enable(fbi->clk_ipg);
-	clk_prepare_enable(fbi->clk_ahb);
-	clk_prepare_enable(fbi->clk_per);
+		clk_prepare_enable(fbi->clk_ipg);
+		clk_prepare_enable(fbi->clk_ahb);
+		clk_prepare_enable(fbi->clk_per);
+		fbi->enabled = 1;
 
-	if (fbi->backlight_power)
-		fbi->backlight_power(1);
-	if (fbi->lcd_power)
-		fbi->lcd_power(1);
+		if (fbi->backlight_power)
+			fbi->backlight_power(1);
+		if (fbi->lcd_power)
+			fbi->lcd_power(1);
+	}
 }
 
 static void imxfb_disable_controller(struct imxfb_info *fbi)
 {
-	pr_debug("Disabling LCD controller\n");
+	if (fbi->enabled) {
+		pr_debug("Disabling LCD controller\n");
 
-	if (fbi->backlight_power)
-		fbi->backlight_power(0);
-	if (fbi->lcd_power)
-		fbi->lcd_power(0);
+		if (fbi->backlight_power)
+			fbi->backlight_power(0);
+		if (fbi->lcd_power)
+			fbi->lcd_power(0);
 
-	clk_disable_unprepare(fbi->clk_per);
-	clk_disable_unprepare(fbi->clk_ipg);
-	clk_disable_unprepare(fbi->clk_ahb);
+		clk_disable_unprepare(fbi->clk_per);
+		clk_disable_unprepare(fbi->clk_ipg);
+		clk_disable_unprepare(fbi->clk_ahb);
+		fbi->enabled = 0;
 
-	writel(0, fbi->regs + LCDC_RMCR);
+		writel(0, fbi->regs + LCDC_RMCR);
+	}
 }
 
 static int imxfb_blank(int blank, struct fb_info *info)
-- 
1.7.9.5

