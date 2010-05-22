Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0EVTOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:14:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35170 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab0EVTOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:14:40 -0400
Date: Sat, 22 May 2010 21:14:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100522191434.GA7712@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
References: <1274555088-6292-1-git-send-email-bp@amd64.org>
 <1274555088-6292-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1274555088-6292-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Sat, May 22, 2010 at 09:04:47PM +0200

> Register and enable events marked as persistent right after perf events
> has initialized.
> 
> Not-yet-signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  include/linux/ftrace_event.h |   10 +++++++
>  include/linux/perf_event.h   |    1 +
>  kernel/perf_event.c          |   59 +++++++++++++++++++++++++++++++++++++----
>  kernel/trace/trace.h         |    1 -
>  4 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index c0f4b36..b40d637 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -13,6 +13,8 @@ struct dentry;
>  
>  DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
>  
> +extern struct list_head ftrace_events;
> +
>  struct trace_print_flags {
>  	unsigned long		mask;
>  	const char		*name;
> @@ -134,6 +136,7 @@ struct ftrace_event_call {
>  	int			perf_refcount;
>  	int			(*perf_event_enable)(struct ftrace_event_call *);
>  	void			(*perf_event_disable)(struct ftrace_event_call *);
> +	unsigned int		type;
>  };
>  
>  #define PERF_MAX_TRACE_SIZE	2048
> @@ -155,6 +158,13 @@ enum {
>  	FILTER_PTR_STRING,
>  };
>  
> +enum event_type_t {
> +	EVENT_FLEXIBLE = 0x1,
> +	EVENT_PINNED = 0x2,
> +	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
> +	EVENT_PERSISTENT = 0x3,
> +};

Doh,

I meant

enum event_type_t {
	EVENT_FLEXIBLE = 0x1,
	EVENT_PINNED = 0x2,
	EVENT_PERSISTENT = 0x4,
	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED | EVENT_PERSISTENT,
};

here.

> +
>  extern int trace_event_raw_init(struct ftrace_event_call *call);
>  extern int trace_define_field(struct ftrace_event_call *call, const char *type,
>  			      const char *name, int offset, int size,
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c8e3754..aa62c97 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -579,6 +579,7 @@ struct perf_event {
>  	struct list_head		group_entry;
>  	struct list_head		event_entry;
>  	struct list_head		sibling_list;
> +	struct list_head		pevent_entry;
>  	int				nr_siblings;
>  	int				group_flags;
>  	struct perf_event		*group_leader;
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 3d1552d..84f2f36 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -72,6 +72,11 @@ static atomic64_t perf_event_id;
>  static DEFINE_SPINLOCK(perf_resource_lock);
>  
>  /*
> + * persistent events which are always on
> + */
> +DEFINE_PER_CPU(struct list_head, persistent_events);
> +
> +/*
>   * Architecture provided APIs - weak aliases:
>   */
>  extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
> @@ -1017,12 +1022,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
>  	return 0;
>  }
>  
> -enum event_type_t {
> -	EVENT_FLEXIBLE = 0x1,
> -	EVENT_PINNED = 0x2,
> -	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
> -};
> -
>  static void ctx_sched_out(struct perf_event_context *ctx,
>  			  struct perf_cpu_context *cpuctx,
>  			  enum event_type_t event_type)
> @@ -5385,6 +5384,8 @@ static void __init perf_event_init_all_cpus(void)
>  	for_each_possible_cpu(cpu) {
>  		cpuctx = &per_cpu(perf_cpu_context, cpu);
>  		__perf_event_init_context(&cpuctx->ctx, NULL);
> +
> +		INIT_LIST_HEAD(&per_cpu(persistent_events, cpu));
>  	}
>  }
>  
> @@ -5405,12 +5406,16 @@ static void __perf_event_exit_cpu(void *info)
>  	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>  	struct perf_event_context *ctx = &cpuctx->ctx;
>  	struct perf_event *event, *tmp;
> +	struct list_head *pers_events_list = &__get_cpu_var(persistent_events);
>  
>  	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
>  		__perf_event_remove_from_context(event);
>  	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
>  		__perf_event_remove_from_context(event);
> +	list_for_each_entry_safe(event, tmp, pers_events_list, pevent_entry)
> +		__perf_event_remove_from_context(event);
>  }
> +
>  static void perf_event_exit_cpu(int cpu)
>  {
>  	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
> @@ -5456,6 +5461,46 @@ static struct notifier_block __cpuinitdata perf_cpu_nb = {
>  	.priority		= 20,
>  };
>  
> +static void __init perf_init_persistent_events(void)
> +{
> +
> +	struct ftrace_event_call *call;
> +	struct perf_event_attr attr;
> +	struct perf_event *event;
> +	int cpu;
> +
> +	list_for_each_entry(call, &ftrace_events, list) {
> +
> +		if (call->type != EVENT_PERSISTENT)
> +			continue;
> +
> +		attr.type	= PERF_TYPE_TRACEPOINT,
> +		attr.config	= call->id,
> +		attr.size	= sizeof(attr),
> +
> +		get_online_cpus();
> +
> +		for_each_online_cpu(cpu) {
> +			struct list_head *list;
> +
> +			event = perf_event_create_kernel_counter(&attr, cpu, -1, NULL);
> +			if (IS_ERR(event)) {
> +				printk(KERN_ERR "Error initializing persistent "
> +						"event %s on cpu %d\n",
> +						call->name, cpu);
> +				break;
> +			}
> +
> +			list = &per_cpu(persistent_events, cpu);
> +			list_add(&event->pevent_entry, list);
> +
> +			perf_event_enable(event);
> +
> +		}
> +		put_online_cpus();
> +	}
> +}
> +
>  void __init perf_event_init(void)
>  {
>  	perf_event_init_all_cpus();
> @@ -5464,6 +5509,8 @@ void __init perf_event_init(void)
>  	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
>  			(void *)(long)smp_processor_id());
>  	register_cpu_notifier(&perf_cpu_nb);
> +
> +	perf_init_persistent_events();
>  }
>  
>  static ssize_t perf_show_reserve_percpu(struct sysdev_class *class,
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2825ef2..95f5611 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -786,7 +786,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
>  }
>  
>  extern struct mutex event_mutex;
> -extern struct list_head ftrace_events;
>  
>  extern const char *__start___trace_bprintk_fmt[];
>  extern const char *__stop___trace_bprintk_fmt[];
> -- 
> 1.7.1
> 
> 

-- 
Regards/Gruss,
    Boris.
