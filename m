Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1DEGmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:42:42 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60258 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab1DEGml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:42:41 -0400
Message-ID: <4D9AB958.5010304@ti.com>
Date: Tue, 05 Apr 2011 12:10:24 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Marc Zyngier <Marc.Zyngier@arm.com>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Detlef Vollmann <dv@vollmann.ch>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>	<201104031726.37420.arnd@arndb.de>	<20110403160324.GA8050@n2100.arm.linux.org.uk>	<201104040259.26601.arnd@arndb.de>	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>	<20110404112104.GB19854@n2100.arm.linux.org.uk>	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>	<20110404133104.GA23266@n2100.arm.linux.org.uk>	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com> <BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>
In-Reply-To: <BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2011 1:38 AM, Linus Walleij wrote:
> 2011/4/4 Marc Zyngier<Marc.Zyngier@arm.com>:
>> On Mon, 2011-04-04 at 14:31 +0100, Russell King - ARM Linux wrote:
>>>
>>> If ARM are going to architect a set of timers into the hardware, let's
>>> make sure that all such hardware has them so we can dig ourselves out
>>> of this crappy mess that we find ourselves in today.
>>
>> As far as I know, A15 always has a set of generic timers.
>>
>> It may be that they are not available (frequency not programmed into the
>> CNTFREQ register), or that someone decided to use a better alternative
>> (for some particular interpretation of "better").
>
> I guess this thing is inside that A15 core?
>
Yes but the power domain partitioning can be used.

> First, what happens the day any vendors start making SoCs on this is
> they turn the A15 core off whenever it is not used, loosing all state
> including this timer, I believe.
>
> This forces them all to add some totally different clocksource, event and
> wakeup in some always-on voltage domain and rate that higher than
> the A15 timer(s). They will then implement sched_clock() and
> clocksource on that instead and only use A15 for localtimers.
>
> (Leading to the proliferation of board/SoC timer hacks discussed
> so much recently...)
>
> The only way to reuse that poor thing in practice is if you engineer
> a separate power domain with stuff that is supposed to be always-on
> in the A15 macro (including these timers) so vendors must implement
> this so as not to loose its state. Is this the case?
>
Yes. From what I understood from A15 timer architeture so far is,
A15 counter is suppose to be kept in ALWAYS ON domain by Soc vendors.
That's the requirement.

> Else, in effect it will only be used as clocksource and sched_clock()
> with these Versatile boards where the power is always on anyway.
>
> Second, have you taken into account the effect of changing the
> frequency of the A15 core, which is something every vendor also
> does, as you know Colin Cross already has a patch pending
> for that on the TWD localtimer which has not yet reached
> the kernel. (Or is A15 fixed frequency? Forgive my ignorance...)
>
This one is also addressed. The counter will run on fixed
frequency and even if the clock input has changed, the
counting will be as if the clock source is constant.
e.g
- @6 MHz, counter will increment count by 1 for every ~166 nS
- @32 KHz, counter will increment count by ~183 times for
   every ~30 ms

So overall clock-source should work in all scenario's including low
power scenario'.

The only issue I see is the clock-events implemented using
local timers capabilities in low power modes. The local timers
won't be able wakeup CPU from DORMANT or OFF state and hence
you will need an additional wakeup capable clock-event
working together with the local timers using clock-notifiers.

> (And third it will also eventually need to hook into the timer-based
> delay framework that I think Nokia is working on to be really
> useful, else all delays become unpredictable.)
>
Do you mean udelay()/mdelay() here ?

Regards
Santosh
