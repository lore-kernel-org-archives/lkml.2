Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1EIAez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:34:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:34496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1EIAdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="744199454"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 13/19] mfd: Use mfd cell platform_data for mc13xxx cells platform bits
Date: Mon,  9 May 2011 02:32:05 +0200
Message-Id: <1304901131-7104-14-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/leds/leds-mc13783.c           |    7 +++----
 drivers/mfd/mc13xxx-core.c            |   12 +++++++-----
 drivers/regulator/mc13783-regulator.c |    7 ++++---
 drivers/regulator/mc13892-regulator.c |    7 ++++---
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index 06a5bb4..f05bb08 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -22,7 +22,6 @@
 #include <linux/leds.h>
 #include <linux/workqueue.h>
 #include <linux/mfd/mc13783.h>
-#include <linux/mfd/core.h>
 #include <linux/slab.h>
 
 struct mc13783_led {
@@ -184,7 +183,7 @@ static int __devinit mc13783_led_setup(struct mc13783_led *led, int max_current)
 
 static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
 {
-	struct mc13783_leds_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
 	int ret = 0;
 	int reg = 0;
@@ -265,7 +264,7 @@ out:
 
 static int __devinit mc13783_led_probe(struct platform_device *pdev)
 {
-	struct mc13783_leds_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783_led_platform_data *led_cur;
 	struct mc13783_led *led, *led_dat;
 	int ret, i;
@@ -352,7 +351,7 @@ err_free:
 
 static int __devexit mc13783_led_remove(struct platform_device *pdev)
 {
-	struct mc13783_leds_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct mc13783_led *led = platform_get_drvdata(pdev);
 	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
 	int i;
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 668634e..7e4d44b 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -683,13 +683,14 @@ out:
 EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
 
 static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
-		const char *format, void *pdata)
+		const char *format, void *pdata, size_t pdata_size)
 {
 	char buf[30];
 	const char *name = mc13xxx_get_chipname(mc13xxx);
 
 	struct mfd_cell cell = {
-		.mfd_data = pdata,
+		.platform_data = pdata,
+		.pdata_size = pdata_size,
 	};
 
 	/* there is no asnprintf in the kernel :-( */
@@ -705,7 +706,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 
 static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 {
-	return mc13xxx_add_subdevice_pdata(mc13xxx, format, NULL);
+	return mc13xxx_add_subdevice_pdata(mc13xxx, format, NULL, 0);
 }
 
 static int mc13xxx_probe(struct spi_device *spi)
@@ -764,7 +765,7 @@ err_revision:
 
 	if (pdata->flags & MC13XXX_USE_REGULATOR) {
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-regulator",
-				&pdata->regulators);
+				&pdata->regulators, sizeof(pdata->regulators));
 	}
 
 	if (pdata->flags & MC13XXX_USE_RTC)
@@ -774,7 +775,8 @@ err_revision:
 		mc13xxx_add_subdevice(mc13xxx, "%s-ts");
 
 	if (pdata->flags & MC13XXX_USE_LED)
-		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led", pdata->leds);
+		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led",
+				pdata->leds, sizeof(*pdata->leds));
 
 	return 0;
 }
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 23249cb..3e5d0c3 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -15,7 +15,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
-#include <linux/mfd/core.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
@@ -337,7 +336,8 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv;
 	struct mc13xxx *mc13783 = dev_get_drvdata(pdev->dev.parent);
-	struct mc13783_regulator_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13783_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	struct mc13783_regulator_init_data *init_data;
 	int i, ret;
 
@@ -381,7 +381,8 @@ err:
 static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	struct mc13783_regulator_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13783_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	int i;
 
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 6f15168..1b8f739 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -15,7 +15,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
-#include <linux/mfd/core.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
@@ -521,7 +520,8 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv;
 	struct mc13xxx *mc13892 = dev_get_drvdata(pdev->dev.parent);
-	struct mc13xxx_regulator_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13xxx_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	struct mc13xxx_regulator_init_data *init_data;
 	int i, ret;
 	u32 val;
@@ -595,7 +595,8 @@ err_free:
 static int __devexit mc13892_regulator_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	struct mc13xxx_regulator_platform_data *pdata = mfd_get_data(pdev);
+	struct mc13xxx_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	int i;
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.2.3

