Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2B1HJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:09:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50012 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2B1HJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:09:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linkinjeon@gmail.com designates 10.204.128.75 as permitted sender) smtp.mail=linkinjeon@gmail.com; dkim=pass header.i=linkinjeon@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAF1ZMEdh19eNbknfNskQxKeo0sjP7ELOAdRi9zD5VEqTLBXj6Q@mail.gmail.com>
References: <28c262361003230146o7bca61e6h3af2062b1172fdb2@mail.gmail.com>
	<afc622a1003230511o108556f4s5d1282bd3122b3d9@mail.gmail.com>
	<BANLkTimKw3mg8N-gBxh3jbo9msaHOF3qPA@mail.gmail.com>
	<CAF1ZMEdh19eNbknfNskQxKeo0sjP7ELOAdRi9zD5VEqTLBXj6Q@mail.gmail.com>
Date: Tue, 28 Feb 2012 16:09:40 +0900
Message-ID: <CAKYAXd8O1ibkkv0wrPxJFxuCwtsdW1Z66WAxKN15FX2VZvV0gQ@mail.gmail.com>
Subject: Re: data consistency of high page
From: Namjae Jeon <linkinjeon@gmail.com>
To: "Dennis.Yxun" <dennis.yxun@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, yan@mips.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/28 Dennis.Yxun <dennis.yxun@gmail.com>:
> Hi NamJae:
>  We hit pretty much the same problem, highmem + cache consistence
> but our hardware should have cache alias problem
>  Could you try attached following patch?
Hi Dennis.
I already fixed it as your patch in our system before.
your patch looks reasonable to me.
Would you post this patch with adding the below ?

Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Tested-by: Namjae Jeon <linkinjeon@gmail.com>

Thanks~

>
> dmesg:
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096
> bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072
> bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536
> bytes)
> [    0.000000] Primary instruction cache 16kB, VIPT, 4-way, linesize 32
> bytes.
> [    0.000000] Primary data cache 16kB, 4-way, VIPT, no aliases, linesize 32
> byt
> es
> [    0.000000] MIPS secondary cache 128kB, 8-way, linesize 32
> bytes.
> [    0.000000] Writing ErrCtl
> register=00000000
> [    0.000000] Readback ErrCtl
> register=00000000
> [    0.000000] Memory: 510548k/262144k available (2728k kernel code, 13740k
> rese
> rved, 630k data, 5784k init, 262144k highmem)
>
> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
> index 00d70c8..536b7f9 100644
> --- a/arch/mips/mm/cache.c
> +++ b/arch/mips/mm/cache.c
> @@ -15,6 +15,7 @@
>  #include <linux/sched.h>
>  #include <linux/syscalls.h>
>  #include <linux/mm.h>
> +#include <linux/highmem.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/processor.h>
> @@ -83,8 +84,13 @@ void __flush_dcache_page(struct page *page)
>         struct address_space *mapping = page_mapping(page);
>         unsigned long addr;
>
> -       if (PageHighMem(page))
> +       if (PageHighMem(page) &&
> +               (addr = (unsigned long) kmap_atomic(page, KM_SYNC_DCACHE)))
> {
> +               flush_data_cache_page(addr);
> +               kunmap_atomic((void *)addr, KM_SYNC_DCACHE);
>                 return;
> +       }
>
>
>
> On Tue, Apr 5, 2011 at 4:17 PM, NamJae Jeon <linkinjeon@gmail.com> wrote:
>>
>> Hi.
>>
>> As you know, there is cache operation about highpage in arm arch.
>>
>> arch/arm/mm/flush.c
>>
>> -----------------------------------------------------------------------------------------------
>> if (!PageHighMem(page)) {
>>                __cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
>>        } else {
>>                void *addr = kmap_high_get(page);
>>                if (addr) {
>>                        __cpuc_flush_dcache_area(addr, PAGE_SIZE);
>>                        kunmap_high(page);
>>                } else if (cache_is_vipt()) {
>>                        /* unmapped pages might still be cached */
>>                        addr = kmap_atomic(page);
>>                        __cpuc_flush_dcache_area(addr, PAGE_SIZE);
>>                        kunmap_atomic(addr);
>>                }
>>        }
>>
>> -------------------------------------------------------------------------------------------------
>>
>> currently, mips kernel just return without cache operation.
>>
>> Would you plz tell me your opinion ?
>>
>> Thanks.
>>
>>
>> 2010/3/23 NamJae Jeon <linkinjeon@gmail.com>:
>> > Hi. Ralf.
>> >
>> > I'm Namjae.jeon. nice to meet you.
>> >
>> > I face cache aliasing problem on mips 34ke.
>> >
>> > Our target cache is 34kB 4way i/d-cache , 32bytes linesize.
>> >
>> > As you know, there is possibility of cache aliasing on 8kB per way.
>> >
>> > But mips arch of kernel mainline can not properly  handile this case.
>> >
>> > For example, highmem handling in __fluash_dcache_page function is just
>> > return.
>> >
>> > So, if argument page is page in highmem, it can not flush in dcache
>> > line.
>> >
>> > I want to listen your opinion.
>> >
>> > Thanks.
>> >
>> >
>> > 2010/3/23 Minchan Kim <minchan.kim@gmail.com>:
>> >> Hi, Ralf.
>> >>
>> >> Below is thread long time ago.
>> >> At that time, we can't end up the problem by some reason.
>> >> Sorry for that.
>> >>
>> >> The problem would occur, again.
>> >>
>> >> On Fri, Oct 16, 2009 at 6:24 PM, Ralf Baechle <ralf@linux-mips.org>
>> >> wrote:
>> >>> On Fri, Oct 16, 2009 at 02:17:19PM +0900, Minchan Kim wrote:
>> >>>
>> >>>> Many code of kernel fs usually allocate high page and flush.
>> >>>> But flush_dcache_page of mips checks PageHighMem to avoid flush
>> >>>> so that data consistency is broken, I think.
>> >>>
>> >>> What processor and cache configuration?
>> >>>
>> >>>> I found it's by you and Atsushi-san on 585fa724.
>> >>>> Why do we need the check?
>> >>>> Could you elaborte please?
>> >>>
>> >>> The if statement exists because __flush_dcache_page would crash if a
>> >>> page
>> >>> is not mapped.  This of course isn't correct but that wasn't a problem
>> >>> since highmem still is only supported on machines that don't have
>> >>> aliases.
>> >>>
>> >>>  Ralf
>> >>>
>> >>
>> >> Our system is following as.
>> >>
>> >> mips 34ke
>> >> primary i-cache 32kB VIPT 4way 32 byte line size.
>> >> primary d-cache 32kB 4way  32 bytes linesize
>> >>
>> >> If you have further questions, Namjae, Could you follow question of
>> >> Ralf?
>> >>
>> >> --
>> >> Kind regards,
>> >> Minchan Kim
>> >>
>> >
>>
>
