Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2CSMQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:16:20 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49352 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2CSMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:16:19 -0400
Message-ID: <4F672384.7030500@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 17:46:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 15/26] sched, numa: Implement hotplug hooks
References: <20120316144028.036474157@chello.nl> <20120316144241.074193109@chello.nl>
In-Reply-To: <20120316144241.074193109@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031902-0260-0000-0000-000000B6F019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 08:10 PM, Peter Zijlstra wrote:

> start/stop numa balance threads on-demand using cpu-hotlpug.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched/numa.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 55 insertions(+), 7 deletions(-)
> --- a/kernel/sched/numa.c
> +++ b/kernel/sched/numa.c
> @@ -596,31 +596,79 @@ static int numad_thread(void *data)
>  	return 0;
>  }
> 
> +static int __cpuinit
> +numa_hotplug(struct notifier_block *nb, unsigned long action, void *hcpu)
> +{
> +	int cpu = (long)hcpu;
> +	int node = cpu_to_node(cpu);
> +	struct node_queue *nq = nq_of(node);
> +	struct task_struct *numad;
> +	int err = 0;
> +
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_UP_PREPARE:
> +		if (nq->numad)
> +			break;
> +
> +		numad = kthread_create_on_node(numad_thread,
> +				nq, node, "numad/%d", node);
> +		if (IS_ERR(numad)) {
> +			err = PTR_ERR(numad);
> +			break;
> +		}
> +
> +		nq->numad = numad;
> +		nq->next_schedule = jiffies + HZ; // XXX sync-up?
> +		break;
> +
> +	case CPU_ONLINE:
> +		wake_up_process(nq->numad);
> +		break;
> +
> +	case CPU_DEAD:
> +	case CPU_UP_CANCELED:
> +		if (!nq->numad)
> +			break;
> +
> +		if (cpumask_any_and(cpu_online_mask,
> +				    cpumask_of_node(node)) >= nr_cpu_ids) {
> +			kthread_stop(nq->numad);
> +			nq->numad = NULL;
> +		}
> +		break;
> +	}
> +
> +	return notifier_from_errno(err);
> +}
> +
>  static __init int numa_init(void)
>  {
> -	int node;
> +	int node, cpu, err;
> 
>  	nqs = kzalloc(sizeof(struct node_queue*) * nr_node_ids, GFP_KERNEL);
>  	BUG_ON(!nqs);
> 
> -	for_each_node(node) { // XXX hotplug
> +	for_each_node(node) {
>  		struct node_queue *nq = kmalloc_node(sizeof(*nq),
>  				GFP_KERNEL | __GFP_ZERO, node);
>  		BUG_ON(!nq);
> 
> -		nq->numad = kthread_create_on_node(numad_thread,
> -				nq, node, "numad/%d", node);
> -		BUG_ON(IS_ERR(nq->numad));
> -
>  		spin_lock_init(&nq->lock);
>  		INIT_LIST_HEAD(&nq->entity_list);
> 
>  		nq->next_schedule = jiffies + HZ;
>  		nq->node = node;
>  		nqs[node] = nq;
> +	}
> 
> -		wake_up_process(nq->numad);
> +	get_online_cpus();
> +	cpu_notifier(numa_hotplug, 0);


ABBA deadlock!

CPU 0						CPU1
				echo 0/1 > /sys/devices/.../cpu*/online

					acquire cpu_add_remove_lock

get_online_cpus()
	acquire cpu_hotplug lock
					
					Blocked on cpu hotplug lock

cpu_notifier()
	acquire cpu_add_remove_lock

ABBA DEADLOCK!

[cpu_maps_update_begin/done() deal with cpu_add_remove_lock].

So, basically, at the moment there is no way to register a CPU Hotplug notifier
and do setup for all currently online cpus in a totally race-free manner.

One approach to fix this is to audit whether register_cpu_notifier() really needs
to take cpu_add_remove_lock and if no, then acquire cpu hotplug lock instead.

The other approach is to keep the existing lock ordering as it is and yet provide
a race-free way to register, as I had posted some time ago (incomplete/untested):

http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826


> +	for_each_online_cpu(cpu) {
> +		err = numa_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
> +		BUG_ON(notifier_to_errno(err));
> +		numa_hotplug(NULL, CPU_ONLINE, (void *)(long)cpu);
>  	}
> +	put_online_cpus();
> 
>  	return 0;
>  }
> 
> 

 
Regards,
Srivatsa S. Bhat

