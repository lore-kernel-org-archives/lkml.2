Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2C1RJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:09:21 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57904 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab2C1RJT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F728050.9030904@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net>
 <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org>
 <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
 <4F6946AA.4070201@codeaurora.org> <4F6CEC0C.4060704@codeaurora.org>
 <CAJOA=zNDKesFtuRgv+6brmBvmbQQecKEOJ89EiG-+YzXVTosWw@mail.gmail.com>
 <4F6CF555.4080109@codeaurora.org> <CAJOA=zOnR1NwZ1Cmkfb+b7f7=N_vg+txAUqKXF2Nf2nVYFMjjg@mail.gmail.com>
 <4F6D0167.3040704@codeaurora.org> <CAJOA=zM47mB8tY2hV1QDVm1GZRqQrjrktkbLQ-Vp7hBjA8H5xg@mail.gmail.com>
 <4F728050.9030904@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 28 Mar 2012 10:08:56 -0700
Message-ID: <CAJOA=zM0_czNzdqXfJDn8vzfpVLywBvYTg3SxKs6BHUOsRNd9w@mail.gmail.com>
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

On Tue, Mar 27, 2012 at 8:06 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 03/23/2012 04:28 PM, Turquette, Mike wrote:
>> On Fri, Mar 23, 2012 at 4:04 PM, Saravana Kannan<skannan@codeaurora.org>
>>  wrote:
>>> On 03/23/2012 03:32 PM, Turquette, Mike wrote:
>>> How does a child (or grand child) clock (not a driver using the clock)
>>> reject a rate change if it know it can't handle that freq from the
>>> parent? I
>>> won't claim to know this part of the code thoroughly, but I can't find an
>>> easy way to do this.
>>
>>
>> Technically you could subscribe a notifier to your grand-child clock,
>> even if there is no driver for it.  The same code that implements your
>> platform's clock operations could register the notifier handler.
>
>>
>>
>> You can see how this works in clk_propagate_rate_change.  That usage
>> is certainly targeted more at drivers but could be made to work for
>> your case.  Let me know what you think; this is an interesting issue.
>
>
> I think notifications should be left to drivers. Notifications are too heavy
> handed for enforcing requirements of the clock tree.

Agreed.  I'm working on a "clock dependency" design at the moment,
which should hopefully answer your question.

> Also, clk_hw to clk
> might no longer be a 1-1 mapping in the future. It's quite possible that
> each clk_get() would get a different struct clk based on the caller to keep
> track of their constraints separately. So, clock drivers shouldn't ever use
> them to identify a clock.

I'm also working on this same thing!  Lots to keep me busy these days.

snip

> I think there is still a problem with not being able to differentiate
> between pre-change recalc and post-change recalc. This applies for any set
> parent and set rate on a clock that has children.
>
> Consider this simple example:
> * Divider clock B is fed from clock A.
> * Clock B can never output > 120 MHz due to downstream
>  HW/clock limitations.
> * Clock A is running at 200 MHz
> * Clock B divider is set to 2.
>
> Now, say the rate of clock A is changing from 200 MHz to 300 MHz (due to set
> rate or set parent). In this case, the clock B divider should be set to 3
> pre-rate change to guarantee that the output of clock B is never > 120 MHz.
> So the rate of clock B will go from 100 MHz (200/2) to 66 MHz (200/3) to 100
> MHz (300/3) and everything is good.
>
> Assume we somehow managed to do the above. So, now clock A is at 300 MHz,
> clock B divider is at 3 and the clock B output is 100 MHz.
>
> Now, say the rate of clock A changes from 300 MHz to 100 MHz. In this case
> the clock B divider should only be changed post rate change. If we do it pre
> rate change, then the output will go from 100 MHz (300/3) to 150 MHz (300/1)
> to 100 MHz (100/1). We went past the 120 MHz limit of clock B's output rate.
>
> If we do this post rate change, we can do this without exceeding the max
> output limit of clock B. It will go from 100 MHz (300/3) to 33 MHz (100/3)
> to 100 MHz (100/1). We never went past the 120 MHz limit.
>
> So, at least for this reason above, I think we need to pass a pre/post
> parameter to the recalc ops.
>
> While we are at it, we should probably just add a failure option for recalc
> to make it easy to reject unacceptable rate changes. To keep the clock
> framework code simpler, you could decide to allow errors only for the
> pre-change recalc calls. That way, the error case roll back code won't be
> crazy.

recalc is too late to catch this.  I think you mean round_rate.  We
want to determine which rate changes are out-of-spec during
clk_calc_new_rates (for clk_set_rate) which involves round_rate being
a bit smarter about what it can and cannot do.

Anyways I'm looking at ways to do this in my clk-dependencies branch.

Regards,
Mike
