Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1EPLSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:18:55 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:45022 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab1EPLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:18:54 -0400
Message-ID: <4DD10814.1010103@ti.com>
Date: Mon, 16 May 2011 16:48:44 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Colin Cross <ccross@android.com>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
References: <1290060899-9786-1-git-send-email-ccross@android.com> <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com> <4D70BE9D.4000507@stericsson.com> <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com> <4D714C17.7080102@gmail.com> <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com> <eea425c066cc69c30f118fb102fff43e@mail.gmail.com> <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com> <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com> <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com> <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com> <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com> <alpine.LFD.2.02.1105131138460.2831@ionos> <BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com> <alpine.LFD.2.02.1105141749510.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105141749510.3078@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/2011 9:21 PM, Thomas Gleixner wrote:
> On Fri, 13 May 2011, Colin Cross wrote:
>> On Fri, May 13, 2011 at 3:02 AM, Thomas Gleixner<tglx@linutronix.de>  wrote:
>>>   /**
>>> + * clockevents_reconfigure - Reconfigure and reprogram a clock event device.
>>> + * @dev:       device to modify
>>> + * @freq:      new device frequency
>>> + * @secr:      guaranteed runtime conversion range in seconds
>>> + *
>>> + * Reconfigure and reprogram a clock event device in oneshot
>>> + * mode. Must only be called from low level idle code where
>>> + * interaction with hrtimers/nohz code etc. is not possible and
>>> + * guaranteed not to conflict. Must be called with interrupts
>>> + * disabled!
>>> + * Returns 0 on success, -ETIME when the event is in the past or
>>> + * -EINVAL when called with invalid parameters.
>>> + */
>> We need to call this from a cpufreq notifier with interrupts disabled,
>> not from idle.
>
> That works as well. Comments needs update. The important thing is that
> neither a timer interrupt nor a hrtimer function should interfere on
> that very cpu.
>

The new interface certainly better than the TWD PRE-SCALER method.

Thanks for this Thomas.

Just for my understanding, the clockevents_reconfigure() needs to
be called with interrupts disabled on that CPU as part of
the CPUFREQ notifiers. I assume the right place is do it
in POST notifier after the CPU clock and hence TWD clock is
updated. Is that right ?

Since there is need to call this API in interrupt
disable context, does it make sense to take care of it
inside the API itself instead of relying on caller fn ?

The arch's where the per CPU TWD's share clock, per-cpu
clock-events should be reconfigured on all CPUs, whenever
the parent(CPU) clock has changed using some thing like
smp_call_function_any() etc. Is that right understanding?

At least this is how I did twd pre-scaler based fn
for OMAP.

Regards
Santosh




