Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2IZUXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:23:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41991 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2IZUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:23:38 -0400
Date: Wed, 26 Sep 2012 21:23:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
	lost probes
Message-ID: <20120926202321.GD30938@n2100.arm.linux.org.uk>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk> <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com> <20120916082510.GN12245@n2100.arm.linux.org.uk> <CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com> <20120926200833.GA14340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926200833.GA14340@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 01:08:33PM -0700, Greg Kroah-Hartman wrote:
> On Sun, Sep 16, 2012 at 09:24:43PM +0800, Ming Lei wrote:
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index 181ed26..17d7437 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -714,12 +714,12 @@ int bus_add_driver(struct device_driver *drv)
> >  	if (error)
> >  		goto out_unregister;
> > 
> > +	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
> >  	if (drv->bus->p->drivers_autoprobe) {
> >  		error = driver_attach(drv);
> >  		if (error)
> >  			goto out_unregister;
> >  	}
> > -	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
> >  	module_add_driver(drv->owner, drv);
> > 
> >  	error = driver_create_file(drv, &driver_attr_uevent);
> > 
> > 
> > 
> 
> Did the above patch ever prove to solve the issue or not?

To be honest, I've not bothered to test the above patch, and now when I
look at it, I notice it's broken - in that on error it will corrupt the
driver list.  Take a look at the error path.

priv is drv->p.  We add priv->knode_bus to the driver list.  If
driver_attach() returns an error, then we go to out_unregister, which
does:

out_unregister:
        kobject_put(&priv->kobj);
        kfree(drv->p);
        drv->p = NULL;

thereby freeing the node we just added to the driver list without first
removing it.

I suspect it will fix the problem, but let's get the patch to be correct
before it gets tested...
