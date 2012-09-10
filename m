Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab2IJJEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:04:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53789 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2IJI7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:59:47 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/7] pwm: i.MX: add functions to enable/disable pwm.
Date: Mon, 10 Sep 2012 10:59:33 +0200
Message-Id: <1347267577-3296-4-git-send-email-s.hauer@pengutronix.de>
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

We used to enable/disable the PWM only by switching the
clock on or off. Instead, use the dedicated register bits.
These differ on different SoCs, so introduce a SoC specific
function for this.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 5d426ff..13d4d22 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -25,6 +25,7 @@
 #define MX1_PWMS    0x04   /* PWM Sample Register */
 #define MX1_PWMP    0x08   /* PWM Period Register */
 
+#define MX1_PWMC_EN		(1 << 4)
 
 /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
 
@@ -49,6 +50,7 @@ struct imx_chip {
 
 	int (*config)(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns);
+	void (*set_enable)(struct pwm_chip *chip, bool enable);
 };
 
 #define to_imx_chip(chip)	container_of(chip, struct imx_chip, chip)
@@ -82,6 +84,21 @@ static int imx_pwm_config_v1(struct pwm_chip *chip,
 	return 0;
 }
 
+static void imx_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+	u32 val;
+
+	val = readl(imx->mmio_base + MX1_PWMC);
+
+	if (enable)
+		val |= MX1_PWMC_EN;
+	else
+		val &= ~MX1_PWMC_EN;
+
+	writel(val, imx->mmio_base + MX1_PWMC);
+}
+
 static int imx_pwm_config_v2(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
@@ -116,7 +133,10 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 
 	cr = MX3_PWMCR_PRESCALER(prescale) |
 		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
-		MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
+		MX3_PWMCR_DBGEN;
+
+	if (imx->enabled)
+		cr |= MX3_PWMCR_EN;
 
 	if (cpu_is_mx25())
 		cr |= MX3_PWMCR_CLKSRC_IPG;
@@ -128,6 +148,21 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 	return 0;
 }
 
+static void imx_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+	u32 val;
+
+	val = readl(imx->mmio_base + MX3_PWMCR);
+
+	if (enable)
+		val |= MX3_PWMCR_EN;
+	else
+		val &= ~MX3_PWMCR_EN;
+
+	writel(val, imx->mmio_base + MX3_PWMCR);
+}
+
 static int imx_pwm_config(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
@@ -145,6 +180,8 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (ret)
 		return ret;
 
+	imx->set_enable(chip, true);
+
 	imx->enabled = 1;
 
 	return 0;
@@ -154,7 +191,7 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
 
-	writel(0, imx->mmio_base + MX3_PWMCR);
+	imx->set_enable(chip, false);
 
 	clk_disable_unprepare(imx->clk);
 	imx->enabled = 0;
@@ -199,10 +236,13 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	if (imx->mmio_base == NULL)
 		return -EADDRNOTAVAIL;
 
-	if (cpu_is_mx1() || cpu_is_mx21())
+	if (cpu_is_mx1() || cpu_is_mx21()) {
 		imx->config = imx_pwm_config_v1;
-	else
+		imx->set_enable = imx_pwm_set_enable_v1;
+	} else {
 		imx->config = imx_pwm_config_v2;
+		imx->set_enable = imx_pwm_set_enable_v2;
+	}
 
 	ret = pwmchip_add(&imx->chip);
 	if (ret < 0)
-- 
1.7.10.4

