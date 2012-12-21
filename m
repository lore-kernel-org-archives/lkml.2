Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2LUWom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:44:42 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52214 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LUWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:44:40 -0500
MIME-Version: 1.0
In-Reply-To: <20121221222619.GA1102@phenom.dumpdata.com>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
	<1354089042-10023-13-git-send-email-yinghai@kernel.org>
	<20121221222619.GA1102@phenom.dumpdata.com>
Date: Fri, 21 Dec 2012 14:44:39 -0800
X-Google-Sender-Auth: WlZiWKEv3a-s3Ru8UTZBPaSLPWk
Message-ID: <CAE9FiQXsi5gj6QGp-rreH6Bqb6A5WTA6umFiiJ1mQFRp6u5ziw@mail.gmail.com>
Subject: Re: [PATCH v5 12/13] x86, 64bit: Print init kernel lowmap correctly
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 2:26 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 4178530..30f6190 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -304,10 +304,14 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
>>  void __init cleanup_highmap(void)
>>  {
>>       unsigned long vaddr = __START_KERNEL_map;
>> -     unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
>> +     unsigned long vaddr_end = __START_KERNEL_map + KERNEL_IMAGE_SIZE;
>
> Should you remove the line in head64.c that sets the
> max_pfn_mapped to KERNEL_IMAGE_SIZE >> PAGE_SHIFT?
>
>>       unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
>>       pmd_t *pmd = level2_kernel_pgt;
>>
>> +     /* Xen has its own end somehow with abused max_pfn_mapped */
>
> Could you clarify please?
>
> My recollection is that the max_pfn_mapped would point to the end of the
> RAMdisk. And yes (from mmu.c):
>
>    1862         /* max_pfn_mapped is the last pfn mapped in the initial memory
>    1863          * mappings. Considering that on Xen after the kernel mappings we
>    1864          * have the mappings of some pages that don't exist in pfn space, we
>    1865          * set max_pfn_mapped to the last real pfn mapped. */
>    1866         max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
>    1867
>
> And if you follow xen_start_info, you get to include/xen/interface/xen.h which has:
>
>     406  *  4. This the order of bootstrap elements in the initial virtual region:
>     407  *      a. relocated kernel image
>     408  *      b. initial ram disk              [mod_start, mod_len]
>     409  *      c. list of allocated page frames [mfn_list, nr_pages]
>
> so per that code I believe max_pfn_mapped covers the kernel and the ramdisk - no more.
>

for native path, in x86_64_start_kernel, we set max_pfn_mapped wrongly (my fault
, I messed up low mapping and high mapping).
before this patchset, low_mapping end before end of x86_64_start_kernel is
1G, and high mapping end is 512M.

max_pfn_mapped is for low mapping.

in this patch, for native patch, we keep max_pfn_mapped untouched, so
before clean_highmap, it will be 0.

so we check !max_pfn_mapped to make xen still work.

>
>> +     if (max_pfn_mapped)
>> +             vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
>> +
>>       for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
>>               if (pmd_none(*pmd))
>>                       continue;
>> --
>
> This part of the patch does not seem to have much to do with the printk?
> Should it be seperate patch?

maybe we can change the subject of this patch to:

Subject: [PATCH] x86, 64bit: Don't set max_pfn_mapped wrong on native boot path

?
