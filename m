Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0DZIlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 04:41:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32346 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DZIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 04:41:16 -0400
X-IronPort-AV: E=Sophos;i="4.52,272,1270440000"; 
   d="scan'208";a="15856478"
From: <michael.hennerich@analog.com>
To: gregkh@suse.de
CC: jic23@cam.ac.uk, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
       Michael Hennerich <Michael.Hennerich@analog.com>
Subject: [PATCH] iio-trig-gpio:Remove redundant gpio_request
Date: Mon, 26 Apr 2010 10:36:36 +0200
Message-ID: <1272270996-3495-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant gpio_request:
The GPIO used as trigger IRQ, is also requested as gpio, but actually never read.

Use platform resource facility to get IRQs numbers and flags.
Make sure this driver can be used with any system IRQ, not necessarily limited to GPIO-IRQs.
Use dev_err(dev...) and friends instead of printk(KERN_ERR...)

Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

 drivers/staging/iio/trigger/iio-trig-gpio.c |  127 +++++++++++++--------------
 1 files changed, 61 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/iio/trigger/iio-trig-gpio.c b/drivers/staging/iio/trigger/iio-trig-gpio.c
index 539e416..6e64a76 100644
--- a/drivers/staging/iio/trigger/iio-trig-gpio.c
+++ b/drivers/staging/iio/trigger/iio-trig-gpio.c
@@ -13,7 +13,6 @@
  * TODO:
  *
  * Add board config elements to allow specification of startup settings.
- * Add configuration settings (irq type etc)
  */
 
 #include <linux/kernel.h>
@@ -30,7 +29,7 @@ DEFINE_MUTEX(iio_gpio_trigger_list_lock);
 
 struct iio_gpio_trigger_info {
 	struct mutex in_use;
-	int gpio;
+	unsigned int irq;
 };
 /*
  * Need to reference count these triggers and only enable gpio interrupts
@@ -57,78 +56,77 @@ static const struct attribute_group iio_gpio_trigger_attr_group = {
 	.attrs = iio_gpio_trigger_attrs,
 };
 
-static int iio_gpio_trigger_probe(struct platform_device *dev)
+static int iio_gpio_trigger_probe(struct platform_device *pdev)
 {
-	int *pdata = dev->dev.platform_data;
 	struct iio_gpio_trigger_info *trig_info;
 	struct iio_trigger *trig, *trig2;
-	int i, irq, ret = 0;
-	if (!pdata) {
-		printk(KERN_ERR "No IIO gpio trigger platform data found\n");
-		goto error_ret;
-	}
-	for (i = 0;; i++) {
-		if (!gpio_is_valid(pdata[i]))
-			break;
-		trig = iio_allocate_trigger();
-		if (!trig) {
-			ret = -ENOMEM;
-			goto error_free_completed_registrations;
-		}
+	unsigned long irqflags;
+	struct resource *irq_res;
+	int irq, ret = 0, irq_res_cnt = 0;
 
-		trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
-		if (!trig_info) {
-			ret = -ENOMEM;
-			goto error_put_trigger;
-		}
-		trig->control_attrs = &iio_gpio_trigger_attr_group;
-		trig->private_data = trig_info;
-		trig_info->gpio = pdata[i];
-		trig->owner = THIS_MODULE;
-		trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
-		if (!trig->name) {
-			ret = -ENOMEM;
-			goto error_free_trig_info;
+	do {
+		irq_res = platform_get_resource(pdev,
+				IORESOURCE_IRQ, irq_res_cnt);
+
+		if (irq_res == NULL) {
+			if (irq_res_cnt == 0)
+				dev_err(&pdev->dev, "No GPIO IRQs specified");
+			break;
 		}
-		snprintf((char *)trig->name,
-			 IIO_TRIGGER_NAME_LENGTH,
-			 "gpiotrig%d",
-			 pdata[i]);
-		ret = gpio_request(trig_info->gpio, trig->name);
-		if (ret)
-			goto error_free_name;
-
-		ret = gpio_direction_input(trig_info->gpio);
-		if (ret)
-			goto error_release_gpio;
-
-		irq = gpio_to_irq(trig_info->gpio);
-		if (irq < 0) {
-			ret = irq;
-			goto error_release_gpio;
+		irqflags = (irq_res->flags & IRQF_TRIGGER_MASK) | IRQF_SHARED;
+
+		for (irq = irq_res->start; irq <= irq_res->end; irq++) {
+
+			trig = iio_allocate_trigger();
+			if (!trig) {
+				ret = -ENOMEM;
+				goto error_free_completed_registrations;
+			}
+
+			trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+			if (!trig_info) {
+				ret = -ENOMEM;
+				goto error_put_trigger;
+			}
+			trig->control_attrs = &iio_gpio_trigger_attr_group;
+			trig->private_data = trig_info;
+			trig_info->irq = irq;
+			trig->owner = THIS_MODULE;
+			trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH,
+					GFP_KERNEL);
+			if (!trig->name) {
+				ret = -ENOMEM;
+				goto error_free_trig_info;
+			}
+			snprintf((char *)trig->name,
+				 IIO_TRIGGER_NAME_LENGTH,
+				 "irqtrig%d", irq);
+
+			ret = request_irq(irq, iio_gpio_trigger_poll,
+					  irqflags, trig->name, trig);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"request IRQ-%d failed", irq);
+				goto error_free_name;
+			}
+
+			ret = iio_trigger_register(trig);
+			if (ret)
+				goto error_release_irq;
+
+			list_add_tail(&trig->alloc_list,
+					&iio_gpio_trigger_list);
 		}
 
-		ret = request_irq(irq, iio_gpio_trigger_poll,
-				  IRQF_TRIGGER_RISING,
-				  trig->name,
-				  trig);
-		if (ret)
-			goto error_release_gpio;
+		irq_res_cnt++;
+	} while (irq_res != NULL);
 
-		ret = iio_trigger_register(trig);
-		if (ret)
-			goto error_release_irq;
 
-		list_add_tail(&trig->alloc_list, &iio_gpio_trigger_list);
-
-	}
 	return 0;
 
 /* First clean up the partly allocated trigger */
 error_release_irq:
 	free_irq(irq, trig);
-error_release_gpio:
-	gpio_free(trig_info->gpio);
 error_free_name:
 	kfree(trig->name);
 error_free_trig_info:
@@ -142,18 +140,16 @@ error_free_completed_registrations:
 				 &iio_gpio_trigger_list,
 				 alloc_list) {
 		trig_info = trig->private_data;
-		free_irq(gpio_to_irq(trig_info->gpio), trig);
-		gpio_free(trig_info->gpio);
+		free_irq(gpio_to_irq(trig_info->irq), trig);
 		kfree(trig->name);
 		kfree(trig_info);
 		iio_trigger_unregister(trig);
 	}
 
-error_ret:
 	return ret;
 }
 
-static int iio_gpio_trigger_remove(struct platform_device *dev)
+static int iio_gpio_trigger_remove(struct platform_device *pdev)
 {
 	struct iio_trigger *trig, *trig2;
 	struct iio_gpio_trigger_info *trig_info;
@@ -165,8 +161,7 @@ static int iio_gpio_trigger_remove(struct platform_device *dev)
 				 alloc_list) {
 		trig_info = trig->private_data;
 		iio_trigger_unregister(trig);
-		free_irq(gpio_to_irq(trig_info->gpio), trig);
-		gpio_free(trig_info->gpio);
+		free_irq(trig_info->irq, trig);
 		kfree(trig->name);
 		kfree(trig_info);
 		iio_put_trigger(trig);
