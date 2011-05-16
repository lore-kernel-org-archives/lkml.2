Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1EPXIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:08:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1EPXIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fAPMH8xYcAs6RB+HDekYx357zqDYmLmwielwDmWDPAKWdRwktqkU25nbEJtVf8Bwt3
         JaQy2BtK12LpjDaTPAyA==
MIME-Version: 1.0
In-Reply-To: <4DD15427.7080506@ti.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
	<AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
	<7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
	<AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
	<AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com>
	<BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com>
	<alpine.LFD.2.02.1105131138460.2831@ionos>
	<BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com>
	<alpine.LFD.2.02.1105141749510.3078@ionos>
	<4DD10814.1010103@ti.com>
	<alpine.LFD.2.02.1105161642250.3078@ionos>
	<BANLkTimMSPmqD+kyz1EJUrH9sS=qWRZymw@mail.gmail.com>
	<4DD15427.7080506@ti.com>
Date: Mon, 16 May 2011 16:08:00 -0700
X-Google-Sender-Auth: tcnqMk8TqQZJGrG6HRUn_OMOLkk
Message-ID: <BANLkTimsnJsnXkMOjiD52vhL612LVZoVvA@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Colin Cross <ccross@android.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        martin persson <martin.persson@stericsson.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 9:43 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On 5/16/2011 9:59 PM, Colin Cross wrote:
>>
>> On Mon, May 16, 2011 at 7:44 AM, Thomas Gleixner<tglx@linutronix.de>
>>  wrote:
>>>
>>> On Mon, 16 May 2011, Santosh Shilimkar wrote:
>>>>
>>>> On 5/14/2011 9:21 PM, Thomas Gleixner wrote:
>>>> Just for my understanding, the clockevents_reconfigure() needs to
>>>> be called with interrupts disabled on that CPU as part of
>>>> the CPUFREQ notifiers. I assume the right place is do it
>>>> in POST notifier after the CPU clock and hence TWD clock is
>>>> updated. Is that right ?
>>>
>>> Yes.
>>
>> Is it safe to only call it in POST?  If the frequency is increasing,
>> and the TWD is not updated until after the CPU frequency has changed,
>> it is possible for a clockevent to fire too early.  Will that cause
>> problems, or does the clockevent code check against a clocksource to
>> ensure the desired time has been reached?  If that is OK, it
>> drastically simplifies the code, because the driver only needs to know
>> the current TWD frequency, not predict a future TWD frequency.
>>
> This was the exact reason I asked this question. As discussed
> earlier on this thread, we observed drift in ticks especially
> at lowest and highest clock-points. But they way I understood
> is clockevents_reconfigure() will block those additional
> ticks at least during the reconfiguration of the clock-event.
>
>
>>>> Since there is need to call this API in interrupt
>>>> disable context, does it make sense to take care of it
>>>> inside the API itself instead of relying on caller fn ?
>>>
>>> Hmm, no strong opinion
>>
>> For SMP TWD, the caller will always be in interrupt disabled mode,
>> because the cpufreq notifier will get called on a random cpu, so
>> smp_call_function_single will be used to transition to the correct
>> cpu, which disables interrupts.
>>
> Ok. So it's indirectly taken care then.
>
>>>> The arch's where the per CPU TWD's share clock, per-cpu
>>>> clock-events should be reconfigured on all CPUs, whenever
>>>> the parent(CPU) clock has changed using some thing like
>>>> smp_call_function_any() etc. Is that right understanding?
>>>
>>> Yes. If that's a common requirement we should move that to core code.
>>
>> Santosh, are you suggesting the TWD be updated from the clock
>> framework instead of the cpufreq notifier?
>>
> That's where I was kind of leaning to. Basically doing this in common
> core code at one place and possibly outside the ARM TWD library. You
> might get same requirement on other arch's in future.

But right now, there is no common clock place, and even if there was,
there is no plan that I know of for a clock notifier, which is what
would be required here.

>> I believe ARMv7 requires all CPUs to run at the same frequency, so it
>> would be possible to do this in the core code somewhere, but A15 has
>> fixed frequency counters, and all SMP Cortex-A9s I've seen use the SMP
>> TWD driver, so in practice this may end up being the only user.
>>
> Yes but the code managing the architectural timer(A15) and TWD(A9) is
> different. But I understand your point about the usage and it
> might be limited to CA9 at this point of time.
>
>> It would be possible for the clockevent to have a flag
>> CLOCKEVENT_EVT_FEAT_SCALES_WITH_CPU, which registers a cpufreq
>> notifier, if there were any other users.
>
>>
> Something like this is better to get better clarity on the
> hardware behavior. O.w we will have piece of code in TWD
> library which needs proper documentation about the
> usage of likes of smp_call_function_single().

This is harder than I made it sound, unless the clockevent code took a
struct clk as well.  Something needs to get the frequency of the
smp_twd clock and pass it in to clockevents_reconfigure.

I will post an RFC patch that uses a clock to call
clockevents_reconfigure from a cpufreq notifier in smp_twd.c.
