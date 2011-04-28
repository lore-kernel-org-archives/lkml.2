Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1D1Asu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:48:50 -0400
Received: from kroah.org ([198.145.64.141]:59236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab1D1Ase (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:48:34 -0400
Date: Wed, 27 Apr 2011 17:25:52 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 12/25] Staging: hv: Cleanup error handling in
 vmbus_child_device_register()
Message-ID: <20110428002552.GD14294@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-12-git-send-email-kys@microsoft.com>
 <20110426225059.GA12897@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1AF@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD1AF@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 02:11:48AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, April 26, 2011 6:51 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 12/25] Staging: hv: Cleanup error handling in
> > vmbus_child_device_register()
> > 
> > On Tue, Apr 26, 2011 at 09:20:29AM -0700, K. Y. Srinivasan wrote:
> > > Cleanup error handling in vmbus_child_device_register().
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > ---
> > >  drivers/staging/hv/vmbus_drv.c |    7 ++++++-
> > >  1 files changed, 6 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > > index d597dd4..4d569ad 100644
> > > --- a/drivers/staging/hv/vmbus_drv.c
> > > +++ b/drivers/staging/hv/vmbus_drv.c
> > > @@ -720,11 +720,16 @@ int vmbus_child_device_register(struct hv_device
> > *child_device_obj)
> > >  	 */
> > >  	ret = device_register(&child_device_obj->device);
> > >
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  	/* vmbus_probe() error does not get propergate to device_register(). */
> > >  	ret = child_device_obj->probe_error;
> > 
> > Wait, why not?  Why is the probe_error have to be saved off like this?
> > That seems like something is wrong here, this patch should not be
> > needed.
> > 
> > Well, you should check the return value of device_register, that is
> > needed, but this seems broken somehow.
> 
> The current code had comments claiming that the probe error was not
> correctly propagated. Looking at the kernel side of the code, it was not clear
> if device_register() could succeed while the probe might fail.

Of course it can, device_register() has nothing to do with the probe
callback of the device itself.  To think otherwise is to not understand
the driver model and assume things that you should never be caring
about.

Think about it, if you register a device, you don't know at that point
in time if a driver is currently loaded for it, and that it will be
bound to that device.  Nor do you care, as any needed notifications for
new drivers will be sent to userspace, and they will be loaded at some
random time in the future.  So a probe() call might never be called for
this device until some other time, running on some other processor, in
some other thread.

Drivers are allowed to return errors from their probe functions for
valid reasons (i.e. this driver shouldn't bind to this device for a
variety of good reasons.)  No one cares about this, as the driver core
handles it properly and will pass on to the next driver in the list that
might be able to be bound to this device.

So why do you care about the return value of the probe() call?  It gets
properly handled already by the driver core, why would your bus ever
care about it?  (Hint, no other bus does, as it makes no sense.)

> In any event, if you can guarantee that device_register() can return
> any probe related errors, I agree with you that saving the probe error
> is an overkill. The current code saved the probe error and with new
> check I added with regards to the return value of device_register,
> there is no correctness issue with this patch.

As explained above, no, it will not return a probe error, as that makes
no sense.  If the code is wanting to rely on this, it is broken and must
be fixed.

thanks,

greg k-h
