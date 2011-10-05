Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab1JEBli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:41:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43878 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1JEBlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:41:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6489"; a="124837652"
Message-ID: <4E8BB5D0.3090508@codeaurora.org>
Date: Tue, 04 Oct 2011 18:41:36 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "Turquette, Mike" <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, paul@pwsan.com,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        patches@linaro.org, broonie@opensource.wolfsonmicro.com,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        eric.miao@linaro.org, linux@arm.linux.org.uk,
        Jamie Iles <jamie@jamieiles.com>, arnd.bergmann@linaro.org,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-5-git-send-email-mturquette@ti.com> <4E80C564.3050004@gmail.com> <20110926184024.GB9194@gallagher> <4E80CE28.9030103@gmail.com> <20110926193733.GC9194@gallagher> <CAJOA=zMA8q-acr=BGWrpC9iLSR3E8Y0ybH4sZ=FOn54zQ7TJKw@mail.gmail.com> <4E810AFA.9040004@gmail.com>
In-Reply-To: <4E810AFA.9040004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 04:30 PM, Rob Herring wrote:
> On 09/26/2011 05:37 PM, Turquette, Mike wrote:
>> On Mon, Sep 26, 2011 at 12:37 PM, Jamie Iles<jamie@jamieiles.com>  wrote:
>>> On Mon, Sep 26, 2011 at 02:10:32PM -0500, Rob Herring wrote:
>>>> On 09/26/2011 01:40 PM, Jamie Iles wrote:
>>>>> On Mon, Sep 26, 2011 at 01:33:08PM -0500, Rob Herring wrote:
>>>>>>> +static void clk_gate_set_bit(struct clk_hw *clk)
>>>>>>> +{
>>>>>>> + struct clk_gate *gate = to_clk_gate(clk);
>>>>>>> + u32 reg;
>>>>>>> +
>>>>>>> + reg = __raw_readl(gate->reg);
>>>>>>> + reg |= BIT(gate->bit_idx);
>>>>>>> + __raw_writel(reg, gate->reg);
>>>>>>
>>>>>> Don't these read-mod-writes need a spinlock around it?
>>>>>>
>>>>>> It's possible to have an enable bits and dividers in the same register.
>>>>>> If you did a set_rate and while doing an enable/disable, there would be
>>>>>> a problem. Also, it may be 2 different clocks in the same register, so
>>>>>> the spinlock needs to be shared and not per clock.
>>>>>
>>>>> Well the prepare lock will be held here and I believe that would be
>>>>> sufficient.
>>>>
>>>> No, the enable spinlock is protecting enable/disable. But set_rate is
>>>> protected by the prepare mutex. So you clearly don't need locking if you
>>>> have a register of only 1 bit enables. If you have a register accessed
>>>> by both enable/disable and prepare/unprepare/set_rate, then you need
>>>> some protection.
>>>
>>> OK fair point, but I would guess that if you had a clock like this then
>>> you probably wouldn't use this simple gated clock would you?  (speaking
>>> from my world where we have quite simple clocks ;-))
>>
>> I think it is a safe assumption that if a register controls both
>> enable/disable and some programmable divider then,
>>
>> 1) those controls are probably for the same clock
>> 2) that clock won't be using the cookie-cutter gated-clock
>> implementation anyways
>
> By definition of simple gated clock, the other bits have to be for
> another clock. The restriction is that all the other bits can only be
> clock gate bits.
>
>>
>> Rob, do you feel these assumptions are OK and locking can remain the
>> same in this patch?
>
> Perhaps it is rare enough that it is not worth it use generic code in
> this case. If so, the documentation should be clear about this
> constraint. It is not something anyone will have hit before because
> everyone used a single global lock. Now with the api being split between
> 2 locks, this adds a new complexity.

I kinda agree with Rob on this. There are very few, if any, such simple 
clocks on MSM chips. It's very easy to a SoC clock developer to 
accidentally use these simple clocks without realizing the point that 
Rob brings up.

> I think the simple gated clock code should be usable for any clock
> controlled by a single bit in a 32-bit register independent of other
> things in that register.

To take care of the scenario Rob bring up, the prepare/unprepare and 
enable/disable code will have to grab a per-tree register-lock before 
accessing any registers. The prepare/unprepare code should obviously be 
written to hold this register-lock for as small of a duration as 
possible. For example, if the prepare code is doing voltage increase, 
the register-lock should be grabber _after_ the voltage is increased. At 
least, this is approximately how the MSM clock code can be mapped onto 
this generic framework.

I think we should just go ahead and implement the per-tree register lock 
so that the generic clock implementations are more useful. The lock will 
really be held only for a very short time and hence shouldn't matter 
that there is a single lock for all the clocks in a tree.

Thomas,

Did you get a chance to send out your patches with support for per-tree 
locking? I would really like to see that as part of the first patch 
series that gets pulled in.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
