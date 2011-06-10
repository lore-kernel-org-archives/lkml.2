Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1FJNeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:34:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab1FJNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:34:04 -0400
Date: Fri, 10 Jun 2011 14:33:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
Message-ID: <20110610133338.GD24636@n2100.arm.linux.org.uk>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com> <20110609124723.GA24636@n2100.arm.linux.org.uk> <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com> <20110609163206.GB24636@n2100.arm.linux.org.uk> <1307686397.10976.116.camel@vkoul-udesk3> <E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com> <20110610104318.GC24636@n2100.arm.linux.org.uk> <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 05:18:46PM +0530, Raju, Sundaram wrote:
> Russell,
> 
> > How do you handle the situation where a driver uses your new proposed
> > API, but it doesn't support that in hardware.
> 
> It should be handled the same way how a sg buffer is handled, 
> if LLI chaining feature is not available in the hardware. 

No, if the LLI chaining feature is available in hardware and your special
'skip' feature is not, then you have to generate a set of LLIs for the
hardware to walk through to 'emulate' the skip feature.

If you have no LLI support, then you need to program each transfer manually
into the DMA controller.

> > > Actually we can deduce the chunk_size from the
> > > dma_slave_config itself. It is either the src_addr_width or
> > > dst_addr_width based on the direction. Because at a stretch
> > > DMAC cannot transfer more than the slave register width.
> > 
> > I think you're misinterpreting those fields.  (dst|src)_addr_width tells
> > the DMA controller the width of each transaction - whether to issue a
> > byte, half-word, word or double-word read or write to the peripheral.
> > It doesn't say how many of those to issue, it just says what the
> > peripheral access size is to be.
> > 
> > In other words, they describe the width of the FIFO register.
> 
> Yes correct, I was just giving an example for considering or
> understanding a buffer in 3D and how each dimension should be.
> 
> chunk_size = (src|dst)_addr_width, for a special case,
> i.e, if DMAC is programmed to transfer the entire 1D buffer
> per sync event received from the peripheral.

Please, don't generate special cases.  Design proper APIs from the
outset rather than abusing what's already there.  So no, don't abuse
the address width stuff.

In any case, the address width stuff must still be used to describe the
peripherals FIFO register.

> In slave transfer, the peripheral is going to give a sync event to 
> DMAC when the FIFO register is full|empty.

'sync event' - peripherals give 'request' signals to the DMAC asking
them to transfer some more data only, and the DMAC gives an acknowledge
signal back so that the peripheral knows that the DMAC is giving them
data.  In the generic case, they typically have no further signalling.

When the DMAC sees an active request, it will attempt to transfer up
to the minimum of (burst size, number of transfers remaining) to the
peripheral in one go.

> Now DMACs capable of 3D transfer, do transfer of the whole 1D
> buffer per sync received or even whole 2D buffer per sync received
> (based on the sync rate programmed in the DMAC).

Ok, what I'm envisioning is that your term "chunk size" means "register
width", and you view that as one dimension.  We already describe this.

A frame is a collection of chunks.  That's already described - the number
of chunks in a buffer is the buffer size divided by the chunk size.
Buffers must be a multiple of the chunk size.

Then we have a collection of frames.  These can be non-contiguous.
That's effectively described by our scatterlist.

> So the DMAC has to be programmed for a 1D size (i.e. chunk size)
> equal to that of the width of the FIFO register if the sync rate
> programmed in DMAC is "per chunk".  

This appears to be a circular definition, and makes little sense to me.

The overall conclusion which I'm coming to is that we already support
what you're asking for, but the problem is that we're using different
(and I'd argue standard) terminology to describe what we have.

The only issue which I see that we don't cover is the case where you want
to describe a single buffer which is organised as N bytes to be transferred,
M following bytes to be skipped, N bytes to be transferred, M bytes to be
skipped.  I doubt there are many controllers which can be programmed with
both 'N' and 'M' parameters directly.

Let me finish with a summary of how memory-to-peripheral transfers are
expected to operate:
1. The DMA controller reads data from system RAM using whatever parameters
   are most suitable for it to use up to the current buffer size.

2. When the DMA request goes active, it transfers data that it read
   previously to the device in dest_addr_width chunks of data.  It
   transfers the minimum of the remaining data or the burst size.

3. The peripheral, receiving data and filling its FIFO, drops the DMA
   request.

4. The DMA controller then reads more data from system RAM in the same
   way in (1).

5. If at any point the DMA controller reaches the end of the buffer, and
   as a link to the next buffer, it immediately moves to the next buffer
   and starts fetching data from that new buffer.
