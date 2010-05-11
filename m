Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0EKOAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:00:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757957Ab0EKOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:00:51 -0400
Date: Tue, 11 May 2010 10:00:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: dwmw2@infradead.org, <daniel@caiaq.de>, <clemens@ladisch.de>,
       <tiwai@suse.de>, <alsa-devel@alsa-project.org>, <gregkh@suse.de>,
       <konrad.wilk@oracle.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <chrisw@sous-sol.org>,
       <iommu@lists.linux-foundation.org>, <andi@firstfloor.org>,
       <pedrib@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100511100637D.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.1005110956330.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, FUJITA Tomonori wrote:

> > > > > At one point we tried an experiment, printing out the buffer and DMA 
> > > > > addresses.  I don't recall seeing anything obviously wrong, but if an 
> > > > > IOMMU was in use then that might not mean anything.  Is it possible 
> > > > > that the IOMMU mappings sometimes get messed up for addresses above 4 
> > > > > GB?
> > > > 
> > > > You mean that an IOMMU could allocate an address above 4GB wrongly? If
> > > > so, IIRC, all the IOMMU implementations use dev->dma_mask and
> > > > dev->coherent_dma_mask properly. And the DMA address space of the
> > > > majority of IOMMUs are limited less than 4GB.
> > > 
> > > The Intel IOMMU code will use dev->dma_mask and dev->coherent_dma_mask
> > > properly. It is not limited to 4GiB, but it will tend to give virtual
> > > DMA addresses below 4GiB even when a device is capable of more; it'll
> > > only give out higher addresses when the address space below 4GiB is
> > > exhausted.
> > 
> > What I meant was: Is it possible that the IOMMU code will return a
> > virtual DMA address before 4 GB but will somehow forget to actually map
> > that address to the data buffer?
> 
> Then, the IOMMU is completely broken. Then, we would get tons of DMA
> bugs not only about USB, I guess. So I'm not sure.

Yes, you're right about that.

> > The problem goes away when Pedro boots with mem=4G.  And the dma_mask
> > value is set properly (in fact, the ehci-hcd driver currently doesn't
> > use 64-bit DMA at all).
> > 
> > If anyone wants to see the debug log entries showing the buffer and DMA
> > addresses, they are attached to this email message:
> > 
> > 	http://marc.info/?l=linux-kernel&m=127076841801054&w=2
> > 
> > Either the data isn't getting written to the buffer correctly or else
> > the buffer isn't getting sent to the device correctly.  Can anybody
> > suggest a means of determining which is the case?
> 
> I can't say anything about this log that including only DMA addresses.
> I'm not familiar with how the USB core does DMA stuff. And the USB
> stack design that the USB core does DMA stuff (allocating, mappings,
> etc) makes debugging DMA issues really difficult.

The DMA stuff is simple enough in this case.  The urb->transfer_buffer
address is passed to dma_map_single(), and the DMA address it returns
is stored in urb->transfer_dma.  Those are the two values printed out
by the debugging patch.

Alan Stern

