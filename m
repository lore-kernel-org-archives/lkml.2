Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2CSTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:09:26 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:39568 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758406Ab2CSTJY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120319112858.GX3852@pengutronix.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <4F6716DD.5090900@ti.com>
 <20120319112858.GX3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 19 Mar 2012 12:09:01 -0700
Message-ID: <CAJOA=zOgHXy1_J+LG1LUWwsESwrtqAvrgHKUR22AJdsbRHa+YA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rajendra Nayak <rnayak@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 4:28 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Mar 19, 2012 at 04:52:05PM +0530, Rajendra Nayak wrote:
>> Hi Mike,
>>
>> >+/*
>> >+ * calculate the new rates returning the topmost clock that has to be
>> >+ * changed.
>> >+ */
>> >+static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>> >+{
>> >+    struct clk *top = clk;
>> >+    unsigned long best_parent_rate = clk->parent->rate;
>>
>> Shouldn't you check for a valid parent before dereferencing it? A
>> clk_set_rate() on a root clock might throw up some issues otherwise.
>>
>
> Yes, should be checked.

The clk_calc_new_rates code assumes a valid parent pointer in several
locations.  Thanks for the catch Rajendra.  Will roll into my fixes
series.

>> >+    unsigned long new_rate;
>> >+
>> >+    if (!clk->ops->round_rate&&  !(clk->flags&  CLK_SET_RATE_PARENT)) {
>> >+            clk->new_rate = clk->rate;
>> >+            return NULL;
>>
>> So does this mean a clk_set_rate() fails for a clk which does not have
>> a valid .round_rate and does not have a CLK_SET_RATE_PARENT flag set?
>> I was thinking this could do a..
>>               clk->new_rate = rate;
>>               top = clk;
>>               goto out;
>> ..instead.
>
> The core should make sure that either both set_rate and round_rate are
> present or none of them.

Agreed.  The documentation covers which clk_ops are hard dependencies
(based on supported operations), but the code doesn't strictly check
this.  I'll add a small state machine to __clk_init which validates
that .round_rate, .recalc_rate and .set_rate are *all* present if any
one of them are present, and present a WARN if otherwise.

Thanks,
Mike
