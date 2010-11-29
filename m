Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0K2T46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:56:58 -0500
Received: from kroah.org ([198.145.64.141]:60043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0K2T45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:56:57 -0500
Date: Mon, 29 Nov 2010 11:56:49 -0800
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101129195649.GA32500@kroah.com>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:43:28PM +0100, Guennadi Liakhovetski wrote:
> When two drivers interoperate without an explicit dependency, it is often
> required to prevent one of them from being unloaded safely by dereferencing
> dev->driver->owner. This patch provides a generic function to do this in a
> race-free way.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Not run-time tested in this form, but this is just a generalisation of the 
> code in drivers/media/video/sh_mobile_ceu_camera.c::sh_mobile_ceu_probe(). 
> If the idea is accepted in principle, I will replace that specific 
> implementation with a call to this function, test... But I am not sure, if 
> I'd be able to test it for races. If such testing is required on SMP, I'd 
> have to write some test-case for it. Thoughts?
> 
>  drivers/base/dd.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |    1 +
>  2 files changed, 64 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index da57ee9..44c6672 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -17,10 +17,12 @@
>   * This file is released under the GPLv2
>   */
>  
> +#include <linux/completion.h>
>  #include <linux/device.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/kthread.h>
> +#include <linux/notifier.h>
>  #include <linux/wait.h>
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
> @@ -422,3 +424,64 @@ void dev_set_drvdata(struct device *dev, void *data)
>  	dev->p->driver_data = data;
>  }
>  EXPORT_SYMBOL(dev_set_drvdata);
> +
> +struct bus_wait {
> +	struct notifier_block	notifier;
> +	struct completion	completion;
> +	struct device		*dev;
> +};
> +
> +static int bus_notify(struct notifier_block *nb,
> +		      unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	struct bus_wait *wait = container_of(nb, struct bus_wait, notifier);
> +
> +	if (wait->dev != dev)
> +		return NOTIFY_DONE;
> +
> +	switch (action) {
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +		/* Protect from module unloading */
> +		wait_for_completion(&wait->completion);
> +		return NOTIFY_OK;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +int device_try_get_driver(struct device *dev)

Please create some kerneldoc information for this new function so that
people know how to use it and what it is for.

Also, do you want to provide a device_put_driver() function as well to
decrement the owner count once the person who grabed the driver is done
with it?

> +{
> +	struct bus_wait wait = {
> +		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
> +		.dev = dev,
> +		.notifier.notifier_call = bus_notify,
> +	};
> +	struct bus_type	*bus;
> +	int ret;
> +
> +	if (!dev || !dev->bus)
> +		return 0;
> +
> +	bus = dev->bus;
> +
> +	if (bus_register_notifier(bus, &wait.notifier) < 0)
> +		return 0;
> +
> +	/*
> +	 * From this point the driver module will not unload, until we complete
> +	 * the completion. In the worst case it is hanging in device release on
> +	 * our completion. So, _now_ dereferencing the "owner" is safe.
> +	 */
> +	if (dev->driver && dev->driver->owner)
> +		ret = try_module_get(dev->driver->owner);
> +	else
> +		/* Either no driver, or too late, or probing failed */
> +		ret = 0;
> +
> +	/* Let notifier complete, if it has been blocked */
> +	complete(&wait.completion);
> +	bus_unregister_notifier(bus, &wait.notifier);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(device_try_get_driver);

EXPORT_SYMBOL_GPL() please.

thanks,

greg k-h
