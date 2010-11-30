Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0K3H7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:59:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46369 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0K3H7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y2poIzrIQp8T+86Ad7nKbtthXEZME2bU1xUCne020KTLU79neypCSTCAlkqk88NK88
         HF8qaN/P+CJhNZV2e8cTq2xOMwF2wr9Thhxz8QgP9PKNeada40HDpsuJCLd5YmyKpGkv
         gDxYC+V62cBj/p8JdrJXuDcTBaiRjF9hpkdYQ=
Date: Mon, 29 Nov 2010 23:59:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Hemanth V <hemanthv@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        saaguirre@ti.com, Shubhrajyoti@ti.com
Subject: Re: PATCH V4 1/2] input: CMA3000 Accelerometer Driver
Message-ID: <20101130075911.GC15731@core.coreip.homeip.net>
References: <37129.10.24.255.17.1291028260.squirrel@dbdmail.itg.ti.com>
 <4CF38E4D.3070309@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF38E4D.3070309@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:28:13AM +0000, Jonathan Cameron wrote:
> On 11/29/10 10:57, Hemanth V wrote:
> >>From 9985dc1211ae33baa877489c26920dfd1c29bb35 Mon Sep 17 00:00:00 2001
> > From: Hemanth V <hemanthv@ti.com>
> > Date: Thu, 26 Aug 2010 17:44:48 +0530
> > Subject: [PATCH] input: CMA3000 Accelerometer Driver
> > 
> > Add support for CMA3000 Tri-axis accelerometer, which
> > supports Motion detect, Measurement and Free fall modes.
> > CMA3000 supports both I2C/SPI bus for communication, currently the
> > driver supports I2C based communication.
> > 
> > Driver reports acceleration data through input subsystem
> 
> Couple of nitpicks inline.  There's one unneeded NULL assignment
> that should probably be cleaned up. I'd also like to see actual
> part numbers listed somewhere in the Kconfig help text.
> 
> The removal of various temporary variables is something I know
> at least one other reviewer has commented on.  Basically they may
> make the code look cleaner, but they add (marginally) to the
> review burden and that's annoys reviewers ;)
> 
> Anyhow, all the comments are trivial. Nice driver Hemanth.
> 
> Dmitry: This is clean and for now has none of the controversial
> sysfs interfaces so baring the input bits (which I'm not as
> familiar with and you might want to glance over) this looks
> ready to merge to me.

Yep, almost there.

Hemanth, does the driver still work if you apply the patch below?

Thanks.

-- 
Dmitry

Input: cma3000 - misc fixes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/Kconfig           |   18 +-
 drivers/input/misc/cma3000_d0x.c     |  344 ++++++++++++++++++++--------------
 drivers/input/misc/cma3000_d0x.h     |   30 +--
 drivers/input/misc/cma3000_d0x_i2c.c |  117 ++++++------
 include/linux/input/cma3000.h        |   10 -
 5 files changed, 286 insertions(+), 233 deletions(-)


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index d5e5fd6..f0d9017 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -449,10 +449,10 @@ config INPUT_ADXL34X_SPI
 	  module will be called adxl34x-spi.
 
 config INPUT_CMA3000
- 	tristate "VTI CMA3000 Tri-axis accelerometer"
- 	help
- 	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
- 	  driver
+	tristate "VTI CMA3000 Tri-axis accelerometer"
+	help
+	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
+	  driver
 
 	  This driver currently only supports I2C interface to the
 	  controller. Also select the I2C method.
@@ -463,11 +463,11 @@ config INPUT_CMA3000
 	  module will be called cma3000_d0x.
 
 config INPUT_CMA3000_I2C
- 	tristate "Support I2C bus connection"
- 	depends on INPUT_CMA3000 && I2C
- 	help
- 	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
- 	  through I2C interface.
+	tristate "Support I2C bus connection"
+	depends on INPUT_CMA3000 && I2C
+	help
+	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
+	  through I2C interface.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called cma3000_d0x_i2c.
diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index 158add9..421502a 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -1,7 +1,5 @@
 /*
- * cma3000_d0x.c
  * VTI CMA3000_D0x Accelerometer driver
- *	Supports I2C interface
  *
  * Copyright (C) 2010 Texas Instruments
  * Author: Hemanth V <hemanthv@ti.com>
@@ -19,10 +17,11 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/platform_device.h>
 #include <linux/input/cma3000.h>
 
 #include "cma3000_d0x.h"
@@ -63,10 +62,29 @@
 #define BIT_TO_2G  18
 #define BIT_TO_8G  71
 
+struct cma3000_accl_data {
+	const struct cma3000_bus_ops *bus_ops;
+	const struct cma3000_platform_data *pdata;
+
+	struct device *dev;
+	struct input_dev *input_dev;
+
+	int bit_to_mg;
+	int irq;
+
+	int g_range;
+	u8 mode;
+
+	struct mutex mutex;
+	bool opened;
+	bool suspended;
+};
+
 #define CMA3000_READ(data, reg, msg) \
-	((data)->bus_ops->read(data, reg, msg))
+	(data->bus_ops->read(data->dev, reg, msg))
 #define CMA3000_SET(data, reg, val, msg) \
-	((data)->bus_ops->write(data, reg, val, msg))
+	((data)->bus_ops->write(data->dev, reg, val, msg))
+
 /*
  * Conversion for each of the eight modes to g, depending
  * on G range i.e 2G or 8G. Some modes always operate in
@@ -74,29 +92,29 @@
  */
 
 static int mode_to_mg[8][2] = {
-	{0, 0},
-	{BIT_TO_8G, BIT_TO_2G},
-	{BIT_TO_8G, BIT_TO_2G},
-	{BIT_TO_8G, BIT_TO_8G},
-	{BIT_TO_8G, BIT_TO_8G},
-	{BIT_TO_8G, BIT_TO_2G},
-	{BIT_TO_8G, BIT_TO_2G},
-	{0, 0},
+	{ 0, 0 },
+	{ BIT_TO_8G, BIT_TO_2G },
+	{ BIT_TO_8G, BIT_TO_2G },
+	{ BIT_TO_8G, BIT_TO_8G },
+	{ BIT_TO_8G, BIT_TO_8G },
+	{ BIT_TO_8G, BIT_TO_2G },
+	{ BIT_TO_8G, BIT_TO_2G },
+	{ 0, 0},
 };
 
 static void decode_mg(struct cma3000_accl_data *data, int *datax,
 				int *datay, int *dataz)
 {
 	/* Data in 2's complement, convert to mg */
-	*datax = (((s8)(*datax)) * (data->bit_to_mg));
-	*datay = (((s8)(*datay)) * (data->bit_to_mg));
-	*dataz = (((s8)(*dataz)) * (data->bit_to_mg));
+	*datax = ((s8)*datax) * data->bit_to_mg;
+	*datay = ((s8)*datay) * data->bit_to_mg;
+	*dataz = ((s8)*dataz) * data->bit_to_mg;
 }
 
 static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
 {
 	struct cma3000_accl_data *data = dev_id;
-	int  datax, datay, dataz;
+	int datax, datay, dataz;
 	u8 ctrl, mode, range, intr_status;
 
 	intr_status = CMA3000_READ(data, CMA3000_INTSTATUS, "interrupt status");
@@ -138,7 +156,7 @@ static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
 
 static int cma3000_reset(struct cma3000_accl_data *data)
 {
-	int ret;
+	int val;
 
 	/* Reset sequence */
 	CMA3000_SET(data, CMA3000_RSTR, 0x02, "Reset");
@@ -148,53 +166,44 @@ static int cma3000_reset(struct cma3000_accl_data *data)
 	/* Settling time delay */
 	mdelay(10);
 
-	ret = CMA3000_READ(data, CMA3000_STATUS, "Status");
-	if (ret < 0) {
-		dev_err(&data->client->dev, "Reset failed\n");
-		return ret;
-	} else if (ret & CMA3000_STATUS_PERR) {
-		dev_err(&data->client->dev, "Parity Error\n");
+	val = CMA3000_READ(data, CMA3000_STATUS, "Status");
+	if (val < 0) {
+		dev_err(data->dev, "Reset failed\n");
+		return val;
+	}
+
+	if (val & CMA3000_STATUS_PERR) {
+		dev_err(data->dev, "Parity Error\n");
 		return -EIO;
-	} else {
-		return 0;
 	}
+
+	return 0;
 }
 
-int cma3000_poweron(struct cma3000_accl_data *data)
+static int cma3000_poweron(struct cma3000_accl_data *data)
 {
-	uint8_t ctrl = 0, mdthr, mdfftmr, ffthr, mode;
-	int g_range, ret;
-
-	g_range = data->pdata.g_range;
-	mode = data->pdata.mode;
-	mdthr = data->pdata.mdthr;
-	mdfftmr = data->pdata.mdfftmr;
-	ffthr = data->pdata.ffthr;
-
-	if (mode < CMAMODE_DEFAULT || mode > CMAMODE_POFF) {
-		data->pdata.mode = CMAMODE_MOTDET;
-		mode = data->pdata.mode;
-		dev_info(&data->client->dev,
-			"Invalid mode specified, assuming Motion Detect\n");
-	}
+	const struct cma3000_platform_data *pdata = data->pdata;
+	u8 ctrl = 0;
+	int ret;
 
-	if (g_range == CMARANGE_2G) {
-		ctrl = (mode << 1) | CMA3000_RANGE2G;
-	} else if (g_range == CMARANGE_8G) {
-		ctrl = (mode << 1) | CMA3000_RANGE8G;
+	if (data->g_range == CMARANGE_2G) {
+		ctrl = (data->mode << 1) | CMA3000_RANGE2G;
+	} else if (data->g_range == CMARANGE_8G) {
+		ctrl = (data->mode << 1) | CMA3000_RANGE8G;
 	} else {
-		dev_info(&data->client->dev,
-			"Invalid G range specified, assuming 8G\n");
-		ctrl = (mode << 1) | CMA3000_RANGE8G;
-		data->pdata.g_range = CMARANGE_8G;
+		dev_info(data->dev,
+			 "Invalid G range specified, assuming 8G\n");
+		ctrl = (data->mode << 1) | CMA3000_RANGE8G;
 	}
-#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
-	ctrl |= CMA3000_BUSI2C;
-#endif
 
-	CMA3000_SET(data, CMA3000_MDTHR, mdthr, "Motion Detect Threshold");
-	CMA3000_SET(data, CMA3000_MDFFTMR, mdfftmr, "Time register");
-	CMA3000_SET(data, CMA3000_FFTHR, ffthr, "Free fall threshold");
+	ctrl |= data->bus_ops->ctrl_mod;
+
+	CMA3000_SET(data, CMA3000_MDTHR, pdata->mdthr,
+		    "Motion Detect Threshold");
+	CMA3000_SET(data, CMA3000_MDFFTMR, pdata->mdfftmr,
+		    "Time register");
+	CMA3000_SET(data, CMA3000_FFTHR, pdata->ffthr,
+		    "Free fall threshold");
 	ret = CMA3000_SET(data, CMA3000_CTRL, ctrl, "Mode setting");
 	if (ret < 0)
 		return -EIO;
@@ -203,9 +212,8 @@ int cma3000_poweron(struct cma3000_accl_data *data)
 
 	return 0;
 }
-EXPORT_SYMBOL(cma3000_poweron);
 
-int cma3000_poweroff(struct cma3000_accl_data *data)
+static int cma3000_poweroff(struct cma3000_accl_data *data)
 {
 	int ret;
 
@@ -214,118 +222,172 @@ int cma3000_poweroff(struct cma3000_accl_data *data)
 
 	return ret;
 }
-EXPORT_SYMBOL(cma3000_poweroff);
 
-int cma3000_init(struct cma3000_accl_data *data)
+static int cma3000_open(struct input_dev *input_dev)
 {
-	int ret = 0, fuzz_x, fuzz_y, fuzz_z, g_range;
-	uint32_t irqflags;
+	struct cma3000_accl_data *data = input_get_drvdata(input_dev);
 
-	if (data->client->dev.platform_data == NULL) {
-		dev_err(&data->client->dev, "platform data not found\n");
-		ret = -EINVAL;
-		goto err_op1_failed;
-	}
+	mutex_lock(&data->mutex);
 
-	/* if no IRQ return error */
-	if (data->client->irq == 0) {
-		ret = -EINVAL;
-		goto err_op1_failed;
+	if (!data->suspended)
+		cma3000_poweron(data);
+
+	data->opened = true;
+
+	mutex_unlock(&data->mutex);
+
+	return 0;
+}
+
+static void cma3000_close(struct input_dev *input_dev)
+{
+	struct cma3000_accl_data *data = input_get_drvdata(input_dev);
+
+	mutex_lock(&data->mutex);
+
+	if (!data->suspended)
+		cma3000_poweroff(data);
+
+	data->opened = false;
+
+	mutex_unlock(&data->mutex);
+}
+
+void cma3000_suspend(struct cma3000_accl_data *data)
+{
+	mutex_lock(&data->mutex);
+
+	if (!data->suspended && data->opened)
+		cma3000_poweroff(data);
+
+	data->suspended = true;
+
+	mutex_unlock(&data->mutex);
+}
+EXPORT_SYMBOL(cma3000_suspend);
+
+
+void cma3000_resume(struct cma3000_accl_data *data)
+{
+	mutex_lock(&data->mutex);
+
+	if (data->suspended && data->opened)
+		cma3000_poweron(data);
+
+	data->suspended = false;
+
+	mutex_unlock(&data->mutex);
+}
+EXPORT_SYMBOL(cma3000_resume);
+
+struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
+				       const struct cma3000_bus_ops *bops)
+{
+	const struct cma3000_platform_data *pdata = dev->platform_data;
+	struct cma3000_accl_data *data;
+	struct input_dev *input_dev;
+	int rev;
+	int error;
+
+	if (!pdata) {
+		dev_err(dev, "platform data not found\n");
+		error = -EINVAL;
+		goto err_out;
 	}
 
-	memcpy(&(data->pdata), data->client->dev.platform_data,
-		sizeof(struct cma3000_platform_data));
 
-	ret = cma3000_reset(data);
-	if (ret)
-		goto err_op1_failed;
+	/* if no IRQ return error */
+	if (irq == 0) {
+		error = -EINVAL;
+		goto err_out;
+	}
 
-	ret = CMA3000_READ(data, CMA3000_REVID, "Revid");
-	if (ret < 0)
-		goto err_op1_failed;
+	data = kzalloc(sizeof(struct cma3000_accl_data), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!data || !input_dev) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
 
-	pr_info("CMA3000 Accelerometer : Revision %x\n", ret);
+	data->dev = dev;
+	data->input_dev = input_dev;
+	data->bus_ops = bops;
+	data->pdata = pdata;
+	mutex_init(&data->mutex);
 
-	/* Bring it out of default power down state */
-	ret = cma3000_poweron(data);
-	if (ret < 0)
-		goto err_op1_failed;
-
-	fuzz_x = data->pdata.fuzz_x;
-	fuzz_y = data->pdata.fuzz_y;
-	fuzz_z = data->pdata.fuzz_z;
-	g_range = data->pdata.g_range;
-	irqflags = data->pdata.irqflags;
-
-	data->input_dev = input_allocate_device();
-	if (data->input_dev == NULL) {
-		ret = -ENOMEM;
-		dev_err(&data->client->dev,
-			"Failed to allocate input device\n");
-		goto err_op1_failed;
+	data->mode = pdata->mode;
+	if (data->mode < CMAMODE_DEFAULT || data->mode > CMAMODE_POFF) {
+		data->mode = CMAMODE_MOTDET;
+		dev_warn(dev,
+			 "Invalid mode specified, assuming Motion Detect\n");
 	}
 
-	data->input_dev->name = "cma3000-accelerometer";
+	data->g_range = pdata->g_range;
+	if (data->g_range != CMARANGE_2G && data->g_range != CMA3000_RANGE8G) {
+		dev_info(dev,
+			 "Invalid G range specified, assuming 8G\n");
+		data->g_range = CMARANGE_8G;
+	}
 
-#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
-	data->input_dev->id.bustype = BUS_I2C;
-#endif
+	input_dev->name = "cma3000-accelerometer";
+	input_dev->id.bustype = bops->bustype;
+	input_dev->open = cma3000_open;
+	input_dev->close = cma3000_close;
 
-	 __set_bit(EV_ABS, data->input_dev->evbit);
-	 __set_bit(EV_MSC, data->input_dev->evbit);
+	 __set_bit(EV_ABS, input_dev->evbit);
 
-	input_set_abs_params(data->input_dev, ABS_X, -g_range,
-				g_range, fuzz_x, 0);
-	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
-				g_range, fuzz_y, 0);
-	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
-				g_range, fuzz_z, 0);
-	input_set_abs_params(data->input_dev, ABS_MISC, 0,
-				1, 0, 0);
+	input_set_abs_params(input_dev, ABS_X,
+			-data->g_range, data->g_range, pdata->fuzz_x, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			-data->g_range, data->g_range, pdata->fuzz_y, 0);
+	input_set_abs_params(input_dev, ABS_Z,
+			-data->g_range, data->g_range, pdata->fuzz_z, 0);
 
-	mutex_init(&data->mutex);
+	input_set_drvdata(input_dev, data);
 
-	ret = request_threaded_irq(data->client->irq, NULL,
-				cma3000_thread_irq,
-				irqflags | IRQF_ONESHOT,
-				data->client->name, data);
+	error = cma3000_reset(data);
+	if (error)
+		goto err_free_mem;
 
-	if (ret < 0) {
-		dev_err(&data->client->dev,
-			"request_threaded_irq failed\n");
-		goto err_op2_failed;
+	rev = CMA3000_READ(data, CMA3000_REVID, "Revid");
+	if (rev < 0) {
+		error = rev;
+		goto err_free_mem;
 	}
 
-	ret = input_register_device(data->input_dev);
-	if (ret) {
-		dev_err(&data->client->dev,
-			"Unable to register input device\n");
-		goto err_op3_failed;
+	pr_info("CMA3000 Accelerometer: Revision %x\n", rev);
+
+	error = request_threaded_irq(irq, NULL, cma3000_thread_irq,
+				     pdata->irqflags | IRQF_ONESHOT,
+				     "cma3000_d0x", data);
+	if (error) {
+		dev_err(dev, "request_threaded_irq failed\n");
+		goto err_free_mem;
 	}
 
-	return 0;
+	error = input_register_device(data->input_dev);
+	if (error) {
+		dev_err(dev, "Unable to register input device\n");
+		goto err_free_irq;
+	}
 
-err_op3_failed:
-	free_irq(data->client->irq, data);
-err_op2_failed:
-	mutex_destroy(&data->mutex);
-err_op1_failed:
-	input_free_device(data->input_dev);
+	return data;
 
-	return ret;
+err_free_irq:
+	free_irq(irq, data);
+err_free_mem:
+	input_free_device(input_dev);
+	kfree(data);
+err_out:
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(cma3000_init);
 
-int cma3000_exit(struct cma3000_accl_data *data)
+void cma3000_exit(struct cma3000_accl_data *data)
 {
-	int ret;
-
-	ret = cma3000_poweroff(data);
-	free_irq(data->client->irq, data);
-	mutex_destroy(&data->mutex);
+	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
-
-	return ret;
+	kfree(data);
 }
 EXPORT_SYMBOL(cma3000_exit);
 
diff --git a/drivers/input/misc/cma3000_d0x.h b/drivers/input/misc/cma3000_d0x.h
index 107b5fa..4215047 100644
--- a/drivers/input/misc/cma3000_d0x.h
+++ b/drivers/input/misc/cma3000_d0x.h
@@ -21,33 +21,23 @@
 #ifndef _INPUT_CMA3000_H
 #define _INPUT_CMA3000_H
 
-#include <linux/i2c.h>
+#include <linux/types.h>
 #include <linux/input.h>
 
+struct device;
 struct cma3000_accl_data;
 
 struct cma3000_bus_ops {
 	u16 bustype;
-	int (*read) (struct cma3000_accl_data *, u8, char *);
-	int (*write) (struct cma3000_accl_data *, u8, u8, char *);
+	u8 ctrl_mod;
+	int (*read)(struct device *, u8, char *);
+	int (*write)(struct device *, u8, u8, char *);
 };
 
-struct cma3000_accl_data {
-#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
-	struct i2c_client *client;
-#endif
-	struct input_dev *input_dev;
-	struct cma3000_platform_data pdata;
-
-	/* mutex for sysfs operations */
-	struct mutex mutex;
-	const struct cma3000_bus_ops *bus_ops;
-	int bit_to_mg;
-};
-
-int cma3000_init(struct cma3000_accl_data *);
-int cma3000_exit(struct cma3000_accl_data *);
-int cma3000_poweron(struct cma3000_accl_data *);
-int cma3000_poweroff(struct cma3000_accl_data *);
+struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
+					const struct cma3000_bus_ops *bops);
+void cma3000_exit(struct cma3000_accl_data *);
+void cma3000_suspend(struct cma3000_accl_data *);
+void cma3000_resume(struct cma3000_accl_data *);
 
 #endif
diff --git a/drivers/input/misc/cma3000_d0x_i2c.c b/drivers/input/misc/cma3000_d0x_i2c.c
index f843478..cca194f 100644
--- a/drivers/input/misc/cma3000_d0x_i2c.c
+++ b/drivers/input/misc/cma3000_d0x_i2c.c
@@ -20,123 +20,124 @@
  */
 
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/input/cma3000.h>
 #include "cma3000_d0x.h"
 
-static int cma3000_set(struct cma3000_accl_data *accl, u8 reg, u8 val,
-			char *msg)
+static int cma3000_i2c_set(struct device *dev,
+			   u8 reg, u8 val, char *msg)
 {
-	int ret = i2c_smbus_write_byte_data(accl->client, reg, val);
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, val);
 	if (ret < 0)
-		dev_err(&accl->client->dev,
-			"i2c_smbus_write_byte_data failed (%s)\n", msg);
+		dev_err(&client->dev,
+			"%s failed (%s, %d)\n", __func__, msg, ret);
 	return ret;
 }
 
-static int cma3000_read(struct cma3000_accl_data *accl, u8 reg, char *msg)
+static int cma3000_i2c_read(struct device *dev, u8 reg, char *msg)
 {
-	int ret = i2c_smbus_read_byte_data(accl->client, reg);
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
 	if (ret < 0)
-		dev_err(&accl->client->dev,
-			"i2c_smbus_read_byte_data failed (%s)\n", msg);
+		dev_err(&client->dev,
+			"%s failed (%s, %d)\n", __func__, msg, ret);
 	return ret;
 }
 
 static const struct cma3000_bus_ops cma3000_i2c_bops = {
-	.bustype = BUS_I2C,
-	.read = cma3000_read,
-	.write = cma3000_set,
+	.bustype	= BUS_I2C,
+#define CMA3000_BUSI2C     (0 << 4)
+	.ctrl_mod	= CMA3000_BUSI2C,
+	.read		= cma3000_i2c_read,
+	.write		= cma3000_i2c_set,
 };
 
-static int __devinit cma3000_accl_probe(struct i2c_client *client,
+static int __devinit cma3000_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
-	int ret;
-	struct cma3000_accl_data *data = NULL;
+	struct cma3000_accl_data *data;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (data == NULL) {
-		ret = -ENOMEM;
-		goto err_op_failed;
-	}
+	data = cma3000_init(&client->dev, client->irq, &cma3000_i2c_bops);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
-	data->client = client;
 	i2c_set_clientdata(client, data);
-	data->bus_ops = &cma3000_i2c_bops;
-
-	ret = cma3000_init(data);
-	if (ret)
-		goto err_op_failed;
 
 	return 0;
-
-err_op_failed:
-
-	kfree(data);
-	return ret;
 }
 
-static int __devexit cma3000_accl_remove(struct i2c_client *client)
+static int __devexit cma3000_i2c_remove(struct i2c_client *client)
 {
 	struct cma3000_accl_data *data = i2c_get_clientdata(client);
-	int ret;
 
-	ret = cma3000_exit(data);
-	i2c_set_clientdata(client, NULL);
-	kfree(data);
+	cma3000_exit(data);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM
-static int cma3000_accl_suspend(struct i2c_client *client, pm_message_t mesg)
+static int cma3000_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct cma3000_accl_data *data = i2c_get_clientdata(client);
 
-	return cma3000_poweroff(data);
+	cma3000_suspend(data);
+
+	return 0;
 }
 
-static int cma3000_accl_resume(struct i2c_client *client)
+static int cma3000_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct cma3000_accl_data *data = i2c_get_clientdata(client);
 
-	return cma3000_poweron(data);
+	cma3000_resume(data);
+
+	return 0;
 }
+
+static const struct dev_pm_ops cma3000_i2c_pm_ops = {
+	.suspend	= cma3000_i2c_suspend,
+	.resume		= cma3000_i2c_resume,
+};
 #endif
 
-static const struct i2c_device_id cma3000_id[] = {
+static const struct i2c_device_id cma3000_i2c_id[] = {
 	{ "cma3000_d01", 0 },
 	{ },
 };
 
-static struct i2c_driver cma3000_accl_driver = {
-	.probe		= cma3000_accl_probe,
-	.remove		= cma3000_accl_remove,
-	.id_table	= cma3000_id,
+static struct i2c_driver cma3000_i2c_driver = {
+	.probe		= cma3000_i2c_probe,
+	.remove		= __devexit_p(cma3000_i2c_remove),
+	.id_table	= cma3000_i2c_id,
+	.driver = {
+		.name	= "cma3000_i2c_accl",
+		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
-	.suspend	= cma3000_accl_suspend,
-	.resume		= cma3000_accl_resume,
+		.pm	= &cma3000_i2c_pm_ops,
 #endif
-	.driver = {
-		.name = "cma3000_accl"
 	},
 };
 
-static int __init cma3000_accl_init(void)
+static int __init cma3000_i2c_init(void)
 {
-	return i2c_add_driver(&cma3000_accl_driver);
+	return i2c_add_driver(&cma3000_i2c_driver);
 }
 
-static void __exit cma3000_accl_exit(void)
+static void __exit cma3000_i2c_exit(void)
 {
-	i2c_del_driver(&cma3000_accl_driver);
+	i2c_del_driver(&cma3000_i2c_driver);
 }
 
-module_init(cma3000_accl_init);
-module_exit(cma3000_accl_exit);
+module_init(cma3000_i2c_init);
+module_exit(cma3000_i2c_exit);
 
-MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
+MODULE_DESCRIPTION("CMA3000-D0x Accelerometer I2C Driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
diff --git a/include/linux/input/cma3000.h b/include/linux/input/cma3000.h
index fcddece..085e62a 100644
--- a/include/linux/input/cma3000.h
+++ b/include/linux/input/cma3000.h
@@ -50,11 +50,11 @@ struct cma3000_platform_data {
 	int fuzz_y;
 	int fuzz_z;
 	int g_range;
-	uint8_t  mode;
-	uint8_t  mdthr;
-	uint8_t  mdfftmr;
-	uint8_t  ffthr;
-	uint32_t  irqflags;
+	uint8_t mode;
+	uint8_t mdthr;
+	uint8_t mdfftmr;
+	uint8_t ffthr;
+	unsigned long irqflags;
 };
 
 #endif
