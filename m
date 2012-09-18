Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2IRA4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:56:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57162 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2IRA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:56:29 -0400
Message-ID: <5057BE59.3050903@linaro.org>
Date: Mon, 17 Sep 2012 17:20:41 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org> <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
In-Reply-To: <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091800-2398-0000-0000-00000B0FD376
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175062; UDB=6.00039646; UTC=2012-09-18
 00:56:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 04:49 PM, Andy Lutomirski wrote:
> On Mon, Sep 17, 2012 at 3:04 PM, John Stultz <john.stultz@linaro.org> wrote:
>> This item has been on my todo list for a number of years.
>>
>> One interesting bit of the timekeeping code is that we internally
>> keep sub-nanosecond precision. This allows for really fine
>> grained error accounting, which allows us to keep long term
>> accuracy, even if the clocksource can only make very coarse
>> adjustments.
>>
>> Since sub-nanosecond precision isn't useful to userland, we
>> normally truncate this extra data off before handing it to
>> userland. So only the timekeeping core deals with this extra
>> resolution.
>>
>> Brief background here:
>>
>> Timekeeping roughly works as follows:
>>          time_ns = base_ns + cyc2ns(cycles)
>>
>> With our sub-ns resolution we can internally do calculations
>> like:
>>          base_ns = 0.9
>>          cyc2ns(cycles) =  0.9
>>          Thus:
>>          time_ns = 0.9 + 0.9 = 1.8 (which we truncate down to 1)
>>
>>
>> Where we periodically accumulate the cyc2ns(cycles) portion into
>> the base_ns to avoid cycles getting to large where it might overflow.
>>
>> So we might have a case where we accumulate 3 cycle "chunks", each
>> cycle being 10.3 ns long.
>>
>> So before accumulation:
>>          base_ns = 0
>>          cyc2ns(4) = 41.2
>>          time_now = 41.2 (truncated to 41)
>>
>> After accumulation:
>>          base_ns = 30.9
>>          cyc2ns(1) = 10.3
>>          time_now = 41.2 (truncated to 41)
>>
>>
>> One quirk is when we export timekeeping data to the vsyscall code,
>> we also truncate the extra resolution. This in the past has caused
>> problems, where single nanosecond inconsistencies could be detected.
>>
>> So before accumulation:
>>          base_ns = 0
>>          cyc2ns(4) = 41.2 (truncated to 41)
>>          time_now = 41
>>
>> After accumulation:
>>          base_ns = 30.9 (truncated to 30)
>>          cyc2ns(1) = 10.3 (truncated to 10)
>>          time_now = 40
>>
>> And time looks like it went backwards!
>>
>> In order to avoid this, we currently end round up to the next
>> nanosecond when we do accumulation. In order to keep this from
>> causing long term drift (as much as 1ns per tick), we add the
>> amount we rounded up to the error accounting, which will slow the
>> clocksource frequency appropriately to avoid the drift.
>>
>> This works, but causes the clocksource adjustment code to do much
>> more work. Steven Rosdet pointed out that the unlikely() case in
>> timekeeping_adjust is ends up being true every time.
>>
>> Further this, rounding up and slowing down adds more complexity to
>> the timekeeping core.
>>
>> The better solution is to provide the full sub-nanosecond precision
>> data to the vsyscall code, so that we do the truncation on the final
>> data, in the exact same way the timekeeping core does, rather then
>> truncating some of the source data. This requires reworking the
>> vsyscall code paths (x86, ppc, s390, ia64) to be able to handle this
>> extra data.
>>
>> This patch set provides an initial draft of how I'd like to solve it.
>> 1) Introducing first a way for the vsyscall data to access the entire
>>     timekeeper stat
>> 2) Transitioning the existing update_vsyscall methods to
>>     update_vsyscall_old
>> 3) Introduce the new full-resolution update_vsyscall method
>> 4) Limit the problematic extra rounding to only systems using the
>>     old vsyscall method
>> 5) Convert x86 to use the new vsyscall update and full resolution
>>     gettime calculation.
>>
>> Powerpc, s390 and ia64 will also need to be converted, but this
>> allows for a slow transition.
>>
>> Anyway, I'd greatly appreciate any thoughts or feedback on this
>> approach.
> I haven't looked in any great detail, but the approach looks sensible
> and should slow down the vsyscall code.

Did you mean "shouldn't"?   Or are you concerned about something 
specifically?

I know you've done quite a bit of tuning on the x86 vdso side, and I 
don't want to wreck that, so I'd appreciate any specific thoughts you 
have if you get a chance to look at it.

> That being said, as long as you're playing with this, here are a
> couple thoughts:
>
> 1. The TSC-reading code does this:
>
> 	ret = (cycle_t)vget_cycles();
>
> 	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
>
> 	if (likely(ret >= last))
> 		return ret;
>
> I haven't specifically benchmarked the cost of that branch, but I
> suspect it's a fairly large fraction of the total cost of
> vclock_gettime.  IIUC, the point is that there might be a few cycles
> worth of clock skew even on systems with otherwise usable TSCs, and we
> don't want a different CPU to return complete garbage if the cycle
> count is just below cycle_last.
>
> A different formulation would avoid the problem: set cycle_last to,
> say, 100ms *before* the time of the last update_vsyscall, and adjust
> the wall_time, etc variables accordingly.  That way a few cycles (or
> anything up to 100ms) or skew won't cause an overflow.  Then you could
> kill that branch.
Interesting.  So I want to keep the scope of this patch set in check, so 
I'd probably hold off on something like this till later, but this might 
not be too complicated to do in the update_wall_time() function, 
basically delaying the accumulation by some amount of time  Although 
this would have odd effects on things like filesystem timestamps, which 
provide "the time at the last tick", which would then be "the time at 
the last tick + Xms".  So it probably needs more careful consideration.



> 2. There's nothing vsyscall-specific about the code in
> vclock_gettime.c.  In fact, the VVAR macro should work just fine in
> kernel code.  If you moved all this code into a header, then in-kernel
> uses could use it, and maybe even other arches could use it.  Last
> time I checked, it seemed like vclock_gettime was considerably faster
> than whatever the in-kernel equivalent did.
I like the idea of unifying the implementations, but I'd want to know 
more about why vclock_gettime was faster then the in-kernel 
getnstimeofday(), since it might be due to the more limited locking (we 
only update vsyscall data under the vsyscall lock, where as the 
timekeeper lock is held for the entire execution of update_wall_time()), 
or some of the optimizations in the vsyscall code is focused on 
providing timespecs to userland, where as in-kernel we also have to 
provide ktime_ts.

If you have any details here, I'd love to hear more. There is some work 
I have planned to address some of these differences, but I'm not sure 
when I'll eventually get to it.


> 3. The mul_u64_u32_shr function [1] might show up soon, and it would
> potentially allow much longer intervals between timekeeping updates.
> I'm not sure whether the sub-ns formuation would still work, though (I
> suspect it would with some care).
>
Yea, we already have a number of calculations to try to maximize the 
interval while still allowing for fine tuned adjustments. Even so, we 
are somewhat bound by the need to provide tick-granular timestamps for 
filesystem code, etc.  So it may be limited to extending idle times out 
until folks are ok with either going with most expensive clock-granular 
timestamps for filesystem code, or loosing the granularity needs somewhat.

But thanks for pointing it out, I'll keep an eye on it.

Tanks again!
-john

