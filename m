Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1FIJy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:54:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60023 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1FIJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=npzkQAlaFmTiJE5bMyvXe3Ec3xxOLXHsIMGpN8fxa5vvsUo89J/Qdijqy3L2VbDxF9
         8KZ+1RoZR02/ZA+ZPo92fPEErj9hD8DBBrvQaIoMMxW3O7HksH8u8HucnqjPq/uh31GO
         dOIpWRdmsOO14a7O0mhA4lSBTiEtlNNC2VH8M=
Date: Thu, 9 Jun 2011 11:54:50 +0200
From: Tejun Heo <tj@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, linux-kernel@vger.kernel.org,
        youquan.song@intel.com, stable@kernel.org
Subject: Re: [patch v2 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110609095450.GC11773@htj.dyndns.org>
References: <20110607201411.791585562@sbsiddha-MOBL3.sc.intel.com>
 <20110607201425.083758186@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607201425.083758186@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh, Ingo.

On Tue, Jun 07, 2011 at 01:14:12PM -0700, Suresh Siddha wrote:
> Currently stop machine infrastructure can be called only from a cpu that is
> online. But for !CONFIG_SMP, we do allow calling __stop_machine() before the
> cpu is online.
> 
> x86 for example requires stop machine infrastructure in the cpu online path
> and currently implements its own stop machine (using stop_one_cpu_nowait())
> for MTRR initialization in the cpu online path.
> 
> Enhance the __stop_machine() so that it can be called before the cpu
> is onlined. This will pave the way for code consolidation and address potential
> deadlocks caused by multiple mechanisms of doing system wide rendezvous.
> 
> This will also address the behavioral differences of __stop_machine()
> between SMP and UP builds.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org    # v2.6.35+

First of all, I agree this is the correct thing to do but I don't
agree with some of the details.  Also, this is slightly scary for
-stable.  Maybe we should opt for something less intrusive for
-stable?

> +/**
> + * __stop_cpus - stop multiple cpus
> + * @cpumask: cpus to stop
> + * @fn: function to execute
> + * @arg: argument to @fn
> + *
> + * Execute @fn(@arg) on online cpus in @cpumask. If @cpumask is NULL, @fn
> + * is run on all the online cpus including the current cpu (even if it
> + * is not online).
> + * On each target cpu, @fn is run in a process context (except when run on
> + * the cpu that is in the process of coming online, in which case @fn is run
> + * in the same context as __stop_cpus()) with the highest priority
> + * preempting any task on the cpu and monopolizing it.  This function
> + * returns after all executions are complete.
> + */

It's minor but can you please follow the comment style in the same
file?  ie. Blank line between paragraphs, separate CONTEXT: and
RETURNS: sections.  At the second thought, why is this function even
exported?  It doesn't seem to have any out-of-file user left.  Maybe
best to make it static?

>  int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
>  {
> +	int online = percpu_read(cpu_stopper.enabled);
> +	int include_this_offline = 0;
>  	struct cpu_stop_work *work;
>  	struct cpu_stop_done done;
> +	unsigned int weight;
>  	unsigned int cpu;
>  
> +	if (!cpumask) {
> +		cpumask = cpu_online_mask;
> +		include_this_offline = 1;
> +	}

This seems a bit too subtle.  I would much prefer if it were much more
explicit than using non-obvious combination of conditions to trigger
this special behavior.

Hmm... Wouldn't it be better to change cpu_stop_queue_work() consider
whether the local CPU is offline and then add cpu_stop_wait_done()
which does wait_for_completion() if local is online and otherwise
execute fn locally, call cpu_stop_signal_done() and wait in busy loop?

That would make the whole thing much more generic and easier to
describe.  The current implementation seems quite hacky/subtle and
doesn't fit well with the rest.  It would be much better if we can
just state "if used from local CPU which is not online and the target
@cpumask includes the local CPU, the work item is executed on-stack
and completion is waited in busy-loop" for all cpu_stop functions.

Also, it would be better to factor out work item execution and
completion from cpu_stopper_thread() and call that instead of invoking
fn(arg) directly.

Thank you.

-- 
tejun
