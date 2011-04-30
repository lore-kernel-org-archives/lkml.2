Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214Ab1D3B5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:57:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58150 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761138Ab1D3B5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:57:45 -0400
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTi=9rW=U-Excx+xJb1h3mVvfEaxhKw@mail.gmail.com>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
	 <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
	 <alpine.LFD.2.02.1104300220040.3005@ionos>
	 <BANLkTi=9rW=U-Excx+xJb1h3mVvfEaxhKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 18:57:35 -0700
Message-ID: <1304128655.30215.80.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 18:12 -0700, Arve Hjønnevåg wrote:
>         /* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
> -       set_normalized_timespec(&delta,
> +       set_normalized_timespec(&new_delta,
>                                 ts.tv_sec - oldtime,
>                                 ts.tv_nsec - (NSEC_PER_SEC >> 1));
> 
> +       /* prevent 1/2 sec errors from accumulating */
> +       delta_delta = timespec_sub(new_delta, delta);
> +       if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2)
> +               delta = new_delta;
>         return 0;

So, the basic idea is to keep the RTC vs CLOCK_REALTIME delta constant
(by using the same value as the last time) for each resume cycle
assuming it stays within +/-2 seconds.

If it changes more then that since the last suspend (due to user running
hwclock or the periodic NTP sync or drift of the uncorrected RTC) then
throw away the old value and use the new delta.


> @@ -80,6 +87,8 @@ static int rtc_resume(struct device *dev)
>                 return 0;
>         }
>         rtc_tm_to_time(&tm, &newtime);
> +       if (delta_delta.tv_sec < -1)
> +               newtime++;


So this part isn't quite clicking at the moment (forgive my brain, its a
sunny friday!). Wouldn't this trigger even if we threw away the old
delta (since nothing clears delta_delta)?

I'll spend some more time looking at it, but if you can clarify why we
want to inject a second here (and why there's not a corresponding dec
for delta_delta being > 1 sec to make it symmetric) it would help? 

thanks
-john




