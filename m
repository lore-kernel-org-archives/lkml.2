Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1FJLtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:49:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50814 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab1FJLtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:49:10 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Koul, Vinod" <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 10 Jun 2011 17:18:46 +0530
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave	transfer
Thread-Topic: [RFC] dmaengine: add new api for preparing simple slave
	transfer
Thread-Index: AcwnWzz+Iw3A+/2xQBmimj+KoZcN1gABSWcQ
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
 <20110609124723.GA24636@n2100.arm.linux.org.uk>
 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
 <20110609163206.GB24636@n2100.arm.linux.org.uk>
 <1307686397.10976.116.camel@vkoul-udesk3>
 <E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com>
 <20110610104318.GC24636@n2100.arm.linux.org.uk>
In-Reply-To: <20110610104318.GC24636@n2100.arm.linux.org.uk>
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

Russell,

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Friday, June 10, 2011 4:13 PM
> To: Raju, Sundaram
> Cc: Koul, Vinod; Dan; davinci-linux-open-source@linux.davincidsp.com; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
> 
> On Fri, Jun 10, 2011 at 03:51:41PM +0530, Raju, Sundaram wrote:
> > Consider a simple video use case of de-interlacing a video buffer.
> > Odd lines have to be transferred first, and then the even lines are
> > transferred separately. This can be done by programming the
> > inter frame gap as the line size of the video buffer in the DMAC.
> > This will require you to have only 2 descriptors, one for the
> > odd lines and another for the even lines. This results in only
> > 2 descriptors being written to DMAC registers.
> 
> How would this be handled with DMACs which can't 'skip' bytes in the
> buffer?  You would have to generate a list of LLIs separately
> describing each 'line' of video and chain them together.

Correct.

> 
> How do you handle the situation where a driver uses your new proposed
> API, but it doesn't support that in hardware.
> 

It should be handled the same way how a sg buffer is handled, 
if LLI chaining feature is not available in the hardware. 

It has to be submitted as a queue of separate descriptors to
the DMAC, where each descriptor will be processed after the 
completion of the previous descriptor.

> > Actually we can deduce the chunk_size from the
> > dma_slave_config itself. It is either the src_addr_width or
> > dst_addr_width based on the direction. Because at a stretch
> > DMAC cannot transfer more than the slave register width.
> 
> I think you're misinterpreting those fields.  (dst|src)_addr_width tells
> the DMA controller the width of each transaction - whether to issue a
> byte, half-word, word or double-word read or write to the peripheral.
> It doesn't say how many of those to issue, it just says what the
> peripheral access size is to be.
> 
> In other words, they describe the width of the FIFO register.

Yes correct, I was just giving an example for considering or
understanding a buffer in 3D and how each dimension should be.

chunk_size = (src|dst)_addr_width, for a special case,
i.e, if DMAC is programmed to transfer the entire 1D buffer
per sync event received from the peripheral.

In slave transfer, the peripheral is going to give a sync event to 
DMAC when the FIFO register is full|empty.

Now DMACs capable of 3D transfer, do transfer of the whole 1D
buffer per sync received or even whole 2D buffer per sync received
(based on the sync rate programmed in the DMAC).

So the DMAC has to be programmed for a 1D size (i.e. chunk size)
equal to that of the width of the FIFO register if the sync rate
programmed in DMAC is "per chunk".  

Regards,
Sundaram
