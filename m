Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab2CWX2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:28:40 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51819 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab2CWX2i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F6D0167.3040704@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net>
 <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org>
 <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
 <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org>
 <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com>
 <4F6CF555.4080109@codeaurora.org> <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
 <4F6D0167.3040704@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 23 Mar 2012 16:28:16 -0700
Message-ID: <CAJOA=zM47mB8tY2hV1QDVm1GZRqQrjrktkbLQ-Vp7hBjA8H5xg@mail.gmail.com>
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

On Fri, Mar 23, 2012 at 4:04 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 03/23/2012 03:32 PM, Turquette, Mike wrote:
>> .recalc_rate serves two purposes: first it recalculates the rate after
>> the rate has changed and you pass in a new parent_rate argument.  The
>> second purpose is to "speculate" a rate change.  You can pass in any
>> rate for the parent_rate parameter when you call .recalc_rates.  This
>> is what __speculate_rates does before the rate changes.  For
>> clk_set_parent we call,
>>
>> __clk_speculate_rates(clk, parent->rate);
>>
>> Where parent above is the *new* parent.  So this will let us propagate
>> pre-rate change notifiers with the new rate.
>>
>> Your .recalc_rate callback doesn't need to differentiate between the
>> two calls to .recalc_rate.  It should just take in the parent_rate
>> value and do the calculation required of it.
>
> Yeah, this is generally true. But, in this specific case, the clock is a mux
> that can literally measure the real rate. I would like the rate of this mux
> clock to be the real measured rate and not just the parent rate.

That's pretty cool hardware.  Do you find that software-only tracking
doesn't match up with sampling the frequency in hardware?  If software
tracking of the rate changes is correct then you could just skip using
this hardware feature.

> I could actually measure the current rate and return that for recalc_rate(),
> but then the reported rate change during the pre-change notification would
> be wrong. Having the "msg" will let us at least fake the rate correctly for
> pre change notifiers.

In previous series I had separate .recalc_rate and .speculate_rate
callbacks.  I merged them since they were almost identical.  I'd
prefer not to reintroduce them since it creates a burden on others to
support seperate callbacks, and passing in the message is one way to
solve that... I'll think on this a bit more.

> How does a child (or grand child) clock (not a driver using the clock)
> reject a rate change if it know it can't handle that freq from the parent? I
> won't claim to know this part of the code thoroughly, but I can't find an
> easy way to do this.

Technically you could subscribe a notifier to your grand-child clock,
even if there is no driver for it.  The same code that implements your
platform's clock operations could register the notifier handler.

You can see how this works in clk_propagate_rate_change.  That usage
is certainly targeted more at drivers but could be made to work for
your case.  Let me know what you think; this is an interesting issue.

> Reason for rejection could be things like the counter (for division, etc)
> has an upper limit on how fast it can run.

Are you hitting this in practice today?  The clock framework shouldn't
be a perfect piece of code that can validate every possible
combination imaginable.  Some burden falls on the code calling the clk
api (especially if that code is platform code) to make sure that it
doesn't do stupid things.

>>> Also, I noticed that clk_set_parent() is treating a NULL as an invalid
>>> clock. Should that be fixed? set_parent(NULL) could be treated as a
>>> grounding the clock. Should we let the ops->set_parent determine if NULL
>>> is
>>> valid option?
>>
>>
>> We must be looking at different code.  clk_set_parent doesn't return
>> any error if parent == NULL.  Bringing this to my attention does show
>> that we do deref the parent pointer without a check though...
>>
>> Do you have a real use case for this?  Due to the way that we match
>> the parent pointer with the cached clk->parents member it would be
>> painful to support NULL parents as valid.
>
> I don't have a real use case for MSM. We just have a ground_clock.

I'm electing to ignore the issue until we have a real use-case for it.

Regards,
Mike
