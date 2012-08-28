Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2H1LtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:49:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2H1Lsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:43 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/9] pwm i.MX: add devicetree support
Date: Tue, 28 Aug 2012 13:48:20 +0200
Message-Id: <1346154504-5623-6-git-send-email-s.hauer@pengutronix.de>
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
 drivers/pwm/pwm-imx.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index a689144..dfc1bae 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -16,9 +16,9 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/pwm.h>
+#include <linux/of_device.h>
 #include <mach/hardware.h>
 
-
 /* i.MX1 and i.MX21 share the same PWM function block: */
 
 #define MX1_PWMC    0x00   /* PWM Control Register */
@@ -203,8 +203,17 @@ static struct pwm_ops imx_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct of_device_id imx_pwm_dt_ids[] = {
+	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_config_v1, },
+	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_config_v2, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_pwm_of_match);
+
 static int __devinit imx_pwm_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+			of_match_device(imx_pwm_dt_ids, &pdev->dev);
 	struct imx_chip *imx;
 	struct resource *r;
 	int ret = 0;
@@ -235,12 +244,16 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	if (imx->mmio_base == NULL)
 		return -EADDRNOTAVAIL;
 
-	if (cpu_is_mx1() || cpu_is_mx21()) {
-		imx->config = imx_pwm_config_v1;
-		imx->set_enable = imx_pwm_set_enable_v1;
+	if (of_id) {
+		imx->config = of_id->data;
 	} else {
-		imx->config = imx_pwm_config_v2;
-		imx->set_enable = imx_pwm_set_enable_v2;
+		if (cpu_is_mx1() || cpu_is_mx21()) {
+			imx->config = imx_pwm_config_v1;
+			imx->set_enable = imx_pwm_set_enable_v1;
+		} else {
+			imx->config = imx_pwm_config_v2;
+			imx->set_enable = imx_pwm_set_enable_v2;
+		}
 	}
 
 	ret = pwmchip_add(&imx->chip);
-- 
1.7.10.4

