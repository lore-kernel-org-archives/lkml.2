Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2IMKAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:00:51 -0400
Received: from [205.233.59.134] ([205.233.59.134]:58193 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2IMKAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:00:50 -0400
Message-ID: <1347530393.15764.115.camel@twins>
Subject: Re: [PATCH] lockdep: Check if nested lock is actually held
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Sep 2012 11:59:53 +0200
In-Reply-To: <5051A9E7.5040501@canonical.com>
References: <5051A9E7.5040501@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 11:39 +0200, Maarten Lankhorst wrote:
> It is considered good form to lock the lock you claim to be nested in.

Uhm yeah.. cute. You actually found a site where this triggered?

> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index ea9ee45..7175447 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2998,6 +2998,43 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
>  
>  struct lock_class_key __lockdep_no_validate__;
>  
> +static int
> +print_lock_nested_lock_not_held(struct task_struct *curr,
> +				struct held_lock *lock,
> +				struct lockdep_map *nest,
> +				unsigned long ip)
> +{
> +	if (!debug_locks_off())
> +		return 0;
> +	if (debug_locks_silent)
> +		return 0;
> +
> +	printk("\n");
> +	printk("==================================\n");
> +	printk("[ BUG: Nested lock was not taken ]\n");
> +	print_kernel_ident();
> +	printk("----------------------------------\n");
> +
> +	printk("%s/%d is trying to lock:\n", curr->comm, task_pid_nr(curr));
> +	print_lock(lock);
> +
> +	printk("\nbut this task is not holding:\n");
> +	printk("%s\n", nest->name);
> +
> +	printk("\nstack backtrace:\n");
> +	dump_stack();
> +
> +	printk("\nother info that might help us debug this:\n");
> +	lockdep_print_held_locks(curr);
> +
> +	printk("\nstack backtrace:\n");
> +	dump_stack();
> +
> +	return 0;
> +}
> +
> +static int __lock_is_held(struct lockdep_map *lock);
> +
>  /*
>   * This gets called for every mutex_lock*()/spin_lock*() operation.
>   * We maintain the dependency maps and validate the locking attempt:
> @@ -3139,6 +3176,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  	}
>  	chain_key = iterate_chain_key(chain_key, id);
>  
> +	if (nest_lock && !__lock_is_held(nest_lock))
> +		return print_lock_nested_lock_not_held(curr, hlock,
> +						       nest_lock, ip);

At this time we've already set hlock->nest_lock, so I've shortened the
argument list here a little.

>  	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
>  		return 0;
>  
> 

