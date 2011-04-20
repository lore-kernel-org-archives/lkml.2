Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1DTJYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:24:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49703 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1DTJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ju26zKc+Tnm03Ygj3MPD2jwNGkOwvq01c5GzraYLNrvpJiUtb6yOLBfTFE7zV7Kk1E
         GPZtI+kqEh+otCXwas2lkkclAcNXrtnN/26Nt5Ybj5r43Rk6tvIDVGtkssSedWR6b+Nc
         S/nJ032mXS0sZMP7mhFo5Mg4UAwRk+4MUI7S0=
From: Igor Plyatov <plyatov@gmail.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH] mach-at91: gsia18s board improvements and bug fixes
Date: Wed, 20 Apr 2011 13:23:19 +0400
Message-Id: <1303291399-4075-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* AT91_PIN_Pxxx port names replaced by human readable GPO_xxxx, GPI_xxxx,
  GPIO_xxxx names. This simplify source code and schematic maintenance.
* Active logic levels and default states corrected for GPOs.
* Replace small functions which use platform_register_device() by its direct
  calls.
* Remove GPIO_CARD_UNMOUNT_1 gpio_keys_button, because it not used.
* debounce_interval added for critical buttons.
* Remove unneeded GPI setup code for buttons, because this done by corresponding
  driver.
* pcf8574x_0x20_setup() and pcf8574x_0x20_teardown functions small refactoring.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 arch/arm/mach-at91/board-gsia18s.c        |  150 +++++++++++-----------------
 arch/arm/mach-at91/include/mach/gsia18s.h |   25 ++++-
 2 files changed, 80 insertions(+), 95 deletions(-)

diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index bc28136..7837f8d 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -91,7 +91,7 @@ static struct at91_usbh_data __initdata usbh_data = {
  * USB Device port
  */
 static struct at91_udc_data __initdata udc_data = {
-	.vbus_pin	= AT91_PIN_PA22,
+	.vbus_pin	= GPI_USB_DEV_VB,
 	.pullup_pin	= 0,		/* pull-up driven by UDC */
 };
 
@@ -99,7 +99,7 @@ static struct at91_udc_data __initdata udc_data = {
  * MACB Ethernet device
  */
 static struct at91_eth_data __initdata macb_data = {
-	.phy_irq_pin	= AT91_PIN_PA28,
+	.phy_irq_pin	= GPI_ETH_IRQ,
 	.is_rmii	= 1,
 };
 
@@ -109,49 +109,49 @@ static struct at91_eth_data __initdata macb_data = {
 static struct gpio_led gpio_leds[] = {
 	{
 		.name			= "gpo:spi1reset",
-		.gpio			= AT91_PIN_PC1,
+		.gpio			= GPO_SPI1_RESET,
 		.active_low		= 0,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "gpo:trig_net_out",
-		.gpio			= AT91_PIN_PB20,
-		.active_low		= 0,
+		.gpio			= GPO_TRIG_NET_OUT,
+		.active_low		= 1,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "gpo:trig_net_dir",
-		.gpio			= AT91_PIN_PB19,
-		.active_low		= 0,
+		.gpio			= GPO_TRIG_NET_DIR,
+		.active_low		= 1,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "gpo:charge_dis",
-		.gpio			= AT91_PIN_PC2,
+		.gpio			= GPO_CHARGE_DIS,
 		.active_low		= 0,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "led:event",
-		.gpio			= AT91_PIN_PB17,
+		.gpio			= GPO_LED_EVENT,
 		.active_low		= 1,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "led:lan",
-		.gpio			= AT91_PIN_PB18,
+		.gpio			= GPO_LED_LAN,
 		.active_low		= 1,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	{
 		.name			= "led:error",
-		.gpio			= AT91_PIN_PB16,
+		.gpio			= GPO_LED_ERROR,
 		.active_low		= 1,
 		.default_trigger	= "none",
 		.default_state		= LEDS_GPIO_DEFSTATE_ON,
@@ -171,11 +171,6 @@ static struct platform_device leds = {
 	}
 };
 
-static void __init gsia18s_leds_init(void)
-{
-	platform_device_register(&leds);
-}
-
 /* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
 static struct gpio_led pcf_gpio_leds1[] = {
 	{ /* bit 0 */
@@ -188,31 +183,31 @@ static struct gpio_led pcf_gpio_leds1[] = {
 	{ /* bit 1 */
 		.name			= "gpo:wifi_setup",
 		.gpio			= PCF_GPIO_WIFI_SETUP,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 2 */
 		.name			= "gpo:wifi_enable",
 		.gpio			= PCF_GPIO_WIFI_ENABLE,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 3	*/
 		.name			= "gpo:wifi_reset",
 		.gpio			= PCF_GPIO_WIFI_RESET,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_ON,
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 	/* bit 4 used as GPI	*/
 	{ /* bit 5 */
 		.name			= "gpo:gps_setup",
 		.gpio			= PCF_GPIO_GPS_SETUP,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 6 */
 		.name			= "gpo:gps_standby",
@@ -248,30 +243,30 @@ static struct gpio_led pcf_gpio_leds2[] = {
 	{ /* bit 0 */
 		.name			= "gpo:alarm_1",
 		.gpio			= PCF_GPIO_ALARM1,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 1 */
 		.name			= "gpo:alarm_2",
 		.gpio			= PCF_GPIO_ALARM2,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 2 */
 		.name			= "gpo:alarm_3",
 		.gpio			= PCF_GPIO_ALARM3,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	{ /* bit 3 */
 		.name			= "gpo:alarm_4",
 		.gpio			= PCF_GPIO_ALARM4,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 	/* bits 4, 5, 6 not used */
 	{ /* bit 7 */
@@ -301,25 +296,25 @@ static struct gpio_led pcf_gpio_leds3[] = {
 	{ /* bit 0 */
 		.name			= "gpo:modem_power",
 		.gpio			= PCF_GPIO_MODEM_POWER,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
+		.default_state		= LEDS_GPIO_DEFSTATE_ON,
 	},
 		/* bits 1 and 2 not used */
 	{ /* bit 3 */
 		.name			= "gpo:modem_reset",
 		.gpio			= PCF_GPIO_MODEM_RESET,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_ON,
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	},
 		/* bits 4, 5 and 6 not used */
 	{ /* bit 7 */
 		.name			= "gpo:trx_reset",
 		.gpio			= PCF_GPIO_TRX_RESET,
-		.active_low		= 1,
+		.active_low		= 0,
 		.default_trigger	= "none",
-		.default_state		= LEDS_GPIO_DEFSTATE_ON,
+		.default_state		= LEDS_GPIO_DEFSTATE_OFF,
 	}
 };
 
@@ -336,13 +331,6 @@ static struct platform_device pcf_leds3 = {
 	}
 };
 
-static void __init gsia18s_pcf_leds_init(void)
-{
-	platform_device_register(&pcf_leds1);
-	platform_device_register(&pcf_leds2);
-	platform_device_register(&pcf_leds3);
-}
-
 /*
  * SPI busses.
  */
@@ -389,7 +377,7 @@ static struct spi_board_info gsia18s_spi_devices[] = {
  */
 static struct gpio_keys_button buttons[] = {
 	{
-		.gpio		= GPIO_TRIG_NET_IN,
+		.gpio		= GPI_TRIG_NET_IN,
 		.code		= BTN_1,
 		.desc		= "TRIG_NET_IN",
 		.type		= EV_KEY,
@@ -397,20 +385,13 @@ static struct gpio_keys_button buttons[] = {
 		.wakeup		= 1,
 	},
 	{ /* SW80 on the GS_IA18_S-MN board*/
-		.gpio		= GPIO_CARD_UNMOUNT_0,
+		.gpio		= GPI_CARD_UNMOUNT_0,
 		.code		= BTN_2,
 		.desc		= "Card umount 0",
 		.type		= EV_KEY,
 		.active_low	= 1,
 		.wakeup		= 1,
-	},
-	{ /* SW79 on the GS_IA18_S-MN board*/
-		.gpio		= GPIO_CARD_UNMOUNT_1,
-		.code		= BTN_3,
-		.desc		= "Card umount 1",
-		.type		= EV_KEY,
-		.active_low	= 1,
-		.wakeup		= 1,
+		.debounce_interval = 10,
 	},
 	{ /* SW280 on the GS_IA18-CB board*/
 		.gpio		= GPIO_KEY_POWER,
@@ -419,6 +400,7 @@ static struct gpio_keys_button buttons[] = {
 		.type		= EV_KEY,
 		.active_low	= 0,
 		.wakeup		= 1,
+		.debounce_interval = 10,
 	}
 };
 
@@ -436,60 +418,44 @@ static struct platform_device button_device = {
 	}
 };
 
-static void __init gsia18s_add_device_buttons(void)
-{
-	at91_set_gpio_input(GPIO_TRIG_NET_IN, 1);
-	at91_set_deglitch(GPIO_TRIG_NET_IN, 1);
-	at91_set_gpio_input(GPIO_CARD_UNMOUNT_0, 1);
-	at91_set_deglitch(GPIO_CARD_UNMOUNT_0, 1);
-	at91_set_gpio_input(GPIO_CARD_UNMOUNT_1, 1);
-	at91_set_deglitch(GPIO_CARD_UNMOUNT_1, 1);
-	at91_set_gpio_input(GPIO_KEY_POWER, 0);
-	at91_set_deglitch(GPIO_KEY_POWER, 1);
-
-	platform_device_register(&button_device);
-}
-
 /*
  * I2C
  */
-static int pcf8574x_0x20_setup(struct i2c_client *client, int gpio,
+static int pcf8574x_0x20_setup(struct i2c_client *client, int gpio_base,
 				unsigned int ngpio, void *context)
 {
 	int status;
+	int gpio;
 
-	status = gpio_request(gpio + PCF_GPIO_ETH_DETECT, "eth_det");
+	gpio = gpio_base + PCF_GPIO_ETH_DETECT;
+	status = gpio_request(gpio, "eth_det");
 	if (status < 0) {
-		pr_err("error: can't request GPIO%d\n",
-			gpio + PCF_GPIO_ETH_DETECT);
+		pr_err("error: can't request GPIO%d\n", gpio);
 		return status;
 	}
-	status = gpio_direction_input(gpio + PCF_GPIO_ETH_DETECT);
+	status = gpio_direction_input(gpio);
 	if (status < 0) {
-		pr_err("error: can't setup GPIO%d as input\n",
-			gpio + PCF_GPIO_ETH_DETECT);
+		pr_err("error: can't setup GPIO%d as input\n", gpio);
 		return status;
 	}
-	status = gpio_export(gpio + PCF_GPIO_ETH_DETECT, false);
+	status = gpio_export(gpio, false);
 	if (status < 0) {
-		pr_err("error: can't export GPIO%d\n",
-			gpio + PCF_GPIO_ETH_DETECT);
+		pr_err("error: can't export GPIO%d\n", gpio);
 		return status;
 	}
-	status = gpio_sysfs_set_active_low(gpio + PCF_GPIO_ETH_DETECT, 1);
+	status = gpio_sysfs_set_active_low(gpio, 1);
 	if (status < 0) {
-		pr_err("error: gpio_sysfs_set active_low(GPIO%d, 1)\n",
-			gpio + PCF_GPIO_ETH_DETECT);
+		pr_err("error: gpio_sysfs_set active_low(GPIO%d, 1)\n", gpio);
 		return status;
 	}
 
 	return 0;
 }
 
-static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
+static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio_base,
 					unsigned ngpio, void *context)
 {
-	gpio_free(gpio + PCF_GPIO_ETH_DETECT);
+	gpio_free(gpio_base + PCF_GPIO_ETH_DETECT);
 	return 0;
 }
 
@@ -533,9 +499,9 @@ static struct i2c_board_info __initdata gsia18s_i2c_devices[] = {
  * Compact Flash
  */
 static struct at91_cf_data __initdata gsia18s_cf1_data = {
-	.irq_pin	= AT91_PIN_PA27,
-	.det_pin	= AT91_PIN_PB30,
-	.rst_pin	= AT91_PIN_PB31,
+	.irq_pin	= GPI_CF1_IRQ,
+	.det_pin	= GPI_CF1_DET,
+	.rst_pin	= GPO_CF1_RESET,
 	.chipselect	= 5,
 	.flags		= AT91_CF_TRUE_IDE,
 };
@@ -544,7 +510,7 @@ static struct at91_cf_data __initdata gsia18s_cf1_data = {
 static void gsia18s_power_off(void)
 {
 	pr_notice("Power supply will be switched off automatically now or after 60 seconds without ArmDAS.\n");
-	at91_set_gpio_output(AT91_PIN_PA25, 1);
+	at91_set_gpio_output(GPIO_KEY_POWER, 1);
 	/* Spin to death... */
 	while (1)
 		;
@@ -564,9 +530,11 @@ static void __init gsia18s_board_init(void)
 	at91_add_device_usbh(&usbh_data);
 	at91_add_device_udc(&udc_data);
 	at91_add_device_eth(&macb_data);
-	gsia18s_leds_init();
-	gsia18s_pcf_leds_init();
-	gsia18s_add_device_buttons();
+	platform_device_register(&leds);
+	platform_device_register(&pcf_leds1);
+	platform_device_register(&pcf_leds2);
+	platform_device_register(&pcf_leds3);
+	platform_device_register(&button_device);
 	at91_add_device_i2c(gsia18s_i2c_devices,
 				ARRAY_SIZE(gsia18s_i2c_devices));
 	at91_add_device_cf(&gsia18s_cf1_data);
diff --git a/arch/arm/mach-at91/include/mach/gsia18s.h b/arch/arm/mach-at91/include/mach/gsia18s.h
index 307c194..d972dc7 100644
--- a/arch/arm/mach-at91/include/mach/gsia18s.h
+++ b/arch/arm/mach-at91/include/mach/gsia18s.h
@@ -1,9 +1,26 @@
-/* Buttons */
-#define GPIO_TRIG_NET_IN		AT91_PIN_PB21
-#define GPIO_CARD_UNMOUNT_0		AT91_PIN_PB13
-#define GPIO_CARD_UNMOUNT_1		AT91_PIN_PB12
+/* GPIOs (IN/OUT changed on the fly) */
 #define GPIO_KEY_POWER			AT91_PIN_PA25
 
+/* GPIs */
+#define GPI_TRIG_NET_IN			AT91_PIN_PB21
+#define GPI_CARD_UNMOUNT_0		AT91_PIN_PB13
+#define GPI_USB_DEV_VB			AT91_PIN_PA22
+#define GPI_ETH_IRQ			AT91_PIN_PA28
+#define GPI_CF1_IRQ			AT91_PIN_PA27
+#define GPI_CF1_DET			AT91_PIN_PB30
+#define GPI_PPS0_IN			AT91_PIN_PC0
+#define GPI_PPS1_IN			AT91_PIN_PB12
+
+/* GPOs */
+#define GPO_SPI1_RESET			AT91_PIN_PC1
+#define GPO_TRIG_NET_OUT		AT91_PIN_PB20
+#define GPO_TRIG_NET_DIR		AT91_PIN_PB19
+#define GPO_CHARGE_DIS			AT91_PIN_PC2
+#define GPO_LED_EVENT			AT91_PIN_PB17
+#define GPO_LED_LAN			AT91_PIN_PB18
+#define GPO_LED_ERROR			AT91_PIN_PB16
+#define GPO_CF1_RESET			AT91_PIN_PB31
+
 /* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
 #define GS_IA18_S_PCF_GPIO_BASE0	NR_BUILTIN_GPIO
 #define PCF_GPIO_HDC_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 0)
-- 
1.7.1

