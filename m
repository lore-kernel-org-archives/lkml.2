Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031425Ab2HIPxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:53:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49027 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031246Ab2HIPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org
Subject: [PATCH 05/22] ASoC: Ux500: Enable MOP500 driver for Device Tree
Date: Thu,  9 Aug 2012 16:47:31 +0100
Message-Id: <1344527268-5964-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we ensure that the MOP500 audio driver will be probed during a
Device Tree boot. We also parse the sound node to link together the
codec, dma and the CPU-side Digital Audio Interface.

CC: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 31c4d26..6840df7 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/spi/spi.h>
+#include <linux/of.h>
 
 #include <sound/soc.h>
 #include <sound/initval.h>
@@ -56,8 +57,35 @@ static struct snd_soc_card mop500_card = {
 	.num_links = ARRAY_SIZE(mop500_dai_links),
 };
 
+static int __devinit mop500_of_probe(struct platform_device *pdev,
+				struct device_node *np)
+{
+	struct device_node *codec_np, *msp_np[2];
+	int i;
+
+	msp_np[0] = of_parse_phandle(np, "stericsson,cpu-dai", 0);
+	msp_np[1] = of_parse_phandle(np, "stericsson,cpu-dai", 1);
+	codec_np  = of_parse_phandle(np, "stericsson,audio-codec", 0);
+
+	if (!(msp_np[0] && msp_np[1] && codec_np)) {
+		dev_err(&pdev->dev, "Phandle missing or invalid\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 2; i++) {
+		mop500_dai_links[i].cpu_of_node = msp_np[i];
+		mop500_dai_links[i].cpu_dai_name = NULL;
+		mop500_dai_links[i].codec_of_node = codec_np;
+		mop500_dai_links[i].codec_name = NULL;
+	}
+
+	snd_soc_of_parse_card_name(&mop500_card, "stericsson,card-name");
+
+	return 0;
+}
 static int __devinit mop500_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
 	pr_debug("%s: Enter.\n", __func__);
@@ -66,6 +94,12 @@ static int __devinit mop500_probe(struct platform_device *pdev)
 
 	mop500_card.dev = &pdev->dev;
 
+	if (np) {
+		ret = mop500_of_probe(pdev, np);
+		if (ret)
+			return ret;
+	}
+
 	dev_dbg(&pdev->dev, "%s: Card %s: Set platform drvdata.\n",
 		__func__, mop500_card.name);
 	platform_set_drvdata(pdev, &mop500_card);
@@ -101,10 +135,16 @@ static int __devexit mop500_remove(struct platform_device *pdev)
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

