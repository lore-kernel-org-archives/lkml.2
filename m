Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0IWXUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:20:09 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43104 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0IWXUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:20:08 -0400
Date: Thu, 23 Sep 2010 16:20:06 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
Message-ID: <20100923232005.GB25888@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
 <AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
 <20100923201239.GA24391@ovro.caltech.edu>
 <AANLkTik1R-ZPpG5QibWuT1OhUPZr3i_Hr0LMW7D7s6zm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik1R-ZPpG5QibWuT1OhUPZr3i_Hr0LMW7D7s6zm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 23 Sep 2010 16:20:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:58:06PM -0700, Dan Williams wrote:
> On Thu, Sep 23, 2010 at 1:12 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> > On Thu, Sep 23, 2010 at 11:31:11AM -0700, Dan Williams wrote:
> >> On Tue, Sep 7, 2010 at 1:45 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> >> > The DMA_SLAVE support functions all existed as static inlines in the
> >> > driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
> >> > of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.
> >> >
> >> > At the same time, add the missing linux/list.h header.
> >> >
> >> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> >> > ---
> >> >
> >> > Hello AKPM, Dan,
> >>
> >> Hi, I'm back from paternity leave.
> >>
> >> >
> >> > At AKPM's request, I moved these static inline'd functions into the driver
> >> > code itself, and then EXPORT_SYMBOL_GPL()'d them. I also added a gfp
> >> > parameter to the fsl_dma_slave_alloc() function. And included the
> >> > linux/list.h header.
> >> >
> >> > If you'd like three separate patches, I can do that. The changes were so
> >> > trivial that I lumped all of them into a single patch.
> >> >
> >> > Thanks,
> >> > Ira
> >> >
> >> >  arch/powerpc/include/asm/fsldma.h |   70 +++------------------------------
> >> >  drivers/dma/fsldma.c              |   77 +++++++++++++++++++++++++++++++++++++
> >>
> >> Remind me why we need this header file and these routines again?  git
> >> grep says nothing in-tree is using these?
> >>
> >> I also do not want to proliferate driver specific interfaces.  It
> >> defeats the purpose of having a common dmaengine structure.  Along
> >> these lines Linus W. added the new device_control() method (first
> >> added in commit c3635c78, later tweaked in 05827630).  Could that be
> >> massaged for your needs?
> >>
> >
> > These routines are used by a (currently out of tree) driver that I
> > maintain. Please see the LKML and linuxppc-dev ML post titled:
> > [PATCH RFCv2 0/5] CARMA Board Support
> >
> > The FPGA programming driver uses these interfaces. Past a few initial
> > comments (which I promptly fixed!), it seems that nobody wants to look
> > at this driver. I don't know how to move it towards mainline other than
> > spam people, which I would prefer to avoid doing.
> >
> > The new device_control() method doesn't have enough information for this
> > purpose. I also don't know of any other DMA controllers that have the
> > feature I'm using (described below).
> >
> > The fsldma controller has the option of being controlled by an external
> > device, via some pins. This is leveraged by our system controller to
> > properly program some big data processing FPGAs.
> >
> > Basically, the fsldma controller must be told:
> > 1) descriptors (src, dst, len tuples)
> > 2) use the external-start feature (external control)
> > 3) go
> >
> > Now #3's "go" doesn't actually start the transfer. It just starts
> > listening on the external pins for the correct sequence for each
> > transaction.
> >
> > Also, the descriptors must be set up such that they form a single chain,
> > without interruptions between segments. Back at the beginning of the
> > year, I did a lot of work on the fsldma driver. It *should* be able to
> > chain DMA transfers appropriately for this mode using the existing
> > device_prep_dma_memcpy() routine.
> >
> > This means that it would be possible to move some of the functionality
> > of fsldma's device_prep_slave_sg() into core DMAEngine code, and
> > implement something like dma_memcpy_sg_to_sg(). This would take two
> > scatterlists and call device_prep_slave_sg() enough times to setup a DMA
> > operation that will move all data appropriately.
> >
> > This is exactly what fsldma's device_prep_slave_sg() actually does. It
> > was non-trivial to get the triply nested loops correct.
> >
> > As an example from my driver, I have this scenario:
> > 1) a scatterlist of kernel memory pages (this is my data payload)
> > 2) a fixed set of non-incrementing physical addresses I need to send that data to
> >
> > Other than the fsldma device_prep_slave_sg(), this is difficult to do.
> >
> > I hope that helps to explain the problem.
> 
> Yes, thanks now I recall, and I remember saying something about how
> this passes the "Voyager test".  That said it seems odd to carry
> symbol exports for something like this.  Instead of exporting can we
> exploit the fact that the fpga driver already knows it has a
> fsldma_device pointer and do something like:
> 
> struct fsldma_device *fdev = container_of(dma, typeof(fdev), common);
> 
> fdev->slave_alloc();
> 
> This keeps it contained to the fsldma driver.
> 

I agree that it sucks to have exports for this. I'm happy with the
static inlines in a header, but AKPM didn't like them.

I think the solution above would actually need to be a struct
fsldma_chan instead of a struct fsldma_device, but otherwise would work.

The caveat with your solution above is that (parts of)
drivers/dma/fsldma.h need to be copied into
arch/powerpc/include/asm/fsldma.h for the type information. It seems a
bit awkward as well.

I'd like to propose another possible solution:
1) add an external_control member to struct dma_slave_config
2) remove the list_head from struct fsl_dma_slave
3) remove all of the functions from arch/powerpc/include/asm/fsldma.h
4) add dma_async_memcpy_sg_to_sg()

dma_cookie_t dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
				       struct *dst_sg, int dst_nents,
				       struct *src_sg, int src_nents,
				       dma_async_tx_callback cb,
				       void *cb_param);

This function would do most of the current work that the current fsldma
device_prep_slave_sg() does: setting up a DMA chain to transfer between
two scatterlists.

I'm willing to do an ugly hack to make a fake scatterlist with my fixed
non-incrementing hardware addresses for the dst_sg. Like this:

sg_dma_address(sg) = MY_FIXED_ADDRESS_1;
sg_dma_len(sg) = MY_FIXED_LENGTH_1;
sg = sg_next(sg);
sg_dma_address(sg) = MY_FIXED_ADDRESS_2;
sg_dma_len(sg) = MY_FIXED_LENGTH_2;

Now my driver would look like this:

struct dma_slave_config dsc;
dsc.external_control = true;

/* allocate and fill my dst_sg with the fake data, like above */
/* DO NOT use dma_map_sg() on the fake scatterlist */
/* allocate and fill my src_sg with pages + data */
src_nents = dma_map_sg(..., src_sg, DMA_TO_DEVICE);

/* sets up the DMA transfer, but doesn't start it */
cookie = dma_async_memcpy_sg_to_sg(chan, dst_sg, dst_nents,
				   src_sg, src_nents,
				   my_cb, my_cb_param);

/* puts the DMA engine into external control mode */
ret = chan->device_control(chan, DMA_SLAVE_CONFIG, (unsigned long)dsc);

/* "start" the transfer */
dma_async_memcpy_issue_pending(chan);

/*
 * start the system controller FPGA programmer, which will toggle the
 * DMA engine's external control pins appropriately.
 *
 * Wait until my callback is called, which will wake up and continue
 * the function. Using wait_for_completion_timeout(), etc. Which is
 * exactly what I do now.
 */


The freescale DMA engine must have the external control bit set on every
new transaction. It is automatically cleared after a transaction
completes.

Ira
