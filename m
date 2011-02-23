Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1BWUIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:08:06 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65167 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab1BWUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:08:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHf3ZE120uZw/2dsb2JhbACmIHS8DYVeBJFr
Message-ID: <4D65691E.9080600@internode.on.net>
Date: Thu, 24 Feb 2011 06:37:58 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-AU; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110223162432.GL31195@random.random> <20110223165550.GP31195@random.random>
In-Reply-To: <20110223165550.GP31195@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrea Arcangeli wrote, on 24/02/11 03:25:
> On Wed, Feb 23, 2011 at 05:24:32PM +0100, Andrea Arcangeli wrote:
>> On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
>>> OK, these patches applied together against upstream didn't cause a crash
>>> but I did observe:
>>>
>>> significant slowdowns of MIDI playback (moreso than in previous cases,
>>> and with less than 20 Meg of swap file in use);
>>>
>>> kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
>>>
>>> If I should try only one of the patches or something else entirely,
>>> please let me know.
>>
>> Yes, with irq off, schedule won't run and need_resched won't get set.
>>
>> So let's try this.
>>
>> In case this doesn't fix I definitely give it up with compaction in
>> kswapd as GFP_ATOMIC will likely not get an huge benefit out of
>> compaction anyway because 1) the allocations from GFP_ATOMIC are
>> likely short lived, 2) the cost of the compaction scan loop +
>> migration may be higher than the benefit we get from jumbo frames
>>
>> So if this doesn't fix it, I'll already post a definitive fix that
>> removes compaction from kswapd (but leaves it enabled for direct
>> reclaim for all order sizes including kernel stack). I already
>> verified that this solves not just the midi latency issue but the
>> other server benchmark that I'm dealing with. Then we can think at
>> compaction+kswapd later for 2.6.39 but I think we need to close this
>> kswapd issue in time for 2.6.38. So if the below isn't enough the next
>> patch should be applied. I'll get those two patches tested in the
>> server load too, and I'll let you know how the results are when it
>> finishes.
>>
>> Please apply also the attached "kswapd-high-wmark" before the below
>> one.
>> +		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
>> +			if (fatal_signal_pending(current))
>> +				break;
>
> this is compaction-kswapd-2, to fix the buglet same as in the other
> patch.
>
> In short (to avoid confusion) it'll be helpful if you can test
> compaction-kswapd-2 vs compaction-no-kswapd-3 and let us know if both
> are ok or if only compaction-no-kswapd-3 is ok. compaction-no-kswapd-3
> should help, compaction-kswapd-2 I'm unsure. And as usual I suggest to
> apply kswapd-high-wmark (attached to previous emails) _before_
> applying both patches.

kswapd-high_wmark + compaction-kswapd-2 - kswapd0 CPU up to 11 percent 
and slightly less pronounced slowdowns of MIDI playback compared to 
previous patches.

kswapd-high_wmark + compaction-no-kswapd-3 - kswapd0 CPU up to 2.3 
percent and no noticable slowdown of MIDI playback.

Mel Gorman's mm/compaction.c patch - kswapd0 CPU up to 20 percent and no 
noticable slowdown of MIDI playback.

Thanks everyone for the help with this.

Arthur.
