Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2A0PBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:01:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51165 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2A0PBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:01:30 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>
Subject: RE: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Thread-Topic: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Thread-Index: AczbdSds1n6amVVGTfqCj870KpG3gwAZgSeAAEoszvA=
Date: Fri, 27 Jan 2012 15:01:25 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA9317CA152@DBDE01.ent.ti.com>
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
 <20120126090245.GF15110@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120126090245.GF15110@legolas.emea.dhcp.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.112.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Wed, Jan 25, 2012 at 03:22:32PM +0000, Gupta, Ajay Kumar wrote:
> > As a next step to dma-engine based cppi4.1 driver implementation this
> > RFC has the overview of changes in the musb driver.
> > RFC on CPPI slave driver changes will follow next.
> >
> > Overview of changes in the musb driver
> > ======================================
> >
> > 1)Add a dma-engine.c file in the drivers/usb/musb folder 2)This file
> > will host the current musb dma APIs and translates them to
> >   dmaengine APIs.
> > 3)This will help to keep the changes in drivers/usb/musb/musb* files
> >   minimal and also to retain compatibility other DMA (Mentor etc.)
> >   drivers which are yet to be moved to drivers/dma
> > 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
> >   make existing musb APIs compatible.
> > 5)drivers/usb/musb/dma-engine.c file will implement the filter
> >   functions and also implement .dma_controller_create (allocates
> >   & provides "dma_controller" object) and .dma_controller_delete
> > 6)CPPI4.1 DMA specific queue and buffer management will be internal
> >   to slave CPPI DMA driver implementation.
> 
> looks good.
> 
> > Brief on each DMA related API used in /drivers/usb/musb*
> > =========================================================
> > 1)
> > MUSB DMA API currently used: dma_controller_create()
> > MUSB DMA API parameters currently used:
> > 		struct musb  *musb,
> > 		void __iomem *mregs
> >
> > Proposal: This API will be implemented in the dma-engine.c and will
> > allocate and populate dma_controller object.
> 
> k
> 
> > 2)
> > MUSB DMA API currently used: dma_controller_delete() MUSB DMA API
> > parameters currently used:
> > 		struct dma_controller *controller
> >
> > Proposal: This API will be implemented in the dma-engine.c and frees
> >          the dma_controller object
> 
> k
> 
> > 3)
> > MUSB DMA API currently used: dma_controller.start() MUSB DMA API
> > parameters currently used:
> > 		struct dma_controller *controller
> >
> > Proposal: This will be an empty function. The current actions intended
> >           for start of HW DMA (as whole engine - not the specific
> channel)
> >	    will be implemented in cppi41 slave driver.
> 
> why don' you make this one actually enable the hw ? Maybe call
> pm_runtime_get_sync(), enable the DMA, increase a usecount on the
> controller and stuff like that ?

Sounds good, will look into this.
> 
> > 4)
> > MUSB DMA API currently used: dma_controller.stop() MUSB DMA API
> > parameters currently used:
> > 		struct dma_controller *controller
> >
> > Proposal: This will be an empty function. The current actions intended
> >           for stop of HW DMA (as whole engine - not the specific
> channel)
> >	    will be implemented in cppi41 slave driver.
> 
> likewise, but reversing start ?
> 
> > 5)
> > MUSB DMA API currently used: dma_controller.chan_alloc()
> > MUSB DMA API parameters currently used:
> > 				struct dma_controller *,
> > 				struct musb_hw_ep *,
> > 				u8 is_tx
> > Proposal
> > * This function translates to the dma_request_channel API of dma-
> engine.
> > * The filter function that helps to acquire the channel is also part
> of
> >   this implementation.
> > * The dma_chan structure returned by dma-engine API is going to be
> >   different from "dma_channel" structure. As the channel structure
> >   does not carry any important information except status and
> >   associating DMA-HW channel structure, dma engine.c could still
> >   translate/emulate the similar (almost same) structure to musb*
> files.
> > * The endpoint and direction information is used in filter function.
> > * A challenge here is to implement a filter function that scales up
> >   for more number of channels (64 channels at this point)
> 
> to start, make it as simple as necessary. Implement other trickery
> later.

Yes, ofcourse.
> 
> > * Another challenge is the maintain the platform data on endpoints vs
> >   channels (which change between SoCs)
> 
> We need to move out of platform_data. While doing that, make it match on
> DT attributes.

Ok fine.

Regards,
Ajay

> 
> > 6)
> > MUSB DMA API currently used: dma_controller.chan_program() MUSB DMA
> > API parameters currently used:
> > 				struct dma_channel *
> > 				u16 maxpacket
> > 				u8 mode,
> > 				dma_addr_t dma_addr,
> > 				u32 length
> >
> > Proposal:
> > * All the parameters except the maxpacket directly applies in
> > dma-engine API
> > * Max packet is used for Transparent (mode0) mode of DMA where, each
> >   burst of DMA programming will be of maxpacket size.
> > * For all generic DMA requests - SG structure of DMA engine API will
> >   have only one entry
> > * DMA driver would require the "maxpacket" size, for deciding type of
> >   DMA transfer. As the current API does not provide option, it can be
> >   part of a private data to slave DMA driver through dma_chan
> structure.
> >   Alternatively, dmaengine's "DMA_SLAVE_CONFIG" control command also
> >   can be used for this purpose
> > * For ISO requests, each frame buffer is treated as an entry of SG
> structure.
> >   ISO programming will require some changes in musb_host.c as it
> currently
> >   programs each frame buffer as a separate DMA request.
> 
> k
> 
> > 7)
> > MUSB DMA API currently used: dma_controller.chan_release() MUSB DMA
> > API parameters currently used:
> > 		struct dma_channel	*channel
> >
> > Proposal: Releases the channel - typically happens only during the
> rmmod
> >         of the driver
> 
> k
> 
> > 8)
> > MUSB DMA API currently used: dma_controller.chan_abort() MUSB DMA API
> > parameters currently used:
> > 		struct dma_channel	*channel
> >
> > Proposal: This translates into the control commands of DMA engine. We
> can use
> >           "DMA_TERMINATE_ALL" control command for this purpose.
> 
> k
> 
> --
> balbi
