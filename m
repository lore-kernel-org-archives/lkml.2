Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1H2O4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:56:12 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:48523 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1H2O4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:56:06 -0400
Date: Mon, 29 Aug 2011 10:55:43 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110829145543.GA9952@flamenco.cs.columbia.edu>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314608570-32766-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manohar,

Great work! A couple of comments inlined below.

On Mon, Aug 29, 2011 at 11:02:50 +0200, Manohar Vanga wrote:
(snip)
> +static int __vme_register_driver_bus(struct vme_driver *drv,
> +	struct vme_bridge *bridge, unsigned int ndevs)
> +{
> +	int err;
> +	unsigned int i;
> +	struct vme_dev *vdev;
> +	struct vme_dev *tmp;
> +
> +	for (i = 0; i < ndevs; i++) {
> +		vdev = kzalloc(sizeof(struct vme_dev), GFP_KERNEL);
> +		if (!vdev) {
> +			err = -ENOMEM;
> +			goto err_alloc;
> +		}
> +		vdev->id.num = i;
>  		vdev->id.bus = bridge->num;
>  		vdev->id.slot = i + 1;
>  		vdev->bridge = bridge;
> +		vdev->dev.platform_data = drv;
> +		vdev->dev.release = vme_dev_release;
>  		vdev->dev.parent = bridge->parent;
>  		vdev->dev.bus = &vme_bus_type;
> -		/*
> -		 * We save a pointer to the bridge in platform_data so that we
> -		 * can get to it later. We keep driver_data for use by the
> -		 * driver that binds against the slot
> -		 */
> -		vdev->dev.platform_data = bridge;
> -		dev_set_name(&vdev->dev, "vme-%x.%x", bridge->num, i + 1);
> -
> -		retval = device_register(&vdev->dev);
> -		if (retval)
> -			goto err_reg;
> +		dev_set_name(&vdev->dev, "%s.%u-%u", drv->name, vdev->id.bus,
> +			vdev->id.num);
> +
> +		err = device_register(&vdev->dev);
> +		if (err)
> +			goto err_dev_reg;
> +
> +		if (vdev->dev.platform_data) {
> +			list_add_tail(&vdev->list, &drv->devices);
> +			drv->ndev++;
> +		} else {
> +			device_unregister(&vdev->dev);
> +			kfree(vdev);
> +		}
>  	}
> +	return 0;
>  
> -	return retval;
> -
> -err_reg:
> -	while (--i >= 0) {
> -		vdev = &bridge->dev[i];
> +err_dev_reg:
> +	kfree(vdev);
> +err_alloc:
> +	list_for_each_entry_safe(vdev, tmp, &drv->devices, list) {
> +		list_del(&vdev->list);
>  		device_unregister(&vdev->dev);

Here there seems to be a missing kfree(vdev), like the one after device_unregister()
a few lines earlier.

>  	}
> -	vme_remove_bus(bridge);
> -	return retval;
> +	return err;
>  }
> -EXPORT_SYMBOL(vme_register_bridge);

(snip)

> -int vme_register_driver(struct vme_driver *drv)
> +int vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  {
> +	int err;
> +
>  	drv->driver.name = drv->name;
>  	drv->driver.bus = &vme_bus_type;
> -
> -	return driver_register(&drv->driver);
> +	INIT_LIST_HEAD(&drv->devices);
> +
> +	err = driver_register(&drv->driver);
> +	if (err)
> +		return err;
> +
> +	err = __vme_register_driver(drv, ndevs);
> +	if (!err & (drv->ndev == 0))

Probably you meant if (!err && drv->ndev == 0) here.

In fact one could imagine a driver that has no devices when it's
installed (it might get them later); so I'd remove this check.

> +		err = -ENODEV;
> +	if (err)
> +		vme_unregister_driver(drv);
> +	return err;
>  }
>  EXPORT_SYMBOL(vme_register_driver);


		Emilio
