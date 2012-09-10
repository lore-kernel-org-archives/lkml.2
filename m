Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2IJKsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:48:07 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58408 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2IJKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/14] ARM: OMAP/ASoC: Zoom2: Let the codec to handle the hs_extmute GPIO
Date: Mon, 10 Sep 2012 13:46:28 +0300
Message-Id: <1347273992-9107-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of set_hs_extmute callback and let the codec driver to
handle the extmute GPIO.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c  | 9 ++-------
 arch/arm/mach-omap2/include/mach/board-zoom.h | 2 --
 sound/soc/omap/zoom2.c                        | 4 ----
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index b797cb2..a7d3b04 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -34,6 +34,7 @@
 #include "common-board-devices.h"
 
 #define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
+#define ZOOM2_HEADSET_EXTMUTE_GPIO	(153)
 #define OMAP_ZOOM_WLAN_IRQ_GPIO		(162)
 
 #define LCD_PANEL_ENABLE_GPIO		(7 + OMAP_MAX_GPIO_LINES)
@@ -244,12 +245,6 @@ static int zoom_twl_gpio_setup(struct device *dev,
 	return ret;
 }
 
-/* EXTMUTE callback function */
-static void zoom2_set_hs_extmute(int mute)
-{
-	gpio_set_value(ZOOM2_HEADSET_EXTMUTE_GPIO, mute);
-}
-
 static struct twl4030_gpio_platform_data zoom_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
@@ -279,7 +274,7 @@ static int __init omap_i2c_init(void)
 
 		codec_data->ramp_delay_value = 3;	/* 161 ms */
 		codec_data->hs_extmute = 1;
-		codec_data->set_hs_extmute = zoom2_set_hs_extmute;
+		codec_data->hs_extmute_gpio = ZOOM2_HEADSET_EXTMUTE_GPIO;
 	}
 	omap_pmic_init(1, 2400, "twl5030", INT_34XX_SYS_NIRQ, &zoom_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/include/mach/board-zoom.h b/arch/arm/mach-omap2/include/mach/board-zoom.h
index 775fdc3..2e94869 100644
--- a/arch/arm/mach-omap2/include/mach/board-zoom.h
+++ b/arch/arm/mach-omap2/include/mach/board-zoom.h
@@ -8,5 +8,3 @@
 extern int __init zoom_debugboard_init(void);
 extern void __init zoom_peripherals_init(void);
 extern void __init zoom_display_init(void);
-
-#define ZOOM2_HEADSET_EXTMUTE_GPIO	153
diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
index 920e0d9..df97a41 100644
--- a/sound/soc/omap/zoom2.c
+++ b/sound/soc/omap/zoom2.c
@@ -191,9 +191,6 @@ static int __init zoom2_soc_init(void)
 	BUG_ON(gpio_request(ZOOM2_HEADSET_MUX_GPIO, "hs_mux") < 0);
 	gpio_direction_output(ZOOM2_HEADSET_MUX_GPIO, 0);
 
-	BUG_ON(gpio_request(ZOOM2_HEADSET_EXTMUTE_GPIO, "ext_mute") < 0);
-	gpio_direction_output(ZOOM2_HEADSET_EXTMUTE_GPIO, 0);
-
 	return 0;
 
 err1:
@@ -207,7 +204,6 @@ module_init(zoom2_soc_init);
 static void __exit zoom2_soc_exit(void)
 {
 	gpio_free(ZOOM2_HEADSET_MUX_GPIO);
-	gpio_free(ZOOM2_HEADSET_EXTMUTE_GPIO);
 
 	platform_device_unregister(zoom2_snd_device);
 }
-- 
1.7.12

