Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1H2RxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:53:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38250 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab1H2RxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:53:01 -0400
X-Sasl-enc: S0WcT4TlAaBfU8nk7ZXMFlZ9n6j56NkdkbilOYvYo9fU 1314640380
Date: Mon, 29 Aug 2011 10:51:04 -0700
From: Greg KH <greg@kroah.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110829175104.GB10250@kroah.com>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-2-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314608570-32766-2-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:02:48AM +0200, Manohar Vanga wrote:
> This patch adds functions that allow for reference counting
> bridge modules. The patch introduces the functions
> 'vme_bridge_get()' and 'vme_bridge_put()'.
> 
> The functions are automatically called during .probe and .remove
> for drivers.
> 
> This patch is based on the changes introduced by Emilio G. Cota
> in the patch:
> 
>     https://lkml.org/lkml/2010/10/25/492

Generally do not try to couple a module reference count with a device
count, you are locking code, not data, and we really don't want to lock
code anymore now that we properly handle device reference counts.

> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +
>  drivers/staging/vme/bridges/vme_tsi148.c   |    2 +
>  drivers/staging/vme/vme.c                  |   43 +++++++++++++++++++++++++--
>  drivers/staging/vme/vme_bridge.h           |    1 +
>  4 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 0e4feac..b80cb12 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -1673,6 +1673,8 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	ca91cx42_bridge->parent = &pdev->dev;
>  	strcpy(ca91cx42_bridge->name, driver_name);
>  
> +	ca91cx42_bridge->owner = THIS_MODULE;
> +
>  	/* Setup IRQ */
>  	retval = ca91cx42_irq_init(ca91cx42_bridge);
>  	if (retval != 0) {
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 6c1167c..b0b434a 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2312,6 +2312,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	tsi148_bridge->parent = &pdev->dev;
>  	strcpy(tsi148_bridge->name, driver_name);
>  
> +	tsi148_bridge->owner = THIS_MODULE;
> +
>  	/* Setup IRQ */
>  	retval = tsi148_irq_init(tsi148_bridge);
>  	if (retval != 0) {
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index feb2d00..f5ff578 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -52,6 +52,32 @@ static struct vme_bridge *dev_to_bridge(struct device *dev)
>  }
>  
>  /*
> + * Increments the reference count of a VME bridge.
> + *
> + * On success, it can be assumed that the bridge won't be removed until
> + * the corresponding call to vme_put_bridge(). This along with
> + * vme_bridge_put are automatically called and VME device drivers need
> + * not worry about using this.
> + */
> +static int vme_bridge_get(struct vme_bridge *bridge)
> +{
> +	if (try_module_get(bridge->owner))
> +		return 0;
> +	return -ENXIO;
> +}
> +
> +/*
> + * Decrements the reference count of a VME bridge
> + *
> + * This function decrements the reference count of the module that controls
> + * the bridge. It must come after a call to vme_bridge_get().
> + */
> +static void vme_bridge_put(struct vme_bridge *bridge)
> +{
> +	module_put(bridge->owner);
> +}
> +
> +/*
>   * Find the bridge that the resource is associated with.
>   */
>  static struct vme_bridge *find_bridge(struct vme_resource *resource)
> @@ -1496,13 +1522,19 @@ static int vme_bus_probe(struct device *dev)
>  {
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
> -	int retval = -ENODEV;
> +	int retval = 0;
>  
>  	driver = dev_to_vme_driver(dev);
>  	bridge = dev_to_bridge(dev);
>  
> -	if (driver->probe != NULL)
> +	if (driver->probe) {
> +		if (vme_bridge_get(bridge))
> +			return -ENXIO;
> +
>  		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
> +		if (retval)
> +			vme_bridge_put(bridge);
> +	}
>  
>  	return retval;
>  }
> @@ -1511,14 +1543,17 @@ static int vme_bus_remove(struct device *dev)
>  {
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
> -	int retval = -ENODEV;
> +	int retval = 0;

This looks like a bugfix that we should take separate from this overall
patch, right?  Same goes for the function above this.


>  
>  	driver = dev_to_vme_driver(dev);
>  	bridge = dev_to_bridge(dev);
>  
> -	if (driver->remove != NULL)
> +	if (driver->remove)

Was that really needed? :)

>  		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
>  
> +	if (driver->probe)
> +		vme_bridge_put(bridge);
> +
>  	return retval;
>  }
>  
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index 8959670..ef751a4 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -113,6 +113,7 @@ struct vme_bridge {
>  	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
>  	void *driver_priv;	/* Private pointer for the bridge driver */
>  	struct list_head bus_list; /* list of VME buses */
> +	struct module *owner;	/* module that owns the bridge */

Why?  When you register the device for this bridge, you should properly
handle the module reference counting in the vme core for any open sysfs
files.

Other than that, you shouldn't care about the module reference at all,
right?

What am I missing here?  What is this solving?

confused,

greg k-h
