Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1AKQV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:21:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40653 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab1AKQVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rHKhSMOjiA8gIZ6yhc2S0Ws42C7pT1nolHx51wf0C/ar4uvZaw5/5yGmB91s/7OgAo
         ThzYeva4Nvsh+oy8fWK3NrEc6faNr/4aUrBvk/JX3mEEX+WOdVdG3G2Y7EilsSYAUOXb
         tNLlBjDbV7QMP15ElOB2GzM8DTpviNiH//wJk=
MIME-Version: 1.0
In-Reply-To: <20110111155545.GD10897@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
	<4D2B16F3.1070105@shipmail.org>
	<20110110152135.GA9732@dumpdata.com>
	<4D2B2CC1.2050203@shipmail.org>
	<20110110164519.GA27066@dumpdata.com>
	<4D2B70FB.3000504@shipmail.org>
	<20110111155545.GD10897@dumpdata.com>
Date: Tue, 11 Jan 2011 11:21:52 -0500
Message-ID: <AANLkTimarEHNAs-1hCJf05YhkRQP2qF1D9it81NA3VTb@mail.gmail.com>
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

On Tue, Jan 11, 2011 at 10:55 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> . snip ..
>> >>>I think the error path would be the same in both cases?
>> >>Not really. The really dangerous situation is if TTM is allowed to
>> >>exhaust all GFP_KERNEL memory. Then any application or kernel task
>> >Ok, since GFP_KERNEL does not contain the GFP_DMA32 flag then
>> >this should be OK?
>>
>> No, Unless I miss something, on a machine with 4GB or less,
>> GFP_DMA32 and GFP_KERNEL are allocated from the same pool of pages?
>
> Yes. Depending on the E820 and where the PCI hole is present. More
> details below.
>>
>> >
>> >>What *might* be possible, however, is that the GFP_KERNEL memory on
>> >>the host gets exhausted due to extensive TTM allocations in the
>> >>guest, but I guess that's a problem for XEN to resolve, not TTM.
>> >Hmm. I think I am missing something here. The GFP_KERNEL is any memory
>> >and the GFP_DMA32 is memory from the ZONE_DMA32. When we do start
>> >using the PCI-API, what happens underneath (so under Linux) is that
>> >"real PFNs" (Machine Frame Numbers) which are above the 0x100000 mark
>> >get swizzled in for the guest's PFNs (this is for the PCI devices
>> >that have the dma_mask set to 32bit). However, that is a Xen MMU
>> >accounting issue.
>>
>>
>> So I was under the impression that when you allocate coherent memory
>> in the guest, the physical page comes from DMA32 memory in the host.
>
> No. It comes from DMA32 zone off the hypervisor pool. If say you have a machine
> with 24GB, the first guest (Dom0) could allocate memory from 20->24GB
> (so only 4GB allocated to it). It will then also fetch 64MB from the DMA32
> zone for the SWIOTLB. Then the next guest, say 4GB (gets 16GB->20GB) - gets
> 64MB from DMA32. And  so on.
>
> So at the end we have 16GB taken from 8GB->24GB, and 320MB taken from
> 0->4GB. When you start allocating coherent memory from each guest
> (and yeah, say we use 2GB each), we end up with the first guest getting
> the 2GB, the second getting 1.7GB, and then the next two getting zil.
>
> You still have GFP_KERNEL memory in each guest - the first one has 2GB left
> , then second 2.3, the next two have each 4GB.
>
> From the hyprevisor pool perspective, the 0-4GB zone is exhausted, so
> is the 8GB->24GB, but it still has 4GB->8GB free - so it can launch one more
> guest (but without PCI passthrough devices).
>
>> On a 4GB machine or less, that would be the same as kernel memory.
>> Now, if 4 guests think they can allocate 2GB of coherent memory
>> each, you might run out of kernel memory on the host?
>
> So host in this case refers to the Hypervisor and it does not care
> about the DMA or what - it does not have any device drivers(*) or such.
> The first guest (dom0) is the one that deals with the device drivers.
>
> *: It has one: the serial port, but that is not really that important
> for this discussion.
>>
>>
>> Another thing that I was thinking of is what happens if you have a
>> huge gart and allocate a lot of coherent memory. Could that
>> potentially exhaust IOMMU resources?
>
> <scratches his head>
>
> So the GART is in the PCI space in one of the BARs of the device right?
> (We are talking about the discrete card GART, not the poor man AMD IOMMU?)
> The PCI space is under the 4GB, so it would be considered coherent by
> definition.

GART is not a PCI BAR; it's just a remapper for system pages.  On
radeon GPUs at least there is a memory controller with 3 programmable
apertures: vram, internal gart, and agp gart.  You can map these
resources whereever you want in the GPU's address space and then the
memory controller takes care of the translation to off-board resources
like gart pages.  On chip memory clients (display controllers, texture
blocks, render blocks, etc.) write to internal GPU addresses.  The GPU
has it's own direct connection to vram, so that's not an issue.  For
AGP, the GPU specifies aperture base and size, and you point it to the
bus address of gart aperture provided by the northbridge's AGP
controller.  For internal gart, the GPU has a page table stored in
either vram or uncached system memory depending on the asic.  It
provides a contiguous linear aperture to GPU clients and the memory
controller translates the transactions to the backing pages via the
pagetable.

Alex

>
> However the PCI space with its BARs eats in the 4GB space, so if you
> have a 1GB region from 0xC0000->0x100000, then you only have 3GB
> left of DMA32 zone.
>
> If I think of this as an accounting, and if the PCI space goes further
> down (say 0x40000, so from 2GB->4GB it is a E820 gap, and 0GB->2GB is System RAM
> with 4GB->6GB being the other System RAM, for a cumulative number of 4GB
> of memory in the machine), we would only have 2GB of DMA32 zone (The GFP_KERNEL
> zone is 4GB, while GFP_DMA32 zone is 2GB).
>
> Then the answer is yes. However, wouldn't such device be 64-bit? And
> if they are 64-bit, then the TTM API wouldn't bother to allocate pages
> from the 32-bit region, right?
>
>>
>> >>/Thomas
>> >>
>> >>*) I think gem's flink still is vulnerable to this, though, so it
>> >Is there a good test-case for this?
>>
>>
>> Not put in code. What you can do (for example in an openGL app) is
>> to write some code that tries to flink with a guessed bo name until
>> it succeeds. Then repeatedly from within the app, try to flink the
>> same name until something crashes. I don't think the linux OOM
>> killer can handle that situation. Should be fairly easy to put
>> together.
>
> Uhhh, OK, you just flew over what I know about graphics. Let me
> research this a bit more.
>
>>
>> /Thomas
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
