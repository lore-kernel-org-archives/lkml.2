Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966184Ab2EPJT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:19:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65279 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2EPJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:19:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="189120197"
Message-ID: <20357906133225932a45e9cefefac829.squirrel@www.codeaurora.org>
In-Reply-To: <CAJOA=zOjj8AY1Uk7X=1GCGHt-6OUndtwR-e36vdrRmFjhJDynA@mail.gmail.com>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
    <20120515194245.GO30400@pengutronix.de>
    <4FB2B3AA.3010903@codeaurora.org>
    <20120515200040.GP30400@pengutronix.de>
    <4FB2B7DC.4070706@codeaurora.org>
    <CAJOA=zOjj8AY1Uk7X=1GCGHt-6OUndtwR-e36vdrRmFjhJDynA@mail.gmail.com>
Date: Wed, 16 May 2012 02:19:55 -0700 (PDT)
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and 
     clk_enable()
From: skannan@codeaurora.org
To: "Turquette, Mike" <mturquette@ti.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Andrew Lunn" <andrew@lunn.ch>, "Paul Walmsley" <paul@pwsan.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Magnus Damm" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Richard Zhao" <richard.zhao@linaro.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Deepak Saxena" <dsaxena@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Shawn Guo" <shawn.guo@freescale.com>,
        "Amit Kucheria" <amit.kucheria@linaro.org>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Arnd Bergman" <arnd.bergmann@linaro.org>,
        "Jeremy Kerr" <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, May 15, 2012 at 1:09 PM, Saravana Kannan <skannan@codeaurora.org>
> wrote:
>> On 05/15/2012 01:00 PM, Sascha Hauer wrote:
>>>
>>> On Tue, May 15, 2012 at 12:51:06PM -0700, Saravana Kannan wrote:
>>>>>>
>>>>>>        ret = clk->ops->set_parent(clk->hw, i);
>>>>>
>>>>>
>>>>> You call ->set_parent while holding a spinlock. This won't work with
>>>>> i2c
>>>>> clocks.
>>>>
>>>>
>>>> I did account for that. I explained it in the commit text. Please
>>>> let me know if any part of that is not clear or is not correct.
>>>>
>>>
>>> I missed this part in the commit log. I have no idea whether we can
>>> live
>>> with this limitation though.
>>>
>>> Sascha
>>>
>>
>> It's not really an artificial limitation of the patch. This has to be
>> enforced if the clock is to be managed correctly while allowing
>> .set_parent
>> to NOT be atomic.
>>
>> There is no way to guarantee that the enable/disable is properly
>> propagated
>> to the parent clock if we can't guarantee mutual exclusion between
>> changing
>> parents and calling enable/disable.
>>
>
> We know for sure that __clk_enable was propagated since it won't
> return until it is done.  The bigger issue here is the inherent
> prepare_lock/enable_lock raciness, which this patch does not solve.
> Your approach above is like putting a band-aid gunshot wound :-)

No, I'm not trying to fix a race that's purely between prepare and enable.
The operation of updating the HW state (calling .set_parent) and the
operation of updating the SW state (setting clk->parent = new parent) is
not atomic with respect to other code that cares about the HW/SW state
(enable/disable). This would be similar to holding the enable spinlock
around incrementing the enable count but not holding it while calling
.enable on the clock -- that is just plain wrong.

If you still claim that's this is nothing more than prepare/enable race,
then why are we implementing a half-baked enable/disable propagation up
the parents? In it's current state, it's never guaranteed to be correct
for ANY clock. Why give an illusion of correctness? Just don't do it --
that will make the common clock framework less useful, but it's better
than something that pretends to be correct.

Also, just because we pushed the enforcement of correctness between
clk_prepare() and clk_enable() to the end user doesn't mean we should
throw up our arms and push all the correctness enforcement to the end
user. The API should try to limit the amount of burden of correctness that
we put on the end user. The only thing we should avoid is writing code
that's correct for the end user only under some circumstances.

It's relatively easy to implement device driver code that ensures that
enable is only called on a prepared clock (since we have ref counting and
it's just a matter of matching enables with prepares). But it would be
much harder to implement useful and power efficient device driver code
that guarantees that enable/set parent is mutually exclusive. You also
need to keep in mind the comment I made in the original email about set
rates that need reparenting. set parent is just another way of setting the
rate and vice-versa (in many cases). This stance of yours means that any
clock that needs to reparent during a set rate while the clock is enabled
can never be implemented correctly.

A very simple example is a device driver that's trying to do power
management by enabling/disabling clocks in interrupt context and also
scaling the clock based on load on the device. Those drivers will fail
horribly if the set rate needs reparenting.

> What is really needed is a way to synchronize all of
> the clock operations and drop these race conditions. Until that
> problem is solved OR until it is proven impossible to fix with the
> API's given to us I won't be taking this patch.  It is invalid for the
> set of clocks that don't set the CLK_SET_PARENT_GATE flag AND have
> .set_parent callbacks which might sleep.

This is clearly the opposite of the direction we (the community) decided
to go with the design of the clock APIs -- clk_prepare/clk_enable split.
If we need to question that, that should be a separate discussion and not
part of a discussion where we try to fix issues in the implementation of
those APIs. There is not much to prove here either -- you just can't
synchronize between critical sections where some are protected by mutex
and others by spinlocks. Giving this is a reason to not pick up patches
that fix bugs is not well justified. Again, I'm not saying your question
is/isn't justified, just that it's a separate discussion.

> It is invalid for the
> set of clocks that don't set the CLK_SET_PARENT_GATE flag AND have
> .set_parent callbacks which might sleep.

Sure, but how does it affect the decision of whether we need to fix a race
condition? Any clock platform driver that implements this incorrectly can
be easily caught in testing or code review. Every single call to that set
parent is going to spew a warning.

Thanks,
Saravana

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

