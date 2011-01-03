Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1ACQyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:54:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45487 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1ACQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:54:31 -0500
Date: Mon, 3 Jan 2011 16:52:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Peter Pearse <peter.pearse@arm.com>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, yuanyabin1978@sina.com,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: dmaengine: fix dma_unmap (was: Re: [PATCH 06/13] DMAENGINE:
	driver for the ARM PL080/PL081 PrimeCells)
Message-ID: <20110103165227.GC32508@n2100.arm.linux.org.uk>
References: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 08:36:00AM -0800, Dan Williams wrote:
> For raid this will have implications for architectures that split
> operation types on to different physical channels.  Preparing the
> entire operation chain ahead of time is not possible on such
> configuration because we need to remap the buffers for each channel
> transition.

That's not entirely true.  You will only need to remap buffers if
old_chan->device != new_chan->device, as the underlying struct device
will be the different and could possibly have a different IOMMU or
DMA-able memory parameters.

So, when changing channels, the optimization is not engine specific,
but can be effected when the chan->device points to the same dma_device
structure.  That means it should still be possible to chain several
operations together, even if it means that they occur on different
channels on the same device.

One passing idea is the async_* operations need to chain buffers in
terms of <virtual page+offset, len, dma_addr_t, struct dma_device *>, or
maybe <struct dma_device *, scatterlist>.  If the dma_device pointer is
initialized, the scatterlist is already mapped.  If this differs from
the dma_device for the next selected operation, the previous operations
need to be run, then unmap and remap for the new device.

Does that sound possible?

> > I'd also like to see DMA_COMPL_SKIP_*_UNMAP always set by prep_slave_sg()
> > in tx->flags so we don't have to end up with "is this a slave operation"
> > tests in the completion handler.
> 
> Longer term I do not see these flags surviving, but yes a 2.6.38
> change along these lines makes sense.

Well, if the idea is to kill those flags, then it would be a good idea
not to introduce new uses of them as that'll only complicate matters.

I do have an untested patch which adds the unmap to pl08x, but I'm
wondering if it's worth it, or whether to disable the memcpy support
for the time being.
