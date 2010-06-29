Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0F2Q63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:58:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46815 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab0F2Q62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:58:28 -0400
Message-ID: <4C2A2627.3080408@us.ibm.com>
Date: Tue, 29 Jun 2010 09:58:15 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: futex_find_get_task make credentials check conditional
References: <20100623091307.GA11072@tiehlicka.suse.cz> <4C2417AA.4030306@us.ibm.com>	<20100625082711.GA32765@tiehlicka.suse.cz> <4C24ED34.9040808@us.ibm.com>	<4C253D32.6040304@us.ibm.com> <20100628144246.GA14201@tiehlicka.suse.cz> <20100628153214.GA24127@tiehlicka.suse.cz> <20100628155845.GC24127@tiehlicka.suse.cz> <20100628163952.GD24127@tiehlicka.suse.cz>	<1277743748.3561.139.camel@laptop> <20100629084230.GE6215@tiehlicka.suse.cz> <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
In-Reply-To: <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 09:41 AM, Linus Torvalds wrote:
> On Tue, Jun 29, 2010 at 1:42 AM, Michal Hocko<mhocko@suse.cz>  wrote:
>>
>> futex_find_get_task is currently used (through lookup_pi_state) from two
>> contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
>> makes sense in the first code path, the second one is more problematic
>> because this check requires that the PI lock holder (pid parameter) has
>> the same uid and euid as the process's euid which is trying to lock the
>> same futex (current).
>
> So exactly why does it make sense to check the credentials in the
> first code path then? Shouldn't the futex issue in the end depend on
> whether you have a shared page or not - and not on credentials at all?
> Any two processes that share a futex in the same shared page should be
> able to use that without any regard for whether they are the same
> user. That's kind of the point, no?

I agree and haven't been able to come up with a need for the test 
either, but I wanted to hear back from Ingo as the he authored the 
original check.

I was trying to see if futex_lock_pi() could somehow be abused, but if 
so, I don't see it:

TaskUserA			TaskUserB
futex_lock_pi(addrA)
				*addrB = TID_OF(TaskUserA)
				futex_lock_pi(addrB)

TaskUserB would lookup the pi_state, not find it as addrB and addrA 
don't hash to the same key, create a new pi_state and mark TaskUserA as 
the owner, then block.

Once TaskUserA exits, the pi_list will contain the pi_state for the 
addrB futex. This is "bad", but the kernel cleans it up, releases the 
lock - but doesn't wake TaskUserB. That seems acceptable to me since 
TaskUserB is in the wrong here.


> IOW, I personally dislike these kinds of conditional checks,
> especially since the discussion (at least the part I've seen) hasn't
> made it clear why it should be conditional - or exist - in the first
> place.
>
> So I'd like the patch to include an explanation of exactly why the two
> cases are different.

Agreed, waiting on Ingo at the moment.

> The other thing I'd like to see is to move the whole cred checking up
> a level. There's no reason to check the credentials in
> futex_find_get_task() that I can see - why not do it in the caller
> instead? IOW, I think futex_find_get_task() should just look something
> like this instead:


/me beats head on desk, duh. Still, I'm hoping this isn't necessary and 
we can lose the credentials checking entirely.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
