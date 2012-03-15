Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161422Ab2COUUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:20:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47116 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161381Ab2COUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:19:58 -0400
Message-ID: <4F624EA3.7020009@linaro.org>
Date: Thu, 15 Mar 2012 13:18:43 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] time: x86: Fix race switching from vsyscall to non-vsyscall
 clock
References: <1331769536-4602-1-git-send-email-john.stultz@linaro.org> <1331769536-4602-2-git-send-email-john.stultz@linaro.org> <alpine.LFD.2.02.1203150131390.2466@ionos> <4F613AF9.2030504@linaro.org> <CALCETrWheuZGrMYzvWDRoRjNJt5mD-0FEd+PQRh3N=XjfL98gQ@mail.gmail.com>
In-Reply-To: <CALCETrWheuZGrMYzvWDRoRjNJt5mD-0FEd+PQRh3N=XjfL98gQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031520-2398-0000-0000-00000511D37E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 06:43 PM, Andy Lutomirski wrote:
> On Wed, Mar 14, 2012 at 5:42 PM, John Stultz<john.stultz@linaro.org>  wrote:
>> On 03/14/2012 05:34 PM, Thomas Gleixner wrote:
>>> On Wed, 14 Mar 2012, John Stultz wrote:
>>>>   notrace static noinline int do_realtime(struct timespec *ts)
>>>>   {
>>>>         unsigned long seq, ns;
>>>> +       int mode;
>>> Please keep a newline between declarations and code.
>>
>> Fixed below. Thanks!
>> (Let me know if you see whitespace damage, I switched mail clients today and
>> am learning the quirks here.)
>> -john
>>
>>
>>
>> When switching from a vsyscall capable to a non-vsyscall capable
>> clocksource, there was a small race, where the last vsyscall
>> gettimeofday before the switch might return a invalid time value
>> using the new non-vsyscall enabled clocksource values after the
>> switch is complete.
>>
>> This is due to the vsyscall code checking the vclock_mode once
>> outside of the seqcount protected section. After it reads the
>> vclock mode, it doesn't re-check that the sampled clock data
>> that is obtained in the seqcount critical section still matches.
>>
>> The fix is to sample vclock_mode inside the protected section,
>> and as long as it isn't VCLOCK_NONE, return the calculated
>> value. If it has changed and is now VCLOCK_NONE, fall back
>> to the syscall gettime calculation.
>>
>> v2:
>>   * Cleanup checks as suggested by tglx
>>   * Also fix same issue present in gettimeofday path
>>
>> CC: Andy Lutomirski<luto@amacapital.net>
>> CC: Thomas Gleixner<tglx@linutronix.de>
>> Signed-off-by: John Stultz<john.stultz@linaro.org>
>> ---
>>   arch/x86/vdso/vclock_gettime.c |   68
>> +++++++++++++++++++++++++--------------
>>   1 files changed, 43 insertions(+), 25 deletions(-)
>>
> Looks reasonable to me.  I like this approach better than the earlier
> way -- it's likely to cause less slowdown in the VCLOCK_TSC case.
>
> That being said, I think you might have a bug:
>
> notrace static inline long vgetns(void)
> {
>          long v;
>          cycles_t cycles;
>          if (gtod->clock.vclock_mode == VCLOCK_TSC)
>                  cycles = vread_tsc();
>          else
>                  cycles = vread_hpet();
>          v = (cycles - gtod->clock.cycle_last)&  gtod->clock.mask;
>          return (v * gtod->clock.mult)>>  gtod->clock.shift;
> }
>
> In the VCLOCK_NONE, you'll access the hpet mapping.  But in
> hpet_enable, hpet_set_mapping isn't called and this will crash, I
> think.
Thanks for catching this!

My solution is to add:

	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
		cycles = vread_hpet();
	else
		return 0;

Let me know if this works for you.

thanks
-john


