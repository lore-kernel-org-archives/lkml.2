Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1DDLV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 07:21:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52655 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1DDLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 07:21:58 -0400
Date: Mon, 4 Apr 2011 12:21:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Detlef Vollmann <dv@vollmann.ch>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Tony Lindgren <tony@atomide.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110404112104.GB19854@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104031726.37420.arnd@arndb.de> <20110403160324.GA8050@n2100.arm.linux.org.uk> <201104040259.26601.arnd@arndb.de> <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 12:03:42PM +0100, Catalin Marinas wrote:
> On Mon, 2011-04-04 at 01:59 +0100, Arnd Bergmann wrote:
> > On Sunday 03 April 2011, Russell King - ARM Linux wrote:
> > > Then there's those which change the cs->read function pointer at runtime,
> ...
> > > and those which share that pointer with their sched_clock() implementation.
> > 
> > Abstracting sched_clock() to be run-time selected is something that
> > needs to be taken care of. Maybe we could have a generic sched_clock
> > implementation that is written on top of clocksource instead of jiffies,
> > and always select that on architectures that have a decent clocksource.
> 
> On Cortex-A15 with the virtualisation extensions and architected timers
> the clocksource is implemented using a physical counter (as we want
> wall-clock timing). But for sched_clock() we may want to use a virtual
> counter (which is basically an offset from the physical one, set by the
> hypervisor during guest OS switching). Marc already posted some patches
> for this.

I had a quick look at the two patches, but I was far from impressed
due to the apparant complexity I saw.

There's no point in trying to consolidate stuff if it results in a net
increase in the amount of code to be maintained as that just increases
the burden, churn and maintainence headache.

Is there an easier way to consolidate it across all platforms?  I think
so:

static DEFINE_CLOCK_DATA(cd);
static u32 sched_clock_mask;
static u32 (*read_sched_clock)(void);

unsigned long long notrace sched_clock(void)
{
	if (read_sched_clock) {
		u32 cyc = read_sched_clock();
		return cyc_to_sched_clock(&cd, cyc, sched_clock_mask);
	} else {
		/* jiffies based code */
	}
}

static void notrace update_sched_clock(void)
{
	u32 cyc = read_sched_clock();
	update_sched_clock(&cd, cyc, sched_clock_mask);
}

void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
{
	BUG_ON(bits > 32);
	read_sched_clock = read;
	sched_clock_mask = (1 << bits) - 1;
	init_sched_clock(&cd, update_sched_clock, bits, rate);
}

and then get rid of the per-platform implementations entirely - all
that platforms then have to provide is a read function and a call to
setup_sched_clock().

Whether its worth it or not is questionable - the above is more lines
of code than many of the existing implementations, and we're not going
to shrink the existing implementations by much (maybe one to three
lines.)  The only thing we gain is the ability to select an implementation
at runtime.
