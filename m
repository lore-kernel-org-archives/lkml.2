Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2IDOMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab2IDOMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:12:07 -0400
Date: Tue, 4 Sep 2012 17:13:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] virtio: Don't access device data after unregistration.
Message-ID: <20120904141321.GJ9805@redhat.com>
References: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903141445.GA5054@redhat.com>
 <CAJK669aRsbOOmjmT+K8OHYvenOhkYWuSOx6nBM7hxC_C4mmw-g@mail.gmail.com>
 <20120903201847.GC6181@redhat.com>
 <CAJK669ZVHOZVEw+1UeLU5KyxZexGfWC0VPnrK5XZd9x935PznQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669ZVHOZVEw+1UeLU5KyxZexGfWC0VPnrK5XZd9x935PznQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:12:33PM +0200, Sjur Brændeland wrote:
> Hi Michael,
> 
> >> >> Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.
> >> >
> >> > What's the root cause of the panic?
> >>
> >> I believe the cause of the panic is calling
> >> ida_simple_remove(&virtio_index_ida, dev->index);
> >> when the dev structure is "poisoned" after kfree.
> >> It might be the "BUG_ON((int)id < 0)" that bites...
> >>
> >> >> Use device_del() and put_device() instead of
> >> >> device_unregister(), and access device data before
> >> >> calling put_device().
> >>
> >> > Why does this help? Does device_unregister free the
> >> > device so dev->index access crashes?
> >>
> >> Yes, if device ref-count is one when calling unregister
> >> the device is freed.
> >
> > Interesting. Where exactly?...
> 
> I was wrong here, the reason is not related to ref-count being
> above one. The reason this issue do not show up in virtio_pci
> is that the release function is a dummy:
> 
> [snip]
> static void virtio_pci_release_dev(struct device *_d)
> {
> 	/*
> 	 * No need for a release method as we allocate/free
> 	 * all devices together with the pci devices.
> 	 * Provide an empty one to avoid getting a warning from core.
> 	 */
> }
> 
> The device structure uses a kref for reference counting the device.
> In virtio_pci() the release function virtio_pci_release_dev()
> will be called when the device is unregistered, but because the
> release function is dummy, data isn't freed or reset at this point.
> So for virtio devices created from virtio_pci my patch is not
> currently needed.
> 
> However, empty release functions are not the preferred way, e.g look at
> https://lkml.org/lkml/2012/4/3/301
> 
> [Greg K.H:]
> > > > > +static void hsi_port_release(struct device *dev __maybe_unused)
> > > > > +{
> > > > > +}
> > > >
> > > > As per the documentation in the kernel tree, I get to mock you
> > > > mercilessly for doing something as foolish as this.  You are not smarter
> > > > than the kernel and don't think that you got rid of the kernel warning
> > > > properly by doing this.  Do you think that I wrote that code for no good
> > > > reason?  The kernel was being nice and telling you what you did wrong,
> > > > don't try to fake it out, it's smarter than you are here.
> 
> But remoteproc frees the device memory in the release function
> rproc_vdev_release() and needs this patch.
> 
> Regards,
> Sjur


Okay, so let's add a comment in virtio in unregister
function. Also slightly preferable to just use device_unregister
IMHO. Something like the below?

	/*
	   device_unregister drops reference to device so put_device could
	   invoke release callback. In case that callback will free the device,
	   make sure we don't access device after this call.
	 */

	int index = dev->index;
        device_unregister(&dev->dev);
        ida_simple_remove(&virtio_index_ida, index);

-- 
MST
