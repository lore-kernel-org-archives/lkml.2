Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0HaCCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:02:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0HaCCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AHGoGvJrVs1vuowVufud7K8Mya3k/8HHaKrJG9ko1WgPmAQ/EhEFRYvAasRviT9nYm
         2BYu9cnsgQmx9GLM+L17vmx9BjIJS2/He2XykmzTXGodQ5kTSxT0c3n+lS6wnd/Q/n6/
         8N9PRpdZAEz+1yg3YFgiQd73Id5i82NCRS8Xs=
MIME-Version: 1.0
In-Reply-To: <20100831102557.87D3.A69D9226@jp.fujitsu.com>
References: <20100831095140.87C7.A69D9226@jp.fujitsu.com>
	<AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
	<20100831102557.87D3.A69D9226@jp.fujitsu.com>
Date: Tue, 31 Aug 2010 11:02:45 +0900
Message-ID: <AANLkTinhVnMW8f7+jQdDyEzD=O2YPLSyTuGRE2JnRVzm@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:38 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > I think both Ying's and Minchan's opnion are right and makes sense.  however I _personally_
>> > like Ying version because 1) this version is simpler 2) swap full is very rarely event 3)
>> > no swap mounting is very common on HPC. so this version could have a chance to
>> > improvement hpc workload too.
>>
>> I agree.
>>
>> >
>> > In the other word, both avoiding unnecessary TLB flush and keeping proper page aging are
>> > performance matter. so when we are talking performance, we always need to think frequency
>> > of the event.
>>
>> Ying's one and mine both has a same effect.
>> Only difference happens swap is full. My version maintains old
>> behavior but Ying's one changes the behavior. I admit swap full is
>> rare event but I hoped not changed old behavior if we doesn't find any
>> problem.
>> If kswapd does aging when swap full happens, is it a problem?
>> We have been used to it from 2.6.28.
>>
>> If we regard a code consistency is more important than _unexpected_
>> result, Okay. I don't mind it. :)
>
> To be honest, I don't mind the difference between you and Ying's version. because
> _practically_ swap full occur mean the application has a bug. so, proper page aging
> doesn't help so much. That's the reason why I said I prefer simper. I don't have
> strong opinion. I think it's not big matter.
>
>
>> But at least we should do more thing to make the patch to compile out
>> for non-swap configurable system.
>
> Yes, It makes embedded happy :)
>
>

How about this?

(Not formal patch. If we agree, I will post it later when I have a SMTP).


Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3109ff7..c3c44a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1579,7 +1579,7 @@ static void shrink_active_list(unsigned long
nr_pages, struct zone *zone,
        __mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
        spin_unlock_irq(&zone->lru_lock);
 }
-
+#if CONFIG_SWAP
 static int inactive_anon_is_low_global(struct zone *zone)
 {
        unsigned long active, inactive;
@@ -1605,12 +1605,21 @@ static int inactive_anon_is_low(struct zone
*zone, struct scan_control *sc)
 {
        int low;

+       if (nr_swap_pages)
+               return 0;
+
        if (scanning_global_lru(sc))
                low = inactive_anon_is_low_global(zone);
        else
                low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
        return low;
 }
+#else
+static inline int inactive_anon_is_low(struct zone *zone, struct
scan_control *sc)
+{
+       return 0;
+}
+#endif

 static int inactive_file_is_low_global(struct zone *zone)
 {
@@ -1856,7 +1865,7 @@ static void shrink_zone(int priority, struct zone *zone,
         * Even if we did not try to evict anon pages at all, we want to
         * rebalance the anon lru active/inactive ratio.
         */
-       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
+       if (inactive_anon_is_low(zone, sc))
                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

        throttle_vm_writeout(sc->gfp_mask);


-- 
Kind regards,
Minchan Kim
