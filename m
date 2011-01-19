Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1ASITk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:19:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1ASITi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:19:38 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com
Subject: [PATCHv4 3/4] OMAP3: Devkit8000: Check return value of gpio_request
Date: Wed, 19 Jan 2011 09:19:25 +0100
Message-Id: <1295425166-25540-4-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295425166-25540-1-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:rCKK8RVbFSBC0+1XMmoIU5Rc2Hjh9fh4hc7/4BuhIzy
 0GXtBReUxrZQbASrWQhpxQyp3MarWAUBMEnGn6AVU0z8mweXgi
 N5VC5OjXy1fjrfhmuThGEEuEUIjPfnD5b4h+eZTqQm53AyMp+V
 zFvAFlurZ1tayqvHxptuhBiHKjQtg5v1aBTuuniBiEnKk0XKIM
 FDWallbo2kqYRNeYniOLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of gpio_request is ignored.
This patch adds the check of the return value of gpio_request.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 9fb416b..4ddd81c 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -234,6 +234,8 @@ static struct gpio_led gpio_leds[];
 static int devkit8000_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
+	int ret;
+
 	omap_mux_init_gpio(29, OMAP_PIN_INPUT);
 	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
 	mmc[0].gpio_cd = gpio + 0;
@@ -244,13 +246,23 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 
 	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
 	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
-	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
+	ret = gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
+	if (ret < 0) {
+		printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
+		return ret;
+	}
+
 	/* Disable until needed */
 	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
 
 	/* gpio + 7 is "DVI_PD" (out, active low) */
 	devkit8000_dvi_device.reset_gpio = gpio + 7;
-	gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
+	ret = gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
+	if (ret < 0) {
+		printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
+		return ret;
+	}
+
 	/* Disable until needed */
 	gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
 
-- 
1.7.4.rc2

