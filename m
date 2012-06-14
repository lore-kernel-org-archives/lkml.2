Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2FNPrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:47:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36870 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2FNPrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120614152537.GR27397@tiehlicka.suse.cz>
References: <1339661592-3915-1-git-send-email-kosaki.motohiro@gmail.com> <20120614152537.GR27397@tiehlicka.suse.cz>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 14 Jun 2012 11:46:47 -0400
Message-ID: <CAHGf_=rcOox0qhn1WhUau4jpg+U4eNQLTrQYU5sLmp825jP+dQ@mail.gmail.com>
Subject: Re: [resend][PATCH] mm, vmscan: fix do_try_to_free_pages() livelock
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nick Piggin <npiggin@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:25 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 14-06-12 04:13:12, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Currently, do_try_to_free_pages() can enter livelock. Because of,
>> now vmscan has two conflicted policies.
>>
>> 1) kswapd sleep when it couldn't reclaim any page when reaching
>>    priority 0. This is because to avoid kswapd() infinite
>>    loop. That said, kswapd assume direct reclaim makes enough
>>    free pages to use either regular page reclaim or oom-killer.
>>    This logic makes kswapd -> direct-reclaim dependency.
>> 2) direct reclaim continue to reclaim without oom-killer until
>>    kswapd turn on zone->all_unreclaimble. This is because
>>    to avoid too early oom-kill.
>>    This logic makes direct-reclaim -> kswapd dependency.
>>
>> In worst case, direct-reclaim may continue to page reclaim forever
>> when kswapd sleeps forever.
>>
>> We can't turn on zone->all_unreclaimable from direct reclaim path
>> because direct reclaim path don't take any lock and this way is racy.
>>
>> Thus this patch removes zone->all_unreclaimable field completely and
>> recalculates zone reclaimable state every time.
>>
>> Note: we can't take the idea that direct-reclaim see zone->pages_scanned
>> directly and kswapd continue to use zone->all_unreclaimable. Because, it
>> is racy. commit 929bea7c71 (vmscan: all_unreclaimable() use
>> zone->all_unreclaimable as a name) describes the detail.
>>
>> Reported-by: Aaditya Kumar <aaditya.kumar.30@gmail.com>
>> Reported-by: Ying Han <yinghan@google.com>
>> Cc: Nick Piggin <npiggin@gmail.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Cc: Michal Hocko <mhocko@suse.cz>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Looks good, just one comment bellow:
>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
>
> [...]
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index eeb3bc9..033671c 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
> [...]
>> @@ -1936,8 +1936,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>>               if (global_reclaim(sc)) {
>>                       if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>>                               continue;
>> -                     if (zone->all_unreclaimable &&
>> -                                     sc->priority != DEF_PRIORITY)
>> +                     if (!zone_reclaimable(zone) &&
>> +                         sc->priority != DEF_PRIORITY)
>
> Not exactly a hot path but still would be nice to test the priority
> first as the test is cheaper (maybe compiler is clever enough to reorder
> this, as both expressions are independent and without any side-effects
> but...).

ok, will fix.
