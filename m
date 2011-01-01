Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1AARir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 12:38:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60841 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1AARip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 12:38:45 -0500
Date: Sat, 1 Jan 2011 17:38:37 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: dma-debug: multiple concurrent mappings of same address space
Message-ID: <20110101173837.GA18040@flint.arm.linux.org.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Joerg Roedel <joerg.roedel@amd.com>,
	David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the DMA engine code, I'm concerned about multiple DMA
mappings of the same DMA buffer.  This is something that is explicitly
allowed by the DMA debug code, presumably for DM/MD device support
where the same buffer is passed to several block devices in parallel
for writing.

Presumably, though, there must be some restrictions on this.  Consider
an architecture (ARM) where we need to perform cache maintainence to
achieve coherence for DMA.  Or an architecture which uses a swiotlb.
Here, we track the buffer ownership thusly:

	/* CPU owns buffer */
	dma_map_foo()
	/* DMA device owns buffer */
	dma_sync_foo_for_cpu();
	/* CPU owns buffer */
	dma_sync_foo_for_device();
	/* DMA device owns buffer */
	dma_unmap_foo();
	/* CPU owns buffer */

and on ARM, we take the following action on owership transitions:

			CPU->DEV	DEV->CPU
DMA_TO_DEVICE		writeback	no-op
DMA_FROM_DEVICE		writeback	invalidate
DMA_BIDIRECTIONAL	writeback 	invalidate

If we have two concurrent DMA_TO_DEVICE mappings, this is not a problem
as the DMA will see coherent data, provided there are no CPU writes
between the first DMA buffer mapping and the last DMA buffer unmapping.

For DMA_FROM_DEVICE however, it seems to make no sense to allow multiple
concurrent mappings (the two DMA devices will fight over who's data
ultimately ends up in the buffer.)

For concurrent DMA_FROM_DEVICE and DMA_TO_DEVICE, it makes even less sense,
and is potentially data corrupting especially when you consider that there
may be a swiotlb copying data to/from the buffers at map and unmap time.

This issue has come up while I've been looking at the DMA engine code
(drivers/dma and crypto/async-tx).  This allows several offloaded
operations to be stacked, eg:

	async_memcpy(src, intermediate);
	async_memcpy(intermediate, dest);
	submit();

Each async_xor() call maps the source and destination buffers, and then
hands it off (in the mapped state) to the DMA engine driver.  Sometime
later, the DMA engine driver completes the operation and unmaps the
buffer after each step.  So what you get is:

	dma_map(src, DMA_TO_DEVICE) for the first xor
	dma_map(intermediate, DMA_FROM_DEVICE) for the first xor
	dma_map(intermediate, DMA_TO_DEVICE) for the second xor
	dma_map(dst, DMA_FROM_DEVICE) for the second xor
	submit()
	dma_unmap(src, DMA_TO_DEVICE) for the first xor
	dma_unmap(intermediate, DMA_FROM_DEVICE) for the first xor
	dma_unmap(intermediate, DMA_TO_DEVICE) for the second xor
	dma_unmap(dst, DMA_FROM_DEVICE) for the second xor

This won't work if you have a swiotlb in there because the second
operation won't see the results of the first operation.

Would it be a good idea to extend the DMA API debug to be able to check
for such cases - iow, permit multiple DMA_TO_DEVICE mappings but warn
for other cases?

(Think of DMA_TO_DEVICE as a read-lock, and the other mappings as a
write-lock - the semantics applying to a rw lock would seem to apply
to what is permitted here.)

Thoughts?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
