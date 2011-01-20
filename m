Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1ATRtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:49:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37581 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1ATRtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cZaFSjuy+fVXKTh+F6ohZjWcOvT0iEszPgnSWC/49ksm9YwOw0r5Ekfz9upffck69e
         CZV89qWF4Rnd7Gxr3awIgmR66oqyMKeOlwF26Z5AdnMbanPrYEoOplkDICyGNhQ4IVSc
         qxGAazeLsPWAMz72DxDbLJre9jGrfN4i185Wc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=nsAOtLPK75Wy5Rm8pfWob8xTP5259DyYuxR9J@mail.gmail.com>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com>
	<1295544047.9039.609.camel@nimitz>
	<AANLkTi=nsAOtLPK75Wy5Rm8pfWob8xTP5259DyYuxR9J@mail.gmail.com>
Date: Fri, 21 Jan 2011 02:48:59 +0900
Message-ID: <AANLkTinLLYYUXe=ZYKKGXgKU_p5RHv2COX_L1zCk8Ba+@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
From: KyongHo Cho <pullip.linux@gmail.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Cc: KyongHo Cho <pullip.cho@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 2:20 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Thu, 2011-01-20 at 18:45 +0900, KyongHo Cho wrote:
>> Sparsemem allows that a bank of memory spans over several adjacent
>> sections if the start address and the end address of the bank
>> belong to different sections.
>> When gathering statictics of physical memory in mem_init() and
>> show_mem(), this possiblity was not considered.
>>
>> This patch guarantees that simple increasing the pointer to page
>> descriptors does not exceed the boundary of a section
> ...
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 57c4c5c..6ccecbe 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -93,24 +93,38 @@ void show_mem(void)
>>
>>               pfn1 = bank_pfn_start(bank);
>>               pfn2 = bank_pfn_end(bank);
>> -
>> +#ifndef CONFIG_SPARSEMEM
>>               page = pfn_to_page(pfn1);
>>               end  = pfn_to_page(pfn2 - 1) + 1;
>> -
>> +#else
>> +             pfn2--;
>>               do {
>> -                     total++;
>> -                     if (PageReserved(page))
>> -                             reserved++;
>> -                     else if (PageSwapCache(page))
>> -                             cached++;
>> -                     else if (PageSlab(page))
>> -                             slab++;
>> -                     else if (!page_count(page))
>> -                             free++;
>> -                     else
>> -                             shared += page_count(page) - 1;
>> -                     page++;
>> -             } while (page < end);
>> +                     page = pfn_to_page(pfn1);
>> +                     if (pfn_to_section_nr(pfn1) < pfn_to_section_nr(pfn2)) {
>> +                             pfn1 += PAGES_PER_SECTION;
>> +                             pfn1 &= PAGE_SECTION_MASK;
>> +                     } else {
>> +                             pfn1 = pfn2;
>> +                     }
>> +                     end = pfn_to_page(pfn1) + 1;
>> +#endif
>
> This problem actually exists without sparsemem, too.  Discontigmem (at
> least) does it as well.
>

Actually, as long as a bank in meminfo only resides in a pgdat, no
problem happens
because there is no restriction of size of area in a pgdat.
That's why I just considered about sparsemem.

> The x86 version of show_mem() actually manages to do this without any
> #ifdefs, and works for a ton of configuration options.  It uses
> pfn_valid() to tell whether it can touch a given pfn.
>
> Long-term, it might be a good idea to convert arm's show_mem() over to
> use pgdat's like everything else.  But, for now, you should just be able
> to do something roughly like this:
>
> -               page = pfn_to_page(pfn1);
> -               end  = pfn_to_page(pfn2 - 1) + 1;
> -
> -               do {
> +               for (pfn = pfn1; pfn < pfn2; pfn++) {
> +                       if (!pfn_valid(pfn))
> +                               continue;
> +                       page = pfn_to_page(pfn);
> +
>                        total++;
>                        if (PageReserved(page))
>                                reserved++;
>                        else if (PageSwapCache(page))
>                                cached++;
>                        else if (PageSlab(page))
>                                slab++;
>                        else if (!page_count(page))
>                                free++;
>                        else
>                                shared += page_count(page) - 1;
>                        page++;
> -               } while (page < end);
> +               }
>
> That should work for sparsemem, or any other crazy memory models that we
> come up with.  pfn_to_page() is pretty quick, especially when doing it
> in a tight loop like that.
>

That's true.
I worried that pfn_to_page() in sparsemem is a bit slower than that in flatmem.
Moreover, the previous one didn't use pfn_to_page() but page++ for the
performance.
Nevertheless, I also think that pfn_to_page() make the code neat.
