Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2CWWdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:33:40 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46228 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271Ab2CWWdU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F6CF555.4080109@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net>
 <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org>
 <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
 <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org>
 <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com> <4F6CF555.4080109@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 23 Mar 2012 15:32:58 -0700
Message-ID: <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
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

On Fri, Mar 23, 2012 at 3:12 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 03/23/2012 02:39 PM, Turquette, Mike wrote:
>> __clk_recalc_rates is called by __clk_reparent which is called by
>> clk_set_parent.  __clk_recalc_rates is also called by clk_set_rate.
>>
>> Does this not handle the old cached clk->rate for you?
>
> For the set_parent case, ops->recalc_rate() is called twice. Once for
> PRE_CHANGE and once for POST_CHANGE. For this clock, I can only really
> recalc the rate during the POST_CHANGE call. So, how should I differentiate
> the two cases?

.recalc_rate serves two purposes: first it recalculates the rate after
the rate has changed and you pass in a new parent_rate argument.  The
second purpose is to "speculate" a rate change.  You can pass in any
rate for the parent_rate parameter when you call .recalc_rates.  This
is what __speculate_rates does before the rate changes.  For
clk_set_parent we call,

__clk_speculate_rates(clk, parent->rate);

Where parent above is the *new* parent.  So this will let us propagate
pre-rate change notifiers with the new rate.

Your .recalc_rate callback doesn't need to differentiate between the
two calls to .recalc_rate.  It should just take in the parent_rate
value and do the calculation required of it.

Take a look at __clk_speculate_rates and __clk_recalc_rates and you'll
see how to use it.

> On a separate note:
> Sorry if I missed any earlier discussion on this, but what's the reason for
> calling recalc_rate() pre-change and post-change but without giving it the
> ability to differentiate between the two?

I think my answer above covers this.  The .recalc_rate callback only
exists to perform a hardware-specific calculation.  The context of
pre- or post-change is irrelevant since the parent_rate passed in
could be the actual rate of the parent or a future rate of the parent.

> I think it's quite useful for recalc_rate to be called pre/post change (some
> steps have to be done pre/post change depending on whether the parent rate
> is increasing or decreasing). But I don't see the "msg" being passed along.

What kind of steps?  Does your .recalc_rate perform these steps?  I
need more details to understand your requirements.

> Also, I noticed that clk_set_parent() is treating a NULL as an invalid
> clock. Should that be fixed? set_parent(NULL) could be treated as a
> grounding the clock. Should we let the ops->set_parent determine if NULL is
> valid option?

We must be looking at different code.  clk_set_parent doesn't return
any error if parent == NULL.  Bringing this to my attention does show
that we do deref the parent pointer without a check though...

Do you have a real use case for this?  Due to the way that we match
the parent pointer with the cached clk->parents member it would be
painful to support NULL parents as valid.

It is also worth considering whether clk_set_parent is really the
correct operation for grounding a clock.  clk_unprepare might be a
better candidate.

Regards,
Mike
