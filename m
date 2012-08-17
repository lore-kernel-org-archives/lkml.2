Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab2HQDba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:31:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030672Ab2HQD1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:05 -0400
Message-Id: <20120817030248.551809868@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Daniel Mack <zonque@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [ 30/37] Input: eeti_ts: pass gpio value instead of IRQ
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 4eef6cbfcc03b294d9d334368a851b35b496ce53 upstream.

The EETI touchscreen asserts its IRQ line as soon as it has data in its
internal buffers. The line is automatically deasserted once all data has
been read via I2C. Hence, the driver has to monitor the GPIO line and
cannot simply rely on the interrupt handler reception.

In the current implementation of the driver, irq_to_gpio() is used to
determine the GPIO number from the i2c_client's IRQ value.

As irq_to_gpio() is not available on all platforms, this patch changes
this and makes the driver ignore the passed in IRQ. Instead, a GPIO is
added to the platform_data struct and gpio_to_irq is used to derive the
IRQ from that GPIO. If this fails, bail out. The driver is only able to
work in environments where the touchscreen GPIO can be mapped to an
IRQ.

Without this patch, building raumfeld_defconfig results in:

drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-input@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
[bwh: Backported to 3.2: raumfeld_controller_i2c_board_info.irq was
 initialised using gpio_to_irq(), but this doesn't seem to matter]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-pxa/raumfeld.c        |    2 +-
 drivers/input/touchscreen/eeti_ts.c |   21 +++++++++++++--------
 include/linux/input/eeti_ts.h       |    1 +
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index 5905ed1..d89d87ae 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -953,12 +953,12 @@ static struct i2c_board_info raumfeld_connector_i2c_board_info __initdata = {
 
 static struct eeti_ts_platform_data eeti_ts_pdata = {
 	.irq_active_high = 1,
+	.irq_gpio = GPIO_TOUCH_IRQ,
 };
 
 static struct i2c_board_info raumfeld_controller_i2c_board_info __initdata = {
 	.type	= "eeti_ts",
 	.addr	= 0x0a,
-	.irq	= gpio_to_irq(GPIO_TOUCH_IRQ),
 	.platform_data = &eeti_ts_pdata,
 };
 
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 503c709..908407e 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -48,7 +48,7 @@ struct eeti_ts_priv {
 	struct input_dev *input;
 	struct work_struct work;
 	struct mutex mutex;
-	int irq, irq_active_high;
+	int irq_gpio, irq, irq_active_high;
 };
 
 #define EETI_TS_BITDEPTH	(11)
@@ -62,7 +62,7 @@ struct eeti_ts_priv {
 
 static inline int eeti_ts_irq_active(struct eeti_ts_priv *priv)
 {
-	return gpio_get_value(irq_to_gpio(priv->irq)) == priv->irq_active_high;
+	return gpio_get_value(priv->irq_gpio) == priv->irq_active_high;
 }
 
 static void eeti_ts_read(struct work_struct *work)
@@ -157,7 +157,7 @@ static void eeti_ts_close(struct input_dev *dev)
 static int __devinit eeti_ts_probe(struct i2c_client *client,
 				   const struct i2c_device_id *idp)
 {
-	struct eeti_ts_platform_data *pdata;
+	struct eeti_ts_platform_data *pdata = client->dev.platform_data;
 	struct eeti_ts_priv *priv;
 	struct input_dev *input;
 	unsigned int irq_flags;
@@ -199,9 +199,12 @@ static int __devinit eeti_ts_probe(struct i2c_client *client,
 
 	priv->client = client;
 	priv->input = input;
-	priv->irq = client->irq;
+	priv->irq_gpio = pdata->irq_gpio;
+	priv->irq = gpio_to_irq(pdata->irq_gpio);
 
-	pdata = client->dev.platform_data;
+	err = gpio_request_one(pdata->irq_gpio, GPIOF_IN, client->name);
+	if (err < 0)
+		goto err1;
 
 	if (pdata)
 		priv->irq_active_high = pdata->irq_active_high;
@@ -215,13 +218,13 @@ static int __devinit eeti_ts_probe(struct i2c_client *client,
 
 	err = input_register_device(input);
 	if (err)
-		goto err1;
+		goto err2;
 
 	err = request_irq(priv->irq, eeti_ts_isr, irq_flags,
 			  client->name, priv);
 	if (err) {
 		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
-		goto err2;
+		goto err3;
 	}
 
 	/*
@@ -233,9 +236,11 @@ static int __devinit eeti_ts_probe(struct i2c_client *client,
 	device_init_wakeup(&client->dev, 0);
 	return 0;
 
-err2:
+err3:
 	input_unregister_device(input);
 	input = NULL; /* so we dont try to free it below */
+err2:
+	gpio_free(pdata->irq_gpio);
 err1:
 	input_free_device(input);
 	kfree(priv);
diff --git a/include/linux/input/eeti_ts.h b/include/linux/input/eeti_ts.h
index f875b31..16625d7 100644
--- a/include/linux/input/eeti_ts.h
+++ b/include/linux/input/eeti_ts.h
@@ -2,6 +2,7 @@
 #define LINUX_INPUT_EETI_TS_H
 
 struct eeti_ts_platform_data {
+	int irq_gpio;
 	unsigned int irq_active_high;
 };
 


