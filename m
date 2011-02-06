Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1BFXDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:03:16 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1059 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753759Ab1BFXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:03:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 15254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/7] ASoC: Samsung: neo1973: Use gpio_request_array to request gpios
Date: Mon,  7 Feb 2011 00:04:21 +0100
Message-Id: <1297033463-14577-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gpio_request_array instead of requesting and setting up each gpio by hand
makes the code more readable and more compact.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/samsung/neo1973_gta02_wm8753.c |   36 +++++++----------------------
 1 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index b007dd79..62d2f39 100644
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
@@ -397,37 +402,15 @@ static int __init neo1973_gta02_init(void)
 	if (ret)
 		goto err_unregister_dai;
 
-	/* Initialise GPIOs used by amp */
-	ret = gpio_request(GTA02_GPIO_HP_IN, "GTA02_HP_IN");
+	ret = gpio_request_array(neo1973_gta02_gpios,
+				ARRAY_SIZE(neo1973_gta02_gpios));
 	if (ret) {
-		pr_err("gta02_wm8753: Failed to register GPIO %d\n", GTA02_GPIO_HP_IN);
+		pr_err("gta02_wm8753: Failed to request gpio\n");
 		goto err_del_device;
 	}
 
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
 err_del_device:
 	platform_device_del(neo1973_gta02_snd_device);
 err_unregister_dai:
@@ -440,10 +423,9 @@ module_init(neo1973_gta02_init);
 
 static void __exit neo1973_gta02_exit(void)
 {
+	gpio_free_array(neo1973_gta02_gpios, ARRAY_SIZE(neo1973_gta02_gpios));
 	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
 	platform_device_unregister(neo1973_gta02_snd_device);
-	gpio_free(GTA02_GPIO_HP_IN);
-	gpio_free(GTA02_GPIO_AMP_SHUT);
 }
 module_exit(neo1973_gta02_exit);
 
-- 
1.7.2.3

