Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1LSX3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:29:18 -0500
Received: from d1.icnet.pl ([212.160.220.21]:38472 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1LSX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:29:16 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: [PATCH v2 1/7][RESEND] ARM: OMAP1: ams-delta: register latch dependent devices later
Date: Tue, 20 Dec 2011 00:28:32 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <83e934adfc691b347534edb7788a67ab2e6bd7e1.1324331816.git.jkrzyszt@tis.icnet.pl>
In-Reply-To: <83e934adfc691b347534edb7788a67ab2e6bd7e1.1324331816.git.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Message-Id: <201112200028.32947.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending because of a typo in the Cc: list, sorry.

8<--------------------------

In preparation to converting Amstrad Delta on-board latches to
basic_mmio_gpio devices, registration of platform devices which depend
on latches and will require initialization of their GPIO pins first,
should be moved out of .machine_init down to late_initcall level, as the
gpio-generic driver is not available until device_initcall time.  The
latch reset operation, which will be replaced with GPIO initialization,
must also be moved to late_initcall for the same reason.

Since there was already another, separate arch_initcall function for
setting up one of those latch dependent devices, the on-board modem
device, reuse that function, i.e., rename it to a name that matches the
new purpose, extend with other device setup relocated from
.machine_init, and move down to the late_initcall level.

While being at it, add missing gpio_free() in case the modem platform
device registration fails.

In addition, defer registration of the Amstrad Delta ASoC and serio
devices, done from their device driver files, until late_initcall time,
as those drivers will depend on their GPIO pins already requested from
the board late_init() function until updated to register their GPIO pins
themselves.

Thanks to Tony Lindgren <tony@atomide.com> who suggested this approach
instead of shifting up the gpio-generic driver initialization.

Created and tested against linux-3.2-rc6.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
This patch was not present in the initial submission, it replaces the
old patch 1/10, providing an alternative solution not touching the
gpio-generic driver.

Thanks,
Janusz


 arch/arm/mach-omap1/board-ams-delta.c |   28 ++++++++++++++++++++--------
 drivers/input/serio/ams_delta_serio.c |    4 ++++
 sound/soc/omap/ams-delta.c            |    4 ++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index b0f15d2..50987c9 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -275,11 +275,14 @@ static struct omap1_cam_platform_data ams_delta_camera_platform_data = {
 };
 
 static struct platform_device *ams_delta_devices[] __initdata = {
-	&ams_delta_nand_device,
 	&ams_delta_kp_device,
+	&ams_delta_camera_device,
+};
+
+static struct platform_device *late_devices[] __initdata = {
+	&ams_delta_nand_device,
 	&ams_delta_lcd_device,
 	&ams_delta_led_device,
-	&ams_delta_camera_device,
 };
 
 static void __init ams_delta_init(void)
@@ -307,9 +310,6 @@ static void __init ams_delta_init(void)
 	omap_serial_init();
 	omap_register_i2c_bus(1, 100, NULL, 0);
 
-	/* Clear latch2 (NAND, LCD, modem enable) */
-	ams_delta_latch2_write(~0, 0);
-
 	omap1_usb_init(&ams_delta_usb_config);
 	omap1_set_camera_info(&ams_delta_camera_platform_data);
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -345,13 +345,18 @@ static struct platform_device ams_delta_modem_device = {
 	},
 };
 
-static int __init ams_delta_modem_init(void)
+static int __init late_init(void)
 {
 	int err;
 
 	if (!machine_is_ams_delta())
 		return -ENODEV;
 
+	/* Clear latch2 (NAND, LCD, modem enable) */
+	ams_delta_latch2_write(~0, 0);
+
+	platform_add_devices(late_devices, ARRAY_SIZE(late_devices));
+
 	omap_cfg_reg(M14_1510_GPIO2);
 	ams_delta_modem_ports[0].irq =
 			gpio_to_irq(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
@@ -367,9 +372,16 @@ static int __init ams_delta_modem_init(void)
 		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
 		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
 
-	return platform_device_register(&ams_delta_modem_device);
+	err = platform_device_register(&ams_delta_modem_device);
+	if (err)
+		goto gpio_free;
+	return 0;
+
+gpio_free:
+	gpio_free(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
+	return err;
 }
-arch_initcall(ams_delta_modem_init);
+late_initcall(late_init);
 
 static void __init ams_delta_map_io(void)
 {
diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
index d4d08bd..56ffd7c 100644
--- a/drivers/input/serio/ams_delta_serio.c
+++ b/drivers/input/serio/ams_delta_serio.c
@@ -165,6 +165,9 @@ serio:
 	kfree(ams_delta_serio);
 	return err;
 }
+#ifndef MODULE
+late_initcall(ams_delta_serio_init);
+#else
 module_init(ams_delta_serio_init);
 
 static void __exit ams_delta_serio_exit(void)
@@ -175,3 +178,4 @@ static void __exit ams_delta_serio_exit(void)
 	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
 }
 module_exit(ams_delta_serio_exit);
+#endif
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index ccb8a6a..1764a3b 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -636,6 +636,9 @@ err:
 	platform_device_put(ams_delta_audio_platform_device);
 	return ret;
 }
+#ifndef MODULE
+late_initcall(ams_delta_module_init);
+#else
 module_init(ams_delta_module_init);
 
 static void __exit ams_delta_module_exit(void)
@@ -657,6 +660,7 @@ static void __exit ams_delta_module_exit(void)
 	platform_device_unregister(ams_delta_audio_platform_device);
 }
 module_exit(ams_delta_module_exit);
+#endif
 
 MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
 MODULE_DESCRIPTION("ALSA SoC driver for Amstrad E3 (Delta) videophone");
-- 
1.7.3.4

