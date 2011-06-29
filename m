Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1F2QIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:08:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36816 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1F2QIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:08:52 -0400
Date: Wed, 29 Jun 2011 18:08:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, Will Deacon <will.deacon@arm.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110629160841.GA2032@somewhere>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
 <1309362157-6596-2-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309362157-6596-2-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:42:35PM +0300, Avi Kivity wrote:
> The perf_event overflow handler does not receive any caller-derived
> argument, so many callers need to resort to looking up the perf_event
> in their local data structure.  This is ugly and doesn't scale if a
> single callback services many perf_events.
> 
> Fix by adding a context parameter to perf_event_create_kernel_counter()
> (and derived hardware breakpoints APIs) and storing it in the perf_event.
> The field can be accessed from the callback as event->overflow_handler_context.
> All callers are updated.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

I believe it can micro-optimize ptrace through register_user_hw_breakpoint() because
we could store the index of the breakpoint that way, instead of iterating through 4 slots.

Perhaps it can help in arm too, adding Will in Cc.

But for register_wide_hw_breakpoint, I'm not sure. kgdb is the main user, may be Jason
could find some use of it.

> ---
>  arch/arm/kernel/ptrace.c                |    3 ++-
>  arch/powerpc/kernel/ptrace.c            |    2 +-
>  arch/sh/kernel/ptrace_32.c              |    3 ++-
>  arch/x86/kernel/kgdb.c                  |    2 +-
>  arch/x86/kernel/ptrace.c                |    3 ++-
>  drivers/oprofile/oprofile_perf.c        |    2 +-
>  include/linux/hw_breakpoint.h           |   10 ++++++++--
>  include/linux/perf_event.h              |    4 +++-
>  kernel/events/core.c                    |   21 +++++++++++++++------
>  kernel/events/hw_breakpoint.c           |   10 +++++++---
>  kernel/watchdog.c                       |    2 +-
>  samples/hw_breakpoint/data_breakpoint.c |    2 +-
>  12 files changed, 44 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 9726006..4911c94 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -479,7 +479,8 @@ static struct perf_event *ptrace_hbp_create(struct task_struct *tsk, int type)
>  	attr.bp_type	= type;
>  	attr.disabled	= 1;
>  
> -	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, tsk);
> +	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, NULL,
> +					   tsk);
>  }
>  
>  static int ptrace_gethbpregs(struct task_struct *tsk, long num,
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index cb22024..5249308 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -973,7 +973,7 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
>  								&attr.bp_type);
>  
>  	thread->ptrace_bps[0] = bp = register_user_hw_breakpoint(&attr,
> -							ptrace_triggered, task);
> +					       ptrace_triggered, NULL, task);
>  	if (IS_ERR(bp)) {
>  		thread->ptrace_bps[0] = NULL;
>  		ptrace_put_breakpoints(task);
> diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
> index 3d7b209..930312f 100644
> --- a/arch/sh/kernel/ptrace_32.c
> +++ b/arch/sh/kernel/ptrace_32.c
> @@ -91,7 +91,8 @@ static int set_single_step(struct task_struct *tsk, unsigned long addr)
>  		attr.bp_len = HW_BREAKPOINT_LEN_2;
>  		attr.bp_type = HW_BREAKPOINT_R;
>  
> -		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
> +		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
> +						 NULL, tsk);
>  		if (IS_ERR(bp))
>  			return PTR_ERR(bp);
>  
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index 5f9ecff..473ab53 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -638,7 +638,7 @@ void kgdb_arch_late(void)
>  	for (i = 0; i < HBP_NUM; i++) {
>  		if (breakinfo[i].pev)
>  			continue;
> -		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
> +		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL, NULL);
>  		if (IS_ERR((void * __force)breakinfo[i].pev)) {
>  			printk(KERN_ERR "kgdb: Could not allocate hw"
>  			       "breakpoints\nDisabling the kernel debugger\n");
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 807c2a2..28092ae 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -715,7 +715,8 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
>  		attr.bp_type = HW_BREAKPOINT_W;
>  		attr.disabled = 1;
>  
> -		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
> +		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
> +						 NULL, tsk);
>  
>  		/*
>  		 * CHECKME: the previous code returned -EIO if the addr wasn't
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index 9046f7b..59acf9e 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -79,7 +79,7 @@ static int op_create_counter(int cpu, int event)
>  
>  	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
>  						  cpu, NULL,
> -						  op_overflow_handler);
> +						  op_overflow_handler, NULL);
>  
>  	if (IS_ERR(pevent))
>  		return PTR_ERR(pevent);
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index d1e55fe..6ae9c63 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -73,6 +73,7 @@ static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
>  extern struct perf_event *
>  register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
> +			    void *context,
>  			    struct task_struct *tsk);
>  
>  /* FIXME: only change from the attr, and don't unregister */
> @@ -85,11 +86,13 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
>  extern struct perf_event *
>  register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
>  				perf_overflow_handler_t	triggered,
> +				void *context,
>  				int cpu);
>  
>  extern struct perf_event * __percpu *
>  register_wide_hw_breakpoint(struct perf_event_attr *attr,
> -			    perf_overflow_handler_t triggered);
> +			    perf_overflow_handler_t triggered,
> +			    void *context);
>  
>  extern int register_perf_hw_breakpoint(struct perf_event *bp);
>  extern int __register_perf_hw_breakpoint(struct perf_event *bp);
> @@ -115,6 +118,7 @@ static inline int __init init_hw_breakpoint(void) { return 0; }
>  static inline struct perf_event *
>  register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
> +			    void *context,
>  			    struct task_struct *tsk)	{ return NULL; }
>  static inline int
>  modify_user_hw_breakpoint(struct perf_event *bp,
> @@ -122,10 +126,12 @@ modify_user_hw_breakpoint(struct perf_event *bp,
>  static inline struct perf_event *
>  register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
>  				perf_overflow_handler_t	 triggered,
> +				void *context,
>  				int cpu)		{ return NULL; }
>  static inline struct perf_event * __percpu *
>  register_wide_hw_breakpoint(struct perf_event_attr *attr,
> -			    perf_overflow_handler_t triggered)	{ return NULL; }
> +			    perf_overflow_handler_t triggered,
> +			    void *context)		{ return NULL; }
>  static inline int
>  register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
>  static inline int
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index e0786e3..40264b5 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -855,6 +855,7 @@ struct perf_event {
>  	u64				id;
>  
>  	perf_overflow_handler_t		overflow_handler;
> +	void				*overflow_handler_context;
>  
>  #ifdef CONFIG_EVENT_TRACING
>  	struct ftrace_event_call	*tp_event;
> @@ -978,7 +979,8 @@ extern struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr,
>  				int cpu,
>  				struct task_struct *task,
> -				perf_overflow_handler_t callback);
> +				perf_overflow_handler_t callback,
> +				void *context);
>  extern u64 perf_event_read_value(struct perf_event *event,
>  				 u64 *enabled, u64 *running);
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9efe710..6dd4819 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6150,7 +6150,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  		 struct task_struct *task,
>  		 struct perf_event *group_leader,
>  		 struct perf_event *parent_event,
> -		 perf_overflow_handler_t overflow_handler)
> +		 perf_overflow_handler_t overflow_handler,
> +		 void *context)
>  {
>  	struct pmu *pmu;
>  	struct perf_event *event;
> @@ -6208,10 +6209,13 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  #endif
>  	}
>  
> -	if (!overflow_handler && parent_event)
> +	if (!overflow_handler && parent_event) {
>  		overflow_handler = parent_event->overflow_handler;
> +		context = parent_event->overflow_handler_context;
> +	}
>  
>  	event->overflow_handler	= overflow_handler;
> +	event->overflow_handler_context = context;
>  
>  	if (attr->disabled)
>  		event->state = PERF_EVENT_STATE_OFF;
> @@ -6478,7 +6482,8 @@ SYSCALL_DEFINE5(perf_event_open,
>  		}
>  	}
>  
> -	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
> +	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
> +				 NULL, NULL);
>  	if (IS_ERR(event)) {
>  		err = PTR_ERR(event);
>  		goto err_task;
> @@ -6663,7 +6668,8 @@ err_fd:
>  struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  				 struct task_struct *task,
> -				 perf_overflow_handler_t overflow_handler)
> +				 perf_overflow_handler_t overflow_handler,
> +				 void *context)
>  {
>  	struct perf_event_context *ctx;
>  	struct perf_event *event;
> @@ -6673,7 +6679,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  	 * Get the target context (task or percpu):
>  	 */
>  
> -	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
> +	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
> +				 overflow_handler, context);
>  	if (IS_ERR(event)) {
>  		err = PTR_ERR(event);
>  		goto err;
> @@ -6957,7 +6964,7 @@ inherit_event(struct perf_event *parent_event,
>  					   parent_event->cpu,
>  					   child,
>  					   group_leader, parent_event,
> -					   NULL);
> +				           NULL, NULL);
>  	if (IS_ERR(child_event))
>  		return child_event;
>  	get_ctx(child_ctx);
> @@ -6984,6 +6991,8 @@ inherit_event(struct perf_event *parent_event,
>  
>  	child_event->ctx = child_ctx;
>  	child_event->overflow_handler = parent_event->overflow_handler;
> +	child_event->overflow_handler_context
> +		= parent_event->overflow_handler_context;
>  
>  	/*
>  	 * Precalculate sample_data sizes
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index 086adf2..b7971d6 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -431,9 +431,11 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
>  struct perf_event *
>  register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
> +			    void *context,
>  			    struct task_struct *tsk)
>  {
> -	return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
> +	return perf_event_create_kernel_counter(attr, -1, tsk, triggered,
> +						context);
>  }
>  EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
>  
> @@ -502,7 +504,8 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
>   */
>  struct perf_event * __percpu *
>  register_wide_hw_breakpoint(struct perf_event_attr *attr,
> -			    perf_overflow_handler_t triggered)
> +			    perf_overflow_handler_t triggered,
> +			    void *context)
>  {
>  	struct perf_event * __percpu *cpu_events, **pevent, *bp;
>  	long err;
> @@ -515,7 +518,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
>  	get_online_cpus();
>  	for_each_online_cpu(cpu) {
>  		pevent = per_cpu_ptr(cpu_events, cpu);
> -		bp = perf_event_create_kernel_counter(attr, cpu, NULL, triggered);
> +		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
> +						      triggered, context);
>  
>  		*pevent = bp;
>  
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 3d0c56a..0aaa41f 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -371,7 +371,7 @@ static int watchdog_nmi_enable(int cpu)
>  	/* Try to register using hardware perf events */
>  	wd_attr = &wd_hw_attr;
>  	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
> -	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
> +	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
>  	if (!IS_ERR(event)) {
>  		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
>  		goto out_save;
> diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
> index 0636539..2b85831 100644
> --- a/samples/hw_breakpoint/data_breakpoint.c
> +++ b/samples/hw_breakpoint/data_breakpoint.c
> @@ -60,7 +60,7 @@ static int __init hw_break_module_init(void)
>  	attr.bp_len = HW_BREAKPOINT_LEN_4;
>  	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
>  
> -	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
> +	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
>  	if (IS_ERR((void __force *)sample_hbp)) {
>  		ret = PTR_ERR((void __force *)sample_hbp);
>  		goto fail;
> -- 
> 1.7.5.3
> 
