Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1EXOSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:18:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58978 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1EXOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BSjgblmAdEEj4/enLRb0K6do3bA04i0w7kkzsJT1UstJQkOBhnJ99Pu5DVwCjPSsNm
         74mkTNql0Heu0lnqn5KDiapxQWFdzJm+7TpfZrPXjnuyeLnR4AwXCPOUgZxNgdGYTUct
         bDP1TWOE2wMtliO0m1BtB3U8DoawrTBj6jbp8=
MIME-Version: 1.0
In-Reply-To: <4DDA1B18.3080201@ladisch.de>
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
	<20110519145921.GE9854@dumpdata.com>
	<4DD53E2B.2090002@ladisch.de>
	<BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>
	<4DD60F57.8030000@ladisch.de>
	<s5htycp6b25.wl%tiwai@suse.de>
	<BANLkTi=P6WP-+BiqEwCRTxaNTqNHT988wA@mail.gmail.com>
	<4DDA1B18.3080201@ladisch.de>
Date: Tue, 24 May 2011 16:18:11 +0200
Message-ID: <BANLkTikOEssVJ6mXOUxt=BUFX6ERqxMWwg@mail.gmail.com>
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Clemens,

On Mon, May 23, 2011 at 10:30 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Leon Woestenberg wrote:
>> Having dma_mmap_coherent() there is good for one or two archs, but how
>> can we built portable drivers if the others arch's are still missing?
>
> Easy: Resolve all issues, implement it for all the other arches, and add
> it to the official DMA API.
>
>> How would dma_mmap_coherent() look like on x86?
>
> X86 and some others are always coherent; just use vm_insert_page() or
> remap_page_range().
>
Hello Clemens,

On Mon, May 23, 2011 at 10:30 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Leon Woestenberg wrote:
>> Having dma_mmap_coherent() there is good for one or two archs, but how
>> can we built portable drivers if the others arch's are still missing?
>
> Easy: Resolve all issues, implement it for all the other arches, and add
> it to the official DMA API.
>
I could send patches, but I would get bashed. Would be a learning
experience though (and a long email thread).

>> How would dma_mmap_coherent() look like on x86?
>
> X86 and some others are always coherent; just use vm_insert_page() or
> remap_page_range().
>

For x86 (my current test system) I tend to go with remap_page_range()
so that the mapping is done before the pages are actually touched.

With that I leave the work-in-progress (dma_mmap_coherent) aside for a
moment, I'll revisit that later on ARM.

However, I still feel I'm treading sandy waters, not familiar enough
with the VM internals.

Does memory allocated with pci_alloc_consistent() need a get_page() in
the driver before I  remap_page_range() it?
Does memory allocated with __get_free_pages() need a get_page() in the
driver before I  remap_page_range() it?

And how about set_bit(PG_reserved, ...) on those pages? Is that
something of the past?

#if 0
...
<vm_insert_page implementation here, disabled>
...
#else /* remap_pfn_range */
#warning Using remap_pfn_range
static int buffer_mmap(struct file *file, struct vm_area_struct *vma)
{
        unsigned long vsize, vsize2;
        void *vaddr, *vaddr2;
        unsigned long start = vma->vm_start;

         * VM_RESERVED: prevent the pages from being swapped out */
        vma->vm_flags |= VM_RESERVED;
        vma->vm_private_data = file->private_data;

        /* allocated using __get_free_pages() or pci_alloc_consistent() */
        vaddr = buffer_virt;
        vsize = buffer_size;

        /* iterate over pages */
        vaddr2 = vaddr;
        vsize2 = vsize;
        while (vsize2 > 0) {
                printk(KERN_DEBUG "get_page(page=%p)\n", virt_to_page(vaddr2));
                get_page(virt_to_page(vaddr2));
                //set_bit(PG_reserved, &(virt_to_page(vaddr2)->flags));
                vaddr2 += PAGE_SIZE;
                vsize2 -= PAGE_SIZE;
        }
        remap_pfn_range(vma, vma->vm_start,
page_to_pfn(virt_to_page(vaddr)), vsize, vma->vm_page_prot);
        return 0;
}
#endif



Thanks for the explanation,

Regards,
-- 
Leon
