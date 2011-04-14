Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1DNOoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:44:05 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55963 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758945Ab1DNOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:44:03 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: "wanlong.gao@gmail.com" <wanlong.gao@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 14 Apr 2011 07:41:17 -0700
Subject: RE: [PATCH 01/13] input: touchscreen: use polling mode in 88pm860x
Thread-Topic: [PATCH 01/13] input: touchscreen: use polling mode in 88pm860x
Thread-Index: Acv6rJVDRqzzC46QQfCTzP4OlXfWZwABNt2Q
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05AC12@SC-VEXCH1.marvell.com>
References: <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
	<1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
 <BANLkTi=vuY61=X6okw8udWZZ=uQwCAPgjA@mail.gmail.com>
In-Reply-To: <BANLkTi=vuY61=X6okw8udWZZ=uQwCAPgjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3EEiIpf019850



>-----Original Message-----
>From: gaowanlong@gmail.com [mailto:gaowanlong@gmail.com] On Behalf Of
>Wanlong Gao
>Sent: 2011Äê4ÔÂ14ÈÕ 10:02 PM
>To: Haojian Zhuang
>Cc: sameo@linux.intel.com; haojian.zhuang@gmail.com; linux-
>kernel@vger.kernel.org; Dmitry Torokhov
>Subject: Re: [PATCH 01/13] input: touchscreen: use polling mode in
>88pm860x
>
>On 4/13/11, Haojian Zhuang <haojian.zhuang@marvell.com> wrote:
>> Measuring point on touchscreen with IRQ mode can only monitor pen-down
>> event. If finger is moving on touchscreen, it can't be monitored by
>> IRQ pen-down event. So switch to polling mode after pen-down event.
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> ---
>>  drivers/input/touchscreen/88pm860x-ts.c |   82
>> +++++++++++++++++++++++-------
>>  1 files changed, 63 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/88pm860x-ts.c
>> b/drivers/input/touchscreen/88pm860x-ts.c
>> index b3aebc2..fe12f61 100644
>> --- a/drivers/input/touchscreen/88pm860x-ts.c
>> +++ b/drivers/input/touchscreen/88pm860x-ts.c
>> @@ -12,13 +12,25 @@
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/i2c.h>
>> +#include <linux/slab.h>
>>  #include <linux/input.h>
>>  #include <linux/mfd/88pm860x.h>
>> -#include <linux/slab.h>
>>
>>  #define MEAS_LEN		(8)
>>  #define ACCURATE_BIT		(12)
>>
>> +/*
>> + * While 32KHz hardware timer is used for scheduler, we always assign
>HZ
>> + * to 128. It means that 1 tick costs 7.8msec.
>> + */
>> +#define MEASURE_INTERVAL_MS	(7)
>> +
>> +/* debounce register */
>> +#define DEBOUNCE		(0x0A)
>> +
>> +#define PD_DEBOUNCE_0MSEC	(0)
>> +#define PD_DEBOUNCE_MASK	(3)
>> +
>>  /* touch register */
>>  #define MEAS_EN3		(0x52)
>>
>> @@ -39,22 +51,27 @@
>>  #define MEAS_TSIZ2_EN		(1 << 7)
>>
>>  struct pm860x_touch {
>> -	struct input_dev *idev;
>> -	struct i2c_client *i2c;
>> -	struct pm860x_chip *chip;
>> -	int irq;
>> -	int res_x;		/* resistor of Xplate */
>> +	struct input_dev	*idev;
>> +	struct i2c_client	*i2c;
>> +	struct pm860x_chip	*chip;
>> +	struct delayed_work	poll_work;
>> +	struct mutex		lock;
>> +
>> +	int			irq;
>> +	int			res_x;		/* resistor of Xplate */
>>  };
>>
>> -static irqreturn_t pm860x_touch_handler(int irq, void *data)
>> +static void pm860x_poll_work(struct work_struct *work)
>>  {
>> -	struct pm860x_touch *touch = data;
>> +	struct pm860x_touch *touch = container_of(work, struct
>pm860x_touch,
>> +						  poll_work.work);
>>  	struct pm860x_chip *chip = touch->chip;
>> +	int x, y, z1, z2, rt = 0;
>> +	int ret, pen_down, interval;
>>  	unsigned char buf[MEAS_LEN];
>> -	int x, y, pen_down;
>> -	int z1, z2, rt = 0;
>> -	int ret;
>> +	struct timeval start, end;
>>
>> +	do_gettimeofday(&start);
>>  	ret = pm860x_bulk_read(touch->i2c, MEAS_TSIX_1, MEAS_LEN, buf);
>>  	if (ret < 0)
>>  		goto out;
>> @@ -77,30 +94,54 @@ static irqreturn_t pm860x_touch_handler(int irq,
>void
>> *data)
>>  		input_report_abs(touch->idev, ABS_PRESSURE, rt);
>>  		input_report_key(touch->idev, BTN_TOUCH, 1);
>>  		dev_dbg(chip->dev, "pen down at [%d, %d].\n", x, y);
>> +
>> +		do_gettimeofday(&end);
>> +		interval = (end.tv_sec - start.tv_sec) * 1000000 +
>> +			(end.tv_usec - start.tv_usec) / 1000;
>Is the interval you calibrated right ?

Good catch. I'll fix it.

>> +		interval = (interval < MEASURE_INTERVAL_MS)
>> +			? (MEASURE_INTERVAL_MS - interval) : 0;
>> +		schedule_delayed_work(&touch->poll_work,
>> +				      msecs_to_jiffies(interval));
>>  	} else {
>>  		input_report_abs(touch->idev, ABS_PRESSURE, 0);
>>  		input_report_key(touch->idev, BTN_TOUCH, 0);
>>  		dev_dbg(chip->dev, "pen release\n");
>> +		mutex_unlock(&touch->lock);
>>  	}
>>  	input_sync(touch->idev);
>>
>>  out:
>> +	return;
>> +}
>> +
>> +static irqreturn_t pm860x_touch_handler(int irq, void *data)
>> +{
>> +	struct pm860x_touch *touch = data;
>> +	int ret;
>> +
>> +	ret = pm860x_reg_read(touch->i2c, PM8607_STATUS_1);
>> +	dev_dbg(touch->chip->dev, "pen status:%d\n", (ret &
>PM8607_STATUS_PEN)
>> +		? 1 : 0);
>> +	if ((ret & PM8607_STATUS_PEN) == 0)
>prefer to  !(ret & PM8607_STATUS_PEN) ?
>> +		return IRQ_HANDLED;
>> +
>> +	mutex_lock(&touch->lock);
>> +	pm860x_poll_work(&touch->poll_work.work);
>>  	return IRQ_HANDLED;
>>  }
>>
>>  static int pm860x_touch_open(struct input_dev *dev)
>>  {
>>  	struct pm860x_touch *touch = input_get_drvdata(dev);
>> -	int data, ret;
>> +	int data;
>>
>> +	/* set debounce time with 0ms */
>> +	pm860x_set_bits(touch->i2c, DEBOUNCE, PD_DEBOUNCE_MASK,
>> +			PD_DEBOUNCE_0MSEC);
>>  	data = MEAS_PD_EN | MEAS_TSIX_EN | MEAS_TSIY_EN
>>  		| MEAS_TSIZ1_EN | MEAS_TSIZ2_EN;
>> -	ret = pm860x_set_bits(touch->i2c, MEAS_EN3, data, data);
>> -	if (ret < 0)
>> -		goto out;
>> +	pm860x_set_bits(touch->i2c, MEAS_EN3, data, data);
>Why not check the return value now ?

Seems checking is better in open(). I'll fix it.

>>  	return 0;
>> -out:
>> -	return ret;
>>  }
>>
>>  static void pm860x_touch_close(struct input_dev *dev)
>> @@ -152,16 +193,17 @@ static int __devinit pm860x_touch_probe(struct
>> platform_device *pdev)
>>  	}
>>
>>  	touch->idev->name = "88pm860x-touch";
>> -	touch->idev->phys = "88pm860x/input0";
>> +	touch->idev->phys = "88pm860x/input1";
>>  	touch->idev->id.bustype = BUS_I2C;
>>  	touch->idev->dev.parent = &pdev->dev;
>>  	touch->idev->open = pm860x_touch_open;
>>  	touch->idev->close = pm860x_touch_close;
>>  	touch->chip = chip;
>>  	touch->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip-
>>companion;
>> -	touch->irq = irq + chip->irq_base;
>> +	touch->irq = irq;
>>  	touch->res_x = pdata->res_x;
>>  	input_set_drvdata(touch->idev, touch);
>> +	mutex_init(&touch->lock);
>>
>>  	ret = request_threaded_irq(touch->irq, NULL, pm860x_touch_handler,
>>  				   IRQF_ONESHOT, "touch", touch);
>> @@ -188,6 +230,7 @@ static int __devinit pm860x_touch_probe(struct
>> platform_device *pdev)
>>  	}
>>
>>  	platform_set_drvdata(pdev, touch);
>> +	INIT_DELAYED_WORK(&touch->poll_work, pm860x_poll_work);
>>  	return 0;
>>  out_rg:
>>  	free_irq(touch->irq, touch);
>> @@ -202,6 +245,7 @@ static int __devexit pm860x_touch_remove(struct
>> platform_device *pdev)
>>  {
>>  	struct pm860x_touch *touch = platform_get_drvdata(pdev);
>>
>> +	flush_scheduled_work();
>>  	input_unregister_device(touch->idev);
>>  	free_irq(touch->irq, touch);
>>  	platform_set_drvdata(pdev, NULL);
>> --
>> 1.5.6.5
>>
>Best regards
>Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-
>kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
