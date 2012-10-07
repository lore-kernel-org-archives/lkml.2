Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2JGRSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 13:18:17 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49708 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2JGRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 13:18:08 -0400
Message-ID: <5071B906.4020505@linux.vnet.ibm.com>
Date: Sun, 07 Oct 2012 22:46:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: Deadlock on poweroff
References: <20121007024711.GA21403@shutemov.name> <20121007160311.GE2485@linux.vnet.ibm.com> <20121007165012.GA23535@shutemov.name> <5071B63D.4020300@linux.vnet.ibm.com> <20121007171109.GA23613@shutemov.name>
In-Reply-To: <20121007171109.GA23613@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100717-4790-0000-0000-000004F5238D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 10:41 PM, Kirill A. Shutemov wrote:
> On Sun, Oct 07, 2012 at 10:35:01PM +0530, Srivatsa S. Bhat wrote:
>> On 10/07/2012 10:20 PM, Kirill A. Shutemov wrote:
>>> On Sun, Oct 07, 2012 at 09:03:11AM -0700, Paul E. McKenney wrote:
>>>> On Sun, Oct 07, 2012 at 05:47:11AM +0300, Kirill A. Shutemov wrote:
>>>>> Hi Paul and all,
>>>>>
>>>>> With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
>>>>> poweroff.
>>>>>
>>>>> It guess it happens because of race for cpu_hotplug.lock:
>>>>>
>>>>> 	CPU A					CPU B
>>>>> disable_nonboot_cpus()
>>>>> _cpu_down()
>>>>> cpu_hotplug_begin()
>>>>>  mutex_lock(&cpu_hotplug.lock);
>>>>> __cpu_notify()
>>>>> padata_cpu_callback()
>>>>> __padata_remove_cpu()
>>>>> padata_replace()
>>>>> synchronize_rcu()
>>>>> 					rcu_gp_kthread()
>>>>> 					get_online_cpus();
>>>>> 					mutex_lock(&cpu_hotplug.lock);
>>>>>
>>>>> Have you seen the issue before?
>>>>
>>>> This is a new one for me.  Does the following (very lightly tested)
>>>> patch help?
>>>
>>> Works for me. Thanks.
>>>
>>
>> Could you share the patch please? Looks like it didn't hit the mailing
>> lists.. 
> 
> Sure. Here's original  mail from Paul:
>

Ah, great! Thanks!

Regards,
Srivatsa S. Bhat
 
> Date: Sun, 7 Oct 2012 09:03:11 -0700
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> To: "Kirill A. Shutemov" <kirill@shutemov.name>
> Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
>         Thomas Gleixner <tglx@linutronix.de>,
>         Andrew Morton <akpm@linux-foundation.org>,
>         Steffen Klassert <steffen.klassert@secunet.com>,
>         ".linux-crypto"@vger.kernel.org
> Subject: Re: Deadlock on poweroff
> Message-ID: <20121007160311.GE2485@linux.vnet.ibm.com>
> Reply-To: paulmck@linux.vnet.ibm.com
> References: <20121007024711.GA21403@shutemov.name>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> In-Reply-To: <20121007024711.GA21403@shutemov.name>
> User-Agent: Mutt/1.5.21 (2010-09-15)
> X-Content-Scanned: Fidelis XPS MAILER
> x-cbid: 12100716-7408-0000-0000-000009194B17
> Status: RO
> Content-Length: 6055
> Lines: 173
> 
> On Sun, Oct 07, 2012 at 05:47:11AM +0300, Kirill A. Shutemov wrote:
>> Hi Paul and all,
>>
>> With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
>> poweroff.
>>
>> It guess it happens because of race for cpu_hotplug.lock:
>>
>> 	CPU A					CPU B
>> disable_nonboot_cpus()
>> _cpu_down()
>> cpu_hotplug_begin()
>>  mutex_lock(&cpu_hotplug.lock);
>> __cpu_notify()
>> padata_cpu_callback()
>> __padata_remove_cpu()
>> padata_replace()
>> synchronize_rcu()
>> 					rcu_gp_kthread()
>> 					get_online_cpus();
>> 					mutex_lock(&cpu_hotplug.lock);
>>
>> Have you seen the issue before?
> 
> This is a new one for me.  Does the following (very lightly tested)
> patch help?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Grace-period initialization excludes only RCU notifier
> 
> Kirill noted the following deadlock cycle on shutdown involving padata:
> 
>> With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
>> poweroff.
>>
>> It guess it happens because of race for cpu_hotplug.lock:
>>
>>       CPU A                                   CPU B
>> disable_nonboot_cpus()
>> _cpu_down()
>> cpu_hotplug_begin()
>>  mutex_lock(&cpu_hotplug.lock);
>> __cpu_notify()
>> padata_cpu_callback()
>> __padata_remove_cpu()
>> padata_replace()
>> synchronize_rcu()
>>                                       rcu_gp_kthread()
>>                                       get_online_cpus();
>>                                       mutex_lock(&cpu_hotplug.lock);
> 
> It would of course be good to eliminate grace-period delays from
> CPU-hotplug notifiers, but that is a separate issue.  Deadlock is
> not an appropriate diagnostic for excessive CPU-hotplug latency.
> 
> Fortunately, grace-period initialization does not actually need to
> exclude all of the CPU-hotplug operation, but rather only RCU's own
> CPU_UP_PREPARE and CPU_DEAD CPU-hotplug notifiers.  This commit therefore
> introduces a new per-rcu_state onoff_mutex that provides the required
> concurrency control in place of the get_online_cpus() that was previously
> in rcu_gp_init().
> 
> Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index fb63d7b..5eece12 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -74,6 +74,7 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
>  	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
>  	.orphan_donetail = &sname##_state.orphan_donelist, \
>  	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
> +	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
>  	.name = #sname, \
>  }
>  
> @@ -1229,7 +1230,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  	raw_spin_unlock_irq(&rnp->lock);
>  
>  	/* Exclude any concurrent CPU-hotplug operations. */
> -	get_online_cpus();
> +	mutex_lock(&rsp->onoff_mutex);
>  
>  	/*
>  	 * Set the quiescent-state-needed bits in all the rcu_node
> @@ -1266,7 +1267,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  		cond_resched();
>  	}
>  
> -	put_online_cpus();
> +	mutex_unlock(&rsp->onoff_mutex);
>  	return 1;
>  }
>  
> @@ -1754,6 +1755,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>  	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
>  
>  	/* Exclude any attempts to start a new grace period. */
> +	mutex_lock(&rsp->onoff_mutex);
>  	raw_spin_lock_irqsave(&rsp->onofflock, flags);
>  
>  	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
> @@ -1798,6 +1800,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>  	init_callback_list(rdp);
>  	/* Disallow further callbacks on this CPU. */
>  	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
> +	mutex_unlock(&rsp->onoff_mutex);
>  }
>  
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> @@ -2708,6 +2711,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
>  	struct rcu_node *rnp = rcu_get_root(rsp);
>  
> +	/* Exclude new grace periods. */
> +	mutex_lock(&rsp->onoff_mutex);
> +
>  	/* Set up local state, ensuring consistent view of global state. */
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
>  	rdp->beenonline = 1;	 /* We have now been online. */
> @@ -2722,14 +2728,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  	rcu_prepare_for_idle_init(cpu);
>  	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
>  
> -	/*
> -	 * A new grace period might start here.  If so, we won't be part
> -	 * of it, but that is OK, as we are currently in a quiescent state.
> -	 */
> -
> -	/* Exclude any attempts to start a new GP on large systems. */
> -	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
> -
>  	/* Add CPU to rcu_node bitmasks. */
>  	rnp = rdp->mynode;
>  	mask = rdp->grpmask;
> @@ -2753,8 +2751,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
>  		rnp = rnp->parent;
>  	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
> +	local_irq_restore(flags);
>  
> -	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
> +	mutex_unlock(&rsp->onoff_mutex);
>  }
>  
>  static void __cpuinit rcu_prepare_cpu(int cpu)
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 5faf05d..a240f03 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -394,11 +394,17 @@ struct rcu_state {
>  	struct rcu_head **orphan_donetail;	/* Tail of above. */
>  	long qlen_lazy;				/* Number of lazy callbacks. */
>  	long qlen;				/* Total number of callbacks. */
> +	/* End of fields guarded by onofflock. */
> +
> +	struct mutex onoff_mutex;		/* Coordinate hotplug & GPs. */
> +
>  	struct mutex barrier_mutex;		/* Guards barrier fields. */
>  	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
>  	struct completion barrier_completion;	/* Wake at barrier end. */
>  	unsigned long n_barrier_done;		/* ++ at start and end of */
>  						/*  _rcu_barrier(). */
> +	/* End of fields guarded by barrier_mutex. */
> +
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
>  						/*  force_quiescent_state(). */
>  	unsigned long n_force_qs;		/* Number of calls to */
> 

