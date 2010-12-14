Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab0LNQoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:44:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44690 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529Ab0LNQoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:44:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S0Th3OCjlF9nuNHOPPQLmUozeftZoY5xyNkDn8nSEkxyjPDJBzg7ZG8by6IJ+E2jKC
         24KTKYzfOo613puQ0ak2W667TzyK0APFkATPfcfoMPbypvHkqJbJKJNj2XLSLrtNMZ35
         kNfAD9XeInRFd371y8lRKZThHDuPJQbOtOsrw=
MIME-Version: 1.0
In-Reply-To: <1292335269.5015.1798.camel@gandalf.stny.rr.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	<1292335269.5015.1798.camel@gandalf.stny.rr.com>
Date: Wed, 15 Dec 2010 00:44:04 +0800
Message-ID: <AANLkTi=Ui3mUsi0wHxRYasGsS20tuTfEi8xzMT3o9g+F@mail.gmail.com>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated boosting
From: Lai Jiangshan <eag0628@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

>
>>
>> This is the motivation of this patch.
>>
>> An approach(wrong): when C's priority become higher and B, we deprive
>> the pending ownership from B and give it to C and wakeup C.
>> But this approach may lead to livelock.
>
> I'm curious to how this can cause a livelock. I'm not doubting you, but
> I just woke up, and I'm only half way through my first cup of coffee.
>

if B is deprived, B has go to sleep again. In rare condition,
B,C 's priority are changed frequent, the pending ownership is
given to B/ deprived from B and given to C/ deprived from C and given to B
......

No task can go forward, it is a kind of livelock.

>>
>> So my approach: just give pending ownership(candidate ownership)
>> to C and wakeup C. Thus we have multiple candidate owners(B and C).
>> Any candidate owner is not boosted until it really owns the rtmutex.
>>
>> The candidate ownership is assigned to the top waiter always when
>> 1) unlock time
>> 2) the top waiter is changed
>
> (not looking at the code itself yet) How is a candidate ownership
> changed when the top waiter is changed?

candidate ownerships will not changed until some task really owns it.
when the top waiter is changed, the top waiter is also assigned
candidate ownership. The candidate ownerships are not stored in
struct rtmutex, they are store in the corresponding waiters.

> Or is that only when the lock
> has been unlocked and the current candidate hasn't taken it yet?

Yes, the current candidate hasn't taken it yet, it is just woken up.

>
>>
>> If any candidate owner is running and calls try_to_take_rt_mutex(),
>> it will win unconditionally and really own the lock.
>
> (still not looking at code :-)  What happens if another high prio
> process comes along and tries to take the lock before the candidate gets
> there. That high prio task should still steal the lock. The candidate
> will lose it then.

Another higher prio task will steal the lock before the candidate
gets there. The candidates will go to sleep again.

>
>>
>> How to indicate a candidate owner?
>> 1) add a variable can_seq in the struct rtmutex, it is increased
>>    when unlock (with waiters queued).
>> 2) when a waiter is assigned candidate ownership:
>>    waiter->cand_seq = rtmutex->cand_seq, waiter->cand_owner = 1;
>> So a waiter is candidate owner when if and only if
>> (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
>
> Again, what happens when another high prio task comes along and takes
> the lock? Does cand_owner turn to zero? (Almost done with my coffee,
> then I'll look at code. Or maybe after a second cup, rtmutex requires
> two cups to review code).

After this lucky high prio task release the lock, the lock->cand_seq
is increased. so there is no candidate owner until we assign new
candidate owners. (we will assign a new one immediately)


>
>>
>> Other advantage of this patch:
>> 1) The states of a rtmutex are reduced a half, easier to read the code.
>
> This is good.
>
>> 2) the codes become shorter.
>
> This is also good.
>
>> 3) pending owner is not dequeued: they will retain FIFO when it is stolen.
>
> I don't quite understand this part.

if B C have the some priority and are queued in the waitlist of
a lock which is owned by A. A release it. B is assigned pending
ownership and dequeued. But D steal the lock and B is enqueued.
Now, the top waiter is C, not B. It breaks FIFO.

>
>> 4) like normal mutex, unlock path just do very little work and wakeup candidate owner.
>>    candidate owner dequeue its waiter when it wins the lock.
>
> Hmm, this seems tricky. I kind of remember going this path and hitting
> issues before.

if we have only one pending owner, we must do something for
the pending owner and prepared it to be boosted when needed, so it's
not possible that the unlock path just do very little work.

multiple candidates make things simpler.


>
>>
>> disadvantage
>> 1) the size of struct rtmutex is slightly larger. (I can send another patch
>>    to reduce it if anyone needs)
>
> If we do go this way, we would want to shrink this struct. The -rt patch
> (which this came from) turns almost all spinlocks into rtmutexes, so any
> small increase in this struct will result in a huge bloat of the kernel.
>
>>
>> Not advantage nor disadvantage
>> 1) Even we support multiple candidate owners, we hardly cause "thundering herd"
>>    the number of candidate owners is likely 1.
>
> This is because a candidate is only created when the lock is first
> unlocked or it is unlocked and a lower prio waiter is boosted above the
> current candidate, correct?
>
>> 2) two APIs are changed.
>>    rt_mutex_owner() will not return pending owner
>>    rt_mutex_next_owner() always return the top owner, it is a candidate owner.
>>       will not return NULL if we only have a pending owner.
>>    I have fixed the code that use these APIs.
>>
>> need updated after this patch is accepted
>> 1) Document/*
>> 2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst
>>
>> Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
>
> I'll put this on my todo list to review.
>
> Thanks!
>

Thanks,
Lai
