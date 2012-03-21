Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2CUANg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:13:36 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:56313 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755511Ab2CUANe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <348585ed29fb3ff171267c03658e6c0d.squirrel@www.codeaurora.org>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org> <20120320071957.GH3852@pengutronix.de>
 <348585ed29fb3ff171267c03658e6c0d.squirrel@www.codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 20 Mar 2012 17:13:08 -0700
Message-ID: <CAJOA=zO=wp9oyuBZONk2oCRYdWU1c4qanKJik-8-sFg51p27MQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: Fix error handling in fixed clock hardware type
 register fn
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
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
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:46 AM, Saravana Kannan
<skannan@codeaurora.org> wrote:
> On Tue, March 20, 2012 12:19 am, Sascha Hauer wrote:
>> On Mon, Mar 19, 2012 at 08:38:25PM -0700, Saravana Kannan wrote:
>>> If memory allocation for the parents array or the parent string fails,
>>> then
>>> fail the registration immediately instead of calling clk_register and
>>> hoping it fails there.
>>>
>>> Return -ENOMEM on failure.
>>>
>>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>>> Cc: Mike Turquette <mturquette@linaro.org>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
>>> Cc: Paul Walmsley <paul@pwsan.com>
>>> Cc: Shawn Guo <shawn.guo@freescale.com>
>>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>>> Cc: Jamie Iles <jamie@jamieiles.com>
>>> Cc: Richard Zhao <richard.zhao@linaro.org>
>>> Cc: Saravana Kannan <skannan@codeaurora.org>
>>> Cc: Magnus Damm <magnus.damm@gmail.com>
>>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: Amit Kucheria <amit.kucheria@linaro.org>
>>> Cc: Deepak Saxena <dsaxena@linaro.org>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>> There are still some memory free issues when clk_register() fails, but I
>>> will
>>> fix it when I fixed the other register() fns to return ENOMEM of alloc
>>> failure instead of a NULL.
>>>
>>>  drivers/clk/clk-fixed-rate.c |   10 +++++++---
>>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
>>> index 90c79fb..6423ae9 100644
>>> --- a/drivers/clk/clk-fixed-rate.c
>>> +++ b/drivers/clk/clk-fixed-rate.c
>>> @@ -61,22 +61,26 @@ struct clk *clk_register_fixed_rate(struct device
>>> *dev, const char *name,
>>>              parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
>>>
>>>              if (! parent_names)
>>> -                    goto out;
>>> +                    goto fail_ptr;
>>>
>>>              len = sizeof(char) * strlen(parent_name);
>>>
>>>              parent_names[0] = kmalloc(len, GFP_KERNEL);
>>>
>>>              if (!parent_names[0])
>>> -                    goto out;
>>> +                    goto fail_str;
>>>
>>>              strncpy(parent_names[0], parent_name, len);
>>>      }
>>
>> It's easier to add a char *parent to struct clk_fixed and pass it to
>> clk_register with &fixed->parent. This saves you a kmalloc call and
>> makes the error path simpler. It's the same way already done in the
>> divider.

I thought I had done this for v7... hmm looks like one got left out.
I'll line up a patch to get it in sync with the others as part of my
fixes.

> I thought about that since I saw the same was done for gated and divider
> (I think). Here is my guess at Mike's reasoning for this:
>
> Gated and divider clocks have to have a parent. There's nothing to gate
> otherwise. But fixed rate clocks might not have a parent. It could be XO's
> or PLLs running off of always on XOs not controlled by the SoC. So, it's
> arguable to not have a parent. I don't have a strong opinion on this --
> since Mike took the time to write it, it left it to his subjective
> preference.

I appreciate the thoughtfulness.  Re-using the same type of mechanism
as the divider and gate clocks will still allow the fixed-rate clock
to be parentless, and it makes for cleaner code, one less allocation
and lines up with how the other single-parent basic clocks are done,
so I'll take that method in instead of your patch.

> I sent this patch first since it was around the place I was cleaning up. I
> didn't want to actually just shuffle around a bug. As I mentioned, this
> patch still leaves a bug open -- what if clk_register() fails. I plan to
> fix that once my two patches are picked up (hopefully).

Do you still find it useful to return -ENOMEM from the registration
function instead of a NULL clock?  I'm always worried that people
don't check for error codes on pointers in their platform code and
only check for NULL...

Regards,
Mike

> Thanks,
> Saravana
