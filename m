Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab0EJO6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:58:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51746 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751843Ab0EJO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:58:38 -0400
Date: Mon, 10 May 2010 10:58:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Woodhouse <dwmw2@infradead.org>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, <daniel@caiaq.de>,
       <clemens@ladisch.de>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
       <gregkh@suse.de>, <konrad.wilk@oracle.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <chrisw@sous-sol.org>,
       <iommu@lists.linux-foundation.org>, <andi@firstfloor.org>,
       <pedrib@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <1273483265.372.3383.camel@macbook.infradead.org>
Message-ID: <Pine.LNX.4.44L0.1005101049100.1626-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, David Woodhouse wrote:

> On Mon, 2010-05-10 at 11:50 +0900, FUJITA Tomonori wrote:
> > On Fri, 7 May 2010 10:51:10 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Fri, 7 May 2010, Daniel Mack wrote:
> > > 
> > > > > At least the audio class and ua101 drivers don't do this and fill the
> > > > > buffers before they are submitted.
> > > > 
> > > > Gnaa, you're right. I _thought_ my code does it the way I described, but
> > > > what I wrote is how I _wanted_ to do it, not how it's currently done. I
> > > > have a plan to change this in the future.
> > > > 
> > > > So unfortunately, that doesn't explain it either. Sorry for the noise.
> > > 
> > > At one point we tried an experiment, printing out the buffer and DMA 
> > > addresses.  I don't recall seeing anything obviously wrong, but if an 
> > > IOMMU was in use then that might not mean anything.  Is it possible 
> > > that the IOMMU mappings sometimes get messed up for addresses above 4 
> > > GB?
> > 
> > You mean that an IOMMU could allocate an address above 4GB wrongly? If
> > so, IIRC, all the IOMMU implementations use dev->dma_mask and
> > dev->coherent_dma_mask properly. And the DMA address space of the
> > majority of IOMMUs are limited less than 4GB.
> 
> The Intel IOMMU code will use dev->dma_mask and dev->coherent_dma_mask
> properly. It is not limited to 4GiB, but it will tend to give virtual
> DMA addresses below 4GiB even when a device is capable of more; it'll
> only give out higher addresses when the address space below 4GiB is
> exhausted.

What I meant was: Is it possible that the IOMMU code will return a
virtual DMA address before 4 GB but will somehow forget to actually map
that address to the data buffer?

The problem goes away when Pedro boots with mem=4G.  And the dma_mask
value is set properly (in fact, the ehci-hcd driver currently doesn't
use 64-bit DMA at all).

If anyone wants to see the debug log entries showing the buffer and DMA
addresses, they are attached to this email message:

	http://marc.info/?l=linux-kernel&m=127076841801054&w=2

Either the data isn't getting written to the buffer correctly or else
the buffer isn't getting sent to the device correctly.  Can anybody
suggest a means of determining which is the case?

Alan Stern

