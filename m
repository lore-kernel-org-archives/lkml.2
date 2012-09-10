Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2IJJEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:04:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab2IJI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:59:56 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/7] pwm: i.MX: factor out SoC specific functions
Date: Mon, 10 Sep 2012 10:59:31 +0200
Message-Id: <1347267577-3296-2-git-send-email-s.hauer@pengutronix.de>
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

To cleanup the code and to make it easier to support different
SoCs.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 drivers/pwm/pwm-imx.c |  146 ++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 63 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 2a0b353..8b7f01e 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -46,81 +46,96 @@ struct imx_chip {
 	void __iomem	*mmio_base;
 
 	struct pwm_chip	chip;
+
+	int (*config)(struct pwm_chip *chip,
+		struct pwm_device *pwm, int duty_ns, int period_ns);
 };
 
 #define to_imx_chip(chip)	container_of(chip, struct imx_chip, chip)
 
-static int imx_pwm_config(struct pwm_chip *chip,
+static int imx_pwm_config_v1(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
 
-	if (!(cpu_is_mx1() || cpu_is_mx21())) {
-		unsigned long long c;
-		unsigned long period_cycles, duty_cycles, prescale;
-		u32 cr;
-
-		c = clk_get_rate(imx->clk);
-		c = c * period_ns;
-		do_div(c, 1000000000);
-		period_cycles = c;
-
-		prescale = period_cycles / 0x10000 + 1;
-
-		period_cycles /= prescale;
-		c = (unsigned long long)period_cycles * duty_ns;
-		do_div(c, period_ns);
-		duty_cycles = c;
-
-		/*
-		 * according to imx pwm RM, the real period value should be
-		 * PERIOD value in PWMPR plus 2.
-		 */
-		if (period_cycles > 2)
-			period_cycles -= 2;
-		else
-			period_cycles = 0;
-
-		writel(duty_cycles, imx->mmio_base + MX3_PWMSAR);
-		writel(period_cycles, imx->mmio_base + MX3_PWMPR);
-
-		cr = MX3_PWMCR_PRESCALER(prescale) |
-			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
-			MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
-
-		if (cpu_is_mx25())
-			cr |= MX3_PWMCR_CLKSRC_IPG;
-		else
-			cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
-
-		writel(cr, imx->mmio_base + MX3_PWMCR);
-	} else if (cpu_is_mx1() || cpu_is_mx21()) {
-		/* The PWM subsystem allows for exact frequencies. However,
-		 * I cannot connect a scope on my device to the PWM line and
-		 * thus cannot provide the program the PWM controller
-		 * exactly. Instead, I'm relying on the fact that the
-		 * Bootloader (u-boot or WinCE+haret) has programmed the PWM
-		 * function group already. So I'll just modify the PWM sample
-		 * register to follow the ratio of duty_ns vs. period_ns
-		 * accordingly.
-		 *
-		 * This is good enough for programming the brightness of
-		 * the LCD backlight.
-		 *
-		 * The real implementation would divide PERCLK[0] first by
-		 * both the prescaler (/1 .. /128) and then by CLKSEL
-		 * (/2 .. /16).
-		 */
-		u32 max = readl(imx->mmio_base + MX1_PWMP);
-		u32 p = max * duty_ns / period_ns;
-		writel(max - p, imx->mmio_base + MX1_PWMS);
-	} else {
-		BUG();
-	}
+	/*
+	 * The PWM subsystem allows for exact frequencies. However,
+	 * I cannot connect a scope on my device to the PWM line and
+	 * thus cannot provide the program the PWM controller
+	 * exactly. Instead, I'm relying on the fact that the
+	 * Bootloader (u-boot or WinCE+haret) has programmed the PWM
+	 * function group already. So I'll just modify the PWM sample
+	 * register to follow the ratio of duty_ns vs. period_ns
+	 * accordingly.
+	 *
+	 * This is good enough for programming the brightness of
+	 * the LCD backlight.
+	 *
+	 * The real implementation would divide PERCLK[0] first by
+	 * both the prescaler (/1 .. /128) and then by CLKSEL
+	 * (/2 .. /16).
+	 */
+	u32 max = readl(imx->mmio_base + MX1_PWMP);
+	u32 p = max * duty_ns / period_ns;
+	writel(max - p, imx->mmio_base + MX1_PWMS);
+
+	return 0;
+}
+
+static int imx_pwm_config_v2(struct pwm_chip *chip,
+		struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+	unsigned long long c;
+	unsigned long period_cycles, duty_cycles, prescale;
+	u32 cr;
+
+	c = clk_get_rate(imx->clk);
+	c = c * period_ns;
+	do_div(c, 1000000000);
+	period_cycles = c;
+
+	prescale = period_cycles / 0x10000 + 1;
+
+	period_cycles /= prescale;
+	c = (unsigned long long)period_cycles * duty_ns;
+	do_div(c, period_ns);
+	duty_cycles = c;
+
+	/*
+	 * according to imx pwm RM, the real period value should be
+	 * PERIOD value in PWMPR plus 2.
+	 */
+	if (period_cycles > 2)
+		period_cycles -= 2;
+	else
+		period_cycles = 0;
+
+	writel(duty_cycles, imx->mmio_base + MX3_PWMSAR);
+	writel(period_cycles, imx->mmio_base + MX3_PWMPR);
+
+	cr = MX3_PWMCR_PRESCALER(prescale) |
+		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
+		MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
+
+	if (cpu_is_mx25())
+		cr |= MX3_PWMCR_CLKSRC_IPG;
+	else
+		cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
+
+	writel(cr, imx->mmio_base + MX3_PWMCR);
 
 	return 0;
 }
 
+static int imx_pwm_config(struct pwm_chip *chip,
+		struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+
+	return imx->config(chip, pwm, duty_ns, period_ns);
+}
+
 static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
@@ -187,6 +202,11 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	if (imx->mmio_base == NULL)
 		return -EADDRNOTAVAIL;
 
+	if (cpu_is_mx1() || cpu_is_mx21())
+		imx->config = imx_pwm_config_v1;
+	else
+		imx->config = imx_pwm_config_v2;
+
 	ret = pwmchip_add(&imx->chip);
 	if (ret < 0)
 		return ret;
-- 
1.7.10.4

