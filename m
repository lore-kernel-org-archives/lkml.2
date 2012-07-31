Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2GaGng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:43:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56303 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2GaGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:43:34 -0400
Date: Tue, 31 Jul 2012 08:45:57 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: About dma_sync_single_for_{cpu,device}
Message-ID: <20120731064557.GA4676@gobelin>
References: <20120730202401.GA4947@gobelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120730202401.GA4947@gobelin>
X-Location: France
User-Agent: Mutt (Linux 3.5.0-07078-gf7da9cd-dirty x86_64 GNU/Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


(This is an email originally addressed to the linux-kernel
mailing-list.)


On our board we've got an MV78200 and a network device between which we
xfer memory chunks via the ddram with an external dma controller.
To handle these xfers we're using the dma API.

To tx a chunk of data from the SoC => network device, we :
- prepare a buffer with a leading header embedding a pattern, 
- trigger the xfer and wait for an irq
// The device updates the pattern and then triggers an irq
- upon irq we check the pattern for the xfer completion


I was expecting the following to work:
	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);
	dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
	dev_send(buffer);
	// wait for irq (don't peek in the buffer) ... got irq
	dma_sync_single_for_cpu(dev, buffer, pattern_size, DMA_FROM_DEVICE);
	if (!xfer_done(buffer)) // not RAM value
		dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
	[...]

But this does not work (the buffer pattern does not reflect the ddram
value).
On the other hand, the following works:
	[...]
	// wait for irq (don't peek in the buffer) ... got irq
	dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
	if (!xfer_done(buffer)) // RAM value
	[...]


Looking at 
	dma-mapping.c:__dma_page_cpu_to_{dev,cpu}() and
	proc-feroceon.S: feroceon_dma_{,un}map_area
this behavior is not surprising.
The sync_for_cpu calls the unmap which just invalidates the outer cache
while the sync_for_device invalidates both inner and outer.

It seems that:
- we need to invalidate after the RAM has been updated
- we need to invalidate with sync_single_for_device rather than
  sync_single_for_cpu to check the value

Is it correct ?






Maybe the following comment in dma-mapping.c explains the situation :
/*
 * The DMA API is built upon the notion of "buffer ownership".  A buffer
 * is either exclusively owned by the CPU (and therefore may be accessed
 * by it) or exclusively owned by the DMA device.  These helper functions
 * represent the transitions between these two ownership states.
 *
 * Note, however, that on later ARMs, this notion does not work due to
 * speculative prefetches.  We model our approach on the assumption that
 * the CPU does do speculative prefetches, which means we clean caches
 * before transfers and delay cache invalidation until transfer completion.
 *
 */

Thanks for your input,
 
Regards,
 
Karl
