Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1AKRCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:02:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16894 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1AKRCw (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 Jan 2011 12:02:52 -0500
Date: Tue, 11 Jan 2011 11:59:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, konrad@darnok.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
Message-ID: <20110111165953.GI10897@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <4D2B16F3.1070105@shipmail.org>
 <20110110152135.GA9732@dumpdata.com>
 <4D2B2CC1.2050203@shipmail.org>
 <20110110164519.GA27066@dumpdata.com>
 <4D2B70FB.3000504@shipmail.org>
 <20110111155545.GD10897@dumpdata.com>
 <AANLkTimarEHNAs-1hCJf05YhkRQP2qF1D9it81NA3VTb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimarEHNAs-1hCJf05YhkRQP2qF1D9it81NA3VTb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Another thing that I was thinking of is what happens if you have a
> >> huge gart and allocate a lot of coherent memory. Could that
> >> potentially exhaust IOMMU resources?
> >
> > <scratches his head>
> >
> > So the GART is in the PCI space in one of the BARs of the device right?
> > (We are talking about the discrete card GART, not the poor man AMD IOMMU?)
> > The PCI space is under the 4GB, so it would be considered coherent by
> > definition.
> 
> GART is not a PCI BAR; it's just a remapper for system pages.  On
> radeon GPUs at least there is a memory controller with 3 programmable
> apertures: vram, internal gart, and agp gart.  You can map these

To access it, ie, to program it, you would need to access the PCIe card
MMIO regions, right? So that would be considered in PCI BAR space?

> resources whereever you want in the GPU's address space and then the
> memory controller takes care of the translation to off-board resources
> like gart pages.  On chip memory clients (display controllers, texture
> blocks, render blocks, etc.) write to internal GPU addresses.  The GPU
> has it's own direct connection to vram, so that's not an issue.  For
> AGP, the GPU specifies aperture base and size, and you point it to the
> bus address of gart aperture provided by the northbridge's AGP
> controller.  For internal gart, the GPU has a page table stored in

I think we are just talking about the GART on the GPU, not the old AGP
GART.

> either vram or uncached system memory depending on the asic.  It
> provides a contiguous linear aperture to GPU clients and the memory
> controller translates the transactions to the backing pages via the
> pagetable.

So I think I misunderstood what is meant by 'huge gart'. That sounds
like linear address space provided by GPU. And hooking up a lot of coherent
memory (so System RAM) to that linear address space would be no different that what
is currently being done. When you allocate memory using page_alloc(GFP_DMA32)
and hook up that memory to the linear space you exhaust the same amount of
ZONE_DMA32 memory as if you were to use the PCI API. It comes from the same
pool, except that doing it from the PCI API gets you the bus address right
away.
