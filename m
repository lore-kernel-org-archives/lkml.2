Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2GULRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 07:17:03 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46247 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2GULRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 07:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZgBo9=HX5MHhmWBiQcdiGMss9RSS_reF4gJimivJx7sQ@mail.gmail.com>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
	<loom.20120719T113441-155@post.gmane.org>
	<CAO6Zf6BSpq53UqYjCkq0b3pTPW=WDTnCorQ59tONnV7U-U6EOg@mail.gmail.com>
	<CACT4Y+ZgBo9=HX5MHhmWBiQcdiGMss9RSS_reF4gJimivJx7sQ@mail.gmail.com>
Date: Sat, 21 Jul 2012 13:17:00 +0200
Message-ID: <CAO6Zf6DWAnoMmHjXU4H0ACR8pTy7yV7vji-qRtmnvzWdZWgr5w@mail.gmail.com>
Subject: Re: [PATCH 0/2] [RFC] Volatile ranges (v4)
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc: lkml ]

>> > There is a property of shadow memory that I would like to exploit
>> >  - any region of shadow memory can be reset to zero at any point
>> > w/o any bad consequences (it can lead to missed data
>> > races, but it's better than OOM kill).
>> > I've tried to execute madvise(MADV_DONTNEED) every X
>> > seconds for whole shadow memory. It almost works.
>> > The problem is that madvise() seems to be
>> > not atomic, occasionally I see missed writes, that's not acceptable,
>>
>> Just to be sure, you mean that if you do, say
>>
>> *ptr = 1;  // [1]
>> ...
>> value = *ptr; // [2] value is 1 here
>> ...
>> *ptr = 2; // possibly from another thread, but we can be certain that
>> it's after [1], perhaps because we checked the content with [2]
>> ...
>> // madvise(..., MADV_DONTNEED); _might_ have been called
>> ...
>> value = *ptr;
>>
>> so here we expect 'value' to be either 2 or 0 (zero page iff madvise()
>> did take place), but you get '1' occasionally?
>> Is that what you mean or something else?
>
>
>
> Yes, that's what I mean.
> Basically I observed inconsistent state of memory that must never happen. I
> had no other explanations except that the madvise() call works as a time
> machine. I executed madvise() every 3 seconds, and the inconsistencies
> happened exactly at the same times. When I turned off madvise(), the
> problems disappear.

Did you try disabling swapping? The "time machine" (if it's not a
problem somewhere else) should take old stuff from somewhere.

mmap's man indicates "zero-fill-on-demand pages for mappings without
an underlying file" and the comment in madvise_dontneed() says "Be
sure to free swap resources too", but then looking at the code in
zap_pte_ranges(), there are a few corner cases where swap entries seem
to be left over intact. In any case, given that you can reproduce it
easily, it'll be a quick check.

Also, it's a MAP_PRIVATE mapping, isn't it?

>
> I am not sure whether it's a bug or not, because the man says "For the time
> being, the application is finished with the given range", and we are
> obviously do not since we have concurrent accesses. However I would be great
> if it is "fixed".
>
>
>
>> > I need either zero pages or
>> > consistent pages.
>> > Your FADV_VOLATILE looks like it may be the solution.
>> > To summarize: I have a huge region of memory that
>> > I would like to mark as "volatile" at program
>> > startup. The region is anonymous (not backed by any file).
>> > The kernel must be able to take away
>> > any pages in the range, and then return zero pages later.
>>
>> I guess that for the use-cases that people have considered so far,
>> users are supposed to mark regions NONVOLATILE before accessing them
>> again. If I understand correctly, that's not what you want to do...
>
>
> No, it's not what I want to do. I can't do any tracking during accesses.
> Ideally I just mark the range during startup, it's also possible to do some
> work on a periodic basis.
>
>
>>
>> does it mean that your 'transactions' are always write-a-single-word?
>> i.e. you don't need to make sure that, say, in
>>
>> ptr[0] = val_a;
>> ptr[1] = val_b;
>> ... // no accesses to ptr [0] and [1]
>> c = ptr[0];
>> d = ptr[1];
>>
>> either c == val_a and d == val_b or both are 0?
>
>
> Exactly. Any transaction first issues N independent 8-byte atomic reads, and
> then optionally 1 atomic 8-byte write. Value of 0 especially means "no data
> here", because, well, I do not want to setup 40TB of memory to some other
> value :)
>
>
>>
>>
>> Also, the current implementation of volatile-ranges will try to 'zap'
>> the whole volatile range... not just some of its pages. Perhaps, it's
>> not something you need too. Of course, this can be addressed one way
>> or another.
>
>
> Well, yes, it's not ideal (but we had lived with MADV_DONTNEED for the whole
> range for some time). Ideally, kernel just takes pages away as it needs
> them.
>
>
>
>> Basically, in your specific case, the pages of your region should be,
>> kind of, swapped out to /dev/zero :-)) meaning that once the system
>> decides to swap such a page out, no actual swap is required and, once
>> the area is being accessed again, a zero-page is mapped into it.
>
>
> Yes, I believe that's how MADV_DONTNEED currently works (... or
> zero-fill-on-demand pages for mappings without an underlying file).
> Also the pages must be "swapped out" with higher prio.
> I think what I want is somewhat similar to page cache. Kind of best effort
> LRU caching.
>

-- Dmitry
