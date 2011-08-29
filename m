Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1H2Xz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:55:29 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44483 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1H2Xz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:55:28 -0400
Date: Mon, 29 Aug 2011 19:55:08 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>, Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110829235508.GA30400@flamenco.cs.columbia.edu>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
 <20110829175241.GC10250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829175241.GC10250@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:52:41 -0700, Greg KH wrote:
> On Mon, Aug 29, 2011 at 11:02:49AM +0200, Manohar Vanga wrote:
> > --- a/drivers/staging/vme/vme_bridge.h
> > +++ b/drivers/staging/vme/vme_bridge.h
> > @@ -115,9 +115,8 @@ struct vme_bridge {
> >  	struct list_head bus_list; /* list of VME buses */
> >  	struct module *owner;	/* module that owns the bridge */
> >  
> > -	struct device dev[VME_SLOTS_MAX];	/* Device registered with
> > -						 * device model on VME bus
> > -						 */
> > +	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
> > +						 * on VME bus */
> 
> Overall, this is the right way to go, using a vme_dev.
> 
> BUT, you should never have a static list of devices, these should be
> pointers, not actual structures here, otherwise your reference counting
> just got all messed up and is wrong.
> 
> And yes, I know you didn't create the code this way, but it needs to be
> fixed _before_ you make this kind of a change.

True, I overlooked this while reviewing >_<

Manohar, have a look at vme_unregister_driver_ng() and
__vme_register_driver_bus() in this patch:
 
    http://article.gmane.org/gmane.linux.kernel/1054046

Note that there's no kfree(vme_dev) in those functions. put_device(),
which is also called from device_unregister(), decrements
the underlying kobj's refcount. When this refcount reaches 0,
kobject_release() is called. Eventually dev->release() gets called,
which in this case is set to vme_dev_release_ng(); it's there
(and only there) where vme_dev can be freed.

		Emilio
