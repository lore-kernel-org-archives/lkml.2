Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2EAKno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:43:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45417 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2EAKnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:43:42 -0400
Date: Tue, 1 May 2012 11:43:10 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
Message-ID: <20120501104310.GB28930@e102568-lin.cambridge.arm.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
 <201204302325.09505.rjw@sisk.pl>
 <CAMbhsRRReyiv2LgUNgp6XiW07V8Eb0gd4fb7W6nBjMZ1FpmOBQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMbhsRRReyiv2LgUNgp6XiW07V8Eb0gd4fb7W6nBjMZ1FpmOBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 May 2012 10:44:41.0409 (UTC) FILETIME=[69E1DB10:01CD2787]
X-MC-Unique: 112050111431805701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Mon, Apr 30, 2012 at 10:37:30PM +0100, Colin Cross wrote:
> On Mon, Apr 30, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > I have a comment, which isn't about the series itself, but something
> > thay may be worth thinking about.
> >
> > On Monday, April 30, 2012, Colin Cross wrote:
> >> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> >> cpus cannot be independently powered down, either due to
> >> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> >> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> >> will corrupt the gic state unless the other cpu runs a work
> >> around).  Each cpu has a power state that it can enter without
> >> coordinating with the other cpu (usually Wait For Interrupt, or
> >> WFI), and one or more "coupled" power states that affect blocks
> >> shared between the cpus (L2 cache, interrupt controller, and
> >> sometimes the whole SoC).  Entering a coupled power state must
> >> be tightly controlled on both cpus.
> >
> > That seems to be a special case of a more general situation where
> > a number of CPU cores belong into a single power domain, possibly along
> > some I/O devices.
> >
> > We'll need to handle the general case at one point anyway, so I wonder if
> > the approach shown here may get us in the way?
> 
> I can't parse what you're saying here.
> 
> >> The easiest solution to implementing coupled cpu power states is
> >> to hotplug all but one cpu whenever possible, usually using a
> >> cpufreq governor that looks at cpu load to determine when to
> >> enable the secondary cpus.  This causes problems, as hotplug is an
> >> expensive operation, so the number of hotplug transitions must be
> >> minimized, leading to very slow response to loads, often on the
> >> order of seconds.
> >
> > This isn't a solution at all, rather a workaround and a poor one for that
> > matter.
> 
> Yes, which is what started me on this series.
> 
> >> This patch series implements an alternative solution, where each
> >> cpu will wait in the WFI state until all cpus are ready to enter
> >> a coupled state, at which point the coupled state function will
> >> be called on all cpus at approximately the same time.
> >>
> >> Once all cpus are ready to enter idle, they are woken by an smp
> >> cross call.
> >
> > Is it really necessary to wake up all of the CPUs in WFI before
> > going to deeper idle?  We should be able to figure out when they
> > are going to be needed next time without waking them up and we should
> > know the latency to wake up from the deeper multi-CPU "C-state",
> > so it should be possible to decide whether or not to go to deeper
> > idle without the SMP cross call.  Is there anything I'm missing here?
> 
> The decision to go to the lower state has already been made when the
> cross call occurs.  On the platforms I have worked directly with so
> far (Tegra2 and OMAP4460), the secondary cpu needs to execute code
> before the primary cpu turns off the power.  For example, on OMAP4460,
> the secondary cpu needs to go from WFI (clock gated) to OFF (power
> gated), because OFF is not supported as an individual cpu state due to
> a ROM code bug.  To do that transition, it needs to come out of WFI,
> set up it's power domain registers, save a bunch of state, and
> transition to OFF.
> 
> On Tegra3, the deepest individual cpu state for cpus 1-3 is OFF, the
> same state the cpu would go into as the first step of a transition to
> a deeper power state (cpus 0-3 OFF).  It would be more optimal in that
> case to bypass the SMP cross call, and leave the cpu in OFF, but that
> would require some way of disabling all wakeups for the secondary cpus
> and then verifying that they didn't start waking up just before the
> wakeups were disabled.  I have just started considering this
> optimization, but I don't see anything in the existing code that would
> prevent adding it later.

I agree it is certainly an optimization that can be added later if benchmarks
show it is needed (but again it is heavily platform dependent, ie technology
dependent).
On a side note, disabling (or move to the primary) wake-ups for "secondaries"
on platforms where every core is in a different power domain is still needed
to avoid having a situation where a CPU can independently get out of idle, ie
abort idle, after hitting the coupled barrier.
Still do not know if for those platforms coupled C-states should be used, but
it is much better to have a choice there IMHO.

I have also started thinking about a cluster or multi-CPU "next-event" that
could avoid triggering heavy operations like L2 cleaning (ie cluster shutdown)
if a timer is about to expire on a given CPU (as you know CPUs get in and out
of idle independently so the governor decision at the point the coupled state
barrier is hit might be stale).

I reckon the coupled C-state concept can prove to be an effective one for
some platforms, currently benchmarking it.

> A simple measurement using the tracing may show that it is
> unnecessary.  If the wakeup time for CPU1 to go from OFF to active is
> small there might be no need to optimize out the extra wakeup.

Indeed, it is all about resetting the CPU and getting it started, with
inclusive L2 the power cost of shutting down a CPU and resuming it should be
low (and timing very fast) for most platforms.

Lorenzo

