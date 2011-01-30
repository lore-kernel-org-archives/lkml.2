Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1A3TMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:12:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56764 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1A3TMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aSrq1ztWXJkGVulCVb8F/xaMekmUUkgzUPNc3SflpXURE6R2utNnQDoftrvtBTz475
         LOcIrJ6lRD//e048pONIJ/06Z0snaz+bbT2zAFqJ/lMo7Dp8fOQHrU93CVgB8Lrb+o0p
         ubydJ+wHVwmd9e+cmETggeHvlO4fcxO9Vztgo=
MIME-Version: 1.0
In-Reply-To: <20110130182540.GA12801@pengutronix.de>
References: <AANLkTimHqDGtY3rTzB_xr9f_-pd7Sf084G8vOGghdKhh@mail.gmail.com>
	<20110130182540.GA12801@pengutronix.de>
Date: Sun, 30 Jan 2011 20:12:10 +0100
Message-ID: <AANLkTi=UYOeNXtL9ZhyVESBvWQwMEdbVUAOMqp4aV4_H@mail.gmail.com>
Subject: Re: [leds-pca9532] Add gpio capability
From: Joachim Eastwood <manabian@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 1/30/11, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi,
>
>> Since it is a bug to call get/set value on unrequested gpio's the
>> check for PCA9532_TYPE_GPIO could be removed from
>> pca9532_gpio_get_value/pca9532_gpio_set_value functions. But I have
>> kept it for this posting.
>
> If you keep it, you could print a warning maybe. Or just remove the check.

I'll think I will remove the check.

>
>> -------------------------------------------------------------------
>>     [leds-pca9532] Add gpio capability
>>
>>     Pins not used for leds can now be used as gpio by setting pin type as
>>     PCA9532_TYPE_GPIO and defining a gpio_base in platform data.
>>
>>     Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
>
> Some Kconfig-magic is missing. Iff that feature is used, then it depends on
> GENERIC_GPIO.

I though about it just when I had hit send. I'll create an updated
version where gpio capability is optional.

GENERIC_GPIO? Shouldn't it be GPIOLIB in this case?

>
>>
>> diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
>> index afac338..b036fa5 100644
>> --- a/drivers/leds/leds-pca9532.c
>> +++ b/drivers/leds/leds-pca9532.c
>> @@ -19,7 +19,9 @@
>>  #include <linux/mutex.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/leds-pca9532.h>
>> +#include <linux/gpio.h>
>>
>> +#define PCA9532_REG_INPUT(i) ((i)/8)
>>  #define PCA9532_REG_PSC(i) (0x2+(i)*2)
>>  #define PCA9532_REG_PWM(i) (0x3+(i)*2)
>>  #define PCA9532_REG_LS0  0x6
>> @@ -34,6 +36,7 @@ struct pca9532_data {
>>  	struct mutex update_lock;
>>  	struct input_dev *idev;
>>  	struct work_struct work;
>> +	struct gpio_chip gpio;
>>  	u8 pwm[2];
>>  	u8 psc[2];
>>  };
>> @@ -200,16 +203,58 @@ static void pca9532_led_work(struct work_struct
>> *work)
>>  	pca9532_setled(led);
>>  }
>>
>> -static void pca9532_destroy_devices(struct pca9532_data *data, int
>> n_devs)
>> +static int pca9532_gpio_request_pin(struct gpio_chip *gc, unsigned off)
>
> Nitpick: maybe 'offset' as variable name? I first thought 'off' was a
> description of the state.

Yes, I guess 'offset' would be better. This seems to used in other
gpio drivers as well.

>>  {
>> -	int i = n_devs;
>> +	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
>> +	struct pca9532_led *led = &data->leds[off];
>> +
>> +	if (led->type == PCA9532_TYPE_GPIO)
>> +		return 0;
>> +
>> +	return -EINVAL;
>
> -EBUSY? The value is valid, just the pin is used already.

Agreed.

>> +}
>> +
>> +static void pca9532_gpio_set_value(struct gpio_chip *gc, unsigned off,
>> int val)
>> +{
>> +	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
>> +	struct pca9532_led *led = &data->leds[off];
>> +
>> +	if (led->type == PCA9532_TYPE_GPIO) {
>> +		if (val)
>> +			led->state = PCA9532_ON;
>> +		else
>> +			led->state = PCA9532_OFF;
>> +
>> +		pca9532_setled(led);
>> +	}
>> +}
>> +
>> +static int pca9532_gpio_get_value(struct gpio_chip *gc, unsigned off)
>> +{
>> +	struct pca9532_data *data = container_of(gc, struct pca9532_data, gpio);
>> +	struct pca9532_led *led = &data->leds[off];
>> +	unsigned char reg;
>> +
>> +	if (led->type == PCA9532_TYPE_GPIO) {
>> +		reg = i2c_smbus_read_byte_data(data->client,
>> +						PCA9532_REG_INPUT(off));
>> +		return !!(reg & (1<<(off % 8)));
>
> Spaces around operators.

Will fix.

>> +	}
>> +
>> +	return -1;
>
> According to gpio.txt, you should return 0 here (there are no errorcodes).

I will remove the check for PCA9532_TYPE_GPIO so this will go away.

>> +}
>> +
>> +static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
>> +{
>> +	int err, i = n_devs;
>>
>>  	if (!data)
>> -		return;
>> +		return -EINVAL;
>>
>>  	while (--i >= 0) {
>>  		switch (data->leds[i].type) {
>>  		case PCA9532_TYPE_NONE:
>> +		case PCA9532_TYPE_GPIO:
>>  			break;
>>  		case PCA9532_TYPE_LED:
>>  			led_classdev_unregister(&data->leds[i].ldev);
>> @@ -224,12 +269,24 @@ static void pca9532_destroy_devices(struct
>> pca9532_data *data, int n_devs)
>>  			break;
>>  		}
>>  	}
>> +
>> +	if (data->gpio.dev) {
>> +		err = gpiochip_remove(&data->gpio);
>> +		if (err) {
>> +			dev_err(&data->client->dev, "%s failed, %d\n",
>> +						"gpiochip_remove()", err);
>> +			return err;
>> +		}
>> +	}
>> +
>> +	return 0;
>>  }
>>
>>  static int pca9532_configure(struct i2c_client *client,
>>  	struct pca9532_data *data, struct pca9532_platform_data *pdata)
>>  {
>>  	int i, err = 0;
>> +	int gpios = 0;
>>
>>  	for (i = 0; i < 2; i++)	{
>>  		data->pwm[i] = pdata->pwm[i];
>> @@ -249,6 +306,9 @@ static int pca9532_configure(struct i2c_client
>> *client,
>>  		switch (led->type) {
>>  		case PCA9532_TYPE_NONE:
>>  			break;
>> +		case PCA9532_TYPE_GPIO:
>> +			gpios++;
>> +			break;
>>  		case PCA9532_TYPE_LED:
>>  			led->state = pled->state;
>>  			led->name = pled->name;
>> @@ -297,6 +357,30 @@ static int pca9532_configure(struct i2c_client
>> *client,
>>  			break;
>>  		}
>>  	}
>> +
>> +	if (gpios) {
>> +		data->gpio.label = "gpio-pca9532";
>> +		data->gpio.set = pca9532_gpio_set_value;
>> +		data->gpio.get = pca9532_gpio_get_value;
>> +		data->gpio.request = pca9532_gpio_request_pin;
>> +		data->gpio.can_sleep = 1;
>> +		data->gpio.base = pdata->gpio_base;
>> +		data->gpio.ngpio = 16;
>> +		data->gpio.dev = &client->dev;
>> +		data->gpio.owner = THIS_MODULE;
>
> I'd assume that you also need to define a direction_output-function which
> always
> returns success?

Yes, you are right. It is not possible to set direction in hw, but I
should provide them.

>> +
>> +		err = gpiochip_add(&data->gpio);
>> +		if (err) {
>> +			/* Use data->gpio.dev as a flag for freeing gpiochip */
>> +			data->gpio.dev = NULL;
>> +			dev_info(&client->dev, "could not add gpiochip\n");
>
> dev_warning?

Yes, that is better.

>> +		} else {
>> +			dev_info(&client->dev, "gpios %i...%i\n",
>> +				data->gpio.base, data->gpio.base +
>> +				data->gpio.ngpio - 1);
>> +		}
>> +	}
>> +
>>  	return 0;
>>
>>  exit:
>> @@ -337,7 +421,12 @@ static int pca9532_probe(struct i2c_client *client,
>>  static int pca9532_remove(struct i2c_client *client)
>>  {
>>  	struct pca9532_data *data = i2c_get_clientdata(client);
>> -	pca9532_destroy_devices(data, 16);
>> +	int err;
>> +
>> +	err = pca9532_destroy_devices(data, 16);
>> +	if (err)
>> +		return err;
>> +
>>  	kfree(data);
>>  	return 0;
>>  }
>> diff --git a/include/linux/leds-pca9532.h b/include/linux/leds-pca9532.h
>> index f158eb1..b8d6fff 100644
>> --- a/include/linux/leds-pca9532.h
>> +++ b/include/linux/leds-pca9532.h
>> @@ -25,7 +25,7 @@ enum pca9532_state {
>>  };
>>
>>  enum pca9532_type { PCA9532_TYPE_NONE, PCA9532_TYPE_LED,
>> -	PCA9532_TYPE_N2100_BEEP };
>> +	PCA9532_TYPE_N2100_BEEP, PCA9532_TYPE_GPIO };
>>
>>  struct pca9532_led {
>>  	u8 id;
>> @@ -41,6 +41,7 @@ struct pca9532_platform_data {
>>  	struct pca9532_led leds[16];
>>  	u8 pwm[2];
>>  	u8 psc[2];
>> +	int gpio_base;
>>  };
>>
>>  #endif /* __LINUX_PCA9532_H */
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

Thanks for the review. I'll send out an updated patch later tonight.

regards
Joachim Eastwood

> Regards,
>
>    Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
