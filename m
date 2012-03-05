Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2CEAMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:12:48 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:33394 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab2CEAMr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:12:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.213.21.211 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <20120304115201.GB26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com> <20120304115201.GB26882@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 4 Mar 2012 16:12:21 -0800
Message-ID: <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
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

On Sun, Mar 4, 2012 at 3:52 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Mar 03, 2012 at 09:14:43AM -0800, Turquette, Mike wrote:
>> On Sat, Mar 3, 2012 at 5:31 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Sat, Mar 03, 2012 at 12:29:00AM -0800, Mike Turquette wrote:
>> >> The common clock framework defines a common struct clk useful across
>> >> most platforms as well as an implementation of the clk api that drivers
>> >> can use safely for managing clocks.
>> >>
>> >> The net result is consolidation of many different struct clk definitions
>> >> and platform-specific clock framework implementations.
>> >>
>> >> This patch introduces the common struct clk, struct clk_ops and an
>> >> implementation of the well-known clock api in include/clk/clk.h.
>> >> Platforms may define their own hardware-specific clock structure and
>> >> their own clock operation callbacks, so long as it wraps an instance of
>> >> struct clk_hw.
>> >>
>> >> See Documentation/clk.txt for more details.
>> >>
>> >> This patch is based on the work of Jeremy Kerr, which in turn was based
>> >> on the work of Ben Herrenschmidt.
>> >>
>> >> +
>> >> +/**
>> >> + * struct clk_hw - handle for traversing from a struct clk to its corresponding
>> >> + * hardware-specific structure.  struct clk_hw should be declared within struct
>> >> + * clk_foo and then referenced by the struct clk instance that uses struct
>> >> + * clk_foo's clk_ops
>> >> + *
>> >> + * clk: pointer to the struct clk instance that points back to this struct
>> >> + * clk_hw instance
>> >> + */
>> >> +struct clk_hw {
>> >> +     struct clk *clk;
>> >> +};
>> >
>> > The reason for doing this is that struct clk should be an opaque cookie
>> > for both drivers and implementers of clocks. I recently had the idea whether
>> > the roles of these two structs could be swapped. So instead of the above we
>> > could do:
>> >
>> > struct clk {
>> >        struct clk_hw *hw;
>> > }
>>
>> Firstly, struct clk is an opaque cookie for both drivers and
>> implementers of clocks with this patchset.
>>
>> Secondly, struct clk does indeed have a pointer to struct clk_hw.
>> Refer to include/linux/clk-private.h in this patch.
>>
>> The reference is cyclical.  A reference to struct clk can navigate to
>> struct clk_foo via container_of (usually something like "#define
>> to_clk_foo(_hw) container_of(_hw, struct clk_foo, hw)" where struct
>> clk's pointer to it's .hw member is passed into one of the struct
>> clk_ops callbacks.
>>
>> Likewise if struct clk_foo needs the struct clk ptr for any reason
>> then it can get it from foo->hw->clk.
>>
>> I believe this patch already does what you suggest, but I might be
>> missing your point.
>
> In include/linux/clk-private.h you expose struct clk outside the core.
> This has to be done to make static initializers possible. There is a big
> warning in this file that it must not be included from files implementing
> struct clk_ops. You can simply avoid this warning by declaring struct clk
> with only a single member:
>
> include/linux/clk.h:
>
> struct clk {
>        struct clk_internal *internal;
> };
>
> This way everybody knows struct clk (thus can embed it in their static
> initializers), but doesn't know anything about the internal members. Now
> in drivers/clk/clk.c you declare struct clk_internal exactly like struct
> clk was declared before:
>
> struct clk_internal {
>        const char              *name;
>        const struct clk_ops    *ops;
>        struct clk_hw           *hw;
>        struct clk              *parent;
>        char                    **parent_names;
>        struct clk              **parents;
>        u8                      num_parents;
>        unsigned long           rate;
>        unsigned long           flags;
>        unsigned int            enable_count;
>        unsigned int            prepare_count;
>        struct hlist_head       children;
>        struct hlist_node       child_node;
>        unsigned int            notifier_count;
> #ifdef CONFIG_COMMON_CLK_DEBUG
>        struct dentry           *dentry;
> #endif
> };
>
> An instance of struct clk_internal will be allocated in
> __clk_init/clk_register. Now the private data stays completely inside
> the core and noone can abuse it.

Hi Sascha,

I see the disconnect here.  For OMAP (and possibly other platforms) at
least some clock data is necessary during early boot, before the
regular allocation methods are available (timers for instance).  Due
to this my idea of static initialization was to take care of
everything that would normally require an allocator, which includes
the internals of struct clk; thus exposing struct clk is useful here
as you can still use the clock framework during very early boot.  Your
method above doesn't satisfy this requirement.  I'm not sure what the
purpose would be of statically allocating your version of struct clk,
which will ultimately need to allocate memory for the clock internals
anyways.  Can you elaborate the benefit of this approach over just
using the clk_foo_register functions?

Note that struct clk is still declared in clk.h (and clk-provider.h),
so platforms that have struct clk *clk declarations won't have a
problem.

Thanks much,
Mike

>
> With this __clk_init could be something like:
>
> struct clk_initializer {
>        const char              *name;
>        const struct clk_ops    *ops;
>        char                    **parent_names;
>        u8                      num_parents;
>        unsigned long           flags;
>        struct clk              *clk;
> };
>
> void __clk_init(struct device *dev, struct clk_initializer *init);
>
> I hope I made my intention a bit clearer.
>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
