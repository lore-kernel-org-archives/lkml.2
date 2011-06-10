Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1FJKWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:22:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36219 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1FJKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:22:11 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan <dan.j.williams@intel.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 10 Jun 2011 15:51:41 +0530
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave transfer
Thread-Topic: [RFC] dmaengine: add new api for preparing simple slave
 transfer
Thread-Index: AcwnOm/f8gE2PXWgQhWTnYPjyRs7MAACMjSg
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	 <20110609124723.GA24636@n2100.arm.linux.org.uk>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	 <20110609163206.GB24636@n2100.arm.linux.org.uk>
 <1307686397.10976.116.camel@vkoul-udesk3>
In-Reply-To: <1307686397.10976.116.camel@vkoul-udesk3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5AAMNfC031803

I think I should have tried to explain my case with a specific example.
I tried to generalize it and it has confused and misled every one.
I have tried again now. :)

<snip>
> > > A simple single buffer transfer (i.e. non sg transfer) can be done only
> > > as a trivial case of the device_prep_slave_sg API. The client driver is
> > > expected to prepare a sg list and provide to the dmaengine API for that
> > > single buffer also.
> > 
> > We can avoid preparing a sg list in every driver which wants this by
> > having dmaengine.h provide a helper for this case:
> > 
> > static inline dma_async_tx_descriptor *dmaengine_prep_slave_single(
> > 	struct dma_chan *chan, void *buf, size_t len,
> > 	enum dma_data_direction dir, unsigned long flags)
> > {
> > 	struct scatterlist sg;
> > 
> > 	sg_init_one(&sg, buf, len);
> > 
> > 	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
> > }
> That sounds good...

Yes, this should be sufficient if the only aim is to avoid preparing a sg list
in every driver which wants to transfer a single buffer.

But my main aim was to add more buffer related details to the API.
I have tried to explain a use case below, where this will be useful.

<snip>
> >
> > I think also providing dmaengine_prep_slave_sg() and
> > dmaengine_prep_dma_cyclic() as wrappers to hide the chan-> >device->blah
> > bit would also be beneficial (and helps keep that detail out of the
> > users of DMA engine.)
> >

Yes, this would really be helpful if someone is just looking at the 
client drivers and are not familiar with the dmaengine's 
internal data structures.

> > > In a slave transfer, the client has to define all the buffer related
> > > attributes and the peripheral related attributes.
> >
> > I'd argue that it is incorrect to have drivers specify the buffer
> > related attributes - that makes the API unnecessarily complicated
> > to use, requiring two calls (one to configure the channel, and one
> > to prepare the transfer) each time it needs to be used.

I am not able to understand why 2 calls will be required?
Client configures the slave using dma_slave_config only once.
If the direction flag is removed then, this configuration doesnâ€™t
have to be modified at all.

<quote>
> So I think the slave transfer API must also have a provision to pass 
> the buffer configuration. The buffer attributes have to be passed 
> directly as an argument in the prepare API, unlike dma_slave_config 
> as they will be different for each buffer that is going to be 
> transferred.
</quote>

The API is called only once in the current framework to prepare 
the descriptor.
After adding any extra arguments in the prepare API, client will
still have to call it only once.

> >
> > Not only that but the memory side of the transfer should be no business
> > of the driver - the driver itself should only specify the attributes
> > for the device being driven.  The attributes for the memory side of the
> > transfer should be a property of the DMA engine itself.
> >

Yes Russell, you are correct. Attributes of the memory side should
be a property of DMA engine itself.

What is meant here is that, client has told the DMAC how to 
write to/ read from the slave peripheral by defining all the slave
properties in the dma_slave_config.

It is assumed that the buffer side has to be read/written to 
byte after byte continuously by the DMAC. 
I wanted to say client must have provisions to pass the details 
on how it wants the DMAC to read/ write to the 
buffer, if the capability is available in the DMAC.

DMACs have the capability to auto increment the 
source/destination address accordingly after transferring
a byte of data and they automatically read/write to the
next byte location. In some DMACs you can program an offset also. 
They read x bytes, skip y bytes and read the next x bytes.
This detail will be passed to the client driver by the application.
Then it is for the slave driver to communicate this to the
DMA engine, right?

> > I would like to see in the long term the dma_slave_config structure
> > lose its 'direction' argument, and the rest of the parameters used to
> > define the device side parameters only.
> I am not sure why direction flag is required and can be done away with.
> Both sg and cyclic API have a direction parameter and that should be
> used. A channel can be used in any direction client wishes to.

I also agree. The direction flag in the dma_slave_config is redundant.
As Russell had already mentioned in another thread, this redundancy
forces DMAC drivers to check if the direction flag in the 
dma_slave_config is same as that passed to the prepare API.

Also client drivers have to keep modifying the dma_slave_config
every time before they make a direction change in transfer.

> >
> > > But many a times a client may want to transfer from a single buffer to
> > > the peripheral and most of the DMA controllers have the capability to
> > > transfer data in chunks/frames directly at a stretch.
> >
> > So far, I've only seen DMA controllers which operate on a linked list of
> > source, destination, length, attributes, and next entry pointer.
> >
> > > All the attributes of a buffer, which are required for the transfer
> > > can be programmed in single descriptor and submitted to the
> > > DMA controller.
> >
> > I'm not sure that this is useful - in order to make use of the data, the
> > data would have to be copied in between the descriptors - and doesn't that
> > rather negate the point of DMA if you have to memcpy() the data around?
> >
> > Isn't it far more efficient to have DMA place the data exactly where it's
> > required in memory right from the start without any memcpy() operations?
> >
> > Can you explain where and how you would use something like this:
> >

Consider a simple video use case of de-interlacing a video buffer.
Odd lines have to be transferred first, and then the even lines are 
transferred separately. This can be done by programming the 
inter frame gap as the line size of the video buffer in the DMAC.
This will require you to have only 2 descriptors, one for the
odd lines and another for the even lines. This results in only
2 descriptors being written to DMAC registers.

But if we have to construct a sglist for this, we end up having to 
write the descriptors to DMAC as many times as the 
number of lines in the video buffer.

To simply put it in other words, current DMA engine supports
1D transfers alone. Though sg list may be 2D, but again it the
DMACs are programmed for multiple 1D transfers again and 
again in a sg case. If the DMAC supports multi dimensional
transfer, that feature cannot be utilized by using the current
DMA engine APIs.

> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 0 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 1 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  |		........					     | 
> > -------------------------------------------------------------------
> >  |		Inter Frame Gap			     | 
> > -------------------------------------------------------------------
> >  | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame m 
> > -------------------------------------------------------------------
> 
> Can you also explain what a chunk contains, what a frame contains,
> how they're different and how they're processed?  Where does the
> data to be transferred to the device live?
> 
> > 
> > Note: ICG = Inter Chunk Gap.
> > 
> > struct dma_buffer_config {
> > 	u32 chunk_size; /* number of bytes in a chunk */
> > 	u32 frame_size; /* number of chunks in a frame */
> > 	/* u32 n_frames; number of frames in the buffer */
> > 	u32 inter_chunk_gap; /* number of bytes between end of a chunk 
> > 				and the start of the next chunk */ 
> > 	u32 inter_frame_gap; /* number of bytes between end of a frame 
> > 				and the start of the next frame */ 
> > 	bool sync_rate; /* 0 - a sync event is required from the 
> > 				peripheral to transfer a chunk 
> > 			1 - a sync event is required from the 
> > 				peripheral to transfer a frame */ 
> > };
> >

I have tried to represent a 3 dimensional buffer here. 
Each chunk is a 1D buffer with 'x' bytes. 
Each frame is a 2D buffer with 'n' chunks. 
The overall buffer is 3D with 'm' frames.

Actually we can deduce the chunk_size from the 
dma_slave_config itself. It is either the src_addr_width or
dst_addr_width based on the direction. Because at a stretch
DMAC cannot transfer more than the slave register width.

All these values in the dma_buffer_config proposed above
can be programmed in the DMAC through a single descriptor
if the DMAC is 3D transfer capable.

If the client has to do this type of transfer using sg list
then it will end up having a sglist of m*n entries and that 
many descriptors have to be programmed on the DMAC

> 
> Also, bear in mind that in Linux, we try hard to avoid allocating
> buffers larger than one page at a time - as soon as we get to multiple
> contiguous page buffers, allocations can start failing because of
> memory fragmentation.  This is why we much prefer scatterlists over
> single contiguous buffers for DMA.

Regards,
Sundaram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
