Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2C1DG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:06:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11659 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2C1DG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:06:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="174116612"
Message-ID: <4F728050.9030904@codeaurora.org>
Date: Tue, 27 Mar 2012 20:06:56 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net> <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org> <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com> <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org> <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com> <4F6CF555.4080109@codeaurora.org> <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com> <4F6D0167.3040704@codeaurora.org> <CAJOA=zM47mB8tY2hV1QDVm1GZRqQrjrktkbLQ-Vp7hBjA8H5xg@mail.gmail.com>
In-Reply-To: <CAJOA=zM47mB8tY2hV1QDVm1GZRqQrjrktkbLQ-Vp7hBjA8H5xg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 04:28 PM, Turquette, Mike wrote:
> On Fri, Mar 23, 2012 at 4:04 PM, Saravana Kannan<skannan@codeaurora.org>  wrote:
>> On 03/23/2012 03:32 PM, Turquette, Mike wrote:
>>> .recalc_rate serves two purposes: first it recalculates the rate after
>>> the rate has changed and you pass in a new parent_rate argument.  The
>>> second purpose is to "speculate" a rate change.  You can pass in any
>>> rate for the parent_rate parameter when you call .recalc_rates.  This
>>> is what __speculate_rates does before the rate changes.  For
>>> clk_set_parent we call,
>>>
>>> __clk_speculate_rates(clk, parent->rate);
>>>
>>> Where parent above is the *new* parent.  So this will let us propagate
>>> pre-rate change notifiers with the new rate.
>>>
>>> Your .recalc_rate callback doesn't need to differentiate between the
>>> two calls to .recalc_rate.  It should just take in the parent_rate
>>> value and do the calculation required of it.
>>
>> Yeah, this is generally true. But, in this specific case, the clock is a mux
>> that can literally measure the real rate. I would like the rate of this mux
>> clock to be the real measured rate and not just the parent rate.
>
> That's pretty cool hardware.  Do you find that software-only tracking
> doesn't match up with sampling the frequency in hardware?  If software
> tracking of the rate changes is correct then you could just skip using
> this hardware feature.

We use this HW for automated testing of the SW. It's very handy. So, I 
definitely need to support it.

>> I could actually measure the current rate and return that for recalc_rate(),
>> but then the reported rate change during the pre-change notification would
>> be wrong. Having the "msg" will let us at least fake the rate correctly for
>> pre change notifiers.
>
> In previous series I had separate .recalc_rate and .speculate_rate
> callbacks.  I merged them since they were almost identical.  I'd
> prefer not to reintroduce them since it creates a burden on others to
> support seperate callbacks, and passing in the message is one way to
> solve that... I'll think on this a bit more.

For this specific clock, I don't think anyone is really going to care if 
the pre rate change notification is correct. So, I will just go with 
reporting the wrong rate during pre-change for now.

But it does increase the total testing time quite a bit as I have to 
measure the real rate during pre and post change and measurement is 
relatively slow. It actually does add up into minutes when the whole 
test suite is run. So, would be nice to have this fixed eventually but 
it's not urgent for this measure clock.

>> How does a child (or grand child) clock (not a driver using the clock)
>> reject a rate change if it know it can't handle that freq from the parent? I
>> won't claim to know this part of the code thoroughly, but I can't find an
>> easy way to do this.
>
> Technically you could subscribe a notifier to your grand-child clock,
> even if there is no driver for it.  The same code that implements your
> platform's clock operations could register the notifier handler.
 >
> You can see how this works in clk_propagate_rate_change.  That usage
> is certainly targeted more at drivers but could be made to work for
> your case.  Let me know what you think; this is an interesting issue.

I think notifications should be left to drivers. Notifications are too 
heavy handed for enforcing requirements of the clock tree. Also, clk_hw 
to clk might no longer be a 1-1 mapping in the future. It's quite 
possible that each clk_get() would get a different struct clk based on 
the caller to keep track of their constraints separately. So, clock 
drivers shouldn't ever use them to identify a clock.

>> Reason for rejection could be things like the counter (for division, etc)
>> has an upper limit on how fast it can run.
>
> Are you hitting this in practice today?

Such HW limitations are real. But we don't use clk_set_parent() in our 
drivers often.

> The clock framework shouldn't
> be a perfect piece of code that can validate every possible
> combination imaginable.  Some burden falls on the code calling the clk
> api (especially if that code is platform code) to make sure that it
> doesn't do stupid things.

We can't expect a normal driver to know that the clk_set_parent() 
shouldn't be called when the parent is at a particular rate since there 
are clock HW limitations. The clock framework doesn't need to validate 
everything, but it should give the clock driver the option of rejecting 
invalid requests.

Btw, I think this earlier comment from me is wrong.
 > Nevermind, my brain isn't working today. I can just do that different
 > ordering in ops->set_parent().

I think there is still a problem with not being able to differentiate 
between pre-change recalc and post-change recalc. This applies for any 
set parent and set rate on a clock that has children.

Consider this simple example:
* Divider clock B is fed from clock A.
* Clock B can never output > 120 MHz due to downstream
   HW/clock limitations.
* Clock A is running at 200 MHz
* Clock B divider is set to 2.

Now, say the rate of clock A is changing from 200 MHz to 300 MHz (due to 
set rate or set parent). In this case, the clock B divider should be set 
to 3 pre-rate change to guarantee that the output of clock B is never > 
120 MHz. So the rate of clock B will go from 100 MHz (200/2) to 66 MHz 
(200/3) to 100 MHz (300/3) and everything is good.

Assume we somehow managed to do the above. So, now clock A is at 300 
MHz, clock B divider is at 3 and the clock B output is 100 MHz.

Now, say the rate of clock A changes from 300 MHz to 100 MHz. In this 
case the clock B divider should only be changed post rate change. If we 
do it pre rate change, then the output will go from 100 MHz (300/3) to 
150 MHz (300/1) to 100 MHz (100/1). We went past the 120 MHz limit of 
clock B's output rate.

If we do this post rate change, we can do this without exceeding the max 
output limit of clock B. It will go from 100 MHz (300/3) to 33 MHz 
(100/3) to 100 MHz (100/1). We never went past the 120 MHz limit.

So, at least for this reason above, I think we need to pass a pre/post 
parameter to the recalc ops.

While we are at it, we should probably just add a failure option for 
recalc to make it easy to reject unacceptable rate changes. To keep the 
clock framework code simpler, you could decide to allow errors only for 
the pre-change recalc calls. That way, the error case roll back code 
won't be crazy.

>>> Do you have a real use case for this?  Due to the way that we match
>>> the parent pointer with the cached clk->parents member it would be
>>> painful to support NULL parents as valid.
>>
>> I don't have a real use case for MSM. We just have a ground_clock.
>
> I'm electing to ignore the issue until we have a real use-case for it.

Sounds reasonable.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
