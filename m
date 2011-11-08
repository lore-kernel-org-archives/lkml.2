Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1KHA3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:29:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35481 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1KHA3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:29:47 -0500
Message-ID: <4EB874C4.4010706@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 19:16:04 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: jweiner@redhat.com
CC: khlebnikov@parallels.com, penberg@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        hannes@cmpxchg.org, riel@redhat.com, mel@csn.ul.ie,
        minchan.kim@gmail.com, gene.heskett@gmail.com
Subject: Re: [rfc 1/3] mm: vmscan: never swap under low memory pressure
References: <20110808110658.31053.55013.stgit@localhost6> <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com> <4E3FD403.6000400@parallels.com> <20111102163056.GG19965@redhat.com> <20111102163141.GH19965@redhat.com> <4EB183CF.6050300@jp.fujitsu.com> <20111103155127.GM19965@redhat.com>
In-Reply-To: <20111103155127.GM19965@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay. I had tripped San Jose in last week.


> On Wed, Nov 02, 2011 at 10:54:23AM -0700, KOSAKI Motohiro wrote:
>>> ---
>>>  mm/vmscan.c |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index a90c603..39d3da3 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -831,6 +831,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>>>  		 * Try to allocate it some swap space here.l
>>>  		 */
>>>  		if (PageAnon(page) && !PageSwapCache(page)) {
>>> +			if (priority >= DEF_PRIORITY - 2)
>>> +				goto keep_locked;
>>>  			if (!(sc->gfp_mask & __GFP_IO))
>>>  				goto keep_locked;for
>>>  			if (!add_to_swap(page))
>>
>> Hehe, i tried very similar way very long time ago. Unfortunately, it doesn't work.
>> "DEF_PRIORITY - 2" is really poor indicator for reclaim pressure. example, if the
>> machine have 1TB memory, DEF_PRIORITY-2 mean 1TB>>10 = 1GB. It't too big.
> 
> Do you remember what kind of tests you ran that demonstrated
> misbehaviour?
> 
> We can not reclaim anonymous pages without swapping, so the priority
> cutoff applies only to inactive file pages.  If you had 1TB of
> inactive file pages, the scanner would have to go through
> 
> 	((1 << (40 - 12)) >> 12) +
> 	((1 << (40 - 12)) >> 11) +
> 	((1 << (40 - 12)) >> 10) = 1792MB
> 
> without reclaiming SWAP_CLUSTER_MAX before it considers swapping.
> That's a lot of scanning but how likely is it that you have a TB of
> unreclaimable inactive cache pages?

I meant, the affect of this protection strongly depend on system memory.

 - system memory is plenty.
	the protection virtually affect to disable swap-out completely.
 - system memory is not plenty.
	the protection slightly makes a bonus to avoid swap out.

If people buy new machine and move-in their legacy workload into it, they
might surprise a lot of behavior change. I'm worry about it.

That's why I dislike DEF_PRIORITY based heuristic.


> Put into proportion, with a priority threshold of 10 a reclaimer will
> look at 0.17% ((n >> 12) + (n >> 11) + (n >> 10) (excluding the list
> balance bias) of inactive file pages without reclaiming
> SWAP_CLUSTER_MAX before it considers swapping.

Moreover, I think we need to make more precious analysis why unnecessary swapout
was happen. Which factor is dominant and when occur.


> Currently, the list balance biasing with each newly-added file page
> has much higher resistance to scan anonymous pages initially.  But
> once it shifted toward anon pages, all reclaimers will start swapping,
> unlike the priority threshold that each reclaimer has to reach
> individually.  Could this have been what was causing problems for you? 

Um. Currently number of fulusher threads are controlled by kernel. But,
number of swap-out threads aren't limited at all. So, our swapout often
works too aggressively. I think we need fix it.





