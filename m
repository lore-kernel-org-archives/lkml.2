Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1DDNYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:24:04 -0400
Received: from service87.mimecast.com ([94.185.240.25]:52870 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750934Ab1DDNYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:24:01 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, david@lang.hm,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>, Detlef Vollmann <dv@vollmann.ch>
In-Reply-To: <20110404112104.GB19854@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <201104031726.37420.arnd@arndb.de>
	 <20110403160324.GA8050@n2100.arm.linux.org.uk>
	 <201104040259.26601.arnd@arndb.de>
	 <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
	 <20110404112104.GB19854@n2100.arm.linux.org.uk>
Organization: ARM Ltd
Date: Mon, 04 Apr 2011 14:24:17 +0100
Message-ID: <1301923457.417.34.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 04 Apr 2011 13:23:51.0007 (UTC) FILETIME=[898B1EF0:01CBF2CB]
X-MC-Unique: 111040414235512101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 12:21 +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 04, 2011 at 12:03:42PM +0100, Catalin Marinas wrote:
> > On Mon, 2011-04-04 at 01:59 +0100, Arnd Bergmann wrote:
> > > On Sunday 03 April 2011, Russell King - ARM Linux wrote:
> > > > Then there's those which change the cs->read function pointer at runtime,
> > ...
> > > > and those which share that pointer with their sched_clock() implementation.
> > > 
> > > Abstracting sched_clock() to be run-time selected is something that
> > > needs to be taken care of. Maybe we could have a generic sched_clock
> > > implementation that is written on top of clocksource instead of jiffies,
> > > and always select that on architectures that have a decent clocksource.
> > 
> > On Cortex-A15 with the virtualisation extensions and architected timers
> > the clocksource is implemented using a physical counter (as we want
> > wall-clock timing). But for sched_clock() we may want to use a virtual
> > counter (which is basically an offset from the physical one, set by the
> > hypervisor during guest OS switching). Marc already posted some patches
> > for this.
> 
> I had a quick look at the two patches, but I was far from impressed
> due to the apparant complexity I saw.
>
> There's no point in trying to consolidate stuff if it results in a net
> increase in the amount of code to be maintained as that just increases
> the burden, churn and maintainence headache.
> 
> Is there an easier way to consolidate it across all platforms?  I think
> so:
> 
> static DEFINE_CLOCK_DATA(cd);
> static u32 sched_clock_mask;
> static u32 (*read_sched_clock)(void);
> 
> unsigned long long notrace sched_clock(void)
> {
> 	if (read_sched_clock) {
> 		u32 cyc = read_sched_clock();
> 		return cyc_to_sched_clock(&cd, cyc, sched_clock_mask);
> 	} else {
> 		/* jiffies based code */
> 	}
> }
> 
> static void notrace update_sched_clock(void)
> {
> 	u32 cyc = read_sched_clock();
> 	update_sched_clock(&cd, cyc, sched_clock_mask);
> }
> 
> void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
> {
> 	BUG_ON(bits > 32);
> 	read_sched_clock = read;
> 	sched_clock_mask = (1 << bits) - 1;
> 	init_sched_clock(&cd, update_sched_clock, bits, rate);
> }
> 
> and then get rid of the per-platform implementations entirely - all
> that platforms then have to provide is a read function and a call to
> setup_sched_clock().

The complexity mostly comes the fact that I tried to avoid having more
runtime complexity on platforms that didn't need to select their
sched_clock() implementation at runtime (no indirection while calling
sched_clock()).

If this can be relaxed, then your implementation is definitely better.

> Whether its worth it or not is questionable - the above is more lines
> of code than many of the existing implementations, and we're not going
> to shrink the existing implementations by much (maybe one to three
> lines.)  The only thing we gain is the ability to select an implementation
> at runtime.

I believe this last point to be rather important if we plan to have this
mythical single kernel covering several architectures. It's also nice
for the A15 to be able to use some default sched_clock() implementation
as a fallback if the generic timers are not available for some reason.

	M.
-- 
Reality is an implementation detail.


