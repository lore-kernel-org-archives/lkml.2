Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0CRBqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 21:46:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:51708 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab0CRBqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 21:46:49 -0400
Date: Thu, 18 Mar 2010 10:46:37 +0900
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.1003171050080.1734-100000@iolanthe.rowland.org>
References: <20100317072827F.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.1003171050080.1734-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100318104619S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 18 Mar 2010 10:46:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 11:22:01 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Here's the situation.  The USB controller drivers don't all support
> scatter-gather operation.  So there's a library routine in the USB core
> which calls dma_map_sg() and then creates a separate I/O request for
> each scatterlist element.  The driver can process these requests one at
> a time, and when they are all finished the library routine calls
> dma_unmap_sg().
> 
> However...  For tracing purposes (usbmon -- like tcpdump but for USB),
> we may need to copy the data from each I/O request's transfer buffer.  
> Unfortunately, this copying is done as each request is submitted (for 
> output) or as it completes (for input), at which times the buffers are 
> all mapped for DMA.  That's the problem.
> 
> Would we be better off not using dma_map_sg() at all in this situation?
> We could map each scatterlist buffer individually with dma_map_single()
> as the request is submitted and then unmap the buffer when the request
> completes, just like with non-sg transfers; then the problem wouldn't
> arise.
> 
> Would there be any significant penalty for doing this?  I realize it
> would prevent adjacent buffers from getting coalesced, but that's
> probably okay.  Any other reason not to?

No reason. About merging adjacent buffers, there are few IOMMU
implementations that do. The recent IOMMU implementations such as VT-d
and AMD IOMMU don't.

If drivers don't support scatter-gather operation, they had better use
dma_map_page() instead of forging scatter-gather lists and playing
with dma_map_sg().
