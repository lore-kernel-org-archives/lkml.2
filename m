Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2JQSA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:00:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932397Ab2JQSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:00:56 -0400
Message-ID: <1350496855.3072.55.camel@joe-AO722>
Subject: [PATCH] wm831x: Add and use a wm831x_irq_byname convenience function
From: Joe Perches <joe@perches.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Date: Wed, 17 Oct 2012 11:00:55 -0700
In-Reply-To: <1350488383.3072.46.camel@joe-AO722>
References: <n> <1350486076-3784-1-git-send-email-antiroot@gmail.com>
	 <1350486076-3784-3-git-send-email-antiroot@gmail.com>
	 <1350488383.3072.46.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use a convenience inline to get an irq by name.

Signed-off-by: Joe Perches <joe@perches.com>
---
Perhaps this is a better alternative to code reflowing.

 include/linux/mfd/wm831x/core.h       |  8 ++++++++
 drivers/input/touchscreen/wm831x-ts.c |  7 ++-----
 drivers/power/wm831x_power.c          | 20 ++++++++------------
 drivers/regulator/wm831x-dcdc.c       | 23 +++++++++--------------
 drivers/regulator/wm831x-ldo.c        | 10 ++++------
 drivers/rtc/rtc-wm831x.c              |  2 +-
 6 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 4a3b83a..96cd081 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -20,6 +20,7 @@
 #include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/regmap.h>
+#include <linux/platform_device.h>
 
 /*
  * Register values.
@@ -425,6 +426,13 @@ static inline int wm831x_irq(struct wm831x *wm831x, int irq)
 	return irq_create_mapping(wm831x->irq_domain, irq);
 }
 
+static inline int wm831x_irq_byname(struct wm831x *wm831x,
+				    struct platform_device *pdev,
+				    const char *name)
+{
+	return wm831x_irq(wm831x, platform_get_irq_byname(pdev, name));
+}
+
 extern struct regmap_config wm831x_regmap_config;
 
 #endif
diff --git a/drivers/input/touchscreen/wm831x-ts.c b/drivers/input/touchscreen/wm831x-ts.c
index 52abb98..82722b3 100644
--- a/drivers/input/touchscreen/wm831x-ts.c
+++ b/drivers/input/touchscreen/wm831x-ts.c
@@ -260,14 +260,11 @@ static __devinit int wm831x_ts_probe(struct platform_device *pdev)
 	 * If we have a direct IRQ use it, otherwise use the interrupt
 	 * from the WM831x IRQ controller.
 	 */
-	wm831x_ts->data_irq = wm831x_irq(wm831x,
-					 platform_get_irq_byname(pdev,
-								 "TCHDATA"));
+	wm831x_ts->data_irq = wm831x_irq_byname(wm831x, pdev, "TCHDATA");
 	if (pdata && pdata->data_irq)
 		wm831x_ts->data_irq = pdata->data_irq;
 
-	wm831x_ts->pd_irq = wm831x_irq(wm831x,
-				       platform_get_irq_byname(pdev, "TCHPD"));
+	wm831x_ts->pd_irq = wm831x_irq_byname(wm831x, pdev, "TCHPD");
 	if (pdata && pdata->pd_irq)
 		wm831x_ts->pd_irq = pdata->pd_irq;
 
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index fc1ad95..39a6125 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -565,7 +565,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 			    goto err_usb;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
+	irq = wm831x_irq_byname(wm831x, pdev, "SYSLO");
 	ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq,
 				   IRQF_TRIGGER_RISING, "System power low",
 				   power);
@@ -575,7 +575,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 		goto err_battery;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
+	irq = wm831x_irq_byname(wm831x, pdev, "PWR SRC");
 	ret = request_threaded_irq(irq, NULL, wm831x_pwr_src_irq,
 				   IRQF_TRIGGER_RISING, "Power source",
 				   power);
@@ -586,9 +586,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
-		irq = wm831x_irq(wm831x,
-				 platform_get_irq_byname(pdev,
-							 wm831x_bat_irqs[i]));
+		irq = wm831x_irq_byname(wm831x, pdev, wm831x_bat_irqs[i]);
 		ret = request_threaded_irq(irq, NULL, wm831x_bat_irq,
 					   IRQF_TRIGGER_RISING,
 					   wm831x_bat_irqs[i],
@@ -608,10 +606,10 @@ err_bat_irq:
 		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
 		free_irq(irq, power);
 	}
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
+	irq = wm831x_irq_byname(wm831x, pdev, "PWR SRC");
 	free_irq(irq, power);
 err_syslo:
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
+	irq = wm831x_irq_byname(wm831x, pdev, "SYSLO");
 	free_irq(irq, power);
 err_battery:
 	if (power->have_battery)
@@ -632,16 +630,14 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
 	int irq, i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
-		irq = wm831x_irq(wm831x, 
-				 platform_get_irq_byname(pdev,
-							 wm831x_bat_irqs[i]));
+		irq = wm831x_irq_byname(wm831x, pdev, wm831x_bat_irqs[i]);
 		free_irq(irq, wm831x_power);
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
+	irq = wm831x_irq_byname(wm831x, pdev, "PWR SRC");
 	free_irq(irq, wm831x_power);
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
+	irq = wm831x_irq_byname(wm831x, pdev, "SYSLO");
 	free_irq(irq, wm831x_power);
 
 	if (wm831x_power->have_battery)
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 782c228..b6bd0be 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -529,7 +529,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
+	irq = wm831x_irq_byname(wm831x, pdev, "UV");
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
@@ -538,7 +538,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		goto err_regulator;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC"));
+	irq = wm831x_irq_byname(wm831x, pdev, "HC");
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
@@ -552,8 +552,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	return 0;
 
 err_uv:
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
+	free_irq(wm831x_irq_byname(wm831x, pdev, "UV"), dcdc);
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
@@ -569,10 +568,8 @@ static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC")),
-			    dcdc);
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
+	free_irq(wm831x_irq_byname(wm831x, pdev, "HC"), dcdc);
+	free_irq(wm831x_irq_byname(wm831x, pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
@@ -691,7 +688,7 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
+	irq = wm831x_irq_byname(wm831x, pdev, "UV");
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING,	dcdc->name, dcdc);
 	if (ret != 0) {
@@ -716,8 +713,7 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
+	free_irq(wm831x_irq_byname(dcdc->wm831x, pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
@@ -825,7 +821,7 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
+	irq = wm831x_irq_byname(wm831x, pdev, "UV");
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name,
 				   dcdc);
@@ -851,8 +847,7 @@ static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
+	free_irq(wm831x_irq_byname(dcdc->wm831x, pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index c2dc039..6cada4a 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -314,7 +314,7 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
+	irq = wm831x_irq_byname(wm831x, pdev, "UV");
 	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
 				   IRQF_TRIGGER_RISING, ldo->name,
 				   ldo);
@@ -340,8 +340,7 @@ static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(wm831x_irq(ldo->wm831x,
-			    platform_get_irq_byname(pdev, "UV")), ldo);
+	free_irq(wm831x_irq_byname(ldo->wm831x, pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
@@ -571,7 +570,7 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
+	irq = wm831x_irq_byname(wm831x, pdev, "UV");
 	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
 				   IRQF_TRIGGER_RISING, ldo->name, ldo);
 	if (ret != 0) {
@@ -594,8 +593,7 @@ static __devexit int wm831x_aldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(ldo->wm831x, platform_get_irq_byname(pdev, "UV")),
-		 ldo);
+	free_irq(wm831x_irq_byname(ldo->wm831x, pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index ea5c6f8..f111f38 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -416,7 +416,7 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_rtc *wm831x_rtc;
-	int alm_irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "ALM"));
+	int alm_irq = wm831x_irq_byname(wm831x, pdev, "ALM");
 	int ret = 0;
 
 	wm831x_rtc = devm_kzalloc(&pdev->dev, sizeof(*wm831x_rtc), GFP_KERNEL);



