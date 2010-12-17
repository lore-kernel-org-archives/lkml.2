Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0LQSpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:45:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:33343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab0LQSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:45:46 -0500
Subject: RE: intel-iommu.c bug
From: David Woodhouse <dwmw2@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Raj, Ashok" <ashok.raj@intel.com>, Cliff Wickman <cpw@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
In-Reply-To: <1292610483.2674.1.camel@sbsiddha-MOBL3.sc.intel.com>
References: <E1PTbq3-00083L-Sp@eag09.americas.sgi.com>
	 <647EFE31A07A4A478691C20DABDFFCB125C3855230@orsmsx501.amr.corp.intel.com>
	 <1292610483.2674.1.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 18:45:42 +0000
Message-ID: <1292611542.24326.138.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 10:28 -0800, Suresh Siddha wrote:
> > >-----Original Message-----
> > >From: Cliff Wickman [mailto:cpw@sgi.com]
> > >Sent: Friday, December 17, 2010 7:03 AM
> > >To: linux-kernel@vger.kernel.org
> > >Cc: Raj, Ashok; Li, Shaohua; Keshavamurthy, Anil S; Yu, Fenghua
> > >Subject: intel-iommu.c bug
> > >
> > >
> > >
> > >This bug was reported by Mike Habeck <habeck@sgi.com>.
> > >The test system was an SGI Altix UV.  These are Mike's words:
> > >
> > > It appears there is a bug in the iommu code that when 'forcedac' isn't used
> > > the nvidia driver is handed back a 44bit dma address even though it's
> > > dma_mask is set to 40bits.
> > >
> > > I added some debug to the intel_iommu code and I see:
> > >  intel_map_sg(): dma_addr_t=0xf81fffff000, pdev->dma_mask=0xffffffffff
> > >
> > > Note the dma_addr_t being handed back is 44bits even though the mask is 40bits.
> > > This results in the nvidia card generating a bad dma (i.e. the nvidia hw is
> > > only capable of generating a 40bit dma address so the upper 4 bits are lost
> > > and that results in the iommu hw detecting a bad dma access):
> > >
> > >   DRHD: handling fault status reg 2
> > >   DMAR:[DMA Read] Request device [36:00.0] fault addr 81fffff000
> > >   DMAR:[fault reason 06] PTE Read access is not set
> > >
> > > If I boot with 'forcedac' then the dma mask is honored and the dma_addr_t
> > > handed back is 40bits:
> > >
> > >   intel_map_sg(): dma_addr_t=0xfffffff000, pdev->dma_mask=0xffffffffff
> > >
> > > Without forcedac you'd expect these early maps being handed back to be 32bits.
> > > This is the first debug printf (so the first mapping the nvidia device has
> > > requested) so I'd expect it to be 0xfffff000... interesting that is what the
> > > lower 32bits are in this address being handed back... that 0xf81 upper bits
> > > appear to be garbage bits.  This might be a hint to help find the bug...

Hm, you're right; it should be returning addresses under 4GiB until that
space is exhausted and it has to use higher addresses, unless you pass
'forcedac' on the command line.

Please could you instrument alloc_iova (in drivers/pci/iova.c to print
its arguments, and also pfn_hi and pfn_lo of the iova it returns?

If those are sane, can you print start_vpfn at about line 2909 of
intel_iommu.c? And if *that* looks sane, print iov_pfn and the new value
of sg->dma_address each time that's set, at round line 1674.

Is this is 32-bit or 64-bit kernel?

-- 
dwmw2

