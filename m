Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2GaNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:39:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2GaNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:25 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/19] ASoC: Ux500: Move MSP pinctrl setup into the MSP driver
Date: Tue, 31 Jul 2012 14:38:55 +0100
Message-Id: <1343741953-17828-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the initial submission of the MSP driver msp1 and msp3's associated
pinctrl mechanism was passed back to platform code using a plat_init()
call-back routine, but it has no place in platform code. The MSP driver
should set this up for the appropriate ports. Instead we use a use_pinctrl
identifier which is passed from platform_data/Device Tree which indicates
which ports should use pinctrl.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   75 +-------------------------------
 arch/arm/mach-ux500/include/mach/msp.h |    2 -
 sound/soc/ux500/ux500_msp_i2s.c        |   75 +++++++++++++++++++++++++-------
 sound/soc/ux500/ux500_msp_i2s.h        |    2 -
 4 files changed, 60 insertions(+), 94 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 1b6a193..af65fb0 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -23,53 +23,6 @@
 #include "devices-db8500.h"
 #include "pins-db8500.h"
 
-/* MSP1/3 Tx/Rx usage protection */
-static DEFINE_SPINLOCK(msp_rxtx_lock);
-
-/* Reference Count */
-static int msp_rxtx_ref;
-
-/* Pin modes */
-struct pinctrl *msp1_p;
-struct pinctrl_state *msp1_def;
-struct pinctrl_state *msp1_sleep;
-
-int msp13_i2s_init(void)
-{
-	int retval = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&msp_rxtx_lock, flags);
-	if (msp_rxtx_ref == 0 && !(IS_ERR(msp1_p) || IS_ERR(msp1_def))) {
-		retval = pinctrl_select_state(msp1_p, msp1_def);
-		if (retval)
-			pr_err("could not set MSP1 defstate\n");
-	}
-	if (!retval)
-		msp_rxtx_ref++;
-	spin_unlock_irqrestore(&msp_rxtx_lock, flags);
-
-	return retval;
-}
-
-int msp13_i2s_exit(void)
-{
-	int retval = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&msp_rxtx_lock, flags);
-	WARN_ON(!msp_rxtx_ref);
-	msp_rxtx_ref--;
-	if (msp_rxtx_ref == 0 && !(IS_ERR(msp1_p) || IS_ERR(msp1_sleep))) {
-		retval = pinctrl_select_state(msp1_p, msp1_sleep);
-		if (retval)
-			pr_err("could not set MSP1 sleepstate\n");
-	}
-	spin_unlock_irqrestore(&msp_rxtx_lock, flags);
-
-	return retval;
-}
-
 static struct stedma40_chan_cfg msp0_dma_rx = {
 	.high_priority = true,
 	.dir = STEDMA40_PERIPH_TO_MEM,
@@ -132,8 +85,6 @@ static struct msp_i2s_platform_data msp1_platform_data = {
 	.id = MSP_I2S_1,
 	.msp_i2s_dma_rx = NULL,
 	.msp_i2s_dma_tx = &msp1_dma_tx,
-	.msp_i2s_init = msp13_i2s_init,
-	.msp_i2s_exit = msp13_i2s_exit,
 };
 
 static struct stedma40_chan_cfg msp2_dma_rx = {
@@ -219,47 +170,23 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 	.id		= MSP_I2S_3,
 	.msp_i2s_dma_rx	= &msp1_dma_rx,
 	.msp_i2s_dma_tx	= NULL,
-	.msp_i2s_init = msp13_i2s_init,
-	.msp_i2s_exit = msp13_i2s_exit,
 };
 
 int mop500_msp_init(struct device *parent)
 {
-	struct platform_device *msp1;
-
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
 	platform_device_register(&snd_soc_mop500);
 
 	pr_info("Initialize MSP I2S-devices.\n");
 	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
 			   &msp0_platform_data);
-	msp1 = db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
 			   &msp1_platform_data);
 	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
 			   &msp2_platform_data);
 	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
 			   &msp3_platform_data);
 
-	/* Get the pinctrl handle for MSP1 */
-	if (msp1) {
-		msp1_p = pinctrl_get(&msp1->dev);
-		if (IS_ERR(msp1_p))
-			dev_err(&msp1->dev, "could not get MSP1 pinctrl\n");
-		else {
-			msp1_def = pinctrl_lookup_state(msp1_p,
-							PINCTRL_STATE_DEFAULT);
-			if (IS_ERR(msp1_def)) {
-				dev_err(&msp1->dev,
-					"could not get MSP1 defstate\n");
-			}
-			msp1_sleep = pinctrl_lookup_state(msp1_p,
-							  PINCTRL_STATE_SLEEP);
-			if (IS_ERR(msp1_sleep))
-				dev_err(&msp1->dev,
-					"could not get MSP1 idlestate\n");
-		}
-	}
-
 	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
 	platform_device_register(&ux500_pcm);
 
diff --git a/arch/arm/mach-ux500/include/mach/msp.h b/arch/arm/mach-ux500/include/mach/msp.h
index 798be19..3cc7142 100644
--- a/arch/arm/mach-ux500/include/mach/msp.h
+++ b/arch/arm/mach-ux500/include/mach/msp.h
@@ -22,8 +22,6 @@ struct msp_i2s_platform_data {
 	enum msp_i2s_id id;
 	struct stedma40_chan_cfg *msp_i2s_dma_rx;
 	struct stedma40_chan_cfg *msp_i2s_dma_tx;
-	int (*msp_i2s_init) (void);
-	int (*msp_i2s_exit) (void);
 };
 
 #endif
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 36be11e..2cbfc54 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 
@@ -25,6 +26,17 @@
 
 #include "ux500_msp_i2s.h"
 
+/* MSP1/3 Tx/Rx usage protection */
+static DEFINE_SPINLOCK(msp_rxtx_lock);
+
+/* Pin modes */
+struct pinctrl *pinctrl_p;
+struct pinctrl_state *pinctrl_def;
+struct pinctrl_state *pinctrl_sleep;
+
+/* Reference Count */
+int pinctrl_rxtx_ref;
+
  /* Protocol desciptors */
 static const struct msp_protdesc prot_descs[] = {
 	{ /* I2S */
@@ -352,17 +364,23 @@ static int configure_multichannel(struct ux500_msp *msp,
 
 static int enable_msp(struct ux500_msp *msp, struct ux500_msp_config *config)
 {
-	int status = 0;
+	int status = 0, retval = 0;
 	u32 reg_val_DMACR, reg_val_GCR;
+	unsigned long flags;
 
 	/* Check msp state whether in RUN or CONFIGURED Mode */
-	if ((msp->msp_state == MSP_STATE_IDLE) && (msp->plat_init)) {
-		status = msp->plat_init();
-		if (status) {
-			dev_err(msp->dev, "%s: ERROR: Failed to init MSP (%d)!\n",
-				__func__, status);
-			return status;
+	if (msp->msp_state == MSP_STATE_IDLE) {
+		spin_lock_irqsave(&msp_rxtx_lock, flags);
+		if (pinctrl_rxtx_ref == 0 &&
+			!(IS_ERR(pinctrl_p) || IS_ERR(pinctrl_def))) {
+			retval = pinctrl_select_state(pinctrl_p,
+						pinctrl_def);
+			if (retval)
+				pr_err("could not set MSP defstate\n");
 		}
+		if (!retval)
+			pinctrl_rxtx_ref++;
+		spin_unlock_irqrestore(&msp_rxtx_lock, flags);
 	}
 
 	/* Configure msp with protocol dependent settings */
@@ -620,7 +638,8 @@ int ux500_msp_i2s_trigger(struct ux500_msp *msp, int cmd, int direction)
 
 int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 {
-	int status = 0;
+	int status = 0, retval = 0;
+	unsigned long flags;
 
 	dev_dbg(msp->dev, "%s: Enter (dir = 0x%01x).\n", __func__, dir);
 
@@ -631,12 +650,19 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 		writel((readl(msp->registers + MSP_GCR) &
 			       (~(FRAME_GEN_ENABLE | SRG_ENABLE))),
 			      msp->registers + MSP_GCR);
-		if (msp->plat_exit)
-			status = msp->plat_exit();
-			if (status)
-				dev_warn(msp->dev,
-					"%s: WARN: ux500_msp_i2s_exit failed (%d)!\n",
-					__func__, status);
+
+		spin_lock_irqsave(&msp_rxtx_lock, flags);
+		WARN_ON(!pinctrl_rxtx_ref);
+		pinctrl_rxtx_ref--;
+		if (pinctrl_rxtx_ref == 0 &&
+			!(IS_ERR(pinctrl_p) || IS_ERR(pinctrl_sleep))) {
+			retval = pinctrl_select_state(pinctrl_p,
+						pinctrl_sleep);
+			if (retval)
+				pr_err("could not set MSP sleepstate\n");
+		}
+		spin_unlock_irqrestore(&msp_rxtx_lock, flags);
+
 		writel(0, msp->registers + MSP_GCR);
 		writel(0, msp->registers + MSP_TCF);
 		writel(0, msp->registers + MSP_RCF);
@@ -678,8 +704,6 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
 	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
-	msp->plat_init = platform_data->msp_i2s_init;
-	msp->plat_exit = platform_data->msp_i2s_exit;
 	msp->dma_cfg_rx = platform_data->msp_i2s_dma_rx;
 	msp->dma_cfg_tx = platform_data->msp_i2s_dma_tx;
 
@@ -717,6 +741,25 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	dev_dbg(&pdev->dev, "I2S device-name: '%s'\n", i2s_cont->name);
 	msp->i2s_cont = i2s_cont;
 
+	pinctrl_p = pinctrl_get(msp->dev);
+	if (IS_ERR(pinctrl_p))
+		dev_err(&pdev->dev, "could not get MSP pinctrl\n");
+	else {
+		pinctrl_def = pinctrl_lookup_state(pinctrl_p,
+						PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(pinctrl_def)) {
+			dev_err(&pdev->dev,
+				"could not get MSP defstate (%li)\n",
+				PTR_ERR(pinctrl_def));
+		}
+		pinctrl_sleep = pinctrl_lookup_state(pinctrl_p,
+						PINCTRL_STATE_SLEEP);
+		if (IS_ERR(pinctrl_sleep))
+			dev_err(&pdev->dev,
+				"could not get MSP idlestate (%li)\n",
+				PTR_ERR(pinctrl_def));
+	}
+
 	return 0;
 
 err_i2s_cont:
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 2d9136d..1ce336f 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -524,8 +524,6 @@ struct ux500_msp {
 	struct dma_chan *rx_pipeid;
 	enum msp_state msp_state;
 	int (*transfer) (struct ux500_msp *msp, struct i2s_message *message);
-	int (*plat_init) (void);
-	int (*plat_exit) (void);
 	struct timer_list notify_timer;
 	int def_elem_len;
 	unsigned int dir_busy;
-- 
1.7.9.5

