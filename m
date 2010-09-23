Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0IWUMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:12:52 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35584 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0IWUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:12:51 -0400
Date: Thu, 23 Sep 2010 13:12:39 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
Message-ID: <20100923201239.GA24391@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
 <AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 23 Sep 2010 13:12:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:31:11AM -0700, Dan Williams wrote:
> On Tue, Sep 7, 2010 at 1:45 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> > The DMA_SLAVE support functions all existed as static inlines in the
> > driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
> > of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.
> >
> > At the same time, add the missing linux/list.h header.
> >
> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> > ---
> >
> > Hello AKPM, Dan,
> 
> Hi, I'm back from paternity leave.
> 
> >
> > At AKPM's request, I moved these static inline'd functions into the driver
> > code itself, and then EXPORT_SYMBOL_GPL()'d them. I also added a gfp
> > parameter to the fsl_dma_slave_alloc() function. And included the
> > linux/list.h header.
> >
> > If you'd like three separate patches, I can do that. The changes were so
> > trivial that I lumped all of them into a single patch.
> >
> > Thanks,
> > Ira
> >
> >  arch/powerpc/include/asm/fsldma.h |   70 +++------------------------------
> >  drivers/dma/fsldma.c              |   77 +++++++++++++++++++++++++++++++++++++
> 
> Remind me why we need this header file and these routines again?  git
> grep says nothing in-tree is using these?
> 
> I also do not want to proliferate driver specific interfaces.  It
> defeats the purpose of having a common dmaengine structure.  Along
> these lines Linus W. added the new device_control() method (first
> added in commit c3635c78, later tweaked in 05827630).  Could that be
> massaged for your needs?
> 

These routines are used by a (currently out of tree) driver that I
maintain. Please see the LKML and linuxppc-dev ML post titled:
[PATCH RFCv2 0/5] CARMA Board Support

The FPGA programming driver uses these interfaces. Past a few initial
comments (which I promptly fixed!), it seems that nobody wants to look
at this driver. I don't know how to move it towards mainline other than
spam people, which I would prefer to avoid doing.

The new device_control() method doesn't have enough information for this
purpose. I also don't know of any other DMA controllers that have the
feature I'm using (described below).

The fsldma controller has the option of being controlled by an external
device, via some pins. This is leveraged by our system controller to
properly program some big data processing FPGAs.

Basically, the fsldma controller must be told:
1) descriptors (src, dst, len tuples)
2) use the external-start feature (external control)
3) go

Now #3's "go" doesn't actually start the transfer. It just starts
listening on the external pins for the correct sequence for each
transaction.

Also, the descriptors must be set up such that they form a single chain,
without interruptions between segments. Back at the beginning of the
year, I did a lot of work on the fsldma driver. It *should* be able to
chain DMA transfers appropriately for this mode using the existing
device_prep_dma_memcpy() routine.

This means that it would be possible to move some of the functionality
of fsldma's device_prep_slave_sg() into core DMAEngine code, and
implement something like dma_memcpy_sg_to_sg(). This would take two
scatterlists and call device_prep_slave_sg() enough times to setup a DMA
operation that will move all data appropriately.

This is exactly what fsldma's device_prep_slave_sg() actually does. It
was non-trivial to get the triply nested loops correct.

As an example from my driver, I have this scenario:
1) a scatterlist of kernel memory pages (this is my data payload)
2) a fixed set of non-incrementing physical addresses I need to send that data to

Other than the fsldma device_prep_slave_sg(), this is difficult to do.

I hope that helps to explain the problem.

Ira
