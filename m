Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145Ab1ESWK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:10:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59318 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954Ab1ESWK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AeVLxYdNq/8KadUPw3OoVvvA2GCDec6bHiz/fJ87VX06WPTrfVg3/MmWKQ7kzBVpKi
         NOzg3KfBRTHQ12LfNyi+e9rnJQCHhbObFb3thtYdlsEtyTbSl4K7D9Inxu/CQL4n13dZ
         MxT/9ewg7mu6gR4aKJ7atvuhl/Vflc5ywO29U=
MIME-Version: 1.0
In-Reply-To: <4DD53E2B.2090002@ladisch.de>
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
	<20110519145921.GE9854@dumpdata.com>
	<4DD53E2B.2090002@ladisch.de>
Date: Fri, 20 May 2011 00:10:57 +0200
Message-ID: <BANLkTinO1xR4XTN2B325pKCpJ3AjC9YidA@mail.gmail.com>
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Clemens, Konrad, others,

On Thu, May 19, 2011 at 5:58 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Konrad Rzeszutek Wilk wrote:
>> On Thu, May 19, 2011 at 12:14:40AM +0200, Leon Woestenberg wrote:
>> > I cannot get my driver's mmap() to work. I allocate 64 KiB ringbuffer
>> > using pci_alloc_consistent(), then implement mmap() to allow programs
>> > to map that memory into their user space.
>> > ...
>> > int ringbuffer_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> > {
>> >         /* the buffer allocated with pci_alloc_consistent() */
>> >     void *vaddr = ringbuffer_virt;
>> >     int ret;
>> >
>> >     /* find the struct page that describes vaddr, the buffer
>> >      * allocated with pci_alloc_consistent() */
>> >     struct page *page = virt_to_page(lro_char->engine->ringbuffer_virt);
>> >     vmf->page = page;
>> >
>> >         /*** I have verified that vaddr, page, and the pfn correspond with vaddr = pci_alloc_consistent() ***/
>> >     ret = vm_insert_pfn(vma, address, page_to_pfn(page));
>>
>> address is the vmf->virtual_address?
>>
yes, I missed that line when removing some noise:

	unsigned long address = (unsigned long)vmf->virtual_address;

>> And is the page_to_pfn(page) value correct? As in:
>>
>>   int pfn = page_to_pfn(page);
>>
>>   WARN(pfn << PAGE_SIZE != vaddr,"Something fishy.");
>>
Yes, this holds true.

I also verified that the pfn corresponds with the pfn of the virtual
address returned by pci_alloc_consistent().

>> Hm, I think I might have misled you now that I look at that WARN.
>>
>> The pfn to be supplied has to be physical page frame number. Which in
>> this case should be your bus addr shifted by PAGE_SIZE. Duh! Try that
>> value.
>
The physical address? Why? (Just learning here, this is no objection
to your suggestion.)

Also, the bus address is not the physical address, or not in general.
For example on IOMMU systems this certainly doesn't hold true.

So how can I reliably find the out the physical memory address of
pci_alloc_consistent() memory?

> There are wildly different implementations of pci_alloc_consistent
> (actually dma_alloc_coherent) that can return somewhat different
> virtual and/or physical addresses.
>
>> I think a better example might be the 'hpet_mmap' code
>
> Which is x86 and ia64 only.
>
>> > static int ringbuffer_mmap(struct file *file, struct vm_area_struct *vma)
>> > {
>> >     vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>
> So is this an architecture without coherent caches?
>
My aim is to have an architecture independent driver.

My goal is to make sure the CPU can poll for data that the PCI(e) bus
master writes into host memory.

> Or would you want to use pgprot_dmacoherent, if available?
>
Hmm, let me check that.

> I recently looked into this problem, and ended up with the code below.
> I then decided that streaming DMA mappings might be a better idea.
>
I got streaming DMA mappings working already. I cannot use them in my
case as streaming mappings are not cache-coherent in general.

Thanks for the code snippet, it seems x86 only though?

Regards,
-- 
Leon
