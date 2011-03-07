Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1CGHEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:04:07 -0500
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1068 "HELO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754052Ab1CGHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:03:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8276
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Jassi Brar <jassi.brar@samsung.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/7] ASoC: neo1973_gta02_wm8753: Use gpio_request_array to request gpios
Date: Mon,  7 Mar 2011 08:04:57 +0100
Message-Id: <1299481500-5481-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299481500-5481-1-git-send-email-lars@metafoo.de>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gpio_request_array instead of requesting and setting up each gpio by hand
makes the code more readable and more compact.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/samsung/neo1973_gta02_wm8753.c |   52 ++++++++++--------------------
 1 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index b007dd79..28d8448 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -370,6 +370,11 @@ static struct snd_soc_card neo1973_gta02 = {
 	.num_links = ARRAY_SIZE(neo1973_gta02_dai),
 };
 
+static const struct gpio neo1973_gta02_gpios[] = {
+	{ GTA02_GPIO_HP_IN, GPIOF_OUT_INIT_HIGH, "GTA02_HP_IN" },
+	{ GTA02_GPIO_AMP_SHUT, GPIOF_OUT_INIT_HIGH, "GTA02_AMP_SHUT" },
+};
+
 static struct platform_device *neo1973_gta02_snd_device;
 
 static int __init neo1973_gta02_init(void)
@@ -382,9 +387,16 @@ static int __init neo1973_gta02_init(void)
 		return -ENODEV;
 	}
 
+	ret = gpio_request_array(neo1973_gta02_gpios,
+				ARRAY_SIZE(neo1973_gta02_gpios));
+	if (ret)
+		return ret;
+
 	neo1973_gta02_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!neo1973_gta02_snd_device)
-		return -ENOMEM;
+	if (!neo1973_gta02_snd_device) {
+		ret = -ENOMEM;
+		goto err_gpio_free;
+	}
 
 	/* register bluetooth DAI here */
 	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
@@ -397,43 +409,14 @@ static int __init neo1973_gta02_init(void)
 	if (ret)
 		goto err_unregister_dai;
 
-	/* Initialise GPIOs used by amp */
-	ret = gpio_request(GTA02_GPIO_HP_IN, "GTA02_HP_IN");
-	if (ret) {
-		pr_err("gta02_wm8753: Failed to register GPIO %d\n", GTA02_GPIO_HP_IN);
-		goto err_del_device;
-	}
-
-	ret = gpio_direction_output(GTA02_GPIO_HP_IN, 1);
-	if (ret) {
-		pr_err("gta02_wm8753: Failed to configure GPIO %d\n", GTA02_GPIO_HP_IN);
-		goto err_free_gpio_hp_in;
-	}
-
-	ret = gpio_request(GTA02_GPIO_AMP_SHUT, "GTA02_AMP_SHUT");
-	if (ret) {
-		pr_err("gta02_wm8753: Failed to register GPIO %d\n", GTA02_GPIO_AMP_SHUT);
-		goto err_free_gpio_hp_in;
-	}
-
-	ret = gpio_direction_output(GTA02_GPIO_AMP_SHUT, 1);
-	if (ret) {
-		pr_err("gta02_wm8753: Failed to configure GPIO %d\n", GTA02_GPIO_AMP_SHUT);
-		goto err_free_gpio_amp_shut;
-	}
-
 	return 0;
 
-err_free_gpio_amp_shut:
-	gpio_free(GTA02_GPIO_AMP_SHUT);
-err_free_gpio_hp_in:
-	gpio_free(GTA02_GPIO_HP_IN);
-err_del_device:
-	platform_device_del(neo1973_gta02_snd_device);
 err_unregister_dai:
 	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
 err_put_device:
 	platform_device_put(neo1973_gta02_snd_device);
+err_gpio_free:
+	gpio_free_array(neo1973_gta02_gpios, ARRAY_SIZE(neo1973_gta02_gpios));
 	return ret;
 }
 module_init(neo1973_gta02_init);
@@ -442,8 +425,7 @@ static void __exit neo1973_gta02_exit(void)
 {
 	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
 	platform_device_unregister(neo1973_gta02_snd_device);
-	gpio_free(GTA02_GPIO_HP_IN);
-	gpio_free(GTA02_GPIO_AMP_SHUT);
+	gpio_free_array(neo1973_gta02_gpios, ARRAY_SIZE(neo1973_gta02_gpios));
 }
 module_exit(neo1973_gta02_exit);
 
-- 
1.7.2.3

