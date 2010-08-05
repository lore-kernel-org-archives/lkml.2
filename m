Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab0HEG2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:28:17 -0400
Received: from tuxonice.net ([74.207.252.127]:35527 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab0HEG2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:28:15 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C5A59FC.1030304@tuxonice.net>
Date: Thu, 05 Aug 2010 16:28:12 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mark Lord <kernel@teksavvy.com>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 	used!
References: <4C58C528.4000606@tuxonice.net>	<4C5960B0.7020003@teksavvy.com>	<4C59DA16.4020500@tuxonice.net> <AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
In-Reply-To: <AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh.

Thanks for the email.

On 05/08/10 13:58, Hugh Dickins wrote:
> On Wed, Aug 4, 2010 at 2:22 PM, Nigel Cunningham<nigel@tuxonice.net>  wrote:
>> On 04/08/10 22:44, Mark Lord wrote:
>>>
>>> Looks to me like more and more things are using the block discard
>>> functionality, and as predicted it is slowing things down enormously.
>>>
>>> The problem is that we still only discard tiny bits (a single range
>>> still??)
>>> per TRIM command, rather than batching larger ranges and larger numbers
>>> of ranges into single TRIM commands.
>>>
>>> That's a very poor implementation, especially when things start enabling
>>> it by default. Eg. the swap code, mke2fs, etc..
>>>
>>> Ugh.
>
> swap has been discarding since 2.6.29, on one 1MB range at a time.
> There's been no significant change at the swap end since then, but I
> guess more devices have been announcing themselves as nonrotational
> and supporting discard, and the implementation lower down has gone
> through a number of changes.

Okay; that's good to know.

>>
>> I was hoping for a nice quick and simple answer. Since I haven't got one,
>> I'll try to find time to do a git bisect. I think I'll also look at the swap
>> code more carefully and see if it's doing the sensible thing. I can't (at
>> the moment) see the logic behind calling discard when allocating swap. At
>> freeing time makes much more sense to me.
>
> I agree it would make more sense to discard swap when freeing rather
> than when allocating, I wish we could.  But at the freeing point we're
> often holding a page_table spinlock at an outer level, and it's just
> one page we're given to free.  Freeing is an operation you want to be
> comfortable doing when you're short of resources, whereas discard is a
> kind of I/O operation which needs resources.
>
> It happens that in the allocation path, there was already a place at
> which we scanned for a cluster of 1MB free (I'm thinking of 4kB pages
> when I say 1MB), so that was the neatest point at which to site the
> discard - though even there we have to be careful about racing
> allocations.

Makes sense when you put it like that :)

I know it's a bit messier, but would it be possible for us to modify the 
behaviour depending on the reason for the allocation? (No page_table 
spinlock holding when we're hibernating).

The issue isn't as noticable with [u]swsusp at the moment because 
they're allocating swap as the image is being written. If my current set 
of patches for Rafael get accepted, that will change (swap will be 
preallocated).

TuxOnIce always allocates all available storage since there's (usually) 
virtually zero cost of doing so and it then doesn't matter how much the 
drivers allocate when we do the atomic copy, or how good a compression 
ratio is achieved. That's what I'm aiming for in my patches for [u]swsusp.

> I did once try to go back and get it to work when freeing instead of
> allocating, gathering the swap slots up then freeing when convenient.
> It was messy, didn't work very well, and didn't show an improvement in
> performance (on what we were testing at the time).

For one or two at a time, I can see that would be the case. If it is 
possible to do the discard of pages used for hibernation after we're 
finished reading the image, that would be good. Even better would be to 
only do the discard for pages that were actually used and just do a 
simple free for ones that were only allocated.

Of course I'm talking in ideals without having an intimate knowledge of 
the swap allocation code or exactly how ugly the above would make it :)

> I've not been able to test swap, with SSDs, for several months: that's
> a dreadful regression you've found, thanks a lot for reporting it:
> I'll be very interested to hear where you locate the cause.  If it
> needs changes to the way swap does discard, so be it.

I'm traveling to the US on Saturday and have apparently been given one 
of those nice seats with power, so I'll try and get the bisection done then.

TTFN

Nigel
