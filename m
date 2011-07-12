Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1GLJkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:40:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59423 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1GLJkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:40:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1C1684.4090706@jp.fujitsu.com>
Date: Tue, 12 Jul 2011 18:40:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: mgorman@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cl@linux.com
Subject: Re: [PATCH 1/3] mm: vmscan: Do use use PF_SWAPWRITE from zone_reclaim
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>	<1310389274-13995-2-git-send-email-mgorman@suse.de> <CAEwNFnATXiQsmbfuvZNEtcpcVZkyZKRFB1SKbkEREaCW4S-aUg@mail.gmail.com>
In-Reply-To: <CAEwNFnATXiQsmbfuvZNEtcpcVZkyZKRFB1SKbkEREaCW4S-aUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/12 18:27), Minchan Kim wrote:
> Hi Mel,
> 
> On Mon, Jul 11, 2011 at 10:01 PM, Mel Gorman <mgorman@suse.de> wrote:
>> Zone reclaim is similar to direct reclaim in a number of respects.
>> PF_SWAPWRITE is used by kswapd to avoid a write-congestion check
>> but it's set also set for zone_reclaim which is inappropriate.
>> Setting it potentially allows zone_reclaim users to cause large IO
>> stalls which is worse than remote memory accesses.
> 
> As I read zone_reclaim_mode in vm.txt, I think it's intentional.
> It has meaning of throttle the process which are writing large amounts
> of data. The point is to prevent use of remote node's free memory.
> 
> And we has still the comment. If you're right, you should remove comment.
> "         * and we also need to be able to write out pages for RECLAIM_WRITE
>          * and RECLAIM_SWAP."
> 
> 
> And at least, we should Cc Christoph and KOSAKI.

Of course, I'll take full ack this. Do you remember I posted the same patch
about one year ago. At that time, Mel disagreed me and I'm glad to see he changed
the mind. :)



> 
>>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>> ---
>>  mm/vmscan.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 4f49535..ebef213 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3063,7 +3063,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>>         * and we also need to be able to write out pages for RECLAIM_WRITE
>>         * and RECLAIM_SWAP.
>>         */
>> -       p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
>> +       p->flags |= PF_MEMALLOC;
>>        lockdep_set_current_reclaim_state(gfp_mask);
>>        reclaim_state.reclaimed_slab = 0;
>>        p->reclaim_state = &reclaim_state;
>> @@ -3116,7 +3116,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>>        }
>>
>>        p->reclaim_state = NULL;
>> -       current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
>> +       current->flags &= ~PF_MEMALLOC;
>>        lockdep_clear_current_reclaim_state();
>>        return sc.nr_reclaimed >= nr_pages;
>>  }
>> --
>> 1.7.3.4
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
> 
> 
> 


