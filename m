Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2FZTku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:40:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35187 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2FZTkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:40:49 -0400
Date: Tue, 26 Jun 2012 21:40:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120626194043.GB28495@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <1340280437-7718-2-git-send-email-bp@amd64.org>
 <1340380019.18025.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340380019.18025.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:46:59PM +0200, Peter Zijlstra wrote:
> What about something like so on top of those two microcode_core patches?
> 
> Since we don't have to worry about per-cpu loads, we can do a single
> callback after the entire machine is updated.

Looks simple and neat enough to me, some minor nitpicks below...

> 
> ---
>  arch/x86/include/asm/perf_event.h      |    2 +
>  arch/x86/kernel/cpu/perf_event.c       |   21 +++++++++-----
>  arch/x86/kernel/cpu/perf_event.h       |    4 ++
>  arch/x86/kernel/cpu/perf_event_intel.c |   49 ++++++++++++++++++++++++++++++---
>  arch/x86/kernel/microcode_core.c       |   10 ++++--
>  5 files changed, 72 insertions(+), 14 deletions(-)
> 
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -232,6 +232,7 @@ struct perf_guest_switch_msr {
>  
>  extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>  extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
> +extern void perf_check_microcode(void);
>  #else
>  static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>  {
> @@ -245,6 +246,7 @@ static inline void perf_get_x86_pmu_capa
>  }
>  
>  static inline void perf_events_lapic_init(void)	{ }
> +static inline void perf_check_microcode(void) { }
>  #endif
>  
>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -378,7 +378,7 @@ int x86_pmu_hw_config(struct perf_event
>  		int precise = 0;
>  
>  		/* Support for constant skid */
> -		if (x86_pmu.pebs_active) {
> +		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
>  			precise++;
>  
>  			/* Support for IP fixup */
> @@ -1649,13 +1649,20 @@ static void x86_pmu_flush_branch_stack(v
>  		x86_pmu.flush_branch_stack();
>  }
>  
> +void perf_check_microcode(void)
> +{
> +	if (x86_pmu.check_microcode)
> +		x86_pmu.check_microcode();
> +}
> +EXPORT_SYMBOL_GPL(perf_check_microcode);

Maybe we should call the after-ucode-has-been-updated callback something
like arch_verify_microcode_revision or something similar and move it to
generic x86 code so that other stuff can use it too, in the future...

Although I'm not aware of any other users right about now.

> +
>  static struct pmu pmu = {
>  	.pmu_enable		= x86_pmu_enable,
>  	.pmu_disable		= x86_pmu_disable,
>  
> -	.attr_groups	= x86_pmu_attr_groups,
> +	.attr_groups		= x86_pmu_attr_groups,
>  
> -	.event_init	= x86_pmu_event_init,
> +	.event_init		= x86_pmu_event_init,
>  
>  	.add			= x86_pmu_add,
>  	.del			= x86_pmu_del,
> @@ -1663,11 +1670,11 @@ static struct pmu pmu = {
>  	.stop			= x86_pmu_stop,
>  	.read			= x86_pmu_read,
>  
> -	.start_txn	= x86_pmu_start_txn,
> -	.cancel_txn	= x86_pmu_cancel_txn,
> -	.commit_txn	= x86_pmu_commit_txn,
> +	.start_txn		= x86_pmu_start_txn,
> +	.cancel_txn		= x86_pmu_cancel_txn,
> +	.commit_txn		= x86_pmu_commit_txn,
>  
> -	.event_idx	= x86_pmu_event_idx,
> +	.event_idx		= x86_pmu_event_idx,
>  	.flush_branch_stack	= x86_pmu_flush_branch_stack,
>  };
>  
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -361,6 +361,8 @@ struct x86_pmu {
>  	void		(*cpu_starting)(int cpu);
>  	void		(*cpu_dying)(int cpu);
>  	void		(*cpu_dead)(int cpu);
> +
> +	void		(*check_microcode)(void);
>  	void		(*flush_branch_stack)(void);
>  
>  	/*
> @@ -373,7 +375,7 @@ struct x86_pmu {
>  	 * Intel DebugStore bits
>  	 */
>  	int		bts, pebs;
> -	int		bts_active, pebs_active;
> +	int		bts_active, pebs_active, pebs_broken;

I know you don't like bool's here but maybe make it a bitfield like the
one in perf_event_attr?

>  	int		pebs_record_size;
>  	void		(*drain_pebs)(struct pt_regs *regs);
>  	struct event_constraint *pebs_constraints;
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1714,11 +1714,54 @@ static __init void intel_clovertown_quir
>  	x86_pmu.pebs_constraints = NULL;
>  }
>  
> +static int intel_snb_pebs_broken(int cpu)
> +{
> +	u32 rev = UINT_MAX; /* default to broken for unknown models */
> +
> +	switch (cpu_data(cpu).x86_model) {

cpu_data(cpu) does a per_cpu access three times in this function, maybe
declare a local ptr which saves us the next two derefs... (if the
compiler is not optimizing those, anyway, that is).

> +	case 42: /* SNB */
> +		rev = 0x28;
> +		break;
> +
> +	case 45: /* SNB-EP */
> +		switch (cpu_data(cpu).x86_mask) {
> +		case 6: rev = 0x618; break;
> +		case 7: rev = 0x70c; break;
> +		}
> +	}
> +
> +	return (cpu_data(cpu).microcode < rev);
> +}
> +
> +static void intel_snb_check_microcode(void)
> +{
> +	int pebs_broken = 0;
> +	int cpu;
> +
> +	get_online_cpus();
> +	for_each_online_cpu(cpu)
> +		pebs_broken |= intel_snb_pebs_broken(cpu);

if pebs_broken gets set here not on the last cpu, you could break out of
the loop early instead of iterating to the last cpu.

> +	put_online_cpus();
> +
> +	if (pebs_broken == x86_pmu.pebs_broken)

This is strange, why not:

	if (pebs_broken && x86_pmu.pebs_broken)

?

> +		return;
> +
> +	/*
> +	 * Serialized by the microcode lock..
> +	 */
> +	if (x86_pmu.pebs_broken) {
> +		pr_info("PEBS enabled due to micro-code update\n");
> +		x86_pmu.pebs_broken = 0;
> +	} else {
> +		pr_info("PEBS disabled due to CPU errata, please upgrade micro-code\n");

s/micro-code/microcode/g

> +		x86_pmu.pebs_broken = 1;
> +	}
> +}
> +
>  static __init void intel_sandybridge_quirk(void)
>  {
> -	pr_warn("PEBS disabled due to CPU errata\n");
> -	x86_pmu.pebs = 0;
> -	x86_pmu.pebs_constraints = NULL;
> +	x86_pmu.check_microcode = intel_snb_check_microcode;
> +	intel_snb_check_microcode();
>  }
>  
>  static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -87,6 +87,7 @@
>  #include <asm/microcode.h>
>  #include <asm/processor.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/perf_event.h>
>  
>  MODULE_DESCRIPTION("Microcode Update Driver");
>  MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
> @@ -277,7 +278,6 @@ static int reload_for_cpu(int cpu)
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  	int err = 0;
>  
> -	mutex_lock(&microcode_mutex);
>  	if (uci->valid) {
>  		enum ucode_state ustate;
>  
> @@ -288,7 +288,6 @@ static int reload_for_cpu(int cpu)
>  			if (ustate == UCODE_ERROR)
>  				err = -EINVAL;
>  	}
> -	mutex_unlock(&microcode_mutex);
>  
>  	return err;
>  }
> @@ -309,6 +308,7 @@ static ssize_t reload_store(struct devic
>  		return size;
>  
>  	get_online_cpus();
> +	mutex_lock(&microcode_mutex);
>  	for_each_online_cpu(cpu) {
>  		tmp_ret = reload_for_cpu(cpu);
>  		if (tmp_ret != 0)
> @@ -318,6 +318,9 @@ static ssize_t reload_store(struct devic
>  		if (!ret)
>  			ret = tmp_ret;
>  	}
> +	if (!ret)
> +		perf_check_microcode();
> +	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
>  	if (!ret)
> @@ -557,7 +560,8 @@ static int __init microcode_init(void)
>  	mutex_lock(&microcode_mutex);
>  
>  	error = subsys_interface_register(&mc_cpu_interface);
> -
> +	if (!error)
> +		perf_check_microcode();
>  	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
