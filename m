Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0CVCeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:34:00 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:34609 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0CVCd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tmLiTwDqWI3ZTDNWPxW4T/g3yn1WtY01RhP4D9cbPrH75jIqgcNH2xonR/PeMCSVj3
         2XLH3oZLcThOAVFDxW8j6u20dArV49ot2DGlelxKsRIipVv9ORnGRmNjun45tKEqnqjY
         jyunhJT1rSw/ASgr+R9t8puOnGuie60mn/hHQ=
MIME-Version: 1.0
In-Reply-To: <4BA449E2.3080707@kernel.org>
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
	 <4BA449E2.3080707@kernel.org>
Date: Mon, 22 Mar 2010 10:33:58 +0800
Message-ID: <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
From: graff yang <graff.yang@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 03/19/2010 06:02 PM, graff.yang@gmail.com wrote:
>>
>> From: Graff Yang<graff.yang@gmail.com>
>>
>> This patch supports dynamic alloc/free percpu area for nommu arch like
>> blackfin.
>> It allocates contiguous pages in funtion pcpu_get_vm_areas() instead of
>> getting none contiguous pages then vmap it in mmu arch.
>> As we can not get the real page structure through vmalloc_to_page(), so
>> it also modified the nommu version vmalloc_to_page()/vmalloc_to_pfn().
>>
>> Signed-off-by: Graff Yang<graff.yang@gmail.com>
>
> Heh heh... I've never imagined there would be a SMP architecture w/o
> mmu.  That's pretty interesting.  I mean, there is real estate for
> multiple cores but not for mmu?

Yes, we ported the SMP to the blackfin dual core processor BF561.

>
>> diff --git a/mm/nommu.c b/mm/nommu.c
>> index 605ace8..98bbdf4 100644
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -255,13 +255,15 @@ EXPORT_SYMBOL(vmalloc_user);
>>
>>  struct page *vmalloc_to_page(const void *addr)
>>  {
>> -       return virt_to_page(addr);
>> +       return (struct page *)
>> +                       (virt_to_page(addr)->index) ? :
>> virt_to_page(addr);
>
> Nothing major but isn't it more usual to write ?: without the
> intervening space?
>
>> +#ifdef CONFIG_SMP
>> +int map_kernel_range_noflush(unsigned long addr, unsigned long size,
>> +                                       pgprot_t prot, struct page
>> **pages)
>> +{
>
> More nitpicks.
>
>> +       int i, nr_page = size>>  PAGE_SHIFT;
>
>               nr_pages = size >> PAGE_SHIFT;
>
>> +       for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)
>
>                    i < nr_pages
>
>> +               virt_to_page(addr)->index = (pgoff_t)pages[i];
>> +       return size>>  PAGE_SHIFT;
>
>        return size >> PAGE_SHIFT;
>
> I think checkpatch would whine about these too.

OK.

>
>> +void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
>> +{
>> +       int i, nr_page = size>>  PAGE_SHIFT;
>> +       for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)
>> +               virt_to_page(addr)->index = 0;
>> +}
>> +
>> +struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>> +                                       const size_t *sizes, int nr_vms,
>> +                                               size_t align, gfp_t
>> gfp_mask)
>
> Hmmm... in general, one of the reasons the percpu allocation is
> complex is to avoid contiguous allocations while avoiding additional
> TLB / NUMA overhead on machines with rather complex memory
> configuration (which is pretty common these days).  If the memory has
> to be allocated contiguous anyway, it probably would be much simpler
> to hook at higher level and simply allocate each chunk contiguously.
> I'll look into it.
I understand the complexity of percpu allocation code. As a nommu arch,
we have to allocate a bulk of memory in one time to insure its contiguous.
And in my implementation, many pages are wasted.
It would be better, if the percpu allocation code provide some hooks for us.
Thanks for your feedback.

-- 
-Graff
