Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab1JEBQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:16:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab1JEBQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:16:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "peter.maydell\@linaro.org" <peter.maydell@linaro.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio: Add platform bus driver for memory mapped virtio device
In-Reply-To: <1317745002.3158.340.camel@hornet.cambridge.arm.com>
References: <1317217663-32647-1-git-send-email-pawel.moll@arm.com> <878vp1iqpz.fsf@rustcorp.com.au> <1317745002.3158.340.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 05 Oct 2011 11:40:51 +1030
Message-ID: <87aa9ggs4k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Oct 2011 17:16:42 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> Greetings!
> 
> > > +/* The alignment to use between consumer and producer parts of vring.
> > > + * Currently hardcoded to page size. */
> > > +#define VIRTIO_MMIO_VRING_ALIGN		PAGE_SIZE
> > 
> > Really?  Shouldn't that just be 4k?  I haven't seen the qemu side of
> > this, but it seems weird to depend on the kernel's idea of page size...
> 
> Well, the Host doesn't really care now, as it's told what the alignment
> is:
> 
> > +       /* Activate the queue */
> > +       writel(VIRTIO_MMIO_VRING_ALIGN,
> > +                       vm_dev->base + VIRTIO_MMIO_QUEUE_ALIGN);
> > +       writel(virt_to_phys(info->queue) >> PAGE_SHIFT,
> > +                       vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
> 
> And I've just chosen the PAGE_SIZE instead of 4096 following the
> suggestion from your original paper ("Note that there is padding such as
> to place this structure on a page separate from the available ring and
> descriptor array:").

Sorry, I missed that.  OK!

> > Note that the seabios/coreboot hackers wanted a smaller ring alignment
> > so they didn't have to waste two precious pages per device.  You might
> > want to consider making this an option in the header (perhaps express
> > it as log2, eg. 12 rather than 4096).
> 
> I had an impression that you were planning to add some API for the
> devices to choose the alignment? If so this #define would simply
> disappear... Generally, the Client is in control now.

I'm not sure it makes sense to vary per-device, but per-OS perhaps.

> > > +	/* TODO: Write requested queue size to VIRTIO_MMIO_QUEUE_NUM */
> > > +
> > > +	/* Check if queue is either not available or already active. */
> > > +	num = readl(vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> > > +	if (!num || readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN)) {
> > 
> > Please fix this now, like so:
> > 
> >         /* Queue shouldn't already be set up. */        
> >         if (readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN))
> >                 ...
> > 
> >         /* Try for a big queue, drop down to a two-page queue. */
> >         num = VIRTIO_MMIO_MAX_RING;
> 
> Ok, but how much would MAX_RING be? 1024? 513? 127? I really wouldn't
> like to be a judge here... I was hoping the device would tell me that
> (it knows what amounts of data are likely to be processed?)

I'm not sure who knows better, device or driver.  The device can suggest
a value, but you should always write it, otherwise that code will never
get tested until it's too late...

> >         for (;;) {
> >                 size = PAGE_ALIGN(vring_size(num, VIRTIO_MMIO_VRING_ALIGN));
> >                 info->queue = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
> >                 if (info->queue)
> >                         break;
> > 
> >                 /* Already smallest possible allocation? */
> >                 if (size == VIRTIO_MMIO_VRING_ALIGN*2) {
> >                         err = -ENOMEM;
> >                         goto error_kmalloc;
> >                 }
> >                 num /= 2;
> >         }
> and then
> 	writel(num, vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> 
> Can do. This, however, gets us back to this question: can the Host
> cowardly refuse the requested queue size? If you really think that it
> can't, I'm happy to accept that and change the spec accordingly. If it
> can, we'll have to read the size back and potentially re-alloc pages...

I'm not sure.  Perhaps the device gives the maximum it will accept, and
the driver should start from that or 1025, whatever is less (that's
still 28k for each ring).  That gives us flexibility.

The absolute maximum is a ring of 32k elements, which is about 850k.
That seems a little excessive, though.

Cheers,
Rusty.
