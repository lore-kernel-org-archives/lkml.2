Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1AIM36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 07:29:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1AIM34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 07:29:56 -0500
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/9] acpi: Use ACPI C-state type instead of enumeration value to export cpuidle state name
Date: Sun, 9 Jan 2011 13:30:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <1294396190-23031-2-git-send-email-trenn@suse.de> <alpine.LFD.2.02.1101071529100.20609@x980>
In-Reply-To: <alpine.LFD.2.02.1101071529100.20609@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091330.12027.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 January 2011 21:45:18 Len Brown wrote:
> On Fri, 7 Jan 2011, Thomas Renninger wrote:
> 
> > In the former /proc/acpi/processor/power/* there were Cx showing the
> > enumerated number/amount of C-states and type[Cy] which is
> > what should get shown as the cpuidle state name.
> > 
> > Typically on latest Nehalem and later CPUs, BIOS vendors miss
> > out C2 and C3 wrongly shows up as C2.
> 
> I think this patch will cause more confusion than it will fix.
> 
> It assumes that all states of type C2 should have the name "C2"
> and all the states of type "C3" should have the name "C3".
Right.
> But some systems may have more than one state of each type...
Exported through ACPI tables?
 
> also, the state->name is somewhat arbitrary.
> 
> You'll notice that intel_idle uses the hardware C-state names
> such as NHM-C1, NHM-C3, NHM-C6 - to match the (arbitrary)
> names in the hardware documentation.  We could call those
> states Moe/Larry/Curley just as well.
That works out with HW specific intel_idle.c driver, but not
with the generic acpi/processor one.

> If somebody wants to know what the state _is_,
> then the state->desc field shows them in un-ambiguous
> terms, "MWAIT 0x10" etc.
Right, people can/should use it for additional info.

> if somebody wants to simply enumerate the states,
> so they can use acpi.max_cstate=N, for example, then
> cpuidle already enumerates them in 
> /sys/devices/system/cpu/cpu0/cpuidle/state%d
Not sure I get this.
Currently you have:
/sys/../stateX/...
/sys/devices/system/cpu/cpu0/cpuidle/state%d/name
and stateX (the directory name) and stateX/name contain
duplicate info:
X and CX.
in acpi cpuidle driver case.
While the C-state type as exported by BIOS may not always
be correct, it contains more info as the current approach, which
has zero info.

The other ACPI related patches are ok?
What do you think of cpu_idle events thrown as real cpuidle
subsystem events to make them architecture independent and
break up the unnecessary complexity (intel_idle throws the
idle start and cpuidle the end event, etc.).

> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> ps. the thing about "mising C2".  That isn't a bug.
> That is actually BIOS writer's attempt to not break
> the installed base of Linux.  NHM doesn't actually
> have any ACPI C3-type states, just C2-type states.
> But in NHM, the LAPIC timer stops in C2-type states,
> so the BIOS advertises them as C2-type to make sure
> that an old version of Linux doesn't attempt to
> use the LAPIC timer in those states.
> (we switched to not trusting the LAPIC timer even
> in C2-type states a while back, but the installed
> base never gets updated)
> 
> pps. I do think we need to be able to dump
> the _CST, as we lost the ACPI type info that
> was in /proc/acpi/processor/*/power and we
> may need it to debug some systems.
?
I restore the ACPI type info as exported by ACPI tables
with this patch, should be the same as done with
/proc/acpi/processor/*/power
Do I miss something?
Do you want to export additional ACPI table C-state
info?

Something else, but related:
You recently said that it might be a good idea to get
C-/P- state ACPI tables which are often in a separate
SSDT loaded at runtime via "load" ACPI command, dumped
with the acpidump  tool. This would be a cool feature.
Does dynamically loaded SSDT dumping
via acpidump work already or is/has someone looked at this?

Thanks,

     Thomas

> 
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > CC: arjan@linux.intel.com
> > CC: lenb@kernel.org
> > CC: linux-acpi@vger.kernel.org
> > CC: linux-kernel@vger.kernel.org
> > ---
> >  drivers/acpi/processor_idle.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> > index dcb38f8..104ae77 100644
> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -1008,7 +1008,6 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
> >  #endif
> >  		cpuidle_set_statedata(state, cx);
> >  
> > -		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
> >  		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
> >  		state->exit_latency = cx->latency;
> >  		state->target_residency = cx->latency * latency_factor;
> > @@ -1016,6 +1015,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
> >  		state->flags = 0;
> >  		switch (cx->type) {
> >  			case ACPI_STATE_C1:
> > +			snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
> >  			state->flags |= CPUIDLE_FLAG_SHALLOW;
> >  			if (cx->entry_method == ACPI_CSTATE_FFH)
> >  				state->flags |= CPUIDLE_FLAG_TIME_VALID;
> > @@ -1025,6 +1025,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
> >  			break;
> >  
> >  			case ACPI_STATE_C2:
> > +			snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
> >  			state->flags |= CPUIDLE_FLAG_BALANCED;
> >  			state->flags |= CPUIDLE_FLAG_TIME_VALID;
> >  			state->enter = acpi_idle_enter_simple;
> > @@ -1032,6 +1033,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
> >  			break;
> >  
> >  			case ACPI_STATE_C3:
> > +			snprintf(state->name, CPUIDLE_NAME_LEN, "C3");
> >  			state->flags |= CPUIDLE_FLAG_DEEP;
> >  			state->flags |= CPUIDLE_FLAG_TIME_VALID;
> >  			state->flags |= CPUIDLE_FLAG_CHECK_BM;
> > -- 
> > 1.7.3.1
> > 
> 

