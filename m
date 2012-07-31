Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2GaNop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:44:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33375 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2GaNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/19] ASoC: Ux500: Enable MOP500 driver for Device Tree
Date: Tue, 31 Jul 2012 14:38:56 +0100
Message-Id: <1343741953-17828-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we ensure that the MOP500 audio driver will be probed during a
Device Tree boot. We also parse the sound node to link together the
codec, dma and the CPU-side Digital Audio Interface.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 31c4d26..821f2a9 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/spi/spi.h>
+#include <linux/of.h>
 
 #include <sound/soc.h>
 #include <sound/initval.h>
@@ -56,14 +57,45 @@ static struct snd_soc_card mop500_card = {
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
@@ -101,10 +133,16 @@ static int __devexit mop500_remove(struct platform_device *pdev)
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

