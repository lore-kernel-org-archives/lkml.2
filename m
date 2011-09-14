Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1INAe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:34:27 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:59644 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1INAe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:34:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110913165344.1d800582.akpm@google.com>
References: <1315941801.2565.19.camel@edumazet-laptop>
	<20110913165344.1d800582.akpm@google.com>
Date: Wed, 14 Sep 2011 08:34:21 +0800
Message-ID: <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Andrew Morton <akpm@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Pawel Sikora <pluto@agmk.net>, Justin Piszcz <jpiszcz@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 7:53 AM, Andrew Morton <akpm@google.com> wrote:
> On Tue, 13 Sep 2011 21:23:21 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>> Linus,
>>
>> It seems current kernels (3.1.0-rc6) are really unreliable, or maybe I
>> expect too much from them.
>>
>> On my 4GB x86_64 machine (2 quad-core cpus, 2 threads per core), I can
>> have a cpu locked in
>>
>>  find_get_pages -> radix_tree_gang_lookup_slot -> __lookup
>>
>>
>> Problem is : A bisection will be very hard, since a lot of kernels
>> simply destroy my disk (the PCI MRRS horror stuff).
>
> Yes, that's hard.  Quite often my bisection efforts involve moving to a
> new bisection point then hand-applying a few patches to make the the
> thing compile and/or work.
>
> There have only been three commits to radix-tree.c this year, so a bit
> of manual searching through those would be practical?
>
>> Messages at console :
>>
>> INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by
>> 11 t=60002 jiffies)
>>
>> perf top -C 1
>>
>> Events: 3K cycles
>> +     43,08%  bash  [kernel.kallsyms]  [k] __lookup
>> +     41,51%  bash  [kernel.kallsyms]  [k] find_get_pages
>> +     15,31%  bash  [kernel.kallsyms]  [k] radix_tree_gang_lookup_slot
>>
>>     43.08%     bash  [kernel.kallsyms]  [k] __lookup
>>                |
>>                --- __lookup
>>                   |
>>                   |--97.09%-- radix_tree_gang_lookup_slot
>>                   |          find_get_pages
>>                   |          pagevec_lookup
>>                   |          invalidate_mapping_pages
>>                   |          drop_pagecache_sb
>>                   |          iterate_supers
>>                   |          drop_caches_sysctl_handler
>>                   |          proc_sys_call_handler.isra.3
>>                   |          proc_sys_write
>>                   |          vfs_write
>>                   |          sys_write
>>                   |          system_call_fastpath
>>                   |          __write
>>                   |
>>
>>
>> Steps to reproduce :
>>
>> In one terminal, kernel builds in a loop (defconfig + hpsa driver)
>>
>> cd /usr/src/linux
>> while :
>> do
>>  make clean
>>  make -j128
>> done
>>
>>
>> In another term :
>>
>> while :
>> do
>>  echo 3 >/proc/sys/vm/drop_caches
>>  sleep 20
>> done
>>
>
> This is a regression?  3.0 is OK?

FYI,  other guys have reported similar bugs for 3.0.

kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
http://marc.info/?l=linux-kernel&m=131342662028153&w=2

[3.0.2-stable] BUG: soft lockup - CPU#13 stuck for 22s! [kswapd2:1092]
http://marc.info/?l=linux-kernel&m=131469584117857&w=2

kernel 3.1-rc4: BUG soft lockup (w/frame pointers enabled)
http://marc.info/?l=linux-kernel&m=131566383719422&w=2

Lin Ming

>
> Also, do you know that the hang is happening at the radix-tree level?
> It might be at the filemap.c level or at the superblock level and we
> just end up spending most cycles at the lower levels because they're
> called so often?  The iterate_supers/drop_pagecache_sb code is fairly
> recent.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
