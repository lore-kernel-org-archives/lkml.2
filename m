Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2JOSBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:01:46 -0400
Received: from antcom.de ([188.40.178.216]:59659 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2JOSBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:01:45 -0400
Message-ID: <507C4F85.8020707@antcom.de>
Date: Mon, 15 Oct 2012 20:01:41 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-3-git-send-email-stigge@antcom.de> <507BA0B4.5030701@gmail.com>
In-Reply-To: <507BA0B4.5030701@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 07:35 AM, Ryan Mallon wrote:
>> --- linux-2.6.orig/Documentation/ABI/testing/sysfs-gpio
>> +++ linux-2.6/Documentation/ABI/testing/sysfs-gpio
>> @@ -24,4 +24,8 @@ Description:
>>  	    /base ... (r/o) same as N
>>  	    /label ... (r/o) descriptive, not necessarily unique
>>  	    /ngpio ... (r/o) number of GPIOs; numbered N to N + (ngpio - 1)
>> -
>> +	/blockN ... for each GPIO block #N
>> +	    /ngpio ... (r/o) number of GPIOs in this group
>> +	    /exported ... sysfs export state of this group (0, 1)
>> +	    /value ... current value as 32 or 64 bit integer in decimal
>> +                       (only available if /exported is 1)
>> --- linux-2.6.orig/drivers/gpio/gpiolib.c
>> +++ linux-2.6/drivers/gpio/gpiolib.c
>> @@ -974,6 +974,218 @@ static void gpiochip_unexport(struct gpi
>>  				chip->label, status);
>>  }
>>  
>> +static ssize_t gpio_block_ngpio_show(struct device *dev,
>> +				     struct device_attribute *attr, char *buf)
>> +{
>> +	const struct gpio_block	*block = dev_get_drvdata(dev);
>> +
>> +	return sprintf(buf, "%u\n", block->ngpio);
>> +}
>> +static struct device_attribute
>> +dev_attr_block_ngpio = __ATTR(ngpio, 0444, gpio_block_ngpio_show, NULL);
> 
> static DEVICE_ATTR(ngpio, S_IRUGO, gpio_block_ngpio_show, NULL);

Of course I would have used this. :-) But DEVICE_ATTR isn't flexible
enough here. There is already another "ngpio" in this file (resulting in
its name "dev_attr_ngpio") for gpio chips, colliding with this attribute
here (only on C source level - for sysfs it's fine).

Using S_IRUGO - thanks.

>> +}
>> +
>> +static bool gpio_block_is_output(struct gpio_block *block)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < block->ngpio; i++)
>> +		if (!test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags))
>> +			return false;
> 
> Shouldn't a block force all of the pins to be the same direction? Or at
> least have gpio_block_set skip pins which aren't outputs.

It is again analogous to GPIOs themselves: The sysfs interface prevents
Oopses by checking for the direction with the above function. Otherwise,
the user is responsible for requesting and setting direction.

>> +static ssize_t gpio_block_value_store(struct device *dev,
>> +				      struct device_attribute *attr,
>> +				      const char *buf, size_t size)
>> +{
>> +	ssize_t			status;
>> +	struct gpio_block	*block = dev_get_drvdata(dev);
>> +	unsigned long		value;
>> +
>> +	mutex_lock(&sysfs_lock);
>> +
>> +	status = kstrtoul(buf, 0, &value);
>> +	if (status == 0) {
> 
> You don't need to do the kstrtoul under the lock:
> 
> 	err = kstrtoul(buf, 0, &value);
> 	if (err)
> 		return err;
> 
> 	mutex_lock(&sysfs_lock);
> 	...
> 
> Global lock is a bit lame, it serialises all of your bitbanged busses
> against each other. Why is it not part of the gpio_block structure?

It's the same strategy as for GPIO value get/set.

More importantly maybe: Consider 32 GPIO lines on a single GPIO
controller. Several defined, say, 8 bit buses defined on this single
hardware word actually need to be locked against each other.

So sticking with it for now.

>> +		if (gpio_block_is_output(block)) {
>> +			gpio_block_set(block, value);
>> +			status = size;
>> +		} else {
>> +			status = -EPERM;
>> +		}
>> +	}
>> +
>> +	mutex_unlock(&sysfs_lock);
>> +	return status;
>> +}
>> +
>> +static struct device_attribute
>> +dev_attr_block_value = __ATTR(value, 0644, gpio_block_value_show,
>> +			      gpio_block_value_store);
> 
> Use DEVICE_ATTR and S_IWUSR | S_IRUGO permission macros.

Regarding DEVICE_ATTR as above. But adopting S_IWUSR | S_IRUGO - thanks.

Again, including all the other suggestions in the next update.

Thanks,

Roland
