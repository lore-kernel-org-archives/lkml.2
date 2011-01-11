Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1AKT2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:28:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43405 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab1AKT2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KKl4y62GuyKzhTPZdR8PPObp7O52L0Sr8+WyJAxzVh3K5z8OpwYemfSyfaMfnEdcA2
         ADkZmPohDoaX1xA0SlXwUAXAyqQNJaxJAr2rugzFR9VhK+3kQpkzLYPWlTb7kUBiD9DX
         ZUyoEk0/asmEqq/KBkaHiQyWseoXA0g4g73kM=
MIME-Version: 1.0
In-Reply-To: <20110111182857.GC29223@dumpdata.com>
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
	<20110111182857.GC29223@dumpdata.com>
Date: Tue, 11 Jan 2011 14:28:36 -0500
Message-ID: <AANLkTimTc+q-qzL1kbjOsxiGgKjg2fnweh88FKQFHfXp@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
From: Alex Deucher <alexdeucher@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, konrad@darnok.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 1:28 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Jan 11, 2011 at 01:12:57PM -0500, Alex Deucher wrote:
>> On Tue, Jan 11, 2011 at 11:59 AM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> >> >> Another thing that I was thinking of is what happens if you have a
>> >> >> huge gart and allocate a lot of coherent memory. Could that
>> >> >> potentially exhaust IOMMU resources?
>> >> >
>> >> > <scratches his head>
>> >> >
>> >> > So the GART is in the PCI space in one of the BARs of the device right?
>> >> > (We are talking about the discrete card GART, not the poor man AMD IOMMU?)
>> >> > The PCI space is under the 4GB, so it would be considered coherent by
>> >> > definition.
>> >>
>> >> GART is not a PCI BAR; it's just a remapper for system pages.  On
>> >> radeon GPUs at least there is a memory controller with 3 programmable
>> >> apertures: vram, internal gart, and agp gart.  You can map these
>> >
>> > To access it, ie, to program it, you would need to access the PCIe card
>> > MMIO regions, right? So that would be considered in PCI BAR space?
>>
>> yes, you need access to the mmio aperture to configure the gpu.  I was
>> thinking you mean something akin the the framebuffer BAR only for gart
>> space which is not the case.
>
> Aaah, gotcha.
>>
>> >
>> >> resources whereever you want in the GPU's address space and then the
>> >> memory controller takes care of the translation to off-board resources
>> >> like gart pages.  On chip memory clients (display controllers, texture
>> >> blocks, render blocks, etc.) write to internal GPU addresses.  The GPU
>> >> has it's own direct connection to vram, so that's not an issue.  For
>> >> AGP, the GPU specifies aperture base and size, and you point it to the
>> >> bus address of gart aperture provided by the northbridge's AGP
>> >> controller.  For internal gart, the GPU has a page table stored in
>> >
>> > I think we are just talking about the GART on the GPU, not the old AGP
>> > GART.
>>
>> Ok.  I just mentioned it for completeness.
>
> <nods>
>>
>> >
>> >> either vram or uncached system memory depending on the asic.  It
>> >> provides a contiguous linear aperture to GPU clients and the memory
>> >> controller translates the transactions to the backing pages via the
>> >> pagetable.
>> >
>> > So I think I misunderstood what is meant by 'huge gart'. That sounds
>> > like linear address space provided by GPU. And hooking up a lot of coherent
>> > memory (so System RAM) to that linear address space would be no different that what
>> > is currently being done. When you allocate memory using page_alloc(GFP_DMA32)
>> > and hook up that memory to the linear space you exhaust the same amount of
>> > ZONE_DMA32 memory as if you were to use the PCI API. It comes from the same
>> > pool, except that doing it from the PCI API gets you the bus address right
>> > away.
>> >
>>
>> In this case GPU clients refers to the hw blocks on the GPU; they are
>> the ones that see the contiguous linear aperture.  From the
>> application's perspective, gart memory looks like any other pages.
>
> <nods>. Those 'hw blocks' or 'gart memory' are in reality
> just pages received via the 'alloc_page()' (before this patchset and
> also after this patchset) Oh wait, this 'hw blocks' or 'gart memory' can also
> refer to the VRAM memory right? In which case that is not memory allocated via
> 'alloc_page' but using a different mechanism. Is TTM used then? If so how
> do you stick those VRAM pages under its accounting rules? Or do the drivers
> use some other mechanism for that that is dependent on each driver?
>

"hw blocks" refers to the different sections of the GPU (texture
fetchers, render targets, display controllers), not memory buffers.
E.g., if you want to read a texture from vram or gart, you'd program
the texture base address to the address of the texture in the GPU's
address space.  E.g., you might map 512 MB of vram at from 0x00000000
and a 512 MB gart aperture at 0x20000000 in the GPU's address space.
If you have a texture at the start of vram, you'd program the texture
base address to 0x0000000 or if it was at the start of the gart
aperture, you'd program it to 0x20000000.  To the GPU, the gart looks
like a linear array, but to everything else (driver, apps), it's just
pages.  The driver manages vram access using ttm.  The GPU has access
to the entire amount of vram directly, but the CPU can only access it
via the PCI framebuffer BAR.  On systems with more vram than
framebuffer BAR space, the CPU can only access buffers in the region
covered
by the BAR (usually the first 128 or 256 MB of vram depending on the
BAR).  For the CPU to access a buffer in vram, the GPU has to move it
to the area covered by the BAR or to gart memory.

Alex
