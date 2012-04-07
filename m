Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2DGHCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:02:15 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58697 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2DGHCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:02:13 -0400
Date: Sat, 7 Apr 2012 00:02:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Olof Johansson <olof@lixom.net>, Daniel Mack <daniel@caiaq.de>,
        Sven Neumann <s.neumann@raumfeld.com>, Daniel Mack <zonque@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
Message-ID: <20120407070206.GA17623@core.coreip.homeip.net>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333777207-4151-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
> This seems to have been broken since 2010, so obviously noone actually
> cares about the driver:
> 
> make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
> 
> irq_to_gpio isn't available on most platforms today, so the driver
> will need some rework by someone who has hardware access and can test
> (to make sure that, for example, switching to level interrupts and just
> keep taking them while there's more to process works).
> 
> I guess it could just be scheduled for removal, but let's start with
> marking it CONFIG_BROKEN.

Well, it probably works quite well on arches that do have irq_to_gpio(),
let's ask Daniel and Sven if they still have this hardware and if they
can try the patch below that implements what you suggested.

Thanks.

-- 
Dmitry


Input: eeti_ts - do not use irq_to_gpio

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

irq_to_gpio is not available on many platforms. Let's switch to using
one-shot level interrupts with threaded IRQ handlers that should stay
active as long as there is data.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/eeti_ts.c |  166 ++++++++++++-----------------------
 1 files changed, 56 insertions(+), 110 deletions(-)


diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 503c709..4d875e5 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -46,9 +46,6 @@ MODULE_PARM_DESC(flip_y, "flip y coordinate");
 struct eeti_ts_priv {
 	struct i2c_client *client;
 	struct input_dev *input;
-	struct work_struct work;
-	struct mutex mutex;
-	int irq, irq_active_high;
 };
 
 #define EETI_TS_BITDEPTH	(11)
@@ -60,26 +57,18 @@ struct eeti_ts_priv {
 #define REPORT_BIT_HAS_PRESSURE	(1 << 6)
 #define REPORT_RES_BITS(v)	(((v) >> 1) + EETI_TS_BITDEPTH)
 
-static inline int eeti_ts_irq_active(struct eeti_ts_priv *priv)
-{
-	return gpio_get_value(irq_to_gpio(priv->irq)) == priv->irq_active_high;
-}
-
-static void eeti_ts_read(struct work_struct *work)
+static irqreturn_t eeti_ts_isr(int irq, void *dev_id)
 {
+	struct eeti_ts_priv *priv = dev_id;
+	struct i2c_client *client = priv->client;
+	struct input_dev *input  = priv->input;
+	unsigned int x, y, res, pressed;
+	int rc;
 	char buf[6];
-	unsigned int x, y, res, pressed, to = 100;
-	struct eeti_ts_priv *priv =
-		container_of(work, struct eeti_ts_priv, work);
-
-	mutex_lock(&priv->mutex);
-
-	while (eeti_ts_irq_active(priv) && --to)
-		i2c_master_recv(priv->client, buf, sizeof(buf));
 
-	if (!to) {
-		dev_err(&priv->client->dev,
-			"unable to clear IRQ - line stuck?\n");
+	rc = i2c_master_recv(client, buf, sizeof(buf));
+	if (rc < 0) {
+		dev_err(&client->dev, "i2c_master_recv failed, error: %d", rc);
 		goto out;
 	}
 
@@ -103,46 +92,22 @@ static void eeti_ts_read(struct work_struct *work)
 		y = EETI_MAXVAL - y;
 
 	if (buf[0] & REPORT_BIT_HAS_PRESSURE)
-		input_report_abs(priv->input, ABS_PRESSURE, buf[5]);
+		input_report_abs(input, ABS_PRESSURE, buf[5]);
 
-	input_report_abs(priv->input, ABS_X, x);
-	input_report_abs(priv->input, ABS_Y, y);
-	input_report_key(priv->input, BTN_TOUCH, !!pressed);
-	input_sync(priv->input);
+	input_report_abs(input, ABS_X, x);
+	input_report_abs(input, ABS_Y, y);
+	input_report_key(input, BTN_TOUCH, pressed);
+	input_sync(input);
 
 out:
-	mutex_unlock(&priv->mutex);
-}
-
-static irqreturn_t eeti_ts_isr(int irq, void *dev_id)
-{
-	struct eeti_ts_priv *priv = dev_id;
-
-	 /* postpone I2C transactions as we are atomic */
-	schedule_work(&priv->work);
-
 	return IRQ_HANDLED;
 }
 
-static void eeti_ts_start(struct eeti_ts_priv *priv)
-{
-	enable_irq(priv->irq);
-
-	/* Read the events once to arm the IRQ */
-	eeti_ts_read(&priv->work);
-}
-
-static void eeti_ts_stop(struct eeti_ts_priv *priv)
-{
-	disable_irq(priv->irq);
-	cancel_work_sync(&priv->work);
-}
-
 static int eeti_ts_open(struct input_dev *dev)
 {
 	struct eeti_ts_priv *priv = input_get_drvdata(dev);
 
-	eeti_ts_start(priv);
+	enable_irq(priv->client->irq);
 
 	return 0;
 }
@@ -151,17 +116,17 @@ static void eeti_ts_close(struct input_dev *dev)
 {
 	struct eeti_ts_priv *priv = input_get_drvdata(dev);
 
-	eeti_ts_stop(priv);
+	disable_irq(priv->client->irq);
 }
 
 static int __devinit eeti_ts_probe(struct i2c_client *client,
 				   const struct i2c_device_id *idp)
 {
-	struct eeti_ts_platform_data *pdata;
+	const struct eeti_ts_platform_data *pdata = client->dev.platform_data;
 	struct eeti_ts_priv *priv;
 	struct input_dev *input;
 	unsigned int irq_flags;
-	int err = -ENOMEM;
+	int err;
 
 	/*
 	 * In contrast to what's described in the datasheet, there seems
@@ -171,25 +136,15 @@ static int __devinit eeti_ts_probe(struct i2c_client *client,
 	 */
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&client->dev, "failed to allocate driver data\n");
-		goto err0;
-	}
-
-	mutex_init(&priv->mutex);
 	input = input_allocate_device();
-
-	if (!input) {
-		dev_err(&client->dev, "Failed to allocate input device.\n");
-		goto err1;
+	if (!priv || !input) {
+		dev_err(&client->dev, "failed to memory\n");
+		err = -ENOMEM;
+		goto err_free_mem;
 	}
 
-	input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-	input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-
-	input_set_abs_params(input, ABS_X, 0, EETI_MAXVAL, 0, 0);
-	input_set_abs_params(input, ABS_Y, 0, EETI_MAXVAL, 0, 0);
-	input_set_abs_params(input, ABS_PRESSURE, 0, 0xff, 0, 0);
+	priv->client = client;
+	priv->input = input;
 
 	input->name = client->name;
 	input->id.bustype = BUS_I2C;
@@ -197,49 +152,47 @@ static int __devinit eeti_ts_probe(struct i2c_client *client,
 	input->open = eeti_ts_open;
 	input->close = eeti_ts_close;
 
-	priv->client = client;
-	priv->input = input;
-	priv->irq = client->irq;
-
-	pdata = client->dev.platform_data;
-
-	if (pdata)
-		priv->irq_active_high = pdata->irq_active_high;
+	input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
-	irq_flags = priv->irq_active_high ?
-		IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
+	input_set_abs_params(input, ABS_X, 0, EETI_MAXVAL, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, EETI_MAXVAL, 0, 0);
+	input_set_abs_params(input, ABS_PRESSURE, 0, 0xff, 0, 0);
 
-	INIT_WORK(&priv->work, eeti_ts_read);
-	i2c_set_clientdata(client, priv);
 	input_set_drvdata(input, priv);
 
-	err = input_register_device(input);
-	if (err)
-		goto err1;
+	irq_flags = pdata && pdata->irq_active_high ?
+			IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW;
+	irq_flags |= IRQF_ONESHOT;
 
-	err = request_irq(priv->irq, eeti_ts_isr, irq_flags,
-			  client->name, priv);
-	if (err) {
+	err = request_threaded_irq(client->irq, NULL, eeti_ts_isr,
+				   irq_flags, client->name, priv);
+	if (err < 0) {
 		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
-		goto err2;
+		goto err_free_mem;
 	}
 
 	/*
-	 * Disable the device for now. It will be enabled once the
+	 * Disable the IRQ for now. It will be enabled once the
 	 * input device is opened.
 	 */
-	eeti_ts_stop(priv);
+	disable_irq(client->irq);
 
+	err = input_register_device(input);
+	if (err)
+		goto err_free_irq;
+
+	i2c_set_clientdata(client, priv);
 	device_init_wakeup(&client->dev, 0);
+
 	return 0;
 
-err2:
-	input_unregister_device(input);
-	input = NULL; /* so we dont try to free it below */
-err1:
+err_free_irq:
+	free_irq(client->irq, priv);
+err_free_mem:
 	input_free_device(input);
 	kfree(priv);
-err0:
+
 	return err;
 }
 
@@ -247,20 +200,14 @@ static int __devexit eeti_ts_remove(struct i2c_client *client)
 {
 	struct eeti_ts_priv *priv = i2c_get_clientdata(client);
 
-	free_irq(priv->irq, priv);
-	/*
-	 * eeti_ts_stop() leaves IRQ disabled. We need to re-enable it
-	 * so that device still works if we reload the driver.
-	 */
-	enable_irq(priv->irq);
-
+	free_irq(client->irq, priv);
 	input_unregister_device(priv->input);
 	kfree(priv);
 
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int eeti_ts_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -270,12 +217,12 @@ static int eeti_ts_suspend(struct device *dev)
 	mutex_lock(&input_dev->mutex);
 
 	if (input_dev->users)
-		eeti_ts_stop(priv);
+		disable_irq(client->irq);
 
 	mutex_unlock(&input_dev->mutex);
 
 	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(priv->irq);
+		enable_irq_wake(client->irq);
 
 	return 0;
 }
@@ -287,20 +234,20 @@ static int eeti_ts_resume(struct device *dev)
 	struct input_dev *input_dev = priv->input;
 
 	if (device_may_wakeup(&client->dev))
-		disable_irq_wake(priv->irq);
+		disable_irq_wake(client->irq);
 
 	mutex_lock(&input_dev->mutex);
 
 	if (input_dev->users)
-		eeti_ts_start(priv);
+		enable_irq(client->irq);
 
 	mutex_unlock(&input_dev->mutex);
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(eeti_ts_pm, eeti_ts_suspend, eeti_ts_resume);
-#endif
 
 static const struct i2c_device_id eeti_ts_id[] = {
 	{ "eeti_ts", 0 },
@@ -311,9 +258,8 @@ MODULE_DEVICE_TABLE(i2c, eeti_ts_id);
 static struct i2c_driver eeti_ts_driver = {
 	.driver = {
 		.name = "eeti_ts",
-#ifdef CONFIG_PM
+		.owner = THIS_MODULE,
 		.pm = &eeti_ts_pm,
-#endif
 	},
 	.probe = eeti_ts_probe,
 	.remove = __devexit_p(eeti_ts_remove),
