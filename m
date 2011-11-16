Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1KPVxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:53:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58919 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab1KPVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:52:57 -0500
Date: Wed, 16 Nov 2011 21:52:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Message-ID: <20111116215236.GD3366@decadent.org.uk>
References: <1319773015.6759.30.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319773015.6759.30.camel@deadeye>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please could you ack or nak this?

Ben.

On Fri, Oct 28, 2011 at 04:36:55AM +0100, Ben Hutchings wrote:
> Currently lock debugging is disabled when the kernel is tainted, with
> a few exceptions.  It is already recognised that this can be useful
> for staging modules (TAINT_CRAP), but that also goes for out-of-tree
> modules (TAINT_OOT_MODULE) so long as core kernel developers don't
> have to spend time debugging them.  Also, there are several reasons
> for tainting that are unlikely to introduce false locking bug reports
> (e.g. TAINT_FIRMWARE_WORKAROUND).
> 
> Instead of disabling lock debugging, show the taint flags in all
> lockdep and rtmutex-debug error messages.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  kernel/lockdep.c       |   23 +++++++++++++++--------
>  kernel/panic.c         |   10 ----------
>  kernel/rtmutex-debug.c |    1 +
>  3 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e69434b..b2c4537 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -567,11 +567,12 @@ static void lockdep_print_held_locks(struct task_struct *curr)
>  	}
>  }
>  
> -static void print_kernel_version(void)
> +static void print_kernel_ident(void)
>  {
> -	printk("%s %.*s\n", init_utsname()->release,
> +	printk("%s %.*s %s\n", init_utsname()->release,
>  		(int)strcspn(init_utsname()->version, " "),
> -		init_utsname()->version);
> +		init_utsname()->version,
> +		print_tainted());
>  }
>  
>  static int very_verbose(struct lock_class *class)
> @@ -1148,7 +1149,7 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
>  	printk("\n");
>  	printk("======================================================\n");
>  	printk("[ INFO: possible circular locking dependency detected ]\n");
> -	print_kernel_version();
> +	print_kernel_ident();
>  	printk("-------------------------------------------------------\n");
>  	printk("%s/%d is trying to acquire lock:\n",
>  		curr->comm, task_pid_nr(curr));
> @@ -1487,7 +1488,7 @@ print_bad_irq_dependency(struct task_struct *curr,
>  	printk("======================================================\n");
>  	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
>  		irqclass, irqclass);
> -	print_kernel_version();
> +	print_kernel_ident();
>  	printk("------------------------------------------------------\n");
>  	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
>  		curr->comm, task_pid_nr(curr),
> @@ -1716,7 +1717,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
>  	printk("\n");
>  	printk("=============================================\n");
>  	printk("[ INFO: possible recursive locking detected ]\n");
> -	print_kernel_version();
> +	print_kernel_ident();
>  	printk("---------------------------------------------\n");
>  	printk("%s/%d is trying to acquire lock:\n",
>  		curr->comm, task_pid_nr(curr));
> @@ -2223,7 +2224,7 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
>  	printk("\n");
>  	printk("=================================\n");
>  	printk("[ INFO: inconsistent lock state ]\n");
> -	print_kernel_version();
> +	print_kernel_ident();
>  	printk("---------------------------------\n");
>  
>  	printk("inconsistent {%s} -> {%s} usage.\n",
> @@ -2288,7 +2289,7 @@ print_irq_inversion_bug(struct task_struct *curr,
>  	printk("\n");
>  	printk("=========================================================\n");
>  	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
> -	print_kernel_version();
> +	print_kernel_ident();
>  	printk("---------------------------------------------------------\n");
>  	printk("%s/%d just changed the state of lock:\n",
>  		curr->comm, task_pid_nr(curr));
> @@ -3169,6 +3170,7 @@ print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
>  	printk("\n");
>  	printk("=====================================\n");
>  	printk("[ BUG: bad unlock balance detected! ]\n");
> +	print_kernel_ident();
>  	printk("-------------------------------------\n");
>  	printk("%s/%d is trying to release lock (",
>  		curr->comm, task_pid_nr(curr));
> @@ -3613,6 +3615,7 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
>  	printk("\n");
>  	printk("=================================\n");
>  	printk("[ BUG: bad contention detected! ]\n");
> +	print_kernel_ident();
>  	printk("---------------------------------\n");
>  	printk("%s/%d is trying to contend lock (",
>  		curr->comm, task_pid_nr(curr));
> @@ -3987,6 +3990,7 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
>  	printk("\n");
>  	printk("=========================\n");
>  	printk("[ BUG: held lock freed! ]\n");
> +	print_kernel_ident();
>  	printk("-------------------------\n");
>  	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
>  		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
> @@ -4044,6 +4048,7 @@ static void print_held_locks_bug(struct task_struct *curr)
>  	printk("\n");
>  	printk("=====================================\n");
>  	printk("[ BUG: lock held at task exit time! ]\n");
> +	print_kernel_ident();
>  	printk("-------------------------------------\n");
>  	printk("%s/%d is exiting with locks still held!\n",
>  		curr->comm, task_pid_nr(curr));
> @@ -4141,6 +4146,7 @@ void lockdep_sys_exit(void)
>  		printk("\n");
>  		printk("================================================\n");
>  		printk("[ BUG: lock held when returning to user space! ]\n");
> +		print_kernel_ident();
>  		printk("------------------------------------------------\n");
>  		printk("%s/%d is leaving the kernel with locks still held!\n",
>  				curr->comm, curr->pid);
> @@ -4160,6 +4166,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
>  	printk("\n");
>  	printk("===============================\n");
>  	printk("[ INFO: suspicious RCU usage. ]\n");
> +	print_kernel_ident();
>  	printk("-------------------------------\n");
>  	printk("%s:%d %s!\n", file, line, s);
>  	printk("\nother info that might help us debug this:\n\n");
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b2659360..ad03fb5 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -233,16 +233,6 @@ unsigned long get_taint(void)
>  
>  void add_taint(unsigned flag)
>  {
> -	/*
> -	 * Can't trust the integrity of the kernel anymore.
> -	 * We don't call directly debug_locks_off() because the issue
> -	 * is not necessarily serious enough to set oops_in_progress to 1
> -	 * Also we want to keep up lockdep for staging development and
> -	 * post-warning case.
> -	 */
> -	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
> -		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
> -
>  	set_bit(flag, &tainted_mask);
>  }
>  EXPORT_SYMBOL(add_taint);
> diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
> index a2e7e72..077257f 100644
> --- a/kernel/rtmutex-debug.c
> +++ b/kernel/rtmutex-debug.c
> @@ -101,6 +101,7 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
>  
>  	printk("\n============================================\n");
>  	printk(  "[ BUG: circular locking deadlock detected! ]\n");
> +	printk("%s\n", print_tainted());
>  	printk(  "--------------------------------------------\n");
>  	printk("%s/%d is deadlocking current task %s/%d\n\n",
>  	       task->comm, task_pid_nr(task),
> -- 
> 1.7.7
> 
> 
> 

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
