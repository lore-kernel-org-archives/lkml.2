Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2CEUEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:04:00 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49164 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455Ab2CEUD7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:03:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.14.125.4 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <20120305073836.GU3852@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
 <20120304115201.GB26882@pengutronix.de> <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
 <20120305073836.GU3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 5 Mar 2012 12:03:15 -0800
Message-ID: <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Paul Walmsley <paul@pwsan.com>,
        linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 11:38 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sun, Mar 04, 2012 at 04:12:21PM -0800, Turquette, Mike wrote:
>> >>
>> >> I believe this patch already does what you suggest, but I might be
>> >> missing your point.
>> >
>> > In include/linux/clk-private.h you expose struct clk outside the core.
>> > This has to be done to make static initializers possible. There is a big
>> > warning in this file that it must not be included from files implementing
>> > struct clk_ops. You can simply avoid this warning by declaring struct clk
>> > with only a single member:
>> >
>> > include/linux/clk.h:
>> >
>> > struct clk {
>> >        struct clk_internal *internal;
>> > };
>> >
>> > This way everybody knows struct clk (thus can embed it in their static
>> > initializers), but doesn't know anything about the internal members. Now
>> > in drivers/clk/clk.c you declare struct clk_internal exactly like struct
>> > clk was declared before:
>> >
>> > struct clk_internal {
>> >        const char              *name;
>> >        const struct clk_ops    *ops;
>> >        struct clk_hw           *hw;
>> >        struct clk              *parent;
>> >        char                    **parent_names;
>> >        struct clk              **parents;
>> >        u8                      num_parents;
>> >        unsigned long           rate;
>> >        unsigned long           flags;
>> >        unsigned int            enable_count;
>> >        unsigned int            prepare_count;
>> >        struct hlist_head       children;
>> >        struct hlist_node       child_node;
>> >        unsigned int            notifier_count;
>> > #ifdef CONFIG_COMMON_CLK_DEBUG
>> >        struct dentry           *dentry;
>> > #endif
>> > };
>> >
>> > An instance of struct clk_internal will be allocated in
>> > __clk_init/clk_register. Now the private data stays completely inside
>> > the core and noone can abuse it.
>>
>> Hi Sascha,
>>
>> I see the disconnect here.  For OMAP (and possibly other platforms) at
>> least some clock data is necessary during early boot, before the
>> regular allocation methods are available (timers for instance).
>
> We had this problem on i.MX aswell. It turned out that the timer clock
> is the only clock that is needed so early. We solved this by moving the
> clock init to the system timer init function.

When you say "mov[ed] the clock init to the system timer init
function" do you mean that you statically allocated struct clk and
used the clk framework api, or instead you just did some direct
register writes to initialize things properly?

>
>> Due
>> to this my idea of static initialization was to take care of
>> everything that would normally require an allocator, which includes
>> the internals of struct clk; thus exposing struct clk is useful here
>> as you can still use the clock framework during very early boot.  Your
>> method above doesn't satisfy this requirement.  I'm not sure what the
>> purpose would be of statically allocating your version of struct clk,
>> which will ultimately need to allocate memory for the clock internals
>> anyways.  Can you elaborate the benefit of this approach over just
>> using the clk_foo_register functions?
>
> As said the benefit is that you do not have to expose the internal
> layout of struct clk outside the clock framework. Note that in the

That is a benefit for sure, but if it does not solve the problem of
allowing for static allocation then we still have an issue.

> file you referenced here:
>
> http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/clock44xx_data.c;h=7f833a7b2dca84a52c2bd1e7c8d9cfe560771258;hb=v3.3-rc5-clkv5-omap#l205
>
> You violate what you have in a comment above clk-private.h:
>
> /* __clk_init is only exposed via clk-private.h and is intended for use with
>  * very large numbers of clocks that need to be statically initialized. It is
>  * a layering violation to include clk-private.h from any code which implements
>  * a clock's .ops; as such any statically initialized clock data MUST be in
>  * separate C file from the logic that implements it's operations.
>  */
>
> Well, the file is work in progress, you probably fix this before sending
> it out, but I bet people will include clk-private.h and nobody else
> notices it.

clock44xx_data.c does not violate that rule.  None of the logic that
implements ops for those clocks is present clock44xx_data.c.  All of
the code in that file is simply initialization and registration of
OMAP4 clocks.  Many of the clocks are basic clock types (divider,
multiplexer and fixed-rate are used in that file) with protected code
drivers/clk/clk-*.c and the remaining clocks are of the struct
clk_hw_omap variety, which has code spread across several files:

arch/arm/mach-omap2/clock.c
arch/arm/mach-omap2/clock.h
arch/arm/mach-omap2/clkt_dpll.c
arch/arm/mach-omap2/clkt_clksel.c
arch/arm/mach-omap2/dpll3xxx.c
arch/arm/mach-omap2/dpll4xxx.c

All of the above files include linux/clk-provider.h, not
linux/clk-private.h.  That code makes heavy use of the
__clk_get_whatever helpers and shows how a platform might honor the
layer of separation between struct clk and stuct clk_ops/struct
clk_foo.  You are correct that the code is a work-in-progress, but
there are no layering violations that I can see.

I also think we are talking past each other to some degree.  One point
I would like to make (and maybe you already know this from code
review) is that it is unnecessary to have pointers to your parent
struct clk*'s when either initializing or registering your clocks.  In
fact the existing clk_register_foo functions don't even allow you to
pass in parent pointers and rely wholly on string name matching.  I
just wanted to point that out in case it went unnoticed, as it is a
new way of doing things from the previous series and was born out of
Thomas' review of V4 and multi-parent handling.  This also keeps
device-tree in mind where we might not know the struct clk *pointer at
compile time for "connecting" discrete devices.

Thanks,
Mike

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
