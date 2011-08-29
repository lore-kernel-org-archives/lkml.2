Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1H2Sko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:40:44 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44068 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1H2Skn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:40:43 -0400
Date: Mon, 29 Aug 2011 14:40:12 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, martyn.welch@ge.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110829184012.GA19793@flamenco.cs.columbia.edu>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-2-git-send-email-manohar.vanga@cern.ch>
 <20110829175104.GB10250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829175104.GB10250@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:51:04 -0700, Greg KH wrote:
> On Mon, Aug 29, 2011 at 11:02:48AM +0200, Manohar Vanga wrote:
> > This patch adds functions that allow for reference counting
> > bridge modules. The patch introduces the functions
> > 'vme_bridge_get()' and 'vme_bridge_put()'.
> > 
> > The functions are automatically called during .probe and .remove
> > for drivers.
> > 
> > This patch is based on the changes introduced by Emilio G. Cota
> > in the patch:
> > 
> >     https://lkml.org/lkml/2010/10/25/492
> 
> Generally do not try to couple a module reference count with a device
> count, you are locking code, not data, and we really don't want to lock
> code anymore now that we properly handle device reference counts.

(snip)

> > diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> > index 8959670..ef751a4 100644
> > --- a/drivers/staging/vme/vme_bridge.h
> > +++ b/drivers/staging/vme/vme_bridge.h
> > @@ -113,6 +113,7 @@ struct vme_bridge {
> >  	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
> >  	void *driver_priv;	/* Private pointer for the bridge driver */
> >  	struct list_head bus_list; /* list of VME buses */
> > +	struct module *owner;	/* module that owns the bridge */
> 
> Why?  When you register the device for this bridge, you should properly
> handle the module reference counting in the vme core for any open sysfs
> files.
> 
> Other than that, you shouldn't care about the module reference at all,
> right?
> 
> What am I missing here?  What is this solving?
> 
> confused,

AFAIK currently a vme bridge driver can be freely removed with rmmod
even if it has devices under it. The patch avoids this by increasing
the refcount of the bridge module every time a device is registered
under it.

What's the appropriate thing to do when rmmod tries to remove a bridge
module? Shall we remove each bridge and all the child devices, or just
refuse to remove a bridge when it has child devices? Manohar implements
the latter, although incrementing the refcount of the module is admittedly
coarse. He said he'd later change this to implement the refcounting on
each bridge device (and not module).

Hope this helps, thanks for looking at it.

		Emilio

