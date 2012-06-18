Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2FRRX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:23:27 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:54778 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877Ab2FRRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:23:26 -0400
From: Roland Stigge <stigge@antcom.de>
To: broonie@opensource.wolfsonmicro.com, swarren@wwwdotorg.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] sound/gpio: of_get_named_gpio() return -EPROBE_DEFER if GPIO deferred
Date: Mon, 18 Jun 2012 19:22:56 +0200
Message-Id: <1340040176-16553-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
respective GPIO is not (yet) available. This is useful if driver's probe()
functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
can be probed again later on.

The function still returns -EINVAL on other errors (parse error or node doesn't
exist). This way, the case of an optional/intentionally missing GPIO is handled
appropriately.

For this change, two sound drivers (tegra_{alc5632,wm8903}) need to be
adjusted.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpiolib-of.c       |    5 ++++-
 sound/soc/tegra/tegra_alc5632.c |    2 +-
 sound/soc/tegra/tegra_wm8903.c  |   10 +++++-----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d18068a..9f84fad 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -62,7 +62,10 @@ static int of_gpiochip_find_and_xlate(struct gpio_chip *gc, void *data)
 int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                            int index, enum of_gpio_flags *flags)
 {
-	struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
+	/* Return -EPROBE_DEFER to support probe() functions to be called
+	 * later when the GPIO actually becomes available
+	 */
+	struct gg_data gg_data = { .flags = flags, .out_gpio = -EPROBE_DEFER };
 	int ret;
 
 	/* .of_xlate might decide to not fill in the flags, so clear it. */
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index d684df2..e463529 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -177,7 +177,7 @@ static __devinit int tegra_alc5632_probe(struct platform_device *pdev)
 	}
 
 	alc5632->gpio_hp_det = of_get_named_gpio(np, "nvidia,hp-det-gpios", 0);
-	if (alc5632->gpio_hp_det == -ENODEV)
+	if (alc5632->gpio_hp_det == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 0c5bb33..d4f14e4 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -284,27 +284,27 @@ static __devinit int tegra_wm8903_driver_probe(struct platform_device *pdev)
 	} else if (np) {
 		pdata->gpio_spkr_en = of_get_named_gpio(np,
 						"nvidia,spkr-en-gpios", 0);
-		if (pdata->gpio_spkr_en == -ENODEV)
+		if (pdata->gpio_spkr_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_hp_mute = of_get_named_gpio(np,
 						"nvidia,hp-mute-gpios", 0);
-		if (pdata->gpio_hp_mute == -ENODEV)
+		if (pdata->gpio_hp_mute == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_hp_det = of_get_named_gpio(np,
 						"nvidia,hp-det-gpios", 0);
-		if (pdata->gpio_hp_det == -ENODEV)
+		if (pdata->gpio_hp_det == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_int_mic_en = of_get_named_gpio(np,
 						"nvidia,int-mic-en-gpios", 0);
-		if (pdata->gpio_int_mic_en == -ENODEV)
+		if (pdata->gpio_int_mic_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		pdata->gpio_ext_mic_en = of_get_named_gpio(np,
 						"nvidia,ext-mic-en-gpios", 0);
-		if (pdata->gpio_ext_mic_en == -ENODEV)
+		if (pdata->gpio_ext_mic_en == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 	}
 
-- 
1.7.10

