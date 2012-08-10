Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2HJQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:24:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33678 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2HJQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:24:55 -0400
Date: Fri, 10 Aug 2012 21:54:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
Message-ID: <20120810162425.GD31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120807123305.GA7137@linux.vnet.ibm.com>
 <1344347568.27828.122.camel@twins>
 <20120807171859.GB3850@linux.vnet.ibm.com>
 <1344455938.16728.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1344455938.16728.13.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081016-5490-0000-0000-000001EFA778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1539,6 +1539,7 @@ struct task_struct {
>  #ifdef CONFIG_SMP
>  	u64 node_stamp;			/* migration stamp  */
>  	unsigned long numa_contrib;
> +	struct callback_head numa_work;
>  #endif /* CONFIG_SMP  */
>  #endif /* CONFIG_NUMA */
>  	struct rcu_head rcu;
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -816,7 +816,7 @@ void task_numa_work(struct callback_head
>  	struct task_struct *t, *p = current;
>  	int node = p->node_last;
> 
> -	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
> +	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
> 
>  	/*
>  	 * Who cares about NUMA placement when they're dying.
> @@ -891,8 +891,8 @@ void task_tick_numa(struct rq *rq, struc
>  			 * yet and exit_task_work() is called before
>  			 * exit_notify().
>  			 */
> -			init_task_work(&curr->rcu, task_numa_work);
> -			task_work_add(curr, &curr->rcu, true);
> +			init_task_work(&curr->numa_work, task_numa_work);
> +			task_work_add(curr, &curr->numa_work, true);
>  		}
>  		curr->node_last = node;
>  	}
> 

This change worked well on the 2 node machine 
but on the 8 node machine it hangs with repeated messages

Pid: 60935, comm: numa01 Tainted: G        W    3.5.0-numasched_v2_020812+ #4
Call Trace:
<IRQ>  [<ffffffff810d32e2>] ? rcu_check_callback s+0x632/0x650
[<ffffffff81061bb8>] ? update_process_times+0x48/0x90
[<ffffffff810a2a4e>] ? tick_sched_timer+0x6e/0xe0
[<ffffffff81079c85>] ? __run_hrtimer+0x75/0x1a0
[<ffffffff810a29e0>] ? tick_setup_sched_timer+0x100/0x100
[<ffffffff8107a036>] ? hrtimer_interrupt+0xf6/0x250
[<ffffffff814f1379>] ? smp_apic_timer_interrupt+0x69/0x99
[<ffffffff814f034a>] ? apic_timer_interrupt+0x6a/0x70
<EOI>  [<ffffffff811082e3>] ? wait_on_page_bit+0x73/0x80
[<ffffffff814e7992>] ? _raw_spin_lock+0x22/0x30
[<ffffffff81131bf3>] ? handle_pte_fault+0x1b3/0xca0
[<ffffffff814e64f7>] ? __schedule+0x2e7/0x710
[<ffffffff8107a9a8>] ? up_read+0x18/0x30
[<ffffffff814eb2be>] ? do_page_fault+0x13e/0x460
[<ffffffff810137ba>] ? __switch_to+0x1aa/0x460
[<ffffffff814e64f7>] ? __schedule+0x2e7/0x710
[<ffffffff814e7de5>] ? page_fault+0x25/0x30
{ 3}  (t=62998 jiffies)

