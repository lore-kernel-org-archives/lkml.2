Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1BCEUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:20:20 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40100 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab1BCEUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:20:19 -0500
Date: Wed, 2 Feb 2011 20:20:15 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=" 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/19] mc13xxx: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202202015.0fe392a9@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

In this case, move the various platform_data pointers
to driver_data.  All of the clients which make use of it
are also changed.

Mfd-core makes a copy of platform_data, but driver_data keeps a pointer
to the original data.  Because each cell's platform_data previously
pointed to a local (stack) variable, the various ARM mach types that set
the pdata are updated to keep the memory around.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/arm/mach-imx/mach-mx27_3ds.c     |    8 ++++++--
 arch/arm/mach-imx/mach-pcm038.c       |    6 +++++-
 arch/arm/mach-mx3/mach-mx31_3ds.c     |    6 +++++-
 arch/arm/mach-mx3/mach-mx31moboard.c  |    6 +++++-
 drivers/leds/leds-mc13783.c           |   15 +++++++++------
 drivers/mfd/mc13xxx-core.c            |   20 ++++++--------------
 drivers/regulator/mc13783-regulator.c |    6 +++---
 drivers/regulator/mc13892-regulator.c |    6 +++---
 drivers/regulator/mc13xxx.h           |    1 +
 include/linux/mfd/mc13xxx.h           |    3 +--
 10 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 1643315..edcecaa 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -226,10 +226,14 @@ static struct mc13783_regulator_init_data mx27_3ds_regulators[] = {
 	},
 };
 
-/* MC13783 */
-static struct mc13783_platform_data mc13783_pdata __initdata = {
+static struct mc13783_regulator_platform_data mx27_regs = {
 	.regulators = mx27_3ds_regulators,
 	.num_regulators = ARRAY_SIZE(mx27_3ds_regulators),
+};
+
+/* MC13783 */
+static struct mc13783_platform_data mc13783_pdata __initdata = {
+	.regulators = &mx27_regs,
 	.flags  = MC13783_USE_REGULATOR,
 };
 
diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index 5056148..b5ae8cc 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -262,9 +262,13 @@ static struct mc13783_regulator_init_data pcm038_regulators[] = {
 	},
 };
 
-static struct mc13783_platform_data pcm038_pmic = {
+static struct mc13783_regulator_platform_data pcm038_regs = {
 	.regulators = pcm038_regulators,
 	.num_regulators = ARRAY_SIZE(pcm038_regulators),
+};
+
+static struct mc13783_platform_data pcm038_pmic = {
+	.regulators = &pcm038_regs,
 	.flags = MC13783_USE_ADC | MC13783_USE_REGULATOR |
 		 MC13783_USE_TOUCHSCREEN,
 };
diff --git a/arch/arm/mach-mx3/mach-mx31_3ds.c b/arch/arm/mach-mx3/mach-mx31_3ds.c
index 0d65db8..3e613ee 100644
--- a/arch/arm/mach-mx3/mach-mx31_3ds.c
+++ b/arch/arm/mach-mx3/mach-mx31_3ds.c
@@ -156,9 +156,13 @@ static struct mc13783_regulator_init_data mx31_3ds_regulators[] = {
 };
 
 /* MC13783 */
-static struct mc13783_platform_data mc13783_pdata __initdata = {
+static struct mc13783_regulator_platform_data mc13783_regs = {
 	.regulators = mx31_3ds_regulators,
 	.num_regulators = ARRAY_SIZE(mx31_3ds_regulators),
+};
+
+static struct mc13783_platform_data mc13783_pdata __initdata = {
+	.regulators = &mc13783_regs,
 	.flags  = MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN,
 };
 
diff --git a/arch/arm/mach-mx3/mach-mx31moboard.c b/arch/arm/mach-mx3/mach-mx31moboard.c
index 1aa8d65..424fbd9 100644
--- a/arch/arm/mach-mx3/mach-mx31moboard.c
+++ b/arch/arm/mach-mx3/mach-mx31moboard.c
@@ -267,9 +267,13 @@ static struct mc13783_leds_platform_data moboard_leds = {
 	.tc2_period = MC13783_LED_PERIOD_10MS,
 };
 
-static struct mc13783_platform_data moboard_pmic = {
+static struct mc13783_regulator_platform_data moboard_regs = {
 	.regulators = moboard_regulators,
 	.num_regulators = ARRAY_SIZE(moboard_regulators),
+};
+
+static struct mc13783_platform_data moboard_pmic = {
+	.regulators = &moboard_regs,
 	.leds = &moboard_leds,
 	.flags = MC13783_USE_REGULATOR | MC13783_USE_RTC |
 		MC13783_USE_ADC | MC13783_USE_LED,
diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index f05bb08..687fb13 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -30,6 +30,7 @@ struct mc13783_led {
 	struct mc13783		*master;
 	enum led_brightness	new_brightness;
 	int			id;
+	int			num_leds;
 };
 
 #define MC13783_REG_LED_CONTROL_0	51
@@ -181,9 +182,9 @@ static int __devinit mc13783_led_setup(struct mc13783_led *led, int max_current)
 	return ret;
 }
 
-static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
+static int __devinit mc13783_leds_prepare(struct platform_device *pdev,
+		struct mc13783_leds_platform_data *pdata)
 {
-	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
 	int ret = 0;
 	int reg = 0;
@@ -264,7 +265,7 @@ out:
 
 static int __devinit mc13783_led_probe(struct platform_device *pdev)
 {
-	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct mc13783_leds_platform_data *pdata = platform_get_drvdata(pdev);
 	struct mc13783_led_platform_data *led_cur;
 	struct mc13783_led *led, *led_dat;
 	int ret, i;
@@ -286,12 +287,15 @@ static int __devinit mc13783_led_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ret = mc13783_leds_prepare(pdev);
+	ret = mc13783_leds_prepare(pdev, pdata);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to init led driver\n");
 		goto err_free;
 	}
 
+	/* no need to save the num of LEDs for any other elements of 'led' */
+	led[0].num_leds = pdata->num_leds;
+
 	for (i = 0; i < pdata->num_leds; i++) {
 		led_dat = &led[i];
 		led_cur = &pdata->led[i];
@@ -351,12 +355,11 @@ err_free:
 
 static int __devexit mc13783_led_remove(struct platform_device *pdev)
 {
-	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783_led *led = platform_get_drvdata(pdev);
 	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
 	int i;
 
-	for (i = 0; i < pdata->num_leds; i++) {
+	for (i = 0; i < led[0].num_leds; i++) {
 		led_classdev_unregister(&led[i].cdev);
 		cancel_work_sync(&led[i].work);
 	}
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index b9fcaf0..96842d9 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -683,14 +683,13 @@ out:
 EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
 
 static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
-		const char *format, void *pdata, size_t pdata_size)
+		const char *format, void *pdata)
 {
 	char buf[30];
 	const char *name = mc13xxx_get_chipname(mc13xxx);
 
 	struct mfd_cell cell = {
-		.platform_data = pdata,
-		.data_size = pdata_size,
+		.driver_data = pdata,
 	};
 
 	/* there is no asnprintf in the kernel :-( */
@@ -706,7 +705,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 {
-	return mc13xxx_add_subdevice_pdata(mc13xxx, format, NULL, 0);
+	return mc13xxx_add_subdevice_pdata(mc13xxx, format, NULL);
 }
 
 static int mc13xxx_probe(struct spi_device *spi)
@@ -764,13 +763,8 @@ err_revision:
 		mc13xxx_add_subdevice(mc13xxx, "%s-codec");
 
 	if (pdata->flags & MC13XXX_USE_REGULATOR) {
-		struct mc13xxx_regulator_platform_data regulator_pdata = {
-			.num_regulators = pdata->num_regulators,
-			.regulators = pdata->regulators,
-		};
-
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-regulator",
-				&regulator_pdata, sizeof(regulator_pdata));
+				pdata->regulators);
 	}
 
 	if (pdata->flags & MC13XXX_USE_RTC)
@@ -779,10 +773,8 @@ err_revision:
 	if (pdata->flags & MC13XXX_USE_TOUCHSCREEN)
 		mc13xxx_add_subdevice(mc13xxx, "%s-ts");
 
-	if (pdata->flags & MC13XXX_USE_LED) {
-		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led",
-					pdata->leds, sizeof(*pdata->leds));
-	}
+	if (pdata->flags & MC13XXX_USE_LED)
+		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led", pdata->leds);
 
 	return 0;
 }
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 3e5d0c3..40748b7 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -337,7 +337,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx_regulator_priv *priv;
 	struct mc13xxx *mc13783 = dev_get_drvdata(pdev->dev.parent);
 	struct mc13783_regulator_platform_data *pdata =
-		dev_get_platdata(&pdev->dev);
+			platform_get_drvdata(pdev);
 	struct mc13783_regulator_init_data *init_data;
 	int i, ret;
 
@@ -351,6 +351,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 
 	priv->mc13xxx_regulators = mc13783_regulators;
 	priv->mc13xxx = mc13783;
+	priv->pdata = pdata;
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		init_data = &pdata->regulators[i];
@@ -381,8 +382,7 @@ err:
 static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	struct mc13783_regulator_platform_data *pdata =
-		dev_get_platdata(&pdev->dev);
+	struct mc13783_regulator_platform_data *pdata = priv->pdata;
 	int i;
 
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1b8f739..4b3490b 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -521,7 +521,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx_regulator_priv *priv;
 	struct mc13xxx *mc13892 = dev_get_drvdata(pdev->dev.parent);
 	struct mc13xxx_regulator_platform_data *pdata =
-		dev_get_platdata(&pdev->dev);
+			platform_get_drvdata(pdev);
 	struct mc13xxx_regulator_init_data *init_data;
 	int i, ret;
 	u32 val;
@@ -534,6 +534,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 
 	priv->mc13xxx_regulators = mc13892_regulators;
 	priv->mc13xxx = mc13892;
+	priv->pdata = pdata;
 
 	mc13xxx_lock(mc13892);
 	ret = mc13xxx_reg_read(mc13892, MC13892_REVISION, &val);
@@ -595,8 +596,7 @@ err_free:
 static int __devexit mc13892_regulator_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	struct mc13xxx_regulator_platform_data *pdata =
-		dev_get_platdata(&pdev->dev);
+	struct mc13xxx_regulator_platform_data *pdata = priv->pdata;
 	int i;
 
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 2775826..5430177 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -28,6 +28,7 @@ struct mc13xxx_regulator {
 struct mc13xxx_regulator_priv {
 	struct mc13xxx *mc13xxx;
 	u32 powermisc_pwgt_state;
+	struct mc13xxx_regulator_platform_data *pdata;
 	struct mc13xxx_regulator *mc13xxx_regulators;
 	struct regulator_dev *regulators[];
 };
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index a1d391b..052b133 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -146,8 +146,7 @@ struct mc13xxx_platform_data {
 #define MC13XXX_USE_LED		(1 << 5)
 	unsigned int flags;
 
-	int num_regulators;
-	struct mc13xxx_regulator_init_data *regulators;
+	struct mc13xxx_regulator_platform_data *regulators;
 	struct mc13xxx_leds_platform_data *leds;
 };
 
-- 
1.7.2.3

