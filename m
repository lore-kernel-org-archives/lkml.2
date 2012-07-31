Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2GaJKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:10:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52284 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GaJKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:10:46 -0400
Date: Tue, 31 Jul 2012 10:09:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About dma_sync_single_for_{cpu,device}
Message-ID: <20120731090931.GP6802@n2100.arm.linux.org.uk>
References: <20120730202401.GA4947@gobelin> <20120731064557.GA4676@gobelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731064557.GA4676@gobelin>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 08:45:57AM +0200, Karl Beldan wrote:
> I was expecting the following to work:
> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
> 	dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
> 	dev_send(buffer);
> 	// wait for irq (don't peek in the buffer) ... got irq
> 	dma_sync_single_for_cpu(dev, buffer, pattern_size, DMA_FROM_DEVICE);
> 	if (!xfer_done(buffer)) // not RAM value
> 		dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
> 	[...]

First point is that you clearly do not understand the DMA API at all.  The
DMA API has the idea of buffer ownership.  Only the owner may access the
buffer:

*CPU OWNS THE BUFFER*
dma_map_single()
*DEVICE OWNS THE BUFFER*
dma_sync_single_for_cpu()
*CPU OWNS THE BUFFER*
dma_sync_single_for_device()
*DEVICE OWNS THE BUFFER*
dma_unmap_single()
*CPU OWNS THE BUFFER*

So, there is absolutely no noeed what so ever to follow dma_map_single()
with dma_sync_single_for_device().

Second point is that you should not change the 'direction' argument while
a buffer is mapped.

Thirdly, enable DMA API debugging (DMA_API_DEBUG) to make sure you're
using the DMA API correctly.

Fourthly, remember that the CPU deals with cache lines, and dirty cache
lines may be written back in their _entirety_ - which means that data
DMA'd from a device in the same cache line that you've modified via the
CPU will not work (either the data in the cache line has to be invalidated
and therefore the CPU update discarded, or the cache line has to be flushed
back to RAM and the DMA'd data is overwritten.)  Hence why the buffer
ownership rules are extremely important.

The solution for this fourth point is to use coherent DMA memory for things
like ring buffers and the like, which does not suffer from this.

> Maybe the following comment in dma-mapping.c explains the situation :
> /*
>  * The DMA API is built upon the notion of "buffer ownership".  A buffer
>  * is either exclusively owned by the CPU (and therefore may be accessed
>  * by it) or exclusively owned by the DMA device.  These helper functions
>  * represent the transitions between these two ownership states.
>  *
>  * Note, however, that on later ARMs, this notion does not work due to
>  * speculative prefetches.  We model our approach on the assumption that
>  * the CPU does do speculative prefetches, which means we clean caches
>  * before transfers and delay cache invalidation until transfer completion.
>  *
>  */

Even with that comment, the idea of buffer ownership must be preserved by
drivers, and they must follow that rule.  The fact that some ARM CPU
do not respect the ownership entirely is worked around inside the DMA API
and is of no interest to drivers.  Feroceon is not one CPU which does this
though.
