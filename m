Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JHNgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:36:07 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:11430
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab2JHNgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:36:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <kernel@pengutronix.de>
CC: <FlorianSchandinat@gmx.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] video: imxfb: Do not crash on reboot
Date: Mon, 8 Oct 2012 10:35:36 -0300
Message-ID: <1349703336-8105-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/video/imxfb.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index f3363b2..6acf98a 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -134,6 +134,7 @@ struct imxfb_info {
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
 	struct clk		*clk_per;
+	int			enabled;
 
 	/*
 	 * These are the addresses we mapped
@@ -530,9 +531,12 @@ static void imxfb_enable_controller(struct imxfb_info *fbi)
 	 */
 	writel(RMCR_LCDC_EN_MX1, fbi->regs + LCDC_RMCR);
 
-	clk_prepare_enable(fbi->clk_ipg);
-	clk_prepare_enable(fbi->clk_ahb);
-	clk_prepare_enable(fbi->clk_per);
+	if (!fbi->enabled) {
+		clk_prepare_enable(fbi->clk_ipg);
+		clk_prepare_enable(fbi->clk_ahb);
+		clk_prepare_enable(fbi->clk_per);
+		fbi->enabled = 1;
+	}
 
 	if (fbi->backlight_power)
 		fbi->backlight_power(1);
@@ -551,9 +555,12 @@ static void imxfb_disable_controller(struct imxfb_info *fbi)
 
 	writel(0, fbi->regs + LCDC_RMCR);
 
-	clk_disable_unprepare(fbi->clk_per);
-	clk_disable_unprepare(fbi->clk_ipg);
-	clk_disable_unprepare(fbi->clk_ahb);
+	if (fbi->enabled) {
+		clk_disable_unprepare(fbi->clk_per);
+		clk_disable_unprepare(fbi->clk_ipg);
+		clk_disable_unprepare(fbi->clk_ahb);
+		fbi->enabled = 0;
+	}
 }
 
 static int imxfb_blank(int blank, struct fb_info *info)
-- 
1.7.9.5


