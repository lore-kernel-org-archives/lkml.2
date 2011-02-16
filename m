Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1BPWDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:03:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1BPWDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=yxL1KY1anfyEbTGGcTVs/jeYurpKcj2J0+qscqOq2lKixTGTkaUJlNf6flomTA6oE/
         6mjva4XPTKaVJGSHpEMw==
MIME-Version: 1.0
In-Reply-To: <4D5C46D7.1040903@codeaurora.org>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
	<1297590033-15035-13-git-send-email-ccross@android.com>
	<4D5C34E0.5000209@codeaurora.org>
	<AANLkTi=knKY65xaOT85jFidy6Be8K8RT0L1XtGqq_v2V@mail.gmail.com>
	<4D5C46D7.1040903@codeaurora.org>
Date: Wed, 16 Feb 2011 14:03:07 -0800
X-Google-Sender-Auth: 70A-31xlLtYQJ6RM3prsH4sfi54
Message-ID: <AANLkTikFiZ+wVJ5CWG=Lfnexs-YQs29dtyv_1QDuXBYz@mail.gmail.com>
Subject: Re: [PATCH 12/21] ARM: tegra: clock: Add shared bus clock type
From: Colin Cross <ccross@android.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 1:51 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 02/16/2011 01:01 PM, Colin Cross wrote:
>> On Wed, Feb 16, 2011 at 12:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>
>>> What do you do if clk_set_rate() fails? Should you unwind all the state
>>> such as the rate and if it's enabled/disabled? Or is it safe to say
>>> clk_set_rate() can't fail unless the kernel is buggy in which case why
>>> aren't all those return -E* in the set rate functions just BUG_ONs?
>>
>> In general, clk_set_rate can fail and return an error, but in this
>> case the failure may not be directly related to the driver that called
>> into tegra_clk_shared_bus_update.  For example, if clk_disable is
>> called on a shared clock handle, the rate may drop to the rate
>> requested by another shared clock handle.  clk_disable cannot fail, so
>> there's nothing that could be done with the return code, and the
>> problem was not caused by the driver that called clk_disable, so an
>> error would be meaningless.
>>
>>
>> I will modify tegra_clk_shared_bus_update to BUG on a failed
>> clk_set_rate,
>
> Yes, currently if there are any errors we can't determine which clock's
> vote is causing the error since the rate only takes effect when the
> clock is enabled and another clock could have updated their rate while
> the list is being iterated over.
>
> The code could be written so that we only call clk_set_rate() on the
> parent when the calling clock affects the aggregate rate. That would
> allow us to catch errors for the clk_enable() path and the
> clk_set_rate() path when the clock is already on. In the clk_disable()
> path we could just ignore the errors since we can't do anything anyways
> like you say. The only path that doesn't seem possible is clk_set_rate()
> when the clock is off which presumably doesn't actually matter since
> when you turn the clock on it will fail the same way (delayed
> clk_set_rate?).
>
> BTW, is there a race there in the rate updating code? Say clock 1 is
> enabled with rate 2 on cpu1 and clock 2 is enabled at the same time with
> rate 3 (currently the greatest rate) on cpu2. clock 1 is iterating over
> the list and sees that clock 2 is enabled so it calculates 3 as the max.
> clock 2 then returns from the enable call and then a call to disable
> clock 2 comes in. clock 1 is still iterating over the list and clock 2's
> call to disable runs to completion. clock 1 finally stops iterating over
> the list and has an aggregated rate of 3 (since it saw that clock 2 was
> on which is no longer true). It then calls set_rate() with 3 even though
> the only clock that is on is clock 1 with a rate of 2.
>
> c1 and c2 are off initially
>
> CPU1                    CPU2
> ----                    -----
> clk_set_rate(c1, 2)     clk_set_rate(c2, 3)
> clk_enable(c1)          clk_enable(c2)
> max == 3                max == 3; clk_set_rate(parent, 3)
> ...                     clk_disable(c2)
>                        max == 2; clk_set_rate(parent, 2)
> clk_set_rate(parent, 3)
>
> I think you need some kind of lock while iterating to stop the shared
> clocks from changing underneath you.
Yes, it needs a lock.  I missed adding it when I converted from a
global lock to a per-clock lock.  The children should lock the parent
before changing any of their state or calling
tegra_clk_shared_bus_update.

>> and modify tegra_clk_shared_bus_set_rate to
>> call clk_round_rate on the parent to ensure that the requested rate is valid.
>>
>
> I would hope clk_round_rate() isn't necessary to get a valid rate.
> clk_set_rate() shouldn't require exact/valid rates. clk_round_rate() is
> there to help drivers determine if calling clk_set_rate() with a certain
> rate is going to give them something they want. It's like saying "If I
> call clk_set_rate() with 500Hz what would the clock's rate actually be
> after the call returns?" If the set_rate implementation needs to round
> internally to find a divider or something, it should be done in the
> set_rate code and not in each driver.

The point is not to get the valid rate, it is to weed out rates that
will be rejected (not rounded) by clk_set_rate, without affecting the
clock.  If clk_set_rate will return an error, clk_round_rate should
also return an error.

>>>
>>> Shouldn't you call clk_enable(c->parent)? And do you need to check for
>>> errors from clk_enable()?
>>
>> clk_enable on the parent is handled by the clock op implementation in
>> mach-tegra/clock.c
>>
>
> Oops, thanks. Time to visit the optometrist.
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
