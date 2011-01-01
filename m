Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1AAPh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:37:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57802 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1AAPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:37:25 -0500
Date: Sat, 1 Jan 2011 15:36:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20110101153640.GD25924@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
> Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
> capability is advertised, yes this driver got this wrong.  I'll update
> the documentation to make this requirement clear, and audit the other
> drivers.  With slave-only drivers the only usage model is one where
> the client driver owns dma-mapping.  In the non-slave (opportunistic
> memcpy offload) case the client is unaware of the engine so the driver
> owns unmapping.  The minimal fix is to disable memcpy offload.

Another point - the example code in async-tx-api.txt section 3.7 is
a very bad example.  It doesn't show how the result of one operation
is passed to the next operation, as the source and destination for
each operation is passed in separately.  It actually won't even
compile because of this declaration:

        addr_conv_t addr_conv[xor_src_cnt];
        addr_conv_t addr_conv[NDISKS];

Neither of these are used in the example.

On the subject of chained operations, I really don't see how this can
hope to work with the DMA API.  Using the example provided there:

	async_xor(dst, src, ...)
	async_memcpy
	async_xor(dst, src, ...)
	async_tx_issue_pending_all

Let's assume that the operations start running when we call
async_tx_issue_pending_all(), and the two XOR operations reuse the same
buffers.

The first async_xor() dma_map_page()'s the source and destination buffers.
At this point, the ownership of these buffers passes to the DMA device.

When we get to the second async_xor(), as we haven't started to run any
of these operations, the source and destination buffers are still mapped.
However, we ignore that and call dma_map_page() on them again - this is
illegal because the CPU does not own these buffers.

Moreover, when the first XOR operation completes, it will unmap the
buffers (which returns ownership of the buffer to the CPU), but
continues with the second XOR operation on a now unmapped buffer.

If there is an IOMMU between the DMA engine peripheral and memory, then
this is going to be really vile.  As it is, I don't think this is going
to be reliable on ARM as we're destroying the ownership rules for DMA
buffers which we rely heavily upon to prevent effects from speculative
prefetching.

Last point I've noticed reading through this example and the associated
code is that the async_xor() maps the destination buffer using
DMA_BIDIRECTIONAL.  The corresponding unmap (in the DMA engine driver)
_must_ also be done with DMA_BIDIRECTIONAL (I don't see any drivers
respecting this.)

Sorry for the number of emails on DMA engine stuff recently...
