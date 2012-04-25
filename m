Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2DYO3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:29:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34055 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2DYO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:29:38 -0400
Date: Wed, 25 Apr 2012 15:29:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: care sd_dma_address/len in
	dmaengine_prep_slave_single()
Message-ID: <20120425142901.GA24211@n2100.arm.linux.org.uk>
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com> <1327917366.1527.42.camel@vkoul-udesk3> <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com> <20120201182201.GE889@n2100.arm.linux.org.uk> <4F9807AF.3000804@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9807AF.3000804@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 04:18:23PM +0200, Lars-Peter Clausen wrote:
> On 02/01/2012 07:22 PM, Russell King - ARM Linux wrote:
> > On Mon, Jan 30, 2012 at 05:13:30PM -0800, Kuninori Morimoto wrote:
> >> +	sg_init_table(&sg, 1);
> >> +	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf)),
> >> +		    len, offset_in_page(buf));
> > 
> > There's not much point setting this - the page/virtual address should
> > not be used by DMA engines as that may not reflect what's being requested
> > (especially if there's an IOMMU in the way.)
> 
> I was just looking at this again and there are actually quite a few dma
> engine drivers which use sg->length and sg_phys(sg). I guess these would
> break if the sg_set_page was to be removed. Should these drivers be changed
> to use sg_dma_len and sg_dma_address?

sg->length is meaningless to something performing DMA - and that's probably
a bug you've found.

In cases where sg_dma_len(sg) and sg->length are the same storage, then
there's no problem.  But scatterlists _can_ (and one some architectures)
do split them - especially when you have an IOMMU which can allow you to
combine a scatterlist into fewer entries.

So, anything using sg->length for the size of a scatterlist's DMA transfer
_after_ a call to dma_map_sg() is almost certainly buggy.

sg_phys(sg) of course has nothing to do with DMA addresses.  It's the
physical address _to the CPU_ of the memory associated with the scatterlist
entry.  That may, or may not have the same value for the DMA engine,
particularly if IOMMUs are involved.  So again, that's a bug.

And if these drivers are used on ARM, they must be fixed, sooner rather
than later.  There's patches in the works which will mean we will end up
with IOMMU support in the DMA mapping later, which means everything I've
said above will become reality.
