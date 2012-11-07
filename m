Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2KGPnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:43:06 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48814 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab2KGPnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:43:03 -0500
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RESEND PATCH 2/2] ASoC: Ux500: Control apb clock
Date: Wed, 7 Nov 2012 16:42:42 +0100
Message-ID: <1352302962-25201-2-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352302962-25201-1-git-send-email-ulf.hansson@stericsson.com>
References: <1352302962-25201-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

When switching to common clock driver for ux500 this clock needs to
be handled as well. Before this clock was internally managed by the
clock driver itself.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c |   38 ++++++++++++++++++++++++++++++++------
 sound/soc/ux500/ux500_msp_dai.h |    1 +
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index e11187f..74bb3c0 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -398,13 +398,28 @@ static int ux500_msp_dai_startup(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	/* Prepare and enable clock */
-	dev_dbg(dai->dev, "%s: Enabling MSP-clock.\n", __func__);
+	/* Prepare and enable clocks */
+	dev_dbg(dai->dev, "%s: Enabling MSP-clocks.\n", __func__);
+	ret = clk_prepare_enable(drvdata->pclk);
+	if (ret) {
+		dev_err(drvdata->msp->dev,
+			"%s: Failed to prepare/enable pclk!\n", __func__);
+		goto err_pclk;
+	}
+
 	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		regulator_disable(drvdata->reg_vape);
+	if (ret) {
+		dev_err(drvdata->msp->dev,
+			"%s: Failed to prepare/enable clk!\n", __func__);
+		goto err_clk;
+	}
 
 	return ret;
+err_clk:
+	clk_disable_unprepare(drvdata->pclk);
+err_pclk:
+	regulator_disable(drvdata->reg_vape);
+	return ret;
 }
 
 static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
@@ -430,8 +445,9 @@ static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
 			__func__, dai->id, snd_pcm_stream_str(substream));
 	}
 
-	/* Disable and unprepare clock */
+	/* Disable and unprepare clocks */
 	clk_disable_unprepare(drvdata->clk);
+	clk_disable_unprepare(drvdata->pclk);
 
 	/* Disable regulator */
 	ret = regulator_disable(drvdata->reg_vape);
@@ -782,6 +798,14 @@ static int __devinit ux500_msp_drv_probe(struct platform_device *pdev)
 	}
 	prcmu_qos_add_requirement(PRCMU_QOS_APE_OPP, (char *)pdev->name, 50);
 
+	drvdata->pclk = clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(drvdata->pclk)) {
+		ret = (int)PTR_ERR(drvdata->pclk);
+		dev_err(&pdev->dev, "%s: ERROR: clk_get of pclk failed (%d)!\n",
+			__func__, ret);
+		goto err_pclk;
+	}
+
 	drvdata->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(drvdata->clk)) {
 		ret = (int)PTR_ERR(drvdata->clk);
@@ -812,8 +836,9 @@ static int __devinit ux500_msp_drv_probe(struct platform_device *pdev)
 
 err_init_msp:
 	clk_put(drvdata->clk);
-
 err_clk:
+	clk_put(drvdata->pclk);
+err_pclk:
 	devm_regulator_put(drvdata->reg_vape);
 
 	return ret;
@@ -829,6 +854,7 @@ static int __devexit ux500_msp_drv_remove(struct platform_device *pdev)
 	prcmu_qos_remove_requirement(PRCMU_QOS_APE_OPP, "ux500_msp_i2s");
 
 	clk_put(drvdata->clk);
+	clk_put(drvdata->pclk);
 
 	ux500_msp_i2s_cleanup_msp(pdev, drvdata->msp);
 
diff --git a/sound/soc/ux500/ux500_msp_dai.h b/sound/soc/ux500/ux500_msp_dai.h
index 98202a3..9c778d9 100644
--- a/sound/soc/ux500/ux500_msp_dai.h
+++ b/sound/soc/ux500/ux500_msp_dai.h
@@ -69,6 +69,7 @@ struct ux500_msp_i2s_drvdata {
 	/* Clocks */
 	unsigned int master_clk;
 	struct clk *clk;
+	struct clk *pclk;
 
 	/* Regulators */
 	int vape_opp_constraint;
-- 
1.7.10

