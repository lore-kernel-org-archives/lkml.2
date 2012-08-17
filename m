Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2HQKPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:15:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58053 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab2HQKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:15:34 -0400
Date: Fri, 17 Aug 2012 11:15:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 05/31] arm64: MMU initialisation
Message-ID: <20120817101500.GG24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-6-git-send-email-catalin.marinas@arm.com>
 <502E1793.9080605@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E1793.9080605@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:06:11AM +0100, Santosh Shilimkar wrote:
> On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> > This patch contains the initialisation of the memory blocks, MMU
> > attributes and the memory map. Only five memory types are defined:
> > Device nGnRnE (equivalent to Strongly Ordered), Device nGnRE (classic
> > Device memory), Device GRE, Normal Non-cacheable and Normal Cacheable.
> > Cache policies are supported via the memory attributes register
> > (MAIR_EL1) and only affect the Normal Cacheable mappings.
> >
> > This patch also adds the SPARSEMEM_VMEMMAP initialisation.
> >
> > Signed-off-by: Will Deacon<will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> > ---
> 
> Whats the difference between Device nGnRE and Device GRE ?
> Sorry, I haven't gone through the specs yet and hence the
> question.

G - gathering (multiple reads/writes into one)
R - reordering (reads/writes)
E - early acknowledgement (the write may have not hit the device before
    the instruction returns).

The 'n' in front just negates the meaning.

So the Device memory as we know it on ARMv7 is equivalent to nGnRE. The
Strongly Ordered is nGnRnE. GRE is pretty much like Normal Non-cacheable
memory but with Device mapping, so there are restrictions on unaligned
accesses.

> > +#ifdef CONFIG_ZONE_DMA32
> > +	/* 4GB maximum for 32-bit only capable devices */
> > +	max_dma32 = min(max, MAX_DMA32_PFN);
> > +	zone_size[ZONE_DMA32] = max_dma32 - min;
> > +#endif
> 
> Do you see need of supporting DMA32 on arm64 SOCs ?

I've got some questions from partners but those devices may just be
hidden behind an iommu. For now I left it in.

> > +static struct cachepolicy cache_policies[] __initdata = {
> > +	{
> > +		.policy		= "uncached",
> > +		.mair		= 0x44,			/* inner, outer non-cacheable */
> > +		.tcr		= TCR_IRGN_NC | TCR_ORGN_NC,
> > +	}, {
> > +		.policy		= "writethrough",
> > +		.mair		= 0xaa,			/* inner, outer write-through, read-allocate */
> > +		.tcr		= TCR_IRGN_WT | TCR_ORGN_WT,
> 
> Is WT supported on arm64?
> On the recent ARMv7 processors, I think WT wasn't supported.

All of WB, WA, WT are just architectural hints. A CPU implementation may
or may not ignore them but with Linux we try to follow the architecture
rather than specific implementations.

-- 
Catalin
