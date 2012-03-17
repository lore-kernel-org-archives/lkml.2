Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2CQDYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 23:24:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11226 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CQDYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 23:24:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6651"; a="173319466"
Message-ID: <4F6403CD.8020509@codeaurora.org>
Date: Fri, 16 Mar 2012 20:23:57 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org> <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120303133158.GA26882@pengutronix.de> <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com> <20120304115201.GB26882@pengutronix.de> <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com> <20120305073836.GU3852@pengutronix.de> <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com> <20120306190039.GJ3852@pengutronix.de> <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
In-Reply-To: <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 01:20 PM, Turquette, Mike wrote:
> On Tue, Mar 6, 2012 at 11:00 AM, Sascha Hauer<s.hauer@pengutronix.de>  wrote:
>> On Mon, Mar 05, 2012 at 12:03:15PM -0800, Turquette, Mike wrote:
>>> On Sun, Mar 4, 2012 at 11:38 PM, Sascha Hauer<s.hauer@pengutronix.de>  wrote:
>>>> On Sun, Mar 04, 2012 at 04:12:21PM -0800, Turquette, Mike wrote:
>>>>>>>
>>>>>>> I believe this patch already does what you suggest, but I might be
>>>>>>> missing your point.
>>>>>>
>>>>>> In include/linux/clk-private.h you expose struct clk outside the core.
>>>>>> This has to be done to make static initializers possible. There is a big
>>>>>> warning in this file that it must not be included from files implementing
>>>>>> struct clk_ops. You can simply avoid this warning by declaring struct clk
>>>>>> with only a single member:
>>>>>>
>>>>>> include/linux/clk.h:
>>>>>>
>>>>>> struct clk {
>>>>>>         struct clk_internal *internal;
>>>>>> };
>>>>>>
>>>>>> This way everybody knows struct clk (thus can embed it in their static
>>>>>> initializers), but doesn't know anything about the internal members. Now
>>>>>> in drivers/clk/clk.c you declare struct clk_internal exactly like struct
>>>>>> clk was declared before:
>>>>>>
>>>>>> struct clk_internal {
>>>>>>         const char              *name;
>>>>>>         const struct clk_ops    *ops;
>>>>>>         struct clk_hw           *hw;
>>>>>>         struct clk              *parent;
>>>>>>         char                    **parent_names;
>>>>>>         struct clk              **parents;
>>>>>>         u8                      num_parents;
>>>>>>         unsigned long           rate;
>>>>>>         unsigned long           flags;
>>>>>>         unsigned int            enable_count;
>>>>>>         unsigned int            prepare_count;
>>>>>>         struct hlist_head       children;
>>>>>>         struct hlist_node       child_node;
>>>>>>         unsigned int            notifier_count;
>>>>>> #ifdef CONFIG_COMMON_CLK_DEBUG
>>>>>>         struct dentry           *dentry;
>>>>>> #endif
>>>>>> };
>>>>>>
>>>>>> An instance of struct clk_internal will be allocated in
>>>>>> __clk_init/clk_register. Now the private data stays completely inside
>>>>>> the core and noone can abuse it.
>>>>>
>>>>> Hi Sascha,
>>>>>
>>>>> I see the disconnect here.  For OMAP (and possibly other platforms) at
>>>>> least some clock data is necessary during early boot, before the
>>>>> regular allocation methods are available (timers for instance).
>>>>
>>>> We had this problem on i.MX aswell. It turned out that the timer clock
>>>> is the only clock that is needed so early. We solved this by moving the
>>>> clock init to the system timer init function.
>>>
>>> When you say "mov[ed] the clock init to the system timer init
>>> function" do you mean that you statically allocated struct clk and
>>> used the clk framework api, or instead you just did some direct
>>> register writes to initialize things properly?
>>
>> I meant that on i.MX we do the clock tree initialization when kmalloc is
>> available, see the attached patch for omap4 based on your branch which
>> does the same for Omap. The first clock you need is the one for the
>> timer, so you can initialize the clocktree at the beginning of
>> time_init() and don't need statically initialized clocks anymore.
>>
>>>>
>>>> Well, the file is work in progress, you probably fix this before sending
>>>> it out, but I bet people will include clk-private.h and nobody else
>>>> notices it.
>>>
>>> clock44xx_data.c does not violate that rule.  None of the logic that
>>> implements ops for those clocks is present clock44xx_data.c.
>>
>> Indeed, I missed that. It only has the ops but not the individual
>> functions.
>>
>>> All of
>>> the code in that file is simply initialization and registration of
>>> OMAP4 clocks.  Many of the clocks are basic clock types (divider,
>>> multiplexer and fixed-rate are used in that file) with protected code
>>> drivers/clk/clk-*.c and the remaining clocks are of the struct
>>> clk_hw_omap variety, which has code spread across several files:
>>>
>>> arch/arm/mach-omap2/clock.c
>>> arch/arm/mach-omap2/clock.h
>>> arch/arm/mach-omap2/clkt_dpll.c
>>> arch/arm/mach-omap2/clkt_clksel.c
>>> arch/arm/mach-omap2/dpll3xxx.c
>>> arch/arm/mach-omap2/dpll4xxx.c
>>>
>>> All of the above files include linux/clk-provider.h, not
>>> linux/clk-private.h.  That code makes heavy use of the
>>> __clk_get_whatever helpers and shows how a platform might honor the
>>> layer of separation between struct clk and stuct clk_ops/struct
>>> clk_foo.  You are correct that the code is a work-in-progress, but
>>> there are no layering violations that I can see.
>>>
>>> I also think we are talking past each other to some degree.  One point
>>> I would like to make (and maybe you already know this from code
>>> review) is that it is unnecessary to have pointers to your parent
>>> struct clk*'s when either initializing or registering your clocks.  In
>>> fact the existing clk_register_foo functions don't even allow you to
>>> pass in parent pointers and rely wholly on string name matching.  I
>>> just wanted to point that out in case it went unnoticed, as it is a
>>> new way of doing things from the previous series and was born out of
>>> Thomas' review of V4 and multi-parent handling.  This also keeps
>>> device-tree in mind where we might not know the struct clk *pointer at
>>> compile time for "connecting" discrete devices.
>>
>> Yes, I've seen this and I really like it. Also the change that
>> multiplexers return an index to an array instead of the parent
>> clock is very nice.
>>
>> Sascha
>>
>>
>> 8<-----------------------------------------------------
>>
>> ARM omap4: move clocktree init to timer init time so we don't need static clocks
>>
>> Signed-off-by: Sascha Hauer<s.hauer@pengutronix.de>
>

Hi Mike,

I already took a quick look at the v7 series, but I thought this thread 
has more relevant context for my response. So, responding here.

I'm with Sascha on creating a clk_internal/clk_initializer and removing 
clk_hw. You had asked about the benefits of his suggestion in one of the 
earlier threads. I'm sure I have told some of these reasons I don't like 
clk_hw, but repeating my points here for others to chime in.

I used to be a huge proponent for using macros for clocks in our 
internal tree. All the clocks were constructed using macros (you will 
see it in the history of tree we publish in CAF). They quickly became 
unreadable when you have several hundreds of clocks. The biggest problem 
is that you can't quickly look at a clock's macro and figure out what 
the register offset or bit mask or shift value is. Our eyes/brains 
aren't meant for quickly parsing the commas and finding the n-th field 
or even remembering what the n-th field of each macro corresponds to. If 
it's actually broken out as fields in a struct, it's much easier to 
read. So, long story short, I think the well-intentioned helper macros 
will make code quite unreadable.

I also don't want to maintain such helper macros for the platform 
specific clock types that I will have to create for MSM if I were to go 
with macros.

If I choose not to use the helper macros, then I need to define three 
separate declarations for each clock. That looks messy when you have 
100s of clocks.

With clk_initializer, we also don't have to keep changing the 
clk_init/clk_register APIs whenever we add any other optional fields in 
the future. You just add it to clk_initializer and if people care for 
those fields, they can add it to the static/dynamic clocks.

Whether we use a macro or not, the current approach also adds twice the 
the no. of symbols in the debug info and increases the size of the 
kernel. When we go for a single ARM kernel, this is going to be 
noticeable. I agree that the point about debuginfo size increase might 
not matter to most.

> Hi Sascha,
>
> Thanks for the example code.  This is in fact something I had
> considered doing before, but it is a bit complicated for my platform.
>
> We set up all of the OMAP clocks with __clk_init because this is a
> dependency of OMAP's hwmod code which models and interacts with
> specific resources for hardware modules, such as clocks.  There are
> other dependencies such as our clockdomain code, which needs the
> clocks to be fully initialized.  Some aspects of these layers get
> init'd before we can allocate memory.

I know there is a version of OMAP hwmod in upstream, but is this 
dependency of fully initialized clock struct a requirement for the 
upstream version of hwmod or an internal OMAP tree? I will explain the 
reason for this question further down.

> Admittedly I think that the OMAP code could migrate some of these bits
> to a lazy-registration model, specifically the hwmod object instances,
> but that requires an awful lot of refactoring for a fairly large stack
> of platform code.  This might be something to achieve in the future
> but for now we *need* initialisation to be fully static.

When we work on moving clocks to device tree, wouldn't you face the same 
problem? You will have to dynamically create most of the clocks in that 
case too.

> Assuming that some day OMAP code can be refactored to allow for lazy
> (or at least initcall-based) registration of clocks then perhaps your
> suggestion can take root.  Which leads me to this question: are there
> any other platforms out there that require the level of expose to
> struct clk present in this patchset?  OMAP does, for now, but if that
> changes then I need to know if others require this as well.

MSM platform doesn't need exposure to clk_internal or the corresponding 
fields in clk. We too have the timer issue, but I would rather deal with 
the timer separately (using register writes from the timer code) than 
ugly up the 200+ clocks we have on each SoC.

Getting to suggesting a solution, how about we go with something similar 
to Sasha's suggestion:
* Put clk_inititalizer in clk-provider.h
* clk-provider.h has a forward declaration to clk (struct clk;)
* Put struct clk and struct clk_internal in a clk-private.h or whatever.
* Add a struct *clk field to struct clk_initializer (this is temporary).


For platforms that don't have the static init limitations you mention, 
they can do something like this:

#include <linux/clk-provider.h>

struct clk_complex {
	struct clk_initializer i;
	u32 foo;
	u32 bar;
	u8 baz;
};

struct clk_complex mmc1_clk {
	foo = 5,
	bar = 10,
	baz = 3,
	. i = {
		.name = mmc,
		.ops = &complex_ops,
	}
};

clk_register(NULL, &mmc1_clk.i);

But platforms that have the limitations you mention can do something like:

#include <clk-provider.h>
#include <clk-private.h>

struct clk __mmc1_clk;

struct clk_complex mmc1_clk {
	foo = 5,
	bar = 10,
	baz = 3,
	. i = {
		.name = mmc,
		.ops = &complex_ops,
		.clk = &__mmc1_clk;
	}
};

clk_init(NULL, &mmc1_clk.i);

I guess another way to look at this is: move all the inputs params in 
clk_register() to clk_hw and rename clk_hw to clk_initializer.

With the above solutions, those that don't have the OMAP-like 
limitations can have their code look much cleaner, and OMAP can still 
continue to work. After the initial conversion of all platform to the 
common clock framework, we don't allow anyone to ever include 
clk-private.h. We could even add it to check_patch.pl. Then once 
everyone fixes their static initialization limitations, we can delete 
the clk field from clk_initializer and move struct clk to clk.c.

Thoughts?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
