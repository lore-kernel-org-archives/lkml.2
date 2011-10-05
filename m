Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab1JEKGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:06:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38355 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932096Ab1JEKGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:06:37 -0400
Subject: Re: [PATCH] virtio: Add platform bus driver for memory mapped
 virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
In-Reply-To: <87aa9ggs4k.fsf@rustcorp.com.au>
References: <1317217663-32647-1-git-send-email-pawel.moll@arm.com>
	 <878vp1iqpz.fsf@rustcorp.com.au>
	 <1317745002.3158.340.camel@hornet.cambridge.arm.com>
	 <87aa9ggs4k.fsf@rustcorp.com.au>
Date: Wed, 05 Oct 2011 11:06:30 +0100
Message-ID: <1317809190.3158.352.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 05 Oct 2011 10:06:30.0671 (UTC) FILETIME=[742939F0:01CC8346]
X-MC-Unique: 111100511063304801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I had an impression that you were planning to add some API for the
> > devices to choose the alignment? If so this #define would simply
> > disappear... Generally, the Client is in control now.
> 
> I'm not sure it makes sense to vary per-device, but per-OS perhaps.

It's sorted then - the Guest implementation chooses the alignment, the
Host is informed about it, everyone is happy :-)

> > > > +	/* TODO: Write requested queue size to VIRTIO_MMIO_QUEUE_NUM */
> > > > +
> > > > +	/* Check if queue is either not available or already active. */
> > > > +	num = readl(vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> > > > +	if (!num || readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN)) {
> > > 
> > > Please fix this now, like so:
> > > 
> > >         /* Queue shouldn't already be set up. */        
> > >         if (readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN))
> > >                 ...
> > > 
> > >         /* Try for a big queue, drop down to a two-page queue. */
> > >         num = VIRTIO_MMIO_MAX_RING;
> > 
> > Ok, but how much would MAX_RING be? 1024? 513? 127? I really wouldn't
> > like to be a judge here... I was hoping the device would tell me that
> > (it knows what amounts of data are likely to be processed?)
> 
> I'm not sure who knows better, device or driver.  The device can suggest
> a value, but you should always write it, otherwise that code will never
> get tested until it's too late...
> 
> > >         for (;;) {
> > >                 size = PAGE_ALIGN(vring_size(num, VIRTIO_MMIO_VRING_ALIGN));
> > >                 info->queue = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
> > >                 if (info->queue)
> > >                         break;
> > > 
> > >                 /* Already smallest possible allocation? */
> > >                 if (size == VIRTIO_MMIO_VRING_ALIGN*2) {
> > >                         err = -ENOMEM;
> > >                         goto error_kmalloc;
> > >                 }
> > >                 num /= 2;
> > >         }
> > and then
> > 	writel(num, vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> > 
> > Can do. This, however, gets us back to this question: can the Host
> > cowardly refuse the requested queue size? If you really think that it
> > can't, I'm happy to accept that and change the spec accordingly. If it
> > can, we'll have to read the size back and potentially re-alloc pages...
> 
> I'm not sure.  Perhaps the device gives the maximum it will accept, and
> the driver should start from that or 1025, whatever is less (that's
> still 28k for each ring).  That gives us flexibility.

Ok, So I'll add sort of "QUEUE_NUM_MAX" read-only register in the device
spec and use min(device_max, driver_max) as a base for the pages
allocation, then notify the Host about the queue size as done with the
alignment.

Patch v2 to follow shortly.

Cheers!

Paweł


