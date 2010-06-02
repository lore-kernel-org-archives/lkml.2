Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0FBLis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:38:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab0FBLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:46 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Kan-Ru Chen <kanru@0xlab.org>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 03/11] OMAP2: Devkit8000: Enable DVI-D output
Date: Wed,  2 Jun 2010 13:37:43 +0200
Message-Id: <1275478671-24563-4-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX1/F7/19MGHlJjt3vHdLENTQrUTKjHua+Czlq5T
 X/4GPRyUt+U3x9CmwTg+gYSQBGAqpP0lfTmE94LhCjUXc2koDl
 SFclrhXTFFtlQkBH0hLkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan-Ru Chen <kanru@0xlab.org>

This patch corrects the DVI-D output setup of Devkit8000

Devkit8000 has different DVI reset pin with the BeagleBoard.
On Devkit8000 the TWL4030 GPIO_7 is assigned to do the job.

Signed-off-by: Kan-Ru Chen <kanru@0xlab.org>
---
 arch/arm/mach-omap2/board-devkit8000.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 3bde0e6..17a2517 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -140,13 +140,18 @@ static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 static void devkit8000_panel_disable_lcd(struct omap_dss_device *dssdev)
 {
 }
+
 static int devkit8000_panel_enable_dvi(struct omap_dss_device *dssdev)
 {
+	if (dssdev->reset_gpio != -EINVAL)
+		gpio_set_value(dssdev->reset_gpio, 1);
 	return 0;
 }
 
 static void devkit8000_panel_disable_dvi(struct omap_dss_device *dssdev)
 {
+	if (dssdev->reset_gpio != -EINVAL)
+		gpio_set_value(dssdev->reset_gpio, 0);
 }
 
 static int devkit8000_panel_enable_tv(struct omap_dss_device *dssdev)
@@ -186,6 +191,7 @@ static struct omap_dss_device devkit8000_dvi_device = {
 	.driver_name            = "generic_panel",
 	.type                   = OMAP_DISPLAY_TYPE_DPI,
 	.phy.dpi.data_lines     = 24,
+	.reset_gpio             = -EINVAL, /* will be replaced */
 	.platform_enable        = devkit8000_panel_enable_dvi,
 	.platform_disable       = devkit8000_panel_disable_dvi,
 };
@@ -272,6 +278,15 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 	devkit8000_vmmc1_supply.dev = mmc[0].dev;
 	devkit8000_vsim_supply.dev = mmc[0].dev;
 
+	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
+	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
+
+	/* gpio + 7 is "DVI_PD" (out, active low) */
+	devkit8000_dvi_device.reset_gpio = gpio + 7;
+	gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
+	/* Disable until needed */
+	gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
+
 	return 0;
 }
 
-- 
1.7.1

