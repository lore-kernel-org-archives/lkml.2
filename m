Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2H1Lsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38661 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2H1Lsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:35 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 7/9] pwm i.MX: fix clock lookup
Date: Tue, 28 Aug 2012 13:48:22 +0200
Message-Id: <1346154504-5623-8-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

The i.MX pwm core has two clocks: The ipg clock and the ipg highfreq
(peripheral) clock. The ipg clock has to be enabled for this hardware
to work. The actual pwm output can either be driven by the ipg clock
or the ipg highfreq. The ipg highfreq has the advantage that it runs
even when the SoC is in low power modes.
This patch requests both clocks and enables the ipg clock for accessing
registers and the peripheral clock to actually turn on the pwm.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/pwm-imx.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 3834f475..308ab51 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -41,7 +41,8 @@
 #define MX3_PWMCR_EN              (1 << 0)
 
 struct imx_chip {
-	struct clk	*clk;
+	struct clk	*clk_per;
+	struct clk	*clk_ipg;
 
 	int		enabled;
 	void __iomem	*mmio_base;
@@ -106,7 +107,7 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 	unsigned long period_cycles, duty_cycles, prescale;
 	u32 cr;
 
-	c = clk_get_rate(imx->clk);
+	c = clk_get_rate(imx->clk_per);
 	c = c * period_ns;
 	do_div(c, 1000000000);
 	period_cycles = c;
@@ -161,8 +162,15 @@ static int imx_pwm_config(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
+	int ret;
 
-	return imx->config(chip, pwm, duty_ns, period_ns);
+	clk_prepare_enable(imx->clk_ipg);
+
+	ret = imx->config(chip, pwm, duty_ns, period_ns);
+
+	clk_disable_unprepare(imx->clk_ipg);
+
+	return ret;
 }
 
 static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
@@ -170,7 +178,7 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct imx_chip *imx = to_imx_chip(chip);
 	int rc;
 
-	rc = clk_prepare_enable(imx->clk);
+	rc = clk_prepare_enable(imx->clk_per);
 	if (rc)
 		return rc;
 
@@ -187,7 +195,7 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	imx->set_enable(chip, false);
 
-	clk_disable_unprepare(imx->clk);
+	clk_disable_unprepare(imx->clk_per);
 	imx->enabled = 0;
 }
 
@@ -219,10 +227,19 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	imx->clk = devm_clk_get(&pdev->dev, "pwm");
+	imx->clk_per = devm_clk_get(&pdev->dev, "per");
+	if (IS_ERR(imx->clk_per)) {
+		dev_err(&pdev->dev, "getting per clock failed with %ld\n",
+				PTR_ERR(imx->clk_per));
+		return PTR_ERR(imx->clk_per);
+	}
 
-	if (IS_ERR(imx->clk))
-		return PTR_ERR(imx->clk);
+	imx->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(imx->clk_ipg)) {
+		dev_err(&pdev->dev, "getting ipg clock failed with %ld\n",
+				PTR_ERR(imx->clk_ipg));
+		return PTR_ERR(imx->clk_ipg);
+	}
 
 	imx->chip.ops = &imx_pwm_ops;
 	imx->chip.dev = &pdev->dev;
-- 
1.7.10.4

