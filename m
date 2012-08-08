Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2HHOTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:19:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2HHOTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:19:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Mack <zonque@gmail.com>, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 2/6] ARM: pxa remove irq_to_gpio from eeti_ts driver
Date: Wed, 8 Aug 2012 14:19:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, linux-input@vger.kernel.org
References: <1344430493-5304-1-git-send-email-arnd@arndb.de> <1344430493-5304-3-git-send-email-arnd@arndb.de> <50226843.4080508@gmail.com>
In-Reply-To: <50226843.4080508@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208081419.17181.arnd@arndb.de>
X-Provags-ID: V02:K0:9ohOr3Lm+hRhRw0DoSSzPBNKZnPo+eoWMAyuxge4nls
 6Co/TIhGRzyMZ4IFfjW0er9maowN7rz0jW8ztrqL9/TG2pkwOW
 Z4FrpZZYxHrFfYZ5ZS9HqFCI4fZj4Gg2EdC1h0FlPSzpAj7VlQ
 5AMjeIi4Jve0J53orYU/9WYawsoGL2hoeUfrneUcW3de3zOpJf
 oQvYmnQihLy/bwb74Pei8huERWK/PrwSRqBv7+tD2xhgPclRZ2
 /u94/2s+m2tn5qALKkFO86PPyRiDoJpZevI0NCsMF27gLIYOV5
 mTAUWocH+3DWq4CT3mqiH5Q3ZTwroPOhVCi+6F1QREvN9EiSVV
 1JJCzjmXFlGLZg/D2Mwo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Daniel Mack wrote:
> On 08.08.2012 14:54, Arnd Bergmann wrote:
> > The irq_to_gpio function was removed from the pxa platform
> > in linux-3.2, and this driver has been broken since.
> > 
> > Without this patch, building raumfeld_defconfig results in:
> > 
> > drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
> > drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
> 
> I've sent out a slightly different version of such a patch just
> yesterday. It deferres mainly in the fact that it uses gpio_to_irq() and
> ignores the i2c_client's irq line. That way, there can't be any
> inconsitency.
> 
> I've appended the patch again - I haven't heard back from Dmitry yet.
> 

I've taken your patch instead now, because contains the gpio_request_one
call that I was missing and you sent it before me, but I also noticed
that you forgot to change arch/arm/mach-pxa/raumfeld.c along with the
driver. I've put that in there as well now. If Dmitry wants to take this
patch, I'll drop it from my tree, otherwise I'll send it myself.

	Arnd

8<-----
>From a919cfbeb9441f5058feec8f790ef90d9299a448 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Apr 2012 16:21:37 +0000
Subject: [PATCH] Input: eeti_ts: pass gpio value instead of IRQ

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
Cc: stable@vger.kernel.org (v3.2+)
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-input@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>

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
-	.irq	= PXA_GPIO_TO_IRQ(GPIO_TOUCH_IRQ),
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
 
