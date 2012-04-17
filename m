Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2DQWF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:05:57 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44311 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab2DQWFz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <4F843778.8050506@gmail.com>
References: <20120409222903.GA31622@lunn.ch> <CAJOA=zP8XFTN1mcAyUky3ovrx4Dg1zb9zaB5r8zUYE46Ec-tMQ@mail.gmail.com>
 <4F843778.8050506@gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 17 Apr 2012 15:05:32 -0700
Message-ID: <CAJOA=zMQ465nGXobywH0DWQePxL46Nr7MvNgX-Vsuy1y9y2q3g@mail.gmail.com>
Subject: Re: COMMON_CLK_DISABLE_UNUSED
To: Rob Herring <robherring2@gmail.com>
Cc: arnd.bergmann@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 6:36 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 04/09/2012 06:04 PM, Turquette, Mike wrote:
>> On Mon, Apr 9, 2012 at 3:29 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>>> I think it would be good to consider deleting this config option and
>>> just have the code always enabled.
>>
>> I agree.  We already support the CLK_IGNORE_UNUSED flag, so any
>> platforms that don't want this functionality wholesale can set that
>> bit for every clock.
>>
>> I'll pull out that option.
>>
>
> CLK_IGNORE_UNUSED looks a bit broken to me. If you don't have the flag
> set on the whole chain of parents, then a parent could be turned off.
> This could happen at boot time or when another child get disabled and
> the common parent's ref count goes to 0 and gets disabled.

Chain of parents is irrelevant.  If the clock data is faulty and
doesn't mark a clock properly with CLK_IGNORE_UNUSED when it should
then bad things are expected to happen.

> I think a better solution would be a force enable or enable on boot flag
> that sets ref counts correctly. Otherwise, each platform has to call
> clk_prepare and clk_enable for all the clocks it wants to keep on.

I'm happy with platforms calling clk_prepare and clk_enable for clocks
that are not traditionally controlled by drivers.  Doing so makes for
a more easily understood clocking scheme and takes the magic out of
"why is that clock enabled/disabled?" during debug.

> Here's a simple case that needs work. You have a cpu clock controlled by
> cpufreq driver. If the cpufreq driver is not loaded, we want the cpu
> clock always enabled and don't want the clk infrastructure turning it
> off. If the cpufreq driver is loaded, then we potentially want it to be
> able to enable and disable the cpu clock if we switch parents. I guess
> the easiest solution is the cpufreq driver needs to assume the cpu clock
> is already enabled with a ref count of 1.

This feels cumbersome to me.  So the core increments the prepare and
enable usecounts and defers to the driver code to do the right thing?
This sounds like an easy way to end up with an imbalance of usecounts.
 Even worse drivers might end up doing something awful such as:

clk_enable(clk);
...
driver_does_stuff();
...
clk_disable(clk); // usecount is still 1
clk_disable(clk); // usecount is now zero

In the other thread on this topic started by Viresh a good question
was put forward by Shawn: can your hardware not tolerate having
.clk_enable run against a clock that is already enabled?  For SoCs
this is typically setting (or clearing) a bit that is already set (or
cleared, respectively).  That allows your cpufreq driver to still do
the typical clk_enable/clk_disable routine without having to make any
assumptions about the clock being enabled AND it allows proper use of
the CLK_IGNORE_UNUSED flag in the event that your cpufreq driver is
never loaded.

Regards,
Mike

> Rob
