Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1AKSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:30:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1AKSa3 convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 Jan 2011 13:30:29 -0500
Date: Tue, 11 Jan 2011 13:28:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, konrad@darnok.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
Message-ID: <20110111182857.GC29223@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <4D2B16F3.1070105@shipmail.org>
 <20110110152135.GA9732@dumpdata.com>
 <4D2B2CC1.2050203@shipmail.org>
 <20110110164519.GA27066@dumpdata.com>
 <4D2B70FB.3000504@shipmail.org>
 <20110111155545.GD10897@dumpdata.com>
 <AANLkTimarEHNAs-1hCJf05YhkRQP2qF1D9it81NA3VTb@mail.gmail.com>
 <20110111165953.GI10897@dumpdata.com>
 <AANLkTinkP8b9GNMFqWygJb0O17neB7RLnxTi-DaG13pR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinkP8b9GNMFqWygJb0O17neB7RLnxTi-DaG13pR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:12:57PM -0500, Alex Deucher wrote:
> On Tue, Jan 11, 2011 at 11:59 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >> >> Another thing that I was thinking of is what happens if you have a
> >> >> huge gart and allocate a lot of coherent memory. Could that
> >> >> potentially exhaust IOMMU resources?
> >> >
> >> > <scratches his head>
> >> >
> >> > So the GART is in the PCI space in one of the BARs of the device right?
> >> > (We are talking about the discrete card GART, not the poor man AMD IOMMU?)
> >> > The PCI space is under the 4GB, so it would be considered coherent by
> >> > definition.
> >>
> >> GART is not a PCI BAR; it's just a remapper for system pages.  On
> >> radeon GPUs at least there is a memory controller with 3 programmable
> >> apertures: vram, internal gart, and agp gart.  You can map these
> >
> > To access it, ie, to program it, you would need to access the PCIe card
> > MMIO regions, right? So that would be considered in PCI BAR space?
> 
> yes, you need access to the mmio aperture to configure the gpu.  I was
> thinking you mean something akin the the framebuffer BAR only for gart
> space which is not the case.

Aaah, gotcha.
> 
> >
> >> resources whereever you want in the GPU's address space and then the
> >> memory controller takes care of the translation to off-board resources
> >> like gart pages.  On chip memory clients (display controllers, texture
> >> blocks, render blocks, etc.) write to internal GPU addresses.  The GPU
> >> has it's own direct connection to vram, so that's not an issue.  For
> >> AGP, the GPU specifies aperture base and size, and you point it to the
> >> bus address of gart aperture provided by the northbridge's AGP
> >> controller.  For internal gart, the GPU has a page table stored in
> >
> > I think we are just talking about the GART on the GPU, not the old AGP
> > GART.
> 
> Ok.  I just mentioned it for completeness.

<nods>
> 
> >
> >> either vram or uncached system memory depending on the asic.  It
> >> provides a contiguous linear aperture to GPU clients and the memory
> >> controller translates the transactions to the backing pages via the
> >> pagetable.
> >
> > So I think I misunderstood what is meant by 'huge gart'. That sounds
> > like linear address space provided by GPU. And hooking up a lot of coherent
> > memory (so System RAM) to that linear address space would be no different that what
> > is currently being done. When you allocate memory using page_alloc(GFP_DMA32)
> > and hook up that memory to the linear space you exhaust the same amount of
> > ZONE_DMA32 memory as if you were to use the PCI API. It comes from the same
> > pool, except that doing it from the PCI API gets you the bus address right
> > away.
> >
> 
> In this case GPU clients refers to the hw blocks on the GPU; they are
> the ones that see the contiguous linear aperture.  From the
> application's perspective, gart memory looks like any other pages.

<nods>. Those 'hw blocks' or 'gart memory' are in reality
just pages received via the 'alloc_page()' (before this patchset and 
also after this patchset) Oh wait, this 'hw blocks' or 'gart memory' can also
refer to the VRAM memory right? In which case that is not memory allocated via
'alloc_page' but using a different mechanism. Is TTM used then? If so how
do you stick those VRAM pages under its accounting rules? Or do the drivers
use some other mechanism for that that is dependent on each driver?
