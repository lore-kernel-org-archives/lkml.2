Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2ICU0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2ICU0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:26:21 -0400
Date: Mon, 3 Sep 2012 23:27:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120903202737.GD6181@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 04:57:45PM +0200, Sjur Brændeland wrote:
> Hi Michael,
> 
> > How does access to descriptors work in this setup?
> 
> When the ring is setup by remoteproc the descriptors are
> also allocated using dma_alloc_coherent().
> 
> >> -static void free_buf(struct port_buffer *buf)
> >> +/* Allcoate data buffer from DMA memory if requested */
> >
> > typo
> 
> Thanks.
> 
> >> +static inline void *
> >> +alloc_databuf(struct virtio_device *vdev, size_t size, dma_addr_t *dma_handle,
> >> +                gfp_t flag)
> >>  {
> >> -     kfree(buf->buf);
> >> +#ifdef CONFIG_HAS_DMA
> >> +     if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_DMA_MEM)) {
> >> +             struct device *dev = &vdev->dev;
> >> +             /*
> >> +              * Allocate DMA memory from ancestors. Finding the ancestor
> >> +              * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
> >> +              * implemented.
> >> +              */
> >> +             dev = dev->parent ? dev->parent : dev;
> >> +             dev = dev->parent ? dev->parent : dev;
> >> +             return dma_alloc_coherent(dev, size, dma_handle, flag);
> >> +     }
> >> +#endif
> >
> > Are these ifdefs really needed? If DMA_MEM is set,
> > can't we use dma_alloc_coherent
> > unconditionally?
> 
> If an architecture do not support DMA you will get
> a link error: "unknown symbol" for dma_alloc_coherent.
> 
> Regards,
> Sjur

Yes, it even seems intentional.
But I have a question: can the device work without DMA?
Does not VIRTIO_CONSOLE_F_DMA_MEM mean dma api is required?
If yes you should just fail load.

Also let's add a wrapper at top of file so ifdefs
do not litter the code like this. For example:

#ifdef CONFIG_HAS_DMA
#define VIRTIO_CONSOLE_HAS_DMA (1)
#else
#define VIRTIO_CONSOLE_HAS_DMA (0)
#endif

Now use if instead of ifdef.

-- 
MST
