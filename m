Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0JVTGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:06:35 -0400
Received: from claw.goop.org ([74.207.240.146]:36111 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab0JVTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:06:32 -0400
Message-ID: <4CC1E0B6.3070303@goop.org>
Date: Fri, 22 Oct 2010 12:06:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com> <4CC0CA07.3000306@goop.org> <4CC0DEB8.1060309@zytor.com> <20101022150826.GA23325@dumpdata.com> <4CC1BF58.9020001@zytor.com>
In-Reply-To: <4CC1BF58.9020001@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/22/2010 09:44 AM, H. Peter Anvin wrote:
> On 10/22/2010 08:08 AM, Konrad Rzeszutek Wilk wrote:
>>> Okay, could you clarify this part a bit?  Why does the kernel need to
>>> know the difference between "pseudo-physical" and "machine addresses" at
>>> all?  If they overlap, there is a problem, and if they don't overlap, it
>>> will be a 1:1 mapping anyway...
>> The flag (_PAGE_IOMAP) is used when we set the PTE so that the MFN value is
>> used instead of the PFN. We need that b/c when a driver does page_to_pfn()
>> it ends up using the PFN as bus address to write out registers data.
>>
>> Without this patch, the page->virt->PFN value is used and the PFN != to real MFN
>> so we end up writing in a memory address that the PCI device has no idea about.
>> By setting the PTE with the MFN, the virt->PFN gets the real MFN value.
>>
>> The drivers I am talking about are mostly, if not all, located in drivers/gpu
>> and it looks that we are missing two more patches to utilize the patch
>> that Jeremy posted.
>>
>> Please note that I am _not_ suggesting that the two patches
>> below should go out - I still need to post them on drm mailing list.
>>
> I'm still seriously confused.  If I understand this correctly, we're
> talking about DMA addresses here (as opposed to PIO addresses, i.e.
> BARs), right?
>
> It's the bimodality that really bothers me.  I understand of course that
> Xen imposes yet another address remapping layer, but I'm having a hard
> time understanding any conditions under with we would need that layer to
> go away, as long as DMA addresses are translated via the DMA APIs -- and
> if they aren't, then iommus will break, too.
>
> As such, I don't grok this page flag and what it does, and why it's
> needed.  I'm not saying it's *wrong*, I'm saying the design is opaque to
> me and I'm not sure it is the right solution.

Well, if you want to map a normal memory page, you'd use, say,
pfn_pte(pfn, PAGE_KERNEL) to generate the pte.  The pfn is a
domain-local pseudo-physical address.  When it ends up in
xen_make_pte(), it will translate the the pfn into a machine-global mfn
to generate a pte_t which can be inserted into a pagetable.  (And when
that pagetable starts being used as such, Xen will validate that the mfn
is actually one the domain is allowed to address.)

However, if you're doing an ioremap(), then the mapped address is a
hardware one.  In that case, we construct the pte with
pfn_pte(device_pfn, PAGE_KERNEL_IO), which sets the _PAGE_IOMAP flag in
the pte flags.  When it gets to xen_make_pte(), it sees _PAGE_IOMAP and
constructs a pte_t containing the literal untranslated device_pfn
(really an mfn).  (And again, Xen will check that the domain has access
to that mfn before allowing the mapping to be used.)

We use the DMA API to make sure that pfn<->mfn conversions happen
correctly when setting up DMA (all the Xen swiotlb stuff Konrad has been
working on).  _PAGE_IOMAP is used in the implementation of that, as well
as in ioremap(), remap_pfn_range(), drm, etc.

All this machinery has been in the kernel for quite a while.  This
particular patch fixes gap, making sure that a vma with VM_IO set will
be mapped with _PAGE_IOMAP set, which makes a large class of drm, fbdev,
capture, etc device drivers work properly under Xen unmodified.  (Though
DRM is full of other pitfalls and Konrad has been up to his neck in
piranhas lately, which is why is answer is a little fixated on the DRM
aspect.)

    J
