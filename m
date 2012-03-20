Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2CTUGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:06:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60883 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2CTUGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:06:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="174182843"
Message-ID: <4F68E34A.70207@codeaurora.org>
Date: Tue, 20 Mar 2012 13:06:34 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com> <1332214706-675-1-git-send-email-skannan@codeaurora.org> <1332214706-675-2-git-send-email-skannan@codeaurora.org> <20120320072018.GC32469@S2101-09.ap.freescale.net> <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org> <20120320094031.GI3852@pengutronix.de> <20120320141811.GF32469@S2101-09.ap.freescale.net> <20120320181050.GN3852@pengutronix.de>
In-Reply-To: <20120320181050.GN3852@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:10 AM, Sascha Hauer wrote:
> On Tue, Mar 20, 2012 at 10:18:14PM +0800, Shawn Guo wrote:
>> On Tue, Mar 20, 2012 at 10:40:31AM +0100, Sascha Hauer wrote:
>> ...
>>> I am using these functions and don't need a static array, I just call
>>> the functions with the desired parameters.
>>>
>> With this patch getting in, you do not have to use them then.  I feel
>> a static array will be much more readable than a long list of function
>> calls with a long list of hardcoded arguments to each.
>
> I'm also not a fan of long argument lists; a divider like defined in my
> tree takes 5 arguments, a gate 4 and a mux 6. While 6 is already at the
> border I think it's still acceptable.
>
> What I like in terms of readability is one line per clock which makes
> for quite short clock files.

It certainly makes for short clock files, but it's definitely less 
readable that the expanded struct. For the original author the "one line 
per clock" looks readable since they wrote it. But for someone looking 
at the code to modify it, the expanded one would be much easier to read. 
Also, you can always declare your own macro if you really want to follow 
the one line approach.

> So when we use structs to initialize the clocks we'll probably have
> something like this:
>
> static struct clk_divider somediv = {
> 	.reg = CCM_BASE + 0x14,
> 	.width = 3,
> 	.shift = 17,
> 	.lock =&ccm_lock,
> 	.hw.parent = "someotherdiv",
> 	.hw.flags = CLK_SET_RATE_PARENT,
> };

Taken from your patches:

imx_clk_mux("spll_sel", CCM_CSCR, 17, 1, spll_sel_clks, 
ARRAY_SIZE(spll_sel_clks));

Compare the struct to the one line call. Now tell me, what does "1" 
represent? No clue. But in the struct, I can immediately tell what each 
one of the parameters are.

Anyway, my patch certainly isn't forcing you to use multiple lines. So, 
hopefully this won't be a point of contention.

> This will make a 4000 line file out of a 500 line file. Now when for
> some reason struct clk_divider changes we end with big patches. If the
> clk core gets a new fancy CLK_ flag which we want to have then again
> we end up with big patches. Then there's also the possibility that
> someone finds out that .lock and .hw.flags are common to all dividers
> and comes up with a #define DEFINE_CLK_DIVIDER again to share common
> fields.

This patch won't prevent you from doing any of that. You can still 
create macros for that (there are already one for that). Also, what you 
are pointing out is a bigger problem for the current clk_register() 
function since you might have to change the no. of params of all the 
callers even if a new field is optional.

> All this can be solved when we introduce a small wrapper function and
> use it in the clock files:
>
> static inline struct clk *imx_clk_divider(const char *name, const char *parent,
> 		void __iomem *reg, u8 shift, u8 width)
> {
> 	return clk_register_divider(NULL, name, parent, CLK_SET_RATE_PARENT,
> 			reg, shift, width, 0,&imx_ccm_lock);
> }
>
> It decouples us from the structs used by the clock framework, we can
> add our preferred flags and still can share common fields like the lock.
>
> While this was not the intention when I first converted from struct
> initializers to function initializers I am confident that it will make
> a good job.

Now I'm confused -- it's not clear if you are leaning towards my patch 
or away from it?

I also think we are talking about issues orthogonal to my patch. I don't 
think my patch prevents you from doing any of this as long as you are up 
for wrapper fns or macros.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
