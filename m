Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1IHXc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:32:26 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:33066 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1IHXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:32:19 -0400
From: Mans Rullgard <mans.rullgard@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-dev@lists.linaro.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jarkko Nikula <jhnikula@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v2] ASoC: omap: convert per-board modules to platform drivers
Date: Thu,  8 Sep 2011 18:34:56 +0100
Message-Id: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the per-board modules to platform drivers for a
device created by in main platform setup.  These drivers call
snd_soc_register_card() directly instead of going via a "soc-audio"
device and the corresponding driver in soc-core.

Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
---
Platform device names fixed.
N8x0 changed to get clocks before registering card.
---
 arch/arm/mach-omap2/board-3430sdp.c          |    6 ++
 arch/arm/mach-omap2/board-4430sdp.c          |    6 ++
 arch/arm/mach-omap2/board-am3517evm.c        |    7 +++
 arch/arm/mach-omap2/board-devkit8000.c       |    6 ++
 arch/arm/mach-omap2/board-igep0020.c         |    6 ++
 arch/arm/mach-omap2/board-n8x0.c             |    6 ++
 arch/arm/mach-omap2/board-omap3beagle.c      |    6 ++
 arch/arm/mach-omap2/board-omap3evm.c         |    7 +++
 arch/arm/mach-omap2/board-omap3pandora.c     |    6 ++
 arch/arm/mach-omap2/board-overo.c            |   17 ++++++
 arch/arm/mach-omap2/board-rx51.c             |    6 ++
 arch/arm/mach-omap2/board-zoom-peripherals.c |    6 ++
 sound/soc/omap/am3517evm.c                   |   55 ++++++++++++-------
 sound/soc/omap/igep0020.c                    |   52 ++++++++++++------
 sound/soc/omap/n810.c                        |   73 ++++++++++++++++----------
 sound/soc/omap/omap3beagle.c                 |   55 ++++++++++++-------
 sound/soc/omap/omap3evm.c                    |   56 +++++++++++++-------
 sound/soc/omap/omap3pandora.c                |   70 +++++++++++++++----------
 sound/soc/omap/overo.c                       |   56 ++++++++++++-------
 sound/soc/omap/rx51.c                        |   55 +++++++++++++------
 sound/soc/omap/sdp3430.c                     |   65 ++++++++++++++---------
 sound/soc/omap/sdp4430.c                     |   60 +++++++++++++--------
 sound/soc/omap/zoom2.c                       |   68 ++++++++++++++++--------
 23 files changed, 509 insertions(+), 241 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 5dac974..4c6a845 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -470,6 +470,11 @@ static struct twl4030_codec_data sdp3430_codec = {
 	.audio = &sdp3430_audio,
 };
 
+static struct platform_device sdp3430_soc_audio = {
+	.name	= "sdp3430-soc-audio",
+	.id	= -1,
+};
+
 static struct twl4030_platform_data sdp3430_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
@@ -796,6 +801,7 @@ static void __init omap_3430sdp_init(void)
 	sdp3430_display_init();
 	enable_board_wakeup_source();
 	usbhs_init(&usbhs_bdata);
+	platform_device_register(&sdp3430_soc_audio);
 }
 
 MACHINE_START(OMAP_3430SDP, "OMAP3430 3430SDP board")
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 63de2d3..d73d7e7 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -276,11 +276,17 @@ static struct platform_device sdp4430_lcd_device = {
 	.id		= -1,
 };
 
+static struct platform_device sdp4430_soc_audio = {
+	.name	= "sdp4430-soc-audio",
+	.id	= -1,
+};
+
 static struct platform_device *sdp4430_devices[] __initdata = {
 	&sdp4430_lcd_device,
 	&sdp4430_gpio_keys_device,
 	&sdp4430_leds_gpio,
 	&sdp4430_leds_pwm,
+	&sdp4430_soc_audio,
 };
 
 static struct omap_lcd_config sdp4430_lcd_config __initdata = {
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 63af417..5d632f6 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -457,6 +457,11 @@ static void am3517_evm_hecc_init(struct ti_hecc_platform_data *pdata)
 	platform_device_register(&am3517_hecc_device);
 }
 
+static struct platform_device am3517_evm_soc_audio = {
+	.name	= "am3517evm-soc-audio",
+	.id	= -1,
+};
+
 static struct omap_board_config_kernel am3517_evm_config[] __initdata = {
 };
 
@@ -487,6 +492,8 @@ static void __init am3517_evm_init(void)
 
 	/* MUSB */
 	am3517_evm_musb_init();
+
+	platform_device_register(&am3517_evm_soc_audio);
 }
 
 MACHINE_START(OMAP3517EVM, "OMAP3517/AM3517 EVM")
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 34956ec..070d4f6 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -477,6 +477,11 @@ static struct platform_device omap_dm9000_dev = {
 	},
 };
 
+static struct platform_device soc_audio = {
+	.name	= "omap3beagle-soc-audio",
+	.id	= -1,
+};
+
 static void __init omap_dm9000_init(void)
 {
 	unsigned char *eth_addr = omap_dm9000_platdata.dev_addr;
@@ -505,6 +510,7 @@ static struct platform_device *devkit8000_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
 	&omap_dm9000_dev,
+	&soc_audio,
 };
 
 static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 4bcbee3..9bfc8cb 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -508,8 +508,14 @@ static void __init igep2_display_init(void)
 		pr_err("IGEP v2: Could not obtain gpio GPIO_DVI_PUP\n");
 }
 
+static struct platform_device igep_soc_audio = {
+	.name	= "igep2-soc-audio",
+	.id	= -1,
+};
+
 static struct platform_device *igep_devices[] __initdata = {
 	&igep_vwlan_device,
+	&igep_soc_audio,
 };
 
 static void __init igep_init_early(void)
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 8d74318..a477e6c 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -616,6 +616,11 @@ static struct i2c_board_info n810_i2c_board_info_2[] __initdata = {
 	},
 };
 
+static struct platform_device n8x0_soc_audio = {
+	.name	= "n8x0-soc-audio",
+	.id	= -1,
+};
+
 static void __init n8x0_map_io(void)
 {
 	omap2_set_globals_242x();
@@ -692,6 +697,7 @@ static void __init n8x0_init_machine(void)
 	gpmc_onenand_init(board_onenand_data);
 	n8x0_mmc_init();
 	n8x0_usb_init();
+	platform_device_register(&n8x0_soc_audio);
 }
 
 MACHINE_START(NOKIA_N800, "Nokia N800")
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 4f23c15..b9b5231 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -503,6 +503,11 @@ static struct platform_device keys_gpio = {
 	},
 };
 
+static struct platform_device soc_audio = {
+	.name	= "omap3beagle-soc-audio",
+	.id	= -1,
+};
+
 static void __init omap3_beagle_init_early(void)
 {
 	omap2_init_common_infrastructure();
@@ -521,6 +526,7 @@ static void __init omap3_beagle_init_irq(void)
 static struct platform_device *omap3_beagle_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
+	&soc_audio,
 };
 
 static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index b4d4346..4cd7d2e 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -678,6 +678,11 @@ static struct gpio omap3_evm_ehci_gpios[] __initdata = {
 	{ OMAP3_EVM_EHCI_SELECT, GPIOF_OUT_INIT_LOW,   "select EHCI port" },
 };
 
+static struct platform_device omap3evm_soc_audio = {
+	.name	= "omap3evm-soc-audio",
+	.id	= -1,
+};
+
 static void __init omap3_evm_init(void)
 {
 	omap3_evm_get_revision();
@@ -732,6 +737,8 @@ static void __init omap3_evm_init(void)
 		pr_err("error setting wl12xx data\n");
 	platform_device_register(&omap3evm_wlan_regulator);
 #endif
+
+	platform_device_register(&omap3evm_soc_audio);
 }
 
 MACHINE_START(OMAP3EVM, "OMAP3 EVM")
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 23f71d4..56a22fc 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -593,10 +593,16 @@ fail:
 	printk(KERN_ERR "wl1251 board initialisation failed\n");
 }
 
+static struct platform_device pandora_soc_audio = {
+	.name	= "omap3pandora-soc-audio",
+	.id	= -1,
+};
+
 static struct platform_device *omap3pandora_devices[] __initdata = {
 	&pandora_leds_gpio,
 	&pandora_keys_gpio,
 	&pandora_vwlan_device,
+	&pandora_soc_audio,
 };
 
 static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index b32b492..f9379eb 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -410,6 +410,22 @@ static void __init overo_init_keys(void)
 static inline void __init overo_init_keys(void) { return; }
 #endif
 
+#if defined(CONFIG_SND_SOC) || defined(CONFIG_SND_SOC_MODULE)
+
+static struct platform_device soc_audio = {
+	.name	= "overo-soc-audio",
+	.id	= -1,
+};
+
+static void overo_init_audio(void)
+{
+	platform_device_register(&soc_audio);
+}
+
+#else
+static inline void overo_init_audio(void) {}
+#endif
+
 static int overo_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -573,6 +589,7 @@ static void __init overo_init(void)
 	overo_display_init();
 	overo_init_led();
 	overo_init_keys();
+	overo_init_audio();
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index fec4cac..bb3537a 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -58,6 +58,11 @@ static struct platform_device leds_gpio = {
 	},
 };
 
+static struct platform_device soc_audio = {
+	.name	= "rx51-soc-audio",
+	.id	= -1,
+};
+
 /*
  * cpuidle C-states definition override from the default values.
  * The 'exit_latency' field is the sum of sleep and wake-up latencies.
@@ -140,6 +145,7 @@ static void __init rx51_init(void)
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
 
 	platform_device_register(&leds_gpio);
+	platform_device_register(&soc_audio);
 }
 
 static void __init rx51_map_io(void)
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 118c6f5..037a9cc 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -286,6 +286,11 @@ static int zoom_twl_gpio_setup(struct device *dev,
 	return ret;
 }
 
+static struct platform_device zoom_soc_audio = {
+	.name	= "zoom2-soc-audio",
+	.id	= -1,
+};
+
 /* EXTMUTE callback function */
 static void zoom2_set_hs_extmute(int mute)
 {
@@ -378,4 +383,5 @@ void __init zoom_peripherals_init(void)
 	usb_musb_init(NULL);
 	enable_board_wakeup_source();
 	omap_serial_init();
+	platform_device_register(&zoom_soc_audio);
 }
diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
index 73dde4a..75c8766 100644
--- a/sound/soc/omap/am3517evm.c
+++ b/sound/soc/omap/am3517evm.c
@@ -151,45 +151,60 @@ static struct snd_soc_card snd_soc_am3517evm = {
 	.num_links = 1,
 };
 
-static struct platform_device *am3517evm_snd_device;
-
-static int __init am3517evm_soc_init(void)
+static int __devinit am3517evm_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_am3517evm;
 	int ret;
 
-	if (!machine_is_omap3517evm())
-		return -ENODEV;
 	pr_info("OMAP3517 / AM3517 EVM SoC init\n");
 
-	am3517evm_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!am3517evm_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
 	}
 
-	platform_set_drvdata(am3517evm_snd_device, &snd_soc_am3517evm);
+	return 0;
+}
 
-	ret = platform_device_add(am3517evm_snd_device);
-	if (ret)
-		goto err1;
+static int __devexit am3517evm_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
 
 	return 0;
+}
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(am3517evm_snd_device);
+static struct platform_driver am3517evm_driver = {
+	.driver = {
+		.name = "am3517evm-soc-audio",
+		.owner = THIS_MODULE,
+	},
 
-	return ret;
+	.probe = am3517evm_soc_probe,
+	.remove = __devexit_p(am3517evm_soc_remove),
+};
+
+static int __init am3517evm_soc_init(void)
+{
+	if (!machine_is_omap3517evm())
+		return -ENODEV;
+
+	return platform_driver_register(&am3517evm_driver);
 }
+module_init(am3517evm_soc_init);
 
 static void __exit am3517evm_soc_exit(void)
 {
-	platform_device_unregister(am3517evm_snd_device);
+	platform_driver_unregister(&am3517evm_driver);
 }
-
-module_init(am3517evm_soc_init);
 module_exit(am3517evm_soc_exit);
 
 MODULE_AUTHOR("Anuj Aggarwal <anuj.aggarwal@ti.com>");
 MODULE_DESCRIPTION("ALSA SoC OMAP3517 / AM3517 EVM");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:am3517evm-soc-audio");
diff --git a/sound/soc/omap/igep0020.c b/sound/soc/omap/igep0020.c
index 0ae3470..1d6b756 100644
--- a/sound/soc/omap/igep0020.c
+++ b/sound/soc/omap/igep0020.c
@@ -94,44 +94,60 @@ static struct snd_soc_card snd_soc_card_igep2 = {
 	.num_links = 1,
 };
 
-static struct platform_device *igep2_snd_device;
-
-static int __init igep2_soc_init(void)
+static int __devinit igep2_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_card_igep2;
 	int ret;
 
-	if (!machine_is_igep0020())
-		return -ENODEV;
 	printk(KERN_INFO "IGEP v2 SoC init\n");
 
-	igep2_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!igep2_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
 	}
 
-	platform_set_drvdata(igep2_snd_device, &snd_soc_card_igep2);
+	return 0;
+}
+
+static int __devexit igep2_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	ret = platform_device_add(igep2_snd_device);
-	if (ret)
-		goto err1;
+	snd_soc_unregister_card(card);
 
 	return 0;
+}
+
+static struct platform_driver igep2_driver = {
+	.driver = {
+		.name = "igep2-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = igep2_soc_probe,
+	.remove = __devexit_p(igep2_soc_remove),
+};
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(igep2_snd_device);
+static int __init igep2_soc_init(void)
+{
+	if (!machine_is_igep0020())
+		return -ENODEV;
 
-	return ret;
+	return platform_driver_register(&igep2_driver);
 }
 module_init(igep2_soc_init);
 
 static void __exit igep2_soc_exit(void)
 {
-	platform_device_unregister(igep2_snd_device);
+	platform_driver_unregister(&igep2_driver);
 }
 module_exit(igep2_soc_exit);
 
 MODULE_AUTHOR("Enric Balletbo i Serra <eballetbo@iseebcn.com>");
 MODULE_DESCRIPTION("ALSA SoC IGEP v2");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:igep2-soc-audio");
diff --git a/sound/soc/omap/n810.c b/sound/soc/omap/n810.c
index 83d213b..2904499 100644
--- a/sound/soc/omap/n810.c
+++ b/sound/soc/omap/n810.c
@@ -323,38 +323,25 @@ static struct snd_soc_card snd_soc_n810 = {
 	.num_links = 1,
 };
 
-static struct platform_device *n810_snd_device;
-
-static int __init n810_soc_init(void)
+static int __devinit n810_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_n810;
+	struct device *dev = &pdev->dev;
 	int err;
-	struct device *dev;
-
-	if (!(machine_is_nokia_n810() || machine_is_nokia_n810_wimax()))
-		return -ENODEV;
 
-	n810_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!n810_snd_device)
-		return -ENOMEM;
-
-	platform_set_drvdata(n810_snd_device, &snd_soc_n810);
-	err = platform_device_add(n810_snd_device);
-	if (err)
-		goto err1;
-
-	dev = &n810_snd_device->dev;
+	card->dev = dev;
 
 	sys_clkout2_src = clk_get(dev, "sys_clkout2_src");
 	if (IS_ERR(sys_clkout2_src)) {
 		dev_err(dev, "Could not get sys_clkout2_src clock\n");
 		err = PTR_ERR(sys_clkout2_src);
-		goto err2;
+		return err;
 	}
 	sys_clkout2 = clk_get(dev, "sys_clkout2");
 	if (IS_ERR(sys_clkout2)) {
 		dev_err(dev, "Could not get sys_clkout2\n");
 		err = PTR_ERR(sys_clkout2);
-		goto err3;
+		goto err1;
 	}
 	/*
 	 * Configure 12 MHz output on SYS_CLKOUT2. Therefore we must use
@@ -364,7 +351,7 @@ static int __init n810_soc_init(void)
 	if (IS_ERR(func96m_clk)) {
 		dev_err(dev, "Could not get func 96M clock\n");
 		err = PTR_ERR(func96m_clk);
-		goto err4;
+		goto err2;
 	}
 	clk_set_parent(sys_clkout2_src, func96m_clk);
 	clk_set_rate(sys_clkout2, 12000000);
@@ -375,33 +362,65 @@ static int __init n810_soc_init(void)
 	gpio_direction_output(N810_HEADSET_AMP_GPIO, 0);
 	gpio_direction_output(N810_SPEAKER_AMP_GPIO, 0);
 
+	err = snd_soc_register_card(card);
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			err);
+		goto err3;
+	}
+
 	return 0;
-err4:
-	clk_put(sys_clkout2);
 err3:
-	clk_put(sys_clkout2_src);
+	clk_put(func96m_clk);
 err2:
-	platform_device_del(n810_snd_device);
+	clk_put(sys_clkout2);
 err1:
-	platform_device_put(n810_snd_device);
+	clk_put(sys_clkout2_src);
 
 	return err;
 }
 
-static void __exit n810_soc_exit(void)
+static int __devexit n810_soc_remove(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
 	gpio_free(N810_SPEAKER_AMP_GPIO);
 	gpio_free(N810_HEADSET_AMP_GPIO);
 	clk_put(sys_clkout2_src);
 	clk_put(sys_clkout2);
 	clk_put(func96m_clk);
 
-	platform_device_unregister(n810_snd_device);
+	snd_soc_unregister_card(card);
+
+	return 0;
 }
 
+static struct platform_driver n810_driver = {
+	.driver = {
+		.name = "n8x0-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = n810_soc_probe,
+	.remove = __devexit_p(n810_soc_remove),
+};
+
+static int __init n810_soc_init(void)
+{
+	if (!(machine_is_nokia_n810() || machine_is_nokia_n810_wimax()))
+		return -ENODEV;
+
+	return platform_driver_register(&n810_driver);
+}
 module_init(n810_soc_init);
+
+static void __exit n810_soc_exit(void)
+{
+	platform_driver_unregister(&n810_driver);
+}
 module_exit(n810_soc_exit);
 
 MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
 MODULE_DESCRIPTION("ALSA SoC Nokia N810");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:n8x0-soc-audio");
diff --git a/sound/soc/omap/omap3beagle.c b/sound/soc/omap/omap3beagle.c
index 40db813..85db9c3 100644
--- a/sound/soc/omap/omap3beagle.c
+++ b/sound/soc/omap/omap3beagle.c
@@ -105,45 +105,60 @@ static struct snd_soc_card snd_soc_omap3beagle = {
 	.num_links = 1,
 };
 
-static struct platform_device *omap3beagle_snd_device;
-
-static int __init omap3beagle_soc_init(void)
+static int __devinit omap3beagle_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_omap3beagle;
 	int ret;
 
-	if (!(machine_is_omap3_beagle() || machine_is_devkit8000()))
-		return -ENODEV;
 	pr_info("OMAP3 Beagle/Devkit8000 SoC init\n");
 
-	omap3beagle_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!omap3beagle_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
 	}
 
-	platform_set_drvdata(omap3beagle_snd_device, &snd_soc_omap3beagle);
+	return 0;
+}
 
-	ret = platform_device_add(omap3beagle_snd_device);
-	if (ret)
-		goto err1;
+static int __devexit omap3beagle_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
 
 	return 0;
+}
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(omap3beagle_snd_device);
+static struct platform_driver omap3beagle_driver = {
+	.driver = {
+		.name = "omap3beagle-soc-audio",
+		.owner = THIS_MODULE,
+	},
 
-	return ret;
+	.probe = omap3beagle_soc_probe,
+	.remove = __devexit_p(omap3beagle_soc_remove),
+};
+
+static int __init omap3beagle_soc_init(void)
+{
+	if (!(machine_is_omap3_beagle() || machine_is_devkit8000()))
+		return -ENODEV;
+
+	return platform_driver_register(&omap3beagle_driver);
 }
+module_init(omap3beagle_soc_init);
 
 static void __exit omap3beagle_soc_exit(void)
 {
-	platform_device_unregister(omap3beagle_snd_device);
+	platform_driver_unregister(&omap3beagle_driver);
 }
-
-module_init(omap3beagle_soc_init);
 module_exit(omap3beagle_soc_exit);
 
 MODULE_AUTHOR("Steve Sakoman <steve@sakoman.com>");
 MODULE_DESCRIPTION("ALSA SoC OMAP3 Beagle");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap3beagle-soc-audio");
diff --git a/sound/soc/omap/omap3evm.c b/sound/soc/omap/omap3evm.c
index 0daa044..55c9aa3 100644
--- a/sound/soc/omap/omap3evm.c
+++ b/sound/soc/omap/omap3evm.c
@@ -92,44 +92,60 @@ static struct snd_soc_card snd_soc_omap3evm = {
 	.num_links = 1,
 };
 
-static struct platform_device *omap3evm_snd_device;
-
-static int __init omap3evm_soc_init(void)
+static int __devinit omap3evm_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_omap3evm;
 	int ret;
 
-	if (!machine_is_omap3evm())
-		return -ENODEV;
 	pr_info("OMAP3 EVM SoC init\n");
 
-	omap3evm_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!omap3evm_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
+	card->dev = &pdev->dev;
+
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
 	}
 
-	platform_set_drvdata(omap3evm_snd_device, &snd_soc_omap3evm);
-	ret = platform_device_add(omap3evm_snd_device);
-	if (ret)
-		goto err1;
+	return 0;
+}
+
+static int __devexit omap3evm_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
 
 	return 0;
+}
+
+static struct platform_driver omap3evm_driver = {
+	.driver = {
+		.name = "omap3evm-soc-audio",
+		.owner = THIS_MODULE,
+	},
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(omap3evm_snd_device);
+	.probe = omap3evm_soc_probe,
+	.remove = __devexit_p(omap3evm_soc_remove),
+};
 
-	return ret;
+static int __init omap3evm_soc_init(void)
+{
+	if (!machine_is_omap3evm())
+		return -ENODEV;
+
+	return platform_driver_register(&omap3evm_driver);
 }
+module_init(omap3evm_soc_init);
 
 static void __exit omap3evm_soc_exit(void)
 {
-	platform_device_unregister(omap3evm_snd_device);
+	platform_driver_unregister(&omap3evm_driver);
 }
-
-module_init(omap3evm_soc_init);
 module_exit(omap3evm_soc_exit);
 
 MODULE_AUTHOR("Anuj Aggarwal <anuj.aggarwal@ti.com>");
 MODULE_DESCRIPTION("ALSA SoC OMAP3 EVM");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:omap3evm-soc-audio");
diff --git a/sound/soc/omap/omap3pandora.c b/sound/soc/omap/omap3pandora.c
index 8047c52..c523e5f 100644
--- a/sound/soc/omap/omap3pandora.c
+++ b/sound/soc/omap/omap3pandora.c
@@ -252,17 +252,15 @@ static struct snd_soc_card snd_soc_card_omap3pandora = {
 	.num_links = ARRAY_SIZE(omap3pandora_dai),
 };
 
-static struct platform_device *omap3pandora_snd_device;
-
-static int __init omap3pandora_soc_init(void)
+static int __devinit omap3pandora_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_card_omap3pandora;
 	int ret;
 
-	if (!machine_is_omap3_pandora())
-		return -ENODEV;
-
 	pr_info("OMAP3 Pandora SoC init\n");
 
+	card->dev = &pdev->dev;
+
 	ret = gpio_request(OMAP3_PANDORA_DAC_POWER_GPIO, "dac_power");
 	if (ret) {
 		pr_err(PREFIX "Failed to get DAC power GPIO\n");
@@ -287,53 +285,71 @@ static int __init omap3pandora_soc_init(void)
 		goto fail1;
 	}
 
-	omap3pandora_snd_device = platform_device_alloc("soc-audio", -1);
-	if (omap3pandora_snd_device == NULL) {
-		pr_err(PREFIX "Platform device allocation failed\n");
-		ret = -ENOMEM;
-		goto fail1;
-	}
-
-	platform_set_drvdata(omap3pandora_snd_device, &snd_soc_card_omap3pandora);
-
-	ret = platform_device_add(omap3pandora_snd_device);
+	ret = snd_soc_register_card(card);
 	if (ret) {
-		pr_err(PREFIX "Unable to add platform device\n");
-		goto fail2;
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		goto fail1;
 	}
 
-	omap3pandora_dac_reg = regulator_get(&omap3pandora_snd_device->dev, "vcc");
+	omap3pandora_dac_reg = regulator_get(card->dev, "vcc");
 	if (IS_ERR(omap3pandora_dac_reg)) {
 		pr_err(PREFIX "Failed to get DAC regulator from %s: %ld\n",
-			dev_name(&omap3pandora_snd_device->dev),
+			dev_name(card->dev),
 			PTR_ERR(omap3pandora_dac_reg));
 		ret = PTR_ERR(omap3pandora_dac_reg);
-		goto fail3;
+		goto fail2;
 	}
 
 	return 0;
 
-fail3:
-	platform_device_del(omap3pandora_snd_device);
 fail2:
-	platform_device_put(omap3pandora_snd_device);
+	snd_soc_unregister_card(card);
 fail1:
 	gpio_free(OMAP3_PANDORA_AMP_POWER_GPIO);
 fail0:
 	gpio_free(OMAP3_PANDORA_DAC_POWER_GPIO);
 	return ret;
 }
-module_init(omap3pandora_soc_init);
 
-static void __exit omap3pandora_soc_exit(void)
+static int __devexit omap3pandora_soc_remove(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
 	regulator_put(omap3pandora_dac_reg);
-	platform_device_unregister(omap3pandora_snd_device);
+	snd_soc_unregister_card(card);
 	gpio_free(OMAP3_PANDORA_AMP_POWER_GPIO);
 	gpio_free(OMAP3_PANDORA_DAC_POWER_GPIO);
+
+	return 0;
+}
+
+static struct platform_driver omap3pandora_driver = {
+	.driver = {
+		.name = "omap3pandora-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = omap3pandora_soc_probe,
+	.remove = __devexit_p(omap3pandora_soc_remove),
+};
+
+static int __init omap3pandora_soc_init(void)
+{
+	if (!machine_is_omap3_pandora())
+		return -ENODEV;
+
+	return platform_driver_register(&omap3pandora_driver);
+}
+module_init(omap3pandora_soc_init);
+
+static void __exit omap3pandora_soc_exit(void)
+{
+	platform_driver_unregister(&omap3pandora_driver);
 }
 module_exit(omap3pandora_soc_exit);
 
 MODULE_AUTHOR("Grazvydas Ignotas <notasas@gmail.com>");
 MODULE_DESCRIPTION("ALSA SoC OMAP3 Pandora");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap3pandora-soc-audio");
diff --git a/sound/soc/omap/overo.c b/sound/soc/omap/overo.c
index bbcf380..a8337f6 100644
--- a/sound/soc/omap/overo.c
+++ b/sound/soc/omap/overo.c
@@ -94,46 +94,60 @@ static struct snd_soc_card snd_soc_card_overo = {
 	.num_links = 1,
 };
 
-static struct platform_device *overo_snd_device;
-
-static int __init overo_soc_init(void)
+static int __devinit overo_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_card_overo;
 	int ret;
 
-	if (!(machine_is_overo() || machine_is_cm_t35())) {
-		pr_debug("Incomatible machine!\n");
-		return -ENODEV;
-	}
-	printk(KERN_INFO "overo SoC init\n");
+	pr_info("overo SoC init\n");
+
+	card->dev = &pdev->dev;
 
-	overo_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!overo_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
 	}
 
-	platform_set_drvdata(overo_snd_device, &snd_soc_card_overo);
+	return 0;
+}
 
-	ret = platform_device_add(overo_snd_device);
-	if (ret)
-		goto err1;
+static int __devexit overo_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
 
 	return 0;
+}
+
+static struct platform_driver overo_driver = {
+	.driver = {
+		.name = "overo-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = overo_soc_probe,
+	.remove = __devexit_p(overo_soc_remove),
+};
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(overo_snd_device);
+static int __init overo_soc_init(void)
+{
+	if (!(machine_is_overo() || machine_is_cm_t35()))
+		return -ENODEV;
 
-	return ret;
+	return platform_driver_register(&overo_driver);
 }
 module_init(overo_soc_init);
 
 static void __exit overo_soc_exit(void)
 {
-	platform_device_unregister(overo_snd_device);
+	platform_driver_unregister(&overo_driver);
 }
 module_exit(overo_soc_exit);
 
 MODULE_AUTHOR("Steve Sakoman <steve@sakoman.com>");
 MODULE_DESCRIPTION("ALSA SoC overo");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:overo-soc-audio");
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 0aae998..a14f4d4 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -408,14 +408,12 @@ static struct snd_soc_card rx51_sound_card = {
 	.num_configs = ARRAY_SIZE(rx51_codec_conf),
 };
 
-static struct platform_device *rx51_snd_device;
-
-static int __init rx51_soc_init(void)
+static int __devinit rx51_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
-	if (!machine_is_nokia_rx51())
-		return -ENODEV;
+	card->dev = &pdev->dev;
 
 	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,
 			       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "tvout_sel");
@@ -426,21 +424,14 @@ static int __init rx51_soc_init(void)
 	if (err)
 		goto err_gpio_eci_sw;
 
-	rx51_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!rx51_snd_device) {
-		err = -ENOMEM;
+	err = snd_soc_register_card(card);
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			err);
 		goto err1;
 	}
 
-	platform_set_drvdata(rx51_snd_device, &rx51_sound_card);
-
-	err = platform_device_add(rx51_snd_device);
-	if (err)
-		goto err2;
-
 	return 0;
-err2:
-	platform_device_put(rx51_snd_device);
 err1:
 	gpio_free(RX51_ECI_SW_GPIO);
 err_gpio_eci_sw:
@@ -450,19 +441,47 @@ err_gpio_tvout_sel:
 	return err;
 }
 
-static void __exit rx51_soc_exit(void)
+static int __devexit rx51_soc_remove(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
 	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
 				rx51_av_jack_gpios);
 
-	platform_device_unregister(rx51_snd_device);
+	snd_soc_unregister_card(card);
+
 	gpio_free(RX51_ECI_SW_GPIO);
 	gpio_free(RX51_TVOUT_SEL_GPIO);
+
+	return 0;
 }
 
+static struct platform_driver rx51_driver = {
+	.driver = {
+		.name = "rx51-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = rx51_soc_probe,
+	.remove = __devexit_p(rx51_soc_remove),
+};
+
+static int __init rx51_soc_init(void)
+{
+	if (!machine_is_nokia_rx51())
+		return -ENODEV;
+
+	return platform_driver_register(&rx51_driver);
+}
 module_init(rx51_soc_init);
+
+static void __exit rx51_soc_exit(void)
+{
+	platform_driver_unregister(&rx51_driver);
+}
 module_exit(rx51_soc_exit);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("ALSA SoC Nokia RX-51");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rx51-soc-audio");
diff --git a/sound/soc/omap/sdp3430.c b/sound/soc/omap/sdp3430.c
index 3f72d17..73e317e 100644
--- a/sound/soc/omap/sdp3430.c
+++ b/sound/soc/omap/sdp3430.c
@@ -289,24 +289,15 @@ static struct snd_soc_card snd_soc_sdp3430 = {
 	.num_links = ARRAY_SIZE(sdp3430_dai),
 };
 
-static struct platform_device *sdp3430_snd_device;
-
-static int __init sdp3430_soc_init(void)
+static int __devinit sdp3430_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_sdp3430;
 	int ret;
 	u8 pin_mux;
 
-	if (!machine_is_omap_3430sdp())
-		return -ENODEV;
-	printk(KERN_INFO "SDP3430 SoC init\n");
+	pr_info("SDP3430 SoC init\n");
 
-	sdp3430_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!sdp3430_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(sdp3430_snd_device, &snd_soc_sdp3430);
+	card->dev = &pdev->dev;
 
 	/* Set TWL4030 GPIO6 as EXTMUTE signal */
 	twl_i2c_read_u8(TWL4030_MODULE_INTBR, &pin_mux,
@@ -316,30 +307,54 @@ static int __init sdp3430_soc_init(void)
 	twl_i2c_write_u8(TWL4030_MODULE_INTBR, pin_mux,
 						TWL4030_INTBR_PMBR1);
 
-	ret = platform_device_add(sdp3430_snd_device);
-	if (ret)
-		goto err1;
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
+	}
 
 	return 0;
+}
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(sdp3430_snd_device);
+static int __devexit sdp3430_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	return ret;
+	snd_soc_jack_free_gpios(&hs_jack, ARRAY_SIZE(hs_jack_gpios),
+				hs_jack_gpios);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver sdp3430_driver = {
+	.driver = {
+		.name = "sdp3430-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = sdp3430_soc_probe,
+	.remove = __devexit_p(sdp3430_soc_remove),
+};
+
+static int __init sdp3430_soc_init(void)
+{
+	if (!machine_is_omap_3430sdp())
+		return -ENODEV;
+
+	return platform_driver_register(&sdp3430_driver);
 }
 module_init(sdp3430_soc_init);
 
 static void __exit sdp3430_soc_exit(void)
 {
-	snd_soc_jack_free_gpios(&hs_jack, ARRAY_SIZE(hs_jack_gpios),
-				hs_jack_gpios);
-
-	platform_device_unregister(sdp3430_snd_device);
+	platform_driver_unregister(&sdp3430_driver);
 }
 module_exit(sdp3430_soc_exit);
 
 MODULE_AUTHOR("Misael Lopez Cruz <x0052729@ti.com>");
 MODULE_DESCRIPTION("ALSA SoC SDP3430");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:sdp3430-soc-audio");
diff --git a/sound/soc/omap/sdp4430.c b/sound/soc/omap/sdp4430.c
index 189e039..9dfa9fd 100644
--- a/sound/soc/omap/sdp4430.c
+++ b/sound/soc/omap/sdp4430.c
@@ -215,47 +215,63 @@ static struct snd_soc_card snd_soc_sdp4430 = {
 	.num_links = 1,
 };
 
-static struct platform_device *sdp4430_snd_device;
-
-static int __init sdp4430_soc_init(void)
+static int __devinit sdp4430_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_sdp4430;
 	int ret;
 
-	if (!machine_is_omap_4430sdp())
-		return -ENODEV;
-	printk(KERN_INFO "SDP4430 SoC init\n");
+	pr_info("SDP4430 SoC init\n");
 
-	sdp4430_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!sdp4430_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(sdp4430_snd_device, &snd_soc_sdp4430);
+	card->dev = &pdev->dev;
 
-	ret = platform_device_add(sdp4430_snd_device);
-	if (ret)
-		goto err;
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		return ret;
+	}
 
 	/* Codec starts in HP mode */
 	twl6040_power_mode = 1;
 
 	return 0;
+}
 
-err:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(sdp4430_snd_device);
-	return ret;
+static int __devexit sdp4430_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver sdp4430_driver = {
+	.driver = {
+		.name = "sdp4430-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = sdp4430_soc_probe,
+	.remove = __devexit_p(sdp4430_soc_remove),
+};
+
+static int __init sdp4430_soc_init(void)
+{
+	if (!machine_is_omap_4430sdp())
+		return -ENODEV;
+
+	return platform_driver_register(&sdp4430_driver);
 }
 module_init(sdp4430_soc_init);
 
 static void __exit sdp4430_soc_exit(void)
 {
-	platform_device_unregister(sdp4430_snd_device);
+	platform_driver_unregister(&sdp4430_driver);
 }
 module_exit(sdp4430_soc_exit);
 
 MODULE_AUTHOR("Misael Lopez Cruz <x0052729@ti.com>");
 MODULE_DESCRIPTION("ALSA SoC SDP4430");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:sdp4430-soc-audio");
diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
index 0170994..15691e0 100644
--- a/sound/soc/omap/zoom2.c
+++ b/sound/soc/omap/zoom2.c
@@ -239,26 +239,14 @@ static struct snd_soc_card snd_soc_zoom2 = {
 	.num_links = ARRAY_SIZE(zoom2_dai),
 };
 
-static struct platform_device *zoom2_snd_device;
-
-static int __init zoom2_soc_init(void)
+static int __devinit zoom2_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &snd_soc_zoom2;
 	int ret;
 
-	if (!machine_is_omap_zoom2())
-		return -ENODEV;
-	printk(KERN_INFO "Zoom2 SoC init\n");
+	pr_info("Zoom2 SoC init\n");
 
-	zoom2_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!zoom2_snd_device) {
-		printk(KERN_ERR "Platform device allocation failed\n");
-		return -ENOMEM;
-	}
-
-	platform_set_drvdata(zoom2_snd_device, &snd_soc_zoom2);
-	ret = platform_device_add(zoom2_snd_device);
-	if (ret)
-		goto err1;
+	card->dev = &pdev->dev;
 
 	BUG_ON(gpio_request(ZOOM2_HEADSET_MUX_GPIO, "hs_mux") < 0);
 	gpio_direction_output(ZOOM2_HEADSET_MUX_GPIO, 0);
@@ -266,26 +254,60 @@ static int __init zoom2_soc_init(void)
 	BUG_ON(gpio_request(ZOOM2_HEADSET_EXTMUTE_GPIO, "ext_mute") < 0);
 	gpio_direction_output(ZOOM2_HEADSET_EXTMUTE_GPIO, 0);
 
+	ret = snd_soc_register_card(card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
+		goto err;
+	}
+
 	return 0;
 
-err1:
-	printk(KERN_ERR "Unable to add platform device\n");
-	platform_device_put(zoom2_snd_device);
+err:
+	gpio_free(ZOOM2_HEADSET_MUX_GPIO);
+	gpio_free(ZOOM2_HEADSET_EXTMUTE_GPIO);
 
 	return ret;
 }
-module_init(zoom2_soc_init);
 
-static void __exit zoom2_soc_exit(void)
+static int __devexit zoom2_soc_remove(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
 	gpio_free(ZOOM2_HEADSET_MUX_GPIO);
 	gpio_free(ZOOM2_HEADSET_EXTMUTE_GPIO);
 
-	platform_device_unregister(zoom2_snd_device);
+	return 0;
+}
+
+static struct platform_driver zoom2_driver = {
+	.driver = {
+		.name = "zoom2-soc-audio",
+		.owner = THIS_MODULE,
+	},
+
+	.probe = zoom2_soc_probe,
+	.remove = __devexit_p(zoom2_soc_remove),
+};
+
+static int __init zoom2_soc_init(void)
+{
+	if (!machine_is_omap_zoom2())
+		return -ENODEV;
+
+	return platform_driver_register(&zoom2_driver);
+}
+module_init(zoom2_soc_init);
+
+static void __exit zoom2_soc_exit(void)
+{
+	platform_driver_unregister(&zoom2_driver);
 }
 module_exit(zoom2_soc_exit);
 
 MODULE_AUTHOR("Misael Lopez Cruz <x0052729@ti.com>");
 MODULE_DESCRIPTION("ALSA SoC Zoom2");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:zoom2-soc-audio");
-- 
1.7.6.1

