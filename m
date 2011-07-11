Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1GKLuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:50:32 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35946 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1GKLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:50:30 -0400
Message-ID: <4E1AE372.1000909@mvista.com>
Date: Mon, 11 Jul 2011 15:50:10 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wim Van Sebroeck <wim@iguana.be>,
        Marc Zyngier <marc.zyngier@arm.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/4] ARM: smp_twd: Fix typo in 'twd_timer_rate' printing
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-1-git-send-email-vkuzmichev@mvista.com> <20110707123907.GP8286@n2100.arm.linux.org.uk> <4E15DCE1.8010201@mvista.com> <20110710104740.GD4812@n2100.arm.linux.org.uk>
In-Reply-To: <20110710104740.GD4812@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 07/10/2011 02:47 PM, Russell King - ARM Linux wrote:
> On Thu, Jul 07, 2011 at 08:20:49PM +0400, Vitaly Kuzmichev wrote:
>> Hi Russell,
>>
>> On 07/07/2011 04:39 PM, Russell King - ARM Linux wrote:
>>> On Thu, Jul 07, 2011 at 04:23:13PM +0400, Vitaly Kuzmichev wrote:
>>>> To get hundredths of MHz the rate needs to be divided by 10'000.
>>>> Here is an example:
>>>>  twd_timer_rate = 123456789
>>>>  Before the patch:
>>>>     twd_timer_rate / 1000000 = 123
>>>>     (twd_timer_rate / 1000000) % 100 = 23
>>>>     Result: 123.23MHz.
>>>>  After being fixed:
>>>>     twd_timer_rate / 1000000 = 123
>>>>     (twd_timer_rate / 10000) % 100 = 45
>>>>     Result: 123.45MHz.
>>>>
>>>> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
>>>
>>> -> patch system please.
>>
>> Should I submit other patches into this system too?
> 
> No, the other patches I've yet to look at, and I think there's issues
> still to be resolved.
> 
> Eg, ISTR a patch to make smp_twd.c selectable on non-SMP platforms so
> that the mpcore watchdog can be used on non-SMP platforms.  While that
> fixes the build issues, functionally its broken.  I don't think that
> the mpcore watchdog should be asking the smp_twd code in any case for
> the clock rate.

I'm guessing that you mean here both cases when non-SMP kernel runs on
multi-core and on single-core (I'm not sure whether they really exist)
MPCore CPUs, do you? I think in both these cases TWD timer(s) should
always be presented in MPCore. So it is wrong to call this timer as
SMP_TWD and make it dependent on CONFIG_SMP, isn't it?

I just mean, probably the fact that mpcore_wdt depends on swp_twd is not
a real issue, and my patch is correct, but does not fix everything. In
this case it's better than nothing, better than watchdog that does not
work properly either on SMP, or on non-SMP platforms.
Note that my patch does not introduce new dependencies, it just relies
on the one that already exists.

As regarding to new clocksource/arm_smp_twd driver, if it can be
compiled for non-SMP kernel/platform the mpcore_wdt will also be able to
do the same (even with only my patch). But in the case of clk interface
mpcore_wdt will be dependent on TWD's clk structure anyway. So I can
think only of one case when it can be fully independent from TWD: having
own calibration loop.

> If we get the issue with knowing the TWD clock rate on ARMs development
> platforms sorted out, then we can provide a struct clk for it, which
> means everyone can finally move to using the clk API to get the mpcore
> watchdog/twd clock rate.

I really like this. And I will be happy if this happens before than I'm
expecting :)
Ok, lets assume that this happened. Can you guarantee that the one who
will fix the mpcore_wdt to use clk interface also will not reuse the
formula that was there before? :)


Thanks,
Vitaly.
