Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2EPGAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:00:44 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37415 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747Ab2EPGAI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FB2B7DC.4070706@codeaurora.org>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
 <20120515194245.GO30400@pengutronix.de> <4FB2B3AA.3010903@codeaurora.org>
 <20120515200040.GP30400@pengutronix.de> <4FB2B7DC.4070706@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 15 May 2012 22:59:45 -0700
Message-ID: <CAJOA=zOjj8AY1Uk7X=1GCGHt-6OUndtwR-e36vdrRmFjhJDynA@mail.gmail.com>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and clk_enable()
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 1:09 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 05/15/2012 01:00 PM, Sascha Hauer wrote:
>>
>> On Tue, May 15, 2012 at 12:51:06PM -0700, Saravana Kannan wrote:
>>>>>
>>>>>        ret = clk->ops->set_parent(clk->hw, i);
>>>>
>>>>
>>>> You call ->set_parent while holding a spinlock. This won't work with i2c
>>>> clocks.
>>>
>>>
>>> I did account for that. I explained it in the commit text. Please
>>> let me know if any part of that is not clear or is not correct.
>>>
>>
>> I missed this part in the commit log. I have no idea whether we can live
>> with this limitation though.
>>
>> Sascha
>>
>
> It's not really an artificial limitation of the patch. This has to be
> enforced if the clock is to be managed correctly while allowing .set_parent
> to NOT be atomic.
>
> There is no way to guarantee that the enable/disable is properly propagated
> to the parent clock if we can't guarantee mutual exclusion between changing
> parents and calling enable/disable.
>

We know for sure that __clk_enable was propagated since it won't
return until it is done.  The bigger issue here is the inherent
prepare_lock/enable_lock raciness, which this patch does not solve.
Your approach above is like putting a band-aid gunshot wound :-)

This change essentially forces clocks with sleeping .set_parent
callbacks to be gated during clk_set_parent or else cause a big WARN
and dump_stack.  What is really needed is a way to synchronize all of
the clock operations and drop these race conditions.  Until that
problem is solved OR until it is proven impossible to fix with the
API's given to us I won't be taking this patch.  It is invalid for the
set of clocks that don't set the CLK_SET_PARENT_GATE flag AND have
.set_parent callbacks which might sleep.

> Since we can't do mutual exclusion be using spinlock (since .set_parent is
> NOT atomic for these clocks), then only other way of ensuring mutual
> exclusion is to force an unprepare and then mutually exclude a prepare while
> changing the parent. This by association (can't enable unprepared clock)
> mutually excludes the changing of parent and calling enable/disable.

Right, but this is a workaround to a larger endemic problem.  I
completely get what you're trying to do but this fix isn't enough.

Thanks,
Mike
