Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1HJTOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:14:44 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:53565 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1HJTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:14:43 -0400
Date: Wed, 10 Aug 2011 15:14:24 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110810191424.GA26147@flamenco.cs.columbia.edu>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
 <1312968830-13377-5-git-send-email-manohar.vanga@cern.ch>
 <4E4258F4.8040408@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4258F4.8040408@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:09:56 +0100, Martyn Welch wrote:
> On 10/08/11 10:33, Manohar Vanga wrote:
> >  static struct vme_bridge *find_bridge(struct vme_resource *resource)
> > @@ -1525,9 +1573,13 @@ static int vme_bus_probe(struct device *dev)
> >  	driver = dev_to_vme_driver(dev);
> >  	bridge = dev_to_bridge(dev);
> >  
> > +	vme_bridge_get(bridge->num);

Here the return pointer is not being checked, although things
would need to be very wrong for this to fail here.

> >  	if (driver->probe != NULL)
> >  		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
> >  
> > +	if (retval)
> > +		vme_bridge_put(bridge);
> > +
> 
> Given that we are recounting automatically in probe and remove, under what
> circumstances would we need to call them separately?

I agree, it's hard to imagine a scenario where "doubly locking"
the module would make any sense at all.

It would also be nice to:

- Increment the refcount of the bridge device with get_device(),
  this way we protect against the device removal as well.
  Bonus points if we increment the bridge module's refcount
  once per device driver using it and the bridge device's
  refcount once per device sitting on it.

- re-think what the return value of vme_bridge_get should be;
  guess my original idea was to return a reference to a bridge,
  which would be safely used by device drivers from there
  on. Since apparently we're not going this way, then perhaps
  an int (returning 0 on success and -ENXIO on failure) would
  be clearer.

		Emilio
