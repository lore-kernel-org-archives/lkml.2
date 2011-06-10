Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1FJRWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:22:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:21458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1FJRWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:22:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,348,1304319600"; 
   d="scan'208";a="16864242"
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave
 transfer
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Dan <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3405@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	 <20110609124723.GA24636@n2100.arm.linux.org.uk>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	 <1307686140.10976.111.camel@vkoul-udesk3>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3405@dbde02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 22:17:19 +0530
Message-ID: <1307724439.10976.188.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 16:43 +0530, Raju, Sundaram wrote:
> Vinod,

...
> > 
> > > Now coming to the buffer related attributes, sg list is a nice way to
> > > represent a disjoint buffer; all the offload engines in drivers/dma
> > > create a descriptor for each of the contiguous chunk in the sg list
> > > buffer and pass it to the controller.
> > >
> > > But many a times a client may want to transfer from a single buffer to
> > > the peripheral and most of the DMA controllers have the capability to
> > > transfer data in chunks/frames directly at a stretch.
> > > All the attributes of a buffer, which are required for the transfer
> > > can be programmed in single descriptor and submitted to the
> > > DMA controller.
> > >
> > > So I think the slave transfer API must also have a provision to pass
> > > the buffer configuration. The buffer attributes have to be passed
> > > directly as an argument in the prepare API, unlike dma_slave_config
> > > as they will be different for each buffer that is going to be
> > > transferred.
> > Can you articulate what attributes you are talking about. The
> > dma_slave_config parameters don't represent buffer attributes. They
> > represent the dma attributes on how you want to transfer. These things
> > like bus widths, burst lengths are usually constant for the slave
> > transfers, not sure why they should change per buffer?
> > 
> 
> I have tried to explain the attributes in the previous mail 
> I posted in this thread.
> 
> Yes, buffer attributes should not be represented in 
> the dma_slave_config. It is for slave related data.
> That is why had mentioned that buffer configuration should be
> a separate structure and passed in the prepare API.
> See quoted below:
> 
> <quote>
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
IIUC, you have a buffer with gaps in between (given by above params).
Is your DMA h/w capable of parsing this buffer and directly do a
transfer based on above parameters (without any work for SW), or you are
doing this in your dma driver and then programming a list of buffers?
In former case (although i haven't seen such dma controller yet), can
you share the datasheet? It would make very little sense to change the
current API for your extra special case. This special case needs to be
handled differently rather than making rule out of it!!

And in latter case you are really going the wrong path as Russel pointed
out and trying to abuse the APIs


-- 
~Vinod

