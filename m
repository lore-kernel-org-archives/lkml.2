Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1FJNGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:06:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1FJNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPBCNIMTNdL9gxmdVDEhvxIFvnYoeJ+WQLKLOqOVnJ5fDURWn5emaU+VL3EbmLv777
         LJ7FmODZcTjKAa3/kDFvE3H65FpG+r80NuH0Ui6ImgJnTjaNjSXNRNAM7v0Ul+/ZoJg6
         aOLafVNojtFwwHiR97dKG+nhJjTWQJ5xip2Ww=
Date: Fri, 10 Jun 2011 15:05:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        youquan.song@intel.com, stable@kernel.org
Subject: Re: [patch v3 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110610130554.GI15235@htj.dyndns.org>
References: <20110609223211.006948233@sbsiddha-MOBL3.sc.intel.com>
 <20110609223341.795234398@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609223341.795234398@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh.

On Thu, Jun 09, 2011 at 03:32:12PM -0700, Suresh Siddha wrote:
> Index: linux-2.6-tip/kernel/stop_machine.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/stop_machine.c
> +++ linux-2.6-tip/kernel/stop_machine.c
> @@ -28,6 +28,7 @@
>  struct cpu_stop_done {
>  	atomic_t		nr_todo;	/* nr left to execute */
>  	bool			executed;	/* actually executed? */
> +	bool			offline_ctxt;	/* stop_cpu from offline ctxt */

Maybe something a bit more explicit is better?  Say, from_offline_cpu?

>  	int			ret;		/* collected return value */
>  	struct completion	completion;	/* fired if nr_todo reaches 0 */
>  };
> @@ -47,15 +48,32 @@ static void cpu_stop_init_done(struct cp
>  	memset(done, 0, sizeof(*done));
>  	atomic_set(&done->nr_todo, nr_todo);
>  	init_completion(&done->completion);
> +	done->offline_ctxt = !percpu_read(cpu_stopper.enabled);
> +}

I'm not sure the above test is safe.  CPU_ONLINE notification is not
guaranteed to execute on the CPU being brought online.  It's likely to
happen on the CPU which is bring up the target CPU, so
cpu_stopper.enabled may change asynchronously.  I think the correct
test to perform is querying local CPU onlineness with accompanying
WARN_ON_ONCE() on preemption enable state.

> +static inline void cpu_stop_wait_for_completion(struct cpu_stop_done *done)
> +{
> +	if (!done->offline_ctxt)
> +		wait_for_completion(&done->completion);

Missing {}'s.

> +	else {

Shouldn't this function execute the function on local CPU?

> +		/*
> +		 * If the calling cpu is not online, then we can't afford to
> +		 * sleep, so poll till the work is completed on the target
> +		 * cpu's.
> +		 */
> +		while (atomic_read(&done->nr_todo))
> +			cpu_relax();
> +	}
>  }
>  
>  /* signal completion unless @done is NULL */
>  static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
>  {
>  	if (done) {
> +		bool offline_ctxt = done->offline_ctxt;
>  		if (executed)
>  			done->executed = true;
> -		if (atomic_dec_and_test(&done->nr_todo))
> +		if (atomic_dec_and_test(&done->nr_todo) &&  !offline_ctxt)
>  			complete(&done->completion);

What does the local variable achieve?  Also, an extra space.

> +static
>  int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)

Please put static on the same line.

>  {
> +	int online = percpu_read(cpu_stopper.enabled);
>  	struct cpu_stop_work *work;
>  	struct cpu_stop_done done;
> +	unsigned int weight = 0;
>  	unsigned int cpu;
>  
>  	/* initialize works and done */
> -	for_each_cpu(cpu, cpumask) {
> +	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
>  		work = &per_cpu(stop_cpus_work, cpu);
>  		work->fn = fn;
>  		work->arg = arg;
>  		work->done = &done;
> +		weight++;

This seems a bit dangerous.  Upto now, whether to execute or not is
solely determined by testing stopper->enabled while holding
stopper->lock.  There's no reason to change that behavior for this
feature and even if necessary it should be done in a separate patch
with ample explanation why that's necessary and why it's safe.

>  	preempt_disable();
> -	for_each_cpu(cpu, cpumask)
> +	for_each_cpu_and(cpu, cpumask, cpu_online_mask)
>  		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
>  				    &per_cpu(stop_cpus_work, cpu));

Ditto.

> +	/*
> +	 * This cpu is not yet online. If @fn needs to be run on this
> +	 * cpu, run it now.
> +	 */
> +	if (!online && cpu_isset(smp_processor_id(), *cpumask))
> +		fn(arg);

Can't we put this in cpu_stop_wait_for_completion()?  And please
factor out fn() execution from cpu_stopper_thread() and call that.  I
know you objected to that in the other reply but please do it that
way.  All that's necessary is using a different context and avoiding
sleeping.  It's best to deviate only there.  Please note that the
above change already breaks the return value.

> @@ -431,6 +460,7 @@ static int stop_machine_cpu_stop(void *d
>  	struct stop_machine_data *smdata = data;
>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
>  	int cpu = smp_processor_id(), err = 0;
> +	unsigned long flags = 0;
>  	bool is_active;
>  
>  	if (!smdata->active_cpus)
> @@ -446,7 +476,7 @@ static int stop_machine_cpu_stop(void *d
>  			curstate = smdata->state;
>  			switch (curstate) {
>  			case STOPMACHINE_DISABLE_IRQ:
> -				local_irq_disable();
> +				local_irq_save(flags);
>  				hard_irq_disable();
>  				break;
>  			case STOPMACHINE_RUN:
> @@ -460,7 +490,7 @@ static int stop_machine_cpu_stop(void *d
>  		}
>  	} while (curstate != STOPMACHINE_EXIT);
>  
> -	local_irq_enable();
> +	local_irq_restore(flags);

It would be nice to explain how the function may be called with irq
disabled.  It would also be nice the special offline case explained in
the docbook comments as well.

> @@ -470,9 +500,19 @@ int __stop_machine(int (*fn)(void *), vo
>  					    .num_threads = num_online_cpus(),
>  					    .active_cpus = cpus };
>  
> +	/* Include the calling cpu that might not be online yet. */
> +	if (!percpu_read(cpu_stopper.enabled))
> +		smdata.num_threads++;
> +
>  	/* Set the initial state and stop all online cpus. */
>  	set_state(&smdata, STOPMACHINE_PREPARE);
> -	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
> +
> +	if (percpu_read(cpu_stopper.enabled))
> +		return stop_cpus(cpu_online_mask, stop_machine_cpu_stop,
> +				 &smdata);
> +	else
> +		return __stop_cpus(cpu_all_mask, stop_machine_cpu_stop,
> +				   &smdata);

Ummm... I'm completely lost here.  How is this supposed to work?  As
local CPU can't sleep, we skip synchronization altogether?  What if
another stop machine is already in progress?  Shouldn't you be busy
looping w/ trylock instead?

Thanks.

-- 
tejun
