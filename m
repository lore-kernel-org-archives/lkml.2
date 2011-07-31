Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1GaHJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:09:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57919 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1GaHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:08:51 -0400
Date: Sun, 31 Jul 2011 00:08:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk, jic23@cam.ac.uk,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v6 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110731070844.GA23383@core.coreip.homeip.net>
References: <1311800027-25982-1-git-send-email-eric.andersson@unixphere.com>
 <1311800027-25982-2-git-send-email-eric.andersson@unixphere.com>
 <20110730191726.GG5686@core.coreip.homeip.net>
 <20110730224917.GA8519@skinner.xfiles.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730224917.GA8519@skinner.xfiles.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 12:49:17AM +0200, Eric Andersson wrote:
> > > +static int bma150_open(struct bma150_data *bma150)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = pm_runtime_set_active(&bma150->client->dev);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	pm_runtime_enable(&bma150->client->dev);
> > 
> > I am pretty sure you want to call pm_runtime_enable() in bma150_probe()
> > so that parent controller can be suspended until somebody calls
> > bma150_open() and we mark the device as active (which, in turn, should
> > wake up its parent).
> 
> If I call pm_runtime_enable() I cannot use pm_runtime_set_active() later
> according to the comment in __pm_runtime_set_status (runtime.c):
> "If runtime PM of the device is disabled or its power.runtime_error
> field is different from zero, the status may be changed either to
> RPM_ACTIVE, or to RPM_SUSPENDED..."
> 
> If the PM of the device is enabled it will return -EAGAIN. Of course, we
> could enable() in probe, then disable(); set_active(); enable(); in
> open, but that seems a bit confused, right?

Hmm, indeed. I do not like the idea about disable/set_active/enable so I
guess we'll have to keep track of the current mode themselves and call
bma150_set_mode() ourselves if, after calling pm_runtime_get/put_sync()
we find that our mode is different from what we expect it to be.

I also noticed that you did not properly free IRQ on device removal and
also polled devices need to be freed always (unlike regular input
devices that should be only unregistered). The default_cfg can't be
__initdata because it is used by __devinit functions. And my version of
GCC can't figure out that ipoll_dev never used uninitialized and gives
false warning.

I tried correcting these issues in the patch below, along with renaming
'ret' to 'error' which I prefer when we dealing with error handling.
Could you please git it a try and if everything still works I'll fold it
and commit.

Thanks!

-- 
Dmitry


Input: bma150 - misc changes

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/bma150.c |  458 +++++++++++++++++++++++--------------------
 1 files changed, 248 insertions(+), 210 deletions(-)


diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
index dd509a9..8f55b54 100644
--- a/drivers/input/misc/bma150.c
+++ b/drivers/input/misc/bma150.c
@@ -150,6 +150,7 @@ struct bma150_data {
 	struct i2c_client *client;
 	struct input_polled_dev *input_polled;
 	struct input_dev *input;
+	u8 mode;
 };
 
 /*
@@ -157,7 +158,7 @@ struct bma150_data {
  * are stated and verified by Bosch Sensortec where they are configured
  * to provide a generic sensitivity performance.
  */
-static struct bma150_cfg default_cfg __initdata = {
+static struct bma150_cfg default_cfg __devinitdata = {
 	.any_motion_int = 1,
 	.hg_int = 1,
 	.lg_int = 1,
@@ -185,14 +186,16 @@ static int bma150_write_byte(struct i2c_client *client, u8 reg, u8 val)
 
 	if (client->irq)
 		enable_irq(client->irq);
+
 	return ret;
 }
 
 static int bma150_set_reg_bits(struct i2c_client *client,
 					int val, int shift, u8 mask, u8 reg)
 {
-	int data = i2c_smbus_read_byte_data(client, reg);
+	int data;
 
+	data = i2c_smbus_read_byte_data(client, reg);
 	if (data < 0)
 		return data;
 
@@ -200,135 +203,130 @@ static int bma150_set_reg_bits(struct i2c_client *client,
 	return bma150_write_byte(client, reg, data);
 }
 
-static int bma150_set_mode(struct i2c_client *client, u8 mode)
+static int bma150_set_mode(struct bma150_data *bma150, u8 mode)
 {
-	s32 ret;
+	int error;
 
-	ret = bma150_set_reg_bits(client, mode, BMA150_WAKE_UP_POS,
+	error = bma150_set_reg_bits(bma150->client, mode, BMA150_WAKE_UP_POS,
 				BMA150_WAKE_UP_MSK, BMA150_WAKE_UP_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(client, mode, BMA150_SLEEP_POS,
+	error = bma150_set_reg_bits(bma150->client, mode, BMA150_SLEEP_POS,
 				BMA150_SLEEP_MSK, BMA150_SLEEP_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
 	if (mode == BMA150_MODE_NORMAL)
 		msleep(2);
-	return ret;
+
+	bma150->mode = mode;
+	return 0;
 }
 
-static int __devinit bma150_soft_reset(struct i2c_client *client)
+static int __devinit bma150_soft_reset(struct bma150_data *bma150)
 {
-	s32 ret;
+	int error;
+
+	error = bma150_set_reg_bits(bma150->client, 1, BMA150_SW_RES_POS,
+				BMA150_SW_RES_MSK, BMA150_SW_RES_REG);
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(client, 1, BMA150_SW_RES_POS,
-			BMA150_SW_RES_MSK, BMA150_SW_RES_REG);
 	msleep(2);
-	return ret;
+	return 0;
 }
 
-static int __devinit bma150_set_range(struct i2c_client *client, u8 range)
+static int __devinit bma150_set_range(struct bma150_data *bma150, u8 range)
 {
-	s32 ret;
-
-	ret = bma150_set_reg_bits(client, range, BMA150_RANGE_POS,
+	return bma150_set_reg_bits(bma150->client, range, BMA150_RANGE_POS,
 				BMA150_RANGE_MSK, BMA150_RANGE_REG);
-	return ret;
 }
 
-static int __devinit bma150_set_bandwidth(struct i2c_client *client, u8 bw)
+static int __devinit bma150_set_bandwidth(struct bma150_data *bma150, u8 bw)
 {
-	s32 ret;
-
-	ret = bma150_set_reg_bits(client, bw, BMA150_BANDWIDTH_POS,
+	return bma150_set_reg_bits(bma150->client, bw, BMA150_BANDWIDTH_POS,
 				BMA150_BANDWIDTH_MSK, BMA150_BANDWIDTH_REG);
-	return ret;
 }
 
-static int __devinit bma150_set_low_g_interrupt(struct i2c_client *client,
+static int __devinit bma150_set_low_g_interrupt(struct bma150_data *bma150,
 					u8 enable, u8 hyst, u8 dur, u8 thres)
 {
-	s32 ret;
-	struct bma150_data *bma150 = i2c_get_clientdata(client);
+	int error;
 
-	ret = bma150_set_reg_bits(bma150->client, hyst,
+	error = bma150_set_reg_bits(bma150->client, hyst,
 				BMA150_LOW_G_HYST_POS, BMA150_LOW_G_HYST_MSK,
 				BMA150_LOW_G_HYST_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_write_byte(bma150->client,	BMA150_LOW_G_DUR_REG, dur);
-	if (ret < 0)
-		return ret;
+	error = bma150_write_byte(bma150->client, BMA150_LOW_G_DUR_REG, dur);
+	if (error)
+		return error;
 
-	ret = bma150_write_byte(bma150->client,	BMA150_LOW_G_THRES_REG, thres);
-	if (ret < 0)
-		return ret;
+	error = bma150_write_byte(bma150->client, BMA150_LOW_G_THRES_REG, thres);
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(bma150->client, !!enable,
+	return bma150_set_reg_bits(bma150->client, !!enable,
 				BMA150_LOW_G_EN_POS, BMA150_LOW_G_EN_MSK,
 				BMA150_LOW_G_EN_REG);
-	return ret;
 }
 
-static int __devinit bma150_set_high_g_interrupt(struct i2c_client *client,
+static int __devinit bma150_set_high_g_interrupt(struct bma150_data *bma150,
 					u8 enable, u8 hyst, u8 dur, u8 thres)
 {
-	s32 ret;
-	struct bma150_data *bma150 = i2c_get_clientdata(client);
+	int error;
 
-	ret = bma150_set_reg_bits(bma150->client, hyst,
+	error = bma150_set_reg_bits(bma150->client, hyst,
 				BMA150_HIGH_G_HYST_POS, BMA150_HIGH_G_HYST_MSK,
 				BMA150_HIGH_G_HYST_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_write_byte(bma150->client,	BMA150_HIGH_G_DUR_REG, dur);
-	if (ret < 0)
-		return ret;
+	error = bma150_write_byte(bma150->client,
+				BMA150_HIGH_G_DUR_REG, dur);
+	if (error)
+		return error;
 
-	ret = bma150_write_byte(bma150->client,	BMA150_HIGH_G_THRES_REG, thres);
-	if (ret < 0)
-		return ret;
+	error = bma150_write_byte(bma150->client,
+				BMA150_HIGH_G_THRES_REG, thres);
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(bma150->client, !!enable,
+	return bma150_set_reg_bits(bma150->client, !!enable,
 				BMA150_HIGH_G_EN_POS, BMA150_HIGH_G_EN_MSK,
 				BMA150_HIGH_G_EN_REG);
-	return ret;
 }
 
 
-static int __devinit bma150_set_any_motion_interrupt(struct i2c_client *client,
+static int __devinit bma150_set_any_motion_interrupt(struct bma150_data *bma150,
 						u8 enable, u8 dur, u8 thres)
 {
-	s32 ret;
-	struct bma150_data *bma150 = i2c_get_clientdata(client);
+	int error;
 
-	ret = bma150_set_reg_bits(bma150->client, dur,
+	error = bma150_set_reg_bits(bma150->client, dur,
 				BMA150_ANY_MOTION_DUR_POS,
 				BMA150_ANY_MOTION_DUR_MSK,
 				BMA150_ANY_MOTION_DUR_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_write_byte(bma150->client,
+	error = bma150_write_byte(bma150->client,
 				BMA150_ANY_MOTION_THRES_REG, thres);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(bma150->client, !!enable,
+	error = bma150_set_reg_bits(bma150->client, !!enable,
 				BMA150_ADV_INT_EN_POS, BMA150_ADV_INT_EN_MSK,
 				BMA150_ADV_INT_EN_REG);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
-	ret = bma150_set_reg_bits(bma150->client, !!enable,
+	return bma150_set_reg_bits(bma150->client, !!enable,
 				BMA150_ANY_MOTION_EN_POS,
 				BMA150_ANY_MOTION_EN_MSK,
 				BMA150_ANY_MOTION_EN_REG);
-	return ret;
 }
 
 static void bma150_report_xyz(struct bma150_data *bma150)
@@ -360,6 +358,7 @@ static void bma150_report_xyz(struct bma150_data *bma150)
 static irqreturn_t bma150_irq_thread(int irq, void *dev)
 {
 	bma150_report_xyz(dev);
+
 	return IRQ_HANDLED;
 }
 
@@ -370,22 +369,31 @@ static void bma150_poll(struct input_polled_dev *dev)
 
 static int bma150_open(struct bma150_data *bma150)
 {
-	int ret;
-
-	ret = pm_runtime_set_active(&bma150->client->dev);
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_enable(&bma150->client->dev);
+	int error;
+
+	error = pm_runtime_get_sync(&bma150->client->dev);
+	if (error && error != -ENOSYS)
+		return error;
+
+	/*
+	 * See if runtime PM woke up the device. If runtime PM
+	 * is disabled we need to do it ourselves.
+	 */
+	if (bma150->mode != BMA150_MODE_NORMAL) {
+		error = bma150_set_mode(bma150, BMA150_MODE_NORMAL);
+		if (error)
+			return error;
+	}
 
-	return bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);
+	return 0;
 }
 
 static void bma150_close(struct bma150_data *bma150)
 {
-	pm_runtime_disable(&bma150->client->dev);
-	pm_runtime_set_suspended(&bma150->client->dev);
-	bma150_set_mode(bma150->client, BMA150_MODE_SLEEP);
+	pm_runtime_put_sync(&bma150->client->dev);
+
+	if (bma150->mode != BMA150_MODE_SLEEP)
+		bma150_set_mode(bma150, BMA150_MODE_SLEEP);
 }
 
 static int bma150_irq_open(struct input_dev *input)
@@ -416,81 +424,50 @@ static void bma150_poll_close(struct input_polled_dev *ipoll_dev)
 	bma150_close(bma150);
 }
 
-static void bma150_free_input_device(struct bma150_data *bma150)
+static int __devinit bma150_initialize(struct bma150_data *bma150,
+				       const struct bma150_cfg *cfg)
 {
-	if (bma150->client->irq > 0)
-		input_unregister_device(bma150->input);
-	else
-		input_unregister_polled_device(bma150->input_polled);
-}
-
-static int __devinit bma150_initialize(struct i2c_client *client,
-				       struct bma150_cfg *cfg)
-{
-	s32 ret;
+	int error;
+
+	error = bma150_soft_reset(bma150);
+	if (error)
+		return error;
+
+	error = bma150_set_bandwidth(bma150, cfg->bandwidth);
+	if (error)
+		return error;
+
+	error = bma150_set_range(bma150, cfg->range);
+	if (error)
+		return error;
+
+	if (bma150->client->irq) {
+		error = bma150_set_any_motion_interrupt(bma150,
+					cfg->any_motion_int,
+					cfg->any_motion_dur,
+					cfg->any_motion_thres);
+		if (error)
+			return error;
+
+		error = bma150_set_high_g_interrupt(bma150,
+					cfg->hg_int, cfg->hg_hyst,
+					cfg->hg_dur, cfg->hg_thres);
+		if (error)
+			return error;
+
+		error = bma150_set_low_g_interrupt(bma150,
+					cfg->lg_int, cfg->lg_hyst,
+					cfg->lg_dur, cfg->lg_thres);
+		if (error)
+			return error;
+	}
 
-	ret = bma150_soft_reset(client);
-	if (ret < 0)
-		return ret;
-
-	ret = bma150_set_bandwidth(client, cfg->bandwidth);
-	if (ret < 0)
-		return ret;
-
-	ret = bma150_set_range(client, cfg->range);
-	if (ret < 0)
-		return ret;
-
-	if (!client->irq)
-		goto exit;
-
-	ret = bma150_set_any_motion_interrupt(client, cfg->any_motion_int,
-			cfg->any_motion_dur, cfg->any_motion_thres);
-	if (ret < 0)
-		return ret;
-
-	ret = bma150_set_high_g_interrupt(client, cfg->hg_int,
-			cfg->hg_hyst, cfg->hg_dur, cfg->hg_thres);
-	if (ret < 0)
-		return ret;
-
-	ret = bma150_set_low_g_interrupt(client, cfg->lg_int,
-			cfg->lg_hyst, cfg->lg_dur, cfg->lg_thres);
-	if (ret < 0)
-		return ret;
-exit:
-	ret = bma150_set_mode(client, BMA150_MODE_SLEEP);
-	return ret;
+	return bma150_set_mode(bma150, BMA150_MODE_SLEEP);
 }
 
-static int __devinit bma150_setup_input_device(struct bma150_data *bma150)
+static void __devinit bma150_init_input_device(struct bma150_data *bma150,
+						struct input_dev *idev)
 {
-	struct input_polled_dev *ipoll_dev;
-	struct input_dev *idev;
-	int ret;
-
-	if (bma150->client->irq > 0) {
-		idev = input_allocate_device();
-		if (!idev)
-			return -ENOMEM;
-		idev->open = bma150_irq_open;
-		idev->close = bma150_irq_close;
-		input_set_drvdata(idev, bma150);
-	} else {
-		ipoll_dev = input_allocate_polled_device();
-		if (!ipoll_dev)
-			return -ENOMEM;
-		ipoll_dev->private = bma150;
-		ipoll_dev->open = bma150_poll_open;
-		ipoll_dev->close = bma150_poll_close;
-		ipoll_dev->poll = bma150_poll;
-		ipoll_dev->poll_interval = BMA150_POLL_INTERVAL;
-		ipoll_dev->poll_interval_min = BMA150_POLL_MIN;
-		ipoll_dev->poll_interval_max = BMA150_POLL_MAX;
-
-		idev = ipoll_dev->input;
-	}
-
 	idev->name = BMA150_DRIVER;
 	idev->phys = BMA150_DRIVER "/input0";
 	idev->id.bustype = BUS_I2C;
@@ -500,54 +477,81 @@ static int __devinit bma150_setup_input_device(struct bma150_data *bma150)
 	input_set_abs_params(idev, ABS_X, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
 	input_set_abs_params(idev, ABS_Y, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
 	input_set_abs_params(idev, ABS_Z, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+}
 
-	if (bma150->client->irq > 0) {
-		ret = input_register_device(idev);
-		if (ret < 0) {
-			input_free_device(idev);
-			return ret;
-		}
-		ret = request_threaded_irq(bma150->client->irq, NULL,
-			bma150_irq_thread, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-			BMA150_DRIVER, bma150);
-		if (ret < 0) {
-			dev_err(&bma150->client->dev,
-				"irq request failed %d, ret %d\n",
-				bma150->client->irq, ret);
-			goto error_irq;
-		}
-	} else {
-		ret = input_register_polled_device(ipoll_dev);
-		if (ret < 0) {
-			input_free_polled_device(ipoll_dev);
-			return ret;
-		}
-		bma150->input_polled = ipoll_dev;
+static int __devinit bma150_register_input_device(struct bma150_data *bma150)
+{
+	struct input_dev *idev;
+	int error;
+
+	idev = input_allocate_device();
+	if (!idev)
+		return -ENOMEM;
+
+	bma150_init_input_device(bma150, idev);
+
+	idev->open = bma150_irq_open;
+	idev->close = bma150_irq_close;
+	input_set_drvdata(idev, bma150);
+
+	error = input_register_device(idev);
+	if (error) {
+		input_free_device(idev);
+		return error;
 	}
+
 	bma150->input = idev;
-	return ret;
+	return 0;
+}
 
-error_irq:
-	bma150_free_input_device(bma150);
-	return ret;
+static int __devinit bma150_register_polled_device(struct bma150_data *bma150)
+{
+	struct input_polled_dev *ipoll_dev;
+	int error;
+
+	ipoll_dev = input_allocate_polled_device();
+	if (!ipoll_dev)
+		return -ENOMEM;
+
+	ipoll_dev->private = bma150;
+	ipoll_dev->open = bma150_poll_open;
+	ipoll_dev->close = bma150_poll_close;
+	ipoll_dev->poll = bma150_poll;
+	ipoll_dev->poll_interval = BMA150_POLL_INTERVAL;
+	ipoll_dev->poll_interval_min = BMA150_POLL_MIN;
+	ipoll_dev->poll_interval_max = BMA150_POLL_MAX;
+
+	bma150_init_input_device(bma150, ipoll_dev->input);
+
+	error = input_register_polled_device(ipoll_dev);
+	if (error) {
+		input_free_polled_device(ipoll_dev);
+		return error;
+	}
+
+	bma150->input_polled = ipoll_dev;
+	bma150->input = ipoll_dev->input;
+
+	return 0;
 }
 
 static int __devinit bma150_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
-	struct bma150_cfg *cfg;
+	const struct bma150_platform_data *pdata = client->dev.platform_data;
+	const struct bma150_cfg *cfg;
 	struct bma150_data *bma150;
-	struct bma150_platform_data *pdata;
-	int ret;
+	int chip_id;
+	int error;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_err(&client->dev, "i2c_check_functionality error\n");
 		return -EIO;
 	}
 
-	ret = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
-	if (ret != BMA150_CHIP_ID) {
-		dev_err(&client->dev, "BMA150 chip id error: %d\n", ret);
+	chip_id = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
+	if (chip_id != BMA150_CHIP_ID) {
+		dev_err(&client->dev, "BMA150 chip id error: %d\n", chip_id);
 		return -EINVAL;
 	}
 
@@ -555,62 +559,96 @@ static int __devinit bma150_probe(struct i2c_client *client,
 	if (!bma150)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, bma150);
 	bma150->client = client;
 
-	pdata = client->dev.platform_data;
 	if (pdata) {
-		if (pdata->irq_gpio_cfg && (pdata->irq_gpio_cfg() < 0)) {
-			dev_err(&client->dev,
-				"IRQ GPIO conf. error %d, ret %d\n",
-				client->irq, ret);
-			goto kfree_exit;
+		if (pdata->irq_gpio_cfg) {
+			error = pdata->irq_gpio_cfg();
+			if (error) {
+				dev_err(&client->dev,
+					"IRQ GPIO conf. error %d, error %d\n",
+					client->irq, error);
+				goto err_free_mem;
+			}
 		}
 		cfg = &pdata->cfg;
 	} else {
 		cfg = &default_cfg;
 	}
-	ret = bma150_initialize(client, cfg);
-	if (ret < 0)
-		goto kfree_exit;
 
-	ret = bma150_setup_input_device(bma150);
-	if (ret < 0)
-		goto kfree_exit;
+	error = bma150_initialize(bma150, cfg);
+	if (error)
+		goto err_free_mem;
+
+	if (client->irq > 0) {
+		error = bma150_register_input_device(bma150);
+		if (error)
+			goto err_free_mem;
+
+		error = request_threaded_irq(client->irq,
+					NULL, bma150_irq_thread,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					BMA150_DRIVER, bma150);
+		if (error) {
+			dev_err(&client->dev,
+				"irq request failed %d, error %d\n",
+				client->irq, error);
+			input_unregister_device(bma150->input);
+			goto err_free_mem;
+		}
+	} else {
+		error = bma150_register_polled_device(bma150);
+		if (error)
+			goto err_free_mem;
+	}
+
+	i2c_set_clientdata(client, bma150);
+
+	pm_runtime_enable(&client->dev);
 
-	dev_info(&client->dev, "Registered BMA150 I2C driver\n");
 	return 0;
 
-kfree_exit:
+err_free_mem:
 	kfree(bma150);
-	return ret;
+	return error;
 }
 
-#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
-static int bma150_suspend(struct device *dev)
+static int __devexit bma150_remove(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	pm_runtime_disable(&client->dev);
+
+	if (client->irq > 0) {
+		free_irq(client->irq, bma150);
+		input_unregister_device(bma150->input);
+	} else {
+		input_unregister_polled_device(bma150->input_polled);
+		input_free_polled_device(bma150->input_polled);
+	}
 
-	return bma150_set_mode(client, BMA150_MODE_SLEEP);
+	kfree(bma150);
+
+	return 0;
 }
 
-static int bma150_resume(struct device *dev)
+#ifdef CONFIG_PM
+static int bma150_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
 
-	return bma150_set_mode(client, BMA150_MODE_NORMAL);
+	return bma150_set_mode(bma150, BMA150_MODE_SLEEP);
 }
-#endif
 
-static int __devexit bma150_remove(struct i2c_client *client)
+static int bma150_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bma150_data *bma150 = i2c_get_clientdata(client);
 
-	pm_runtime_disable(&bma150->client->dev);
-	bma150_free_input_device(bma150);
-	kfree(bma150);
-	return 0;
+	return bma150_set_mode(bma150, BMA150_MODE_NORMAL);
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(bma150_pm, bma150_suspend, bma150_resume, NULL);
 
@@ -629,7 +667,7 @@ static struct i2c_driver bma150_driver = {
 		.name	= BMA150_DRIVER,
 		.pm	= &bma150_pm,
 	},
-	.class          = I2C_CLASS_HWMON,
+	.class		= I2C_CLASS_HWMON,
 	.id_table	= bma150_id,
 	.probe		= bma150_probe,
 	.remove		= __devexit_p(bma150_remove),
