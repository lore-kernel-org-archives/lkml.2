Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2JOFgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:36:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2JOFgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:36:03 -0400
Message-ID: <507BA0B4.5030701@gmail.com>
Date: Mon, 15 Oct 2012 16:35:48 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-3-git-send-email-stigge@antcom.de>
In-Reply-To: <1350069085-13283-3-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/12 06:11, Roland Stigge wrote:
> This patch adds sysfs support to the block GPIO API.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Hi Roland,

Some comments below,

~Ryan

> 
> ---
>  Documentation/ABI/testing/sysfs-gpio |    6 
>  drivers/gpio/gpiolib.c               |  226 ++++++++++++++++++++++++++++++++++-
>  include/asm-generic/gpio.h           |   11 +
>  include/linux/gpio.h                 |   13 ++
>  4 files changed, 254 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.orig/Documentation/ABI/testing/sysfs-gpio
> +++ linux-2.6/Documentation/ABI/testing/sysfs-gpio
> @@ -24,4 +24,8 @@ Description:
>  	    /base ... (r/o) same as N
>  	    /label ... (r/o) descriptive, not necessarily unique
>  	    /ngpio ... (r/o) number of GPIOs; numbered N to N + (ngpio - 1)
> -
> +	/blockN ... for each GPIO block #N
> +	    /ngpio ... (r/o) number of GPIOs in this group
> +	    /exported ... sysfs export state of this group (0, 1)
> +	    /value ... current value as 32 or 64 bit integer in decimal
> +                       (only available if /exported is 1)
> --- linux-2.6.orig/drivers/gpio/gpiolib.c
> +++ linux-2.6/drivers/gpio/gpiolib.c
> @@ -974,6 +974,218 @@ static void gpiochip_unexport(struct gpi
>  				chip->label, status);
>  }
>  
> +static ssize_t gpio_block_ngpio_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_block	*block = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", block->ngpio);
> +}
> +static struct device_attribute
> +dev_attr_block_ngpio = __ATTR(ngpio, 0444, gpio_block_ngpio_show, NULL);

static DEVICE_ATTR(ngpio, S_IRUGO, gpio_block_ngpio_show, NULL);

> +
> +static ssize_t gpio_block_value_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_block *block = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", gpio_block_get(block));

Printing the value of a bunch of pins as a decimal is a bit odd. Hex, or
a bitmap would be more appropriate.

> +}
> +
> +static bool gpio_block_is_output(struct gpio_block *block)
> +{
> +	int i;
> +
> +	for (i = 0; i < block->ngpio; i++)
> +		if (!test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags))
> +			return false;

Shouldn't a block force all of the pins to be the same direction? Or at
least have gpio_block_set skip pins which aren't outputs.

> +	return true;
> +}
> +
> +static ssize_t gpio_block_value_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t size)
> +{
> +	ssize_t			status;
> +	struct gpio_block	*block = dev_get_drvdata(dev);
> +	unsigned long		value;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	status = kstrtoul(buf, 0, &value);
> +	if (status == 0) {

You don't need to do the kstrtoul under the lock:

	err = kstrtoul(buf, 0, &value);
	if (err)
		return err;

	mutex_lock(&sysfs_lock);
	...

Global lock is a bit lame, it serialises all of your bitbanged busses
against each other. Why is it not part of the gpio_block structure?


> +		if (gpio_block_is_output(block)) {
> +			gpio_block_set(block, value);
> +			status = size;
> +		} else {
> +			status = -EPERM;
> +		}
> +	}
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static struct device_attribute
> +dev_attr_block_value = __ATTR(value, 0644, gpio_block_value_show,
> +			      gpio_block_value_store);

Use DEVICE_ATTR and S_IWUSR | S_IRUGO permission macros.

> +
> +static int gpio_block_value_is_exported(struct gpio_block *block)
> +{
> +	struct device		*dev;
> +	struct sysfs_dirent	*sd = NULL;
> +
> +	mutex_lock(&sysfs_lock);
> +	dev = class_find_device(&gpio_class, NULL, block, match_export);
> +	if (!dev)
> +		goto out;
> +
> +	sd = sysfs_get_dirent(dev->kobj.sd, NULL, "value");
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +	return sd ? 1 : 0;

  return sd;

or:

  return !!sd;

> +}
> +
> +static ssize_t gpio_block_exported_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct gpio_block	*block = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", gpio_block_value_is_exported(block));
> +}
> +
> +static int gpio_block_value_export(struct gpio_block *block)
> +{
> +	struct device	*dev;
> +	int		status;
> +	int		i;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	for (i = 0; i < block->ngpio; i++) {
> +		status = gpio_request(block->gpio[i], "sysfs");
> +		if (status)
> +			goto out;
> +	}
> +
> +	dev = class_find_device(&gpio_class, NULL, block, match_export);
> +	if (!dev) {
> +		status = -ENODEV;
> +		goto out;
> +	}
> +
> +	status = device_create_file(dev, &dev_attr_block_value);
> +	if (status)
> +		goto out;
> +
> +	mutex_unlock(&sysfs_lock);
> +	return 0;
> +
> +out:
> +	while (i > 0) {
> +		i--;
> +		gpio_free(block->gpio[i]);
> +	}

Nitpick:

	while (--i >= 0)
		gpio_free(block->gpio[i]);

> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static int gpio_block_value_unexport(struct gpio_block *block)
> +{
> +	struct device	*dev;
> +	int		i;
> +
> +	dev = class_find_device(&gpio_class, NULL, block, match_export);
> +	if (!dev)
> +		return -ENODEV;
> +
> +	for (i = 0; i < block->ngpio; i++)
> +		gpio_free(block->gpio[i]);
> +
> +	device_remove_file(dev, &dev_attr_block_value);
> +
> +	return 0;
> +}
> +
> +static ssize_t gpio_block_exported_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t size)
> +{
> +	long	value;
> +	int	status;
> +	struct	gpio_block *block = dev_get_drvdata(dev);
> +	int	exported = gpio_block_value_is_exported(block);
> +
> +	status = kstrtoul(buf, 0, &value);
> +	if (status < 0)
> +		goto err;
> +
> +	if (value != exported) {
> +		if (value)
> +			status = gpio_block_value_export(block);
> +		else
> +			status = gpio_block_value_unexport(block);
> +		if (!status)
> +			status = size;
> +	} else {
> +		status = size;
> +	}
> +err:
> +	return status;
> +}
> +
> +static DEVICE_ATTR(exported, 0644, gpio_block_exported_show,
> +		   gpio_block_exported_store);
> +
> +static const struct attribute *gpio_block_attrs[] = {
> +	&dev_attr_block_ngpio.attr,
> +	&dev_attr_exported.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group gpio_block_attr_group = {
> +	.attrs = (struct attribute **) gpio_block_attrs,
> +};
> +
> +int gpio_block_export(struct gpio_block *block)
> +{
> +	int		status;
> +	struct device	*dev;
> +
> +	/* can't export until sysfs is available ... */
> +	if (!gpio_class.p) {
> +		pr_debug("%s: called too early!\n", __func__);
> +		return -ENOENT;
> +	}
> +
> +	mutex_lock(&sysfs_lock);
> +	dev = device_create(&gpio_class, NULL, MKDEV(0, 0), block,
> +			    block->name);
> +	if (!IS_ERR(dev))
> +		status = sysfs_create_group(&dev->kobj, &gpio_block_attr_group);
> +	else
> +		status = PTR_ERR(dev);
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_export);
> +
> +void gpio_block_unexport(struct gpio_block *block)
> +{
> +	struct device *dev;
> +
> +	mutex_lock(&sysfs_lock);
> +	dev = class_find_device(&gpio_class, NULL, block, match_export);
> +	if (dev)
> +		device_unregister(dev);
> +	mutex_unlock(&sysfs_lock);
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_unexport);
> +
>  static int __init gpiolib_sysfs_init(void)
>  {
>  	int		status;
> @@ -1882,7 +2094,14 @@ int gpio_block_register(struct gpio_bloc
>  			break;
>  		}
>  	}
> -	return i == NR_GPIO_BLOCKS ? -EBUSY : 0;
> +	if (i == NR_GPIO_BLOCKS)
> +		goto err;
> +
> +	gpio_block_export(block);
> +
> +	return 0;
> +err:
> +	return -EBUSY;
>  }
>  EXPORT_SYMBOL_GPL(gpio_block_register);
>  
> @@ -1896,6 +2115,11 @@ void gpio_block_unregister(struct gpio_b
>  			break;
>  		}
>  	}
> +
> +	if (i == NR_GPIO_BLOCKS)
> +		return;
> +
> +	gpio_block_unexport(block);
>  }
>  EXPORT_SYMBOL_GPL(gpio_block_unregister);
>  
> --- linux-2.6.orig/include/asm-generic/gpio.h
> +++ linux-2.6/include/asm-generic/gpio.h
> @@ -210,6 +210,8 @@ extern int gpio_export_link(struct devic
>  			unsigned gpio);
>  extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
>  extern void gpio_unexport(unsigned gpio);
> +extern int gpio_block_export(struct gpio_block *block);
> +extern void gpio_block_unexport(struct gpio_block *block);
>  
>  #endif	/* CONFIG_GPIO_SYSFS */
>  
> @@ -269,6 +271,15 @@ static inline int gpio_sysfs_set_active_
>  static inline void gpio_unexport(unsigned gpio)
>  {
>  }
> +
> +static inline int gpio_block_export(struct gpio_block *block)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void gpio_block_unexport(struct gpio_block *block)
> +{
> +}
>  #endif	/* CONFIG_GPIO_SYSFS */
>  
>  #endif /* _ASM_GENERIC_GPIO_H */
> --- linux-2.6.orig/include/linux/gpio.h
> +++ linux-2.6/include/linux/gpio.h
> @@ -278,6 +278,19 @@ static inline void gpio_unexport(unsigne
>  	WARN_ON(1);
>  }
>  
> +static inline int gpio_block_export(struct gpio_block *block)
> +{
> +	/* GPIO block can never have been requested or set as {in,out}put */
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +
> +static inline void gpio_block_unexport(struct gpio_block *block)
> +{
> +	/* GPIO block can never have been exported */
> +	WARN_ON(1);
> +}
> +
>  static inline int gpio_to_irq(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as input */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

