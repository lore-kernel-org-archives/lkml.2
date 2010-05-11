Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0EKPE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:04:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49640 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753775Ab0EKPE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:04:56 -0400
Date: Tue, 11 May 2010 11:04:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: konrad.wilk@oracle.com, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>, <tiwai@suse.de>, <gregkh@suse.de>,
       <clemens@ladisch.de>, <linux-kernel@vger.kernel.org>,
       <chrisw@sous-sol.org>, <iommu@lists.linux-foundation.org>,
       <andi@firstfloor.org>, <daniel@caiaq.de>, <pedrib@gmail.com>,
       <akpm@linux-foundation.org>, <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100511233852B.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.1005111057540.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, FUJITA Tomonori wrote:

> On Tue, 11 May 2010 10:24:40 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > > > > Either the data isn't getting written to the buffer correctly or else
> > > > > the buffer isn't getting sent to the device correctly.  Can anybody
> > > > > suggest a means of determining which is the case?
> > > > 
> > > > I can't say anything about this log that including only DMA addresses.
> > > > I'm not familiar with how the USB core does DMA stuff. And the USB
> > > > stack design that the USB core does DMA stuff (allocating, mappings,
> > > > etc) makes debugging DMA issues really difficult.
> > > 
> > > The DMA stuff is simple enough in this case.  The urb->transfer_buffer
> > > address is passed to dma_map_single(), and the DMA address it returns
> > > is stored in urb->transfer_dma.  Those are the two values printed out
> > > by the debugging patch.
> > 
> > Is that address (urb->transfer_dma) the same as 'virt_to_phys(urb->transfer_buffer)'
> > (if not, then SWIOTLB is being utilized) and is the dma_sync_* done on the
> > urb->transfer_dma (to properly sync the data from the SWIOTLB to the
> > transfer_buffer) before you start using the urb->transfer_buffer?
> 
> Or calling dma_unmap_single.
> 
> Can you tell me all the exact process of DMA that the usb core and the
> driver do?

1. The audio driver stores data in urb->transfer_buffer.

2. The audio driver calls usb_submit_urb(urb).

3. The USB core does
		urb->transfer_dma = dma_map_single(controller, 
			urb->transfer_buffer,
			urb->transfer_buffer_length,
			DMA_TO_DEVICE);

4. The host controller driver tells the hardware to carry out the data 
   transfer.

5. When the hardware says the transfer is finished, the USB core does
		dma_unmap_single(controller,
			urb->transfer_dma,
			urb->transfer_buffer_length,
			DMA_TO_DEVICE);

6. The audio driver's completion handler is called:
		(urb->complete)(urb);

Alan Stern

