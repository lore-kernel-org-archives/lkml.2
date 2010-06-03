Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab0FCKfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:35:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40781 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab0FCKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:35:10 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] imxfb: add flag to avoid disabling clk multiple times
Date: Thu,  3 Jun 2010 12:34:48 +0200
Message-Id: <1275561288-20661-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while the imxfb driver blanks the screen. The clock supply to the framebuffer
controller is disabled. The same callback to disable the fb is, however, also
used the remove and shutdown hooks of the imxfb platform driver. This means that
the imxfb driver can run into a WARN in clock_disable while unloading or
rebooting, if the screen is blanked previously, since the same clock will be
than eventually disabled multiple times.  This patch adds a flag to make sure
that the clock will only be disabled, if it was not already disabled before.

The remove or shutdown callbacks in the imxfb platform driver call
imxfb_disable_controller to disable the hardware,

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/video/imxfb.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 17c6b5f..6ef9817 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -35,6 +35,7 @@
 
 #include <mach/imxfb.h>
 #include <mach/hardware.h>
+#include <mach/clock.h>
 
 /*
  * Complain if VAR is out of range.
@@ -176,6 +177,7 @@ struct imxfb_info {
 
 	struct imx_fb_videomode *mode;
 	int			num_modes;
+	bool			fbclk_disabled;
 
 	void (*lcd_power)(int);
 	void (*backlight_power)(int);
@@ -466,6 +468,7 @@ static void imxfb_enable_controller(struct imxfb_info *fbi)
 	writel(RMCR_LCDC_EN, fbi->regs + LCDC_RMCR);
 
 	clk_enable(fbi->clk);
+	fbi->fbclk_disabled = 0;
 
 	if (fbi->backlight_power)
 		fbi->backlight_power(1);
@@ -482,7 +485,10 @@ static void imxfb_disable_controller(struct imxfb_info *fbi)
 	if (fbi->lcd_power)
 		fbi->lcd_power(0);
 
-	clk_disable(fbi->clk);
+	if (!fbi->fbclk_disabled) {
+		fbi->fbclk_disabled = 1;
+		clk_disable(fbi->clk);
+	}
 
 	writel(0, fbi->regs + LCDC_RMCR);
 }
@@ -863,7 +869,10 @@ static int __devexit imxfb_remove(struct platform_device *pdev)
 
 	iounmap(fbi->regs);
 	release_mem_region(res->start, resource_size(res));
-	clk_disable(fbi->clk);
+
+	if (!fbi->fbclk_disabled)
+		clk_disable(fbi->clk);
+
 	clk_put(fbi->clk);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.1

