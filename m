Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1ATQkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:40:19 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:33434 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750923Ab1ATQkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:40:17 -0500
Message-ID: <4D386564.2090601@fluff.org>
Date: Thu, 20 Jan 2011 16:40:04 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111091607.GI12552@n2100.arm.linux.org.uk>	<201101111744.59712.jeremy.kerr@canonical.com> <20110111101314.GA774@linux-sh.org>
In-Reply-To: <20110111101314.GA774@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 10:13, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 05:44:59PM +0800, Jeremy Kerr wrote:
>> So, it sounds like the best approach is to provide an atomic clk_enable. I 
>> agree with Sascha that the clk_enable and clk_enable_atomic polarity makes the 
>> most sense, so how about:
>>
>> int clk_enable(struct clk *clk)
>> {
>> 	might_sleep();
>>
>> 	[...]
>> }
>>
>> int clk_enable_atomic(struct clk *clk)
>> {
>> 	BUG_ON(!(clk->flags & CLK_ATOMIC));
>>
>> 	[...]
>> }
>>
>> Paul: even though you mention that the atomic clocks are the usual case, I 
>> think that this way around illustrates the atomic 'restriction' at the call 
>> site more clearly. When the drivers don't care about the atomicity, 
>> clk_enable() is fine. When drivers do need an atomic clock, 
>> clk_enable_atomic() shows this requirement.
>>
> No, the sleeping clock case is and always will be a corner case, and I
> have no interest in pretending otherwise. On SH we have hundreds of
> clocks that are all usable in the atomic context and perhaps less than a
> dozen that aren't (and even in those cases much of the PLL negotiation is
> handled in hardware so there's never any visibility for the lock-down
> from the software side, other architectures also have similar behaviour).

So, how does the software deal with the clock not being available if the
PLL powers up and takes time to lock and the software goes and tries to
use the device? We need to ensure the clock is on and stable before the
clk_enable() call returns.

For all the drivers I've written so far, clk_enable() and disable()
calls are done from sleep-able contexts such as the mmc work queue
or other such systems.
