Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2EAWt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:49:26 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:52393 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633Ab2EAWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:49:25 -0400
Date: Tue, 1 May 2012 15:44:35 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: mturquette@linaro.org, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: COMMON_CLK_DISABLE_UNUSED
Message-ID: <20120501224435.GA17311@gmail.com>
References: <20120409222903.GA31622@lunn.ch>
 <CAJOA=zP8XFTN1mcAyUky3ovrx4Dg1zb9zaB5r8zUYE46Ec-tMQ@mail.gmail.com>
 <4F843778.8050506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F843778.8050506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120410-08:36, Rob Herring wrote:
> On 04/09/2012 06:04 PM, Turquette, Mike wrote:
> > On Mon, Apr 9, 2012 at 3:29 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> >> I think it would be good to consider deleting this config option and
> >> just have the code always enabled.
> > 
> > I agree.  We already support the CLK_IGNORE_UNUSED flag, so any
> > platforms that don't want this functionality wholesale can set that
> > bit for every clock.
> > 
> > I'll pull out that option.
> > 
> 
> CLK_IGNORE_UNUSED looks a bit broken to me. If you don't have the flag
> set on the whole chain of parents, then a parent could be turned off.
> This could happen at boot time or when another child get disabled and
> the common parent's ref count goes to 0 and gets disabled.
> 
> I think a better solution would be a force enable or enable on boot flag
> that sets ref counts correctly. Otherwise, each platform has to call
> clk_prepare and clk_enable for all the clocks it wants to keep on.
> 
> Here's a simple case that needs work. You have a cpu clock controlled by
> cpufreq driver. If the cpufreq driver is not loaded, we want the cpu
> clock always enabled and don't want the clk infrastructure turning it
> off. If the cpufreq driver is loaded, then we potentially want it to be
> able to enable and disable the cpu clock if we switch parents. I guess
> the easiest solution is the cpufreq driver needs to assume the cpu clock
> is already enabled with a ref count of 1.
> 

Hi Rob,

Apologies for the late reply.

I think having any driver (including a cpufreq driver) assume anything
about the usecount is broken.  Most code should follow the
tried-and-true pattern:

clk_get()
clk_prepare()
clk_enable()

cpufreq is no exception to this pattern.  The only concern that has been
raised to date is that of "re-enabling" a clock that is already enabled
in hardware (which the cpufreq driver would do).  That case is only
theoretical and no platform that I am aware of has a problem re-setting
the bit to enable a clock (or i2c message, or whatever).

Thanks,
Mike

> Rob
