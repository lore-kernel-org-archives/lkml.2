Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0JTHZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:25:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44952 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab0JTHZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UO15jZHZVQkUu2WX05/qBMbiz5lDRH4ZE/sZ8Z8i/J8wlz7Z5N/J9uqbi8H1z8/UEA
         oZs8NvkS5CrnMBLMytqrse/p+vMYUDAiM2jtetY2SDn672AW/w4g2Nc4E2VWlCn9Z/vN
         /r1p1z0Ne8FQxY5fIODuBmoblNs1++s1Crdbw=
MIME-Version: 1.0
In-Reply-To: <20101020055717.GA12752@localhost>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
	<20100915122334.3fa7b35f@notabene>
	<20100915082843.GA17252@localhost>
	<20100915184434.18e2d933@notabene>
	<20101018151459.2b443221@notabene>
	<AANLkTimv_zXHdFDGa9ecgXyWmQynOKTDRPC59PZA9mvL@mail.gmail.com>
	<20101019101151.57c6dd56@notabene>
	<AANLkTin3wXWwA-HXhjx6wvzznp3p57Pg6fee8YNkZB79@mail.gmail.com>
	<AANLkTimVu+5gTDs8przJVP2EbWC=FX-zWW7aH08BtrHC@mail.gmail.com>
	<20101020055717.GA12752@localhost>
Date: Wed, 20 Oct 2010 09:25:49 +0200
Message-ID: <AANLkTinC=xcgfwgXw8Tr-Q_cnxZakjj_W=HwQRV+5vkd@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Neil Brown <neilb@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 7:57 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Oct 19, 2010 at 06:06:21PM +0800, Torsten Kaiser wrote:
>> swap_writepage() uses get_swap_bio() which uses bio_alloc() to get one
>> bio. That bio is the submitted, but the submit path seems to get into
>> make_request from raid1.c and that allocates a second bio from
>> bio_alloc() via bio_clone().
>>
>> I am seeing this pattern (swap_writepage calling
>> md_make_request/make_request and then getting stuck in mempool_alloc)
>> more than 5 times in the SysRq+T output...
>
> I bet the root cause is the failure of pool->alloc(__GFP_NORETRY)
> inside mempool_alloc(), which can be fixed by this patch.

No. I tested the patch (ontop of Neils fix and your patch regarding
too_many_isolated()), but the system got stuck the same way on the
first try to fill the tmpfs.
I think the basic problem is, that the mempool that should guarantee
progress is exhausted because the raid1 device is stacked between the
pageout code and the disks and so the "use only 1 bio"-rule gets
violated.

> Thanks,
> Fengguang
> ---
>
> concurrent direct page reclaim problem
>
>  __GFP_NORETRY page allocations may fail when there are many concurrent page
>  allocating tasks, but not necessary in real short of memory. The root cause
>  is, tasks will first run direct page reclaim to free some pages from the LRU
>  lists and put them to the per-cpu page lists and the buddy system, and then
>  try to get a free page from there.  However the free pages reclaimed by this
>  task may be consumed by other tasks when the direct reclaim task is able to
>  get the free page for itself.

I believe the facts disagree with that assumtion. My bad for not
posting this before, but I also used SysRq+M to see whats going on,
but each time there still was some free memory.
Here is the SysRq+M output from the run with only Neils patch applied,
but on each other run the same ~14Mb stayed free

[  437.481365] SysRq : Show Memory
[  437.490003] Mem-Info:
[  437.491357] Node 0 DMA per-cpu:
[  437.500032] CPU    0: hi:    0, btch:   1 usd:   0
[  437.500032] CPU    1: hi:    0, btch:   1 usd:   0
[  437.500032] CPU    2: hi:    0, btch:   1 usd:   0
[  437.500032] CPU    3: hi:    0, btch:   1 usd:   0
[  437.500032] Node 0 DMA32 per-cpu:
[  437.500032] CPU    0: hi:  186, btch:  31 usd: 138
[  437.500032] CPU    1: hi:  186, btch:  31 usd:  30
[  437.500032] CPU    2: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    3: hi:  186, btch:  31 usd:   0
[  437.500032] Node 1 DMA32 per-cpu:
[  437.500032] CPU    0: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    1: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    2: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    3: hi:  186, btch:  31 usd:   0
[  437.500032] Node 1 Normal per-cpu:
[  437.500032] CPU    0: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    1: hi:  186, btch:  31 usd:   0
[  437.500032] CPU    2: hi:  186, btch:  31 usd:  25
[  437.500032] CPU    3: hi:  186, btch:  31 usd:  30
[  437.500032] active_anon:2039 inactive_anon:985233 isolated_anon:682
[  437.500032]  active_file:1667 inactive_file:1723 isolated_file:0
[  437.500032]  unevictable:0 dirty:0 writeback:25387 unstable:0
[  437.500032]  free:3471 slab_reclaimable:2840 slab_unreclaimable:6337
[  437.500032]  mapped:1284 shmem:960501 pagetables:523 bounce:0
[  437.500032] Node 0 DMA free:8008kB min:28kB low:32kB high:40kB
active_anon:0kB inact
ive_anon:7596kB active_file:12kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB i
solated(file):0kB present:15768kB mlocked:0kB dirty:0kB
writeback:404kB mapped:0kB shme
m:7192kB slab_reclaimable:32kB slab_unreclaimable:304kB
kernel_stack:0kB pagetables:0kB
 unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:118
all_unreclaimable? no
[  437.500032] lowmem_reserve[]: 0 2004 2004 2004
[  437.500032] Node 0 DMA32 free:2980kB min:4036kB low:5044kB
high:6052kB active_anon:2
844kB inactive_anon:1918424kB active_file:3428kB inactive_file:3780kB
unevictable:0kB isolated(anon):1232kB isolated(file):0kB
present:2052320kB mlocked:0kB dirty:0kB writeback:72016kB
mapped:2232kB shmem:1847640kB slab_reclaimable:5444kB
slab_unreclaimable:13508kB kernel_stack:744kB pagetables:864kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[  437.500032] lowmem_reserve[]: 0 0 0 0
[  437.500032] Node 1 DMA32 free:2188kB min:3036kB low:3792kB
high:4552kB active_anon:0kB inactive_anon:1555368kB active_file:0kB
inactive_file:28kB unevictable:0kB isolated(anon):768kB
isolated(file):0kB present:1544000kB mlocked:0kB dirty:0kB
writeback:21160kB mapped:0kB shmem:1534960kB slab_reclaimable:3728kB
slab_unreclaimable:7076kB kernel_stack:8kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  437.500032] lowmem_reserve[]: 0 0 505 505
[  437.500032] Node 1 Normal free:708kB min:1016kB low:1268kB
high:1524kB active_anon:5312kB inactive_anon:459544kB
active_file:3228kB inactive_file:3084kB unevictable:0kB
isolated(anon):728kB isolated(file):0kB present:517120kB mlocked:0kB
dirty:0kB writeback:7968kB mapped:2904kB shmem:452212kB
slab_reclaimable:2156kB slab_unreclaimable:4460kB kernel_stack:200kB
pagetables:1228kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:9678 all_unreclaimable? no
[  437.500032] lowmem_reserve[]: 0 0 0 0
[  437.500032] Node 0 DMA: 2*4kB 2*8kB 1*16kB 3*32kB 3*64kB 4*128kB
4*256kB 2*512kB 1*1024kB 2*2048kB 0*4096kB = 8008kB
[  437.500032] Node 0 DMA32: 27*4kB 15*8kB 8*16kB 8*32kB 7*64kB
1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2980kB
[  437.500032] Node 1 DMA32: 1*4kB 6*8kB 3*16kB 1*32kB 0*64kB 1*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2308kB
[  437.500032] Node 1 Normal: 39*4kB 13*8kB 10*16kB 3*32kB 1*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 708kB
[  437.500032] 989289 total pagecache pages
[  437.500032] 25398 pages in swap cache
[  437.500032] Swap cache stats: add 859204, delete 833806, find 28/39
[  437.500032] Free swap  = 9865628kB
[  437.500032] Total swap = 10000316kB
[  437.500032] 1048575 pages RAM
[  437.500032] 33809 pages reserved
[  437.500032] 7996 pages shared
[  437.500032] 1008521 pages non-shared


>  Let's retry it a bit harder.
>
> --- linux-next.orig/mm/page_alloc.c     2010-10-20 13:44:50.000000000 +0800
> +++ linux-next/mm/page_alloc.c  2010-10-20 13:50:54.000000000 +0800
> @@ -1700,7 +1700,7 @@ should_alloc_retry(gfp_t gfp_mask, unsig
>                                unsigned long pages_reclaimed)
>  {
>        /* Do not loop if specifically requested */
> -       if (gfp_mask & __GFP_NORETRY)
> +       if (gfp_mask & __GFP_NORETRY && pages_reclaimed > (1 << (order + 12)))
>                return 0;
>
>        /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
