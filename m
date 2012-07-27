Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2G0Mtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:49:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2G0MqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:46:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/18] ASoC: Ux500: Enable MOP500 driver for Device Tree
Date: Fri, 27 Jul 2012 13:45:47 +0100
Message-Id: <1343393162-11938-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we ensure that the MOP500 audio driver will be probed during a
Device Tree boot. We also parse the sound node to link together the
codec, dma and the CPU-side Digital Audio Interface.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 31c4d26..d84a073 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/spi/spi.h>
+#include <linux/of.h>
 
 #include <sound/soc.h>
 #include <sound/initval.h>
@@ -56,14 +57,48 @@ static struct snd_soc_card mop500_card = {
 	.num_links = ARRAY_SIZE(mop500_dai_links),
 };
 
+static int __devinit mop500_of_probe(struct platform_device *pdev,
+				struct device_node *np)
+{
+	struct device_node *codec_np, *platform_np, *msp_np[2];
+	int i;
+
+	platform_np = of_parse_phandle(np, "platform-pcm-dma", 0);
+	msp_np[0]   = of_parse_phandle(np, "cpu-dai", 0);
+	msp_np[1]   = of_parse_phandle(np, "cpu-dai", 1);
+	codec_np    = of_parse_phandle(np, "audio-codec", 0);
+
+	if (!(platform_np && msp_np[0] && msp_np[1] && codec_np)) {
+		dev_err(&pdev->dev, "Phandle missing or invalid\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 2; i++) {
+		mop500_dai_links[i].platform_of_node = platform_np;
+		mop500_dai_links[i].platform_name = NULL;
+		mop500_dai_links[i].cpu_of_node = msp_np[i];
+		mop500_dai_links[i].cpu_dai_name = NULL;
+		mop500_dai_links[i].codec_of_node = codec_np;
+		mop500_dai_links[i].codec_name = NULL;
+	}
+
+	return 0;
+}
 static int __devinit mop500_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
 	pr_debug("%s: Enter.\n", __func__);
 
 	dev_dbg(&pdev->dev, "%s: Enter.\n", __func__);
 
+	if (np) {
+		ret = mop500_of_probe(pdev, np);
+		if (ret)
+			return ret;
+	}
+
 	mop500_card.dev = &pdev->dev;
 
 	dev_dbg(&pdev->dev, "%s: Card %s: Set platform drvdata.\n",
@@ -101,10 +136,16 @@ static int __devexit mop500_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id snd_soc_mop500_match[] = {
+	{ .compatible = "stericsson,snd-soc-mop500", },
+	{},
+};
+
 static struct platform_driver snd_soc_mop500_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "snd-soc-mop500",
+		.of_match_table = snd_soc_mop500_match,
 	},
 	.probe = mop500_probe,
 	.remove = __devexit_p(mop500_remove),
-- 
1.7.9.5

