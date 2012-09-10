Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2IJKrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:47:21 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:60695 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757351Ab2IJKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:57 -0400
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
Subject: [PATCH v4 14/14] ASoC: twl4030: Support for DT booted kernel
Date: Mon, 10 Sep 2012 13:46:32 +0300
Message-Id: <1347273992-9107-15-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel has been booted with DT blob the platform data is NULL for
the driver.
We need to construct the pdata based on the DT information for runtime use.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 55 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 8b13d50..8405ab9 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -26,6 +26,8 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
@@ -295,13 +297,57 @@ static inline void twl4030_reset_registers(struct snd_soc_codec *codec)
 
 }
 
-static void twl4030_init_chip(struct snd_soc_codec *codec)
+static void twl4030_setup_pdata_of(struct twl4030_codec_data *pdata,
+				   struct device_node *node)
+{
+	int value;
+
+	of_property_read_u32(node, "ti,digimic_delay",
+			     &pdata->digimic_delay);
+	of_property_read_u32(node, "ti,ramp_delay_value",
+			     &pdata->ramp_delay_value);
+	of_property_read_u32(node, "ti,offset_cncl_path",
+			     &pdata->offset_cncl_path);
+	if (!of_property_read_u32(node, "ti,hs_extmute", &value))
+		pdata->hs_extmute = value;
+
+	pdata->hs_extmute_gpio = of_get_named_gpio(node,
+						   "ti,hs_extmute_gpio", 0);
+	if (gpio_is_valid(pdata->hs_extmute_gpio))
+		pdata->hs_extmute = 1;
+}
+
+static struct twl4030_codec_data *twl4030_get_pdata(struct snd_soc_codec *codec)
 {
 	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
+	struct device_node *twl4030_codec_node = NULL;
+
+	twl4030_codec_node = of_find_node_by_name(codec->dev->parent->of_node,
+						  "codec");
+
+	if (!pdata && twl4030_codec_node) {
+		pdata = devm_kzalloc(codec->dev,
+				     sizeof(struct twl4030_codec_data),
+				     GFP_KERNEL);
+		if (!pdata) {
+			dev_err(codec->dev, "Can not allocate memory\n");
+			return NULL;
+		}
+		twl4030_setup_pdata_of(pdata, twl4030_codec_node);
+	}
+
+	return pdata;
+}
+
+static void twl4030_init_chip(struct snd_soc_codec *codec)
+{
+	struct twl4030_codec_data *pdata;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	u8 reg, byte;
 	int i = 0;
 
+	pdata = twl4030_get_pdata(codec);
+
 	if (pdata && pdata->hs_extmute &&
 	    gpio_is_valid(pdata->hs_extmute_gpio)) {
 		int ret;
@@ -2284,13 +2330,6 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "platform_data is missing\n");
-		return -EINVAL;
-	}
-
 	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_twl4030,
 			twl4030_dai, ARRAY_SIZE(twl4030_dai));
 }
-- 
1.7.12

