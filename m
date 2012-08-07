Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2HGPTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:19:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49977 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2HGPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:19:13 -0400
Message-ID: <502131EB.4000100@gmail.com>
Date: Tue, 07 Aug 2012 17:19:07 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Emulating level IRQs
References: <20120503043651.GA11830@core.coreip.homeip.net> <20120713070102.GA2223@core.coreip.homeip.net> <500561AF.9090901@gmail.com> <5008296C.5070709@gmail.com> <20120723165120.GB26577@core.coreip.homeip.net> <500EE314.7040708@gmail.com> <501E9DDB.3020807@gmail.com> <CAN1soZy-_MdjqS3r3Tc1XET6tPzMxDqjYq3Tn0fYLBNNUkdVAg@mail.gmail.com> <501EB3C5.1080501@gmail.com> <CAMPhdO8fZoFrUymb347whDpFkbgxsu8vVSqw5BSd=L4gicfXgg@mail.gmail.com> <20120806163615.GG29272@sirena.org.uk>
In-Reply-To: <20120806163615.GG29272@sirena.org.uk>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/mixed;
 boundary="------------060203050107000801000403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060203050107000801000403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06.08.2012 18:36, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 09:45:13AM +0800, Eric Miao wrote:
> 
>> So my understanding, if it's correct, that we can treat the EETI chip as having
>> two separate inputs: one IRQ line (for the event notification) and one GPIO line
>> (for a condition where data are emptied), we could naturally have two numbers
>> in the driver, but unfortunately they end up being in sync as they are
>> physically
>> one pin.
> 
> ...unless the interrupt controller supports level IRQs at which point we
> don't need the GPIO, of course :/ .

Exactly. My question was rather - like the subject says ;) - if there is
a way to emulate level IRQs on controllers that can't do that natively.

But ok, I followed Eric's suggestion now and implemented it that way.
This also works fine for me.

Dmitry, are you fine with that patch?


Many thanks for the input, everyone!
Daniel



--------------060203050107000801000403
Content-Type: text/x-patch;
 name="0001-Input-eeti_ts-pass-gpio-value-instead-of-IRQ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Input-eeti_ts-pass-gpio-value-instead-of-IRQ.patch"

>From bfb14c1a0417435ebcf5bdebbb94ae6812cb4aee Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Tue, 7 Aug 2012 17:02:59 +0200
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

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 drivers/input/touchscreen/eeti_ts.c | 21 +++++++++++++--------
 include/linux/input/eeti_ts.h       |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

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
 
-- 
1.7.11.2


--------------060203050107000801000403--
