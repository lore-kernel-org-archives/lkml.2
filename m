Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1EaIDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:03:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61993 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1EaIDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wJMzkit383Qtpf+C8OuSEDofQd1r90+C2/+Vrmi7iApmkuELch5kyxQ5xbyOoAkfXU
         uQsaSFae08K/UYyKUgYWzACq3o3Vs5EQLgRN81zJCpPI1cTnzK2QTKxm1nbPMlEkEg5r
         cuWAakD9h0ILc+MlKfhdR4VX+1ZztjfuxRPfc=
Date: Tue, 31 May 2011 01:03:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Hudson <chudson@kionix.com>
Cc: linux-input@vger.kernel.org, jonathan.cameron@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] input: Add support for Kionix KXTJ9 accelerometer
Message-ID: <20110531080337.GB13855@core.coreip.homeip.net>
References: <>
 <1306449620-21879-1-git-send-email-chudson@kionix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306449620-21879-1-git-send-email-chudson@kionix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
On Thu, May 26, 2011 at 06:40:20PM -0400, Chris Hudson wrote:
> Quite a few changes this time around (thanks Jonathan and Dmitry!):
> - The sysfs node for poll_interval was changed to emulate input_polldev.  I
>   could not actually use input_polldev because some commands need to be sent
>   to the hardware when the poll interval is changed.
> - Locking cleaned up throughout
> - Cleared up distinction between IRQ and polling modes: if client->irq, then
>   irq mode is enabled.  Removed register bits required for irq from the header;
>   these will be set in the driver if client->irq is populated.
> - Put .suspend and .resume into struct dev_pm_ops.
> - Many other smaller changes, unnecessary variables removed, etc.
> 
> Signed-off-by: Chris Hudson <chudson@kionix.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Could you please tell me how badly the patch below breaks the device?

Thanks!

-- 
Dmitry


Input: KXTJ9 assorted changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/Kconfig |   27 +-
 drivers/input/misc/kxtj9.c |  654 ++++++++++++++++++++++----------------------
 2 files changed, 344 insertions(+), 337 deletions(-)


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 567f3d2..7010623 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -209,6 +209,23 @@ config INPUT_KEYSPAN_REMOTE
 	  To compile this driver as a module, choose M here: the module will
 	  be called keyspan_remote.
 
+config INPUT_KXTJ9
+	tristate "Kionix KXTJ9 tri-axis digital accelerometer"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Kionix KXTJ9 digital
+	  tri-axis accelerometer.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called kxtj9.
+
+config KXTJ9_POLLED_MODE
+	bool "Enable polling mode support"
+	depends on INPUT_KXTJ9
+	select INPUT_POLLDEV
+	help
+	  Say Y here if you need accelerometer to work in polling mode.
+
 config INPUT_POWERMATE
 	tristate "Griffin PowerMate and Contour Jog support"
 	depends on USB_ARCH_HAS_HCD
@@ -467,14 +484,4 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
-config INPUT_KXTJ9
-	tristate "Kionix KXTJ9 tri-axis digital accelerometer"
-	depends on I2C && SYSFS
-	help
-	  If you say yes here you get support for the Kionix KXTJ9 digital
-	  tri-axis accelerometer.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called kxtj9.
-
 endif
diff --git a/drivers/input/misc/kxtj9.c b/drivers/input/misc/kxtj9.c
index ef83182..1536bf4 100644
--- a/drivers/input/misc/kxtj9.c
+++ b/drivers/input/misc/kxtj9.c
@@ -61,63 +61,86 @@ static const struct {
 	unsigned int cutoff;
 	u8 mask;
 } kxtj9_odr_table[] = {
-	{
-	3,	ODR800F}, {
-	5,	ODR400F}, {
-	10,	ODR200F}, {
-	20,	ODR100F}, {
-	40,	ODR50F}, {
-	80,	ODR25F}, {
-	0,	ODR12_5F},
+	{ 3,	ODR800F },
+	{ 5,	ODR400F },
+	{ 10,	ODR200F },
+	{ 20,	ODR100F },
+	{ 40,	ODR50F  },
+	{ 80,	ODR25F  },
+	{ 0,	ODR12_5F},
 };
 
 struct kxtj9_data {
 	struct i2c_client *client;
 	struct kxtj9_platform_data pdata;
-	struct mutex lock;
-	struct delayed_work input_work;
 	struct input_dev *input_dev;
-
-	bool hw_initialized;
-	bool enabled;
+#ifdef CONFIG_KXTJ9_POLLED_MODE
+	struct input_dev *input_polled_dev;
+#endif
+	unsigned int last_poll_interval;
 	u8 shift;
-	u8 resume[RESUME_ENTRIES];
+	u8 ctrl_reg1;
+	u8 data_ctrl;
+	u8 int_ctrl;
 };
 
 static int kxtj9_i2c_read(struct kxtj9_data *tj9, u8 addr, u8 *data, int len)
 {
-	int err;
-
 	struct i2c_msg msgs[] = {
 		{
-		 .addr = tj9->client->addr,
-		 .flags = tj9->client->flags,
-		 .len = 1,
-		 .buf = &addr,
-		 },
+			.addr = tj9->client->addr,
+			.flags = tj9->client->flags,
+			.len = 1,
+			.buf = &addr,
+		},
 		{
-		 .addr = tj9->client->addr,
-		 .flags = tj9->client->flags | I2C_M_RD,
-		 .len = len,
-		 .buf = data,
-		 },
+			.addr = tj9->client->addr,
+			.flags = tj9->client->flags | I2C_M_RD,
+			.len = len,
+			.buf = data,
+		},
 	};
-	err = i2c_transfer(tj9->client->adapter, msgs, 2);
 
-	return err;
+	return i2c_transfer(tj9->client->adapter, msgs, 2);
 }
 
-static int kxtj9_verify(struct kxtj9_data *tj9)
+static void kxtj9_report_acceleration_data(struct kxtj9_data *tj9)
 {
-	int ret;
+	s16 acc_data[3]; /* Data bytes from hardware xL, xH, yL, yH, zL, zH */
+	s16 x, y, z;
+	int err;
 
-	ret = i2c_smbus_read_byte_data(tj9->client, WHO_AM_I);
-	if (ret < 0)
-		dev_err(&tj9->client->dev, "read err int source\n");
-	if (ret != 0x06)
-		ret = -EIO;
+	err = kxtj9_i2c_read(tj9, XOUT_L, (u8 *)acc_data, 6);
+	if (err < 0)
+		dev_err(&tj9->client->dev, "accelerometer data read failed\n");
+
+	x = le16_to_cpu(acc_data[0]) >> tj9->shift;
+	y = le16_to_cpu(acc_data[1]) >> tj9->shift;
+	z = le16_to_cpu(acc_data[2]) >> tj9->shift;
+
+	input_report_abs(tj9->input_dev, ABS_X,
+			 tj9->pdata.negate_x ? -x : x);
+	input_report_abs(tj9->input_dev, ABS_Y,
+			 tj9->pdata.negate_y ? -y : y);
+	input_report_abs(tj9->input_dev, ABS_Z,
+			 tj9->pdata.negate_x ? -y : y);
+	input_sync(tj9->input_dev);
+}
 
-	return ret;
+static irqreturn_t kxtj9_isr(int irq, void *dev)
+{
+	struct kxtj9_data *tj9 = dev;
+	int err;
+
+	/* data ready is the only possible interrupt type */
+	kxtj9_report_acceleration_data(tj9);
+
+	err = i2c_smbus_read_byte_data(tj9->client, INT_REL);
+	if (err < 0)
+		dev_err(&tj9->client->dev,
+			"error clearing interrupt status: %d\n", err);
+
+	return IRQ_HANDLED;
 }
 
 static int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
@@ -126,17 +149,21 @@ static int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
 	case KXTJ9_G_2G:
 		tj9->shift = SHIFT_ADJ_2G;
 		break;
+
 	case KXTJ9_G_4G:
 		tj9->shift = SHIFT_ADJ_4G;
 		break;
+
 	case KXTJ9_G_8G:
 		tj9->shift = SHIFT_ADJ_8G;
 		break;
+
 	default:
 		return -EINVAL;
 	}
-	tj9->resume[RES_CTRL_REG1] = (tj9->resume[RES_CTRL_REG1] & 0xE7)
-								| new_g_range;
+
+	tj9->ctrl_reg1 &= 0xe7;
+	tj9->ctrl_reg1 |= new_g_range;
 
 	return 0;
 }
@@ -145,72 +172,40 @@ static int kxtj9_update_odr(struct kxtj9_data *tj9, int poll_interval)
 {
 	int err;
 	int i;
-	u8 config;
-	u8 temp = 0;
 
 	/* Use the lowest ODR that can support the requested poll interval */
 	for (i = 0; i < ARRAY_SIZE(kxtj9_odr_table); i++) {
-		config = kxtj9_odr_table[i].mask;
+		tj9->data_ctrl = kxtj9_odr_table[i].mask;
 		if (poll_interval < kxtj9_odr_table[i].cutoff)
 			break;
 	}
 
-	if (tj9->enabled == true) {
-		err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, temp);
-		if (err < 0)
-			return err;
-		err = i2c_smbus_write_byte_data(tj9->client, DATA_CTRL, config);
-		if (err < 0)
-			return err;
-		temp = tj9->resume[RES_CTRL_REG1];
-		err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, temp);
-		if (err < 0)
-			return err;
-		/* Cancel and restart polling if not in irq mode */
-		if (!tj9->client->irq) {
-			cancel_delayed_work_sync(&tj9->input_work);
-			schedule_delayed_work(&tj9->input_work,
-					msecs_to_jiffies(poll_interval));
-		}
-	}
-	tj9->resume[RES_DATA_CTRL] = config;
-
-	return 0;
-}
-
-static int kxtj9_hw_init(struct kxtj9_data *tj9)
-{
-	int err;
-	u8 buf = 0;
-
-	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
-	if (err < 0)
-		return err;
-	err = i2c_smbus_write_byte_data(tj9->client, DATA_CTRL,
-						tj9->resume[RES_DATA_CTRL]);
-	if (err < 0)
-		return err;
-	if (tj9->client->irq) /* only write INT_CTRL_REG1 if in irq mode */
-		err = i2c_smbus_write_byte_data(tj9->client, INT_CTRL1,
-						tj9->resume[RES_INT_CTRL1]);
+	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, 0);
 	if (err < 0)
 		return err;
 
-	err = kxtj9_update_g_range(tj9, tj9->pdata.g_range);
+	err = i2c_smbus_write_byte_data(tj9->client,
+					DATA_CTRL, tj9->data_ctrl);
 	if (err < 0)
 		return err;
 
-	buf = (tj9->resume[RES_CTRL_REG1] | PC1_ON);
-	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
+	err = i2c_smbus_write_byte_data(tj9->client,
+					CTRL_REG1, tj9->ctrl_reg1);
 	if (err < 0)
 		return err;
-	tj9->resume[RES_CTRL_REG1] = buf;
 
-	err = kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
-	if (err < 0)
-		return err;
+	return 0;
+}
 
-	tj9->hw_initialized = true;
+static int kxtj9_device_power_on(struct kxtj9_data *tj9)
+{
+	int err;
+
+	if (tj9->pdata.power_on) {
+		err = tj9->pdata.power_on();
+		if (err < 0)
+			return err;
+	}
 
 	return 0;
 }
@@ -218,319 +213,306 @@ static int kxtj9_hw_init(struct kxtj9_data *tj9)
 static void kxtj9_device_power_off(struct kxtj9_data *tj9)
 {
 	int err;
-	u8 buf;
 
-	buf = tj9->resume[RES_CTRL_REG1] & PC1_OFF;
-	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
+	tj9->ctrl_reg1 &= PC1_OFF;
+	err = i2c_smbus_write_byte_data(tj9->client,
+					CTRL_REG1, tj9->ctrl_reg1);
 	if (err < 0)
 		dev_err(&tj9->client->dev, "soft power off failed\n");
+
 	if (tj9->pdata.power_off)
 		tj9->pdata.power_off();
-	tj9->resume[RES_CTRL_REG1] = buf;
-	tj9->hw_initialized = false;
 }
 
-static int kxtj9_device_power_on(struct kxtj9_data *tj9)
+static int kxtj9_enable(struct kxtj9_data *tj9)
 {
 	int err;
 
-	if (tj9->pdata.power_on) {
-		err = tj9->pdata.power_on();
+	err = kxtj9_device_power_on(tj9);
+	if (err < 0)
+		return err;
+
+	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, 0);
+	if (err < 0)
+		return err;
+
+	err = i2c_smbus_write_byte_data(tj9->client,
+					DATA_CTRL, tj9->data_ctrl);
+	if (err < 0)
+		return err;
+
+	/* only write INT_CTRL_REG1 if in irq mode */
+	if (tj9->client->irq) {
+		err = i2c_smbus_write_byte_data(tj9->client,
+						INT_CTRL1, tj9->int_ctrl);
 		if (err < 0)
 			return err;
 	}
-	if (!tj9->hw_initialized) {
-		msleep(40);
-		err = kxtj9_hw_init(tj9);
-		if (err < 0) {
-			kxtj9_device_power_off(tj9);
-			return err;
-		}
-	}
 
-	return 0;
-}
+	err = kxtj9_update_g_range(tj9, tj9->pdata.g_range);
+	if (err < 0)
+		return err;
 
-static void kxtj9_get_acceleration_data(struct kxtj9_data *tj9, s16 *xyz)
-{
-	int err;
-	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
-	s16 acc_data[3];
+	tj9->ctrl_reg1 |= PC1_ON;
+	err = i2c_smbus_write_byte_data(tj9->client,
+					CTRL_REG1, tj9->ctrl_reg1);
+	if (err < 0)
+		return err;
 
-	err = kxtj9_i2c_read(tj9, XOUT_L, (u8 *)acc_data, 6);
+	err = kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
 	if (err < 0)
-		dev_err(&tj9->client->dev, "accelerometer data read failed\n");
+		return err;
 
-	acc_data[0] = le16_to_cpu(acc_data[0]);
-	acc_data[1] = le16_to_cpu(acc_data[1]);
-	acc_data[2] = le16_to_cpu(acc_data[2]);
+	err = i2c_smbus_read_byte_data(tj9->client, INT_REL);
+	if (err < 0) {
+		dev_err(&tj9->client->dev,
+			"error clearing interrupt: %d\n", err);
+		goto fail;
+	}
 
-	acc_data[0] >>= tj9->shift;
-	acc_data[1] >>= tj9->shift;
-	acc_data[2] >>= tj9->shift;
+	return 0;
 
-	xyz[0] = (tj9->pdata.negate_x) ? (-acc_data[tj9->pdata.axis_map_x])
-		  : (acc_data[tj9->pdata.axis_map_x]);
-	xyz[1] = (tj9->pdata.negate_y) ? (-acc_data[tj9->pdata.axis_map_y])
-		  : (acc_data[tj9->pdata.axis_map_y]);
-	xyz[2] = (tj9->pdata.negate_z) ? (-acc_data[tj9->pdata.axis_map_z])
-		  : (acc_data[tj9->pdata.axis_map_z]);
+fail:
+	kxtj9_device_power_off(tj9);
+	return err;
+}
 
-	input_report_abs(tj9->input_dev, ABS_X, (int) xyz[0]);
-	input_report_abs(tj9->input_dev, ABS_Y, (int) xyz[1]);
-	input_report_abs(tj9->input_dev, ABS_Z, (int) xyz[2]);
-	input_sync(tj9->input_dev);
+static void kxtj9_disable(struct kxtj9_data *tj9)
+{
+	kxtj9_device_power_off(tj9);
 }
 
-static irqreturn_t kxtj9_isr(int irq, void *dev)
+static int kxtj9_input_open(struct input_dev *input)
 {
-	struct kxtj9_data *tj9 = dev;
-	int ret;
-	s16 xyz[3];
+	struct kxtj9_data *tj9 = input_get_drvdata(input);
 
-	/* data ready is the only possible interrupt type */
-	kxtj9_get_acceleration_data(tj9, xyz);
+	return kxtj9_enable(tj9);
+}
 
-	ret = i2c_smbus_read_byte_data(tj9->client, INT_REL);
-	if (ret < 0)
-		dev_err(&tj9->client->dev,
-				"error clearing interrupt status: %d\n", ret);
+static void kxtj9_input_close(struct input_dev *dev)
+{
+	struct kxtj9_data *tj9 = input_get_drvdata(dev);
 
-	return IRQ_HANDLED;
+	kxtj9_disable(tj9);
 }
 
-static int kxtj9_enable(struct kxtj9_data *tj9)
+static void __devinit kxtj9_init_input_device(struct kxtj9_data *tj9,
+					      struct input_dev *input_dev)
 {
-	int err = 0;
-
-	mutex_lock(&tj9->lock);
-	if (tj9->enabled == false) {
-		err = kxtj9_device_power_on(tj9);
-		if (err < 0) {
-			dev_err(&tj9->client->dev,
-					"error during power-on: %d\n", err);
-			goto err0;
-		}
-		err = i2c_smbus_read_byte_data(tj9->client, INT_REL);
-		if (err < 0) {
-			dev_err(&tj9->client->dev,
-					"error clearing interrupt: %d\n", err);
-			goto err0;
-		}
-		if (!tj9->client->irq) /* queue polling if not in irq mode */
-			schedule_delayed_work(&tj9->input_work,
-				msecs_to_jiffies(tj9->pdata.poll_interval));
-		tj9->enabled = true;
-	}
-err0:
-	mutex_unlock(&tj9->lock);
-
-	return err;
+	__set_bit(EV_ABS, input_dev->evbit);
+	input_set_abs_params(input_dev, ABS_X, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(input_dev, ABS_Y, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(input_dev, ABS_Z, -G_MAX, G_MAX, FUZZ, FLAT);
+
+	input_dev->name = "kxtj9_accel";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &tj9->client->dev;
 }
 
-static int kxtj9_disable(struct kxtj9_data *tj9)
+static int __devinit kxtj9_setup_input_device(struct kxtj9_data *tj9)
 {
-	mutex_lock(&tj9->lock);
-	if (tj9->enabled == true) {
-		if (!tj9->client->irq) /* cancel polling if not in irq mode */
-			cancel_delayed_work_sync(&tj9->input_work);
-		kxtj9_device_power_off(tj9);
-		tj9->enabled = false;
+	struct input_dev *input_dev;
+	int err;
+
+	input_dev = input_allocate_device();
+	if (!tj9->input_dev) {
+		dev_err(&tj9->client->dev, "input device allocate failed\n");
+		return -ENOMEM;
+	}
+
+	tj9->input_dev = input_dev;
+
+	input_dev->open = kxtj9_input_open;
+	input_dev->close = kxtj9_input_close;
+	input_set_drvdata(input_dev, tj9);
+
+	kxtj9_init_input_device(tj9, input_dev);
+
+	err = input_register_device(tj9->input_dev);
+	if (err) {
+		dev_err(&tj9->client->dev,
+			"unable to register input polled device %s: %d\n",
+			tj9->input_dev->name, err);
+		input_free_device(tj9->input_dev);
 	}
-	mutex_unlock(&tj9->lock);
 
 	return 0;
 }
 
-static void kxtj9_input_work_func(struct work_struct *work)
+#ifdef CONIFG_KXTJ9_POLLED_MODE
+static void kxtj9_poll(struct input_polled_dev *dev)
 {
-	struct kxtj9_data *tj9 = container_of(work, struct kxtj9_data,
-							input_work.work);
-	s16 xyz[3];
-	mutex_lock(&tj9->lock);
+	struct kxtj9_data *tj9 = dev->private;
+	unsigned int poll_interval = dev->poll_interval;
 
-	kxtj9_get_acceleration_data(tj9, xyz);
+	kxtj9_report_acceleration_data(tj9);
 
-	schedule_delayed_work(&tj9->input_work,
-			msecs_to_jiffies(tj9->pdata.poll_interval));
-	mutex_unlock(&tj9->lock);
+	if (poll_interval != tj9->last_poll_interval) {
+		kxtj9_update_odr(tj9, poll_interval);
+		tj9->last_poll_interval = poll_interval;
+	}
 }
 
-static int kxtj9_input_open(struct input_dev *input)
+static int kxtj9_polled_input_open(struct input_polled_dev *dev)
 {
-	return kxtj9_enable(input_get_drvdata(input));
+	struct kxtj9_data *tj9 = dev->private;
+
+	return kxtj9_enable(tj9);
 }
 
-static void kxtj9_input_close(struct input_dev *dev)
+static void kxtj9_polled_input_close(struct input_polled_dev *dev)
 {
-	kxtj9_disable(input_get_drvdata(dev));
+	struct kxtj9_data *tj9 = dev->private;
+
+	kxtj9_disable(tj9);
 }
 
-static int kxtj9_input_init(struct kxtj9_data *tj9)
+static int __devinit kxtj9_setup_polled_device(struct kxtj9_data *tj9)
 {
-	int err;
+	struct input_polled_dev *poll_dev;
 
-	if (!tj9->client->irq) /* only use input_work if not in irq mode */
-		INIT_DELAYED_WORK(&tj9->input_work, kxtj9_input_work_func);
-	tj9->input_dev = input_allocate_device();
-	if (!tj9->input_dev) {
-		err = -ENOMEM;
-		dev_err(&tj9->client->dev, "input device allocate failed\n");
-		goto err0;
+	poll_dev = input_allocate_polled_device();
+	if (!poll_dev) {
+		dev_err(&tj9->client->dev,
+			"Failed to allocate polled device\n");
+		return -ENOMEM;
 	}
-	tj9->input_dev->open = kxtj9_input_open;
-	tj9->input_dev->close = kxtj9_input_close;
 
-	input_set_drvdata(tj9->input_dev, tj9);
+	tj9->polled_dev = poll_dev;
+	tj9->input_dev = poll_dev->input;
 
-	set_bit(EV_ABS, tj9->input_dev->evbit);
+	poll_dev->private = tj9;
+	poll_dev->poll = kxtj9_poll;
+	poll_dev->open = kxtj9_polled_input_open;
+	poll_dev->close = kxtj9_polled_input_close;
 
-	input_set_abs_params(tj9->input_dev, ABS_X, -G_MAX, G_MAX, FUZZ, FLAT);
-	input_set_abs_params(tj9->input_dev, ABS_Y, -G_MAX, G_MAX, FUZZ, FLAT);
-	input_set_abs_params(tj9->input_dev, ABS_Z, -G_MAX, G_MAX, FUZZ, FLAT);
+	kxtj9_init_input_device(tj9, poll_dev->input);
 
-	tj9->input_dev->name = "kxtj9_accel";
-	tj9->input_dev->id.bustype = BUS_I2C;
-	tj9->input_dev->dev.parent = &tj9->client->dev;
-
-	err = input_register_device(tj9->input_dev);
+	err = input_register_polled_device(poll_dev);
 	if (err) {
 		dev_err(&tj9->client->dev,
-			"unable to register input polled device %s: %d\n",
-			tj9->input_dev->name, err);
-		goto err1;
+			"Unable to register polled device, err=%d\n", err);
+		input_free_polled_device(poll_dev);
+		return 0;
 	}
 
 	return 0;
-err1:
-	input_free_device(tj9->input_dev);
-err0:
-	return err;
 }
 
-/* kxtj9_delay_show: returns the currently selected poll interval (in ms) */
-static ssize_t kxtj9_get_poll(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static kxtj9_teardown_polled_device(struct kxtj9_data *tj9)
 {
-	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
-	return sprintf(buf, "%d\n", tj9->pdata.poll_interval);
+	input_unregister_polled_device(tj9->poll_dev);
+	input_free_polled_device(tj9->poll_dev);
 }
 
-/* kxtj9_delay_store: allows the user to select a new poll interval (in ms) */
-static ssize_t kxtj9_set_poll(struct device *dev, struct device_attribute *attr,
-						const char *buf, size_t count)
+#else
+
+static inline int kxtj9_setup_polled_device(struct kxtj9_data *tj9)
 {
-	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
-	unsigned long interval;
-	int ret = kstrtoul(buf, 10, &interval);
-	if (ret < 0)
-		return ret;
+	return -ENOSYS;
+}
 
-	mutex_lock(&tj9->lock);
-	/* set current interval to the greater of the minimum interval or
-	the requested interval */
-	tj9->pdata.poll_interval = max((int)interval, tj9->pdata.min_interval);
-	mutex_unlock(&tj9->lock);
+static inline void kxtj9_teardown_polled_device(struct kxtj9_data *tj9)
+{
+}
+#endif
 
-	kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
+static int __devinit kxtj9_verify(struct kxtj9_data *tj9)
+{
+	int retval;
 
-	return count;
-}
-static DEVICE_ATTR(poll, S_IRUGO|S_IWUSR, kxtj9_get_poll, kxtj9_set_poll);
+	retval = kxtj9_device_power_on(tj9);
+	if (retval < 0)
+		return retval;
 
-static struct attribute *kxtj9_attributes[] = {
-	&dev_attr_poll.attr,
-	NULL
-};
+	retval = i2c_smbus_read_byte_data(tj9->client, WHO_AM_I);
+	if (retval < 0) {
+		dev_err(&tj9->client->dev, "read err int source\n");
+		goto out;
+	}
 
-static struct attribute_group kxtj9_attribute_group = {
-	.attrs = kxtj9_attributes
-};
+	retval = retval != 0x06 ? - EIO : 0;
+
+out:
+	kxtj9_device_power_off(tj9);
+	return retval;
+}
 
 static int __devinit kxtj9_probe(struct i2c_client *client,
-						const struct i2c_device_id *id)
+				 const struct i2c_device_id *id)
 {
-	int err = -1;
-	struct kxtj9_data *tj9 = kzalloc(sizeof(*tj9), GFP_KERNEL);
-	if (tj9 == NULL) {
-		dev_err(&client->dev,
-			"failed to allocate memory for module data\n");
-		err = -ENOMEM;
-		goto err0;
+	const struct kxtj9_platform_data *pdata = client->dev.platform_data;
+	struct kxtj9_data *tj9;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter,
+				I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "client is not i2c capable\n");
+		return -ENXIO;
 	}
-	if (client->dev.platform_data == NULL) {
+
+	if (!pdata) {
 		dev_err(&client->dev, "platform data is NULL; exiting\n");
-		err = -ENODEV;
-		goto err0;
+		return -EINVAL;
 	}
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
-						I2C_FUNC_SMBUS_BYTE_DATA)) {
-		dev_err(&client->dev, "client not i2c capable\n");
-		err = -ENODEV;
-		goto err0;
+
+	tj9 = kzalloc(sizeof(*tj9), GFP_KERNEL);
+	if (!tj9) {
+		dev_err(&client->dev,
+			"failed to allocate memory for module data\n");
+		return -ENOMEM;
 	}
-	mutex_init(&tj9->lock);
-	mutex_lock(&tj9->lock);
+
 	tj9->client = client;
-	i2c_set_clientdata(client, tj9);
+	tj9->pdata = *pdata;
 
-	memcpy(&tj9->pdata, client->dev.platform_data, sizeof(tj9->pdata));
-	if (tj9->pdata.init) {
-		err = tj9->pdata.init();
+	if (pdata->init) {
+		err = pdata->init();
 		if (err < 0)
-			goto err1;
+			goto err_free_mem;
 	}
 
-	err = sysfs_create_group(&client->dev.kobj, &kxtj9_attribute_group);
-	if (err)
-		goto err2;
+	err = kxtj9_verify(tj9);
+	if (err < 0) {
+		dev_err(&client->dev, "device not recognized\n");
+		goto err_pdata_exit;
+	}
 
-	tj9->resume[RES_CTRL_REG1] = tj9->pdata.res_12bit | tj9->pdata.g_range;
-	tj9->resume[RES_DATA_CTRL] = tj9->pdata.data_odr_init;
+	tj9->ctrl_reg1 = tj9->pdata.res_12bit | tj9->pdata.g_range;
+	tj9->data_ctrl = tj9->pdata.data_odr_init;
 
 	if (client->irq) {
-		err = request_threaded_irq(client->irq, NULL, kxtj9_isr,
-			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "kxtj9-irq", tj9);
-		if (err < 0) {
-			pr_err("%s: request irq failed: %d\n", __func__, err);
-			goto err5;
-		}
-		/* if in irq mode, populate INT_CTRL_REG1 and enable DRDY */
-		tj9->resume[RES_INT_CTRL1] = KXTJ9_IEN | KXTJ9_IEA | KXTJ9_IEL;
-		tj9->resume[RES_CTRL_REG1] |= DRDYE;
-	}
+		/* If in irq mode, populate INT_CTRL_REG1 and enable DRDY. */
+		tj9->int_ctrl |= KXTJ9_IEN | KXTJ9_IEA | KXTJ9_IEL;
+		tj9->ctrl_reg1 |= DRDYE;
 
-	err = kxtj9_input_init(tj9);
-	if (err < 0)
-		goto err3;
+		err = kxtj9_setup_input_device(tj9);
+		if (err)
+			goto err_pdata_exit;
 
-	err = kxtj9_device_power_on(tj9);
-	if (err < 0)
-		goto err4;
-	tj9->enabled = true;
+		err = request_threaded_irq(client->irq, NULL, kxtj9_isr,
+					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					   "kxtj9-irq", tj9);
+		if (err) {
+			dev_err(&client->dev, "request irq failed: %d\n", err);
+			goto err_destroy_input;
+		}
 
-	err = kxtj9_verify(tj9);
-	if (err < 0) {
-		dev_err(&client->dev, "device not recognized\n");
-		goto err5;
+	} else {
+		err = kxtj9_setup_polled_device(tj9);
+		if (err)
+			goto err_pdata_exit;
 	}
 
-	mutex_unlock(&tj9->lock);
-
+	i2c_set_clientdata(client, tj9);
 	return 0;
 
-err5:
-	kxtj9_device_power_off(tj9);
-err4:
+err_destroy_input:
 	input_unregister_device(tj9->input_dev);
-err3:
-	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
-err2:
+err_pdata_exit:
 	if (tj9->pdata.exit)
 		tj9->pdata.exit();
-err1:
-	mutex_unlock(&tj9->lock);
-err0:
+err_free_mem:
 	kfree(tj9);
 	return err;
 }
@@ -539,50 +521,69 @@ static int __devexit kxtj9_remove(struct i2c_client *client)
 {
 	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
 
-	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
-	if (client->irq)
+	if (client->irq) {
 		free_irq(client->irq, tj9);
-	input_unregister_device(tj9->input_dev);
-	kxtj9_device_power_off(tj9);
+		input_unregister_device(tj9->input_dev);
+	} else {
+		kxtj9_teardown_polled_device(tj9);
+	}
+
 	if (tj9->pdata.exit)
 		tj9->pdata.exit();
+
 	kfree(tj9);
 
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int kxtj9_resume(struct device *dev)
+#ifdef CONFIG_PM_SLEEP
+static int kxtj9_suspend(struct device *dev)
 {
-	return kxtj9_enable(i2c_get_clientdata(to_i2c_client(dev)));
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	struct input_dev *input_dev = tj9->input_dev;
+
+	mutex_lock(&input_dev->mutex);
+
+	if (input_dev->users)
+		kxtj9_disable(tj9);
+
+	mutex_unlock(&input_dev->mutex);
+	return 0;
 }
 
-static int kxtj9_suspend(struct device *dev)
+static int kxtj9_resume(struct device *dev)
 {
-	return kxtj9_disable(i2c_get_clientdata(to_i2c_client(dev)));
-}
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	struct input_dev *input_dev = tj9->input_dev;
+	int retval = 0;
 
-static const struct dev_pm_ops kxtj9_pm_ops = {
-	.suspend = kxtj9_suspend,
-	.resume = kxtj9_resume,
-};
+	mutex_lock(&input_dev->mutex);
+
+	if (input_dev->users)
+		kxtj9_enable(tj9);
+
+	mutex_unlock(&input_dev->mutex);
+	return retval;
+}
 #endif
 
+static SIMPLE_DEV_PM_OPS(kxtj9_pm_ops, kxtj9_suspend, kxtj9_resume);
+
 static const struct i2c_device_id kxtj9_id[] = {
-	{NAME, 0},
-	{},
+	{ NAME, 0 },
+	{ },
 };
 
 MODULE_DEVICE_TABLE(i2c, kxtj9_id);
 
 static struct i2c_driver kxtj9_driver = {
 	.driver = {
-		   .name = NAME,
-		   .owner = THIS_MODULE,
-#ifdef CONFIG_PM
-		   .pm = &kxtj9_pm_ops,
-#endif
-		   },
+		.name = NAME,
+		.owner = THIS_MODULE,
+		.pm = &kxtj9_pm_ops,
+	},
 	.probe = kxtj9_probe,
 	.remove = __devexit_p(kxtj9_remove),
 	.id_table = kxtj9_id,
@@ -592,13 +593,12 @@ static int __init kxtj9_init(void)
 {
 	return i2c_add_driver(&kxtj9_driver);
 }
+module_init(kxtj9_init);
 
 static void __exit kxtj9_exit(void)
 {
 	i2c_del_driver(&kxtj9_driver);
 }
-
-module_init(kxtj9_init);
 module_exit(kxtj9_exit);
 
 MODULE_DESCRIPTION("KXTJ9 accelerometer driver");
