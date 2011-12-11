Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1LKUrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:47:07 -0500
Received: from d1.icnet.pl ([212.160.220.21]:52094 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1LKUrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:47:04 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 10/10] ARM: OMAP1: ams-delta: Drop custom I/O functions
Date: Sun, 11 Dec 2011 21:12:08 +0100
Message-Id: <1323634328-856-11-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are no longer required after all drivers which used them have been
converted to the GPIO interface.

Depends on patch 9/10 "input: serio: ams-delta: Toggle keyboard power
over GPIO".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c             |   17 +++--------------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   10 ----------
 2 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 587118c..bed43b4 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -258,19 +258,6 @@ static struct gpio _latch_gpios[] __initconst = {
 	},
 };
 
-void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
-{
-	int bit;
-	u16 bitpos;
-
-	for (bit = 0; bit < ngpio; bit++) {
-		bitpos = 1 << bit;
-		if (mask & bitpos)
-			gpio_set_value(base + bit, (value & bitpos) != 0);
-	}
-}
-EXPORT_SYMBOL(ams_delta_latch_write);
-
 static struct resource ams_delta_nand_resources[] = {
 	[0] = {
 		.start	= OMAP1_MPUIO_BASE,
@@ -441,7 +428,9 @@ static void __init ams_delta_init(void)
 	omap_register_i2c_bus(1, 100, NULL, 0);
 
 	platform_add_devices(_latch_devices, ARRAY_SIZE(_latch_devices));
-	BUG_ON(gpio_request_array(_latch_gpios, ARRAY_SIZE(_latch_gpios)));
+	/* Initialize pins not used by any drivers */
+	gpio_request_array(_latch_gpios, ARRAY_SIZE(_latch_gpios));
+	gpio_free_array(_latch_gpios, ARRAY_SIZE(_latch_gpios));
 
 	omap1_usb_init(&ams_delta_usb_config);
 	omap1_set_camera_info(&ams_delta_camera_platform_data);
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index 004c827..b09b69d 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -28,9 +28,6 @@
 
 #if defined (CONFIG_MACH_AMS_DELTA)
 
-#define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
-#define AMD_DELTA_LATCH2_SCARD_CMDVCC	0x0800
-
 #define AMS_DELTA_GPIO_PIN_KEYBRD_DATA	0
 #define AMS_DELTA_GPIO_PIN_KEYBRD_CLK	1
 #define AMS_DELTA_GPIO_PIN_MODEM_IRQ	2
@@ -58,13 +55,6 @@
 #define AMS_DELTA_LATCH2_GPIO_BASE	AMS_DELTA_GPIO_PIN_LCD_VBLEN
 #define AMS_DELTA_LATCH2_NGPIO		16
 
-#ifndef __ASSEMBLY__
-void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value);
-#endif
-#define ams_delta_latch2_write(mask, value) \
-	ams_delta_latch_write(AMS_DELTA_LATCH2_GPIO_BASE, \
-			AMS_DELTA_LATCH2_NGPIO, (mask), (value))
-
 #endif /* CONFIG_MACH_AMS_DELTA */
 
 #endif /* __ASM_ARCH_OMAP_AMS_DELTA_H */
-- 
1.7.3.4

