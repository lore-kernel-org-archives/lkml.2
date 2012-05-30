Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2E3LNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:13:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61919 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2E3LNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:13:24 -0400
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] Visstrim M10: fix gpio handling.
Date: Wed, 30 May 2012 13:13:09 +0200
Message-Id: <1338376389-32256-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some GPIOs in Visstrim M10 are used without being registered.
This leads to USB and video malfunctions. This patch registers
those GPIOs to solve the issue.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index e8741f9..db4aa6f 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -116,6 +116,8 @@ static const int visstrim_m10_pins[] __initconst = {
 	PB23_PF_USB_PWR,
 	PB24_PF_USB_OC,
 	/* CSI */
+	TVP5150_RSTN | GPIO_GPIO | GPIO_OUT,
+	TVP5150_PWDN | GPIO_GPIO | GPIO_OUT,
 	PB10_PF_CSI_D0,
 	PB11_PF_CSI_D1,
 	PB12_PF_CSI_D2,
@@ -182,10 +184,10 @@ static void __init visstrim_camera_init(void)
 	int dma;
 
 	/* Initialize tvp5150 gpios */
-	mxc_gpio_mode(TVP5150_RSTN | GPIO_GPIO | GPIO_OUT);
-	mxc_gpio_mode(TVP5150_PWDN | GPIO_GPIO | GPIO_OUT);
-	gpio_set_value(TVP5150_RSTN, 1);
-	gpio_set_value(TVP5150_PWDN, 0);
+	gpio_request_one(TVP5150_RSTN, GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
+			 "tvp5150_rstn");
+	gpio_request_one(TVP5150_PWDN, GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+			 "tvp5150_pwdn");
 	ndelay(1);
 
 	gpio_set_value(TVP5150_PWDN, 1);
@@ -414,7 +416,8 @@ static struct i2c_board_info visstrim_m10_i2c_devices[] = {
 /* USB OTG */
 static int otg_phy_init(struct platform_device *pdev)
 {
-	gpio_set_value(OTG_PHY_CS_GPIO, 0);
+	gpio_request_one(OTG_PHY_CS_GPIO, GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+			 "usbotg_cs");
 
 	mdelay(10);
 
-- 
1.7.0.4

