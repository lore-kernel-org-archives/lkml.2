Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0GNRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:03:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37256 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab0GNRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:03:26 -0400
Date: Wed, 14 Jul 2010 18:03:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
	data
Message-ID: <20100714170323.GF5933@sirena.org.uk>
References: <20100713150905.GD24626@rakim.wolfsonmicro.main> <20100713161343.GA25342@bnru01.bnr.st.com> <20100713203852.GA1756@rakim.wolfsonmicro.main> <20100714145053.GA1689@bnru01.bnr.st.com> <20100714145748.GF31073@rakim.wolfsonmicro.main> <20100714153643.GB1689@bnru01.bnr.st.com> <20100714154726.GH31073@rakim.wolfsonmicro.main> <20100714160941.GC1689@bnru01.bnr.st.com> <20100714162048.GA27512@rakim.wolfsonmicro.main> <20100714164708.GD1689@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714164708.GD1689@bnru01.bnr.st.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:17:09PM +0530, Sundar R IYER wrote:
> > Are you positive that in your system it is sensible for consumers to
> > enable and disable all the supplies?  Usually there are restrictions on
> > what can sensibly be done on a given system.  For example, disabling the
> > CPU core or RAM supplies from software would normally not work terribly
> > well.
> As I said earlier, there are other supplies which I havent exposed here,
> simply because,

>  1. they are controlled out of the kernel, which makes it meaningless
>     to include them for kernel modules

There's userspace-consumer.c for exposing the control for userspace.

>  2. Even if those were included, the risk of mis-controlling them due
>     to bad SW is very high as you say and hence safely out of SW control.

> I assure you that such supplies are *not* included in this list.

OK, but your current set of supplies is *very* suspect since you're
offering all this control to lists of consumers that don't exist, and
you've got every single supply on the board varying at runtime.  This is
unusual and normally means that someone's done what you were describing
earlier and just put in the capabilities of the regulator rather than a
set of constraints for the particular board.

> > CPU core or RAM supplies from software would normally not work terribly

> Also, usually the deepest(lowest) power state for the CPU core is
> ~0V(atleast on our platform); which can be possible only by switching
> off the supplies to the core; thus effectively resulting in being
> controlled by SW. Further, I dont see the point of running full supplies
> to the RAM in a system idle state, when it is okay for the RAM to be
> powered @ a half rating OIW accountable to the idle state latencies.

This is normal, but for fairly obvious reasons the very lowest power
states are generally handled outside of the regulator API at a hardware
level via hardware signals to the regulator.  It's not normally part of
the runtime constraints for use while the CPU is live.

> > Right, but think about the case I'm talking about: if you've only hooked
> > up some but not all of the consumers then the core has no idea about the
> > consumers you didn't hook up.  You can only do power control when *all*
> > the consumers needed are configured.

> I see your point. But from an other perspective - it is *not* neccessary
> to have power control only when *all* consumers are in. For eg: we have
> 2 peripherals sharing one of the VAUX supplies. At this moment, both the
> peripherals drivers are integrated with the regulator APIs; which means
> the core handles most of the work regarding control. If, one of the
> peripherals isnt included in the final configuration, still, IMO, it
> *does* make sense that the other active peripheral optimally manage the
> supply control; which is gauranteed by the core. IOW & IMO, a consumer
> that hasnt hooked up to the regulator and thus is *aware* that it isnt
> sourced can be safely assumed to be non-existent. 

I'm not sure how you expect this to actually work in practice?  It's
going to be pretty hard for a driver to do anything constructive if the
power to the hardware gets cut, for example.  Unless you can guarantee
that there will never be any use of the hardware without a driver with
regulator support one driver's idea of optimal may not join up with what
the other consumers need at all.

If you really can safely turn off all these supplies then presumably for
the time being it'd be best to use regulator_has_full_constraints() so
they can all be powered off at runtime now.
