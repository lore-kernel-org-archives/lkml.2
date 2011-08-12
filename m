Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1HLH05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:26:57 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:48724 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1HLH04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:26:56 -0400
Date: Fri, 12 Aug 2011 00:26:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: ashish.jangam@kpitcummins.com, randy.dunlap@oracle.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] da9052_tsi: remove fifo and use delayed work
Message-ID: <20110812072649.GA25911@core.coreip.homeip.net>
References: <1310633890.284.90.camel@L-0532.kpit.com>
 <1312898372-24575-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312898372-24575-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Aug 09, 2011 at 03:59:32PM +0200, Michael Grzeschik wrote:
> Remove the coordinate fifo and check for penup with a delayed work,
> instead of a watching kernel thread.
> 

Yes, this looks much better. A few comments below.

> Issues:
> Sometimes there are well defined jitter values on the x-axys this must
> be more investigated. Hint: DA9052_TSI_CONT_A_REG holds some time Adjust
> values for TSI_SKIP and TSI_DELAY, which might have to be properly
> aligned to the touch events.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/input/touchscreen/da9052_tsi.c |  245 ++++++++------------------------
>  1 files changed, 61 insertions(+), 184 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
> index 91e051a..91d489f 100755
> --- a/drivers/input/touchscreen/da9052_tsi.c
> +++ b/drivers/input/touchscreen/da9052_tsi.c
> @@ -15,47 +15,24 @@
>  #include <linux/input.h>
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
> -#include <linux/freezer.h>
> +#include <linux/sched.h>
>  #include <linux/kthread.h>

That can be dropped too I think.

> -#include <linux/kfifo.h>
>  
>  #include <linux/mfd/da9052/reg.h>
>  #include <linux/mfd/da9052/da9052.h>
>  
> -#define DA9052_ACTIVE			1
> -#define DA9052_INACTIVE		0
> -
> -#define DA9052_TSI_FIFOSIZE		640
> -
> -enum {
> -	DA9052_PEN_IDLE,
> -	DA9052_PEN_DOWN,
> -	DA9052_PEN_UP
> -};
> -
>  struct da9052_tsi_reg {
>  	u16	x;
>  	u16	y;
>  };
>  
> -struct tsi_thread_type {
> -	u8		pid;
> -	u8		state;
> -	struct completion	notifier;
> -	struct task_struct	*thread_task;
> -};
> -
>  struct da9052_tsi {
>  	struct da9052	*da9052;
>  	struct input_dev *dev;
> -	struct tsi_thread_type	tsi_pen_state_thread;
> -	struct tsi_thread_type  tsi_filter_thread;
> -	struct kfifo fifo;
> -	struct kfifo fifo_buf;
>  	u8 pen_up_detect_interval;
>  	u32 zero_data_cnt;
>  	u32 valid_penup_count;

Above 2 are not used.

> -	u8 pen_state;
> +	struct delayed_work work;
>  	int irq_pendwn;
>  	int irq_datardy;
>  };
> @@ -71,6 +48,48 @@ static inline int da9052_ts_stop(struct da9052_tsi *tsi)
>  	return da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
>  }
>  
> +static void da9052_work(struct work_struct *work)
> +{
> +	struct da9052_tsi *tsi = container_of(work, struct da9052_tsi, work.work);
> +	struct da9052 *da9052 = tsi->da9052;
> +	int ret;
> +	uint8_t _v;
> +	u16 down;
> +
> +	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
> +	if (ret < 0)
> +		return;
> +
> +	_v = (uint8_t) ret;
> +	down = ((_v & 0x40) >> 6);
> +
> +	if (!down) {
> +		tsi->da9052->events_mask |= DA9052_E_TSI_READY;
> +		tsi->da9052->events_mask &= ~DA9052_E_PEN_DOWN;
> +
> +		/* Mask TSI_READY event and unmask PEN_DOWN event*/
> +		ret = da9052_reg_update(tsi->da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
> +		if (ret < 0)
> +			return;

There is no good way to handle da9052_reg_update() failure so don't.

> +
> +		input_report_abs(tsi->dev, ABS_PRESSURE, 0);

No fake pressure events please.

> +		input_report_key(tsi->dev, BTN_TOUCH, 1);
> +		input_sync(tsi->dev);
> +	} else {
> +		da9052->events_mask |= DA9052_E_PEN_DOWN;
> +		da9052->events_mask &= ~DA9052_E_TSI_READY;
> +
> +		/* Mask PEN_DOWN event and unmask TSI_READY event*/
> +		ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
> +		if (ret < 0)
> +			return;

Why do we need to do the masking again? Just re-schedule the work.

> +
> +		/* start polling for touch_det to detect release */
> +		schedule_delayed_work(&tsi->work, HZ / 50);
> +	}
> +
> +}
> +
>  static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
>  {
>  	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
> @@ -86,7 +105,10 @@ static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
>  		return IRQ_NONE;
>  
>  	da9052_ts_start(tsi);
> -	tsi->pen_state = DA9052_PEN_DOWN;
> +
> +	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
> +	input_report_key(tsi->dev, BTN_TOUCH, 0);
> +	input_sync(tsi->dev);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -118,7 +140,10 @@ static int da9052_ts_read(struct da9052_tsi *tsi)
>  	co_ord.x = ((_x << 2) & 0x3fc) | (_v & 0x3);
>  	co_ord.y = ((_y << 2) & 0x3fc) | ((_v & 0xc) >> 2);
>  
> -	ret = kfifo_in(&tsi->fifo, &co_ord, sizeof(struct da9052_tsi_reg));
> +	input_report_abs(tsi->dev, ABS_X, co_ord.x);
> +	input_report_abs(tsi->dev, ABS_Y, co_ord.y);
> +	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
> +	input_sync(tsi->dev);
>  
>  	return 0;
>  }
> @@ -135,131 +160,10 @@ static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
>  		return IRQ_NONE;
>  	}
>  

[skip[

> +	/* start polling for touch_det to detect release */
> +	schedule_delayed_work(&tsi->work, HZ / 50);
>  

What if da9052_ts_datardy_irq() never comes? You should schedule from
pendown IRQ handler.

> -	return 0;
> +	return IRQ_HANDLED;
>  }
>  

...

> -
> +	cancel_delayed_work(&tsi->work);

cancel_delayed_work_sync()

There are a few other changes in the patch below, however I can't
compile it since the rest of the MFD code is not in mainline nor in
linux-next.

Thanks.

-- 
Dmitry


Input: da9052 - misc fixes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/da9052_tsi.c |  210 +++++++++++++++-----------------
 1 files changed, 96 insertions(+), 114 deletions(-)


diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index 0445d88..095999e 100644
--- a/drivers/input/touchscreen/da9052_tsi.c
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -15,7 +15,6 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
-#include <linux/kthread.h>
 
 #include <linux/mfd/da9052/reg.h>
 #include <linux/mfd/da9052/da9052.h>
@@ -26,23 +25,20 @@ struct da9052_tsi_reg {
 };
 
 struct da9052_tsi {
-	struct da9052	*da9052;
+	struct da9052 *da9052;
 	struct input_dev *dev;
-	u8 pen_up_detect_interval;
-	u32 zero_data_cnt;
-	u32 valid_penup_count;
 	struct delayed_work work;
 	int irq_pendwn;
 	int irq_datardy;
 };
 
-static inline int da9052_ts_start(struct da9052_tsi *tsi)
+static int da9052_ts_start(struct da9052_tsi *tsi)
 {
 	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
 				 1 << 0, 1 << 0);
 }
 
-static inline int da9052_ts_stop(struct da9052_tsi *tsi)
+static int da9052_ts_stop(struct da9052_tsi *tsi)
 {
 	return da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
 }
@@ -63,51 +59,43 @@ static void da9052_work(struct work_struct *work)
 	down = ((_v & 0x40) >> 6);
 
 	if (!down) {
+		input_report_key(tsi->dev, BTN_TOUCH, 0);
+		input_sync(tsi->dev);
+
+		da9052_ts_stop(tsi);
+
 		tsi->da9052->events_mask |= DA9052_E_TSI_READY;
 		tsi->da9052->events_mask &= ~DA9052_E_PEN_DOWN;
 
 		/* Mask TSI_READY event and unmask PEN_DOWN event*/
-		ret = da9052_reg_update(tsi->da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
-		if (ret < 0)
-			return;
-
-		input_report_abs(tsi->dev, ABS_PRESSURE, 0);
-		input_report_key(tsi->dev, BTN_TOUCH, 1);
-		input_sync(tsi->dev);
+		da9052_reg_update(tsi->da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0x80);
 	} else {
-		da9052->events_mask |= DA9052_E_PEN_DOWN;
-		da9052->events_mask &= ~DA9052_E_TSI_READY;
-
-		/* Mask PEN_DOWN event and unmask TSI_READY event*/
-		ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
-		if (ret < 0)
-			return;
-
-		/* start polling for touch_det to detect release */
+		/* keep polling to detect release */
 		schedule_delayed_work(&tsi->work, HZ / 50);
 	}
-
 }
 
 static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
 {
-	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
+	struct da9052_tsi *tsi = data;
 	struct da9052 *da9052 = tsi->da9052;
 	int ret;
 
+	input_report_key(tsi->dev, BTN_TOUCH, 1);
+	input_sync(tsi->dev);
+
 	da9052->events_mask |= DA9052_E_PEN_DOWN;
 	da9052->events_mask &= ~DA9052_E_TSI_READY;
 
-	/* Mask PEN_DOWN event and unmask TSI_READY event*/
+	/* Mask PEN_DOWN event and unmask TSI_READY event */
 	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
 	if (ret < 0)
 		return IRQ_NONE;
 
 	da9052_ts_start(tsi);
 
-	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
-	input_report_key(tsi->dev, BTN_TOUCH, 0);
-	input_sync(tsi->dev);
+	/* start polling for touch_det to detect release */
+	schedule_delayed_work(&tsi->work, HZ / 50);
 
 	return IRQ_HANDLED;
 }
@@ -141,7 +129,6 @@ static int da9052_ts_read(struct da9052_tsi *tsi)
 
 	input_report_abs(tsi->dev, ABS_X, co_ord.x);
 	input_report_abs(tsi->dev, ABS_Y, co_ord.y);
-	input_report_abs(tsi->dev, ABS_PRESSURE, 1023);
 	input_sync(tsi->dev);
 
 	return 0;
@@ -149,23 +136,20 @@ static int da9052_ts_read(struct da9052_tsi *tsi)
 
 static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
 {
-	struct da9052_tsi *tsi = (struct da9052_tsi *)data;
-	int ret;
+	struct da9052_tsi *tsi = data;
+	int error;
 
-	ret = da9052_ts_read(tsi);
-	if (ret) {
+	error = da9052_ts_read(tsi);
+	if (error) {
 		dev_err(tsi->da9052->dev,
-			"Failed to read TSI co-ordinate, %d\n", ret);
+			"Failed to read TSI co-ordinate, error: %d\n", error);
 		return IRQ_NONE;
 	}
 
-	/* start polling for touch_det to detect release */
-	schedule_delayed_work(&tsi->work, HZ / 50);
-
 	return IRQ_HANDLED;
 }
 
-static int da9052_ts_configure_gpio(struct da9052 *da9052)
+static int __devinit da9052_ts_configure_gpio(struct da9052 *da9052)
 {
 	int ret;
 
@@ -181,26 +165,22 @@ static int da9052_ts_configure_gpio(struct da9052 *da9052)
 	if (ret < 0)
 		return -EIO;
 
-	return ret;
+	return 0;
 }
 
-static int __init da9052_ts_enable_device(struct da9052_tsi *tsi)
+static int __devinit da9052_ts_enable_device(struct da9052_tsi *tsi)
 {
-	ssize_t ret;
 	struct da9052 *da9052 = tsi->da9052;
+	int error;
 
-	ret = da9052_ts_configure_gpio(tsi->da9052);
-	if (ret < 0)
-		return ret;
+	error = da9052_ts_configure_gpio(tsi->da9052);
+	if (error)
+		return error;
 
 	ret = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 0xFC, 0xC0);
 	if (ret < 0)
 		return ret;
 
-	tsi->valid_penup_count = 5;
-
-	tsi->zero_data_cnt = 0;
-
 	/* Measure TSI sample every 1ms */
 	ret = da9052_reg_update(tsi->da9052, DA9052_ADC_CONT_REG,
 				1 << 6, 1 << 6);
@@ -220,43 +200,49 @@ static int __init da9052_ts_enable_device(struct da9052_tsi *tsi)
 	if (ret < 0)
 		return ret;
 
-	/*Supply TSIRef thru LD09 */
+	/* Supply TSIRef thru LD09 */
 	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x59);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	return 0;
 }
 
-static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
+static int __devinit da9052_ts_probe(struct platform_device *pdev)
 {
+	struct da9052 *da9052 = platform_get_drvdata(pdev->dev.parent);
 	struct da9052_tsi *tsi;
 	struct input_dev *input_dev;
-	struct da9052 *da9052;
-	int ret;
-
-	da9052 = dev_get_drvdata(pdev->dev.parent);
+	int irq_pendown, irq_datardy;
+	int error;
+
+	irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
+	irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
+	if (irq_pendown < 0 || irq_datardy < 0) {
+		dev_err(da9052->dev, "Unable to determine device interrupts\n");
+		return -ENXIO;
+	}
 
 	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
-	if (!tsi)
-		return -ENOMEM;
-
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		dev_err(tsi->da9052->dev,
-			"failed to allocate input device\n");
+	if (!tsi || !input_dev) {
+		dev_err(da9052->dev, "failed to allocate memory\n");
 		ret = -ENOMEM;
-		goto err_mem;
+		goto err_free_mem;
 	}
 
 	tsi->da9052 = da9052;
-	tsi->pen_up_detect_interval = 5;
-	platform_set_drvdata(pdev, tsi);
+	tsi->dev = input_dev;
+	tsi->irq_pendown = irq_pendwn;
+	tsi->irq_datadry = irq_datardy;
+	INIT_DELAYED_WORK(&tsi->work, da9052_work);
 
+	input_dev->name = "Dialog DA9052 TouchScreen Driver";
 	input_dev->id.version = 0x0101;
 	input_dev->id.vendor = 0x15B6;
 	input_dev->id.product = 0x9052;
 	input_dev->id.bustype = BUS_RS232;
-	input_dev->name = "Dialog DA9052 TouchScreen Driver";
-	input_dev->dev.parent	= &pdev->dev;
+	input_dev->dev.parent = &pdev->dev;
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
@@ -265,85 +251,81 @@ static s32 __devinit da9052_ts_probe(struct platform_device *pdev)
 
 	input_set_abs_params(input_dev, ABS_X, 0, 1023, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, 1023, 0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 1023, 0, 0);
 
-	tsi->dev = input_dev;
 	input_set_drvdata(input_dev, tsi);
-	ret = input_register_device(tsi->dev);
-	if (ret)
-		goto err_mem;
 
-	INIT_DELAYED_WORK(&tsi->work, da9052_work);
-
-	tsi->irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
-	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
-				NULL, da9052_ts_pendwn_irq,
-				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				"PENDWN", tsi);
-	if (ret < 0) {
-		dev_err(tsi->da9052->dev,
+	error = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
+				     NULL, da9052_ts_pendwn_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "PENDWN", tsi);
+	if (error) {
+		dev_err(da9052->dev,
 			"Failed to register %s IRQ %d, error = %d\n", "PENDWN",
-			tsi->da9052->irq_base + tsi->irq_pendwn, ret);
+			tsi->da9052->irq_base + tsi->irq_pendwn, error);
 		goto err_input;
 	}
 
-	tsi->irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
-	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_datardy,
-				NULL, da9052_ts_datardy_irq,
-				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				"TSIRDY", tsi);
-	if (ret < 0) {
-		dev_err(tsi->da9052->dev,
+	error = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_datardy,
+				     NULL, da9052_ts_datardy_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "TSIRDY", tsi);
+	if (error) {
+		dev_err(da9052->dev,
 			"Failed to register %s IRQ %d, error = %d\n", "TSIRDY",
-			tsi->da9052->irq_base + tsi->irq_datardy, ret);
-		goto err_input;
+			tsi->da9052->irq_base + tsi->irq_datardy, error);
+		goto err_free_pendown;
 	}
 
-	ret = da9052_ts_enable_device(tsi);
-	if (ret < 0)
-		goto err_input;
+	error = da9052_ts_enable_device(tsi);
+	if (error) {
+		dev_err(da9052->dev,
+			"Failed to enable device, error: %d\n", error);
+		goto err_free_datardy;
+	}
 
+	error = input_register_device(tsi->dev);
+	if (error)
+		goto err_free_datardy;
+
+	platform_set_drvdata(pdev, tsi);
 	return 0;
 
-err_input:
+err_free_pendown:
+	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, tsi);
+err_free_datardy:
+	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, tsi);
+err_free_mem:
 	input_free_device(input_dev);
-err_mem:
 	kfree(tsi);
-	return ret;
+	return error;
 }
 
 static int __devexit da9052_ts_remove(struct platform_device *pdev)
 {
 	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
-	s32 ret;
 
-	ret = da9052_clear_bits(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0);
-	if (ret < 0)
-		return ret;
+	da9052_ts_stop(tsi);
+	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
 
-	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
-	if (ret < 0)
-		return ret;
+	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, tsi);
+	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, tsi);
 
-	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, NULL);
-	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, NULL);
+	cancel_delayed_work_sync(&tsi->work);
 
-	cancel_delayed_work(&tsi->work);
 	input_unregister_device(tsi->dev);
+	kfree(tsi);
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(tsi);
-
 	return 0;
 }
 
 static struct platform_driver da9052_tsi_driver = {
-	.probe = da9052_ts_probe,
-	.remove = __devexit_p(da9052_ts_remove),
-	.driver = {
-		.name = "da9052-tsi",
-		.owner = THIS_MODULE,
+	.probe	= da9052_ts_probe,
+	.remove	= __devexit_p(da9052_ts_remove),
+	.driver	= {
+		.name	= "da9052-tsi",
+		.owner	= THIS_MODULE,
 	},
 };
 
