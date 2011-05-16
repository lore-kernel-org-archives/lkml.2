Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1EPQ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:29:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1EPQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cBAvB0b+OKOLMx96aYufT1J4uzLe+h5A8GLUXvfwxEeGwLubFweMs2zn0t0n91f+zT
         is5aJR8xnMM4Ooonbyvg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105161642250.3078@ionos>
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
Date: Mon, 16 May 2011 09:29:03 -0700
X-Google-Sender-Auth: CtVb6gPnvRb_m30fL8-Zfw2q8K0
Message-ID: <BANLkTimMSPmqD+kyz1EJUrH9sS=qWRZymw@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Colin Cross <ccross@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 7:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 16 May 2011, Santosh Shilimkar wrote:
>> On 5/14/2011 9:21 PM, Thomas Gleixner wrote:
>> Just for my understanding, the clockevents_reconfigure() needs to
>> be called with interrupts disabled on that CPU as part of
>> the CPUFREQ notifiers. I assume the right place is do it
>> in POST notifier after the CPU clock and hence TWD clock is
>> updated. Is that right ?
>
> Yes.

Is it safe to only call it in POST?  If the frequency is increasing,
and the TWD is not updated until after the CPU frequency has changed,
it is possible for a clockevent to fire too early.  Will that cause
problems, or does the clockevent code check against a clocksource to
ensure the desired time has been reached?  If that is OK, it
drastically simplifies the code, because the driver only needs to know
the current TWD frequency, not predict a future TWD frequency.

>> Since there is need to call this API in interrupt
>> disable context, does it make sense to take care of it
>> inside the API itself instead of relying on caller fn ?
>
> Hmm, no strong opinion

For SMP TWD, the caller will always be in interrupt disabled mode,
because the cpufreq notifier will get called on a random cpu, so
smp_call_function_single will be used to transition to the correct
cpu, which disables interrupts.

>> The arch's where the per CPU TWD's share clock, per-cpu
>> clock-events should be reconfigured on all CPUs, whenever
>> the parent(CPU) clock has changed using some thing like
>> smp_call_function_any() etc. Is that right understanding?
>
> Yes. If that's a common requirement we should move that to core code.

Santosh, are you suggesting the TWD be updated from the clock
framework instead of the cpufreq notifier?

I believe ARMv7 requires all CPUs to run at the same frequency, so it
would be possible to do this in the core code somewhere, but A15 has
fixed frequency counters, and all SMP Cortex-A9s I've seen use the SMP
TWD driver, so in practice this may end up being the only user.

It would be possible for the clockevent to have a flag
CLOCKEVENT_EVT_FEAT_SCALES_WITH_CPU, which registers a cpufreq
notifier, if there were any other users.
