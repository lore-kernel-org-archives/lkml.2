Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1BGBvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:51:00 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1122 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754354Ab1BGBuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 08/09] ARM: s3c2440: gta02: Request usb pullup pin before using it
Date: Mon,  7 Feb 2011 02:52:00 +0100
Message-Id: <1297043521-21903-8-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request the gpio pin used to control the usb pullup before using it to avoid a
runtime warning about an auto-requested gpio.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 1396639..94456fa 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -451,11 +451,11 @@ static void gta02_udc_command(enum s3c2410_udc_cmd_e cmd)
 	switch (cmd) {
 	case S3C2410_UDC_P_ENABLE:
 		pr_debug("%s S3C2410_UDC_P_ENABLE\n", __func__);
-		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
+		gpio_set_value(GTA02_GPIO_USB_PULLUP, 1);
 		break;
 	case S3C2410_UDC_P_DISABLE:
 		pr_debug("%s S3C2410_UDC_P_DISABLE\n", __func__);
-		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 0);
+		gpio_set_value(GTA02_GPIO_USB_PULLUP, 0);
 		break;
 	case S3C2410_UDC_P_RESET:
 		pr_debug("%s S3C2410_UDC_P_RESET\n", __func__);
@@ -572,11 +572,24 @@ static void gta02_poweroff(void)
 	pcf50633_reg_set_bit_mask(gta02_pcf, PCF50633_REG_OOCSHDWN, 1, 1);
 }
 
+static void gta02_request_gpios(void)
+{
+	int ret;
+	ret = gpio_request_one(GTA02_GPIO_USB_PULLUP, GPIOF_OUT_INIT_LOW,
+				"USB pullup");
+	if (ret) {
+		printk(KERN_ERR "Failed to request USB pullup gpio pin: %d\n",
+			ret);
+	}
+}
+
 static void __init gta02_machine_init(void)
 {
 	/* Set the panic callback to turn AUX LED on or off. */
 	panic_blink = gta02_panic_blink;
 
+	gta02_request_gpios();
+
 	s3c_pm_init();
 
 #ifdef CONFIG_CHARGER_PCF50633
-- 
1.7.2.3

