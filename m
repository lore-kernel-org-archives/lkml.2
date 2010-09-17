Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0IQOFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:05:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35854 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0IQOFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:05:53 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.150.144]
In-Reply-To: <201009171508.46471.trenn@suse.de>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<20100909075403.GA10798@elte.hu>
	<AANLkTimCy8pB6JZ2bkGutTou8-oXc1yjweqCxVrLw=Kk@mail.gmail.com>
	<201009171508.46471.trenn@suse.de>
Date: Fri, 17 Sep 2010 16:05:51 +0200
Message-ID: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Sep 17, 2010 at 3:08 PM, Thomas Renninger <trenn@suse.de> wrote:
> Hi,
>
> I had a quick look at this and it's amazing how broken
> the whole power event tracing interfaces are.
> It's not your fault, Jean, they always were and adding your stuff is
> fine.
That is the whole point! This code needs a serious clean-up and reorganization.
The patch I submitted is now merged in the tip tree, but the can be
corrected once the new power trace API is agreed on.

> Some questions, maybe I've overseen something:
>
> Why does this event:
> DEFINE_EVENT(power, power_frequency,
> exist and takes a C-/P-state, now also an S-state type as argument?
There is no clear link between the POWER_ types enum and the API, that
needs to change.

> It should be named more generic, like:
> DEFINE_EVENT(power, power_switch,
> then it could get invoked when any P-/C-/S-/X- state
> switch happened.
Agree. We need some better definitions for the events and at the same
time a more flexible way to pass extra arguments (e.g. like a return
code or the real HW state in case the desired state is not reached).
Also it is required to be able to track sub-states.
The idea is to identify the C-states latency in the low power entry
and exit paths, using 2 new macros in the enum and a sub state
argument. Cf. http://omappedia.org/images/b/b9/Pytimechart_screenshot9_rs.jpg
(from http://omappedia.org/wiki/Power_Management_Debug_and_Profiling).

> What kind of hack is this:
> TRACE_EVENT(power_end,
> showing up as:
> power_end: dummy=65535
> What ends here?
> I know it's a workaround/hack for userspace apps to be
> able to detect leaving of a sleep state, but how would someone
> know or how would someone describe this in a proper API documentation?
That was a hack, it is now gone. The new power_end only takes the
cpu_id argument.

> Apropos documentation..., are the power trace events documented
> somewhere?
No. We need something like Documentation/trace/events-kmem.txt. I can
write that with for the new power API.

> At least the state should still be passed, then the _start/_end thing
> can be reused by something else than C-states.
>
> I can't see the use of having _start/_end events at all.
> You are always in a state, having one:
> power_switch
> as suggested above, is enough to track everything.
Most of the events can be converted to power_switch, but not all.
Example: you need to know when the suspend ends.

>
> Examples:
>
> Today's C-state tracking:
> power_start: type=1 state=1  -> C1 entered
> power_end: dummy=65535       -> C-state left
> power_start: type=1 state=2  -> C2 entered
> power_end: dummy=65535       -> C-state left
> would then be:
> power_switch: type=1 state=1  -> C1 entered
> power_switch: type=1 state=0  -> C0 entered -> means C1 left...
> power_switch: type=1 state=2  -> C2 entered
> power_switch: type=1 state=0  -> C0 entered -> means C2 left...
> ...
>
> Todays P-state tracking:
> power_frequency: type=2 state=125000000     -> P-state change to 125 MHz
> power_frequency: type=2 state=90000000      -> P-state change to 90 MHz
> would then be:
> power_switch: type=2 state=125000000       -> P-state change to 125 MHz
> power_switch: type=2 state=90000000        -> P-state change to 90 MHz
>
> The S-state and T-state tracking would fit into that without
> modification.
> Thinking one step further, a possibility to track D-states would
What are the T- and D- states?

> need an additional field, a pointer to the device, best a sysfs path
> or similar.
Agree on that. As said above I would like to have extra args.

> Jean, I do not think tracing the S-state with power_start is a
> good idea. Best would be the power_frequency gets renamed

>(yes, breaks
> userspace, but those have to be adjusted)
BTW I can patch pytimechart. What other tools have to change? powertop ...?

> and used for P- and S-
> state tracking (and C-state tracking as well, but this would need
> additional userspace modifications).
OK

> How do you track when the S-states end?
Two options: 1) have new arguments that indicates enter/exit and a
sub-state; 2) a new event fot the exit.
I am in favor of 1 which is more generic.

Ok thanks for those remarks and suggetions.
Let me come back soon with a new power API proposal.

>
>        Thomas
>

Jean
