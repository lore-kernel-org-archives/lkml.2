Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2JONNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:13:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62699 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2JONNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:13:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] ASoC: Ux500: Dispose of device nodes correctly
Date: Mon, 15 Oct 2012 14:13:25 +0100
Message-Id: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When of_parse_phandle() is used to find a device node, its
reference count is incremented by the helper. Once we're
finished with them, it's our responsibly to ensure they
are freed in the correct manor.

Cc: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 6f67e6b..651a52a 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -57,6 +57,20 @@ static struct snd_soc_card mop500_card = {
 	.num_links = ARRAY_SIZE(mop500_dai_links),
 };
 
+static void mop500_of_node_put(void)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (mop500_dai_links[i].cpu_of_node)
+			of_node_put((struct device_node *)
+				mop500_dai_links[i].cpu_of_node);
+		if (mop500_dai_links[i].codec_of_node)
+			of_node_put((struct device_node *)
+				mop500_dai_links[i].codec_of_node);
+	}
+}
+
 static int __devinit mop500_of_probe(struct platform_device *pdev,
 				struct device_node *np)
 {
@@ -69,6 +83,7 @@ static int __devinit mop500_of_probe(struct platform_device *pdev,
 
 	if (!(msp_np[0] && msp_np[1] && codec_np)) {
 		dev_err(&pdev->dev, "Phandle missing or invalid\n");
+		mop500_of_node_put();
 		return -EINVAL;
 	}
 
@@ -83,6 +98,7 @@ static int __devinit mop500_of_probe(struct platform_device *pdev,
 
 	return 0;
 }
+
 static int __devinit mop500_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -128,6 +144,7 @@ static int __devexit mop500_remove(struct platform_device *pdev)
 
 	snd_soc_unregister_card(mop500_card);
 	mop500_ab8500_remove(mop500_card);
+	mop500_of_node_put();
 
 	return 0;
 }
-- 
1.7.9.5

