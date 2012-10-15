Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2JOX51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:57:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51201 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2JOX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:57:25 -0400
Date: Mon, 15 Oct 2012 16:57:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RFC 02/11 v4] gpio: Add sysfs support to block GPIO API
Message-ID: <20121015235720.GA3132@kroah.com>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
 <1350343887-7344-3-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350343887-7344-3-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 01:31:18AM +0200, Roland Stigge wrote:
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

You just raced with userspace telling it that the device was present,
yet the attributes are not there.  Don't do that, use the default class
attributes for the class and then the driver core will create them
automagically without needing to this "by hand" at all.

thanks,

greg k-h
