Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0IQP3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:29:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0IQP3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:29:10 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 17 Sep 2010 17:29:02 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009171508.46471.trenn@suse.de> <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
In-Reply-To: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171729.02569.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 September 2010 16:05:51 Jean Pihet wrote:
> Hi Thomas,
> 
> On Fri, Sep 17, 2010 at 3:08 PM, Thomas Renninger <trenn@suse.de> wrote:
> > Hi,
> >
> > I had a quick look at this and it's amazing how broken
> > the whole power event tracing interfaces are.
> > It's not your fault, Jean, they always were and adding your stuff is
> > fine.
> That is the whole point! This code needs a serious clean-up and reorganization.
> The patch I submitted is now merged in the tip tree, but the can be
> corrected once the new power trace API is agreed on.
Your generic patch is ok. Not that sure about the clock stuff.
How many different clocks do exist on ARM/OMAP?
Possibly this can all go into a:
power_switch_state(type=, state=)
interface and you define some ARM specific static ones like:
+       POWER_NONE      = 0,
+       POWER_CSTATE    = 1,    /* C-State */
+       POWER_PSTATE    = 2,    /* Fequency change or DVFS */
+       POWER_SSTATE    = 3,    /* Suspend */
+       POWER_OMAP_CLOCK_1   = 4,    /* OMAP clock XY */
+       POWER_OMAP_CLOCK_2   = 5,    /* OMAP clock XYZ */
...
> 
> > Some questions, maybe I've overseen something:
> >
> > Why does this event:
> > DEFINE_EVENT(power, power_frequency,
> > exist and takes a C-/P-state, now also an S-state type as argument?
> There is no clear link between the POWER_ types enum and the API, that
> needs to change.
Yep. At least for the frequency (P-state) and idle (C-state) states
I have a reasonable solution, see below.
> 
> > It should be named more generic, like:
> > DEFINE_EVENT(power, power_switch,
> > then it could get invoked when any P-/C-/S-/X- state
> > switch happened.
> Agree. We need some better definitions for the events and at the same
> time a more flexible way to pass extra arguments (e.g. like a return
> code or the real HW state in case the desired state is not reached).
> Also it is required to be able to track sub-states.
> The idea is to identify the C-states latency in the low power entry
> and exit paths, using 2 new macros in the enum and a sub state
> argument. Cf. http://omappedia.org/images/b/b9/Pytimechart_screenshot9_rs.jpg
> (from http://omappedia.org/wiki/Power_Management_Debug_and_Profiling).
IMO one does not need an exit path, see below.
 
> > What kind of hack is this:
> > TRACE_EVENT(power_end,
> > showing up as:
> > power_end: dummy=65535
> > What ends here?
> > I know it's a workaround/hack for userspace apps to be
> > able to detect leaving of a sleep state, but how would someone
> > know or how would someone describe this in a proper API documentation?
> That was a hack, it is now gone. The new power_end only takes the
> cpu_id argument.
The CPU/machine/device always is in a C-/P-/T-/S- whatever state.
Typically 0 means it's in a non-power saving state.
So issueing a power_switch_state(type=X, state=0)
would be the exit path. There is no need for a separate:
power_end(type=X) call.
Compare with my S-state ACPI example, I'll send in a minute.

> > Apropos documentation..., are the power trace events documented
> > somewhere?
> No. We need something like Documentation/trace/events-kmem.txt. I can
> write that with for the new power API.
> 
> > At least the state should still be passed, then the _start/_end thing
> > can be reused by something else than C-states.
> >
> > I can't see the use of having _start/_end events at all.
> > You are always in a state, having one:
> > power_switch
> > as suggested above, is enough to track everything.
> Most of the events can be converted to power_switch, but not all.
> Example: you need to know when the suspend ends.
power_switch_state(type=POWER_SSTATE, state=0)

> >
> > Examples:
> >
> > Today's C-state tracking:
> > power_start: type=1 state=1  -> C1 entered
> > power_end: dummy=65535       -> C-state left
> > power_start: type=1 state=2  -> C2 entered
> > power_end: dummy=65535       -> C-state left
> > would then be:
> > power_switch: type=1 state=1  -> C1 entered
> > power_switch: type=1 state=0  -> C0 entered -> means C1 left...
> > power_switch: type=1 state=2  -> C2 entered
> > power_switch: type=1 state=0  -> C0 entered -> means C2 left...
> > ...
> >
> > Todays P-state tracking:
> > power_frequency: type=2 state=125000000     -> P-state change to 125 MHz
> > power_frequency: type=2 state=90000000      -> P-state change to 90 MHz
> > would then be:
> > power_switch: type=2 state=125000000       -> P-state change to 125 MHz
> > power_switch: type=2 state=90000000        -> P-state change to 90 MHz
> >
> > The S-state and T-state tracking would fit into that without
> > modification.
> > Thinking one step further, a possibility to track D-states would
> What are the T- and D- states?
T-states are processor throttling. Should only get used in critical
thermal conditions, fits nice into this interface.

D-states are device states, defined in ACPI from D0 (no power savings
active, up to D3 (max powersavings active). It's up to the device what
it's doing with it.
This one does not fit into a generic power_switch_state, because:
   - you want a connection to the device exported
   - possibly you want to be smarter than ACPI and tell what exactly
     a device switches off.
I'd leave device specific events out of the discussion for now.

> > need an additional field, a pointer to the device, best a sysfs path
> > or similar.
> Agree on that. As said above I would like to have extra args.
> 
> > Jean, I do not think tracing the S-state with power_start is a
> > good idea. Best would be the power_frequency gets renamed
> 
> >(yes, breaks
> > userspace, but those have to be adjusted)
> BTW I can patch pytimechart. What other tools have to change? powertop ...?
That would be great.
AFAIK the code use trace/perf events in powertop is not yet released.

> > and used for P- and S-
> > state tracking (and C-state tracking as well, but this would need
> > additional userspace modifications).
> OK
> 
> > How do you track when the S-states end?
> Two options: 1) have new arguments that indicates enter/exit and a
> sub-state; 2) a new event fot the exit.
> I am in favor of 1 which is more generic.
See above, I'd use:
power_switch_state(type=POWER_SSTATE, state=0)

I'll post patches to get C-states and S-states making use of
a generic:
power_switch_state(...)
function with still providing old events to not break existing
tools.

    Thomas
