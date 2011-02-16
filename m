Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1BPVvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:51:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19153 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1BPVvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:51:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6259"; a="74850976"
Message-ID: <4D5C46D7.1040903@codeaurora.org>
Date: Wed, 16 Feb 2011 13:51:19 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/21] ARM: tegra: clock: Add shared bus clock type
References: <1297590033-15035-1-git-send-email-ccross@android.com>	<1297590033-15035-13-git-send-email-ccross@android.com>	<4D5C34E0.5000209@codeaurora.org> <AANLkTi=knKY65xaOT85jFidy6Be8K8RT0L1XtGqq_v2V@mail.gmail.com>
In-Reply-To: <AANLkTi=knKY65xaOT85jFidy6Be8K8RT0L1XtGqq_v2V@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 01:01 PM, Colin Cross wrote:
> On Wed, Feb 16, 2011 at 12:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>> What do you do if clk_set_rate() fails? Should you unwind all the state
>> such as the rate and if it's enabled/disabled? Or is it safe to say
>> clk_set_rate() can't fail unless the kernel is buggy in which case why
>> aren't all those return -E* in the set rate functions just BUG_ONs?
>
> In general, clk_set_rate can fail and return an error, but in this
> case the failure may not be directly related to the driver that called
> into tegra_clk_shared_bus_update.  For example, if clk_disable is
> called on a shared clock handle, the rate may drop to the rate
> requested by another shared clock handle.  clk_disable cannot fail, so
> there's nothing that could be done with the return code, and the
> problem was not caused by the driver that called clk_disable, so an
> error would be meaningless.
>
>
> I will modify tegra_clk_shared_bus_update to BUG on a failed
> clk_set_rate,

Yes, currently if there are any errors we can't determine which clock's
vote is causing the error since the rate only takes effect when the
clock is enabled and another clock could have updated their rate while
the list is being iterated over.

The code could be written so that we only call clk_set_rate() on the
parent when the calling clock affects the aggregate rate. That would
allow us to catch errors for the clk_enable() path and the
clk_set_rate() path when the clock is already on. In the clk_disable()
path we could just ignore the errors since we can't do anything anyways
like you say. The only path that doesn't seem possible is clk_set_rate()
when the clock is off which presumably doesn't actually matter since
when you turn the clock on it will fail the same way (delayed
clk_set_rate?).

BTW, is there a race there in the rate updating code? Say clock 1 is
enabled with rate 2 on cpu1 and clock 2 is enabled at the same time with
rate 3 (currently the greatest rate) on cpu2. clock 1 is iterating over
the list and sees that clock 2 is enabled so it calculates 3 as the max.
clock 2 then returns from the enable call and then a call to disable
clock 2 comes in. clock 1 is still iterating over the list and clock 2's
call to disable runs to completion. clock 1 finally stops iterating over
the list and has an aggregated rate of 3 (since it saw that clock 2 was
on which is no longer true). It then calls set_rate() with 3 even though
the only clock that is on is clock 1 with a rate of 2.

c1 and c2 are off initially

CPU1                    CPU2
----                    -----
clk_set_rate(c1, 2)     clk_set_rate(c2, 3)
clk_enable(c1)          clk_enable(c2)
max == 3                max == 3; clk_set_rate(parent, 3)
...                     clk_disable(c2)
                        max == 2; clk_set_rate(parent, 2)
clk_set_rate(parent, 3)

I think you need some kind of lock while iterating to stop the shared
clocks from changing underneath you.

> and modify tegra_clk_shared_bus_set_rate to
> call clk_round_rate on the parent to ensure that the requested rate is valid.
>

I would hope clk_round_rate() isn't necessary to get a valid rate.
clk_set_rate() shouldn't require exact/valid rates. clk_round_rate() is
there to help drivers determine if calling clk_set_rate() with a certain
rate is going to give them something they want. It's like saying "If I
call clk_set_rate() with 500Hz what would the clock's rate actually be
after the call returns?" If the set_rate implementation needs to round
internally to find a divider or something, it should be done in the
set_rate code and not in each driver.

>>
>> Shouldn't you call clk_enable(c->parent)? And do you need to check for
>> errors from clk_enable()?
>
> clk_enable on the parent is handled by the clock op implementation in
> mach-tegra/clock.c
>

Oops, thanks. Time to visit the optometrist.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

