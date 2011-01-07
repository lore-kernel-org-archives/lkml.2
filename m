Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1AGF4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:56:31 -0500
Received: from smtp.nokia.com ([147.243.1.48]:29532 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1AGF4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:56:30 -0500
Date: Fri, 7 Jan 2011 07:50:42 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext jean.pihet@newoldbits.com" <jean.pihet@newoldbits.com>
Cc: mingo@elte.hu, trenn@suse.de, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/2] tools, perf: Documentation for the power events API
Message-ID: <20110107055042.GA6137@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1294253342-29056-1-git-send-email-j-pihet@ti.com>
 <1294253342-29056-3-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294253342-29056-3-git-send-email-j-pihet@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Wed, Jan 05, 2011 at 07:49:02PM +0100, ext jean.pihet@newoldbits.com wrote:
> From: Jean Pihet <j-pihet@ti.com>
> 
> Provides documentation for the following:
> - the new power trace API,
> - the old (legacy) power trace API,
> - the DEPRECATED Kconfig option usage.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> ---
>  Documentation/trace/events-power.txt |   90 ++++++++++++++++++++++++++++++++++
>  1 files changed, 90 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/trace/events-power.txt
> 
> diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
> new file mode 100644
> index 0000000..96d87b6
> --- /dev/null
> +++ b/Documentation/trace/events-power.txt
> @@ -0,0 +1,90 @@
> +
> +			Subsystem Trace Points: power
> +
> +The power tracing system captures events related to power transitions
> +within the kernel. Broadly speaking there are three major subheadings:
> +
> +  o Power state switch which reports events related to suspend (S-states),
> +     cpuidle (C-states) and cpufreq (P-states)
> +  o System clock related changes

What do you mean by system clock here? I see that you are covering cpu rate
changes and system clock (?) here. How about memory clock changes?
Would it make sense to have a major subheading for it? Maybe you are
targeting it be traced by means of clocks event (item 2. bellow)..

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
> +1.1 New trace API
> +-----------------
> +
> +A 'cpu' event class gathers the CPU-related events: cpuidle and
> +cpufreq.
> +
> +cpu_idle		"state=%lu cpu_id=%lu"
> +cpu_frequency		"state=%lu cpu_id=%lu"
> +
> +A suspend event is used to indicate the system going in and out of the
> +suspend mode:
> +
> +machine_suspend		"state=%lu"
> +
> +
> +Note: the value of '-1' or '4294967295' for state means an exit from the current state,
> +i.e. trace_cpu_idle(4, smp_processor_id()) means that the system
> +enters the idle state 4, while trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id())
> +means that the system exits the previous idle state.
> +
> +The event which has 'state=4294967295' in the trace is very important to the user
> +space tools which are using it to detect the end of the current state, and so to
> +correctly draw the states diagrams and to calculate accurate statistics etc.
> +
> +1.2 DEPRECATED trace API
> +------------------------
> +
> +A new Kconfig option CONFIG_EVENT_POWER_TRACING_DEPRECATED with the default value of
> +'y' has been created. This allows the legacy trace power API to be used conjointly
> +with the new trace API.
> +The Kconfig option, the old trace API (in include/trace/events/power.h) and the
> +old trace points will disappear in a future release (namely 2.6.41).
> +
> +power_start		"type=%lu state=%lu cpu_id=%lu"
> +power_frequency		"type=%lu state=%lu cpu_id=%lu"
> +power_end		"cpu_id=%lu"
> +
> +The 'type' parameter takes one of those macros:
> + . POWER_NONE	= 0,
> + . POWER_CSTATE	= 1,	/* C-State */
> + . POWER_PSTATE	= 2,	/* Fequency change or DVFS */
> +
> +The 'state' parameter is set depending on the type:
> + . Target C-state for type=POWER_CSTATE,
> + . Target frequency for type=POWER_PSTATE,
> +
> +power_end is used to indicate the exit of a state, corresponding to the latest
> +power_start event.
> +
> +2. Clocks events
> +================
> +The clock events are used for clock enable/disable and for
> +clock rate change.
> +
> +clock_enable		"%s state=%lu cpu_id=%lu"
> +clock_disable		"%s state=%lu cpu_id=%lu"
> +clock_set_rate		"%s state=%lu cpu_id=%lu"
> +
> +The first parameter gives the clock name (e.g. "gpio1_iclk").
> +The second parameter is '1' for enable, '0' for disable, the target
> +clock rate for set_rate.
> +
> +3. Power domains events
> +=======================
> +The power domain events are used for power domains transitions
> +
> +power_domain_target	"%s state=%lu cpu_id=%lu"
> +
> +The first parameter gives the power domain name (e.g. "mpu_pwrdm").
> +The second parameter is the power domain target state.
> +
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Eduardo Valentin
