Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2KGPnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:43:05 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:36273 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab2KGPnD (ORCPT
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
Subject: [RESEND PATCH 1/2] ASoC: Ux500: Fixup use of clocks
Date: Wed, 7 Nov 2012 16:42:41 +0100
Message-ID: <1352302962-25201-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Make sure clocks are being prepared and unprepared as well
as enabled and disabled.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index be94bf9..e11187f 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -398,11 +398,13 @@ static int ux500_msp_dai_startup(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	/* Enable clock */
+	/* Prepare and enable clock */
 	dev_dbg(dai->dev, "%s: Enabling MSP-clock.\n", __func__);
-	clk_enable(drvdata->clk);
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		regulator_disable(drvdata->reg_vape);
 
-	return 0;
+	return ret;
 }
 
 static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
@@ -428,8 +430,8 @@ static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
 			__func__, dai->id, snd_pcm_stream_str(substream));
 	}
 
-	/* Disable clock */
-	clk_disable(drvdata->clk);
+	/* Disable and unprepare clock */
+	clk_disable_unprepare(drvdata->clk);
 
 	/* Disable regulator */
 	ret = regulator_disable(drvdata->reg_vape);
-- 
1.7.10

