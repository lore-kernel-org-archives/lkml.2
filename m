Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2IJJCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:02:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53842 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2IJJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:12 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/7] pwm: i.MX: add devicetree support
Date: Mon, 10 Sep 2012 10:59:35 +0200
Message-Id: <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
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

At the same time remove platform based support. No user for
this driver has made it into mainline so far, so all we break
is out of tree stuff.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++++++++
 drivers/pwm/pwm-imx.c                             |   45 ++++++++++++++++-----
 2 files changed, 52 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
new file mode 100644
index 0000000..9b9b185
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
@@ -0,0 +1,17 @@
+Freescale i.MX PWM controller
+
+Required properties:
+- compatible: should be "fsl,<soc>-pwm"
+- reg: physical base address and length of the controller's registers
+- #pwm-cells: should be 2.  The first cell specifies the per-chip index
+  of the PWM to use and the second cell is the duty cycle in nanoseconds.
+- interrupts: The interrupt for the pwm controller
+
+Example:
+
+pwm1: pwm@53fb4000 {
+	#pwm-cells = <2>;
+	compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
+	reg = <0x53fb4000 0x4000>;
+	interrupts = <61>;
+};
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index a1e799e..b4e0ad3 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -16,8 +16,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/pwm.h>
-#include <mach/hardware.h>
-
+#include <linux/of_device.h>
 
 /* i.MX1 and i.MX21 share the same PWM function block: */
 
@@ -204,12 +203,41 @@ static struct pwm_ops imx_pwm_ops = {
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
+static const struct of_device_id imx_pwm_dt_ids[] = {
+	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_data_v1, },
+	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_data_v2, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_pwm_dt_ids);
+
 static int __devinit imx_pwm_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+			of_match_device(imx_pwm_dt_ids, &pdev->dev);
+	struct imx_pwm_data *data;
 	struct imx_chip *imx;
 	struct resource *r;
 	int ret = 0;
 
+	if (!of_id)
+		return -ENODEV;
+
 	imx = devm_kzalloc(&pdev->dev, sizeof(*imx), GFP_KERNEL);
 	if (imx == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
@@ -236,13 +264,9 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	if (imx->mmio_base == NULL)
 		return -EADDRNOTAVAIL;
 
-	if (cpu_is_mx1() || cpu_is_mx21()) {
-		imx->config = imx_pwm_config_v1;
-		imx->set_enable = imx_pwm_set_enable_v1;
-	} else {
-		imx->config = imx_pwm_config_v2;
-		imx->set_enable = imx_pwm_set_enable_v2;
-	}
+	data = of_id->data;
+	imx->config = data->config;
+	imx->set_enable = data->set_enable;
 
 	ret = pwmchip_add(&imx->chip);
 	if (ret < 0)
@@ -265,7 +289,8 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
 
 static struct platform_driver imx_pwm_driver = {
 	.driver		= {
-		.name	= "mxc_pwm",
+		.name	= "imx-pwm",
+		.of_match_table = of_match_ptr(imx_pwm_dt_ids),
 	},
 	.probe		= imx_pwm_probe,
 	.remove		= __devexit_p(imx_pwm_remove),
-- 
1.7.10.4

