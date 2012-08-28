Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2H1Lsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2H1Lse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:34 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 9/9] pwm i.MX: add devicetree support
Date: Tue, 28 Aug 2012 13:48:24 +0200
Message-Id: <1346154504-5623-10-git-send-email-s.hauer@pengutronix.de>
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

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/pwm-imx.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 308ab51..dce2acb 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -206,9 +206,25 @@ static struct pwm_ops imx_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
+struct imx_pwm_data {
+	int (*config)(struct pwm_chip *chip,
+		struct pwm_device *pwm, int duty_ns, int period_ns);
+	void (*set_enable)(struct pwm_chip *chip, bool enable);
+};
+
+static struct imx_pwm_data imx_pwm_data_v1 = {
+	.config = imx_pwm_config_v1,
+	.set_enable = imx_pwm_set_enable_v1,
+};
+
+static struct imx_pwm_data imx_pwm_data_v2 = {
+	.config = imx_pwm_config_v2,
+	.set_enable = imx_pwm_set_enable_v2,
+};
+
 static const struct of_device_id imx_pwm_dt_ids[] = {
-	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_config_v1, },
-	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_config_v2, },
+	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_data_v1, },
+	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_data_v2, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx_pwm_of_match);
@@ -257,7 +273,9 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 		return -EADDRNOTAVAIL;
 
 	if (of_id) {
-		imx->config = of_id->data;
+		struct imx_pwm_data *data = of_id->data;
+		imx->config = data->config;
+		imx->set_enable = data->set_enable;
 	} else {
 		if (cpu_is_mx1() || cpu_is_mx21()) {
 			imx->config = imx_pwm_config_v1;
@@ -290,6 +308,7 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
 static struct platform_driver imx_pwm_driver = {
 	.driver		= {
 		.name	= "mxc_pwm",
+		.of_match_table = of_match_ptr(imx_pwm_dt_ids),
 	},
 	.probe		= imx_pwm_probe,
 	.remove		= __devexit_p(imx_pwm_remove),
-- 
1.7.10.4

