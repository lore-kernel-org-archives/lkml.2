Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2H0Pqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:46:43 -0400
Received: from mail1.adetelgroup.com ([78.155.151.235]:43092 "HELO
	mail1.adetelgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752714Ab2H0Ppp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:45:45 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 11:45:43 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-Reply-To: <1346081672-27866-1-git-send-email-shachimi@adeneo-embedded.com>
X-Mailer: git-send-email 1.7.1
Content-class: urn:content-classes:message
Subject: [PATCH v2 2/2] Enable Stop_enable mode during configuration of pwm.
Date: Mon, 27 Aug 2012 17:34:32 +0200
Message-ID: <3465D313FDFB824F9A9C8CD24FA4F6BCB4ACFE@frontmail.adetel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 2/2] Enable Stop_enable mode during configuration of pwm.
thread-index: Ac2EaaHX7DHLuVjvQJ62+89/kaNIKw==
References: <1346081672-27866-1-git-send-email-shachimi@adeneo-embedded.com>
From: "HACHIMI Samir" <shachimi@adeneo-embedded.com>
To: <shawn.guo@linaro.org>, <thierry.reding@avionic-design.de>
Cc: <linux-arm-kernel@lists.infradead.org>, <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>,
        "HACHIMI Samir" <shachimi@adeneo-embedded.com>
X-OriginalArrivalTime: 27 Aug 2012 15:35:49.0339 (UTC) FILETIME=[A252F2B0:01CD8469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samir Hachimi <shachimi@adeneo-embedded.com>

 Enable Stop_enable mode during configuration of pwm.
 Check architecture by looking in driver_data instead of cpu_is_xxx.

Signed-off-by: Samir Hachimi <shachimi@adeneo-embedded.com>
---
 drivers/pwm/pwm-imx.c |   59 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 0519bf2..7df919f 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -32,6 +32,7 @@
 #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
 #define MX3_PWMPR                 0x10    /* PWM Period Register */
 #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_STOPEN		(1 << 25)
 #define MX3_PWMCR_DOZEEN                (1 << 24)
 #define MX3_PWMCR_WAITEN                (1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
@@ -39,6 +40,16 @@
 #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
 #define MX3_PWMCR_EN              (1 << 0)
 
+/* Use the platform_id to distinguish different Archs. */
+#define IS_MX1			0x0
+#define IS_MX21			0x1
+#define IS_MX25			0x2
+#define IS_MX6Q			0x3
+#define PWM_IS_MX1(x)		((x)->id_entry->driver_data == IS_MX1)
+#define PWM_IS_MX21(x)		((x)->id_entry->driver_data == IS_MX21)
+#define PWM_IS_MX25(x)		((x)->id_entry->driver_data == IS_MX25)
+#define PWM_IS_MX6Q(x)		((x)->id_entry->driver_data == IS_MX6Q)
+
 struct imx_chip {
 	struct clk	*clk;
 
@@ -46,6 +57,7 @@ struct imx_chip {
 	void __iomem	*mmio_base;
 
 	struct pwm_chip	chip;
+	struct platform_device	*pdev;
 };
 
 #define to_imx_chip(chip)	container_of(chip, struct imx_chip, chip)
@@ -65,7 +77,7 @@ static int imx_pwm_config(struct pwm_chip *chip,
 			return rc;
 	}
 
-	if (!(cpu_is_mx1() || cpu_is_mx21())) {
+	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
 		unsigned long long c;
 		unsigned long period_cycles, duty_cycles, prescale;
 		u32 cr;
@@ -78,36 +90,33 @@ static int imx_pwm_config(struct pwm_chip *chip,
 		prescale = period_cycles / 0x10000 + 1;
 
 		period_cycles /= prescale;
-		c = (unsigned long long)period_cycles * duty_ns;
-		do_div(c, period_ns);
-		duty_cycles = c;
 
-		/*
-		 * according to imx pwm RM, the real period value should be
-		 * PERIOD value in PWMPR plus 2.
+		/* the chip documentation says the counter counts up to
+		 * period_cycles + 1 and then is reset to 0, so the
+		 *  actual period of the PWM wave is period_cycles + 2
 		 */
-		if (period_cycles > 2)
-			period_cycles -= 2;
-		else
-			period_cycles = 0;
+		c = (unsigned long long)(period_cycles + 2) * duty_ns;
+		do_div(c, period_ns);
+		duty_cycles = c;
 
 		writel(duty_cycles, imx->mmio_base + MX3_PWMSAR);
 		writel(period_cycles, imx->mmio_base + MX3_PWMPR);
 
 		cr = MX3_PWMCR_PRESCALER(prescale) |
-			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN | MX3_PWMCR_DBGEN;
+			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
+			MX3_PWMCR_DBGEN | MX3_PWMCR_STOPEN;
 
 		/* If the PWM is enabled, keep it so. */
 		if (imx->clk_enabled)
 			cr |= MX3_PWMCR_EN;
 
-		if (cpu_is_mx25())
+		if (PWM_IS_MX25(imx->pdev))
 			cr |= MX3_PWMCR_CLKSRC_IPG;
 		else
 			cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
 
 		writel(cr, imx->mmio_base + MX3_PWMCR);
-	} else if (cpu_is_mx1() || cpu_is_mx21()) {
+	} else if (PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev)) {
 		/* The PWM subsystem allows for exact frequencies. However,
 		 * I cannot connect a scope on my device to the PWM line and
 		 * thus cannot provide the program the PWM controller
@@ -150,7 +159,7 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (rc)
 		return rc;
 
-	if (!(cpu_is_mx1() || cpu_is_mx21())) {
+	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
 		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
 		cr |= MX3_PWMCR_EN;
 		writel(cr, imx->mmio_base + MX3_PWMCR);
@@ -167,7 +176,7 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (!imx->clk_enabled)
 		return;
 
-	if (!(cpu_is_mx1() || cpu_is_mx21())) {
+	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
 		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
 		cr &= ~MX3_PWMCR_EN;
 		writel(cr, imx->mmio_base + MX3_PWMCR);
@@ -207,6 +216,7 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 	imx->chip.npwm = 1;
 
 	imx->clk_enabled = 0;
+	imx->pdev = pdev;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
@@ -237,9 +247,26 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&imx->chip);
 }
 
+static const struct platform_device_id pwm_ids[] = {
+	{ .name = "imx1-pwm", .driver_data = IS_MX1, },
+	{ .name = "imx21-pwm", .driver_data = IS_MX21, },
+	{ .name = "imx25-pwm", .driver_data = IS_MX25, },
+	{ .name = "imx6q-pwm", .driver_data = IS_MX6Q, },
+	{},
+};
+
+static const struct of_device_id mxc_pwm_dt_ids[] = {
+	{
+		.compatible = "fsl,imx6q-pwm",
+		.data = (void *)&pwm_ids[IS_MX6Q]
+	},
+	{ /* sentinel */ }
+};
+
 static struct platform_driver imx_pwm_driver = {
 	.driver		= {
 		.name	= "mxc_pwm",
+		.of_match_table = of_match_ptr(mxc_pwm_dt_ids),
 	},
 	.probe		= imx_pwm_probe,
 	.remove		= __devexit_p(imx_pwm_remove),
-- 
1.7.1
