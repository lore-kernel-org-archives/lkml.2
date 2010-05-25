Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0EYMwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:52:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:56447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab0EYMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:52:41 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: mingo@elte.hu
Subject: Re: [PATCH] x86 cpufreq: Make trace_power_frequency cpufreq driver independent
Date: Tue, 25 May 2010 14:53:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       robert.schoene@tu-dresden.de, cpufreq@vger.kernel.org,
       linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org,
       x86@kernel.org, akpm@linux-foundation.org
References: <1274791199-12335-1-git-send-email-trenn@suse.de>
In-Reply-To: <1274791199-12335-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251453.06111.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

this is in fact a resend. First version was sent on 2010-04-30.
Your comment was:
----
Timechart is maintained by Arjan so we need an ack from him as well.
I've seen some back and forth in the discussions -
what's the technical resolution of that?
----
There was enough time for people to argue on this.
The technical resolution is the patch below.

Can this still be seen in 2.6.34 or does this need x86-tip/linux-next
queuing already (which would be bad...).
This is in 11.3/master OpenSUSE branch kernel for some weeks already.

The checkpatch violation is intended to match the indentation of:
include/trace/events/power.h

Thanks,

   Thomas


On Tuesday 25 May 2010 14:39:59 Thomas Renninger wrote:
> and fix the broken case if a core's frequency depends on others.
> 
> trace_power_frequency was only implemented in a rather ungeneric way
> in acpi-cpufreq driver's target() function only.
> -> Move the call to trace_power_frequency to
>    cpufreq.c:cpufreq_notify_transition() where CPUFREQ_POSTCHANGE
>    notifier is triggered.
>    This will support power frequency tracing by all cpufreq drivers
> 
> trace_power_frequency did not trace frequency changes correctly when
> the userspace governor was used or when CPU cores' frequency depend
> on each other.
> -> Moving this into the CPUFREQ_POSTCHANGE notifier and pass the cpu
>    which gets switched automatically fixes this.
> 
> Robert Schoene provided some important fixes on top of my initial
> quick shot version which are integrated in this patch:
> - Forgot some changes in power_end trace (TP_printk/variable names)
> - Variable dummy in power_end must now be cpu_id
> - Use static 64 bit variable instead of unsigned int for cpu_id
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: davej@redhat.com
> CC: arjan@infradead.org
> CC: linux-kernel@vger.kernel.org
> CC: robert.schoene@tu-dresden.de
> CC: cpufreq@vger.kernel.org
> Tested-by: robert.schoene@tu-dresden.de
> CC: linux-perf-users@vger.kernel.org
> CC: linux-trace-users@vger.kernel.org
> CC: x86@kernel.org
> CC: akpm@linux-foundation.org
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 ---
>  arch/x86/kernel/process.c                  |    8 ++++----
>  drivers/cpufreq/cpufreq.c                  |    3 +++
>  drivers/cpuidle/cpuidle.c                  |    2 +-
>  include/trace/events/power.h               |   27 
+++++++++++++++------------
>  tools/perf/builtin-timechart.c             |   11 ++++++-----
>  6 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c 
b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 1d3cdda..cee5263 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -34,7 +34,6 @@
>  #include <linux/compiler.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> -#include <trace/events/power.h>
>  
>  #include <linux/acpi.h>
>  #include <linux/io.h>
> @@ -324,8 +323,6 @@ static int acpi_cpufreq_target(struct 
cpufreq_policy *policy,
>  		}
>  	}
>  
> -	trace_power_frequency(POWER_PSTATE, data-
>freq_table[next_state].frequency);
> -
>  	switch (data->cpu_feature) {
>  	case SYSTEM_INTEL_MSR_CAPABLE:
>  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e7e3521..787572d 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -371,7 +371,7 @@ static inline int hlt_use_halt(void)
>  void default_idle(void)
>  {
>  	if (hlt_use_halt()) {
> -		trace_power_start(POWER_CSTATE, 1);
> +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
>  		current_thread_info()->status &= ~TS_POLLING;
>  		/*
>  		 * TS_POLLING-cleared state must be visible before we
> @@ -441,7 +441,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
>   */
>  void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
>  {
> -	trace_power_start(POWER_CSTATE, (ax>>4)+1);
> +	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
>  	if (!need_resched()) {
>  		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
>  			clflush((void *)&current_thread_info()->flags);
> @@ -457,7 +457,7 @@ void mwait_idle_with_hints(unsigned long ax, 
unsigned long cx)
>  static void mwait_idle(void)
>  {
>  	if (!need_resched()) {
> -		trace_power_start(POWER_CSTATE, 1);
> +		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
>  		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
>  			clflush((void *)&current_thread_info()->flags);
>  
> @@ -478,7 +478,7 @@ static void mwait_idle(void)
>   */
>  static void poll_idle(void)
>  {
> -	trace_power_start(POWER_CSTATE, 0);
> +	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
>  	local_irq_enable();
>  	while (!need_resched())
>  		cpu_relax();
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 063b218..4ed6657 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -29,6 +29,8 @@
>  #include <linux/completion.h>
>  #include <linux/mutex.h>
>  
> +#include <trace/events/power.h>
> +
>  #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, \
>  						"cpufreq-core", msg)
>  
> @@ -354,6 +356,7 @@ void cpufreq_notify_transition(struct 
cpufreq_freqs *freqs, unsigned int state)
>  
>  	case CPUFREQ_POSTCHANGE:
>  		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
> +                trace_power_frequency(POWER_PSTATE, freqs->new, 
freqs->cpu);
>  		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
>  				CPUFREQ_POSTCHANGE, freqs);
>  		if (likely(policy) && likely(policy->cpu == freqs->cpu))
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 12fdd39..c672f4a 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -95,7 +95,7 @@ static void cpuidle_idle_call(void)
>  	/* give the governor an opportunity to reflect on the outcome */
>  	if (cpuidle_curr_governor->reflect)
>  		cpuidle_curr_governor->reflect(dev);
> -	trace_power_end(0);
> +	trace_power_end(smp_processor_id());
>  }
>  
>  /**
> diff --git a/include/trace/events/power.h 
b/include/trace/events/power.h
> index c4efe9b..35a2a6e 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -18,52 +18,55 @@ enum {
>  
>  DECLARE_EVENT_CLASS(power,
>  
> -	TP_PROTO(unsigned int type, unsigned int state),
> +	TP_PROTO(unsigned int type, unsigned int state, unsigned int 
cpu_id),
>  
> -	TP_ARGS(type, state),
> +	TP_ARGS(type, state, cpu_id),
>  
>  	TP_STRUCT__entry(
>  		__field(	u64,		type		)
>  		__field(	u64,		state		)
> +		__field(	u64,		cpu_id		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->type = type;
>  		__entry->state = state;
> +		__entry->cpu_id = cpu_id;
>  	),
>  
> -	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, 
(unsigned long)__entry->state)
> +	TP_printk("type=%lu state=%lu cpu_id=%lu", (unsigned long)__entry-
>type,
> +		(unsigned long)__entry->state, (unsigned long)__entry-
>cpu_id)
>  );
>  
>  DEFINE_EVENT(power, power_start,
>  
> -	TP_PROTO(unsigned int type, unsigned int state),
> +	TP_PROTO(unsigned int type, unsigned int state, unsigned int 
cpu_id),
>  
> -	TP_ARGS(type, state)
> +	TP_ARGS(type, state, cpu_id)
>  );
>  
>  DEFINE_EVENT(power, power_frequency,
>  
> -	TP_PROTO(unsigned int type, unsigned int state),
> +	TP_PROTO(unsigned int type, unsigned int state, unsigned int 
cpu_id),
>  
> -	TP_ARGS(type, state)
> +	TP_ARGS(type, state, cpu_id)
>  );
>  
>  TRACE_EVENT(power_end,
>  
> -	TP_PROTO(int dummy),
> +	TP_PROTO(unsigned int cpu_id),
>  
> -	TP_ARGS(dummy),
> +	TP_ARGS(cpu_id),
>  
>  	TP_STRUCT__entry(
> -		__field(	u64,		dummy		)
> +		__field(	u64,		cpu_id		)
>  	),
>  
>  	TP_fast_assign(
> -		__entry->dummy = 0xffff;
> +		__entry->cpu_id = cpu_id;
>  	),
>  
> -	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
> +	TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
>  
>  );
>  
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-
timechart.c
> index 5a52ed9..5161619 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -300,8 +300,9 @@ struct trace_entry {
>  
>  struct power_entry {
>  	struct trace_entry te;
> -	s64	type;
> -	s64	value;
> +	u64	type;
> +	u64	value;
> +	u64	cpu_id;
>  };
>  
>  #define TASK_COMM_LEN 16
> @@ -498,13 +499,13 @@ static int process_sample_event(event_t *event, 
struct perf_session *session)
>  			return 0;
>  
>  		if (strcmp(event_str, "power:power_start") == 0)
> -			c_state_start(data.cpu, data.time, pe->value);
> +			c_state_start(pe->cpu_id, data.time, pe->value);
>  
>  		if (strcmp(event_str, "power:power_end") == 0)
> -			c_state_end(data.cpu, data.time);
> +			c_state_end(pe->cpu_id, data.time);
>  
>  		if (strcmp(event_str, "power:power_frequency") == 0)
> -			p_state_change(data.cpu, data.time, pe->value);
> +			p_state_change(pe->cpu_id, data.time, pe->value);
>  
>  		if (strcmp(event_str, "sched:sched_wakeup") == 0)
>  			sched_wakeup(data.cpu, data.time, data.pid, te);
> -- 
> 1.6.3
> 
> 

