Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1JDQQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:16:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39675 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932303Ab1JDQQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:51 -0400
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
In-Reply-To: <878vp1iqpz.fsf@rustcorp.com.au>
References: <1317217663-32647-1-git-send-email-pawel.moll@arm.com>
	 <878vp1iqpz.fsf@rustcorp.com.au>
Date: Tue, 04 Oct 2011 17:16:42 +0100
Message-ID: <1317745002.3158.340.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 04 Oct 2011 16:16:43.0366 (UTC) FILETIME=[018BC060:01CC82B1]
X-MC-Unique: 111100417164606201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

> > +/* The alignment to use between consumer and producer parts of vring.
> > + * Currently hardcoded to page size. */
> > +#define VIRTIO_MMIO_VRING_ALIGN		PAGE_SIZE
> 
> Really?  Shouldn't that just be 4k?  I haven't seen the qemu side of
> this, but it seems weird to depend on the kernel's idea of page size...

Well, the Host doesn't really care now, as it's told what the alignment
is:

> +       /* Activate the queue */
> +       writel(VIRTIO_MMIO_VRING_ALIGN,
> +                       vm_dev->base + VIRTIO_MMIO_QUEUE_ALIGN);
> +       writel(virt_to_phys(info->queue) >> PAGE_SHIFT,
> +                       vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);

And I've just chosen the PAGE_SIZE instead of 4096 following the
suggestion from your original paper ("Note that there is padding such as
to place this structure on a page separate from the available ring and
descriptor array:").

> Note that the seabios/coreboot hackers wanted a smaller ring alignment
> so they didn't have to waste two precious pages per device.  You might
> want to consider making this an option in the header (perhaps express
> it as log2, eg. 12 rather than 4096).

I had an impression that you were planning to add some API for the
devices to choose the alignment? If so this #define would simply
disappear... Generally, the Client is in control now.

> > +	/* TODO: Write requested queue size to VIRTIO_MMIO_QUEUE_NUM */
> > +
> > +	/* Check if queue is either not available or already active. */
> > +	num = readl(vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> > +	if (!num || readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN)) {
> 
> Please fix this now, like so:
> 
>         /* Queue shouldn't already be set up. */        
>         if (readl(vm_dev->base + VIRTIO_MMIO_QUEUE_PFN))
>                 ...
> 
>         /* Try for a big queue, drop down to a two-page queue. */
>         num = VIRTIO_MMIO_MAX_RING;

Ok, but how much would MAX_RING be? 1024? 513? 127? I really wouldn't
like to be a judge here... I was hoping the device would tell me that
(it knows what amounts of data are likely to be processed?)

>         for (;;) {
>                 size = PAGE_ALIGN(vring_size(num, VIRTIO_MMIO_VRING_ALIGN));
>                 info->queue = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
>                 if (info->queue)
>                         break;
> 
>                 /* Already smallest possible allocation? */
>                 if (size == VIRTIO_MMIO_VRING_ALIGN*2) {
>                         err = -ENOMEM;
>                         goto error_kmalloc;
>                 }
>                 num /= 2;
>         }
and then
	writel(num, vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);

Can do. This, however, gets us back to this question: can the Host
cowardly refuse the requested queue size? If you really think that it
can't, I'm happy to accept that and change the spec accordingly. If it
can, we'll have to read the size back and potentially re-alloc pages...

Cheers!

Paweł


