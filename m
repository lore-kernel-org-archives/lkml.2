Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab1HMIue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 04:50:34 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:60161 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HMIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 04:50:32 -0400
Date: Sat, 13 Aug 2011 04:50:14 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110813085014.GB32149@flamenco.cs.columbia.edu>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-6-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313145051-13397-6-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:30:51 +0200, Manohar Vanga wrote:
> +++ b/drivers/staging/vme/vme.c
(snip)
> +static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  {
> -	int i;
> -	struct vme_dev *vdev;
> -
> +	struct vme_bridge *bridge;
> +	int err = 0;
>  
> -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		vdev = &bridge->dev[i];
> -		device_unregister(&vdev->dev);
> +	mutex_lock(&vme_buses_lock);
> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> +		/*
> +		 * We increase the refcount of the bridge module here to
> +		 * prevent it from being removed during driver registration
> +		 */
> +		if (!vme_bridge_get(bridge->num))
> +			continue;

hmm have you tested this? It should deadlock, because as in
patch 3 vme_bridge_get() acquires vme_buses_lock.

An alternative is to call here try_module_get() directly on
bridge->owner, which would succeed in preventing it from being
removed (the lock is held 

> +		mutex_unlock(&vme_buses_lock);
> +		err = __vme_register_driver_bus(drv, bridge, ndevs);
> +		mutex_lock(&vme_buses_lock);
> +		vme_bridge_put(bridge);

This, interestingly, wouldn't deadlock, because we pass the bridge
directly. See my second message to patch 3.

> +		if (err)
> +			break;
>  	}
> -	vme_remove_bus(bridge);
> +	mutex_unlock(&vme_buses_lock);
> +	return err;
>  }

The whole loop is admittedly complex. IIRC in my original patch
module_get/put were called here directly, and vme_buses_lock
was unlocked before calling __vme_register_driver_bus()
to avoid a deadlock, because within that function the .probe
methods of the driver would likely call vme_bridge_get().

Now that we don't export them, the loop could be simplified to:


> +	mutex_lock(&vme_buses_lock);
> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> +		err = __vme_register_driver_bus(drv, bridge, ndevs);
> +		if (err)
> +			break;
>  	}
> +	mutex_unlock(&vme_buses_lock);

This cannot race with a bridge being removed. Let's see how:
If the bridge driver is sane, it will call vme_unregister_bridge()
in its .release method. In there vme_remove_bus is called, and
the thread will try to acquire vme_buses_lock, which is already
held by above loop. Coming back to the loop, the try_get_module
call in vme_bus_probe will fail, because the bridge module
is being removed, and as a result all the devices under that
bridge won't be installed--this is what we wanted.

When the loop finishes we unlock vme_buses_lock and the
removal of the bus completes.

That said, I would ONLY take the simplified loop if a comment was
added to explain the above race. And I'd add that comment
near vme_bus_get/put, because if those are exported one
day, the above loop would need be changed accordingly.

		Emilio


