Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2BAPVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:21:00 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:38655 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2BAPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:20:58 -0500
Message-ID: <4F29584F.1060503@free-electrons.com>
Date: Wed, 01 Feb 2012 16:20:47 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: jic23@cam.ac.uk
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        linus.walleij@linaro.org, lars@metafoo.de
Subject: Re: [PATCH 1/6] IIO: Core sysfs only support.
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk> <1320677563-18378-2-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1320677563-18378-2-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I know that this patchset is probably a bit outdated but still...

On 07/11/2011 15:52, jic23@cam.ac.uk wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Add support for simple sysfs only interfaces.
> 
> Bulk of patch is concerned with taking struct iio_chan_spec
> arrays and generating all the relevant interfaces from them.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
First, you can add my
Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I have encountered a bug during my tests though, see below

> +struct iio_dev *iio_device_allocate(int sizeof_priv)
> +{
> +	struct iio_dev *dev;
> +	size_t alloc_size;
> +
> +	alloc_size = sizeof(struct iio_dev);
> +	if (sizeof_priv) {
> +		alloc_size = ALIGN(alloc_size, IIO_ALIGN);
> +		alloc_size += sizeof_priv;
> +	}
> +	/* ensure cacheline alignment of whole construct */
> +	alloc_size += IIO_ALIGN - 1;
> +
> +	dev = kzalloc(alloc_size, GFP_KERNEL);
> +
> +	if (dev) {
> +		dev->dev.groups = dev->groups;
> +		dev->dev.type = &iio_dev_type;
> +		dev->dev.bus = &iio_bus_type;
> +		device_initialize(&dev->dev);
> +		dev_set_drvdata(&dev->dev, (void *)dev);
> +		mutex_init(&dev->mlock);
> +	}
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(iio_device_allocate);
> +
> +void iio_device_free(struct iio_dev *dev)
> +{
> +	if (dev)
> +		iio_put_device(dev);
> +}
> +EXPORT_SYMBOL_GPL(iio_device_free);

Here, the iio_put_device is called in free, but get_device is never
called, but seem to be called in iio_device_register, which, if you ever
encounter an error in the probe function, you will never have called the
iio_device_register function, before calling the iio_device_free
function, which leads to a segfault.

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
