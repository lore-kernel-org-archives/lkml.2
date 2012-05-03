Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2ECTzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:55:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab2ECTzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:55:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
Date: Thu, 3 May 2012 22:00:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
References: <1335816551-27756-1-git-send-email-ccross@android.com> <201204302354.41969.rjw@sisk.pl> <CAMbhsRQcDDW5vWbqb1FRtvOmq6UjOjXj9MCfSt2KF9fHrcY59Q@mail.gmail.com>
In-Reply-To: <CAMbhsRQcDDW5vWbqb1FRtvOmq6UjOjXj9MCfSt2KF9fHrcY59Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032200.01823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 01, 2012, Colin Cross wrote:
> On Mon, Apr 30, 2012 at 2:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, April 30, 2012, Colin Cross wrote:
> >> On Mon, Apr 30, 2012 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > Hi,
> >> >
> >> > I have a comment, which isn't about the series itself, but something
> >> > thay may be worth thinking about.
> >> >
> >> > On Monday, April 30, 2012, Colin Cross wrote:
> >> >> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> >> >> cpus cannot be independently powered down, either due to
> >> >> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> >> >> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> >> >> will corrupt the gic state unless the other cpu runs a work
> >> >> around).  Each cpu has a power state that it can enter without
> >> >> coordinating with the other cpu (usually Wait For Interrupt, or
> >> >> WFI), and one or more "coupled" power states that affect blocks
> >> >> shared between the cpus (L2 cache, interrupt controller, and
> >> >> sometimes the whole SoC).  Entering a coupled power state must
> >> >> be tightly controlled on both cpus.
> >> >
> >> > That seems to be a special case of a more general situation where
> >> > a number of CPU cores belong into a single power domain, possibly along
> >> > some I/O devices.
> >> >
> >> > We'll need to handle the general case at one point anyway, so I wonder if
> >> > the approach shown here may get us in the way?
> >>
> >> I can't parse what you're saying here.
> >
> > The general case is a CPU core in one PM domain with a number of I/O
> > devices and a number of other CPU cores.  If we forget about the I/O
> > devices, we get a situation your patchset is addressing, so the
> > question is how difficult it is going to be to extend it to cover the
> > I/O devices as well.
> 
> The logic in this patch set is always going to be required to get
> multiple cpus to coordinate an idle transition, and it will need to
> stay fairly tightly coupled with cpuidle to correctly track the idle
> time statistics for the intermediate and final states.  I don't think
> there would be an issue if it ends up getting hoisted out into a
> future combined cpu/IO power domain, but it seems more likely that the
> coupled cpu idle states would call into the power domain to say they
> no longer need power.

There are two distinct cases to consider here, (1) when the last I/O
device in the domain becomes idle and the question is whether or not to
power off the entire domain and (2) when a CPU core in a power domain
becomes idle while all of the devices in the domain are idle already.

Case (2) is quite straightforward, the .enter() routine for the
"domain" C-state has to check whether the domain can be turned off and
do it eventually.

Case (1) is more difficult and (assuming that all CPU cores in the domain
are already idle at this point) i see two possible ways to handle it:
(a) Wake up all of the (idle) CPU cores in the domain and let the
  "domain" C-state's .enter() do the job (ie. turn it into case (2)),
  similarly to your patchset.
(b) If cpuidle has prepared the cores for going into deeper idle,
  turn the domain off directly without waking up the cores.

> >> >> The easiest solution to implementing coupled cpu power states is
> >> >> to hotplug all but one cpu whenever possible, usually using a
> >> >> cpufreq governor that looks at cpu load to determine when to
> >> >> enable the secondary cpus.  This causes problems, as hotplug is an
> >> >> expensive operation, so the number of hotplug transitions must be
> >> >> minimized, leading to very slow response to loads, often on the
> >> >> order of seconds.
> >> >
> >> > This isn't a solution at all, rather a workaround and a poor one for that
> >> > matter.
> >>
> >> Yes, which is what started me on this series.
> >>
> >> >> This patch series implements an alternative solution, where each
> >> >> cpu will wait in the WFI state until all cpus are ready to enter
> >> >> a coupled state, at which point the coupled state function will
> >> >> be called on all cpus at approximately the same time.
> >> >>
> >> >> Once all cpus are ready to enter idle, they are woken by an smp
> >> >> cross call.
> >> >
> >> > Is it really necessary to wake up all of the CPUs in WFI before
> >> > going to deeper idle?  We should be able to figure out when they
> >> > are going to be needed next time without waking them up and we should
> >> > know the latency to wake up from the deeper multi-CPU "C-state",
> >> > so it should be possible to decide whether or not to go to deeper
> >> > idle without the SMP cross call.  Is there anything I'm missing here?
> >>
> >> The decision to go to the lower state has already been made when the
> >> cross call occurs.  On the platforms I have worked directly with so
> >> far (Tegra2 and OMAP4460), the secondary cpu needs to execute code
> >> before the primary cpu turns off the power.  For example, on OMAP4460,
> >> the secondary cpu needs to go from WFI (clock gated) to OFF (power
> >> gated), because OFF is not supported as an individual cpu state due to
> >> a ROM code bug.  To do that transition, it needs to come out of WFI,
> >> set up it's power domain registers, save a bunch of state, and
> >> transition to OFF.
> >>
> >> On Tegra3, the deepest individual cpu state for cpus 1-3 is OFF, the
> >> same state the cpu would go into as the first step of a transition to
> >> a deeper power state (cpus 0-3 OFF).  It would be more optimal in that
> >> case to bypass the SMP cross call, and leave the cpu in OFF, but that
> >> would require some way of disabling all wakeups for the secondary cpus
> >> and then verifying that they didn't start waking up just before the
> >> wakeups were disabled.  I have just started considering this
> >> optimization, but I don't see anything in the existing code that would
> >> prevent adding it later.
> >
> > OK
> >
> >> A simple measurement using the tracing may show that it is
> >> unnecessary.  If the wakeup time for CPU1 to go from OFF to active is
> >> small there might be no need to optimize out the extra wakeup.
> >
> > I see.
> >
> > So, in the end, it may always be more straightforward to put individual
> > CPU cores into single-core idle states until the "we can all go to
> > deeper idle" condition is satisfied and then wake them all up and let
> > each of them do the transition individually, right?
> 
> Yes, the tradeoff will be the complexity of code to handle a generic
> way of holding another cpu in idle while this cpu does the transition
> vs. the time and power required to bring a cpu back online just to put
> it into a deeper state.  Right now, since all the users of this code
> are using WFI for their intermediate state, it takes microseconds to
> bring a cpu back up.  On Tegra3, the answer might be "sometimes" -
> only cpu0 can perform the final idle state transition, so if cpu1 is
> the last to go to idle, it will always have to SMP cross call to cpu0,
> but if cpu0 is the last to go idle it may be able to avoid waking up
> cpu1.

Having considered this for a while I think that it may be more straightforward
to avoid waking up the already idled cores.

For instance, say we have 4 CPU cores in a cluster (package) such that each
core has its own idle state (call it C1) and there is a multicore idle state
entered by turning off the entire cluster (call this state C-multi).  One of
the possible ways to handle this seems to be to use an identical table of
C-states for each core containing the C1 entry and a kind of fake entry called
(for example) C4 with the time characteristics of C-multi and a special
.enter() callback.  That callback will prepare the core it is called for to
enter C-multi, but instead of simply turning off the whole package it will
decrement a counter.  If the counte happens to be 0 at this point, the
package will be turned off.  Otherwise, the core will be put into the idle
state corresponding to C1, but it will be ready for entering C-multi at
any time. The counter will be incremented on exiting the C4 "state".

It looks like this should work without modifying the cpuidle core, but
the drawback here is that the cpuidle core doesn't know how much time
spend in C4 is really in C1 and how much of it is in C-multi, so the
statistics reported by it won't reflect the real energy usage.

Thanks,
Rafael
