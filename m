Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1AGUpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:45:38 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:33141 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1AGUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:45:36 -0500
Date: Fri, 07 Jan 2011 15:45:18 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] acpi: Use ACPI C-state type instead of enumeration
 value to export cpuidle state name
In-reply-to: <1294396190-23031-2-git-send-email-trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101071529100.20609@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-2-git-send-email-trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Thomas Renninger wrote:

> In the former /proc/acpi/processor/power/* there were Cx showing the
> enumerated number/amount of C-states and type[Cy] which is
> what should get shown as the cpuidle state name.
> 
> Typically on latest Nehalem and later CPUs, BIOS vendors miss
> out C2 and C3 wrongly shows up as C2.

I think this patch will cause more confusion than it will fix.

It assumes that all states of type C2 should have the name "C2"
and all the states of type "C3" should have the name "C3".
But some systems may have more than one state of each type...

also, the state->name is somewhat arbitrary.

You'll notice that intel_idle uses the hardware C-state names
such as NHM-C1, NHM-C3, NHM-C6 - to match the (arbitrary)
names in the hardware documentation.  We could call those
states Moe/Larry/Curley just as well.

If somebody wants to know what the state _is_,
then the state->desc field shows them in un-ambiguous
terms, "MWAIT 0x10" etc.

if somebody wants to simply enumerate the states,
so they can use acpi.max_cstate=N, for example, then
cpuidle already enumerates them in 
/sys/devices/system/cpu/cpu0/cpuidle/state%d

thanks,
Len Brown, Intel Open Source Technology Center

ps. the thing about "mising C2".  That isn't a bug.
That is actually BIOS writer's attempt to not break
the installed base of Linux.  NHM doesn't actually
have any ACPI C3-type states, just C2-type states.
But in NHM, the LAPIC timer stops in C2-type states,
so the BIOS advertises them as C2-type to make sure
that an old version of Linux doesn't attempt to
use the LAPIC timer in those states.
(we switched to not trusting the LAPIC timer even
in C2-type states a while back, but the installed
base never gets updated)

pps. I do think we need to be able to dump
the _CST, as we lost the ACPI type info that
was in /proc/acpi/processor/*/power and we
may need it to debug some systems.

> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: arjan@linux.intel.com
> CC: lenb@kernel.org
> CC: linux-acpi@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/acpi/processor_idle.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index dcb38f8..104ae77 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1008,7 +1008,6 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>  #endif
>  		cpuidle_set_statedata(state, cx);
>  
> -		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
>  		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
>  		state->exit_latency = cx->latency;
>  		state->target_residency = cx->latency * latency_factor;
> @@ -1016,6 +1015,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>  		state->flags = 0;
>  		switch (cx->type) {
>  			case ACPI_STATE_C1:
> +			snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
>  			state->flags |= CPUIDLE_FLAG_SHALLOW;
>  			if (cx->entry_method == ACPI_CSTATE_FFH)
>  				state->flags |= CPUIDLE_FLAG_TIME_VALID;
> @@ -1025,6 +1025,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>  			break;
>  
>  			case ACPI_STATE_C2:
> +			snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
>  			state->flags |= CPUIDLE_FLAG_BALANCED;
>  			state->flags |= CPUIDLE_FLAG_TIME_VALID;
>  			state->enter = acpi_idle_enter_simple;
> @@ -1032,6 +1033,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>  			break;
>  
>  			case ACPI_STATE_C3:
> +			snprintf(state->name, CPUIDLE_NAME_LEN, "C3");
>  			state->flags |= CPUIDLE_FLAG_DEEP;
>  			state->flags |= CPUIDLE_FLAG_TIME_VALID;
>  			state->flags |= CPUIDLE_FLAG_CHECK_BM;
> -- 
> 1.7.3.1
> 
