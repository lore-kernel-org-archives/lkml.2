Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2IJJA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:00:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab2IJJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:19 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/7] pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
Date: Mon, 10 Sep 2012 10:59:32 +0200
Message-Id: <1347267577-3296-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM core makes sure that pwm_enable/disable are called only
once. Still keep the enabled state since we will need it in
pwm_config.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 8b7f01e..5d426ff 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -42,7 +42,7 @@
 struct imx_chip {
 	struct clk	*clk;
 
-	int		clk_enabled;
+	int		enabled;
 	void __iomem	*mmio_base;
 
 	struct pwm_chip	chip;
@@ -139,14 +139,15 @@ static int imx_pwm_config(struct pwm_chip *chip,
 static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
-	int rc = 0;
+	int ret;
 
-	if (!imx->clk_enabled) {
-		rc = clk_prepare_enable(imx->clk);
-		if (!rc)
-			imx->clk_enabled = 1;
-	}
-	return rc;
+	ret = clk_prepare_enable(imx->clk);
+	if (ret)
+		return ret;
+
+	imx->enabled = 1;
+
+	return 0;
 }
 
 static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
@@ -155,10 +156,8 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	writel(0, imx->mmio_base + MX3_PWMCR);
 
-	if (imx->clk_enabled) {
-		clk_disable_unprepare(imx->clk);
-		imx->clk_enabled = 0;
-	}
+	clk_disable_unprepare(imx->clk);
+	imx->enabled = 0;
 }
 
 static struct pwm_ops imx_pwm_ops = {
@@ -190,8 +189,6 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	imx->chip.base = -1;
 	imx->chip.npwm = 1;
 
-	imx->clk_enabled = 0;
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
-- 
1.7.10.4

