Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2CETQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:16:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab2CETQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:16:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Date: Mon, 5 Mar 2012 19:15:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203051915.45197.arnd@arndb.de>
X-Provags-ID: V02:K0:xtYza+fpzhF/mgoFsESPdyO869sPq4qEpkb20SQLEc2
 cFu+qrD8to7Cz7e9RD3vOYmASk1PblV2A27a0XVxErBoV7Ody/
 YrbA/pFDUEQdBVQkWK5KWKey8OvmT/G3GShWWQtAXXged7RxDK
 0PmepC1Qoze1zhftkb5TXq4xnzNhkwe//JSTiRSRiSVIXnoDyu
 Z9KtpSEB54xQHCnP27Qh8EklHJ7QhBblVKwMJ7cOKcOXIKmsCb
 TdhfTOo0E4HxmbbmyGrUUzVi4rJy1jqPDzMAN+TbyqiwX7jY+k
 bFtkvjiaErlr+cVd3Sd6Z936HywU3VWjzJxDLFNKDXUkXFsh60
 q2ygpO8iLFGYQqCUrcbc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2012, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
> 
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.

Hi Grant,

Looks great! I thought I had found two bugs but it turned out to
all be correct on second look.  What remains in my review is basically
bike-shedding, but I'll send it anyway since I took the time to
write it before I noticed I was wrong on the other points ;-)

Anyway, I'm happy for this to go in in the current way,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> @@ -28,6 +28,133 @@
>  #include "base.h"
>  #include "power/power.h"
>  
> +/*
> + * Deferred Probe infrastructure.
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
> + * pending list.  A successful driver probe will trigger moving all devices
> + * from the pending to the active list so that the workqueue will eventually
> + * retry them.
> + *
> + * The deferred_probe_mutex must be held any time the deferred_probe_*_list
> + * of the (struct device*)->deferred_probe pointers are manipulated
> + */
> +static DEFINE_MUTEX(deferred_probe_mutex);
> +static LIST_HEAD(deferred_probe_pending_list);
> +static LIST_HEAD(deferred_probe_active_list);
> +static struct workqueue_struct *deferred_wq;

I don't understand why you want both lists to be global, it seems to
complicate things.

> +/**
> + * deferred_probe_work_func() - Retry probing devices in the active list.
> + */
> +static void deferred_probe_work_func(struct work_struct *work)
> +{
> +	struct device *dev;
> +	/*
> +	 * This block processes every device in the deferred 'active' list.
> +	 * Each device is removed from the active list and passed to
> +	 * bus_probe_device() to re-attempt the probe.  The loop continues
> +	 * until every device in the active list is removed and retried.
> +	 *
> +	 * Note: Once the device is removed from the list and the mutex is
> +	 * released, it is possible for the device get freed by another thread
> +	 * and cause a illegal pointer dereference.  This code uses
> +	 * get/put_device() to ensure the device structure cannot disappear
> +	 * from under our feet.
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
> +		mutex_unlock(&deferred_probe_mutex);
> +		dev_dbg(dev, "Retrying from deferred list\n");
> +		bus_probe_device(dev);
> +		mutex_lock(&deferred_probe_mutex);
> +
> +		put_device(dev);
> +	}
> +	mutex_unlock(&deferred_probe_mutex);


If you make the deferred_probe_active_list local to this function, and do
the splice inside of it, you only need to hold the mutex for the
splice, and the loop can become a simpler

	LIST_HEAD(list);

	mutex_lock(&deferred_probe_mutex);
	list_splice_tail_init(&deferred_probe_pending_list, &list);
	mutex_unlock(&deferred_probe_mutex);

	list_for_each_entry_safe(...) {
		list_del_init(&dev->deferred_probe);
		bus_probe_device(dev);
		put_device(dev);
	}

Also, What protects the device from going away between being put on the list
and taken off of it? Don't you have to do the device_get during
driver_deferred_probe_add()?

> +static bool driver_deferred_probe_enable = false;
> +/**
> + * driver_deferred_probe_trigger() - Kick off re-probing deferred devices
> + *
> + * This functions moves all devices from the pending list to the active
> + * list and schedules the deferred probe workqueue to process them.  It
> + * should be called anytime a driver is successfully bound to a device.
> + */
> +static void driver_deferred_probe_trigger(void)
> +{
> +	if (!driver_deferred_probe_enable)
> +		return;

I tried to understand whether you need to have locking around
driver_deferred_probe_enable, but I think you don't even need this
variable at all:

> +
> +	/* A successful probe means that all the devices in the pending list
> +	 * should be triggered to be reprobed.  Move all the deferred devices
> +	 * into the active list so they can be retried by the workqueue */
> +	mutex_lock(&deferred_probe_mutex);
> +	list_splice_tail_init(&deferred_probe_pending_list,
> +			      &deferred_probe_active_list);
> +	mutex_unlock(&deferred_probe_mutex);
> +
> +	/* Kick the re-probe thread.  It may already be scheduled, but
> +	 * it is safe to kick it again. */
> +	queue_work(deferred_wq, &deferred_probe_work);
> +}

You can simply check whether deferred_wq is non-NULL here before you call it,
because it never goes away after it has been created.

> +static int deferred_probe_initcall(void)
> +{
> +	deferred_wq = create_singlethread_workqueue("deferwq");
> +	if (WARN_ON(!deferred_wq))
> +		return -ENOMEM;

I think "deferwq" is not a good name for a global thread: all work queues are
there for deferring somehting. How about "deferredprobe"?

	Arnd
