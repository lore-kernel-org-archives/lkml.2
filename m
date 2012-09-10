Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2IJJAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:00:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab2IJJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:20 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 7/7] pwm: i.MX: fix clock lookup
Date: Mon, 10 Sep 2012 10:59:37 +0200
Message-Id: <1347267577-3296-8-git-send-email-s.hauer@pengutronix.de>
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

From: Philipp Zabel <p.zabel@pengutronix.de>

The i.MX PWM core has two clocks: The ipg clock and the ipg highfreq
(peripheral) clock. The ipg clock has to be enabled for this hardware
to work. The actual PWM output can either be driven by the ipg clock
or the ipg highfreq. The ipg highfreq has the advantage that it runs
even when the SoC is in low power modes.
This patch requests both clocks and enables the ipg clock for accessing
registers and the peripheral clock to actually turn on the PWM.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 852de6c..8a5d3ae 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -40,7 +40,8 @@
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
@@ -161,8 +162,17 @@ static int imx_pwm_config(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
+	int ret;
+
+	ret = clk_prepare_enable(imx->clk_ipg);
+	if (ret)
+		return ret;
 
-	return imx->config(chip, pwm, duty_ns, period_ns);
+	ret = imx->config(chip, pwm, duty_ns, period_ns);
+
+	clk_disable_unprepare(imx->clk_ipg);
+
+	return ret;
 }
 
 static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
@@ -170,7 +180,7 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct imx_chip *imx = to_imx_chip(chip);
 	int ret;
 
-	ret = clk_prepare_enable(imx->clk);
+	ret = clk_prepare_enable(imx->clk_per);
 	if (ret)
 		return ret;
 
@@ -187,7 +197,7 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	imx->set_enable(chip, false);
 
-	clk_disable_unprepare(imx->clk);
+	clk_disable_unprepare(imx->clk_per);
 	imx->enabled = 0;
 }
 
@@ -239,10 +249,19 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
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

