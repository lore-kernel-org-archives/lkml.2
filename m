Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0EKQGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:06:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49317 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752219Ab0EKQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:06:10 -0400
Date: Tue, 11 May 2010 12:06:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: gregkh@suse.de, <konrad.wilk@oracle.com>, <tiwai@suse.de>,
       USB list <linux-usb@vger.kernel.org>, <clemens@ladisch.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <chrisw@sous-sol.org>, <iommu@lists.linux-foundation.org>,
       <andi@firstfloor.org>, <daniel@caiaq.de>, <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, FUJITA Tomonori wrote:

> > > Can you tell me all the exact process of DMA that the usb core and the
> > > driver do?
> > 
> > 1. The audio driver stores data in urb->transfer_buffer.
> 
> How urb->transfer_buffer is allocated?

By kmalloc().  Right, Daniel?

> > 2. The audio driver calls usb_submit_urb(urb).
> > 
> > 3. The USB core does
> > 		urb->transfer_dma = dma_map_single(controller, 
> > 			urb->transfer_buffer,
> > 			urb->transfer_buffer_length,
> > 			DMA_TO_DEVICE);
> 
> The mapping error is checked via dma_mapping_error? Even if an mapping
> error happens, no data corruption happens due to that (needs
> something like retrying the request)?

Yes, we check dma_mapping_error().  If there's an error then the
submission fails, and presumably this failure would be logged by the
audio driver.

> > 4. The host controller driver tells the hardware to carry out the data 
> >    transfer.
> > 
> > 5. When the hardware says the transfer is finished, the USB core does
> > 		dma_unmap_single(controller,
> > 			urb->transfer_dma,
> > 			urb->transfer_buffer_length,
> > 			DMA_TO_DEVICE);
> > 
> > 6. The audio driver's completion handler is called:
> > 		(urb->complete)(urb);
> 
> The driver does only DMA_TO_DEVICE? Or you see DMA problems only with
> DMA_TO_DEVICE?

The particular test that Pedro is running uses audio output only -- 
he's sending sound data to a speaker and it comes out noisy.

But the audio data has to come from somewhere, and I don't remember 
where.  Pedro, does the noise occur only when you're playing sound that 
comes from a different USB device?  What happens if you play sounds 
that are stored on your hard disk, like an MP3 file?

Or what happens if you take the incoming sound data and store it in a 
disk file, and then later play that file out through the speaker?

Alan Stern

