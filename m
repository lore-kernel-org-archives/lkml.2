Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1D3DaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:30:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58103 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab1D3DaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:30:02 -0400
MIME-Version: 1.0
In-Reply-To: <1304128655.30215.80.camel@work-vm>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
	<BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
	<alpine.LFD.2.02.1104300220040.3005@ionos>
	<BANLkTi=9rW=U-Excx+xJb1h3mVvfEaxhKw@mail.gmail.com>
	<1304128655.30215.80.camel@work-vm>
Date: Fri, 29 Apr 2011 20:30:00 -0700
Message-ID: <BANLkTikEwZ84bQbuJxzQNfpNZOrGaq8C7g@mail.gmail.com>
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 John Stultz <john.stultz@linaro.org>:
> On Fri, 2011-04-29 at 18:12 -0700, Arve Hjønnevåg wrote:
>>         /* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
>> -       set_normalized_timespec(&delta,
>> +       set_normalized_timespec(&new_delta,
>>                                 ts.tv_sec - oldtime,
>>                                 ts.tv_nsec - (NSEC_PER_SEC >> 1));
>>
>> +       /* prevent 1/2 sec errors from accumulating */
>> +       delta_delta = timespec_sub(new_delta, delta);
>> +       if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2)
>> +               delta = new_delta;
>>         return 0;
>
> So, the basic idea is to keep the RTC vs CLOCK_REALTIME delta constant
> (by using the same value as the last time) for each resume cycle
> assuming it stays within +/-2 seconds.
>
> If it changes more then that since the last suspend (due to user running
> hwclock or the periodic NTP sync or drift of the uncorrected RTC) then
> throw away the old value and use the new delta.
>

Yes.

>
>> @@ -80,6 +87,8 @@ static int rtc_resume(struct device *dev)
>>                 return 0;
>>         }
>>         rtc_tm_to_time(&tm, &newtime);
>> +       if (delta_delta.tv_sec < -1)
>> +               newtime++;
>
>
> So this part isn't quite clicking at the moment (forgive my brain, its a
> sunny friday!). Wouldn't this trigger even if we threw away the old
> delta (since nothing clears delta_delta)?
>
Probably.

> I'll spend some more time looking at it, but if you can clarify why we
> want to inject a second here (and why there's not a corresponding dec
> for delta_delta being > 1 sec to make it symmetric) it would help?
>

I don't remember exactly why I did it this way, but the goal is to
make sure time does not jump backwards. If the rtc runs slower than
the clock we are using when awake, then time could jump backwards
after suspend since we re-sync with the rtc. With your new code, it is
probably better to just clip the resulting sleep-time to not allow
negative values.

-- 
Arve Hjønnevåg
