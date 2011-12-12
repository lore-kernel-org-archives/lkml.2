Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1LLXBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:01:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41186 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LLXBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <4EE6850F.5070002@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
 <1323718578-1157-3-git-send-email-asharma@fb.com> <CAObL_7F8v1PT0FQ=GNcNmJKWkzQ7DfkQ9ym2EeR0TgFKiZPPaw@mail.gmail.com>
 <4EE6850F.5070002@fb.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Dec 2011 15:01:24 -0800
X-Google-Sender-Auth: 3vXcahu04rgKgspXNcxWQkBDeKA
Message-ID: <CAObL_7GPA2RvVQSO9PhDs0X++=_62B83Y-CM1DL1+a9oftJ=YQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 2:49 PM, Arun Sharma <asharma@fb.com> wrote:
>>
>> I also wonder if there a problem with information leaking.  If there
>> was an entire per-cpu vvar page (perhaps mapped differently on each
>> cpu) then nothing interesting would leak.  But that could add
>> overhead.
>>
>
> The timing based attacks depend on the granularity of timestamps. I feel
> what's available here is too coarse grained to be useful. Happy to
> disable the code at compile time for those cases. Are there
> CONFIG_HIGH_SECURITY type of options I could use for this purpose?

It allows anyone to detect with very high precision when context
switches happen on another CPU.  This sounds a little dangerous.  I
don't know if a config option is the right choice.

>
>>>  notrace static long vdso_fallback_gettime(long clock, struct timespec
>>> *ts)
>>>  {
>>>        long ret;
>>> -       asm("syscall" : "=a" (ret) :
>>> -           "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
>>> +       asm volatile("syscall" : "=a" (ret) :
>>> +                    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) :
>>> "memory");
>>>        return ret;
>>>  }
>>
>>
>> Huh?  This should probably be a separate patch (and probably not a
>> -stable candidate, since it would take amazing compiler stupidity to
>> generate anything other than the obvious code).  The memory clobber
>> may also be enough to make this officially safe.
>
>
> Yes - this should be a separate patch. gcc-4.4 likes to get rid of the
> instruction in __do_thread_cpu_time without the asm volatile (in spite of
> the memory clobber).
>

gcc 4.4 caught a genuine bug in your code.  You ignored the return
value (which is an output constraint), so you weren't using any
outputs and gcc omitted the apparently useless code.  The right fix is
to check the return value.  (And to consider adding the missing
volatile.)

>
>
>>> +       if (vp->tsc_unstable) {
>>> +               struct timespec ts;
>>> +               vdso_fallback_gettime(CLOCK_THREAD_CPUTIME_ID,&ts);
>>> +               return timespec_to_ns(&ts);
>>> +       }
>>
>>
>> Yuck -- another flag indicating whether we're using the tsc.
>
>
> I renamed it to thread_cputime_disabled to deal with NR_CPUS > 64.
>

Still yuck.  IMO this should always work.

>
>>> --- a/arch/x86/vdso/vdso.lds.S
>>> +++ b/arch/x86/vdso/vdso.lds.S
>>> @@ -25,6 +25,8 @@ VERSION {
>>>                __vdso_getcpu;
>>>                time;
>>>                __vdso_time;
>>> +               thread_cpu_time;
>>> +               __vdso_thread_cpu_time;
>>>        local: *;
>>>        };
>>>  }
>>
>>
>> Why do we have the non-__vdso versions?  IMO anything that actually
>> uses them is likely to be confused.  They have the same names as the
>> glibc wrappers, but the glibc wrappers have different return value and
>> errno semantics.  I'd say just use __vdso.
>
>
> I'm not familiar with the history of __vdso_foo vs foo. Happy to get rid of
> the non __vdso versions.
>

I'm not either :)  I'm just the most recent person to have made major
changes to this code.


>
>>
>> Also, what's wrong with just adding the functionality to
>> __vdso_clock_gettime?
>>
>
> Performance. Most of this is client dependent (whether it expects time in
> nanoseconds or timespec).
>
>
> Baseline:               19.34 secs
> vclock_gettime:         4.74 secs
> thread_cpu_time:        3.62 secs
>
> Our use case prefers nanoseconds, so the conversion to timespec and back
> adds overhead. Also, having a direct entry point vs going through the switch
> in clock_gettime() adds some cycles.
>
> I have some people here asking me if they could get CLOCK_REALTIME and
> CLOCK_MONOTONIC also in nanoseconds for the same reason.

I'd support a clock_gettime_nsec that supported all the clocks with
sensible semantics.  Perhaps a pair of functions:

clock_gettime_nsec_base that returns an offset, shifted right by 2^63
(63 is somewhat arbitrary.  32 would work just as well, but 64 would
be more awkward to use) with a "guarantee" that the value will not
change until a reboot unless the system is up for a really long time
such that clock_gettime_nsec actually wraps.  clock_gettime_nsec would
then return an offset.

>
>
>
>>> +struct vcpu_data {
>>> +       struct vpercpu_data vpercpu[NR_CPUS];
>>> +       unsigned int tsc_khz;
>>
>>
>> I think this also duplicates some of the gtod_data stuff, at least in
>> the case that TSC works for gtod.
>>
>
> vgotd.h seems to be clock source independent. This vsyscall is usable only
> on systems with tsc_unstable == 0. Also, there is only one instance of mult
> and shift there, whereas we save it on a per-cpu basis in the VVAR page.

Sorry, I was unclear.  gtod_data contains vclock_mode, which will tell
you whether the tsc is usable.  I have a buggy computer (I'm typing
this email on it) that has a TSC that is only useful per-process.  I
don't think it's worth supporting this particular case, since it's a
bios bug and needs fixing by the vendor.  It's hopefully rare.

--Andy
