Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab1AMDDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:03:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1AMDDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:03:13 -0500
Message-ID: <4D2E6B62.2000802@redhat.com>
Date: Wed, 12 Jan 2011 22:02:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	 <20110103162918.577a9620@annuminas.surriel.com>	 <1294164289.2016.186.camel@laptop>	 <1294246647.8369.52.camel@marge.simson.net>	 <1294247065.2016.267.camel@laptop> <1294378146.8823.27.camel@marge.simson.net>
In-Reply-To: <1294378146.8823.27.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 12:29 AM, Mike Galbraith wrote:

> +#ifdef CONFIG_SMP
> +	/*
> +	 * If this yield is important enough to want to preempt instead
> +	 * of only dropping a ->next hint, we're alone, and the target
> +	 * is not alone, pull the target to this cpu.
> +	 *
> +	 * NOTE: the target may be alone in it's cfs_rq if another class
> +	 * task or another task group is currently executing on it's cpu.
> +	 * In this case, we still pull, to accelerate it toward the cpu.
> +	 */
> +	if (cfs_rq != p_cfs_rq&&  preempt&&  cfs_rq->nr_running == 1&&
> +			cpumask_test_cpu(this_cpu,&p->cpus_allowed)) {
> +		pull_task(task_rq(p), p, this_rq(), this_cpu);
> +		p_cfs_rq = cfs_rq_of(pse);
> +	}
> +#endif

This causes some fun issues in a simple test case on
my system.  The test consists of 2 4-VCPU KVM guests,
bound to the same 4 CPUs on the host.

One guest is running the AMQP performance test, the
other guest is totally idle.  This means that besides
the 4 very busy VCPUs, there is only a few percent
CPU use in background tasks from the idle guest and
qemu-kvm userspace bits.

However, the busy guest is restricted to using just
3 out of the 4 CPUs, leaving one idle!

A simple explanation for this is that the above
pulling code will pull another VCPU onto the local
CPU whenever we run into contention inside the guest
and some random background task runs on the CPU where
that other VCPU was.

 From that point on, the 4 VCPUs will stay on 3
CPUs, leaving one idle.  Any time we have contention
inside the guest (pretty frequent), we move whoever
is not currently running to another CPU.

Cgroups only makes the matter worse - libvirt places
each KVM guest into its own cgroup, so a VCPU will
generally always be alone on its own per-cgroup, per-cpu
runqueue!  That can lead to pulling a VCPU onto our local
CPU because we think we are alone, when in reality we
share the CPU with others...

Removing the pulling code allows me to use all 4
CPUs with a 4-VCPU KVM guest in an uncontended situation.

> +	/* Tell the scheduler that we'd really like pse to run next. */
> +	p_cfs_rq->next = pse;

Using set_next_buddy propagates this up to the root,
allowing the scheduler to actually know who we want to
run next when cgroups is involved.

> +	/* We know whether we want to preempt or not, but are we allowed? */
> +	if (preempt&&  same_thread_group(p, task_of(p_cfs_rq->curr)))
> +		resched_task(task_of(p_cfs_rq->curr));

With this in place, we can get into the situation where
we will gladly give up CPU time, but not actually give
any to the other VCPUs in our guest.

I believe we can get rid of that test, because pick_next_entity
already makes sure it ignores ->next if picking ->next would
lead to unfairness.

Removing this test (and simplifying yield_to_task_fair) seems
to lead to more predictable test results.

I'll send the updated patch in another email, since this one is
already way too long for a changelog :)

-- 
All rights reversed
