Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2EZAWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:22:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35200 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2EZAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:22:18 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH] ASoC: make snd_soc_dai_link more symmetrical
Date: Fri, 25 May 2012 18:22:11 -0600
Message-Id: <1337991731-12149-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Prior to this patch, the CPU side of a DAI link was specified using a
single name. Often, this was the result of calling dev_name() on the
device providing the DAI, but in the case of a CPU DAI driver that
provided multiple DAIs, it needed to mix together both the device name
and some device-relative name, in order to form a single globally unique
name.

However, the CODEC side of the DAI link was specified using separate
fields for device (name or OF node) and device-relative DAI name.

This patch allows the CPU side of a DAI link to be specified in the same
way as the CODEC side, separating concepts of device and device-relative
DAI name.

I believe this will be important in multi-codec and/or dynamic PCM
scenarios, where a single CPU driver provides multiple DAIs, while also
booting using device tree, with accompanying desire not to hard-code the
CPU side device's name into the original .cpu_dai_name field.

Ideally, both the CPU DAI and CODEC DAI loops in soc_bind_dai_link()
would now be identical. However, two things prevent that at present:

1) The need to save rtd->codec for the CODEC side, which means we have
to search for the CODEC explicitly, and not just the CODEC side DAI.

2) Since we know the CODEC side DAI is part of a codec, and not just
a standalone DAI, it's slightly more efficient to convert .codec_name/
.codec_of_node into a codec first, and then compare each DAI's .codec
field, since this avoids strcmp() on each DAI's CODEC's name within
the loop.

However, the two loops are essentially semantically equivalent.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Following on from this, it seems like rtd->codec is ripe for removal.
Since in fact there can be more than one codec per DAI link, having such
a top-level variable seems wrong . Any code that needs that value should
be able to access rtd->codec_dai->codec.

However, there are some sysfs files that rely on that value being either
rtd-codec_dai->codec *or* being the aux dev codec, which scuppers that
plan. Are those sysfs files still useful; they are "codec_reg" and
"dapm_widget" which are both in debugfs. I don't see either file documented
in Documentation/ anywhere, so it seems it shouldn't be an ABI people are
relying upon.

If we could remove those, it paves the way to not storing aux devs in an
rtd, but a standalone array of devices right in the card.

Am I way off base or going the wrong direction in my thinking here; I feel
I must be missing something...

 include/sound/soc.h             |   33 ++++++++++++++++++++++++++----
 sound/soc/mxs/mxs-sgtl5000.c    |    2 +-
 sound/soc/soc-core.c            |   42 ++++++++++++++++++++++++++++----------
 sound/soc/tegra/tegra_alc5632.c |    6 ++--
 sound/soc/tegra/tegra_wm8753.c  |    6 ++--
 sound/soc/tegra/tegra_wm8903.c  |    6 ++--
 sound/soc/tegra/trimslice.c     |    6 ++--
 7 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index c703871..23c4efb 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -785,13 +785,36 @@ struct snd_soc_dai_link {
 	/* config - must be set by machine driver */
 	const char *name;			/* Codec name */
 	const char *stream_name;		/* Stream name */
-	const char *codec_name;		/* for multi-codec */
-	const struct device_node *codec_of_node;
-	const char *platform_name;	/* for multi-platform */
-	const struct device_node *platform_of_node;
+	/*
+	 * You MAY specify the link's CPU-side device, either by device name,
+	 * or by DT/OF node, but not both. If this information is omitted,
+	 * the CPU-side DAI is matched using .cpu_dai_name only, which hence
+	 * must be globally unique. These fields are currently typically used
+	 * only for codec to codec links, or systems using device tree.
+	 */
+	const char *cpu_name;
+	const struct device_node *cpu_of_node;
+	/*
+	 * You MAY specify the DAI name of the CPU DAI. If this information is
+	 * omitted, the CPU-side DAI is matched using .cpu_name/.cpu_of_node
+	 * only, which only works well when that device exposes a single DAI.
+	 */
 	const char *cpu_dai_name;
-	const struct device_node *cpu_dai_of_node;
+	/*
+	 * You MUST specify the link's codec, either by device name, or by
+	 * DT/OF node, but not both.
+	 */
+	const char *codec_name;
+	const struct device_node *codec_of_node;
+	/* You MUST specify the DAI name within the codec */
 	const char *codec_dai_name;
+	/*
+	 * You MAY specify the link's platform/PCM/DMA driver, either by
+	 * device name, or by DT/OF node, but not both. Some forms of link
+	 * do not need a platform.
+	 */
+	const char *platform_name;
+	const struct device_node *platform_of_node;
 	int be_id;	/* optional ID for machine driver BE identification */
 
 	const struct snd_soc_pcm_stream *params;
diff --git a/sound/soc/mxs/mxs-sgtl5000.c b/sound/soc/mxs/mxs-sgtl5000.c
index 3e6e876..215113b 100644
--- a/sound/soc/mxs/mxs-sgtl5000.c
+++ b/sound/soc/mxs/mxs-sgtl5000.c
@@ -133,7 +133,7 @@ static int __devinit mxs_sgtl5000_probe_dt(struct platform_device *pdev)
 		mxs_sgtl5000_dai[i].codec_name = NULL;
 		mxs_sgtl5000_dai[i].codec_of_node = codec_np;
 		mxs_sgtl5000_dai[i].cpu_dai_name = NULL;
-		mxs_sgtl5000_dai[i].cpu_dai_of_node = saif_np[i];
+		mxs_sgtl5000_dai[i].cpu_of_node = saif_np[i];
 		mxs_sgtl5000_dai[i].platform_name = NULL;
 		mxs_sgtl5000_dai[i].platform_of_node = saif_np[i];
 	}
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b37ee80..ec83505 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -812,13 +812,15 @@ static int soc_bind_dai_link(struct snd_soc_card *card, int num)
 
 	/* Find CPU DAI from registered DAIs*/
 	list_for_each_entry(cpu_dai, &dai_list, list) {
-		if (dai_link->cpu_dai_of_node) {
-			if (cpu_dai->dev->of_node != dai_link->cpu_dai_of_node)
-				continue;
-		} else {
-			if (strcmp(cpu_dai->name, dai_link->cpu_dai_name))
-				continue;
-		}
+		if (dai_link->cpu_of_node &&
+		    (cpu_dai->dev->of_node != dai_link->cpu_of_node))
+			continue;
+		if (dai_link->cpu_name &&
+		    strcmp(dev_name(cpu_dai->dev), dai_link->cpu_name))
+			continue;
+		if (dai_link->cpu_dai_name &&
+		    strcmp(cpu_dai->name, dai_link->cpu_dai_name))
+			continue;
 
 		rtd->cpu_dai = cpu_dai;
 	}
@@ -3346,6 +3348,12 @@ int snd_soc_register_card(struct snd_soc_card *card)
 				link->name);
 			return -EINVAL;
 		}
+		/* Codec DAI name must be specified */
+		if (!link->codec_dai_name) {
+			dev_err(card->dev, "codec_dai_name not set for %s\n",
+				link->name);
+			return -EINVAL;
+		}
 
 		/*
 		 * Platform may be specified by either name or OF node, but
@@ -3358,12 +3366,24 @@ int snd_soc_register_card(struct snd_soc_card *card)
 		}
 
 		/*
-		 * CPU DAI must be specified by 1 of name or OF node,
-		 * not both or neither.
+		 * CPU device may be specified by either name or OF node, but
+		 * can be left unspecified, and will be matched based on DAI
+		 * name alone..
+		 */
+		if (link->cpu_name && link->cpu_of_node) {
+			dev_err(card->dev,
+				"Neither/both cpu name/of_node are set for %s\n",
+				link->name);
+			return -EINVAL;
+		}
+		/*
+		 * At least one of CPU DAI name or CPU device name/node must be
+		 * specified
 		 */
-		if (!!link->cpu_dai_name == !!link->cpu_dai_of_node) {
+		if (!link->cpu_dai_name &&
+		    !(link->cpu_name || link->cpu_of_node)) {
 			dev_err(card->dev,
-				"Neither/both cpu_dai name/of_node are set for %s\n",
+				"Neither cpu_dai_name nor cpu_name/of_node are set for %s\n",
 				link->name);
 			return -EINVAL;
 		}
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index 1566957..417b09b 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -197,16 +197,16 @@ static __devinit int tegra_alc5632_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	tegra_alc5632_dai.cpu_dai_of_node = of_parse_phandle(
+	tegra_alc5632_dai.cpu_of_node = of_parse_phandle(
 			pdev->dev.of_node, "nvidia,i2s-controller", 0);
-	if (!tegra_alc5632_dai.cpu_dai_of_node) {
+	if (!tegra_alc5632_dai.cpu_of_node) {
 		dev_err(&pdev->dev,
 		"Property 'nvidia,i2s-controller' missing or invalid\n");
 		ret = -EINVAL;
 		goto err;
 	}
 
-	tegra_alc5632_dai.platform_of_node = tegra_alc5632_dai.cpu_dai_of_node;
+	tegra_alc5632_dai.platform_of_node = tegra_alc5632_dai.cpu_of_node;
 
 	ret = tegra_asoc_utils_init(&alc5632->util_data, &pdev->dev);
 	if (ret)
diff --git a/sound/soc/tegra/tegra_wm8753.c b/sound/soc/tegra/tegra_wm8753.c
index 4e77026..02bd5a8 100644
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -157,9 +157,9 @@ static __devinit int tegra_wm8753_driver_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	tegra_wm8753_dai.cpu_dai_of_node = of_parse_phandle(
+	tegra_wm8753_dai.cpu_of_node = of_parse_phandle(
 			pdev->dev.of_node, "nvidia,i2s-controller", 0);
-	if (!tegra_wm8753_dai.cpu_dai_of_node) {
+	if (!tegra_wm8753_dai.cpu_of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
 		ret = -EINVAL;
@@ -167,7 +167,7 @@ static __devinit int tegra_wm8753_driver_probe(struct platform_device *pdev)
 	}
 
 	tegra_wm8753_dai.platform_of_node =
-				tegra_wm8753_dai.cpu_dai_of_node;
+				tegra_wm8753_dai.cpu_of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index b75e0e8..1fd71e5 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -331,9 +331,9 @@ static __devinit int tegra_wm8903_driver_probe(struct platform_device *pdev)
 		}
 
 		tegra_wm8903_dai.cpu_dai_name = NULL;
-		tegra_wm8903_dai.cpu_dai_of_node = of_parse_phandle(np,
+		tegra_wm8903_dai.cpu_of_node = of_parse_phandle(np,
 				"nvidia,i2s-controller", 0);
-		if (!tegra_wm8903_dai.cpu_dai_of_node) {
+		if (!tegra_wm8903_dai.cpu_of_node) {
 			dev_err(&pdev->dev,
 				"Property 'nvidia,i2s-controller' missing or invalid\n");
 			ret = -EINVAL;
@@ -342,7 +342,7 @@ static __devinit int tegra_wm8903_driver_probe(struct platform_device *pdev)
 
 		tegra_wm8903_dai.platform_name = NULL;
 		tegra_wm8903_dai.platform_of_node =
-					tegra_wm8903_dai.cpu_dai_of_node;
+					tegra_wm8903_dai.cpu_of_node;
 	} else {
 		card->dapm_routes = harmony_audio_map;
 		card->num_dapm_routes = ARRAY_SIZE(harmony_audio_map);
diff --git a/sound/soc/tegra/trimslice.c b/sound/soc/tegra/trimslice.c
index 4a8d5b6..5815430 100644
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -162,9 +162,9 @@ static __devinit int tegra_snd_trimslice_probe(struct platform_device *pdev)
 		}
 
 		trimslice_tlv320aic23_dai.cpu_dai_name = NULL;
-		trimslice_tlv320aic23_dai.cpu_dai_of_node = of_parse_phandle(
+		trimslice_tlv320aic23_dai.cpu_of_node = of_parse_phandle(
 				pdev->dev.of_node, "nvidia,i2s-controller", 0);
-		if (!trimslice_tlv320aic23_dai.cpu_dai_of_node) {
+		if (!trimslice_tlv320aic23_dai.cpu_of_node) {
 			dev_err(&pdev->dev,
 				"Property 'nvidia,i2s-controller' missing or invalid\n");
 			ret = -EINVAL;
@@ -173,7 +173,7 @@ static __devinit int tegra_snd_trimslice_probe(struct platform_device *pdev)
 
 		trimslice_tlv320aic23_dai.platform_name = NULL;
 		trimslice_tlv320aic23_dai.platform_of_node =
-				trimslice_tlv320aic23_dai.cpu_dai_of_node;
+				trimslice_tlv320aic23_dai.cpu_of_node;
 	}
 
 	ret = tegra_asoc_utils_init(&trimslice->util_data, &pdev->dev);
-- 
1.7.0.4

