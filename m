Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1CWG7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 02:59:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32814 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1CWG7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 02:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PSzlj3NfMUW3HMZ86aXCpoBZwm5i3Uql+p3C+GKqUxqYM3LvJpzWyjUNNXf460E606
         A7wVMCDSDE7SLuoqnCGBKv0Rhlr57ceqBzf8ZNo8A/GfN0PmGW25EE7HELpRdlk5L5uN
         MOJEKjXsn6YkU/AYsMFpxrHBBnpxbrI2s8gY4=
MIME-Version: 1.0
In-Reply-To: <20110323142133.1AC6.A69D9226@jp.fujitsu.com>
References: <20110322200523.B061.A69D9226@jp.fujitsu.com>
	<20110322144950.GA2628@barrios-desktop>
	<20110323142133.1AC6.A69D9226@jp.fujitsu.com>
Date: Wed, 23 Mar 2011 15:59:04 +0900
Message-ID: <AANLkTim1HcdkPcxnWrv+VbMUSh3kQBC=-myZ-j-a8Wiy@mail.gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 2:21 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Minchan,
>
>> > zone->all_unreclaimable and zone->pages_scanned are neigher atomic
>> > variables nor protected by lock. Therefore a zone can become a state
>> > of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
>>
>> Possible although it's very rare.
>
> Can you test by yourself andrey's case on x86 box? It seems
> reprodusable.
>
>> > current all_unreclaimable() return false even though
>> > zone->all_unreclaimabe=1.
>>
>> The case is very rare since we reset zone->all_unreclaimabe to zero
>> right before resetting zone->page_scanned to zero.
>> But I admit it's possible.
>
> Please apply this patch and run oom-killer. You may see following
> pages_scanned:0 and all_unreclaimable:yes combination. likes below.
> (but you may need >30min)
>
>        Node 0 DMA free:4024kB min:40kB low:48kB high:60kB active_anon:11804kB
>        inactive_anon:0kB active_file:0kB inactive_file:4kB unevictable:0kB
>        isolated(anon):0kB isolated(file):0kB present:15676kB mlocked:0kB
>        dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
>        slab_unreclaimable:0kB kernel_stack:0kB pagetables:68kB unstable:0kB
>        bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
>
>
>>
>>         CPU 0                                           CPU 1
>> free_pcppages_bulk                              balance_pgdat
>>         zone->all_unreclaimabe = 0
>>                                                         zone->all_unreclaimabe = 1
>>         zone->pages_scanned = 0
>> >
>> > Is this ignorable minor issue? No. Unfortunatelly, x86 has very
>> > small dma zone and it become zone->all_unreclamble=1 easily. and
>> > if it becase all_unreclaimable, it never return all_unreclaimable=0
>>         ^^^^^ it's very important verb.    ^^^^^ return? reset?
>>
>>         I can't understand your point due to the typo. Please correct the typo.
>>
>> > beucase it typicall don't have reclaimable pages.
>>
>> If DMA zone have very small reclaimable pages or zero reclaimable pages,
>> zone_reclaimable() can return false easily so all_unreclaimable() could return
>> true. Eventually oom-killer might works.
>
> The point is, vmscan has following all_unreclaimable check in several place.
>
>                        if (zone->all_unreclaimable && priority != DEF_PRIORITY)
>                                continue;
>
> But, if the zone has only a few lru pages, get_scan_count(DEF_PRIORITY) return
> {0, 0, 0, 0} array. It mean zone will never scan lru pages anymore. therefore
> false negative smaller pages_scanned can't be corrected.
>
> Then, false negative all_unreclaimable() also can't be corrected.
>
>
> btw, Why get_scan_count() return 0 instead 1? Why don't we round up?
> Git log says it is intentionally.
>
>        commit e0f79b8f1f3394bb344b7b83d6f121ac2af327de
>        Author: Johannes Weiner <hannes@saeurebad.de>
>        Date:   Sat Oct 18 20:26:55 2008 -0700
>
>            vmscan: don't accumulate scan pressure on unrelated lists
>
>>
>> In my test, I saw the livelock, too so apparently we have a problem.
>> I couldn't dig in it recently by another urgent my work.
>> I think you know root cause but the description in this patch isn't enough
>> for me to be persuaded.
>>
>> Could you explain the root cause in detail?
>
> If you have an another fixing idea, please let me know. :)
>
>
>
>

Okay. I got it.

The problem is following as.
By the race the free_pcppages_bulk and balance_pgdat, it is possible
zone->all_unreclaimable = 1 and zone->pages_scanned = 0.
DMA zone have few LRU pages and in case of no-swap and big memory
pressure, there could be a just a page in inactive file list like your
example. (anon lru pages isn't important in case of non-swap system)
In such case, shrink_zones doesn't scan the page at all until priority
become 0 as get_scan_count does scan >>= priority(it's mostly zero).
And although priority become 0, nr_scan_try_batch returns zero until
saved pages become 32. So for scanning the page, at least, we need 32
times iteration of priority 12..0.  If system has fork-bomb, it is
almost livelock.

If is is right, how about this?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 148c6e6..34983e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1973,6 +1973,9 @@ static void shrink_zones(int priority, struct
zonelist *zonelist,

 static bool zone_reclaimable(struct zone *zone)
 {
+       if (zone->all_unreclaimable)
+               return false;
+
        return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
 }


-- 
Kind regards,
Minchan Kim
