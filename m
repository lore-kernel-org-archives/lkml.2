Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2BKOkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 09:40:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2BKOkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 09:40:14 -0500
Date: Sat, 11 Feb 2012 14:39:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Todd Poynor <toddpoynor@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nicolas Pitre <nico@fluxnic.net>, Oleg Nesterov <oleg@redhat.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linaro-kernel@lists.linaro.org, Mike Chan <mike@android.com>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120211143951.GA24564@sirena.org.uk>
References: <20120208013959.GA24535@panacea>
 <1328670355.2482.68.camel@laptop>
 <20120208202314.GA28290@redhat.com>
 <1328736834.2903.33.camel@pasglop>
 <20120209075106.GB18387@elte.hu>
 <4F35DD3E.4020406@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F35DD3E.4020406@codeaurora.org>
X-Cookie: Swap read error.  You lose your mind.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 07:15:10PM -0800, Saravana Kannan wrote:
> On 02/08/2012 11:51 PM, Ingo Molnar wrote:
> >* Benjamin Herrenschmidt<benh@kernel.crashing.org>  wrote:

> >>On the other hand, the need for schedulable contxts may not
> >>necessarily go away.

> >We will support it, but the *sane* hw solution is where
> >frequency transitions can be done atomically.

> I'm not sure atomicity has much to do with this. From what I can
> tell, it's about the physical characteristics of the voltage source
> and the load on said source.

> After a quick digging around for some info for one of our platforms
> (ARM/MSM), it looks like it will take 200us to ramp up the power
> rail from the voltage for the lowest CPU freq to voltage for the
> highest CPU freq. And that's ignoring any communication delay. The
> 200us is purely how long it takes for the PMIC output to settle
> given the power load from the CPU. I would think other PMICs from
> different manufacturers would be in the same ballpark.

No matter how good the PMICs get the CPUs are also improving the speed
with which they can do frequency changes so I expect this is always
going to need consideration on at least some systems.

> 200us is a lot of time to add to a context switch or to busy wait on
> when the processors today can run at GHz speeds.

Absolutely, and as you say this ignores communication overheads - often
PMICs are connected via I2C which can only be communicated with in
schedulable context and which takes substantially more than microseconds
to interact with.  Usually in systems where scaling performance is
important there will also be GPIOs to signal voltage changes but we
can't rely on them being there and you can often do some useful stuff
if you also interact via I2C.

For step downs this isn't such a big deal as we don't often care if the
voltage drops immediately but for step ups it's critical as if the
voltage hasn't ramped before the CPU tries to run at the higher
frequency the CPU will brown out.

> >We accomodate all hardware as well as we can, but we *design*
> >for proper hardware. So Peter is right, this should be done
> >properly.

> When you say accommodate all hardware, does it mean we will keep
> around CPUfreq and allow attempts at improving it? Or we will
> completely move to scheduler based CPU freq scaling, but won't try
> to force atomicity? Say, may be queue up a notification to a CPU
> driver to scale up the frequency as soon as it can?

We could also make the system aware of the multiple steps in scaling so
that it can do things like kick off voltage ramps and wait for them to
complete before performing the frequency change, I'm sure there's room
to do useful things there.  Possibly having the concept of expanding the
range of currently available frequencies for example.

> IMHO, I think the problem with CPUfreq and its dynamic governors
> today is that they do a timer based sampling of the CPU load instead
> of getting some hints from the scheduler when the scheduler knows
> that the load average is quite high.

Yes, this seems like a big issue - often the interval before the
governors will react can end up being human visible which is
unfortunate.
