Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2IZUIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:08:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2IZUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:08:37 -0400
Date: Wed, 26 Sep 2012 13:08:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
 lost probes
Message-ID: <20120926200833.GA14340@kroah.com>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk>
 <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
 <20120916082510.GN12245@n2100.arm.linux.org.uk>
 <CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 09:24:43PM +0800, Ming Lei wrote:
> On Sun, Sep 16, 2012 at 4:25 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > It isn't.  As I said, it's a race condition due to lack of locking - the
> > driver hasn't been added to the list of drivers at this point:
> >
> > int bus_add_driver(struct device_driver *drv)
> > {
> > ...
> >         if (drv->bus->p->drivers_autoprobe) {
> >                 error = driver_attach(drv);
> >                 if (error)
> >                         goto out_unregister;
> >         }
> >         klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
> > ...
> > }
> >
> > Notice that the attaching is done _before_ the driver is added to the
> > bus driver list.
> 
> Yes, it is a problem since a new device may be added to bus
> and bus_probe_device() may not see the new added driver.
> 
> So looks klist_add_tail() should complete before driver_attach()
> inside bus_add_driver().
> 
> The attached one line change should fix the problem because the
> below way can guarantee that no probe(dev) may be lost.
> 
> 
> CPU0				CPU1
> driver_register
> 	...
> 	write(bus->driver_list)
> 	smp_mb()
> 	read(bus->device_list)
> 	...
> 				device_add
> 					/* bus_add_device */	
> 					write(bus->device_list)
> 					smp_mb()
> 					/* bus_probe_device*/
> 					read(bus->driver_list)
> 
> And the smp_mb() has been implicit by UNLOCK+LOCK
> of 'klist' according to 'VARIETIES OF MEMORY BARRIER' part
> of Documentation/memory-barriers.txt.
> 
> Could you test the below patch to see if it can fix your problem?
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 181ed26..17d7437 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -714,12 +714,12 @@ int bus_add_driver(struct device_driver *drv)
>  	if (error)
>  		goto out_unregister;
> 
> +	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
>  	if (drv->bus->p->drivers_autoprobe) {
>  		error = driver_attach(drv);
>  		if (error)
>  			goto out_unregister;
>  	}
> -	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
>  	module_add_driver(drv->owner, drv);
> 
>  	error = driver_create_file(drv, &driver_attr_uevent);
> 
> 
> 

Did the above patch ever prove to solve the issue or not?

thanks,

greg k-h
