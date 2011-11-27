Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1K0GBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:01:04 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:33359 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab1K0GBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <20111126132232.GC19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org> <20111126132232.GC19025@S2100-06.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sat, 26 Nov 2011 22:00:38 -0800
Message-ID: <CAJOA=zPOeaM7-TFv2zcpLOXRAvEKF49yP+nyvjNaeMf9czMcFg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
To: Shawn Guo <shawn.guo@freescale.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Colin Cross <ccross@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 5:22 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Mon, Nov 21, 2011 at 05:40:45PM -0800, Mike Turquette wrote:
>> + * To prevent this consider setting the CLK_GATE_SET_RATE flag on any
>> + * clk where you also set the CLK_PARENT_SET_RATE flag
>
> Eh, this is how flag CLK_GATE_SET_RATE is born?  Does that mean to make
> the call succeed all the clocks on the propagating path need to be gated
> before clk_set_rate gets called?

Setting that flag on any clk implies nothing about the parents of that
clk.  Obviously if a clk's child is enabled then clk is enabled and
won't have it's rate change if the flag is set, which is the whole
point of the flag.  Again, you don't have to set the flag.

>> +     /* change the rate of this clk */
>> +     ret = clk->ops->set_rate(clk, new_rate);
>
> Yes, right here, the clock gets set to some unexpected rate, since the
> parent clock has not been set to the target rate yet at this point.

Sequence is irrelevant for the case where both parent and child change
dividers, since the output of the child clk will be "weird" at some
point.

>> diff --git a/include/linux/clk.h b/include/linux/clk.h
>> index 7213b52..3b0eb3f 100644
>> --- a/include/linux/clk.h
>> +++ b/include/linux/clk.h
>> @@ -3,6 +3,8 @@
>>   *
>>   *  Copyright (C) 2004 ARM Limited.
>>   *  Written by Deep Blue Solutions Limited.
>> + *  Copyright (c) 2010-2011 Jeremy Kerr <jeremy.kerr@canonical.com>
>> + *  Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
>>   *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License version 2 as
>> @@ -13,17 +15,134 @@
>>
>>  #include <linux/kernel.h>
>>
>> +#include <linux/kernel.h>
>
> Eh, why adding a duplication?

Will fix in v4.

>
>> +#include <linux/errno.h>
>> +
>>  struct device;
>>
>> +struct clk;
>
> Do you really need this?

Strange.  This line existed pre-common clk patches.  I'll look into
why it is getting "added" back in.  This declaration is necessary for
the old-style clk frameworks which each defined their own struct clk.
I assume it is still needed but I'll look at the git history to figure
it out.

>> +struct clk_hw_ops {
>> +     int             (*prepare)(struct clk *clk);
>> +     void            (*unprepare)(struct clk *clk);
>> +     int             (*enable)(struct clk *clk);
>> +     void            (*disable)(struct clk *clk);
>> +     unsigned long   (*recalc_rate)(struct clk *clk);
>> +     long            (*round_rate)(struct clk *clk, unsigned long,
>
> The return type seems interesting.  If we intend to return a rate, it
> should be 'unsigned long' rather than 'long'.  I'm just curious about
> the possible reason behind that.

Yeah these are mostly from the original patch set.  I'll go over these
with a fine-tooth comb for v4.  To some extent I think they model the
return types of the clk API in clk.h.

>
>> +                                     unsigned long *);
>> +     int             (*set_parent)(struct clk *clk, struct clk *);
>> +     struct clk *    (*get_parent)(struct clk *clk);
>> +     int             (*set_rate)(struct clk *clk, unsigned long);
>
> Nit: would it be reasonable to put set_rate after round_rate to group
> *_rate functions together?

Will fix in v4.

>> +int __clk_enable(struct clk *clk);
>> +void __clk_disable(struct clk *clk);
>> +int __clk_prepare(struct clk *clk);
>> +void __clk_unprepare(struct clk *clk);
>> +void __clk_reparent(struct clk *clk, struct clk *new_parent);
>> +
> Do we really need to export all these common clk internal functions?

I think we do.  Saravana also felt this was necessary.

I know that for OMAP we need __clk_prepare, __clk_unprepare and
__clk_reparent just to handle our PLLs.  I don't think we need
__clk_enable or __clk_disable since we can call the proper APIs for
those with the prepare_mutex held.

If no one needs __clk_enable and __clk_disable then I am happy to
remove those declarations.

Thanks for reviewing,
Mike
