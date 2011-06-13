Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1FMR6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:58:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:11716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1FMR6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,359,1304319600"; 
   d="scan'208";a="12981621"
Subject: Re: [patch v3 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110610130554.GI15235@htj.dyndns.org>
References: <20110609223211.006948233@sbsiddha-MOBL3.sc.intel.com>
	 <20110609223341.795234398@sbsiddha-MOBL3.sc.intel.com>
	 <20110610130554.GI15235@htj.dyndns.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 13 Jun 2011 10:58:26 -0700
Message-Id: <1307987906.2682.22.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 06:05 -0700, Tejun Heo wrote:
> > @@ -47,15 +48,32 @@ static void cpu_stop_init_done(struct cp
> >  	memset(done, 0, sizeof(*done));
> >  	atomic_set(&done->nr_todo, nr_todo);
> >  	init_completion(&done->completion);
> > +	done->offline_ctxt = !percpu_read(cpu_stopper.enabled);
> > +}
> 
> I'm not sure the above test is safe.  CPU_ONLINE notification is not
> guaranteed to execute on the CPU being brought online.  It's likely to
> happen on the CPU which is bring up the target CPU, so
> cpu_stopper.enabled may change asynchronously.  I think the correct
> test to perform is querying local CPU onlineness with accompanying
> WARN_ON_ONCE() on preemption enable state.

Thinking a bit more, I think using raw_smp_processor_id() is safe and
easier to understand. So I went back to cpu_online() checks here. We
don't need to worry about preemption state, as we are checking only if
the cpu is online/offline and there is no load balance that happens
between an online and offline cpu.

> >  {
> >  	if (done) {
> > +		bool offline_ctxt = done->offline_ctxt;
> >  		if (executed)
> >  			done->executed = true;
> > -		if (atomic_dec_and_test(&done->nr_todo))
> > +		if (atomic_dec_and_test(&done->nr_todo) &&  !offline_ctxt)
> >  			complete(&done->completion);
> 
> What does the local variable achieve?  Also, an extra space.

If the caller is polling on nr_todo, we need to check the offline status
before decrementing the nr_todo, as the callers stack holding 'done' may
no longer be active (as the caller can return as soon as he sees null
todo). Memory barrier in atomic_dec_and_test() ensures that the offline
status is read before.

> >  	/* initialize works and done */
> > -	for_each_cpu(cpu, cpumask) {
> > +	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
> >  		work = &per_cpu(stop_cpus_work, cpu);
> >  		work->fn = fn;
> >  		work->arg = arg;
> >  		work->done = &done;
> > +		weight++;
> 
> This seems a bit dangerous.  Upto now, whether to execute or not is
> solely determined by testing stopper->enabled while holding
> stopper->lock.  There's no reason to change that behavior for this
> feature and even if necessary it should be done in a separate patch
> with ample explanation why that's necessary and why it's safe.

Making stop_cpus() to work in offline case requires a bit more work for
both CONFIG_SMP and !CONFIG_SMP cases. And there is no user for it
currently.

So in the new version, I made only __stop_machine() to be called from an
online path and no changes for stop_cpus() which can be called only from
a cpu that is already online.

If there is a need, we can make stop_cpus() also behave similarly in
future. But for now, only __stop_machine() is to be used from an online
path (used in the second patch by x86 mtrr code).

> > +	/*
> > +	 * This cpu is not yet online. If @fn needs to be run on this
> > +	 * cpu, run it now.
> > +	 */
> > +	if (!online && cpu_isset(smp_processor_id(), *cpumask))
> > +		fn(arg);
> 
> Can't we put this in cpu_stop_wait_for_completion()?  And please
> factor out fn() execution from cpu_stopper_thread() and call that.  I
> know you objected to that in the other reply but please do it that
> way.  All that's necessary is using a different context and avoiding
> sleeping.

Calling cpu is not yet online (with irq's disabled etc), so it can't do
any context switch etc.

I fixed the return value checking you mentioned.

> > @@ -470,9 +500,19 @@ int __stop_machine(int (*fn)(void *), vo
> >  					    .num_threads = num_online_cpus(),
> >  					    .active_cpus = cpus };
> >  
> > +	/* Include the calling cpu that might not be online yet. */
> > +	if (!percpu_read(cpu_stopper.enabled))
> > +		smdata.num_threads++;
> > +
> >  	/* Set the initial state and stop all online cpus. */
> >  	set_state(&smdata, STOPMACHINE_PREPARE);
> > -	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
> > +
> > +	if (percpu_read(cpu_stopper.enabled))
> > +		return stop_cpus(cpu_online_mask, stop_machine_cpu_stop,
> > +				 &smdata);
> > +	else
> > +		return __stop_cpus(cpu_all_mask, stop_machine_cpu_stop,
> > +				   &smdata);
> 
> Ummm... I'm completely lost here.  How is this supposed to work?  As
> local CPU can't sleep, we skip synchronization altogether?  What if
> another stop machine is already in progress? 

There can't be another stop machine in parallel as stop_machine() does
get_online_cpus() and will be waiting for that if there is a cpu that is
coming online which does __stop_machine().

> Shouldn't you be busy
> looping w/ trylock instead?

Reviewing more closely, stop_cpus() can come in parallel to a
__stop_machine(). So I ended up busy looping with trylock in this path
aswell.

v4 patchset will follow shortly.

thanks,
suresh

