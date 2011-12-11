Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1LKUNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:13:19 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48143 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1LKUNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:13:16 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 02/10] ARM: OMAP1: ams-delta: Convert latches to basic_mmio_gpio
Date: Sun, 11 Dec 2011 21:12:00 +0100
Message-Id: <1323634328-856-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once done, ams-delta specific device drivers currently calling custom
ams_delta_latch[12]_write() functions can call generic gpio_set_value()
instead, which will make them less platform dependent. Even more, some
custom ams-delta only drivers perhaps can be dropped from the tree after
converting selected ams-delta platform devices to follow generic GPIO
based device models.

Created against linux-3.2-rc5.
Requires patch 1/10 "GPIO: gpio-generic: Move initialization up to
postcore" to work correctly.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/Kconfig                       |    1 +
 arch/arm/mach-omap1/board-ams-delta.c             |  235 ++++++++++++++++++---
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   43 +++-
 3 files changed, 241 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 73f287d..1b5f283 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -154,6 +154,7 @@ config MACH_NOKIA770
 config MACH_AMS_DELTA
 	bool "Amstrad E3 (Delta)"
 	depends on ARCH_OMAP1 && ARCH_OMAP15XX
+	select GPIO_GENERIC_PLATFORM
 	select FIQ
 	help
 	  Support for the Amstrad E3 (codename Delta) videophone. Say Y here
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index b0f15d2..d88419e 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -11,6 +11,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/basic_mmio_gpio.h>
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -40,9 +41,6 @@
 
 #include <mach/ams-delta-fiq.h>
 
-static u8 ams_delta_latch1_reg;
-static u16 ams_delta_latch2_reg;
-
 static const unsigned int ams_delta_keymap[] = {
 	KEY(0, 0, KEY_F1),		/* Advert    */
 
@@ -121,39 +119,32 @@ static const unsigned int ams_delta_keymap[] = {
 	KEY(7, 3, KEY_LEFTCTRL),	/* Vol down  */
 };
 
-void ams_delta_latch1_write(u8 mask, u8 value)
-{
-	ams_delta_latch1_reg &= ~mask;
-	ams_delta_latch1_reg |= value;
-	*(volatile __u8 *) AMS_DELTA_LATCH1_VIRT = ams_delta_latch1_reg;
-}
-
-void ams_delta_latch2_write(u16 mask, u16 value)
-{
-	ams_delta_latch2_reg &= ~mask;
-	ams_delta_latch2_reg |= value;
-	*(volatile __u16 *) AMS_DELTA_LATCH2_VIRT = ams_delta_latch2_reg;
-}
+#define _LATCH1_PHYS	0x01000000
+#define _LATCH1_VIRT	0xEA000000
+#define _MODEM_PHYS	0x04000000
+#define _MODEM_VIRT	0xEB000000
+#define _LATCH2_PHYS	0x08000000
+#define _LATCH2_VIRT	0xEC000000
 
 static struct map_desc ams_delta_io_desc[] __initdata = {
 	/* AMS_DELTA_LATCH1 */
 	{
-		.virtual	= AMS_DELTA_LATCH1_VIRT,
-		.pfn		= __phys_to_pfn(AMS_DELTA_LATCH1_PHYS),
+		.virtual	= _LATCH1_VIRT,
+		.pfn		= __phys_to_pfn(_LATCH1_PHYS),
 		.length		= 0x01000000,
 		.type		= MT_DEVICE
 	},
 	/* AMS_DELTA_LATCH2 */
 	{
-		.virtual	= AMS_DELTA_LATCH2_VIRT,
-		.pfn		= __phys_to_pfn(AMS_DELTA_LATCH2_PHYS),
+		.virtual	= _LATCH2_VIRT,
+		.pfn		= __phys_to_pfn(_LATCH2_PHYS),
 		.length		= 0x01000000,
 		.type		= MT_DEVICE
 	},
 	/* AMS_DELTA_MODEM */
 	{
-		.virtual	= AMS_DELTA_MODEM_VIRT,
-		.pfn		= __phys_to_pfn(AMS_DELTA_MODEM_PHYS),
+		.virtual	= _MODEM_VIRT,
+		.pfn		= __phys_to_pfn(_MODEM_PHYS),
 		.length		= 0x01000000,
 		.type		= MT_DEVICE
 	}
@@ -173,6 +164,195 @@ static struct omap_board_config_kernel ams_delta_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 };
 
+static struct resource _latch1_resources[] __initconst = {
+	[0] = {
+		.name	= "dat",
+		.start	= _LATCH1_PHYS,
+		.end	= _LATCH1_PHYS + ((AMS_DELTA_LATCH1_NGPIO - 1) / 8),
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct bgpio_pdata _latch1_pdata __initconst = {
+	.base	= AMS_DELTA_LATCH1_GPIO_BASE,
+	.ngpio	= AMS_DELTA_LATCH1_NGPIO,
+};
+
+static struct platform_device _latch1_device = {
+	.name		= "basic-mmio-gpio",
+	.id		= 0,
+	.resource	= _latch1_resources,
+	.num_resources	= ARRAY_SIZE(_latch1_resources),
+	.dev		= {
+		.platform_data	= &_latch1_pdata,
+	},
+};
+
+static struct resource _latch2_resources[] __initconst = {
+	[0] = {
+		.name	= "dat",
+		.start	= _LATCH2_PHYS,
+		.end	= _LATCH2_PHYS + ((AMS_DELTA_LATCH2_NGPIO - 1) / 8),
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct bgpio_pdata _latch2_pdata __initconst = {
+	.base	= AMS_DELTA_LATCH2_GPIO_BASE,
+	.ngpio	= AMS_DELTA_LATCH2_NGPIO,
+};
+
+static struct platform_device _latch2_device = {
+	.name		= "basic-mmio-gpio",
+	.id		= 1,
+	.resource	= _latch2_resources,
+	.num_resources	= ARRAY_SIZE(_latch2_resources),
+	.dev		= {
+		.platform_data	= &_latch2_pdata,
+	},
+};
+
+static struct platform_device *_latch_devices[] __initconst = {
+	&_latch1_device,
+	&_latch2_device,
+};
+
+static struct gpio _latch_gpios[] __initconst = {
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_CAMERA,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_camera",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_ADVERT,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_advert",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_EMAIL,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_email",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_HANDSFREE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_handsfree",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICEMAIL,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_voicemail",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LED_VOICE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "led_voice",
+	},
+	{
+		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 6,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "dockit1",
+	},
+	{
+		.gpio	= AMS_DELTA_LATCH1_GPIO_BASE + 7,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "dockit2",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LCD_VBLEN,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "lcd_vblen",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_LCD_NDISP,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "lcd_ndisp",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NCE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_nce",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NRE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_nre",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWP,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_nwp",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_NWE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_nwe",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_ALE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_ale",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_NAND_CLE,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "nand_cle",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "keybrd_pwr",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "keybrd_dataout",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_RSTIN,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "scard_rstin",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_CMDVCC,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "scard_cmdvcc",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "modem_nreset",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "modem_codec",
+	},
+	{
+		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 14,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "hookflash1",
+	},
+	{
+		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 15,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "hookflash2",
+	},
+};
+
+void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
+{
+	int bit;
+	u16 bitpos;
+
+	for (bit = 0; bit < ngpio; bit++) {
+		bitpos = 1 << bit;
+		if (mask & bitpos)
+			gpio_set_value(base + bit, (value & bitpos) != 0);
+	}
+}
+EXPORT_SYMBOL(ams_delta_latch_write);
+
 static struct resource ams_delta_nand_resources[] = {
 	[0] = {
 		.start	= OMAP1_MPUIO_BASE,
@@ -307,8 +487,8 @@ static void __init ams_delta_init(void)
 	omap_serial_init();
 	omap_register_i2c_bus(1, 100, NULL, 0);
 
-	/* Clear latch2 (NAND, LCD, modem enable) */
-	ams_delta_latch2_write(~0, 0);
+	platform_add_devices(_latch_devices, ARRAY_SIZE(_latch_devices));
+	BUG_ON(gpio_request_array(_latch_gpios, ARRAY_SIZE(_latch_gpios)));
 
 	omap1_usb_init(&ams_delta_usb_config);
 	omap1_set_camera_info(&ams_delta_camera_platform_data);
@@ -325,8 +505,8 @@ static void __init ams_delta_init(void)
 
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
 	{
-		.membase	= IOMEM(AMS_DELTA_MODEM_VIRT),
-		.mapbase	= AMS_DELTA_MODEM_PHYS,
+		.membase	= IOMEM(_MODEM_VIRT),
+		.mapbase	= _MODEM_PHYS,
 		.irq		= -EINVAL, /* changed later */
 		.flags		= UPF_BOOT_AUTOCONF,
 		.irqflags	= IRQF_TRIGGER_RISING,
@@ -387,6 +567,3 @@ MACHINE_START(AMS_DELTA, "Amstrad E3 (Delta)")
 	.init_machine	= ams_delta_init,
 	.timer		= &omap1_timer,
 MACHINE_END
-
-EXPORT_SYMBOL(ams_delta_latch1_write);
-EXPORT_SYMBOL(ams_delta_latch2_write);
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index 51b102d..1b8e759 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -28,13 +28,6 @@
 
 #if defined (CONFIG_MACH_AMS_DELTA)
 
-#define AMS_DELTA_LATCH1_PHYS		0x01000000
-#define AMS_DELTA_LATCH1_VIRT		0xEA000000
-#define AMS_DELTA_MODEM_PHYS		0x04000000
-#define AMS_DELTA_MODEM_VIRT		0xEB000000
-#define AMS_DELTA_LATCH2_PHYS		0x08000000
-#define AMS_DELTA_LATCH2_VIRT		0xEC000000
-
 #define AMS_DELTA_LATCH1_LED_CAMERA	0x01
 #define AMS_DELTA_LATCH1_LED_ADVERT	0x02
 #define AMS_DELTA_LATCH1_LED_EMAIL	0x04
@@ -66,10 +59,42 @@
 #define AMS_DELTA_GPIO_PIN_CONFIG	11
 #define AMS_DELTA_GPIO_PIN_NAND_RB	12
 
+#define AMS_DELTA_GPIO_PIN_LED_CAMERA		232
+#define AMS_DELTA_GPIO_PIN_LED_ADVERT		233
+#define AMS_DELTA_GPIO_PIN_LED_EMAIL		234
+#define AMS_DELTA_GPIO_PIN_LED_HANDSFREE	235
+#define AMS_DELTA_GPIO_PIN_LED_VOICEMAIL	236
+#define AMS_DELTA_GPIO_PIN_LED_VOICE		237
+
+#define AMS_DELTA_GPIO_PIN_LCD_VBLEN		240
+#define AMS_DELTA_GPIO_PIN_LCD_NDISP		241
+#define AMS_DELTA_GPIO_PIN_NAND_NCE		242
+#define AMS_DELTA_GPIO_PIN_NAND_NRE		243
+#define AMS_DELTA_GPIO_PIN_NAND_NWP		244
+#define AMS_DELTA_GPIO_PIN_NAND_NWE		245
+#define AMS_DELTA_GPIO_PIN_NAND_ALE		246
+#define AMS_DELTA_GPIO_PIN_NAND_CLE		247
+#define AMS_DELTA_GPIO_PIN_KEYBRD_PWR		248
+#define AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT	249
+#define AMS_DELTA_GPIO_PIN_SCARD_RSTIN		250
+#define AMS_DELTA_GPIO_PIN_SCARD_CMDVCC		251
+#define AMS_DELTA_GPIO_PIN_MODEM_NRESET		252
+#define AMS_DELTA_GPIO_PIN_MODEM_CODEC		253
+
+#define AMS_DELTA_LATCH1_GPIO_BASE	AMS_DELTA_GPIO_PIN_LED_CAMERA
+#define AMS_DELTA_LATCH1_NGPIO		8
+#define AMS_DELTA_LATCH2_GPIO_BASE	AMS_DELTA_GPIO_PIN_LCD_VBLEN
+#define AMS_DELTA_LATCH2_NGPIO		16
+
 #ifndef __ASSEMBLY__
-void ams_delta_latch1_write(u8 mask, u8 value);
-void ams_delta_latch2_write(u16 mask, u16 value);
+void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value);
 #endif
+#define ams_delta_latch1_write(mask, value) \
+	ams_delta_latch_write(AMS_DELTA_LATCH1_GPIO_BASE, \
+			AMS_DELTA_LATCH1_NGPIO, (mask), (value))
+#define ams_delta_latch2_write(mask, value) \
+	ams_delta_latch_write(AMS_DELTA_LATCH2_GPIO_BASE, \
+			AMS_DELTA_LATCH2_NGPIO, (mask), (value))
 
 #endif /* CONFIG_MACH_AMS_DELTA */
 
-- 
1.7.3.4

