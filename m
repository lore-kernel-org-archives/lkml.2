Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab2CUBrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:47:36 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35729 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998Ab2CUBre convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120320231242.GP3852@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org> <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net> <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de> <20120320141811.GF32469@S2101-09.ap.freescale.net>
 <20120320181050.GN3852@pengutronix.de> <4F68E34A.70207@codeaurora.org> <20120320231242.GP3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 20 Mar 2012 18:47:08 -0700
Message-ID: <CAJOA=zOGTW7OqACWgJQW6HSPLVev+apdNhv4vNXjHTcp=7N+uQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 4:12 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Mar 20, 2012 at 01:06:34PM -0700, Saravana Kannan wrote:
>> On 03/20/2012 11:10 AM, Sascha Hauer wrote:
>> >On Tue, Mar 20, 2012 at 10:18:14PM +0800, Shawn Guo wrote:
>> >>On Tue, Mar 20, 2012 at 10:40:31AM +0100, Sascha Hauer wrote:
>> >>...
>> >>>I am using these functions and don't need a static array, I just call
>> >>>the functions with the desired parameters.
>> >>>
>> >>With this patch getting in, you do not have to use them then.  I feel
>> >>a static array will be much more readable than a long list of function
>> >>calls with a long list of hardcoded arguments to each.
>> >
>> >I'm also not a fan of long argument lists; a divider like defined in my
>> >tree takes 5 arguments, a gate 4 and a mux 6. While 6 is already at the
>> >border I think it's still acceptable.
>> >
>> >What I like in terms of readability is one line per clock which makes
>> >for quite short clock files.
>>
>> It certainly makes for short clock files, but it's definitely less
>> readable that the expanded struct. For the original author the "one
>> line per clock" looks readable since they wrote it. But for someone
>> looking at the code to modify it, the expanded one would be much
>> easier to read. Also, you can always declare your own macro if you
>> really want to follow the one line approach.
>>
>> >So when we use structs to initialize the clocks we'll probably have
>> >something like this:
>> >
>> >static struct clk_divider somediv = {
>> >     .reg = CCM_BASE + 0x14,
>> >     .width = 3,
>> >     .shift = 17,
>> >     .lock =&ccm_lock,
>> >     .hw.parent = "someotherdiv",
>> >     .hw.flags = CLK_SET_RATE_PARENT,
>> >};
>>
>> Taken from your patches:
>>
>> imx_clk_mux("spll_sel", CCM_CSCR, 17, 1, spll_sel_clks,
>> ARRAY_SIZE(spll_sel_clks));
>>
>> Compare the struct to the one line call. Now tell me, what does "1"
>> represent? No clue. But in the struct, I can immediately tell what
>> each one of the parameters are.
>>
>> Anyway, my patch certainly isn't forcing you to use multiple lines.
>> So, hopefully this won't be a point of contention.
>>
>> >This will make a 4000 line file out of a 500 line file. Now when for
>> >some reason struct clk_divider changes we end with big patches. If the
>> >clk core gets a new fancy CLK_ flag which we want to have then again
>> >we end up with big patches. Then there's also the possibility that
>> >someone finds out that .lock and .hw.flags are common to all dividers
>> >and comes up with a #define DEFINE_CLK_DIVIDER again to share common
>> >fields.
>>
>> This patch won't prevent you from doing any of that. You can still
>> create macros for that (there are already one for that). Also, what
>> you are pointing out is a bigger problem for the current
>> clk_register() function since you might have to change the no. of
>> params of all the callers even if a new field is optional.
>>
>> >All this can be solved when we introduce a small wrapper function and
>> >use it in the clock files:
>> >
>> >static inline struct clk *imx_clk_divider(const char *name, const char *parent,
>> >             void __iomem *reg, u8 shift, u8 width)
>> >{
>> >     return clk_register_divider(NULL, name, parent, CLK_SET_RATE_PARENT,
>> >                     reg, shift, width, 0,&imx_ccm_lock);
>> >}
>> >
>> >It decouples us from the structs used by the clock framework, we can
>> >add our preferred flags and still can share common fields like the lock.
>> >
>> >While this was not the intention when I first converted from struct
>> >initializers to function initializers I am confident that it will make
>> >a good job.
>>
>> Now I'm confused -- it's not clear if you are leaning towards my
>> patch or away from it?
>
> There was a tendency to get rid of static initializers and I like the
> idea of not exposing any of the internally used members outside the
> clock framework.

I'm with Sascha on this.  I feel that dividing the interface strictly
into two halves is the best way.  I have an uneasy feeling about
exposing this stuff into struct clk_hw (or clk_initializer or
whatever).  This stretches the data out across three structures and
just doesn't feel right to me.

> Now people try their best to make themselves comfortable with the
> static initializers and you even discussed the possibility of removing
> the clk_register_* functions (which make it possible for users not
> to use any of the internal struct members). That's what I don't like
> about your patches. But if we go for static initializers anyway then your
> patches probably change things for the better.

Static initialization is something I have fought for; in fact the
original patches provided no way to do it, so clearly what we have
today is some progress for the folks desiring static init.  The patch
above doesn't actually prevent allocation from happening as it still
must call into clk_register and kmalloc struct clk, so besides
readability, I'm not sure what these patches buy us.

Assuming that C99 designated initializers (for the sole purpose of
readability) is the main draw of the above patch, please let me know
what you think about modifying the existing static init macros so that
your clock data looks like this:

DEFINE_CLK_DIVIDER(dpll_iva_m5x2_ck, &dpll_iva_x2_ck, "dpll_iva_x2_ck",
        .flags = 0x0,
        .reg = OMAP4430_CM_DIV_M5_DPLL_IVA,
        .shift = OMAP4430_HSDIVIDER_CLKOUT2_DIV_SHIFT,
        .width = OMAP4430_HSDIVIDER_CLKOUT2_DIV_WIDTH,
        .flags = CLK_DIVIDER_ONE_BASED,
        .lock = NULL
);

Note that the first argument is the name of this clock (and will be
properly stringified for .name = "whatever") and that the second and
third arguments are both the parent clock, used for initializing the
parent pointer and .parent_names, respectively.  If that aspect of the
macro is too ugly then those can even be broken out into a separate
macro since they are independent data structure (struct clk **parents,
and char **parent_names).  Or you could just open code those data
structures and only use a macro for struct clk and struct clk_foo.

This gives you the readability of C99 designated initializers while
keeping struct clk's members totally hidden from the rest of the
world.

Regards,
Mike
