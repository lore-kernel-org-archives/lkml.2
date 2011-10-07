Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab1JGQMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:12:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:54966 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1JGQM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:12:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Date: Fri, 7 Oct 2011 09:12:11 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6BC1@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CABE8wwuB2HxpjWiOjASizL5L6LU2_AHhLZnAJyey__hh1jfX8Q@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Thread-Index: AcyDnseBe81l4gHOTbimI0MHa0/BZgBXojVQ
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com><1317492077.1573.1839.camel@vkoul-udesk3><0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com> <CABE8wwuB2HxpjWiOjASizL5L6LU2_AHhLZnAJyey__hh1jfX8Q@mail.gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Dave Jiang <dave.jiang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan J Williams wrote:
> 
> On Mon, Oct 3, 2011 at 9:52 AM, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> >
> > My concern here is that other subsystems may use/request DMA_SLAVE
channel(s) as well
> > and wrongfully acquire one that belongs to RapidIO. In this case
separation with another
> > flag may have a sense - it is possible to have a system that uses
RapidIO
> > and other "traditional" DMA slave channel.
> >
> > This is why I put that proposed interface for discussion instead of
keeping everything
> > inside of RapidIO.
> > If you think that situation above will not happen I will be happy to
remove
> > that subsystem knowledge from dmaengine files.
> 
> I don't think that situation will happen, even on the same arch I
> don't think DMA_SLAVE is ready to be enabled generically.  So you're
> probably safe here.

Thank you for confirmation. I will rely on DMA_SLAVE only as in my most
recent
version. 
 
> >
> > I agree, this is not a case of "pure" slave transfers but existing
DMA_SLAVE
> > interface fits well into the RapidIO operations.
> >
> > First, we have only one memory mapped location on the host side. We
transfer
> > data to/from location that is not mapped into memory on the same
side.
> >
> > Second, having ability to pass private target information allows me
to pass
> > information about remote target device on per-transfer basis.
> 
> ...but there is no expectation that these engines will be generically
> useful to other subsytems.  To be clear you are just using dmaengine
> as a match making service for your dma providers to clients, right?

Not only that. As an example I am offering other defined DMA slave mode
callbacks
in tsi721_dma driver. I think that RapidIO specific DMA channels should
follow
unified DMA engine interface. I am expecting that other DMA defined
functions
to be used directly without RapidIO specifics. E.g. tx_submit, tx_status
and
issue_pending are implemented in tsi721_dma driver. Similar approach may
be
applied to fsl_dma driver which is capable to RapidIO data transfers on
platforms
with RapidIO interface. 

> > ... skip ...
> > RapidIO network usually has more than one device attached to it and
> > single DMA channel may service data transfers to/from several
devices.
> > In this case device information should be passed on per-transfer
basis.
> >
> 
> You could maybe do what async_tx does and just apply the extra context
> after the ->prep(), but before ->submit(), but it looks like that
> context is critical to setting up the operation.

Yes, it is possible to do but does not look as quite safe and effective
as passing all related parameters during single call. This would require
RIO DMA drivers to hold a "half cooked" descriptor chain until next
portion
of information arrives. This requires to have prep and post-configure
calls
coupled together by locks. In this situation prep with private data
looks
safer and more effective.    

> This looks pretty dangerous without knowing the other details.  What
> prevents another thread from changing dchan->private before the the
> prep routine reads it?

Yes, locking is needed in rio_dma_prep_slave_sg() around a call for prep
routine. After all internal descriptors are set dchan can be submitted
with new private content.  

> 
> DMA_SLAVE assumes a static relationship between dma device and
> slave-device, instead this rapid-io case is a per-operation slave
> context.  It sounds like you really do want a new dma operation type
> that is just an extra-parameter version of the current
> ->device_prep_slave_sg.  But now we're getting into to
> dma_transaction_type proliferation again.  This is probably more fuel
> for the fire of creating a structure transfer template that defines
> multiple possible operation types and clients just fill in the fields
> that they need, rather than adding new operation types for every
> possible permutation of copy operation (DMA_SLAVE, DMA_MEMCPY,
> DMA_CYCLIC, DMA_SG, DMA_INTERLEAVE, DMA_RAPIDIO), it's getting to be a
> bit much.

Exactly. I need an ability of passing private parameter to prep
function.
I chose to adopt DMA engine interface instead of adding one completely
internal to RapidIO because having one common API has much more sense.
Passing user defined data structure when building individual request
would
make not only my life easier but probably will help some other drivers
as well.   
 
> As a starting point, since this the first driver proposal to have
> per-operation slave context and there are other rapid-io specific
> considerations, maybe it's ok to have a rio_dma_prep_slave_sg() that
> does something like:
> 
> struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
> 
> bdma_chan->prep_sg(rext, sgl, sg_len, direction, flags);
> 
> Thoughts?

This brings HW dependence into generic RapidIO layer.
I would like to see it as a generic interface that is available
to other RIO-capable devices (e.g Freescale's 85xx and QorIQ).

I would probably make  ->prep_sg callback part of rio_mport structure
(which holds dma_device). In this case HW will be well abstracted.
The only problem will be with registering with DMA engine but this can
be solved by providing a pointer to a stub routine.

Second option may be keeping rio_dma_prep_slave_sg() "as is" but with an
appropriate
locking as I mentioned above (maybe remove "slave" from its name to
reduce confusion).

Thank you,

Alex.

