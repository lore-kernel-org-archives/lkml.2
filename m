Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2IJKqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:46 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36860 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257Ab2IJKqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:32 -0400
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
Subject: [PATCH v4 07/14] MFD: twl4030-audio: Add DT support
Date: Mon, 10 Sep 2012 13:46:25 +0300
Message-Id: <1347273992-9107-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for loading the twl4030 audio module via devicetree.
Sub devices for codec and vibra will be created as mfd devices once the
core MFD driver is loaded when the kernel is booted with a DT blob.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/mfd/twl4030-audio.txt      | 46 ++++++++++++++++++
 drivers/mfd/twl4030-audio.c                        | 54 +++++++++++++++++++---
 2 files changed, 93 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-audio.txt

diff --git a/Documentation/devicetree/bindings/mfd/twl4030-audio.txt b/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
new file mode 100644
index 0000000..414d2ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
@@ -0,0 +1,46 @@
+Texas Instruments TWL family (twl4030) audio module
+
+The audio module inside the TWL family consist of an audio codec and a vibra
+driver.
+
+Required properties:
+- compatible : must be "ti,twl4030-audio"
+
+Optional properties, nodes:
+
+Audio functionality:
+- codec { }: Need to be present if the audio functionality is used. Within this
+	     section the following options can be used:
+- ti,digimic_delay: Delay need after enabling the digimic to reduce artifacts
+		    from the start of the recorded sample (in ms)
+-ti,ramp_delay_value: HS ramp delay configuration to reduce pop noise
+-ti,hs_extmute: Use external mute for HS pop reduction
+-ti,hs_extmute_gpio: Use external GPIO to control the external mute
+-ti,offset_cncl_path: Offset cancellation path selection, refer to TRM for the
+		      valid values.
+
+Vibra functionality
+- ti,enable-vibra: Need to be set to <1> if the vibra functionality is used. if
+		   missing or it is 0, the vibra functionality is disabled.
+
+Example:
+&i2c1 {
+	clock-frequency = <2600000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+
+		twl_audio: audio {
+			compatible = "ti,twl4030-audio";
+
+			ti,enable-vibra = <1>;
+
+			codec {
+				ti,ramp_delay_value = <3>;
+			};
+
+		};
+	};
+};
diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index a48bf3a..58e6c22 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -28,6 +28,8 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/i2c/twl.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl4030-audio.h>
@@ -156,15 +158,42 @@ unsigned int twl4030_audio_get_mclk(void)
 }
 EXPORT_SYMBOL_GPL(twl4030_audio_get_mclk);
 
+static bool twl4030_audio_has_codec(struct twl4030_audio_data *pdata,
+			      struct device_node *node)
+{
+	if (pdata && pdata->codec)
+		return true;
+
+	if (of_find_node_by_name(node, "codec"))
+		return true;
+
+	return false;
+}
+
+static bool twl4030_audio_has_vibra(struct twl4030_audio_data *pdata,
+			      struct device_node *node)
+{
+	int vibra;
+
+	if (pdata && pdata->vibra)
+		return true;
+
+	if (!of_property_read_u32(node, "ti,enable-vibra", &vibra) && vibra)
+		return true;
+
+	return false;
+}
+
 static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 {
 	struct twl4030_audio *audio;
 	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	struct mfd_cell *cell = NULL;
 	int ret, childs = 0;
 	u8 val;
 
-	if (!pdata) {
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "Platform data is missing\n");
 		return -EINVAL;
 	}
@@ -202,18 +231,22 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 	audio->resource[TWL4030_AUDIO_RES_APLL].reg = TWL4030_REG_APLL_CTL;
 	audio->resource[TWL4030_AUDIO_RES_APLL].mask = TWL4030_APLL_EN;
 
-	if (pdata->codec) {
+	if (twl4030_audio_has_codec(pdata, node)) {
 		cell = &audio->cells[childs];
 		cell->name = "twl4030-codec";
-		cell->platform_data = pdata->codec;
-		cell->pdata_size = sizeof(*pdata->codec);
+		if (pdata) {
+			cell->platform_data = pdata->codec;
+			cell->pdata_size = sizeof(*pdata->codec);
+		}
 		childs++;
 	}
-	if (pdata->vibra) {
+	if (twl4030_audio_has_vibra(pdata, node)) {
 		cell = &audio->cells[childs];
 		cell->name = "twl4030-vibra";
-		cell->platform_data = pdata->vibra;
-		cell->pdata_size = sizeof(*pdata->vibra);
+		if (pdata) {
+			cell->platform_data = pdata->vibra;
+			cell->pdata_size = sizeof(*pdata->vibra);
+		}
 		childs++;
 	}
 
@@ -245,10 +278,17 @@ static int __devexit twl4030_audio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id twl4030_audio_of_match[] = {
+	{.compatible = "ti,twl4030-audio", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl4030_audio_of_match);
+
 static struct platform_driver twl4030_audio_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "twl4030-audio",
+		.of_match_table = twl4030_audio_of_match,
 	},
 	.probe		= twl4030_audio_probe,
 	.remove		= __devexit_p(twl4030_audio_remove),
-- 
1.7.12

