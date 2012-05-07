Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2EGICD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:02:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17241 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2EGICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:02:01 -0400
Date: Mon, 7 May 2012 11:04:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Staging: IndustryPack bus for the Linux Kernel
Message-ID: <20120507080458.GN22134@mwanda>
References: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336375569-21692-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:26:07AM +0200, Samuel Iglesias Gonsalvez wrote:
> +int ipack_bus_register(struct ipack_bus_device *bus)
> +{
> +	int bus_nr;

Blank line here between declaration and code.

> +	bus_nr = ipack_assign_bus_number();
> +	if (bus_nr < 0)
> +		return -1;
> +	bus->bus_nr = bus_nr;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipack_bus_register);

[snip]

> +int ipack_driver_register(struct ipack_driver *edrv)
> +{
> +	int ret;
> +
> +	edrv->driver.bus = &ipack_bus_type;
> +	ret = driver_register(&edrv->driver);
> +	if (ret < 0)
> +		goto exit_driver_register;
> +
> +exit_driver_register:
> +	return ret;
> +}

Better to write it like this:
int ipack_driver_register(struct ipack_driver *edrv)
{
	edrv->driver.bus = &ipack_bus_type;
	return driver_register(&edrv->driver);
}


[snip]

> +int ipack_device_find_drv(struct device_driver *driver, void *param)
> +{
> +	int ret;
> +	struct ipack_device *dev = (struct ipack_device *)param;
> +
> +	ret = ipack_bus_match(&dev->dev, driver);
> +	if (ret)
> +		return !ipack_bus_probe(&dev->dev);

Wouldn't probe() return zero or a negative error code?

> +
> +	return ret;
	return 0;

> +}
> +
> +int ipack_device_register(struct ipack_device *dev)
> +{
> +	int ret;
> +
> +	if (!bus_for_each_drv(&ipack_bus_type, NULL, dev, ipack_device_find_drv)) {
> +		ret = -ENODEV;
> +		goto exit_device_register;

Just return directly here.  I was expecting a reason for a goto but
a nonsense goto is misleading.

> +	}
> +
> +	dev->dev.bus = &ipack_bus_type;
> +	dev->dev.release = ipack_device_release;
> +	dev_set_name(&dev->dev, "%s.%u.%u", dev->board_name, dev->bus_nr, dev->slot);
> +	ret = device_register(&dev->dev);
> +	if (ret < 0) {
> +		printk(KERN_ERR "ipack: error registering the device.\n");
> +		dev->driver->ops->remove(dev);
> +	}
> +
> +exit_device_register:
> +	return ret;
> +}

regards,
dan carpenter
