Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2JQTF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:05:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab2JQTFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:05:24 -0400
Date: Wed, 17 Oct 2012 12:05:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
Message-ID: <20121017190520.GC25996@kroah.com>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
 <1350477107-26512-3-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350477107-26512-3-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 02:31:34PM +0200, Roland Stigge wrote:
> This patch adds sysfs support to the block GPIO API.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
>  Documentation/ABI/testing/sysfs-gpio |    6 
>  drivers/gpio/gpiolib.c               |  214 +++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h           |   11 +
>  include/linux/gpio.h                 |   13 ++
>  4 files changed, 243 insertions(+), 1 deletion(-)
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

I think you need some more documentation here, as I just noticed
something "odd":

> +static int gpio_block_value_unexport(struct gpio_block *block)
> +{
> +	struct device	*dev;
> +	int		i;
> +
> +	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
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

Wait, what?  You are removing a sysfs file in this function, from within
a sysfs write:

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

That looks like a recipie for disaster.  Why do you allow userspace to
do this?

Anyway, the other fixups for how you create/destroy the attribute files
looks great, thanks for making those changes.

greg k-h
