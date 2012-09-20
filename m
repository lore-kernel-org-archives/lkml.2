Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2ITMJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:09:33 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47303 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2ITMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:09:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/7] ASoC: Ux500: Enable ux500 MSP driver for Device Tree
Date: Thu, 20 Sep 2012 14:09:12 +0200
Message-Id: <1348142956-1872-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
References: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register both parts of the MSP driver from Device Tree so that they
are probed when Device Tree is enabled. Also, as there is platform
data involved, we ensure that there is allocated memory to place the
configuration into and that the correct information is extracted from
the DT binary.

Acked-by: Ola Lilja <ola.o.lilja@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c |    6 ++++++
 sound/soc/ux500/ux500_msp_i2s.c |   22 +++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 057e28e..45e43b4 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -830,10 +830,16 @@ static int __devexit ux500_msp_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ux500_msp_i2s_match[] = {
+	{ .compatible = "stericsson,ux500-msp-i2s", },
+	{},
+};
+
 static struct platform_driver msp_i2s_driver = {
 	.driver = {
 		.name = "ux500-msp-i2s",
 		.owner = THIS_MODULE,
+		.of_match_table = ux500_msp_i2s_match,
 	},
 	.probe = ux500_msp_drv_probe,
 	.remove = ux500_msp_drv_remove,
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 12d7f56..e5c79ca 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -18,6 +18,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #include <mach/hardware.h>
 #include <mach/msp.h>
@@ -683,14 +684,29 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 {
 	struct resource *res = NULL;
 	struct i2s_controller *i2s_cont;
+	struct device_node *np = pdev->dev.of_node;
 	struct ux500_msp *msp;
 
-	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
-		pdev->name, platform_data->id);
-
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
 	msp = *msp_p;
 
+	if (np) {
+		if (!platform_data) {
+			platform_data = devm_kzalloc(&pdev->dev,
+				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
+			if (!platform_data)
+				ret = -ENOMEM;
+		}
+	} else
+		if (!platform_data)
+			ret = -EINVAL;
+
+	if (ret)
+		goto err_res;
+
+	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
+		pdev->name, platform_data->id);
+
 	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
 	msp->dma_cfg_rx = platform_data->msp_i2s_dma_rx;
-- 
1.7.9.5

