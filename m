Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab0HFBP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:15:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab0HFBP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:15:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=M5Z0V8zzZu0ga5t/D3yp7XXgfyxArUrTAWkAftqx3vlGqnj2CC/x3mnA1z6ACe9Q3
	ziospAqgoZpuHJC1beA/A==
MIME-Version: 1.0
In-Reply-To: <4C5A59FC.1030304@tuxonice.net>
References: <4C58C528.4000606@tuxonice.net>
	<4C5960B0.7020003@teksavvy.com>
	<4C59DA16.4020500@tuxonice.net>
	<AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
	<4C5A59FC.1030304@tuxonice.net>
Date: Thu, 5 Aug 2010 18:15:52 -0700
Message-ID: <AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't 
	used!
From: Hugh Dickins <hughd@google.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Mark Lord <kernel@teksavvy.com>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 11:28 PM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> On 05/08/10 13:58, Hugh Dickins wrote:
>> I agree it would make more sense to discard swap when freeing rather
>> than when allocating, I wish we could.  But at the freeing point we're
>> often holding a page_table spinlock at an outer level, and it's just
>> one page we're given to free.  Freeing is an operation you want to be
>> comfortable doing when you're short of resources, whereas discard is a
>> kind of I/O operation which needs resources.
>>
>> It happens that in the allocation path, there was already a place at
>> which we scanned for a cluster of 1MB free (I'm thinking of 4kB pages
>> when I say 1MB), so that was the neatest point at which to site the
>> discard - though even there we have to be careful about racing
>> allocations.
>
> Makes sense when you put it like that :)
>
> I know it's a bit messier, but would it be possible for us to modify the
> behaviour depending on the reason for the allocation? (No page_table
> spinlock holding when we're hibernating).

But if we moved it to the swap free, it would occur in the swap free
(if any) _prior_ to hibernating, when testing for hibernation would
just say "no".

>> I did once try to go back and get it to work when freeing instead of
>> allocating, gathering the swap slots up then freeing when convenient.
>> It was messy, didn't work very well, and didn't show an improvement in
>> performance (on what we were testing at the time).

When I tried gathering together the frees, there were just too many
short extents to make the discards worth doing that  way.

>
> For one or two at a time, I can see that would be the case. If it is
> possible to do the discard of pages used for hibernation after we're
> finished reading the image, that would be good. Even better would be to only
> do the discard for pages that were actually used and just do a simple free
> for ones that were only allocated.

There are optimizations which could be done e.g. we discard the whole
of swap at swapon time, then re-discard each 1MB as we begin to
allocate from it.  Clearly that has a certain stupidity to it!  But
the initial discard of the whole of swap should be efficient and worth
doing.  We could keep track of which swap pages have already been
discarded since last used, but that would take up another... it's not
immediately clear to me whether it's another value or another bit of
the swap count.

We could provide an interface for hibernation, to do a minimal number
of maximal range discards to suit hibernation (but we need to be very
careful about ongoing allocation, as in another thread).

But are these things worth doing?  I think not.  Discard is supposed
to be helping not hindering: if the device only supports discard in a
way that's so inefficient, we'd do better to blacklist it as not
supporting discard at all.  My suspicion is that your SSD is of that
kind: that it used not to be recognized as supporting discard, but now
in 2.6.35 it is so recognized.  However, that's just a suspicion: let
me not slander your SSD when it may be my code or someone else's to
blame: needs testing.

>
> Of course I'm talking in ideals without having an intimate knowledge of the
> swap allocation code or exactly how ugly the above would make it :)
>
>> I've not been able to test swap, with SSDs, for several months: that's
>> a dreadful regression you've found, thanks a lot for reporting it:
>> I'll be very interested to hear where you locate the cause.  If it
>> needs changes to the way swap does discard, so be it.
>
> I'm traveling to the US on Saturday and have apparently been given one of
> those nice seats with power, so I'll try and get the bisection done then.

That would be helpful, but displays greater dedication than I'd offer myself!

Hugh
