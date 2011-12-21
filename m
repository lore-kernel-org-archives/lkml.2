Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1LUQBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:01:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43207 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1LUQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:01:34 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gi03_xuaV2EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=O4XBFQGAp-FpmVUVIJ0A:9 a=ou-KjvlrU2UzCLTaskcA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324483293.5916.89.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/8] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 21 Dec 2011 11:01:33 -0500
In-Reply-To: <1324468136-3997-4-git-send-email-jolsa@redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 12:48 +0100, Jiri Olsa wrote:
> Adding a way to temporarily enable/disable ftrace_ops. The change
> follows the same way as 'global' ftrace_ops are done.
> 
> Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
> which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
> flag. In addition new per cpu flag called 'disabled' is also added to
> ftrace_ops to provide the control information for each cpu.
> 
> When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
> set as disabled for all cpus.
> 
> The ftrace_control_list contains all the registered 'control' ftrace_ops.
> The control_ops provides function which iterates ftrace_control_list
> and does the check for 'disabled' flag on current cpu.
> 
> Adding 2 inline functions ftrace_function_enable/ftrace_function_disable,
> which enable/disable the ftrace_ops for given cpu.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/ftrace.h |   42 +++++++++++++++++
>  kernel/trace/ftrace.c  |  116 +++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/trace/trace.h   |    2 +
>  3 files changed, 153 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 523640f..67b8236 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -35,12 +35,14 @@ enum {
>  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
>  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
>  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
>  };
>  
>  struct ftrace_ops {
>  	ftrace_func_t			func;
>  	struct ftrace_ops		*next;
>  	unsigned long			flags;
> +	void __percpu			*disabled;
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  	struct ftrace_hash		*notrace_hash;
>  	struct ftrace_hash		*filter_hash;
> @@ -97,6 +99,46 @@ int register_ftrace_function(struct ftrace_ops *ops);
>  int unregister_ftrace_function(struct ftrace_ops *ops);
>  void clear_ftrace_function(void);
>  
> +/**
> + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> + *
> + * This function enables tracing on given cpu by decreasing
> + * the per cpu control variable.
> + * It must be called with preemption disabled and only on
> + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> + */
> +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> +{
> +	atomic_t *disabled;
> +
> +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)) ||
> +			 !preempt_count())

The WARN_ON_ONCE() should also include the !preempt_count().


> +		return;
> +
> +	disabled = per_cpu_ptr(ops->disabled, cpu);
> +	atomic_dec(disabled);
> +}
> +
> +/**
> + * ftrace_function_disable - enable controlled ftrace_ops on given cpu
> + *
> + * This function enables tracing on given cpu by decreasing
> + * the per cpu control variable.
> + * It must be called with preemption disabled and only on
> + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> + */
> +static inline void ftrace_function_disable(struct ftrace_ops *ops, int cpu)
> +{
> +	atomic_t *disabled;
> +
> +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)) ||
> +			 !preempt_count())

Same here.

> +		return;
> +
> +	disabled = per_cpu_ptr(ops->disabled, cpu);
> +	atomic_inc(disabled);
> +}
> +
>  extern void ftrace_stub(unsigned long a0, unsigned long a1);
>  
>  #else /* !CONFIG_FUNCTION_TRACER */
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7eb702f..1b56013 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -60,6 +60,8 @@
>  #define FTRACE_HASH_DEFAULT_BITS 10
>  #define FTRACE_HASH_MAX_BITS 12
>  
> +#define FL_GLOBAL_CONTROL (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
> +
>  /* ftrace_enabled is a method to turn ftrace on or off */
>  int ftrace_enabled __read_mostly;
>  static int last_ftrace_enabled;
> @@ -87,12 +89,14 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
>  };
>  
>  static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
> +static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
>  static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
>  ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
>  static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
>  ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
>  ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
>  static struct ftrace_ops global_ops;
> +static struct ftrace_ops control_ops;
>  
>  static void
>  ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
> @@ -166,6 +170,38 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
>  }
>  #endif
>  
> +static void control_ops_disable_all(struct ftrace_ops *ops)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		atomic_set(per_cpu_ptr(ops->disabled, cpu), 1);
> +}
> +
> +static int control_ops_alloc(struct ftrace_ops *ops)
> +{
> +	atomic_t *disabled;
> +
> +	disabled = alloc_percpu(atomic_t);
> +	if (!disabled)
> +		return -ENOMEM;
> +
> +	ops->disabled = disabled;
> +	control_ops_disable_all(ops);
> +	return 0;
> +}
> +
> +static void control_ops_free(struct ftrace_ops *ops)
> +{
> +	free_percpu(ops->disabled);
> +}
> +
> +static int control_ops_is_disabled(struct ftrace_ops *ops)
> +{
> +	atomic_t *disabled = this_cpu_ptr(ops->disabled);

Again, the use of "this_cpu_ptr" is wrong. Gah! We should nuke all of
that crap.


> +	return atomic_read(disabled);
> +}
> +
>  static void update_global_ops(void)
>  {
>  	ftrace_func_t func;
> @@ -257,6 +293,26 @@ static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
>  	return 0;
>  }
>  
> +static void add_ftrace_list_ops(struct ftrace_ops **list,
> +				struct ftrace_ops *main_ops,
> +				struct ftrace_ops *ops)
> +{
> +	int first = *list == &ftrace_list_end;
> +	add_ftrace_ops(list, ops);
> +	if (first)
> +		add_ftrace_ops(&ftrace_ops_list, main_ops);
> +}
> +
> +static int remove_ftrace_list_ops(struct ftrace_ops **list,
> +				  struct ftrace_ops *main_ops,
> +				  struct ftrace_ops *ops)
> +{
> +	int ret = remove_ftrace_ops(list, ops);
> +	if (!ret && *list == &ftrace_list_end)
> +		ret = remove_ftrace_ops(&ftrace_ops_list, main_ops);
> +	return ret;
> +}
> +
>  static int __register_ftrace_function(struct ftrace_ops *ops)
>  {
>  	if (ftrace_disabled)
> @@ -268,15 +324,19 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
>  	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
>  		return -EBUSY;
>  
> +	if ((ops->flags & FL_GLOBAL_CONTROL) == FL_GLOBAL_CONTROL)

No biggy, but I usually find:

	if (ops->flags & FL_GLOBAL_CONTROL)

more readable. With what you have, I looked at that condition three
times to figure out what was different between what was '&'d with the
flags and what was being equal too. Usually the ((flags & X) == Y) is
done to check if a subset of bits are set within a mask of bits.


> +		return -EINVAL;
> +
>  	if (!core_kernel_data((unsigned long)ops))
>  		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
>  
>  	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
> -		int first = ftrace_global_list == &ftrace_list_end;
> -		add_ftrace_ops(&ftrace_global_list, ops);
> +		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);

Much better and easier to read :)

>  		ops->flags |= FTRACE_OPS_FL_ENABLED;
> -		if (first)
> -			add_ftrace_ops(&ftrace_ops_list, &global_ops);
> +	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
> +		if (control_ops_alloc(ops))
> +			return -ENOMEM;
> +		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
>  	} else
>  		add_ftrace_ops(&ftrace_ops_list, ops);
>  

The rest looks good.

-- Steve


