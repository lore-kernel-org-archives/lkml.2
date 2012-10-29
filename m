Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2J2LAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:00:24 -0400
Received: from basicbox7.server-home.net ([195.137.212.29]:59698 "EHLO
	basicbox7.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2J2LAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:00:23 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 07:00:23 EDT
Message-ID: <508E5FD3.1060105@leemhuis.info>
Date: Mon, 29 Oct 2012 11:52:03 +0100
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Valdis.Kletnieks@vt.edu,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu> <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz> <50780F26.7070007@suse.cz> <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de>
In-Reply-To: <20121015110937.GE29125@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 15.10.2012 13:09, Mel Gorman wrote:
> On Mon, Oct 15, 2012 at 11:54:13AM +0200, Jiri Slaby wrote:
>> On 10/12/2012 03:57 PM, Mel Gorman wrote:
>>> mm: vmscan: scale number of pages reclaimed by reclaim/compaction only in direct reclaim
>>> Jiri Slaby reported the following:
 > [...]
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 2624edc..2b7edfa 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -1763,14 +1763,20 @@ static bool in_reclaim_compaction(struct scan_control *sc)
>>>   #ifdef CONFIG_COMPACTION
>>>   /*
>>>    * If compaction is deferred for sc->order then scale the number of pages
>>> - * reclaimed based on the number of consecutive allocation failures
>>> + * reclaimed based on the number of consecutive allocation failures. This
>>> + * scaling only happens for direct reclaim as it is about to attempt
>>> + * compaction. If compaction fails, future allocations will be deferred
>>> + * and reclaim avoided. On the other hand, kswapd does not take compaction
>>> + * deferral into account so if it scaled, it could scan excessively even
>>> + * though allocations are temporarily not being attempted.
>>>    */
>>>   static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
>>>   			struct lruvec *lruvec, struct scan_control *sc)
>>>   {
>>>   	struct zone *zone = lruvec_zone(lruvec);
>>>
>>> -	if (zone->compact_order_failed <= sc->order)
>>> +	if (zone->compact_order_failed <= sc->order &&
>>> +	    !current_is_kswapd())
>>>   		pages_for_compaction <<= zone->compact_defer_shift;
>>>   	return pages_for_compaction;
>>>   }
>> Yes, applying this instead of the revert fixes the issue as well.

Just wondering, is there a reason why this patch wasn't applied to 
mainline? Did it simply fall through the cracks? Or am I missing something?

I'm asking because I think I stil see the issue on 
3.7-rc2-git-checkout-from-friday. Seems Fedora rawhide users are hitting 
it, too:
https://bugzilla.redhat.com/show_bug.cgi?id=866988

Or are we seeing something different which just looks similar? I can 
test the patch if it needs further testing, but from the discussion I 
got the impression that everything is clear and the patch ready for merging.

CU
  knurd
