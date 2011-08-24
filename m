Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1HXQMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1HXQMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:12:08 -0400
Date: Wed, 24 Aug 2011 18:08:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "J.H." <warthog9@kernel.org>, users@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        "yong.zhang0" <yong.zhang0@gmail.com>, mingo@kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>,
        scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        hch <hch@infradead.org>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110824160806.GA12317@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314129133.8002.102.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the next emails, I guess this is already off-topic, but still...

On 08/23, Peter Zijlstra wrote:
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2630,7 +2630,6 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  		smp_send_reschedule(cpu);
>  }
>
> -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
>  {
>  	struct rq *rq;
> @@ -2647,7 +2646,6 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
>  	return ret;
>
>  }
> -#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  #endif /* CONFIG_SMP */
>
>  static void ttwu_queue(struct task_struct *p, int cpu)
> @@ -2705,7 +2703,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  	 * this task as prev, wait until its done referencing the task.
>  	 */
>  	while (p->on_cpu) {
> -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  		/*
>  		 * In case the architecture enables interrupts in
>  		 * context_switch(), we cannot busy wait, since that
> @@ -2713,11 +2710,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		 * tries to wake up @prev. So bail and do a complete
>  		 * remote wakeup.
>  		 */
> -		if (ttwu_activate_remote(p, wake_flags))
> +		if (cpu == smp_processor_id() &&

I think this needs "task_cpu(p) == smp_processor_id()". We can't trust
"cpu", task_cpu() was called before ->on_rq check.

This task_cpu() looks really confusing imho, even if it is fine (afaics).
Perhaps it makes sense to do

	--- x/kernel/sched.c
	+++ x/kernel/sched.c
	@@ -2694,10 +2694,11 @@ try_to_wake_up(struct task_struct *p, un
			goto out;
	 
		success = 1; /* we're going to change ->state */
	-	cpu = task_cpu(p);
	 
	-	if (p->on_rq && ttwu_remote(p, wake_flags))
	+	if (p->on_rq && ttwu_remote(p, wake_flags)) {
	+		cpu = task_cpu(p); /* for ttwu_stat() */
			goto stat;
	+	}
	 
	 #ifdef CONFIG_SMP
		/*

to make this more clear. Or even the patch below, I dunno.

Oleg.

--- x/kernel/sched.c
+++ x/kernel/sched.c
@@ -2446,13 +2446,14 @@ static void update_avg(u64 *avg, u64 sam
 #endif
 
 static void
-ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
+ttwu_stat(struct task_struct *p, int wake_flags)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct rq *rq = this_rq();
 
 #ifdef CONFIG_SMP
 	int this_cpu = smp_processor_id();
+	int cpu = task_cpu(p);
 
 	if (cpu == this_cpu) {
 		schedstat_inc(rq, ttwu_local);
@@ -2694,7 +2695,6 @@ try_to_wake_up(struct task_struct *p, un
 		goto out;
 
 	success = 1; /* we're going to change ->state */
-	cpu = task_cpu(p);
 
 	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
@@ -2739,7 +2739,7 @@ try_to_wake_up(struct task_struct *p, un
 
 	ttwu_queue(p, cpu);
 stat:
-	ttwu_stat(p, cpu, wake_flags);
+	ttwu_stat(p, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
@@ -2775,7 +2775,7 @@ static void try_to_wake_up_local(struct 
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_do_wakeup(rq, p, 0);
-	ttwu_stat(p, smp_processor_id(), 0);
+	ttwu_stat(p, 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
 }

