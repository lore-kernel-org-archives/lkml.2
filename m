Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab1JEUiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:38:24 -0400
Received: from mga07.intel.com ([143.182.124.22]:22456 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756743Ab1JEUiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	<1317492077.1573.1839.camel@vkoul-udesk3>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
Date: Wed, 5 Oct 2011 13:38:21 -0700
Message-ID: <CABE8wwuB2HxpjWiOjASizL5L6LU2_AHhLZnAJyey__hh1jfX8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Vinod Koul <vinod.koul@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 9:52 AM, Bounine, Alexandre
<Alexandre.Bounine@idt.com> wrote:
> Vinod Koul wrote:
>>
>> On Fri, 2011-09-30 at 17:38 -0400, Alexandre Bounine wrote:
>> Please CC *maintainers* on your patches, get_maintainers.pl will tell
>> you who. Adding Dan here
>
> Based on https://lkml.org/lkml/2011/2/14/67 and use of DMA_SLAVE in this
> patch I decided that you are the best match among two and there is no reason
> to disturb Dan ;)
>
>> > Adds DMA Engine framework support into RapidIO subsystem.
>> > Uses DMA Engine DMA_SLAVE interface to generate data transfers to/from remote
>> > RapidIO target devices. Uses scatterlist to describe local data buffer and
>> > dma_chan.private member to pass target specific information. Supports flat
>> > data buffer only for a remote side.
>> The way dmaengine works today is that it doesn't know anything about
>> client subsystem. But this brings in a subsystem details to dmaengine
>> which I don't agree with yet.
>> Why can't we abstract this out??
>
> The only thing that brings subsystem knowledge into dmaengine is DMA_RAPIDIO flag.
> I am actually on the fence about this. From RapidIO side point of view I do not
> need that flag at all.
> RapidIO uses a filter routine that is sufficient to identify dmaengine channels
> associated with specific RapidIO mport. Use of DMA_SLAVE flag is safe here.
> Use of private member of dma_chan is "private" business of RapidIO and does
> not break anything.
>
> My concern here is that other subsystems may use/request DMA_SLAVE channel(s) as well
> and wrongfully acquire one that belongs to RapidIO. In this case separation with another
> flag may have a sense - it is possible to have a system that uses RapidIO
> and other "traditional" DMA slave channel.
>
> This is why I put that proposed interface for discussion instead of keeping everything
> inside of RapidIO.
> If you think that situation above will not happen I will be happy to remove
> that subsystem knowledge from dmaengine files.

I don't think that situation will happen, even on the same arch I
don't think DMA_SLAVE is ready to be enabled generically.  So you're
probably safe here.

> My most recent test implementation runs without DMA_RAPIDIO flag though.
>
>>
>> After going thru the patch, I do not believe that this this is case of
>> SLAVE transfers, Dan can you please take a look at this patch
>
> I agree, this is not a case of "pure" slave transfers but existing DMA_SLAVE
> interface fits well into the RapidIO operations.
>
> First, we have only one memory mapped location on the host side. We transfer
> data to/from location that is not mapped into memory on the same side.
>
> Second, having ability to pass private target information allows me to pass
> information about remote target device on per-transfer basis.

...but there is no expectation that these engines will be generically
useful to other subsytems.  To be clear you are just using dmaengine
as a match making service for your dma providers to clients, right?

>
>>
>>
>> > Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
>> > Cc: Vinod Koul <vinod.koul@intel.com>
>> > Cc: Kumar Gala <galak@kernel.crashing.org>
>> > Cc: Matt Porter <mporter@kernel.crashing.org>
>> > Cc: Li Yang <leoli@freescale.com>
>> > ---
>> >  drivers/dma/dmaengine.c   |    4 ++
> ... skip ...
>> > +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
>> > +
>> > +#include <linux/dmaengine.h>
>> > +
> ... skip ...
>> > + */
>> > +struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
>> > +   struct dma_chan *dchan, struct rio_dma_data *data,
>> > +   enum dma_data_direction direction, unsigned long flags)
>> > +{
>> > +   struct dma_async_tx_descriptor *txd = NULL;
>> > +   struct rio_dma_ext rio_ext;
>> > +
>> > +   rio_ext.destid = rdev->destid;
>> > +   rio_ext.rio_addr_u = data->rio_addr_u;
>> > +   rio_ext.rio_addr = data->rio_addr;
>> > +   rio_ext.wr_type = data->wr_type;
>> > +   dchan->private = &rio_ext;
>> > +
>> > +   txd = dchan->device->device_prep_slave_sg(dchan, data->sg, data-
>> >sg_len,
>> > +                                             direction, flags);
>> > +
>> > +   return txd;
>> > +}
>> > +EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
>> You should move the rdev and data to dma_slave_config, that way you
>> should be able to use the existing _prep_slave_sg function.
>
> RapidIO network usually has more than one device attached to it and
> single DMA channel may service data transfers to/from several devices.
> In this case device information should be passed on per-transfer basis.
>

You could maybe do what async_tx does and just apply the extra context
after the ->prep(), but before ->submit(), but it looks like that
context is critical to setting up the operation.

This looks pretty dangerous without knowing the other details.  What
prevents another thread from changing dchan->private before the the
prep routine reads it?

DMA_SLAVE assumes a static relationship between dma device and
slave-device, instead this rapid-io case is a per-operation slave
context.  It sounds like you really do want a new dma operation type
that is just an extra-parameter version of the current
->device_prep_slave_sg.  But now we're getting into to
dma_transaction_type proliferation again.  This is probably more fuel
for the fire of creating a structure transfer template that defines
multiple possible operation types and clients just fill in the fields
that they need, rather than adding new operation types for every
possible permutation of copy operation (DMA_SLAVE, DMA_MEMCPY,
DMA_CYCLIC, DMA_SG, DMA_INTERLEAVE, DMA_RAPIDIO), it's getting to be a
bit much.

As a starting point, since this the first driver proposal to have
per-operation slave context and there are other rapid-io specific
considerations, maybe it's ok to have a rio_dma_prep_slave_sg() that
does something like:

struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);

bdma_chan->prep_sg(rext, sgl, sg_len, direction, flags);

Thoughts?
