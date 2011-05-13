Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1EMLCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:02:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48305 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab1EMLCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:02:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCD1027.70408@jp.fujitsu.com>
Date: Fri, 13 May 2011 20:04:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: David Rientjes <rientjes@google.com>, CAI Qian <caiqian@redhat.com>,
        avagin@gmail.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes memory
 (was Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable())
References: <1889981320.330808.1305081044822.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>	<alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com>	<BANLkTi=fNtPZQk5Mp7rbZJFpA1tzBh+VcA@mail.gmail.com>	<alpine.DEB.2.00.1105121229150.2407@chino.kir.corp.google.com> <BANLkTikJvT8BmfvMeyL8MAyww3Gdgm3kPA@mail.gmail.com>
In-Reply-To: <BANLkTikJvT8BmfvMeyL8MAyww3Gdgm3kPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/13 13:16), Minchan Kim wrote:
> On Fri, May 13, 2011 at 4:38 AM, David Rientjes<rientjes@google.com>  wrote:
>> On Thu, 12 May 2011, Minchan Kim wrote:
>>
>>>> processes a 1% bonus for every 30% of memory they use as proposed
>>>> earlier.)
>>>
>>> I didn't follow earlier your suggestion.
>>> But it's not formal patch so I expect if you send formal patch to
>>> merge, you would write down the rationale.
>>>
>>
>> Yes, I'm sure we'll still have additional discussion when KOSAKI-san
>> replies to my review of his patchset, so this quick patch was written only
>> for CAI's testing at this point.
>>
>> In reference to the above, I think that giving root processes a 3% bonus
>> at all times may be a bit aggressive.  As mentioned before, I don't think
>> that all root processes using 4% of memory and the remainder of system
>> threads are using 1% should all be considered equal.  At the same time, I
>> do not believe that two threads using 50% of memory should be considered
>> equal if one is root and one is not.  So my idea was to discount 1% for
>> every 30% of memory that a root process uses rather than a strict 3%.
>>
>> That change can be debated and I think we'll probably settle on something
>> more aggressive like 1% for every 10% of memory used since oom scores are
>> only useful in comparison to other oom scores: in the above scenario where
>> there are two threads, one by root and one not by root, using 50% of
>> memory each, I think it would be legitimate to give the root task a 5%
>> bonus so that it would only be selected if no other threads used more than
>> 44% of memory (even though the root thread is truly using 50%).
>>
>> This is a heuristic within the oom killer badness scoring that can always
>> be debated back and forth, but I think a 1% bonus for root processes for
>> every 10% of memory used is plausible.
>>
>> Comments?
>
> Yes. Tend to agree.
> Apparently, absolute 3% bonus is a problem in CAI's case.
>
> Your approach which makes bonus with function of rss is consistent
> with current OOM heuristic.
> So In consistency POV, I like it as it could help deterministic OOM policy.
>
> About 30% or 10% things, I think it's hard to define a ideal magic
> value for handling for whole workloads.
> It would be very arguable. So we might need some standard method to
> measure it/or redhat/suse peoples. Anyway, I don't want to argue it
> until we get a number.

I have small comments. 1) typical system have some small size system daemon
2) David's points -= 100 * (points / 3000); line doesn't make any bonus if
points is less than 3000. Zero root bonus is really desired? It may lead to
kill system daemon at first issue. 3) if we change minimum bonus from 0% to
1%, we will face the exact same problem when all process have less than
1% memory. It's not rare if the system has a plenty memory.
So, my recalculation logic (patch [4/4]) is necessary anyway.

However, proportional 1% - 10% bonus seems considerable good idea.


