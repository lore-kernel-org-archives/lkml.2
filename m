Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab0ECMLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:11:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:53047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab0ECMLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:11:51 -0400
Subject: Re: [PATCH] lockdep: reduce stack_trace usage
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: John Kacur <jkacur@redhat.com>, Yong Zhang <yong.zhang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100423134044.GA2777@zhy-desktop>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
	 <1272009915.1646.25.camel@laptop>
	 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
	 <20100423134044.GA2777@zhy-desktop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 May 2010 14:11:29 +0200
Message-ID: <1272888689.5605.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 21:40 +0800, Yong Zhang wrote:

> From 6b9d513b7c417c0805ef0acc1cb3227bddba0889 Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Fri, 23 Apr 2010 21:13:54 +0800
> Subject: [PATCH] lockdep: reduce stack_trace usage
> 
> When calling check_prevs_add(), if all validations passed
> add_lock_to_list() will add new lock to dependency tree and
> alloc stack_trace for each list_entry. But at this time,
> we are always on the same stack, so stack_trace for each
> list_entry has the same value. This is redundant and eats up
> lots of memory which could lead to warning on low
> MAX_STACK_TRACE_ENTRIES.
> Using one copy of stack_trace instead.

OK, I like the idea, but I'm a little confused as to why you pull
save_trace() up two functions, from what I can see we can now end up
saving a trace where we previously would not have done one (the whole
recursive lock mess.

So please respin this with save_trace() in check_prev_add() right before
the first add_lock_to_list().

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  kernel/lockdep.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 2594e1c..097d5fb 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -818,7 +818,8 @@ static struct lock_list *alloc_list_entry(void)
>   * Add a new dependency to the head of the list:
>   */
>  static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
> -			    struct list_head *head, unsigned long ip, int distance)
> +			    struct list_head *head, unsigned long ip,
> +			    int distance, struct stack_trace *trace)
>  {
>  	struct lock_list *entry;
>  	/*
> @@ -829,11 +830,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
>  	if (!entry)
>  		return 0;
>  
> -	if (!save_trace(&entry->trace))
> -		return 0;
> -
>  	entry->class = this;
>  	entry->distance = distance;
> +	entry->trace = *trace;
>  	/*
>  	 * Since we never remove from the dependency list, the list can
>  	 * be walked lockless by other CPUs, it's only allocation
> @@ -1635,7 +1634,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
>   */
>  static int
>  check_prev_add(struct task_struct *curr, struct held_lock *prev,
> -	       struct held_lock *next, int distance)
> +	       struct held_lock *next, int distance, struct stack_trace *trace)
>  {
>  	struct lock_list *entry;
>  	int ret;
> @@ -1694,14 +1693,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
>  	 */
>  	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
>  			       &hlock_class(prev)->locks_after,
> -			       next->acquire_ip, distance);
> +			       next->acquire_ip, distance, trace);
>  
>  	if (!ret)
>  		return 0;
>  
>  	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
>  			       &hlock_class(next)->locks_before,
> -			       next->acquire_ip, distance);
> +			       next->acquire_ip, distance, trace);
>  	if (!ret)
>  		return 0;
>  
> @@ -1732,6 +1731,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  {
>  	int depth = curr->lockdep_depth;
>  	struct held_lock *hlock;
> +	struct stack_trace trace;
>  
>  	/*
>  	 * Debugging checks.
> @@ -1748,6 +1748,9 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  			curr->held_locks[depth-1].irq_context)
>  		goto out_bug;
>  
> +	if (!save_trace(&trace))
> +		return 0;
> +
>  	for (;;) {
>  		int distance = curr->lockdep_depth - depth + 1;
>  		hlock = curr->held_locks + depth-1;
> @@ -1756,7 +1759,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  		 * added:
>  		 */
>  		if (hlock->read != 2) {
> -			if (!check_prev_add(curr, hlock, next, distance))
> +			if (!check_prev_add(curr, hlock, next,
> +						distance, &trace))
>  				return 0;
>  			/*
>  			 * Stop after the first non-trylock entry,

