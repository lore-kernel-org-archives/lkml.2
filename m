Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2CWXEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:04:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49247 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2CWXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:04:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6658"; a="175327010"
Message-ID: <4F6D0167.3040704@codeaurora.org>
Date: Fri, 23 Mar 2012 16:04:07 -0700
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
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net> <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org> <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com> <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org> <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com> <4F6CF555.4080109@codeaurora.org> <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
In-Reply-To: <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 03:32 PM, Turquette, Mike wrote:
> On Fri, Mar 23, 2012 at 3:12 PM, Saravana Kannan<skannan@codeaurora.org>  wrote:
>> On 03/23/2012 02:39 PM, Turquette, Mike wrote:
>>> __clk_recalc_rates is called by __clk_reparent which is called by
>>> clk_set_parent.  __clk_recalc_rates is also called by clk_set_rate.
>>>
>>> Does this not handle the old cached clk->rate for you?
>>
>> For the set_parent case, ops->recalc_rate() is called twice. Once for
>> PRE_CHANGE and once for POST_CHANGE. For this clock, I can only really
>> recalc the rate during the POST_CHANGE call. So, how should I differentiate
>> the two cases?
>
> .recalc_rate serves two purposes: first it recalculates the rate after
> the rate has changed and you pass in a new parent_rate argument.  The
> second purpose is to "speculate" a rate change.  You can pass in any
> rate for the parent_rate parameter when you call .recalc_rates.  This
> is what __speculate_rates does before the rate changes.  For
> clk_set_parent we call,
>
> __clk_speculate_rates(clk, parent->rate);
>
> Where parent above is the *new* parent.  So this will let us propagate
> pre-rate change notifiers with the new rate.
>
> Your .recalc_rate callback doesn't need to differentiate between the
> two calls to .recalc_rate.  It should just take in the parent_rate
> value and do the calculation required of it.

Yeah, this is generally true. But, in this specific case, the clock is a 
mux that can literally measure the real rate. I would like the rate of 
this mux clock to be the real measured rate and not just the parent rate.

I could actually measure the current rate and return that for 
recalc_rate(), but then the reported rate change during the pre-change 
notification would be wrong. Having the "msg" will let us at least fake 
the rate correctly for pre change notifiers.

>> I think it's quite useful for recalc_rate to be called pre/post change (some
>> steps have to be done pre/post change depending on whether the parent rate
>> is increasing or decreasing). But I don't see the "msg" being passed along.
>
> What kind of steps?  Does your .recalc_rate perform these steps?  I
> need more details to understand your requirements.

Nevermind, my brain isn't working today. I can just do that different 
ordering in ops->set_parent(). But the measure clocks case is still true 
though.

But this did bring up another point in my head. Hopefully this one isn't 
my brain playing tricks again today.

How does a child (or grand child) clock (not a driver using the clock) 
reject a rate change if it know it can't handle that freq from the 
parent? I won't claim to know this part of the code thoroughly, but I 
can't find an easy way to do this.

Reason for rejection could be things like the counter (for division, 
etc) has an upper limit on how fast it can run.

>> Also, I noticed that clk_set_parent() is treating a NULL as an invalid
>> clock. Should that be fixed? set_parent(NULL) could be treated as a
>> grounding the clock. Should we let the ops->set_parent determine if NULL is
>> valid option?
>
> We must be looking at different code.  clk_set_parent doesn't return
> any error if parent == NULL.  Bringing this to my attention does show
> that we do deref the parent pointer without a check though...
>
> Do you have a real use case for this?  Due to the way that we match
> the parent pointer with the cached clk->parents member it would be
> painful to support NULL parents as valid.

I don't have a real use case for MSM. We just have a ground_clock.

> It is also worth considering whether clk_set_parent is really the
> correct operation for grounding a clock.  clk_unprepare might be a
> better candidate.

Yeah, not a real use case for MSM.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
