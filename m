Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1FIQCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:02:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43967 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1FIQCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:02:15 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 9 Jun 2011 21:31:56 +0530
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave transfer
Thread-Topic: [RFC] dmaengine: add new api for preparing simple slave
 transfer
Thread-Index: Acwmo2gRKnAnNeQKSruTmIvM+q0/dwAGqiZQ
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
 <20110609124723.GA24636@n2100.arm.linux.org.uk>
In-Reply-To: <20110609124723.GA24636@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here it is, with proper line wrapping;

SDMA and EDMA are TI SoC specific DMA controllers. Their drivers have 
been maintained in the respective SoC folders till now.
arch/arm/plat-omap/dma.c
arch/arm/mach-davinci/dma.c

I have gone through the existing offload engine (DMA) drivers in 
drivers/dma which do slave transfers.
I would like to move SDMA and EDMA also to dmaengine framework.

I believe that even though the dmaengine framework addresses and 
supports most of the required use cases of a client driver to a DMA 
controller, some extensions are required in it to make it still more 
generic.

Current framework contains two APIs to prepare for slave transfers: 

struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
		struct dma_chan *chan, struct scatterlist *sgl,
		unsigned int sg_len, enum dma_data_direction direction,
		unsigned long flags);

struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
		size_t period_len, enum dma_data_direction direction);

and one control API. 
int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
		unsigned long arg);

A simple single buffer transfer (i.e. non sg transfer) can be done only
as a trivial case of the device_prep_slave_sg API. The client driver is
expected to prepare a sg list and provide to the dmaengine API for that
single buffer also.

In a slave transfer, the client has to define all the buffer related 
attributes and the peripheral related attributes. 

The above 2 APIs in the dmaengine framework expect all the 
peripheral/slave related attributes to be filled in the 
dma_slave_config data structure. 
struct dma_slave_config {
        enum dma_data_direction direction;
        dma_addr_t src_addr;
        dma_addr_t dst_addr;
        enum dma_slave_buswidth src_addr_width;
        enum dma_slave_buswidth dst_addr_width;
        u32 src_maxburst;
        u32 dst_maxburst;
};

This data structure is passed to the offload engine via the dma_chan 
data structure in its private pointer.

Now coming to the buffer related attributes, sg list is a nice way to 
represent a disjoint buffer; all the offload engines in drivers/dma 
create a descriptor for each of the contiguous chunk in the sg list 
buffer and pass it to the controller. 

But many a times a client may want to transfer from a single buffer to
the peripheral and most of the DMA controllers have the capability to 
transfer data in chunks/frames directly at a stretch. 
All the attributes of a buffer, which are required for the transfer 
can be programmed in single descriptor and submitted to the 
DMA controller. 

So I think the slave transfer API must also have a provision to pass 
the buffer configuration. The buffer attributes have to be passed 
directly as an argument in the prepare API, unlike dma_slave_config 
as they will be different for each buffer that is going to be 
transferred. 

It is a stretch and impractical to use a highly segmented buffer (like
the one described below) in a sglist. This is because sg list itself 
is a representation of a disjoint buffer collection in terms of 
smaller buffers. Now then each of these smaller buffers can have 
different buffer configurations (like described below) and we are not 
going to go down that road now. 

Hence it makes sense to pass these buffer attributes for only a single
buffer transfer and not a sg list. 
This can be done by OPTION #1 
1. Adding a pointer of the dma_buffer_config data structure in the 
device_prep_slave_sg API.
2. Ensuring that it will be ignored if a sg list passed. 
Only when a single buffer is passed (in the sg list) then this buffer 
configuration will be used.
3. Any client that wants to do a sg transfer can simply ignore this 
buffer configuration and pass NULL.
The main disadvantage of this option is that all the existing drivers 
need to be updated since the API signature is changed.

It might even be better to have a separate API for non sg transfers.
This is OPTION #2 
Advantages of this option are 
1. No change required in the existing drivers that use 
device_prep_slave_sg API. 
2. If any offload engine wants to prepare a simple buffer transfer 
differently and not as a trivial case of a sg list, 
this will be useful. 
I know this can be done using 2 different implementations inside the 
device_prep_slave_sg itself, but I think it's cleaner to have 
different APIs. I have provided the generic buffer configuration 
I can think of, here and also a new API definition, 
if it makes sense to have one. This buffer configuration might not 
be completely generic, and hence I ask all of you to please provide 
comments to improve it. 

Generic buffer description: 
A generic buffer can be split into number of frames which contain 
number of chunks inside them. The frames need not be contiguous, 
nor do the chunks inside a frame. 

-------------------------------------------------------------------
 | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 0 
-------------------------------------------------------------------
 |		Inter Frame Gap			     | 
-------------------------------------------------------------------
 | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame 1 
-------------------------------------------------------------------
 |		Inter Frame Gap			     | 
-------------------------------------------------------------------
 |		........					     | 
-------------------------------------------------------------------
 |		Inter Frame Gap			     | 
-------------------------------------------------------------------
 | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n | Frame m 
-------------------------------------------------------------------

Note: ICG = Inter Chunk Gap.

struct dma_buffer_config {
	u32 chunk_size; /* number of bytes in a chunk */
	u32 frame_size; /* number of chunks in a frame */
	/* u32 n_frames; number of frames in the buffer */
	u32 inter_chunk_gap; /* number of bytes between end of a chunk 
				and the start of the next chunk */ 
	u32 inter_frame_gap; /* number of bytes between end of a frame 
				and the start of the next frame */ 
	bool sync_rate; /* 0 - a sync event is required from the 
				peripheral to transfer a chunk 
			1 - a sync event is required from the 
				peripheral to transfer a frame */ 
};

The patch to add a new API for single buffer transfers alone: 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
@@ -491,6 +492,10 @@ struct dma_device {
		struct dma_chan *chan, struct scatterlist *sgl,
		unsigned int sg_len, enum dma_data_direction direction,
		unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_slave)(
+		struct dma_chan *chan, dma_addr_t buf_addr,
+		unsigned int buf_len, void *buf_prop,
+		enum dma_data_direction direction, unsigned long flags);
	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
		size_t period_len, enum dma_data_direction direction);

The number of frames (n_frames) can always be determined using all 
other values in the dma_buffer_config along with the 
buffer length (buf_len) passed in the API. 
n_frames = buf_len / (chunk_sixe * frame_size); 

Regards, 
Sundaram

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Thursday, June 09, 2011 6:17 PM
To: Raju, Sundaram
Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com; linux-omap@vger.kernel.org
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer

Can you please re-post with sensible wrapping at or before column 72.
I'm not manually reformatting your entire message just so I can find
the relevant bits to reply to.

Thanks.
