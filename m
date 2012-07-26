Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2GZKbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:31:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45943 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2GZK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/21] ASoC: Ux500: Enable ux500 MSP driver for Device Tree
Date: Thu, 26 Jul 2012 11:28:52 +0100
Message-Id: <1343298534-13611-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass registration of both parts of the MSP driver from platform code
to Device Tree so that they are probed when Device Tree is enabled.
Also, as there is platform data involved, we ensure that there is
allocated memory to place the configuration into and that the correct
information is extracted from the DT binary.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   14 --------------
 arch/arm/mach-ux500/board-mop500.c     |    2 --
 arch/arm/mach-ux500/board-mop500.h     |    2 --
 sound/soc/ux500/ux500_msp_dai.c        |    6 ++++++
 sound/soc/ux500/ux500_msp_i2s.c        |   33 +++++++++++++++++++++++++++++---
 5 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 391c129..c20d5d2 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -174,20 +174,6 @@ struct msp_i2s_platform_data msp3_platform_data = {
 	.use_pinctrl    = true,
 };
 
-/* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent)
-{
-	pr_info("Initialize MSP I2S-devices.\n");
-	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-			   &msp0_platform_data);
-	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
-			   &msp1_platform_data);
-	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
-			   &msp2_platform_data);
-	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
-			   &msp3_platform_data);
-}
-
 void mop500_msp_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index d455a61..2ef26c8 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -810,8 +810,6 @@ static void __init u8500_init_machine(void)
 
 		mop500_uib_init();
 
-	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		mop500_of_msp_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3fbf48f..e56c983 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -98,8 +98,6 @@ void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
 void mop500_msp_init(struct device *parent);
-/* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
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

