Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113Ab2CNSjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:39:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63925 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab2CNSjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:39:06 -0400
Message-ID: <4F60E5C3.1090006@gmail.com>
Date: Wed, 14 Mar 2012 13:38:59 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Saravana Kannan <skannan@codeaurora.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] clk: basic clock hardware types
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org> <1331366064-1273-4-git-send-email-mturquette@linaro.org> <20120314182345.GB29317@pengutronix.de>
In-Reply-To: <20120314182345.GB29317@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 01:23 PM, Sascha Hauer wrote:
> On Fri, Mar 09, 2012 at 11:54:24PM -0800, Mike Turquette wrote:
>> Many platforms support simple gateable clocks, fixed-rate clocks,
>> adjustable divider clocks and multi-parent multiplexer clocks.
>>
>> This patch introduces basic clock types for the above-mentioned hardware
>> which share some common characteristics.
>>
>> Based on original work by Jeremy Kerr and contribution by Jamie Iles.
>> Dividers and multiplexor clocks originally contributed by Richard Zhao &
>> Sascha Hauer.
>>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Mike Turquette <mturquette@ti.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Jamie Iles <jamie@jamieiles.com>
>> Cc: Richard Zhao <richard.zhao@linaro.org>
>> Cc: Saravana Kannan <skannan@codeaurora.org>
>> Cc: Magnus Damm <magnus.damm@gmail.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Amit Kucheria <amit.kucheria@linaro.org>
>> Cc: Deepak Saxena <dsaxena@linaro.org>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> ---
>> Changes since v5:
>>  * standardized the hw-specific locking in the basic clock types
>>  * export the individual ops for each basic clock type
>>  * improve registration for single-parent basic clocks (thanks Sascha)
>>  * fixed bugs in gate clock's static initializers (thanks Andrew)
>>
>>  drivers/clk/Makefile         |    3 +-
>>  drivers/clk/clk-divider.c    |  204 ++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/clk-fixed-rate.c |   82 +++++++++++++++++
>>  drivers/clk/clk-gate.c       |  157 ++++++++++++++++++++++++++++++++
>>  drivers/clk/clk-mux.c        |  123 +++++++++++++++++++++++++
>>  include/linux/clk-private.h  |  124 +++++++++++++++++++++++++
>>  include/linux/clk-provider.h |  127 ++++++++++++++++++++++++++
>>  7 files changed, 819 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/clk/clk-divider.c
>>  create mode 100644 drivers/clk/clk-fixed-rate.c
>>  create mode 100644 drivers/clk/clk-gate.c
>>  create mode 100644 drivers/clk/clk-mux.c
>>
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index ff362c4..1f736bc 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -1,3 +1,4 @@
>>  
>>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>> -obj-$(CONFIG_COMMON_CLK)	+= clk.o
>> +obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
>> +				   clk-mux.o clk-divider.o
>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> new file mode 100644
>> index 0000000..c0c4e0b
>> --- /dev/null
>> +++ b/drivers/clk/clk-divider.c
>> @@ -0,0 +1,204 @@
>> +/*
>> + * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
>> + * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
>> + * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * Adjustable divider clock implementation
>> + */
>> +
>> +#include <linux/clk-provider.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/io.h>
>> +#include <linux/err.h>
>> +#include <linux/string.h>
>> +
>> +/*
>> + * DOC: basic adjustable divider clock that cannot gate
>> + *
>> + * Traits of this clock:
>> + * prepare - clk_prepare only ensures that parents are prepared
>> + * enable - clk_enable only ensures that parents are enabled
>> + * rate - rate is adjustable.  clk->rate = parent->rate / divisor
>> + * parent - fixed parent.  No clk_set_parent support
>> + */
>> +
>> +#define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
>> +
>> +static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
>> +		unsigned long parent_rate)
>> +{
>> +	struct clk_divider *divider = to_clk_divider(hw);
>> +	unsigned int div;
>> +	unsigned long flags = 0;
>> +
>> +	if (divider->lock)
>> +		spin_lock_irqsave(divider->lock, flags);
>> +
>> +	div = readl(divider->reg) >> divider->shift;
>> +	div &= (1 << divider->width) - 1;
>> +
>> +	if (divider->lock)
>> +		spin_unlock_irqrestore(divider->lock, flags);
>> +
>> +	if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
>> +		div++;
>> +
>> +	return parent_rate / div;
>> +}
>> +EXPORT_SYMBOL_GPL(clk_divider_recalc_rate);
>> +
>> +static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>> +		unsigned long *best_parent_rate)
>> +{
>> +	struct clk_divider *divider = to_clk_divider(hw);
>> +	int i, bestdiv = 0;
>> +	unsigned long parent_rate, best = 0, now, maxdiv;
>> +
>> +	maxdiv = (1 << divider->width);
> 
> We need a check for rate == 0 here:
> 
> 	if (rate == 0)
> 		rate = 1;
> 
> Otherwise we divide by zero below.
> 
>> +
>> +	if (divider->flags & CLK_DIVIDER_ONE_BASED)
>> +		maxdiv--;
>> +
>> +	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
>> +		parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
>> +		bestdiv = parent_rate / rate;
> 
> It's a bit strange but due to integer maths you must use DIV_ROUND_UP
> in round_rate and div = parent_rate / rate in set_rate.
> 
> Example:
> 
> parent_rate = 100
> rate = 34
> 
> Now the best divider would be 3 (100/3 = 33), but the above
> results in 2. With DIV_ROUND_UP round_rate correctly returns
> 33. Now when you use DIV_ROUND_UP in set_rate the resulting
> divider would be 4 which is wrong whereas 100/33 returns the correct
> result.

This gets into the problem with round_rate. You can't specify whether to
round up or down. For something like an SD card you would want to pass
in the max freq for the card and get back something less than or equal
to it. For something like an LCD pixel clock, you need a frequency
greater than or equal to the requested freq to maintain a minimum
refresh rate. There's been some discussion about this some time back.

But for now we shouldn't fix round_rate, and your solution is right (or
at least safer).

Rob
