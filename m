Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2EMVTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 17:19:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47309 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab2EMVTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 17:19:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Anton Vorontsov <cbou@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm831x: Convert to irq_domain
Date: Sun, 13 May 2012 22:18:56 +0100
Message-Id: <1336943936-27999-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modern idiom is to use irq_domain to allocate interrupts. This is
useful partly to allow further infrastructure to be based on the domains
and partly because it makes it much easier to allocate virtual interrupts
to devices as we don't need to allocate a contiguous range of interrupt
numbers.

Convert the wm831x driver over to this infrastructure, using a legacy
IRQ mapping if an irq_base is specified in platform data and otherwise
using a linear mapping, always registering the interrupts even if they
won't ever be used. Only boards which need to use the GPIOs as
interrupts should need to use an irq_base.

This means that we can't use the MFD irq_base management since the
unless we're using an explicit irq_base from platform data we can't rely
on a linear mapping of interrupts.  Instead we need to map things via
the irq_domain - provide a conveniencem function wm831x_irq() to save a
small amount of typing when doing so. Looking at this I couldn't clearly
see anything the MFD core could do to make this nicer.

Since we're not supporting device tree yet there's no meaningful
advantage if we don't do this conversion in one, the fact that the
interrupt resources are used for repeated IP blocks makes accessor
functions for the irq_domain more trouble to do than they're worth.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-wm831x.c            |    6 +-
 drivers/input/misc/wm831x-on.c        |    2 +-
 drivers/input/touchscreen/wm831x-ts.c |    9 +--
 drivers/mfd/Kconfig                   |    2 +
 drivers/mfd/wm831x-auxadc.c           |    6 +-
 drivers/mfd/wm831x-core.c             |   19 +++----
 drivers/mfd/wm831x-irq.c              |  101 +++++++++++++++++++++------------
 drivers/power/wm831x_power.c          |   21 ++++---
 drivers/regulator/wm831x-dcdc.c       |   24 +++++---
 drivers/regulator/wm831x-isink.c      |    4 +-
 drivers/regulator/wm831x-ldo.c        |   10 ++--
 drivers/rtc/rtc-wm831x.c              |    2 +-
 include/linux/mfd/wm831x/core.h       |    9 ++-
 13 files changed, 131 insertions(+), 84 deletions(-)

diff --git a/drivers/gpio/gpio-wm831x.c b/drivers/gpio/gpio-wm831x.c
index deb949e..e56a216 100644
--- a/drivers/gpio/gpio-wm831x.c
+++ b/drivers/gpio/gpio-wm831x.c
@@ -102,10 +102,8 @@ static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
 
-	if (!wm831x->irq_base)
-		return -EINVAL;
-
-	return wm831x->irq_base + WM831X_IRQ_GPIO_1 + offset;
+	return irq_create_mapping(wm831x->irq_domain,
+				  WM831X_IRQ_GPIO_1 + offset);
 }
 
 static int wm831x_gpio_set_debounce(struct gpio_chip *chip, unsigned offset,
diff --git a/drivers/input/misc/wm831x-on.c b/drivers/input/misc/wm831x-on.c
index aee53fb..fa8b390 100644
--- a/drivers/input/misc/wm831x-on.c
+++ b/drivers/input/misc/wm831x-on.c
@@ -73,7 +73,7 @@ static int __devinit wm831x_on_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_on *wm831x_on;
-	int irq = platform_get_irq(pdev, 0);
+	int irq = wm831x_irq(wm831x, platform_get_irq(pdev, 0));
 	int ret;
 
 	wm831x_on = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_on),
diff --git a/drivers/input/touchscreen/wm831x-ts.c b/drivers/input/touchscreen/wm831x-ts.c
index e34c10a..362f78d 100644
--- a/drivers/input/touchscreen/wm831x-ts.c
+++ b/drivers/input/touchscreen/wm831x-ts.c
@@ -261,15 +261,16 @@ static __devinit int wm831x_ts_probe(struct platform_device *pdev)
 	 * If we have a direct IRQ use it, otherwise use the interrupt
 	 * from the WM831x IRQ controller.
 	 */
+	wm831x_ts->data_irq = wm831x_irq(wm831x,
+					 platform_get_irq_byname(pdev,
+								 "TCHDATA"));
 	if (pdata && pdata->data_irq)
 		wm831x_ts->data_irq = pdata->data_irq;
-	else
-		wm831x_ts->data_irq = platform_get_irq_byname(pdev, "TCHDATA");
 
+	wm831x_ts->pd_irq = wm831x_irq(wm831x,
+				       platform_get_irq_byname(pdev, "TCHPD"));
 	if (pdata && pdata->pd_irq)
 		wm831x_ts->pd_irq = pdata->pd_irq;
-	else
-		wm831x_ts->pd_irq = platform_get_irq_byname(pdev, "TCHPD");
 
 	if (pdata)
 		wm831x_ts->pressure = pdata->pressure;
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9846424..8a767a6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -487,6 +487,7 @@ config MFD_WM831X_I2C
 	select MFD_CORE
 	select MFD_WM831X
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
@@ -499,6 +500,7 @@ config MFD_WM831X_SPI
 	select MFD_CORE
 	select MFD_WM831X
 	select REGMAP_SPI
+	select IRQ_DOMAIN
 	depends on SPI_MASTER && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
diff --git a/drivers/mfd/wm831x-auxadc.c b/drivers/mfd/wm831x-auxadc.c
index 8721095..6ee3018 100644
--- a/drivers/mfd/wm831x-auxadc.c
+++ b/drivers/mfd/wm831x-auxadc.c
@@ -280,11 +280,11 @@ void wm831x_auxadc_init(struct wm831x *wm831x)
 	mutex_init(&wm831x->auxadc_lock);
 	INIT_LIST_HEAD(&wm831x->auxadc_pending);
 
-	if (wm831x->irq && wm831x->irq_base) {
+	if (wm831x->irq) {
 		wm831x->auxadc_read = wm831x_auxadc_read_irq;
 
-		ret = request_threaded_irq(wm831x->irq_base +
-					   WM831X_IRQ_AUXADC_DATA,
+		ret = request_threaded_irq(wm831x_irq(wm831x,
+						      WM831X_IRQ_AUXADC_DATA),
 					   NULL, wm831x_auxadc_irq, 0,
 					   "auxadc", wm831x);
 		if (ret < 0) {
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 476e4d3..946698f 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1813,27 +1813,27 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8310:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8310_devs, ARRAY_SIZE(wm8310_devs),
-				      NULL, wm831x->irq_base);
+				      NULL, 0);
 		break;
 
 	case WM8311:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
-				      NULL, wm831x->irq_base);
+				      NULL, 0);
 		if (!pdata || !pdata->disable_touch)
 			mfd_add_devices(wm831x->dev, wm831x_num,
 					touch_devs, ARRAY_SIZE(touch_devs),
-					NULL, wm831x->irq_base);
+					NULL, 0);
 		break;
 
 	case WM8312:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
-				      NULL, wm831x->irq_base);
+				      NULL, 0);
 		if (!pdata || !pdata->disable_touch)
 			mfd_add_devices(wm831x->dev, wm831x_num,
 					touch_devs, ARRAY_SIZE(touch_devs),
-					NULL, wm831x->irq_base);
+					NULL, 0);
 		break;
 
 	case WM8320:
@@ -1842,7 +1842,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8326:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, wm831x->irq_base);
+				      NULL, 0);
 		break;
 
 	default:
@@ -1867,7 +1867,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	if (ret & WM831X_XTAL_ENA) {
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      rtc_devs, ARRAY_SIZE(rtc_devs),
-				      NULL, wm831x->irq_base);
+				      NULL, 0);
 		if (ret != 0) {
 			dev_err(wm831x->dev, "Failed to add RTC: %d\n", ret);
 			goto err_irq;
@@ -1880,7 +1880,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		/* Treat errors as non-critical */
 		ret = mfd_add_devices(wm831x->dev, wm831x_num, backlight_devs,
 				      ARRAY_SIZE(backlight_devs), NULL,
-				      wm831x->irq_base);
+				      0);
 		if (ret < 0)
 			dev_err(wm831x->dev, "Failed to add backlight: %d\n",
 				ret);
@@ -1909,8 +1909,7 @@ void wm831x_device_exit(struct wm831x *wm831x)
 {
 	wm831x_otp_exit(wm831x);
 	mfd_remove_devices(wm831x->dev);
-	if (wm831x->irq_base)
-		free_irq(wm831x->irq_base + WM831X_IRQ_AUXADC_DATA, wm831x);
+	free_irq(wm831x_irq(wm831x, WM831X_IRQ_AUXADC_DATA), wm831x);
 	wm831x_irq_exit(wm831x);
 }
 
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 2be9628..ecc9d6d 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -18,6 +18,7 @@
 #include <linux/irq.h>
 #include <linux/mfd/core.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
@@ -328,7 +329,7 @@ static inline int irq_data_to_status_reg(struct wm831x_irq_data *irq_data)
 static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 							int irq)
 {
-	return &wm831x_irqs[irq - wm831x->irq_base];
+	return &wm831x_irqs[irq];
 }
 
 static void wm831x_irq_lock(struct irq_data *data)
@@ -374,7 +375,7 @@ static void wm831x_irq_enable(struct irq_data *data)
 {
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
-							     data->irq);
+							     data->hwirq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
@@ -383,7 +384,7 @@ static void wm831x_irq_disable(struct irq_data *data)
 {
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
-							     data->irq);
+							     data->hwirq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
@@ -393,7 +394,7 @@ static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	int irq;
 
-	irq = data->irq - wm831x->irq_base;
+	irq = data->hwirq;
 
 	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
 		/* Ignore internal-only IRQs */
@@ -469,9 +470,11 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 	 * descriptors.
 	 */
 	if (primary & WM831X_TCHPD_INT)
-		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHPD);
+		handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
+						   WM831X_IRQ_TCHPD));
 	if (primary & WM831X_TCHDATA_INT)
-		handle_nested_irq(wm831x->irq_base + WM831X_IRQ_TCHDATA);
+		handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
+						   WM831X_IRQ_TCHDATA));
 	primary &= ~(WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT);
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_irqs); i++) {
@@ -507,7 +510,8 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		}
 
 		if (*status & wm831x_irqs[i].mask)
-			handle_nested_irq(wm831x->irq_base + i);
+			handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
+							   i));
 
 		/* Simulate an edge triggered IRQ by polling the input
 		 * status.  This is sucky but improves interoperability.
@@ -516,7 +520,8 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		    wm831x->gpio_level[i - WM831X_IRQ_GPIO_1]) {
 			ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
 			while (ret & 1 << (i - WM831X_IRQ_GPIO_1)) {
-				handle_nested_irq(wm831x->irq_base + i);
+				handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
+								   i));
 				ret = wm831x_reg_read(wm831x,
 						      WM831X_GPIO_LEVEL);
 			}
@@ -527,10 +532,34 @@ out:
 	return IRQ_HANDLED;
 }
 
+static int wm831x_irq_map(struct irq_domain *h, unsigned int virq,
+			  irq_hw_number_t hw)
+{
+	irq_set_chip_data(virq, h->host_data);
+	irq_set_chip_and_handler(virq, &wm831x_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops wm831x_irq_domain_ops = {
+	.map	= wm831x_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
 int wm831x_irq_init(struct wm831x *wm831x, int irq)
 {
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int i, cur_irq, ret;
+	struct irq_domain *domain;
+	int i, ret, irq_base;
 
 	mutex_init(&wm831x->irq_lock);
 
@@ -543,18 +572,33 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	}
 
 	/* Try to dynamically allocate IRQs if no base is specified */
-	if (!pdata || !pdata->irq_base)
-		wm831x->irq_base = -1;
+	if (pdata && pdata->irq_base) {
+		irq_base = irq_alloc_descs(pdata->irq_base, 0,
+					   WM831X_NUM_IRQS, 0);
+		if (irq_base < 0) {
+			dev_warn(wm831x->dev, "Failed to allocate IRQs: %d\n",
+				 irq_base);
+			irq_base = 0;
+		}
+	} else {
+		irq_base = 0;
+	}
+
+	if (irq_base)
+		domain = irq_domain_add_legacy(wm831x->dev->of_node,
+					       ARRAY_SIZE(wm831x_irqs),
+					       irq_base, 0,
+					       &wm831x_irq_domain_ops,
+					       wm831x);
 	else
-		wm831x->irq_base = pdata->irq_base;
+		domain = irq_domain_add_linear(wm831x->dev->of_node,
+					       ARRAY_SIZE(wm831x_irqs),
+					       &wm831x_irq_domain_ops,
+					       wm831x);
 
-	wm831x->irq_base = irq_alloc_descs(wm831x->irq_base, 0,
-					   WM831X_NUM_IRQS, 0);
-	if (wm831x->irq_base < 0) {
-		dev_warn(wm831x->dev, "Failed to allocate IRQs: %d\n",
-			 wm831x->irq_base);
-		wm831x->irq_base = 0;
-		return 0;
+	if (!domain) {
+		dev_warn(wm831x->dev, "Failed to allocate IRQ domain\n");
+		return -EINVAL;
 	}
 
 	if (pdata && pdata->irq_cmos)
@@ -566,24 +610,7 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 			WM831X_IRQ_OD, i);
 
 	wm831x->irq = irq;
-
-	/* Register them with genirq */
-	for (cur_irq = wm831x->irq_base;
-	     cur_irq < ARRAY_SIZE(wm831x_irqs) + wm831x->irq_base;
-	     cur_irq++) {
-		irq_set_chip_data(cur_irq, wm831x);
-		irq_set_chip_and_handler(cur_irq, &wm831x_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-
-		/* ARM needs us to explicitly flag the IRQ as valid
-		 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
-	}
+	wm831x->irq_domain = domain;
 
 	if (irq) {
 		/* Try to flag /IRQ as a wake source; there are a number of
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 987332b..fc1ad95 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -565,7 +565,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 			    goto err_usb;
 	}
 
-	irq = platform_get_irq_byname(pdev, "SYSLO");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
 	ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq,
 				   IRQF_TRIGGER_RISING, "System power low",
 				   power);
@@ -575,7 +575,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 		goto err_battery;
 	}
 
-	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
 	ret = request_threaded_irq(irq, NULL, wm831x_pwr_src_irq,
 				   IRQF_TRIGGER_RISING, "Power source",
 				   power);
@@ -586,7 +586,9 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
-		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
+		irq = wm831x_irq(wm831x,
+				 platform_get_irq_byname(pdev,
+							 wm831x_bat_irqs[i]));
 		ret = request_threaded_irq(irq, NULL, wm831x_bat_irq,
 					   IRQF_TRIGGER_RISING,
 					   wm831x_bat_irqs[i],
@@ -606,10 +608,10 @@ err_bat_irq:
 		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
 		free_irq(irq, power);
 	}
-	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
 	free_irq(irq, power);
 err_syslo:
-	irq = platform_get_irq_byname(pdev, "SYSLO");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
 	free_irq(irq, power);
 err_battery:
 	if (power->have_battery)
@@ -626,17 +628,20 @@ err_kmalloc:
 static __devexit int wm831x_power_remove(struct platform_device *pdev)
 {
 	struct wm831x_power *wm831x_power = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = wm831x_power->wm831x;
 	int irq, i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
-		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
+		irq = wm831x_irq(wm831x, 
+				 platform_get_irq_byname(pdev,
+							 wm831x_bat_irqs[i]));
 		free_irq(irq, wm831x_power);
 	}
 
-	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
 	free_irq(irq, wm831x_power);
 
-	irq = platform_get_irq_byname(pdev, "SYSLO");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
 	free_irq(irq, wm831x_power);
 
 	if (wm831x_power->have_battery)
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 8710cfb..d685911 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -535,7 +535,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq_byname(pdev, "UV");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
@@ -544,7 +544,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 		goto err_regulator;
 	}
 
-	irq = platform_get_irq_byname(pdev, "HC");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC"));
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
@@ -558,7 +558,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	return 0;
 
 err_uv:
-	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
+		 dcdc);
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
@@ -570,11 +571,14 @@ err:
 static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(platform_get_irq_byname(pdev, "HC"), dcdc);
-	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC")),
+			    dcdc);
+	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
+			    dcdc);
 	regulator_unregister(dcdc->regulator);
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
@@ -726,7 +730,7 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq_byname(pdev, "UV");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING,	dcdc->name, dcdc);
 	if (ret != 0) {
@@ -751,7 +755,8 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
+			    dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
@@ -858,7 +863,7 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq_byname(pdev, "UV");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
 	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
 				   IRQF_TRIGGER_RISING, dcdc->name,
 				   dcdc);
@@ -884,7 +889,8 @@ static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
+		 dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index b50ab77..0d207c2 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -202,7 +202,7 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq(pdev, 0);
+	irq = wm831x_irq(wm831x, platform_get_irq(pdev, 0));
 	ret = request_threaded_irq(irq, NULL, wm831x_isink_irq,
 				   IRQF_TRIGGER_RISING, isink->name, isink);
 	if (ret != 0) {
@@ -227,7 +227,7 @@ static __devexit int wm831x_isink_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(platform_get_irq(pdev, 0), isink);
+	free_irq(wm831x_irq(isink->wm831x, platform_get_irq(pdev, 0)), isink);
 
 	regulator_unregister(isink->regulator);
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index aa1f8b3..a9a28d8 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -321,7 +321,7 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq_byname(pdev, "UV");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
 	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
 				   IRQF_TRIGGER_RISING, ldo->name,
 				   ldo);
@@ -347,7 +347,8 @@ static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
+	free_irq(wm831x_irq(ldo->wm831x,
+			    platform_get_irq_byname(pdev, "UV")), ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
@@ -582,7 +583,7 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	irq = platform_get_irq_byname(pdev, "UV");
+	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
 	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
 				   IRQF_TRIGGER_RISING, ldo->name, ldo);
 	if (ret != 0) {
@@ -605,7 +606,8 @@ static __devexit int wm831x_aldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
-	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
+	free_irq(wm831x_irq(ldo->wm831x, platform_get_irq_byname(pdev, "UV")),
+		 ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 3b6e6a6..59c6245 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -396,7 +396,7 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_rtc *wm831x_rtc;
-	int alm_irq = platform_get_irq_byname(pdev, "ALM");
+	int alm_irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "ALM"));
 	int ret = 0;
 
 	wm831x_rtc = devm_kzalloc(&pdev->dev, sizeof(*wm831x_rtc), GFP_KERNEL);
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 4b12118..736191c 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -17,6 +17,7 @@
 
 #include <linux/completion.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/regmap.h>
 
@@ -338,6 +339,7 @@
 #define WM831X_FLL_CLK_SRC_WIDTH                     2  /* FLL_CLK_SRC - [1:0] */
 
 struct regulator_dev;
+struct irq_domain;
 
 #define WM831X_NUM_IRQ_REGS 5
 #define WM831X_NUM_GPIO_REGS 16
@@ -367,7 +369,7 @@ struct wm831x {
 
 	int irq;  /* Our chip IRQ */
 	struct mutex irq_lock;
-	int irq_base;
+	struct irq_domain *irq_domain;
 	int irq_masks_cur[WM831X_NUM_IRQ_REGS];   /* Currently active value */
 	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
 
@@ -417,6 +419,11 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq);
 void wm831x_irq_exit(struct wm831x *wm831x);
 void wm831x_auxadc_init(struct wm831x *wm831x);
 
+static inline int wm831x_irq(struct wm831x *wm831x, int irq)
+{
+	return irq_create_mapping(wm831x->irq_domain, irq);
+}
+
 extern struct regmap_config wm831x_regmap_config;
 
 #endif
-- 
1.7.10

