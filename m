Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0HQIFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:05:49 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:52448 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0HQIFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:05:45 -0400
Subject: Wakelocks Rebooted - Power management for embedded devices
From: Igor Stoppa <igor.stoppa@nokia.com>
To: Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:40:35 +0300
Message-ID: <1282034436.13642.1115.camel@vimes.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
as discussed during the power management mini-summit in Boston 1ast week
at linuxcon [1] I'd like to reboot the discussion about power management
on embedded linux devices - mostly focusing on handhelds.

The previous discussion was focused on getting a certain implementation
integrated and has certainly been useful to rise the overall level of
awareness about battery-constrained systems.

Many people have commented about how it should have started and evolved,
so I'll try to follow those words of wisdom :-)



High level goals:
-----------------

1) Preserve power and performance behavior over time
Iow the system should not age, even after installing random apps with
different level of power friendliness.

2) Easy development of pm-friendly apps (different from pm-aware)
Most simple apps are anyway active only when visible on the screen.
(I am assuming that, given the specific device implementation, the vast
majority of apps will be written from scratch, rather than ported, to
better integrate with the rest of the system.)

3) Easy identification of problematic apps (those that do not conform to
the desired behavior on a certain platform/configuration)


Implementation requirements:
----------------------------

a) Keep separate policies from mechanisms to ensure cross platform
portability of high level policies
      eg: screen on
		high level constraint: max latency in UI
		low level constraint:  min frequency 

        the former is portable, the latter is not

b) Avoid introducing platform-specific knowledge / dependency in generic
applications, eg. knowledge about "suspend".
This doesn't exclude explicit management of context save/restore, but
the application should not concern itself with the way a certain
platform implements power saving.



Problems/Gaps identified so far:
--------------------------------

I will not replicate Paul McKenney's effort to summarize all the
discussion on suspend blockers (btw thanks for the great work!), however
something received less attention than it deserved imo: runtime tracing
of system hogs.

How to make the system to idle and how to make sure it stays there can
be implemented in different ways, but in any case it is necessary to
track the usage of system resources.

I)  Present solutions seem to focus mostly on the CPU/SoC, while it
would be better if the whole system was accountable for power
consumption - meaning that CPU wakeups are accounted, but also other
power sinks (eg. 3G radio) are accounted ad well.

II) Even when analyzing the SoC, rather than other discrete components,
there is the problem that the same IP block might have different power
impact on the system, depending on the way it is wired in a specific SoC
(clock distribution, power rails, etc) and its activity should be
weighted in a system specific way, without introducing such notion in
the driver itself.

This seems to converge in the discussion initiated by Paul Walmsley and
Kevin Hilman [1] wrt "omap bus" approach where the bus structures could,
amongst other information, also store the correlation between device
state and power consumption.

III) A common way to address device states and states transitions vs
time seems to be missing.
This would allow to expose runtime statistics (through relay-fs, for
example) of residence in a certain state - similarly to what powertop
does for x86 processors.

IV) Also performance modes might benefit from being exposed in a
consistent way which doesn't stop at active/inactive, but can express
also the device specific states.
examples: 
* touch screen sampling rate affects both accuracy and power consumption
* HW audio codec where different ifle states have different latencies


Some Thoughts:
--------------

* The suspend-based approach doesn't seem to fit our design/approach,
but otoh if we make it easy enough for developers to improve/fix their
code when dealing with runtime idle, by exposing causes for not hitting
low power states, the number of power unfriendly apps will just dwindle
down.
Typically such fixes have also significant impact on performance, so
they are not desirable just from a use-time pov.

* Introducing a mechanism to prevent power unfriendly apps from ruining
the overall system performance/use-time seems tp be the way to go (this
might have both an automatic mode and a user-interactive mode), so long
as the user can express what he wants and gets it (which might depend on
what is considered to be paramount in a specific situation)

* In practice it seems unlikely that the applications to be made
available by 3rd parties will be ported existing legacy PC code, but
rather new apps that will be written and targeted to mobile devices.

Yes, there are plenty of examples that contradict my statement, however
observing the population of a typical app-store, most of the
applications are relatively simple and specifically designed to look
nice on a mobile screen.
And even for ported apps, if there are no platform specific APIs (like
suspend blockers), bugfixes can be contributed back to the upstream
project.

* Most of the requirements described in the Android discussion can
actually be handled in userspace because they involve some slowly
evolving phenomenon (typically mode transitions, such as screen on/off)
with no strict time constraint.
We roughly share the same needs/constraints.

* I see lots of potential overlapping wrt tracking/controlling the state
of the system, iow defining the kernel interfaces, while the userspace
implementation could significantly depend on the philosophy followed by
the system integrator.

* the same interfaces could be shared also with other tools currently
used for more static analysis, like powertop, timechart, etc [2]

* MeeGo/Maemo already have a user space policy manager (currently used
for audio routing and cgroup policies) that could be leveraged also for
this sort of power policies.
Raphael was also thinking about a userspace policy manager and albeit
I'm not familiar with Android, I believe it must have something similar
for dealing with bytecode-based apps and their constraints (feedback
from people with better knowledge would be appreciated).

* I wasn't able to locate a complete list of Android goals/requirements;
having such information - coming straight from the source - would
improve the chances of mutual understanding.

* I would welcome people from silicon companies to participate in the
discussion, since they have the best understanding of the real impact of
a certain power saving implementation on the SoC performance.



cheers, igor


[1]
https://lists.linux-foundation.org/pipermail/linux-pm/2010-August/028229.html

[2]
http://blog.fenrus.org/


