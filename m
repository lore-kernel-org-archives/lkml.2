Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0IXBCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:02:18 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:32870 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0IXBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:02:17 -0400
Date: Thu, 23 Sep 2010 18:02:14 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
Message-ID: <20100924010214.GB2889@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
 <AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
 <20100923201239.GA24391@ovro.caltech.edu>
 <AANLkTik1R-ZPpG5QibWuT1OhUPZr3i_Hr0LMW7D7s6zm@mail.gmail.com>
 <20100923232005.GB25888@ovro.caltech.edu>
 <AANLkTi=tKQBCH6MyftMx_2JMhc+tyX22pnzxpexWm01T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=tKQBCH6MyftMx_2JMhc+tyX22pnzxpexWm01T@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 23 Sep 2010 18:02:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 05:19:27PM -0700, Dan Williams wrote:
> [ copying Linus on this usage of slave_config ]
> 
> On Thu, Sep 23, 2010 at 4:20 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> > On Thu, Sep 23, 2010 at 02:58:06PM -0700, Dan Williams wrote:
> [snip discussion of external slave driver]
> >> Yes, thanks now I recall, and I remember saying something about how
> >> this passes the "Voyager test".  That said it seems odd to carry
> >> symbol exports for something like this.  Instead of exporting can we
> >> exploit the fact that the fpga driver already knows it has a
> >> fsldma_device pointer and do something like:
> >>
> >> struct fsldma_device *fdev = container_of(dma, typeof(fdev), common);
> >>
> >> fdev->slave_alloc();
> >>
> >> This keeps it contained to the fsldma driver.
> >>
> >
> > I agree that it sucks to have exports for this. I'm happy with the
> > static inlines in a header, but AKPM didn't like them.
> >
> > I think the solution above would actually need to be a struct
> > fsldma_chan instead of a struct fsldma_device, but otherwise would work.
> >
> > The caveat with your solution above is that (parts of)
> > drivers/dma/fsldma.h need to be copied into
> > arch/powerpc/include/asm/fsldma.h for the type information. It seems a
> > bit awkward as well.
> >
> > I'd like to propose another possible solution:
> > 1) add an external_control member to struct dma_slave_config
> 
> Will you be using the other slave_config fields, or would it be better
> to have a new dma_crtl_cmd?
> 

I wouldn't need them, no. I'm only interested in the external_start and
request_count features. The Freescale DMA controller doesn't burst if
the "hold src/dst address constant" feature is used. Blame the hardware
guys.

I work around it by having a 4K fifo. All writes which hit the 4K of
address space go into the programmer's fifo. Two scatterlists fill this
requirement nicely: src scatterlist has X bytes of kernel memory, dst
scatterlist has X bytes of 4K entries pointing to the fifo.

Re-reading the description for the struct dma_slave_config (comments
above it), it says that controllers *may* have a custom structure which
they embed this structure inside. Like this:

struct fsldma_slave_config {
	struct dma_slave_config cfg;
	bool external_start;
	unsigned int request_count;
};

I guess that is why device_control() takes an unsigned long argument
instead of a struct dma_slave_config *. I'm happy to do that and not
require another command.

> > 2) remove the list_head from struct fsl_dma_slave
> > 3) remove all of the functions from arch/powerpc/include/asm/fsldma.h
> > 4) add dma_async_memcpy_sg_to_sg()
> >
> > dma_cookie_t dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
> >                                       struct *dst_sg, int dst_nents,
> >                                       struct *src_sg, int src_nents,
> >                                       dma_async_tx_callback cb,
> >                                       void *cb_param);
> >
> > This function would do most of the current work that the current fsldma
> > device_prep_slave_sg() does: setting up a DMA chain to transfer between
> > two scatterlists.
> 
> Ok just wrap it in an ifdef CONFIG_DMAENGINE_SG_TO_SG so it compiles
> away on platforms that don't care about it.  I carried an out-of-tree
> config option CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL for a driver that
> eventually made it upstream, so there is precedent for such a thing.
> 
> I assume it will implement this as a series of calls to prep_slave_sg
> or prep_memcpy and be compatible with other dma drivers?
> 

Yes, it will only use prep_memcpy(). The fsldma driver chains all calls
to prep_memcpy() together until dma_async_memcpy_issue_pending() is
called.

> >
> > I'm willing to do an ugly hack to make a fake scatterlist with my fixed
> > non-incrementing hardware addresses for the dst_sg. Like this:
> >
> > sg_dma_address(sg) = MY_FIXED_ADDRESS_1;
> > sg_dma_len(sg) = MY_FIXED_LENGTH_1;
> > sg = sg_next(sg);
> > sg_dma_address(sg) = MY_FIXED_ADDRESS_2;
> > sg_dma_len(sg) = MY_FIXED_LENGTH_2;
> >
> > Now my driver would look like this:
> >
> > struct dma_slave_config dsc;
> > dsc.external_control = true;
> >
> > /* allocate and fill my dst_sg with the fake data, like above */
> > /* DO NOT use dma_map_sg() on the fake scatterlist */
> > /* allocate and fill my src_sg with pages + data */
> > src_nents = dma_map_sg(..., src_sg, DMA_TO_DEVICE);
> >
> > /* sets up the DMA transfer, but doesn't start it */
> > cookie = dma_async_memcpy_sg_to_sg(chan, dst_sg, dst_nents,
> >                                   src_sg, src_nents,
> >                                   my_cb, my_cb_param);
> >
> > /* puts the DMA engine into external control mode */
> > ret = chan->device_control(chan, DMA_SLAVE_CONFIG, (unsigned long)dsc);
> >
> > /* "start" the transfer */
> > dma_async_memcpy_issue_pending(chan);
> >
> > /*
> >  * start the system controller FPGA programmer, which will toggle the
> >  * DMA engine's external control pins appropriately.
> >  *
> >  * Wait until my callback is called, which will wake up and continue
> >  * the function. Using wait_for_completion_timeout(), etc. Which is
> >  * exactly what I do now.
> >  */
> >
> >
> > The freescale DMA engine must have the external control bit set on every
> > new transaction. It is automatically cleared after a transaction
> > completes.
> 
> I think this meets the spirit of upstream inclusion (documents and
> provides a tested usage model for a piece of hardware), does so using
> common (ish) interfaces, and has intrinsic value outside of enabling
> an out-of-tree driver.
> 

Yep. The fake scatterlist thing is ugly, but I don't have any better
ideas. I'll work on implementing this tomorrow.

Thanks for the feedback,
Ira
