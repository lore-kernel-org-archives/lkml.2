Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161805Ab2COVCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:02:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161767Ab2COVBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <4F624EA3.7020009@linaro.org>
References: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
 <1331769536-4602-2-git-send-email-john.stultz@linaro.org> <alpine.LFD.2.02.1203150131390.2466@ionos>
 <4F613AF9.2030504@linaro.org> <CALCETrWheuZGrMYzvWDRoRjNJt5mD-0FEd+PQRh3N=XjfL98gQ@mail.gmail.com>
 <4F624EA3.7020009@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 Mar 2012 14:01:16 -0700
Message-ID: <CALCETrVhRec-Yd6e6K7AiULk51uKbbh6VfAe8sSPkzU-YPYZwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] time: x86: Fix race switching from vsyscall to
 non-vsyscall clock
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 1:18 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 03/14/2012 06:43 PM, Andy Lutomirski wrote:
>>
>> On Wed, Mar 14, 2012 at 5:42 PM, John Stultz<john.stultz@linaro.org>
>>  wrote:
>>>
>>> On 03/14/2012 05:34 PM, Thomas Gleixner wrote:
>>>>
>>>> On Wed, 14 Mar 2012, John Stultz wrote:
>>>>>
>>>>>  notrace static noinline int do_realtime(struct timespec *ts)
>>>>>  {
>>>>>        unsigned long seq, ns;
>>>>> +       int mode;
>>>>
>>>> Please keep a newline between declarations and code.
>>>
>>>
>>> Fixed below. Thanks!
>>> (Let me know if you see whitespace damage, I switched mail clients today
>>> and
>>> am learning the quirks here.)
>>> -john
>>>
>>>
>>>
>>> When switching from a vsyscall capable to a non-vsyscall capable
>>> clocksource, there was a small race, where the last vsyscall
>>> gettimeofday before the switch might return a invalid time value
>>> using the new non-vsyscall enabled clocksource values after the
>>> switch is complete.
>>>
>>> This is due to the vsyscall code checking the vclock_mode once
>>> outside of the seqcount protected section. After it reads the
>>> vclock mode, it doesn't re-check that the sampled clock data
>>> that is obtained in the seqcount critical section still matches.
>>>
>>> The fix is to sample vclock_mode inside the protected section,
>>> and as long as it isn't VCLOCK_NONE, return the calculated
>>> value. If it has changed and is now VCLOCK_NONE, fall back
>>> to the syscall gettime calculation.
>>>
>>> v2:
>>>  * Cleanup checks as suggested by tglx
>>>  * Also fix same issue present in gettimeofday path
>>>
>>> CC: Andy Lutomirski<luto@amacapital.net>
>>> CC: Thomas Gleixner<tglx@linutronix.de>
>>> Signed-off-by: John Stultz<john.stultz@linaro.org>
>>> ---
>>>  arch/x86/vdso/vclock_gettime.c |   68
>>> +++++++++++++++++++++++++--------------
>>>  1 files changed, 43 insertions(+), 25 deletions(-)
>>>
>> Looks reasonable to me.  I like this approach better than the earlier
>> way -- it's likely to cause less slowdown in the VCLOCK_TSC case.
>>
>> That being said, I think you might have a bug:
>>
>> notrace static inline long vgetns(void)
>> {
>>         long v;
>>         cycles_t cycles;
>>         if (gtod->clock.vclock_mode == VCLOCK_TSC)
>>                 cycles = vread_tsc();
>>         else
>>                 cycles = vread_hpet();
>>         v = (cycles - gtod->clock.cycle_last)&  gtod->clock.mask;
>>
>>         return (v * gtod->clock.mult)>>  gtod->clock.shift;
>> }
>>
>> In the VCLOCK_NONE, you'll access the hpet mapping.  But in
>> hpet_enable, hpet_set_mapping isn't called and this will crash, I
>> think.
>
> Thanks for catching this!
>
> My solution is to add:
>
>        else if (gtod->clock.vclock_mode == VCLOCK_HPET)
>                cycles = vread_hpet();
>        else
>                return 0;
>
> Let me know if this works for you.

I think that's much better than my poorly-thought-out suggestion.
Accessing the hpet mapping is really slow, so avoiding it if the hpet
is disabled is a good idea.  And the extra branches shouldn't penalize
the tsc case (which is the only fast case) unless the compiler does
something silly.

--Andy

>
> thanks
> -john
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
