Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1FJLOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:14:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57426 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab1FJLOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:14:14 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: "Koul, Vinod" <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 10 Jun 2011 16:43:53 +0530
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave transfer
Thread-Topic: [RFC] dmaengine: add new api for preparing simple slave
 transfer
Thread-Index: AcwnOdZIq3xiu4rqQvaHUW+9+1V+xAAIH43w
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3405@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	 <20110609124723.GA24636@n2100.arm.linux.org.uk>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
 <1307686140.10976.111.camel@vkoul-udesk3>
In-Reply-To: <1307686140.10976.111.camel@vkoul-udesk3>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5ABESgI031921

Vinod,

> -----Original Message-----
> From: Koul, Vinod [mailto:vinod.koul@intel.com]
> Sent: Friday, June 10, 2011 11:39 AM
> To: Raju, Sundaram; Dan
> Cc: Russell King - ARM Linux; davinci-linux-open-
> source@linux.davincidsp.com; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: RE: [RFC] dmaengine: add new api for preparing simple slave transfer
> 

<snip>
> >
> > The above 2 APIs in the dmaengine framework expect all the
> > peripheral/slave related attributes to be filled in the
> > dma_slave_config data structure.
> > struct dma_slave_config {
> >         enum dma_data_direction direction;
> >         dma_addr_t src_addr;
> >         dma_addr_t dst_addr;
> >         enum dma_slave_buswidth src_addr_width;
> >         enum dma_slave_buswidth dst_addr_width;
> >         u32 src_maxburst;
> >         u32 dst_maxburst;
> > };
> >
> > This data structure is passed to the offload engine via the dma_chan
> > data structure in its private pointer.
> No, this is passed thru control API you described above. Please read
> Documentation/dmaengine.txt

Yes, Vinod its my mistake. I wanted to say control API only, 
but just mixed it up with how the dma_slave_config is attached 
to each dma_chan so that the offload drivers can use it while 
preparing the descriptors.

> 
> > Now coming to the buffer related attributes, sg list is a nice way to
> > represent a disjoint buffer; all the offload engines in drivers/dma
> > create a descriptor for each of the contiguous chunk in the sg list
> > buffer and pass it to the controller.
> >
> > But many a times a client may want to transfer from a single buffer to
> > the peripheral and most of the DMA controllers have the capability to
> > transfer data in chunks/frames directly at a stretch.
> > All the attributes of a buffer, which are required for the transfer
> > can be programmed in single descriptor and submitted to the
> > DMA controller.
> >
> > So I think the slave transfer API must also have a provision to pass
> > the buffer configuration. The buffer attributes have to be passed
> > directly as an argument in the prepare API, unlike dma_slave_config
> > as they will be different for each buffer that is going to be
> > transferred.
> Can you articulate what attributes you are talking about. The
> dma_slave_config parameters don't represent buffer attributes. They
> represent the dma attributes on how you want to transfer. These things
> like bus widths, burst lengths are usually constant for the slave
> transfers, not sure why they should change per buffer?
> 

I have tried to explain the attributes in the previous mail 
I posted in this thread.

Yes, buffer attributes should not be represented in 
the dma_slave_config. It is for slave related data.
That is why had mentioned that buffer configuration should be
a separate structure and passed in the prepare API.
See quoted below:

<quote>
> struct dma_buffer_config {
> 	u32 chunk_size; /* number of bytes in a chunk */
> 	u32 frame_size; /* number of chunks in a frame */
> 	/* u32 n_frames; number of frames in the buffer */
> 	u32 inter_chunk_gap; /* number of bytes between end of a chunk 
> 				and the start of the next chunk */ 
> 	u32 inter_frame_gap; /* number of bytes between end of a frame 
> 				and the start of the next frame */ 
> 	bool sync_rate; /* 0 - a sync event is required from the 
> 				peripheral to transfer a chunk 
> 			1 - a sync event is required from the 
> 				peripheral to transfer a frame */ 
> };
> 
> The patch to add a new API for single buffer transfers alone: 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> @@ -491,6 +492,10 @@ struct dma_device {
> 		struct dma_chan *chan, struct scatterlist *sgl,
> 		unsigned int sg_len, enum dma_data_direction direction,
> 		unsigned long flags);
> +	struct dma_async_tx_descriptor *(*device_prep_slave)(
> +		struct dma_chan *chan, dma_addr_t buf_addr,
> +		unsigned int buf_len, void *buf_prop,
> +		enum dma_data_direction direction, unsigned long flags);
> 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
> 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> 		size_t period_len, enum dma_data_direction direction);
>
</quote>

Regards,
Sundaram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
