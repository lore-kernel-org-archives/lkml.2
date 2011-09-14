Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1INOIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:08:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1INOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:08:00 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110914133750.739484417@chello.nl>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 16:08:06 +0200
Message-ID: <1316009286.2361.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 15:30 +0200, Peter Zijlstra a écrit :
> pièce jointe document texte brut (sched-wakeup-list.patch)
> Provide means to queue wakeup targets for later mass wakeup.
> 
> This is useful for locking primitives that can effect multiple wakeups
> per operation and want to avoid lock internal lock contention by
> delaying the wakeups until we've released the lock internal locks.
> 
> Alternatively it can be used to avoid issuing multiple wakeups, and
> thus save a few cycles, in packet processing. Queue all target tasks
> and wakeup once you've processed all packets. That way you avoid
> waking the target task multiple times if there were multiple packets
> for the same task.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched.c        |   21 +++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -1065,6 +1065,19 @@ struct uts_namespace;
>  struct rq;
>  struct sched_domain;
>  
> +struct wake_list_head {
> +	struct wake_list_node *first;
> +};
> +
> +struct wake_list_node {
> +	struct wake_list_node *next;
> +};
> +
> +#define WAKE_LIST_TAIL ((struct wake_list_node *)0x01)
> +
> +#define WAKE_LIST(name) \
> +	struct wake_list_head name = { WAKE_LIST_TAIL }
> +
>  /*
>   * wake flags
>   */
> @@ -1255,6 +1268,8 @@ struct task_struct {
>  	unsigned int btrace_seq;
>  #endif
>  
> +	struct wake_list_node wake_list;
> +
>  	unsigned int policy;
>  	cpumask_t cpus_allowed;
>  
> @@ -2143,6 +2158,35 @@ extern void wake_up_new_task(struct task
>  extern void sched_fork(struct task_struct *p);
>  extern void sched_dead(struct task_struct *p);
>  
> +static inline void
> +wake_list_add(struct wake_list_head *head, struct task_struct *p)
> +{
> +	struct wake_list_node *n = &p->wake_list;
> +
> +	get_task_struct(p);
> +	/*
> +	 * Atomically grab the task, if ->wake_list is !0 already it means
> +	 * its already queued (either by us or someone else) and will get the
> +	 * wakeup due to that.
> +	 *
> +	 * This cmpxchg() implies a full barrier, which pairs with the write
> +	 * barrier implied by the wakeup in wake_up_list().
> +	 */
> +	if (cmpxchg(&n->next, 0, n) != 0) {
> +		/* It was already queued, drop the extra ref and we're done. */
> +		put_task_struct(p);
> +		return;
> +	}
> +
> +	/*
> +	 * The head is context local, there can be no concurrency.
> +	 */
> +	n->next = head->first;
> +	head->first = n;
> +}
> +

I dont understand why you make a get_task_struct() before the cmpxchg()
and rollback. We certainly must hold a lock/mutex before calling
wake_list_add()

It could be :

{
	if (cmpxchg(&n->next, NULL, head->first))
		return;
	 
	get_task_struct(p);
	head->first = n;
}


