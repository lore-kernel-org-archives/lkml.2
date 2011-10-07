Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935561Ab1JGGvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:51:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46358 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262Ab1JGGvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:51:23 -0400
X-Sasl-enc: /ThfGQQjnBlOzSGAG+epXB7+KcebjOxp5a5e7hsZ9mSI 1317970281
Date: Thu, 6 Oct 2011 23:49:28 -0700
From: Greg KH <greg@kroah.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111007064928.GE27508@kroah.com>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-3-git-send-email-manjugk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317963790-29426-3-git-send-email-manjugk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:33:07AM +0500, G, Manjunath Kondaiah wrote:
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Allow drivers to report at probe time that they cannot get all the 
> resources required by the device, and should be retried at a
> later time.
> 
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.
> 
> Original patch posted by Grant Likely <grant.likely@secretlab.ca> at:
> http://lwn.net/Articles/460522/
> 
> Enhancements to original patch by G, Manjunath Kondaiah <manjugk@ti.com>
>  - checkpatch warning fixes
>  - added Kconfig symbol CONFIG_PROBE_DEFER
>  - replacing normal workqueue with singlethread_workqueue
>  - handling -EPROBE_DEFER error
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
> ---
> Cc: linux-omap@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> 
>  drivers/base/Kconfig   |   11 ++++
>  drivers/base/base.h    |    3 +
>  drivers/base/core.c    |    6 ++
>  drivers/base/dd.c      |  145 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |    7 ++
>  5 files changed, 172 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 21cf46f..b412a71 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -172,6 +172,17 @@ config SYS_HYPERVISOR
>  	bool
>  	default n
>  
> +config PROBE_DEFER
> +	bool "Deferred Driver Probe"
> +	default y
> +	help
> +	  This option provides deferring driver probe if it has dependency on
> +	  other driver. Without this feature, initcall ordering should be done
> +	  manually to resolve driver dependencies. This feature completely side
> +	  steps the issues by allowing driver registration to occur in any
> +	  order, and any driver can request to be retried after a few more other
> +	  drivers get probed.

Why is this even an option?  Why would you ever want it disabled?  Why
does it need to be selected?

If you are going to default something to 'y' then just make it so it
can't be turned off any other way by just not making it an option at
all.

It also cleans up this diff a lot, as you really don't want #ifdef in .c
files.

> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -28,6 +28,136 @@
>  #include "base.h"
>  #include "power/power.h"
>  
> +#if defined CONFIG_PROBE_DEFER
> +/*
> + * Deferred Probe infrastructure.

Why not use kerneldoc?

> + *
> + * Sometimes driver probe order matters, but the kernel doesn't always have
> + * dependency information which means some drivers will get probed before a
> + * resource it depends on is available.  For example, an SDHCI driver may
> + * first need a GPIO line from an i2c GPIO controller before it can be
> + * initialized.  If a required resource is not available yet, a driver can
> + * request probing to be deferred by returning -EPROBE_DEFER from its probe hook
> + *
> + * Deferred probe maintains two lists of devices, a pending list and an active
> + * list.  A driver returning -EPROBE_DEFER causes the device to be added to the
> + * pending list.
> + *
> + * The deferred_probe_mutex *must* be held any time the deferred_probe_*_list
> + * of the (struct device*)->deferred_probe pointers are manipulated
> + */
> +static DEFINE_MUTEX(deferred_probe_mutex);
> +static LIST_HEAD(deferred_probe_pending_list);
> +static LIST_HEAD(deferred_probe_active_list);
> +static struct workqueue_struct *deferred_wq;
> +
> +/**
> + * deferred_probe_work_func() - Retry probing devices in the active list.
> + */
> +static void deferred_probe_work_func(struct work_struct *work)
> +{
> +	struct device *dev;
> +	/*

Extra blank line please.

> +	 * This bit is tricky.  We want to process every device in the
> +	 * deferred list, but devices can be removed from the list at any
> +	 * time while inside this for-each loop.  There are two things that
> +	 * need to be protected against:

That's what the klist structure is supposed to make easier, why not use
that here?

> +	 * - if the device is removed from the deferred_probe_list, then we
> +	 *   loose our place in the loop.  Since any device can be removed
> +	 *   asynchronously, list_for_each_entry_safe() wouldn't make things
> +	 *   much better.  Simplest solution is to restart walking the list
> +	 *   whenever the current device gets removed.  Not the most efficient,
> +	 *   but is simple to implement and easy to audit for correctness.
> +	 * - if the device is unregistered, and freed, then there is a risk
> +	 *   of a null pointer dereference.  This code uses get/put_device()
> +	 *   to ensure the device cannot disappear from under our feet.

Ick, use a klist, it was created to handle this exact problem in the
driver core, so to not use it would be wrong, right?

> +	 */
> +	mutex_lock(&deferred_probe_mutex);
> +	while (!list_empty(&deferred_probe_active_list)) {
> +		dev = list_first_entry(&deferred_probe_active_list,
> +					typeof(*dev), deferred_probe);
> +		list_del_init(&dev->deferred_probe);
> +
> +		get_device(dev);
> +
> +		/* Drop the mutex while probing each device; the probe path
> +		 * may manipulate the deferred list */

Use proper kernel multi-line comment format.  This needs to be done in a
number of places in this patch, please fix them all.

thanks,

greg k-h
