Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1LDIY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 03:24:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58586 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1LDIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 03:24:56 -0500
Date: Sun, 4 Dec 2011 00:24:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonyericsson.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        aghayal@codeaurora.org,
        Courtney Cavin <courtney.cavin@sonyericsson.com>
Subject: Re: [PATCH v5] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111204082447.GA14593@core.coreip.homeip.net>
References: <1322055635-3622-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322055635-3622-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On Wed, Nov 23, 2011 at 02:40:35PM +0100, oskar.andero@sonyericsson.com wrote:
> From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> 
> This driver adds support for Sharp's GP2AP002A00F proximity sensor. The
> proximity is measured as a binary switch, i.e. an object is either
> detected or not detected. Hence, this driver is implemented as a switch
> that reports SW_FRONT_PROXIMITY.
> 

I was looking at the driver before applying it to my tree and I realized
that there are a few issues I'd like to have fixed:

- we may exit suspend/resume methods with mutex held if enable/disable
  fails;
- we need to do gpio_regiest/gpio_free on the vout_gpio;
- the driver should depend on GENERIC_GPIO;
- we need to use the same "dev" when reporting errors/warnings and not
  mix up i2c_client->dev and input->dev;
- we need to set up client->dev as parent of our input device.

Does the patch below applied on top of your patch works for you?

Thanks.

-- 
Dmitry

Input: gp2ap002a00f - misc changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/Kconfig        |   21 ++--
 drivers/input/misc/Makefile       |    2 
 drivers/input/misc/gp2ap002a00f.c |  174 +++++++++++++++++++------------------
 3 files changed, 101 insertions(+), 96 deletions(-)


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index a62fcdc..7b46781 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -179,6 +179,17 @@ config INPUT_APANEL
 	 To compile this driver as a module, choose M here: the module will
 	 be called apanel.
 
+config INPUT_GP2A
+	tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor driver"
+	depends on I2C
+	depends on GENERIC_GPIO
+	help
+	  Say Y here if you have a Sharp GP2AP002A00F proximity/als combo-chip
+	  hooked to an I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gp2ap002a00f.
+
 config INPUT_GPIO_TILT_POLLED
 	tristate "Polled GPIO tilt switch"
 	depends on GENERIC_GPIO
@@ -558,14 +569,4 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
-config INPUT_GP2A
-	tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor driver"
-	depends on I2C
-	help
-	  Say Y here if you have a Sharp GP2AP002A00F proximity/als combo-chip
-	  hooked to an I2C bus.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called gp2ap002a00f.
-
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index dd99a75..46671a8 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -23,8 +23,8 @@ obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
-obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_GPIO_TILT_POLLED)	+= gpio_tilt_polled.o
+obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_INPUT_KXTJ9)		+= kxtj9.o
diff --git a/drivers/input/misc/gp2ap002a00f.c b/drivers/input/misc/gp2ap002a00f.c
index 5689a2b..71fba8c 100644
--- a/drivers/input/misc/gp2ap002a00f.c
+++ b/drivers/input/misc/gp2ap002a00f.c
@@ -20,7 +20,7 @@
 #include <linux/input/gp2ap002a00f.h>
 
 struct gp2a_data {
-	struct input_dev *device;
+	struct input_dev *input;
 	const struct gp2a_platform_data *pdata;
 	struct i2c_client *i2c_client;
 };
@@ -39,48 +39,12 @@ enum gp2a_controls {
 	GP2A_CTRL_SSD	= 0x01
 };
 
-static int gp2a_enable(struct gp2a_data *dt)
-{
-	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
-					 GP2A_CTRL_SSD);
-}
-
-static int gp2a_disable(struct gp2a_data *dt)
-{
-	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
-					 0x00);
-}
-
-static int __devinit gp2a_initialize(struct gp2a_data *dt)
-{
-	int error;
-
-	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_GAIN,
-					  0x08);
-	if (error < 0)
-		return error;
-
-	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_HYS,
-					  0xc2);
-	if (error < 0)
-		return error;
-
-	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_CYCLE,
-					  0x04);
-	if (error < 0)
-		return error;
-
-	error = gp2a_disable(dt);
-
-	return error;
-}
-
 static int gp2a_report(struct gp2a_data *dt)
 {
 	int vo = gpio_get_value(dt->pdata->vout_gpio);
 
-	input_report_switch(dt->device, SW_FRONT_PROXIMITY, !vo);
-	input_sync(dt->device);
+	input_report_switch(dt->input, SW_FRONT_PROXIMITY, !vo);
+	input_sync(dt->input);
 
 	return 0;
 }
@@ -94,6 +58,18 @@ static irqreturn_t gp2a_irq(int irq, void *handle)
 	return IRQ_HANDLED;
 }
 
+static int gp2a_enable(struct gp2a_data *dt)
+{
+	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
+					 GP2A_CTRL_SSD);
+}
+
+static int gp2a_disable(struct gp2a_data *dt)
+{
+	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
+					 0x00);
+}
+
 static int gp2a_device_open(struct input_dev *dev)
 {
 	struct gp2a_data *dt = input_get_drvdata(dev);
@@ -101,7 +77,8 @@ static int gp2a_device_open(struct input_dev *dev)
 
 	error = gp2a_enable(dt);
 	if (error < 0) {
-		dev_err(&dev->dev, "unable to activate, err %d\n", error);
+		dev_err(&dt->i2c_client->dev,
+			"unable to activate, err %d\n", error);
 		return error;
 	}
 
@@ -117,17 +94,41 @@ static void gp2a_device_close(struct input_dev *dev)
 
 	error = gp2a_disable(dt);
 	if (error < 0)
-		dev_err(&dev->dev, "unable to deactivate, err %d\n", error);
+		dev_err(&dt->i2c_client->dev,
+			"unable to deactivate, err %d\n", error);
+}
+
+static int __devinit gp2a_initialize(struct gp2a_data *dt)
+{
+	int error;
+
+	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_GAIN,
+					  0x08);
+	if (error < 0)
+		return error;
+
+	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_HYS,
+					  0xc2);
+	if (error < 0)
+		return error;
+
+	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_CYCLE,
+					  0x04);
+	if (error < 0)
+		return error;
+
+	error = gp2a_disable(dt);
+
+	return error;
 }
 
 static int __devinit gp2a_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	const struct gp2a_platform_data *pdata;
+	const struct gp2a_platform_data *pdata = client->dev.platform_data;
 	struct gp2a_data *dt;
 	int error;
 
-	pdata = client->dev.platform_data;
 	if (!pdata)
 		return -EINVAL;
 
@@ -137,63 +138,67 @@ static int __devinit gp2a_probe(struct i2c_client *client,
 			return error;
 	}
 
-	error = gpio_direction_input(pdata->vout_gpio);
-	if (error < 0)
+	error = gpio_request_one(pdata->vout_gpio, GPIOF_IN, GP2A_I2C_NAME);
+	if (error)
 		goto err_hw_shutdown;
 
 	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
 	if (!dt) {
 		error = -ENOMEM;
-		goto err_hw_shutdown;
+		goto err_free_gpio;
 	}
 
 	dt->pdata = pdata;
 	dt->i2c_client = client;
-	i2c_set_clientdata(client, dt);
 
 	error = gp2a_initialize(dt);
 	if (error < 0)
 		goto err_free_mem;
 
-	dt->device = input_allocate_device();
-	if (!dt->device) {
+	dt->input = input_allocate_device();
+	if (!dt->input) {
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
-	input_set_drvdata(dt->device, dt);
 
-	dt->device->open = gp2a_device_open;
-	dt->device->close = gp2a_device_close;
-	dt->device->name = GP2A_I2C_NAME;
-	dt->device->id.bustype = BUS_I2C;
+	input_set_drvdata(dt->input, dt);
+
+	dt->input->open = gp2a_device_open;
+	dt->input->close = gp2a_device_close;
+	dt->input->name = GP2A_I2C_NAME;
+	dt->input->id.bustype = BUS_I2C;
+	dt->input->dev.parent = &client->dev;
 
-	input_set_capability(dt->device, EV_SW, SW_FRONT_PROXIMITY);
+	input_set_capability(dt->input, EV_SW, SW_FRONT_PROXIMITY);
 
-	error = request_threaded_irq(client->irq, NULL,
-			gp2a_irq, IRQF_TRIGGER_RISING |
-			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+	error = request_threaded_irq(client->irq, NULL, gp2a_irq,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+				IRQF_ONESHOT,
 			GP2A_I2C_NAME, dt);
 	if (error) {
 		dev_err(&client->dev, "irq request failed\n");
 		goto err_free_input_dev;
 	}
 
-	error = input_register_device(dt->device);
+	error = input_register_device(dt->input);
 	if (error) {
 		dev_err(&client->dev, "device registration failed\n");
 		goto err_free_irq;
 	}
 
 	device_init_wakeup(&client->dev, pdata->wakeup);
+	i2c_set_clientdata(client, dt);
 
 	return 0;
 
 err_free_irq:
 	free_irq(client->irq, dt);
 err_free_input_dev:
-	input_free_device(dt->device);
+	input_free_device(dt->input);
 err_free_mem:
 	kfree(dt);
+err_free_gpio:
+	gpio_free(pdata->vout_gpio);
 err_hw_shutdown:
 	if (pdata->hw_shutdown)
 		pdata->hw_shutdown(client);
@@ -203,15 +208,20 @@ err_hw_shutdown:
 static int __devexit gp2a_remove(struct i2c_client *client)
 {
 	struct gp2a_data *dt = i2c_get_clientdata(client);
+	const struct gp2a_platform_data *pdata = dt->pdata;
 
 	device_init_wakeup(&client->dev, false);
 
 	free_irq(client->irq, dt);
-	input_unregister_device(dt->device);
-	if (dt->pdata->hw_shutdown)
-		dt->pdata->hw_shutdown(client);
+
+	input_unregister_device(dt->input);
 	kfree(dt);
 
+	gpio_free(pdata->vout_gpio);
+
+	if (pdata->hw_shutdown)
+		pdata->hw_shutdown(client);
+
 	return 0;
 }
 
@@ -220,42 +230,36 @@ static int gp2a_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct gp2a_data *dt = i2c_get_clientdata(client);
-	int error;
-
-	mutex_lock(&dt->device->mutex);
+	int retval = 0;
 
 	if (device_may_wakeup(&client->dev)) {
 		enable_irq_wake(client->irq);
-	} else if (dt->device->users) {
-		error = gp2a_disable(dt);
-		if (error < 0)
-			return error;
+	} else {
+		mutex_lock(&dt->input->mutex);
+		if (dt->input->users)
+			retval = gp2a_disable(dt);
+		mutex_unlock(&dt->input->mutex);
 	}
 
-	mutex_unlock(&dt->device->mutex);
-
-	return 0;
+	return retval;
 }
 
 static int gp2a_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct gp2a_data *dt = i2c_get_clientdata(client);
-	int error;
-
-	mutex_lock(&dt->device->mutex);
+	int retval = 0;
 
 	if (device_may_wakeup(&client->dev)) {
 		disable_irq_wake(client->irq);
-	} else if (dt->device->users) {
-		error = gp2a_enable(dt);
-		if (error < 0)
-			return error;
+	} else {
+		mutex_lock(&dt->input->mutex);
+		if (dt->input->users)
+			retval = gp2a_enable(dt);
+		mutex_unlock(&dt->input->mutex);
 	}
 
-	mutex_unlock(&dt->device->mutex);
-
-	return 0;
+	return retval;
 }
 #endif
 
@@ -270,11 +274,11 @@ static struct i2c_driver gp2a_i2c_driver = {
 	.driver = {
 		.name	= GP2A_I2C_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= &gp2a_pm
+		.pm	= &gp2a_pm,
 	},
 	.probe		= gp2a_probe,
 	.remove		= __devexit_p(gp2a_remove),
-	.id_table	= gp2a_i2c_id
+	.id_table	= gp2a_i2c_id,
 };
 
 static int __init gp2a_init(void)
