Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab2HWU6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:58:35 -0400
Received: from zose-mta15.web4all.fr ([176.31.217.11]:49502 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934358Ab2HWU6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:58:32 -0400
Date: Thu, 23 Aug 2012 23:03:57 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <1305545087.2775440.1345755837651.JavaMail.root@advansee.com>
In-Reply-To: <20120823191108.GB8127@avionic-0098.mockup.avionic-design.de>
Subject: [PATCH] pwm-imx: Fix config / enable / disable
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

imx_pwm_config() did not enable the PWM IP clock while accessing the registers.
Hence, a call to pwm_config() had no effect before pwm_enable() had been called,
which does not comply to the PWM API.

Moreover, calling pwm_disable() then pwm_enable() must be a transparent
operation.

This fixes the first setting of brightness through sysfs that had no effect with
leds-pwm.

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/pwm/pwm-imx.c                          |   55 +++++++++++++++-----
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git linux-next-c94456b.orig/drivers/pwm/pwm-imx.c linux-next-c94456b/drivers/pwm/pwm-imx.c
index 2a0b353..0519bf2 100644
--- linux-next-c94456b.orig/drivers/pwm/pwm-imx.c
+++ linux-next-c94456b/drivers/pwm/pwm-imx.c
@@ -55,6 +55,16 @@ static int imx_pwm_config(struct pwm_chip *chip,
 {
 	struct imx_chip *imx = to_imx_chip(chip);
 
+	/*
+	 * If the PWM is disabled, make sure to turn on the clock before
+	 * accessing the registers.
+	 */
+	if (!imx->clk_enabled) {
+		int rc = clk_prepare_enable(imx->clk);
+		if (rc)
+			return rc;
+	}
+
 	if (!(cpu_is_mx1() || cpu_is_mx21())) {
 		unsigned long long c;
 		unsigned long period_cycles, duty_cycles, prescale;
@@ -85,8 +95,11 @@ static int imx_pwm_config(struct pwm_chip *chip,
 		writel(period_cycles, imx->mmio_base + MX3_PWMPR);
 
 		cr = MX3_PWMCR_PRESCALER(prescale) |
-			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
-			MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
+			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN | MX3_PWMCR_DBGEN;
+
+		/* If the PWM is enabled, keep it so. */
+		if (imx->clk_enabled)
+			cr |= MX3_PWMCR_EN;
 
 		if (cpu_is_mx25())
 			cr |= MX3_PWMCR_CLKSRC_IPG;
@@ -118,32 +131,50 @@ static int imx_pwm_config(struct pwm_chip *chip,
 		BUG();
 	}
 
+	/* If the PWM is disabled, turn the clock off again to save power. */
+	if (!imx->clk_enabled)
+		clk_disable_unprepare(imx->clk);
+
 	return 0;
 }
 
 static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
-	int rc = 0;
+	int rc;
 
-	if (!imx->clk_enabled) {
-		rc = clk_prepare_enable(imx->clk);
-		if (!rc)
-			imx->clk_enabled = 1;
+	if (imx->clk_enabled)
+		return 0;
+
+	rc = clk_prepare_enable(imx->clk);
+	if (rc)
+		return rc;
+
+	if (!(cpu_is_mx1() || cpu_is_mx21())) {
+		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
+		cr |= MX3_PWMCR_EN;
+		writel(cr, imx->mmio_base + MX3_PWMCR);
 	}
-	return rc;
+
+	imx->clk_enabled = 1;
+	return 0;
 }
 
 static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
 
-	writel(0, imx->mmio_base + MX3_PWMCR);
+	if (!imx->clk_enabled)
+		return;
 
-	if (imx->clk_enabled) {
-		clk_disable_unprepare(imx->clk);
-		imx->clk_enabled = 0;
+	if (!(cpu_is_mx1() || cpu_is_mx21())) {
+		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
+		cr &= ~MX3_PWMCR_EN;
+		writel(cr, imx->mmio_base + MX3_PWMCR);
 	}
+
+	clk_disable_unprepare(imx->clk);
+	imx->clk_enabled = 0;
 }
 
 static struct pwm_ops imx_pwm_ops = {
