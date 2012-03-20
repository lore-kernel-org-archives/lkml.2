Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab2CTHy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:54:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50510 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2CTHyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:54:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="171672153"
Message-ID: <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
In-Reply-To: <20120320072018.GC32469@S2101-09.ap.freescale.net>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
    <1332214706-675-1-git-send-email-skannan@codeaurora.org>
    <1332214706-675-2-git-send-email-skannan@codeaurora.org>
    <20120320072018.GC32469@S2101-09.ap.freescale.net>
Date: Tue, 20 Mar 2012 00:54:55 -0700 (PDT)
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Shawn Guo" <shawn.guo@linaro.org>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        "Arnd Bergman" <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Andrew Lunn" <andrew@lunn.ch>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Jeremy Kerr" <jeremy.kerr@canonical.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul Walmsley" <paul@pwsan.com>,
        "Shawn Guo" <shawn.guo@freescale.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Richard Zhao" <richard.zhao@linaro.org>,
        "Magnus Damm" <magnus.damm@gmail.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Amit Kucheria" <amit.kucheria@linaro.org>,
        "Deepak Saxena" <dsaxena@linaro.org>,
        "Grant Likely" <grant.likely@secretlab.ca>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, March 20, 2012 12:20 am, Shawn Guo wrote:
> On Mon, Mar 19, 2012 at 08:38:26PM -0700, Saravana Kannan wrote:
>> This has a couple of advantages:
>> * Completely hides struct clk from many clock platform drivers and
>> static
>>   clock initialization code.
>> * Simplifies the generic clk_register() function and allows adding
>> optional
>>   fields in the future without modifying the function signature.
>> * Allows for simpler static initialization of clocks on all platforms by
>>   removing the need for forward delcarations.
>> * Halves the number of symbols added for each static clock
>> initialization.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>
> I agree this is a reasonable move.  But while you simplify the interface
> of clk_register(), why not making a further step to simplify the
> following interfaces simple too?
>
> struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 unsigned long fixed_rate);
> struct clk *clk_register_gate(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 void __iomem *reg, u8 bit_idx,
>                 u8 clk_gate_flags, spinlock_t *lock);
> struct clk *clk_register_divider(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 void __iomem *reg, u8 shift, u8 width,
>                 u8 clk_divider_flags, spinlock_t *lock);
> struct clk *clk_register_mux(struct device *dev, const char *name,
>                 char **parent_names, u8 num_parents, unsigned long flags,
>                 void __iomem *reg, u8 shift, u8 width,
>                 u8 clk_mux_flags, spinlock_t *lock);

If you simplify those functions further. They would just become
clk_register(). I'm not sure I see a value in them in at that point or
even in their current form. But if others see (I'm guessing since they
acked or didn't nack it), I'm not going to ask to remove them. If everyone
agrees that we should just remove them, I would be glad to.

It's arguable that these functions for the common hardware types saves the
need to deal with the kalloc in every platform driver. But it's not clear
to me where they would get these parameters in the first place. Most
likely form some sort of static array. At which point, it might as well be
a static array of pointers to clk_gated.hw, clk_fixed_rate.hw, etc instead
of a platform specific  struct to hold these initializers.

Btw, I need to fix the macros too. Or may be even delete them. Will see
the overall response before I send out v2 to do that.

>
> Otherwise,
>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
Thanks

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


