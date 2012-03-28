Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2C1Xtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:49:39 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49259 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758755Ab2C1Xtg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <4F738FEA.9020109@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net>
 <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org>
 <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
 <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org>
 <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com>
 <4F6CF555.4080109@codeaurora.org> <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
 <4F6D0167.3040704@codeaurora.org> <CAJOA=zM47mB8tY2hV1QDVm1GZRqQrjrktkbLQ-Vp7hBjA8H5xg@mail.gmail.com>
 <4F728050.9030904@codeaurora.org> <CAJOA=zM0_czNzdqXfJDn8vzfpVLywBvYTg3SxKs6BHUOsRNd9w@mail.gmail.com>
 <4F738FEA.9020109@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 28 Mar 2012 16:49:13 -0700
Message-ID: <CAJOA=zNd=JTByP+yfXJpZrAb1cswo+XD0F4vzrhOsOoROPT8sQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:25 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 03/28/2012 10:08 AM, Turquette, Mike wrote:
>> On Tue, Mar 27, 2012 at 8:06 PM, Saravana Kannan<skannan@codeaurora.org>
>>  wrote:
>>> I think there is still a problem with not being able to differentiate
>>> between pre-change recalc and post-change recalc. This applies for any
>>> set
>>> parent and set rate on a clock that has children.
>>>
>>> Consider this simple example:
>>> * Divider clock B is fed from clock A.
>>> * Clock B can never output>  120 MHz due to downstream
>>>  HW/clock limitations.
>>> * Clock A is running at 200 MHz
>>> * Clock B divider is set to 2.
>>>
>>> Now, say the rate of clock A is changing from 200 MHz to 300 MHz (due to
>>> set
>>> rate or set parent). In this case, the clock B divider should be set to 3
>>> pre-rate change to guarantee that the output of clock B is never>  120
>>> MHz.
>>> So the rate of clock B will go from 100 MHz (200/2) to 66 MHz (200/3) to
>>> 100
>>> MHz (300/3) and everything is good.
>>>
>>> Assume we somehow managed to do the above. So, now clock A is at 300 MHz,
>>> clock B divider is at 3 and the clock B output is 100 MHz.
>>>
>>> Now, say the rate of clock A changes from 300 MHz to 100 MHz. In this
>>> case
>>> the clock B divider should only be changed post rate change. If we do it
>>> pre
>>> rate change, then the output will go from 100 MHz (300/3) to 150 MHz
>>> (300/1)
>>> to 100 MHz (100/1). We went past the 120 MHz limit of clock B's output
>>> rate.
>>>
>>> If we do this post rate change, we can do this without exceeding the max
>>> output limit of clock B. It will go from 100 MHz (300/3) to 33 MHz
>>> (100/3)
>>> to 100 MHz (100/1). We never went past the 120 MHz limit.
>>>
>>> So, at least for this reason above, I think we need to pass a pre/post
>>> parameter to the recalc ops.
>
> Sorry if I wasn't clear. But the case above is a separate issue from what I
> mention below. What are your thoughts on handling this? Pass "msg" to
> recalc_rates?

I'm OK passing the msg to in .recalc_rates for your hardware which
samples frequency.

>>> While we are at it, we should probably just add a failure option for
>>> recalc
>>> to make it easy to reject unacceptable rate changes. To keep the clock
>>> framework code simpler, you could decide to allow errors only for the
>>> pre-change recalc calls. That way, the error case roll back code won't be
>>> crazy.

We do need a rate validation mechanism, which neither .round_rate or
.recalc_rates provide.  But I don't want to bolt one on right now because
the proper solution to that problem is not a quick fix.  Coupled to
this issue are lingering topics that we've discussed tentatively in
the past:

1) rate ranges (min/max)

2) clock dependencies; these should enforce functional dependencies
between clocks

3) intended rates; this strays into the scary arena of policy, which
has traditionally fallen outside the purview of the clock framework.
But if we want a better clock framework we probably need a way for
downstream clocks to make intelligent decisions about their rates when
parent rates change.  We could overload .round_rate to do this for
clk_set_rate, but that doesn't help out clk_set_parent.  And I'm
against overloading the functionality of these callbacks any more than
I already have.

I'm not sure that just overloading .recalc_rates is the best approach.
 I like that .recalc_rates only recalculates the rate!  For clocks
that need to make an intelligent decision about their rates when
parent rates change we might need to introduce a new callback and/or
refactor the clk_set_rate and clk_set_parent paths to use some common
code.

>> recalc is too late to catch this.  I think you mean round_rate.  We
>> want to determine which rate changes are out-of-spec during
>> clk_calc_new_rates (for clk_set_rate) which involves round_rate being
>> a bit smarter about what it can and cannot do.
>
>
> The case I'm referring to is set_parent(). set_rate() and set_parent() have
> a lot of common implications and it doesn't look like the clock framework is
> handling the common cases the same way for both set_parent() and set_rate().

Agreed that there needs to be some unification here.  Certainly a
common rate validation mechanism is missing and the downstream
notification diverged in the last set of patches.

> It almost feels like set_parent() and set_rate() should just be wrappers
> around some common function that handles most of the work. After all,
> set_parent() is just a slimmed down version of set_rate(). Set rate is just
> a combination of set parent and set divider.

I mostly agree.  A big caveat is that clk_set_parent will never
propagate a request up the tree, but that doesn't mean the
implementation details of the two functions are mutually exclusive.

>> Anyways I'm looking at ways to do this in my clk-dependencies branch.
>>
>
> Are you also looking into the pre/post rate change divider handling case I
> mentioned above?

I'll admit that my initial focus on clk-deps was more along the lines of:

"Clock A wants to go faster, and has a functional dependency to scale
Clock B to a faster rate first"

That sort of situation is often necessary to keep certain timing
requirements valid.  But your example reinforces that clocks need to
have some clue about rate ranges, and it resets my opinion on writing
a clk-dep mechanism which is just focused on raising rates.  The real
solution should be generic and able to handle lowering and NACKing
rates also.

In short: for now I'll just pass the msg into .recalc_rates.  The
other stuff is a design activity which is out-of-scope for the
upcoming -rc bugfix windows.

Regards,
Mike
