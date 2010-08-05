Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab0HED6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:58:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab0HED6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:58:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=KW3dxVHzxOtrJVak1mV9fH4BtNCUXjIVmSCXGsmyE8DKPNUSja9RGsu74KDTEuRYe
	HX36GVCn5gD+c47LvtSng==
MIME-Version: 1.0
In-Reply-To: <4C59DA16.4020500@tuxonice.net>
References: <4C58C528.4000606@tuxonice.net>
	<4C5960B0.7020003@teksavvy.com>
	<4C59DA16.4020500@tuxonice.net>
Date: Wed, 4 Aug 2010 20:58:46 -0700
Message-ID: <AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't 
	used!
From: Hugh Dickins <hughd@google.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Mark Lord <kernel@teksavvy.com>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 2:22 PM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> On 04/08/10 22:44, Mark Lord wrote:
>>
>> Looks to me like more and more things are using the block discard
>> functionality, and as predicted it is slowing things down enormously.
>>
>> The problem is that we still only discard tiny bits (a single range
>> still??)
>> per TRIM command, rather than batching larger ranges and larger numbers
>> of ranges into single TRIM commands.
>>
>> That's a very poor implementation, especially when things start enabling
>> it by default. Eg. the swap code, mke2fs, etc..
>>
>> Ugh.

swap has been discarding since 2.6.29, on one 1MB range at a time.
There's been no significant change at the swap end since then, but I
guess more devices have been announcing themselves as nonrotational
and supporting discard, and the implementation lower down has gone
through a number of changes.

>
> I was hoping for a nice quick and simple answer. Since I haven't got one,
> I'll try to find time to do a git bisect. I think I'll also look at the swap
> code more carefully and see if it's doing the sensible thing. I can't (at
> the moment) see the logic behind calling discard when allocating swap. At
> freeing time makes much more sense to me.

I agree it would make more sense to discard swap when freeing rather
than when allocating, I wish we could.  But at the freeing point we're
often holding a page_table spinlock at an outer level, and it's just
one page we're given to free.  Freeing is an operation you want to be
comfortable doing when you're short of resources, whereas discard is a
kind of I/O operation which needs resources.

It happens that in the allocation path, there was already a place at
which we scanned for a cluster of 1MB free (I'm thinking of 4kB pages
when I say 1MB), so that was the neatest point at which to site the
discard - though even there we have to be careful about racing
allocations.

I did once try to go back and get it to work when freeing instead of
allocating, gathering the swap slots up then freeing when convenient.
It was messy, didn't work very well, and didn't show an improvement in
performance (on what we were testing at the time).

I've not been able to test swap, with SSDs, for several months: that's
a dreadful regression you've found, thanks a lot for reporting it:
I'll be very interested to hear where you locate the cause.  If it
needs changes to the way swap does discard, so be it.

Hugh
