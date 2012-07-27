Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2G0MqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:46:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63195 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2G0MqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:46:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device Tree
Date: Fri, 27 Jul 2012 13:45:49 +0100
Message-Id: <1343393162-11938-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register both parts of the MSP driver from Device Tree so that they
are probed when Device Tree is enabled. Also, as there is platform
data involved, we ensure that there is allocated memory to place the
configuration into and that the correct information is extracted from
the DT binary.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c |    6 ++++++
 sound/soc/ux500/ux500_msp_i2s.c |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 772cb19..0f7dd49 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -833,10 +833,16 @@ static int __devexit ux500_msp_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ux500_msp_i2c_match[] = {
+	{ .compatible = "stericsson,ux500-msp-i2s", },
+	{},
+};
+
 static struct platform_driver msp_i2s_driver = {
 	.driver = {
 		.name = "ux500-msp-i2s",
 		.owner = THIS_MODULE,
+		.of_match_table = ux500_msp_i2c_match,
 	},
 	.probe = ux500_msp_drv_probe,
 	.remove = ux500_msp_drv_remove,
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 72ad6e8..1ecdec0 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -18,6 +18,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #include <mach/hardware.h>
 #include <mach/msp.h>
@@ -685,6 +686,16 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 
 }
 
+void ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
+			struct ux500_msp *msp,
+			struct device_node *np)
+{
+	if (of_get_property(np, "stericsson,use-pinctrl", NULL))
+		msp->use_pinctrl = true;
+	else
+		msp->use_pinctrl = false;
+}
+
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p,
 			struct msp_i2s_platform_data *platform_data)
@@ -692,17 +703,33 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	int ret = 0;
 	struct resource *res = NULL;
 	struct i2s_controller *i2s_cont;
+	struct device_node *np = pdev->dev.of_node;
 	struct ux500_msp *msp;
 	static int initialised = false;
 
-	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
-		pdev->name, platform_data->id);
-
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
 	msp = *msp_p;
 	if (!msp)
 		return -ENOMEM;
 
+	if (np) {
+		if (!platform_data) {
+			platform_data = devm_kzalloc(&pdev->dev,
+				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
+			if (!platform_data)
+				ret = -ENOMEM;
+		}
+		ux500_msp_i2s_of_init_msp(pdev, msp, np);
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
 	msp->use_pinctrl = platform_data->use_pinctrl;
-- 
1.7.9.5

