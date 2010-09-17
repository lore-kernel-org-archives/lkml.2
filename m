Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0IQNIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:08:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0IQNIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:08:52 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 17 Sep 2010 15:08:45 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <20100909075403.GA10798@elte.hu> <AANLkTimCy8pB6JZ2bkGutTou8-oXc1yjweqCxVrLw=Kk@mail.gmail.com>
In-Reply-To: <AANLkTimCy8pB6JZ2bkGutTou8-oXc1yjweqCxVrLw=Kk@mail.gmail.com>
MIME-Version: 1.0
X-Length: 4445
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171508.46471.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had a quick look at this and it's amazing how broken
the whole power event tracing interfaces are.
It's not your fault, Jean, they always were and adding your stuff is 
fine.

Some questions, maybe I've overseen something:

Why does this event:
DEFINE_EVENT(power, power_frequency,
exist and takes a C-/P-state, now also an S-state type as argument?

It should be named more generic, like:
DEFINE_EVENT(power, power_switch,
then it could get invoked when any P-/C-/S-/X- state
switch happened.

What kind of hack is this:
TRACE_EVENT(power_end,
showing up as:
power_end: dummy=65535
What ends here?
I know it's a workaround/hack for userspace apps to be
able to detect leaving of a sleep state, but how would someone
know or how would someone describe this in a proper API documentation?
Apropos documentation..., are the power trace events documented 
somewhere?

At least the state should still be passed, then the _start/_end thing 
can be reused by something else than C-states.

I can't see the use of having _start/_end events at all.
You are always in a state, having one:
power_switch
as suggested above, is enough to track everything.

Examples:

Today's C-state tracking:
power_start: type=1 state=1  -> C1 entered
power_end: dummy=65535       -> C-state left
power_start: type=1 state=2  -> C2 entered
power_end: dummy=65535       -> C-state left
would then be:
power_switch: type=1 state=1  -> C1 entered
power_switch: type=1 state=0  -> C0 entered -> means C1 left...
power_switch: type=1 state=2  -> C2 entered
power_switch: type=1 state=0  -> C0 entered -> means C2 left...
...

Todays P-state tracking:
power_frequency: type=2 state=125000000     -> P-state change to 125 MHz
power_frequency: type=2 state=90000000      -> P-state change to 90 MHz
would then be:
power_switch: type=2 state=125000000       -> P-state change to 125 MHz
power_switch: type=2 state=90000000        -> P-state change to 90 MHz

The S-state and T-state tracking would fit into that without 
modification.
Thinking one step further, a possibility to track D-states would
need an additional field, a pointer to the device, best a sysfs path
or similar.

Jean, I do not think tracing the S-state with power_start is a
good idea. Best would be the power_frequency gets renamed (yes, breaks
userspace, but those have to be adjusted) and used for P- and S-
state tracking (and C-state tracking as well, but this would need
additional userspace modifications).
How do you track when the S-states end?

        Thomas

