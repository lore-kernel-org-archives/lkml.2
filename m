Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3ADJzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:55:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47083 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab3ADJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:54:34 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lrg@ti.com>, <perex@perex.cz>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: [PATCH V2 2/2] ASoC: Davinci: machine: Add device tree binding
Date: Fri, 4 Jan 2013 15:24:37 +0530
Message-ID: <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>

Device tree support for Davinci Machine driver

When the board boots with device tree, the driver will receive card,
codec, dai interface details (like the card name, DAPM routing map,
phandle for the audio components described in the dts file, codec mclk
speed).
The card will be set up based on this information.
Since the routing is provided via DT we can mark the card fully routed
so core can take care of disconnecting the unused pins.

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
---
Changes in V2
	 - Remove reference to Linux & software details from DT binding

:000000 100644 0000000... 25f7180... A	Documentation/devicetree/bindings/sound/davinci-evm-audio.txt
:100644 100644 d55e647... 91a32e5... M	sound/soc/davinci/davinci-evm.c
 .../bindings/sound/davinci-evm-audio.txt           |   53 ++++++
 sound/soc/davinci/davinci-evm.c                    |  179 +++++++++++++++++---
 2 files changed, 212 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/davinci-evm-audio.txt b/Documentation/devicetree/bindings/sound/davinci-evm-audio.txt
new file mode 100644
index 0000000..25f7180
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/davinci-evm-audio.txt
@@ -0,0 +1,53 @@
+* Texas Instruments SoC audio setups with TLV320AIC3X Codec
+
+Required properties:
+- compatible :
+	"ti,dm365-voice-codec-audio"	: for DM365 platforms with Voice Codec
+	"ti,da830-evm-audio"		: for DM365/DA8xx/OMAPL1x/AM33xx
+
+- ti,model : The user-visible name of this sound complex.
+- ti,audio-codec : The phandle of the TLV320AIC3x audio codec
+- ti,mcasp-controller : The phandle of the McASP controller
+- ti,codec-clock-rate : The Codec Clock rate (in Hz) applied to the Codec
+- ti,audio-routing : A list of the connections between audio components.
+  Each entry is a pair of strings, the first being the connection's sink,
+  the second being the connection's source. Valid names for sources and
+  sinks are the codec's pins, and the jacks on the board:
+
+  Codec pins:
+
+  * MIC3L
+  * MIC3R
+  * LINE1L
+  * LINE2L
+  * LINE1R
+  * LINE2R
+
+  Board connectors:
+
+  * Headphone Jack
+  * Line Out
+  * Mic Jack
+
+
+Example:
+
+sound {
+	compatible = "ti,da830-evm-audio";
+	ti,model = "DA830 EVM";
+	ti,audio-codec = <&tlv320aic3x>;
+	ti,mcasp-controller = <&mcasp1>;
+	ti,codec-clock-rate = <12000000>;
+	ti,audio-routing =
+		"Headphone Jack",       "HPLOUT",
+		"Headphone Jack",       "HPROUT",
+		"Line Out",             "LLOUT",
+		"Line Out",             "RLOUT",
+		"MIC3L",                "Mic Bias 2V",
+		"MIC3R",                "Mic Bias 2V",
+		"Mic Bias 2V",          "Mic Jack",
+		"LINE1L",               "Line In",
+		"LINE2L",               "Line In",
+		"LINE1R",               "Line In",
+		"LINE2R",               "Line In";
+};
diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index d55e647..91a32e5 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
+#include <linux/of_platform.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
@@ -34,27 +35,38 @@ static int evm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_dai *codec_dai = rtd->codec_dai;
 	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_card *soc_card = codec->card;
+	struct device_node *np = soc_card->dev->of_node;
 	int ret = 0;
 	unsigned sysclk;
 
-	/* ASP1 on DM355 EVM is clocked by an external oscillator */
-	if (machine_is_davinci_dm355_evm() || machine_is_davinci_dm6467_evm() ||
-	    machine_is_davinci_dm365_evm())
-		sysclk = 27000000;
-
-	/* ASP0 in DM6446 EVM is clocked by U55, as configured by
-	 * board-dm644x-evm.c using GPIOs from U18.  There are six
-	 * options; here we "know" we use a 48 KHz sample rate.
-	 */
-	else if (machine_is_davinci_evm())
-		sysclk = 12288000;
-
-	else if (machine_is_davinci_da830_evm() ||
-				machine_is_davinci_da850_evm())
-		sysclk = 24576000;
-
-	else
-		return -EINVAL;
+	if (np) {
+		ret = of_property_read_u32(np, "ti,codec-clock-rate", &sysclk);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* ASP1 on DM355 EVM is clocked by an external oscillator */
+		if (machine_is_davinci_dm355_evm() ||
+			machine_is_davinci_dm6467_evm() ||
+			machine_is_davinci_dm365_evm())
+			sysclk = 27000000;
+
+		/*
+		 * ASP0 in DM6446 EVM is clocked by U55, as configured by
+		 * board-dm644x-evm.c using GPIOs from U18.  There are six
+		 * options; here we "know" we use a 48 KHz sample rate.
+		 */
+		else if (machine_is_davinci_evm())
+			sysclk = 12288000;
+
+		else if (machine_is_davinci_da830_evm() ||
+					machine_is_davinci_da850_evm())
+			sysclk = 24576000;
+
+		else
+			return -EINVAL;
+	}
 
 	/* set codec DAI configuration */
 	ret = snd_soc_dai_set_fmt(codec_dai, AUDIO_FORMAT);
@@ -132,13 +144,22 @@ static int evm_aic3x_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	struct device_node *np = codec->card->dev->of_node;
+	int ret;
 
 	/* Add davinci-evm specific widgets */
 	snd_soc_dapm_new_controls(dapm, aic3x_dapm_widgets,
 				  ARRAY_SIZE(aic3x_dapm_widgets));
 
-	/* Set up davinci-evm specific audio path audio_map */
-	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
+	if (np) {
+		ret = snd_soc_of_parse_audio_routing(codec->card,
+							"ti,audio-routing");
+		if (ret)
+			return ret;
+	} else {
+		/* Set up davinci-evm specific audio path audio_map */
+		snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
+	}
 
 	/* not connected */
 	snd_soc_dapm_disable_pin(dapm, "MONO_LOUT");
@@ -287,6 +308,108 @@ static struct snd_soc_card da850_snd_soc_card = {
 	.num_links = 1,
 };
 
+#if defined(CONFIG_OF)
+
+enum {
+	MACHINE_VERSION_1 = 0,	/* DM365 with Voice Codec */
+	MACHINE_VERSION_2,	/* DM365/DA8xx/OMAPL1x/AM33xx */
+};
+
+static const struct of_device_id davinci_evm_dt_ids[] = {
+	{
+		.compatible = "ti,dm365-voice-codec-audio",
+		.data = (void *)MACHINE_VERSION_1,
+	},
+	{
+		.compatible = "ti,da830-evm-audio",
+		.data = (void *)MACHINE_VERSION_2,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, davinci_mcasp_dt_ids);
+
+/*
+ * This struct is just used as place holder. It will be filled with
+ * data from dt node
+ */
+static struct snd_soc_dai_link evm_dai = {
+	.name		= "TLV320AIC3X",
+	.stream_name	= "AIC3X",
+	.codec_dai_name	= "tlv320aic3x-hifi",
+};
+
+/* davinci evm audio machine driver */
+static struct snd_soc_card evm_soc_card = {
+	.owner = THIS_MODULE,
+	.dai_link = &evm_dai,
+	.num_links = 1,
+};
+
+static int davinci_evm_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match =
+		of_match_device(of_match_ptr(davinci_evm_dt_ids), &pdev->dev);
+	u32 machine_ver;
+	int ret = 0;
+
+	machine_ver = (u32)match->data;
+	switch (machine_ver) {
+	case MACHINE_VERSION_1:
+		evm_dai.name		= "Voice Codec - CQ93VC";
+		evm_dai.stream_name	= "CQ93";
+		evm_dai.codec_dai_name	= "cq93vc-hifi";
+		break;
+
+	case MACHINE_VERSION_2:
+		evm_dai.ops = &evm_ops;
+		evm_dai.init = evm_aic3x_init;
+		break;
+	}
+
+	evm_dai.codec_of_node = of_parse_phandle(np, "ti,audio-codec", 0);
+	if (!evm_dai.codec_of_node)
+		return -EINVAL;
+
+	evm_dai.cpu_of_node = of_parse_phandle(np,
+						"ti,mcasp-controller", 0);
+	if (!evm_dai.cpu_of_node)
+		return -EINVAL;
+
+	evm_dai.platform_of_node = evm_dai.cpu_of_node;
+
+	evm_soc_card.dev = &pdev->dev;
+	ret = snd_soc_of_parse_card_name(&evm_soc_card, "ti,model");
+	if (ret)
+		return ret;
+
+	ret = snd_soc_register_card(&evm_soc_card);
+	if (ret)
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+
+	return ret;
+}
+
+static int __devexit davinci_evm_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver davinci_evm_driver = {
+	.probe		= davinci_evm_probe,
+	.remove		= __devexit_p(davinci_evm_remove),
+	.driver		= {
+		.name	= "davinci_evm",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(davinci_evm_dt_ids),
+	},
+};
+#endif
+
 static struct platform_device *evm_snd_device;
 
 static int __init evm_init(void)
@@ -295,6 +418,15 @@ static int __init evm_init(void)
 	int index;
 	int ret;
 
+#if defined(CONFIG_OF)
+	/*
+	 * If dtb is there, the devices will be created dynamically.
+	 * Only register platfrom driver structure.
+	 */
+	if (of_have_populated_dt())
+		return platform_driver_register(&davinci_evm_driver);
+#endif
+
 	if (machine_is_davinci_evm()) {
 		evm_snd_dev_data = &dm6446_snd_soc_card_evm;
 		index = 0;
@@ -330,6 +462,13 @@ static int __init evm_init(void)
 
 static void __exit evm_exit(void)
 {
+#if defined(CONFIG_OF)
+	if (of_have_populated_dt()) {
+		platform_driver_unregister(&davinci_evm_driver);
+		return;
+	}
+#endif
+
 	platform_device_unregister(evm_snd_device);
 }
 
-- 
1.7.9.5

