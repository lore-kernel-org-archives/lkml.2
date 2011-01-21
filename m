Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1AUVxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:53:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32922 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1AUVxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:53:48 -0500
Date: Fri, 21 Jan 2011 16:53:44 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Dima Zavin <dmitriyz@google.com>
cc: Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
In-Reply-To: <AANLkTik53zyXytvuAd5zK0_zExfQT3FmOgTr8BexmGeT@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101211618170.8580@xanadu.home>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org> <20110120185617.GI6335@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101201623480.8580@xanadu.home> <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
 <4D3907BD.4040900@codeaurora.org> <AANLkTik53zyXytvuAd5zK0_zExfQT3FmOgTr8BexmGeT@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Dima Zavin wrote:

> On Thu, Jan 20, 2011 at 8:12 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> > On 01/20/2011 06:06 PM, Dima Zavin wrote:
> >> Here's a better one.
> >>
> >> Many devices use serial display panels sitting on either MDDI or MIPI
> >> links. The interface clocks need to be on, but they stay in low-power
> >> mode while the display is on. The display controller however does not
> >> need to be on since the serial panels typically have a local
> >> framebuffer that does the idle panel refresh on it's own. When a new
> >> frame comes in to be displayed, you need to clock on the display
> >> controller, DMA the data to the panel, and when it's done turn the
> >> controller off. The clk_enable may or may not happen at irq context,
> >> depending on whether or not you are starting the DMA from a
> >> vsync/tear-effect irq or simply from the screen_update() function. The
> >> clk_disable will most certainly happen from the DMA_DONE irq.
> >
> > Why do we need to turn on the clock in the IRQ? Why not defer it to a
> > workqueue (or whatever is the method of the day to defer work from an IRQ)?
> > The advantage of doing the clk_enable in the IRQ should be negligible
> > compared to the time it takes to do the DMA.
> 
> Because in an interactive system running at 60fps, you only have 16ms
> budget per frame. During the blanking interval when you receive the
> IRQ you need to immediately start the DMA. If you defer to a workqueue
> and schedule you are practically guaranteeing to never run at 60fps
> (more like 30 if you are consistently late, which you would with that
> kind of timing and even a mildly busy system).

And... is there really some advantage to turn the clock off in between 
frames when you're otherwise busy generating them anyway?

I think the fundamental problem with this clock API is that it tries to 
consolidate completely different usages behind the same set of 
interfaces, and that obviously fails.

Some people have clocks that are derived from slow-stabilizing PLLs and 
in that case you do want to use a sleeping API.  Obviously such clocks 
just can't be turned off and on between video frames while in interrupt 
context, hence for such clocks, the hypothetical clk_disable() call must 
do nothing.

So I think that the API must be augmented with more methods, such as:

clk_slow_enable():
  - may sleep
  - may be a no-op if the clk_fast_enable() is supported

clk_fast_enable():
  - may not sleep, used in atomic context
  - may be a no-op if controlling the clock takes time, in which case 
    clk_slow_enable() must have set the clock up entirely

... and similar for clk_slow_disable() and clk_fast_disable().

Then the driver must call clk_slow_enable() when in sleepable context, 
at worst after a successful probe, or better within the open method, or 
even better right before some processing request if possible.  The 
driver must also call clk_fast_enable() right before the hardware is 
kicked into motion.

Then, as soon as the IRQ from the hardware to indicate that the job is 
done is received, you call clk_fast_disable().  At that point you might 
awake a sleeping thread waiting for the resulting data.  In that thread, 
you then call clk_slow_disable() if possible, or from the driver's 
release() method otherwise.

So if you happen to have a fast-enabling clock, you make 
clk_slow_enable() a no op, and do everything in clk_fast_enable().  If 
your clock control sits on some I2C bus then you must do everything from 
clk_slow_enable() and make clk_fast_enable() a no op.  If you do have 
both a PLL and the ability to gate clock signals, then you just 
configure the PLL from clk_slow_enable() keeping the clock signal gated, 
and ungate it only from clk_fast_enable(), to gate it (and only 
gate it) with clk_fast_disable() so it can be quickly be ungated again 
with clk_fast_enable().

This way, the API has a chance of making drivers look generic, and the 
clock providers have more flexibility to hook into the API and optimize 
to the best they can do.

Of course that means that drivers must call both the slow and the fast 
methods eventually, each in their best place.  If a driver has no use 
for clk_fast_enable() then it should simply call it right after 
clk_slow_enable() returns (and a convenience macro could be provided for 
that case).


Nicolas
