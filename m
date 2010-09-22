Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0IVSuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:50:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab0IVSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 22 Sep 2010 20:49:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009180026.59482.trenn@suse.de> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
In-Reply-To: <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009222049.18154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropping discuss@lesswatts.org from the CC list.]

On Wednesday, September 22, 2010, Jean Pihet wrote:
> Hi,
> 
> Here is a patch that redefines the power events API. The advantages
> are: easier maintainance of the kernel and the
> user space tools, a cleaner and more generic interface, more
> parameters for fine tracing and even documentation!
> 
> Thomas, this patch has your patch above merged in ('power-trace: Use
> power_switch_state instead of power_start and power_end'). The revised
> ACPI patch is coming asap.
> 
> The trace points for x86 and OMAP are also udated accordingly.
> 
> The pytimechart tool needs an update for the new API. This can be done
> as soon as the kernel code gets merged in.
> Please note the point below about the existing code in builtin-timechart.c.
> 
> On Sat, Sep 18, 2010 at 12:26 AM, Thomas Renninger <trenn@suse.de> wrote:
> > On Friday 17 September 2010 18:24:12 Ingo Molnar wrote:
> >>
> >> * Thomas Renninger <trenn@suse.de> wrote:
> >>
> >> > On Friday 17 September 2010 16:24:59 Ingo Molnar wrote:
> >
> >> [ You dont even have to document it, as good code is self-explanatory ;-) ]
> > I recently posted a patch exporting some things through /sys/kernel/debug/...
> > Greg complained that a file for Documentation/ABI/{testing,stable}/* is missing
> > and I fully agree.
> The proposed patch has the documentation in
> Documentation/trace/events-power.txt.
> 
> > If different userspace apps should make use of this (in above case nobody
> > than my debug userspace tool will...) and this should be called something like an API,
> > it should be documented and if something changes, it should
> > first be marked deprecated, etc.
> Note: the exsiting code in tools/perf/builtin-timechart.c needs an
> update for the new events API. Is this code still maintained? I not,
> could pytimechart be merged in instead?
> 
> Feedback is welcome!
> 
> >
> >     Thomas
> >
> 
> Thanks,
> Jean
> 
> ---
> From f37d1875050d33273b10e99497b4059b37e6680d Mon Sep 17 00:00:00 2001
> From: Jean Pihet <jean.pihet@newoldbits.com>
> Date: Wed, 22 Sep 2010 17:10:47 +0200
> Subject: [PATCH] tools, perf: redefine the power events API
> 
> Redefine the API with:
> - power_switch_state for C-, P- and S-states,
> - clock and power_domain events
> 
> The new API allows easier maintainance of the kernel and the
> user space tools, a cleaner and more generic interface,
> more parameters for fine tracing and even documentation.
> 
> The new events are used by the x86 and OMAP platforms.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> ---
>  Documentation/trace/events-power.txt |   70 +++++++++++++++++++++++++
>  arch/arm/mach-omap2/cpuidle34xx.c    |    3 +
>  arch/arm/mach-omap2/pm34xx.c         |   11 ++++
>  arch/arm/mach-omap2/powerdomain.c    |    3 +
>  arch/arm/plat-omap/clock.c           |   13 ++++-
>  arch/arm/plat-omap/cpu-omap.c        |    3 +
>  arch/x86/kernel/process.c            |   13 +++--
>  arch/x86/kernel/process_32.c         |    3 +-
>  arch/x86/kernel/process_64.c         |    3 +-
>  drivers/cpufreq/cpufreq.c            |    3 +-
>  drivers/cpuidle/cpuidle.c            |    2 +-
>  drivers/idle/intel_idle.c            |    2 +-
>  include/trace/events/power.h         |   95 ++++++++++++++++------------------
>  kernel/trace/power-traces.c          |    2 -
>  14 files changed, 161 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/trace/events-power.txt
> 
> diff --git a/Documentation/trace/events-power.txt
> b/Documentation/trace/events-power.txt
> new file mode 100644
> index 0000000..967f842
> --- /dev/null
> +++ b/Documentation/trace/events-power.txt
> @@ -0,0 +1,70 @@
> +
> +			Subsystem Trace Points: power
> +
> +The power tracing system captures events related to power transitions
> +within the kernel. Broadly speaking there are three major subheadings:
> +
> +  o Power state switch which reports events related to suspend (S-states),
> +     cpuidle (C-states) and cpufreq (P-states)
> +  o System clock related changes
> +  o Power domains related changes and transitions
> +
> +This document describes what each of the tracepoints is and why they
> +might be useful.
> +
> +Cf. include/trace/events/power.h for the events definitions.
> +
> +1. Power state switch events
> +============================
> +
> +power_switch_state	type=%lu state=%lu sub_state=%lu cpu_id=%lu
> +
> +The 'type' parameter takes one of those macros:
> + . POWER_NONE	= 0,
> + . POWER_CSTATE	= 1,	/* C-State */
> + . POWER_PSTATE	= 2,	/* Fequency change or DVFS */
> + . POWER_SSTATE	= 3,	/* Suspend */

This POWER_SSTATE thing seems to be totally artificial and omap-specific.

Why do you want it to be done this way?

Or is the ACPI handling added in the ACPI patch?  In which case, why don't you
put that power_switch_state(POWER_SSTATE, 1, 0, cpu) into
kernel/power/suspend.c:suspend_enter() (and analogously for
power_switch_state(POWER_SSTATE, 0, 0, cpu)).

Moreover, why is the cpu argument necessary for POWER_SSTATE at all?

Thanks,
Rafael
