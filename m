Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2IRAnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:43:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58279 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2IRAnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <5057BE59.3050903@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <5057BE59.3050903@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Sep 2012 17:43:26 -0700
Message-ID: <CALCETrVDsjkQkdmMtbGz7fP053VZo6O1UWtxZpg8wwa7jWVU7w@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 5:20 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 09/17/2012 04:49 PM, Andy Lutomirski wrote:
>>
>> On Mon, Sep 17, 2012 at 3:04 PM, John Stultz <john.stultz@linaro.org>
>> wrote:

>>>
>>> Anyway, I'd greatly appreciate any thoughts or feedback on this
>>> approach.
>>
>> I haven't looked in any great detail, but the approach looks sensible
>> and should slow down the vsyscall code.
>
>
> Did you mean "shouldn't"?   Or are you concerned about something
> specifically?
>
> I know you've done quite a bit of tuning on the x86 vdso side, and I don't
> want to wreck that, so I'd appreciate any specific thoughts you have if you
> get a chance to look at it.

I meant "shouldn't".  The thing I use for testing is:
https://gitorious.org/linux-test-utils/linux-clock-tests

>
>
>> That being said, as long as you're playing with this, here are a
>> couple thoughts:
>>
>> 1. The TSC-reading code does this:
>>
>>         ret = (cycle_t)vget_cycles();
>>
>>         last = VVAR(vsyscall_gtod_data).clock.cycle_last;
>>
>>         if (likely(ret >= last))
>>                 return ret;
>>
>> I haven't specifically benchmarked the cost of that branch, but I
>> suspect it's a fairly large fraction of the total cost of
>> vclock_gettime.  IIUC, the point is that there might be a few cycles
>> worth of clock skew even on systems with otherwise usable TSCs, and we
>> don't want a different CPU to return complete garbage if the cycle
>> count is just below cycle_last.
>>
>> A different formulation would avoid the problem: set cycle_last to,
>> say, 100ms *before* the time of the last update_vsyscall, and adjust
>> the wall_time, etc variables accordingly.  That way a few cycles (or
>> anything up to 100ms) or skew won't cause an overflow.  Then you could
>> kill that branch.
>
> Interesting.  So I want to keep the scope of this patch set in check, so I'd
> probably hold off on something like this till later, but this might not be
> too complicated to do in the update_wall_time() function, basically delaying
> the accumulation by some amount of time  Although this would have odd
> effects on things like filesystem timestamps, which provide "the time at the
> last tick", which would then be "the time at the last tick + Xms".  So it
> probably needs more careful consideration.

Fair enough.  One way to do this cleanly might be to have helpers that
effectively read CLOCK_REALTIME_COARSE and use those instead of xtime.

>
>
>
>
>> 2. There's nothing vsyscall-specific about the code in
>> vclock_gettime.c.  In fact, the VVAR macro should work just fine in
>> kernel code.  If you moved all this code into a header, then in-kernel
>> uses could use it, and maybe even other arches could use it.  Last
>> time I checked, it seemed like vclock_gettime was considerably faster
>> than whatever the in-kernel equivalent did.
>
> I like the idea of unifying the implementations, but I'd want to know more
> about why vclock_gettime was faster then the in-kernel getnstimeofday(),
> since it might be due to the more limited locking (we only update vsyscall
> data under the vsyscall lock, where as the timekeeper lock is held for the
> entire execution of update_wall_time()), or some of the optimizations in the
> vsyscall code is focused on providing timespecs to userland, where as
> in-kernel we also have to provide ktime_ts.
>
> If you have any details here, I'd love to hear more. There is some work I
> have planned to address some of these differences, but I'm not sure when
> I'll eventually get to it.
>

I suspect it's because everyone who's benchmarked and tuned the "what
time is it?" code has focused on the vdso version, so the in-kernel
version hasn't gotten much love.  The vclock_gettime code has
basically no abstractions and uses only direct (i.e. explicitly
devirtualized) calls.  ktime_get, OTOH, uses clock->read, which, in
the best case, is read_tsc.  read_tsc (in arch/x86/kernel/tsc.c) is
missing the don't-use-cmov optimization.

The vclock_gettime code also produces a struct timespec without
div/mod, which is probably impossible for any code that goes through
ktime.

In the other direction, AFAICS the in-kernel code is completely
missing the rdtsc_barrier call, which is empirically rather necessary.
 It's pretty easy to detect clock skew without it.

>
>
>> 3. The mul_u64_u32_shr function [1] might show up soon, and it would
>> potentially allow much longer intervals between timekeeping updates.
>> I'm not sure whether the sub-ns formuation would still work, though (I
>> suspect it would with some care).
>>
> Yea, we already have a number of calculations to try to maximize the
> interval while still allowing for fine tuned adjustments. Even so, we are
> somewhat bound by the need to provide tick-granular timestamps for
> filesystem code, etc.  So it may be limited to extending idle times out
> until folks are ok with either going with most expensive clock-granular
> timestamps for filesystem code, or loosing the granularity needs somewhat.

Maybe this could depend on which clocksource is in use.  On recent
Intel boxen, the entire vclock_gettime call takes under 20 ns.  When
called from the kernel, it could be even faster if static keys (or
whatever they're called these days) were used.

FWIW, I don't understand the NTP code at all.  I'm pretty sure I know
what a PLL is, and I don't understand how that has anything to do with
NTP (although it makes sense in a PPS context).  I've always wondered
why the kernel's idea of time was any more complicated than "here's
the clock frequency; in addition, slew the time by X ns (or sub-ns)
over the next Y ns" -- some driver or even userspace code could
program that and the kernel could wake up when it needed to for the
update.  (To make this seamless, vclock_gettime would either need a
branch or the kernel would need to wake up a little early and update
the vsyscall data.)

--Andy
