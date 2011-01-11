Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1AKSNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:13:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35774 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1AKSM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cjQPdujBCezBYdOtrS+Ewbs5y1/D5Zapa+u8vlK9N/NXdGstIJjEyJ37BJTVfg+RYs
         PQxxdKnr/ymmIgpeyViIYrXRSeFNQmTegfnrrhnYOYKt3xWVG5sXHSUXzKO5MVXZfFDf
         qYCNRZX13qKdi/x+n0dnMmOE8HcQoIixNHklA=
MIME-Version: 1.0
In-Reply-To: <20110111165953.GI10897@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
	<4D2B16F3.1070105@shipmail.org>
	<20110110152135.GA9732@dumpdata.com>
	<4D2B2CC1.2050203@shipmail.org>
	<20110110164519.GA27066@dumpdata.com>
	<4D2B70FB.3000504@shipmail.org>
	<20110111155545.GD10897@dumpdata.com>
	<AANLkTimarEHNAs-1hCJf05YhkRQP2qF1D9it81NA3VTb@mail.gmail.com>
	<20110111165953.GI10897@dumpdata.com>
Date: Tue, 11 Jan 2011 13:12:57 -0500
Message-ID: <AANLkTinkP8b9GNMFqWygJb0O17neB7RLnxTi-DaG13pR@mail.gmail.com>
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

On Tue, Jan 11, 2011 at 11:59 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> >> Another thing that I was thinking of is what happens if you have a
>> >> huge gart and allocate a lot of coherent memory. Could that
>> >> potentially exhaust IOMMU resources?
>> >
>> > <scratches his head>
>> >
>> > So the GART is in the PCI space in one of the BARs of the device right?
>> > (We are talking about the discrete card GART, not the poor man AMD IOMMU?)
>> > The PCI space is under the 4GB, so it would be considered coherent by
>> > definition.
>>
>> GART is not a PCI BAR; it's just a remapper for system pages.  On
>> radeon GPUs at least there is a memory controller with 3 programmable
>> apertures: vram, internal gart, and agp gart.  You can map these
>
> To access it, ie, to program it, you would need to access the PCIe card
> MMIO regions, right? So that would be considered in PCI BAR space?

yes, you need access to the mmio aperture to configure the gpu.  I was
thinking you mean something akin the the framebuffer BAR only for gart
space which is not the case.

>
>> resources whereever you want in the GPU's address space and then the
>> memory controller takes care of the translation to off-board resources
>> like gart pages.  On chip memory clients (display controllers, texture
>> blocks, render blocks, etc.) write to internal GPU addresses.  The GPU
>> has it's own direct connection to vram, so that's not an issue.  For
>> AGP, the GPU specifies aperture base and size, and you point it to the
>> bus address of gart aperture provided by the northbridge's AGP
>> controller.  For internal gart, the GPU has a page table stored in
>
> I think we are just talking about the GART on the GPU, not the old AGP
> GART.

Ok.  I just mentioned it for completeness.

>
>> either vram or uncached system memory depending on the asic.  It
>> provides a contiguous linear aperture to GPU clients and the memory
>> controller translates the transactions to the backing pages via the
>> pagetable.
>
> So I think I misunderstood what is meant by 'huge gart'. That sounds
> like linear address space provided by GPU. And hooking up a lot of coherent
> memory (so System RAM) to that linear address space would be no different that what
> is currently being done. When you allocate memory using page_alloc(GFP_DMA32)
> and hook up that memory to the linear space you exhaust the same amount of
> ZONE_DMA32 memory as if you were to use the PCI API. It comes from the same
> pool, except that doing it from the PCI API gets you the bus address right
> away.
>

In this case GPU clients refers to the hw blocks on the GPU; they are
the ones that see the contiguous linear aperture.  From the
application's perspective, gart memory looks like any other pages.

Alex
