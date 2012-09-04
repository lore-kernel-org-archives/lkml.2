Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2IDNtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab2IDNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:49:06 -0400
Date: Tue, 4 Sep 2012 16:50:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120904135022.GI9805@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 01:28:36PM +0200, Sjur Brændeland wrote:
> Hi Michael,
> 
> >> If an architecture do not support DMA you will get
> >> a link error: "unknown symbol" for dma_alloc_coherent.
> >
> > Yes, it even seems intentional.
> > But I have a question: can the device work without DMA?
> 
> The main dependency is actually on the dma-allocation.
> In my case I do dma_declare_coherent_memory() with
> the memory area shared with the remote device as argument.
> Subsequent calls to dma_alloc_coherent() will then allocate
> from this memory area.
> 
> > Does not VIRTIO_CONSOLE_F_DMA_MEM mean dma api is required?
> 
> Yes.dma_alloc_coherent to work.
> 
> > If yes you should just fail load.
> 
> Agree, I'll check on VIRTIO_CONSOLE_HAS_DMA before adding
> VIRTIO_CONSOLE_F_DMA_MEM to the feature array.
> 
> > Also let's add a wrapper at top of file so ifdefs
> > do not litter the code like this. For example:
> >
> > #ifdef CONFIG_HAS_DMA
> > #define VIRTIO_CONSOLE_HAS_DMA (1)
> > #else
> > #define VIRTIO_CONSOLE_HAS_DMA (0)
> > #endif
> 
> OK, good point. Perhaps we could even exploit gcc's
> ability to remove dead code and do something like this:
> 
>        if (VIRTIO_CONSOLE_HAS_DMA &&
>            virtio_has_feature(vdev, VIRTIO_CONSOLE_F_DMA_MEM)) {
> ...
> 
> This does not give any linker warnings when compiling for UML (no DMA).
> 
> Regards,
> Sjur

Exactly. Though if we just fail load it will be much less code.

Generally, using a feature bit for this is a bit of a problem though:
normally driver is expected to be able to simply ignore
a feature bit. In this case driver is required to
do something so a feature bit is not a good fit.
I am not sure what the right thing to do is.

-- 
MST
