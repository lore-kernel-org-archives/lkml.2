Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab0HFElF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:41:05 -0400
Received: from tuxonice.net ([74.207.252.127]:43479 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0HFElD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:41:03 -0400
X-Bogosity: Ham, spamicity=0.001491
Message-ID: <4C5B925A.5000409@tuxonice.net>
Date: Fri, 06 Aug 2010 14:40:58 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mark Lord <kernel@teksavvy.com>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 	used!
References: <4C58C528.4000606@tuxonice.net>	<4C5960B0.7020003@teksavvy.com>	<4C59DA16.4020500@tuxonice.net>	<AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>	<4C5A59FC.1030304@tuxonice.net> <AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>
In-Reply-To: <AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 06/08/10 11:15, Hugh Dickins wrote:
> On Wed, Aug 4, 2010 at 11:28 PM, Nigel Cunningham<nigel@tuxonice.net>  wrote:
>> On 05/08/10 13:58, Hugh Dickins wrote:
>>> I agree it would make more sense to discard swap when freeing rather
>>> than when allocating, I wish we could.  But at the freeing point we're
>>> often holding a page_table spinlock at an outer level, and it's just
>>> one page we're given to free.  Freeing is an operation you want to be
>>> comfortable doing when you're short of resources, whereas discard is a
>>> kind of I/O operation which needs resources.

The more I think about this, the more it seems to me that doing the 
discard at allocation time is just wrong. How about a strategy in which 
you do the discard immediately if resources permit, or flag it as in 
need of doing (at a future swap free of that page or swap off time) if 
things are too pressured at the moment? I haven't put thought into what 
data structures could be used for that - just want to ask for now if 
you'd be happy with the idea of looking into a strategy like that.

>>> It happens that in the allocation path, there was already a place at
>>> which we scanned for a cluster of 1MB free (I'm thinking of 4kB pages
>>> when I say 1MB), so that was the neatest point at which to site the
>>> discard - though even there we have to be careful about racing
>>> allocations.
>>
>> Makes sense when you put it like that :)
>>
>> I know it's a bit messier, but would it be possible for us to modify the
>> behaviour depending on the reason for the allocation? (No page_table
>> spinlock holding when we're hibernating).
>
> But if we moved it to the swap free, it would occur in the swap free
> (if any) _prior_ to hibernating, when testing for hibernation would
> just say "no".

I see what you mean. I'm not so worried by that because if we're having 
to free swap in order to hibernate, things are going to be slow anyway 
and discards aren't going to stand out nearly so much.

I'm much more concerned by the fact that we're currently doing discards 
for swap that wasn't even being used. If I reboot, swapon and then 
hibernate without having touched swap so far, I still get the 'hit' on 
the whole 4GB. I don't think we should be storing on disk a "this hasn't 
been used since last discarded" flag, so I'm looking for other solutions.

>>> I did once try to go back and get it to work when freeing instead of
>>> allocating, gathering the swap slots up then freeing when convenient.
>>> It was messy, didn't work very well, and didn't show an improvement in
>>> performance (on what we were testing at the time).
>
> When I tried gathering together the frees, there were just too many
> short extents to make the discards worth doing that  way.

Okay.

>> For one or two at a time, I can see that would be the case. If it is
>> possible to do the discard of pages used for hibernation after we're
>> finished reading the image, that would be good. Even better would be to only
>> do the discard for pages that were actually used and just do a simple free
>> for ones that were only allocated.
>
> There are optimizations which could be done e.g. we discard the whole
> of swap at swapon time, then re-discard each 1MB as we begin to
> allocate from it.  Clearly that has a certain stupidity to it!  But
> the initial discard of the whole of swap should be efficient and worth
> doing.  We could keep track of which swap pages have already been
> discarded since last used, but that would take up another... it's not
> immediately clear to me whether it's another value or another bit of
> the swap count.
>
> We could provide an interface for hibernation, to do a minimal number
> of maximal range discards to suit hibernation (but we need to be very
> careful about ongoing allocation, as in another thread).
>
> But are these things worth doing?  I think not.  Discard is supposed
> to be helping not hindering: if the device only supports discard in a
> way that's so inefficient, we'd do better to blacklist it as not
> supporting discard at all.  My suspicion is that your SSD is of that
> kind: that it used not to be recognized as supporting discard, but now
> in 2.6.35 it is so recognized.  However, that's just a suspicion: let
> me not slander your SSD when it may be my code or someone else's to
> blame: needs testing.

I've done the bisect now - spent the time today instead of on the place, 
and it took me to fbbf055692aeb25c54c49d9ca84532de836fbba0. This is 
Christoph's Hellwig's patch "block: fix DISCARD_BARRIER requests".

Could the problem be that we're using DISCARD_FL_BARRIER too much? (I'm 
still looking at the code here, so am writing without having thought 
everything through _really_ carefully.

>> Of course I'm talking in ideals without having an intimate knowledge of the
>> swap allocation code or exactly how ugly the above would make it :)
>>
>>> I've not been able to test swap, with SSDs, for several months: that's
>>> a dreadful regression you've found, thanks a lot for reporting it:
>>> I'll be very interested to hear where you locate the cause.  If it
>>> needs changes to the way swap does discard, so be it.
>>
>> I'm traveling to the US on Saturday and have apparently been given one of
>> those nice seats with power, so I'll try and get the bisection done then.
>
> That would be helpful, but displays greater dedication than I'd offer myself!

Done without an airplane now. I don't have to be credited with too much 
dedication! :)

Nigel
