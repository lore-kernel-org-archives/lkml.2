Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1AHSH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:07:26 -0500
Received: from lo.gmane.org ([80.91.229.12]:42839 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1AHSHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:07:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Screwing with the concurrency limit
Date: Sat, 08 Jan 2011 10:06:04 -0800
Message-ID: <iga94g$hkf$1@dough.gmane.org>
References: <4D287AED.9090304@gmail.com> <20110108161840.GC13269@mtj.dyndns.org> <20110108163733.GD13269@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: c-76-105-220-120.hsd1.or.comcast.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
In-Reply-To: <20110108163733.GD13269@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 08:37 AM, Tejun Heo wrote:
> On Sat, Jan 08, 2011 at 11:18:40AM -0500, Tejun Heo wrote:
>> workqueue_set_max_active() would need a bit update to make it behave
>> under such dynamic usage (so that it returns the original max_active
>> after applying the new one and kicks the delayed work items when
>> max_active gets increased) but if that sounds like a plan which could
>> work, I'll be happy to update it.
>
> So, something like the following.  It's only compile tested but the
> idea is to update workqueue_set_max_active() such that
>
> * If 0 is specified as the new @max_active, the default concurrency
>    level is used.
>
> * The old max_active is returned so that it can be restored later.
>
> * When max_active changes, if it becomes higher, the delayed work
>    items will be activated immediately.

Well, that doesn't quite do it, I'd need workqueue_inc_max_active() and 
workqueue_dec_max_active()... set_max_active() would be racy. But those 
would be trivial now that I've seen your patch (I missed 
workqueue_set_max_active() when I was reading through the code earlier).

But also there's no point in adjusting max_active on every cpu's 
workqueue, adjusting just the one on the local cpu would do exactly what 
I want and be more efficient too... Can you see any issues in doing it 
that way?

What I was really hoping for was something like... maybe 
move_work_to_workqueue() - if you could do that on the work item you're 
executing, move it from the workqueue that has max_active = 1 to a 
different one - it's stateless from the caller's perspective. But I 
suspect that'd be more complicated than your way of doing it, and 
inc()/dec() is probably just as good...

> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 0c0771f..bea79ed 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -363,8 +363,8 @@ extern bool flush_delayed_work(struct delayed_work *dwork);
>   extern bool flush_delayed_work_sync(struct delayed_work *work);
>   extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
>
> -extern void workqueue_set_max_active(struct workqueue_struct *wq,
> -				     int max_active);
> +extern int workqueue_set_max_active(struct workqueue_struct *wq,
> +				    int max_active);
>   extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
>   extern unsigned int work_cpu(struct work_struct *work);
>   extern unsigned int work_busy(struct work_struct *work);
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index e785b0f..0a45072 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2814,11 +2814,13 @@ static void free_cwqs(struct workqueue_struct *wq)
>   	}
>   }
>
> -static int wq_clamp_max_active(int max_active, unsigned int flags,
> -			       const char *name)
> +static int wq_determine_max_active(int max_active, unsigned int flags,
> +				   const char *name)
>   {
>   	int lim = flags&  WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
>
> +	max_active = max_active ?: WQ_DFL_ACTIVE;
> +
>   	if (max_active<  1 || max_active>  lim)
>   		printk(KERN_WARNING "workqueue: max_active %d requested for %s "
>   		       "is out of range, clamping between %d and %d\n",
> @@ -2827,6 +2829,15 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
>   	return clamp_val(max_active, 1, lim);
>   }
>
> +static void cwq_set_max_active(struct cpu_workqueue_struct *cwq, int max_active)
> +{
> +	cwq->max_active = max_active;
> +
> +	while (!list_empty(&cwq->delayed_works)&&
> +	       cwq->nr_active<  cwq->max_active)
> +		cwq_activate_first_delayed(cwq);
> +}
> +
>   struct workqueue_struct *__alloc_workqueue_key(const char *name,
>   					       unsigned int flags,
>   					       int max_active,
> @@ -2850,8 +2861,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
>   	if (flags&  WQ_UNBOUND)
>   		flags |= WQ_HIGHPRI;
>
> -	max_active = max_active ?: WQ_DFL_ACTIVE;
> -	max_active = wq_clamp_max_active(max_active, flags, name);
> +	max_active = wq_determine_max_active(max_active, flags, name);
>
>   	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
>   	if (!wq)
> @@ -2879,8 +2889,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
>   		cwq->gcwq = gcwq;
>   		cwq->wq = wq;
>   		cwq->flush_color = -1;
> -		cwq->max_active = max_active;
>   		INIT_LIST_HEAD(&cwq->delayed_works);
> +		cwq_set_max_active(cwq, max_active);
>   	}
>
>   	if (flags&  WQ_RESCUER) {
> @@ -2910,7 +2920,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
>
>   	if (workqueue_freezing&&  wq->flags&  WQ_FREEZEABLE)
>   		for_each_cwq_cpu(cpu, wq)
> -			get_cwq(cpu, wq)->max_active = 0;
> +			cwq_set_max_active(get_cwq(cpu, wq), 0);
>
>   	list_add(&wq->list,&workqueues);
>
> @@ -2981,29 +2991,31 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
>    * CONTEXT:
>    * Don't call from IRQ context.
>    */
> -void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
> +int workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
>   {
> +	int old_max_active;
>   	unsigned int cpu;
>
> -	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
> +	max_active = wq_determine_max_active(max_active, wq->flags, wq->name);
>
>   	spin_lock(&workqueue_lock);
>
> +	old_max_active = wq->saved_max_active;
>   	wq->saved_max_active = max_active;
>
>   	for_each_cwq_cpu(cpu, wq) {
>   		struct global_cwq *gcwq = get_gcwq(cpu);
> +		struct cpu_workqueue_struct *cwq = get_cwq(gcwq->cpu, wq);
>
>   		spin_lock_irq(&gcwq->lock);
> -
> -		if (!(wq->flags&  WQ_FREEZEABLE) ||
> -		    !(gcwq->flags&  GCWQ_FREEZING))
> -			get_cwq(gcwq->cpu, wq)->max_active = max_active;
> -
> +		if (cwq->max_active)
> +			cwq_set_max_active(cwq, max_active);
>   		spin_unlock_irq(&gcwq->lock);
>   	}
>
>   	spin_unlock(&workqueue_lock);
> +
> +	return old_max_active;
>   }
>   EXPORT_SYMBOL_GPL(workqueue_set_max_active);
>
> @@ -3533,7 +3545,7 @@ void freeze_workqueues_begin(void)
>   			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
>
>   			if (cwq&&  wq->flags&  WQ_FREEZEABLE)
> -				cwq->max_active = 0;
> +				cwq_set_max_active(cwq, 0);
>   		}
>
>   		spin_unlock_irq(&gcwq->lock);
> @@ -3622,11 +3634,7 @@ void thaw_workqueues(void)
>   				continue;
>
>   			/* restore max_active and repopulate worklist */
> -			cwq->max_active = wq->saved_max_active;
> -
> -			while (!list_empty(&cwq->delayed_works)&&
> -			       cwq->nr_active<  cwq->max_active)
> -				cwq_activate_first_delayed(cwq);
> +			cwq_set_max_active(cwq, wq->saved_max_active);
>   		}
>
>   		wake_up_worker(gcwq);


