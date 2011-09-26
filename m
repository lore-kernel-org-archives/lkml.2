Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1IZOTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:19:46 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:56778 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1IZOTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:19:44 -0400
Date: Mon, 26 Sep 2011 16:16:03 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110926141603.GB16310@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
 <1314868526-13230-4-git-send-email-manohar.vanga@cern.ch>
 <20110901222631.GA1835@t61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110901222631.GA1835@t61>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Emilio,

> > +	/* Initialize the list for bridge devices */
> > +	INIT_LIST_HEAD(&tsi148_bridge->devices);
> > +
> 
> Probably it makes more sense to handle this in vme.c:vme_add_bus(), since
> the particular bridge drivers do not manage at all the device list.

I thought of doing this but decided to go the other way for some forgotten
reason. I think it was the fact that there would be a gap between allocation
and initialization that bothered me.

Anyway, I've changed it and it is now done in vme_add_bus().

> > -#define USER_BUS_MAX                  1
> > +#define VME_USER_BUS_MAX	1
> 
> this could be another patch, but duh..

Done.

> >  int vme_register_bridge(struct vme_bridge *bridge)
> >  {
> > -	struct vme_dev *vdev;
> > -	int retval;
> > -	int i;
> > +	return vme_add_bus(bridge);
> > +}
> > +EXPORT_SYMBOL(vme_register_bridge);
> 
> Consider sending a subsequent patch cleaning up functions like these.
> But don't do it in this patch; this patch, if anything, needs to go
> on a diet.
> 
> > -	retval = vme_add_bus(bridge);
> > -	if (retval)
> > -		return retval;
> > +void vme_unregister_bridge(struct vme_bridge *bridge)
> > +{
> > +	vme_remove_bus(bridge);
> > +}
> > +EXPORT_SYMBOL(vme_unregister_bridge);
> 
> ditto

I'm not sure I understood this entirely. This replaces the old function
with the new one. There isn't any cleanup here. Or did I understand something
wrongly?

> > +/* - Driver Registration --------------------------------------------------- */
> 
> I know you're keeping this comment from what's already in the file,
> but personally I simply find it distracting.

Well there are others as well, so I've left it there for now.

> > +		} else
> > +			device_unregister(&vdev->dev);
> > +	}
> > +	return 0;
> >  
> > -err_reg:
> > +err_dev_reg:
> 
> Leaving the previous label would be better, it's easier to review.
> 
> >  	kfree(vdev);
> > -err_devalloc:
> > -	while (--i >= 0) {
> > -		vdev = bridge->dev[i];
> > +err_alloc:
> 
> ditto

Done.

> > -int vme_register_driver(struct vme_driver *drv)
> > +int vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
> >  {
> > +	int err;
> > +
> >  	drv->driver.name = drv->name;
> >  	drv->driver.bus = &vme_bus_type;
> > +	INIT_LIST_HEAD(&drv->devices);
> > +
> > +	err = driver_register(&drv->driver);
> > +	if (err)
> > +		return err;
> >  
> > -	return driver_register(&drv->driver);
> > +	err = __vme_register_driver(drv, ndevs);
> > +	if (err)
> > +		vme_unregister_driver(drv);
> 
> If __vme_register_driver() fails, we can be sure the created devices
> (and their corresponding lists) have been cleaned up before the
> function returned the failure. So here it seems clearer to call
> unregister_driver().

Agreed. Fixed in the resend.

> >  void vme_unregister_driver(struct vme_driver *drv)
> >  {
> > +	struct vme_dev *dev, *dev_tmp;
> > +
> > +	list_for_each_entry_safe(dev, dev_tmp, &drv->devices, drv_list) {
> > +		list_del(&dev->drv_list);
> > +		list_del(&dev->bridge_list);
> > +		device_unregister(&dev->dev);
> > +	}
> 
> All code operating on both lists is protected by vme_buses_lock, except the
> one in this function, which seems dangerous. vme_unregister_driver may race
> with vme_unregister_bridge. We need to acquire the lock here too.

Fixed.

> >  struct vme_device_id {
> > +	int num;
> >  	int bus;
> >  	int slot;
> 
> As I mentioned earlier, AFAICT the slot field is meaningless now.
> Consider submitting a subsequent patch that removes it.

Done. See resend.

> >  int vme_slot_get(struct vme_dev *);
> 
> AFAICT this is an exported symbol that after this patch has no callers
> and no meaning. Consider submitting a subsequent patch that removes it,
> possibly together with the removal of struct vme_device_id.slot.
> btw remember to update the documentation, I'm sure I'd forget.

This returns the geographical location of the bridge device. Would this
be useful for VME64x crates? I see it isn't used anywhere so I can't imagine
when it might be needed. Maybe Martyn can clarify?

-- 
/manohar
