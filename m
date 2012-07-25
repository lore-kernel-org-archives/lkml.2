Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2GYUyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:54:38 -0400
Received: from svenfoo.org ([82.94.215.22]:46461 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2GYUyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:54:36 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Ville Syrjala <syrjala@sci.fi>
Subject: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in platform data
Date: Wed, 25 Jul 2012 22:54:29 +0200
Message-Id: <1343249670-14985-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of porting boards to devicetree implemenation, we should
keep information about external circuitry where they belong - the
individual drivers.

This patch adds a way to specify a GPIO to drive the (optional) external
pull-up logic, rather than using a function pointer for that.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Ville Syrjala <syrjala@sci.fi>
---
 drivers/w1/masters/w1-gpio.c |   18 +++++++++++++++++-
 include/linux/w1-gpio.h      |    1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index df600d1..dac88ff 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -59,6 +59,13 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 	if (err)
 		goto free_master;
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin)) {
+		err = gpio_request_one(pdata->ext_pullup_enable_pin,
+				       GPIOF_INIT_LOW, "w1 pullup");
+		if (err < 0)
+			goto free_gpio;
+	}
+
 	master->data = pdata;
 	master->read_bit = w1_gpio_read_bit;
 
@@ -72,15 +79,21 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 
 	err = w1_add_master_device(master);
 	if (err)
-		goto free_gpio;
+		goto free_gpio_ext_pu;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_set_value(pdata->ext_pullup_enable_pin, 1);
+
 	platform_set_drvdata(pdev, master);
 
 	return 0;
 
+ free_gpio_ext_pu:
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_free(pdata->ext_pullup_enable_pin);
  free_gpio:
 	gpio_free(pdata->pin);
  free_master:
@@ -97,6 +110,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_set_value(pdata->ext_pullup_enable_pin, 0);
+
 	w1_remove_master_device(master);
 	gpio_free(pdata->pin);
 	kfree(master);
diff --git a/include/linux/w1-gpio.h b/include/linux/w1-gpio.h
index 3adeff8..065e3ae 100644
--- a/include/linux/w1-gpio.h
+++ b/include/linux/w1-gpio.h
@@ -19,6 +19,7 @@ struct w1_gpio_platform_data {
 	unsigned int pin;
 	unsigned int is_open_drain:1;
 	void (*enable_external_pullup)(int enable);
+	unsigned int ext_pullup_enable_pin;
 };
 
 #endif /* _LINUX_W1_GPIO_H */
-- 
1.7.10.4

