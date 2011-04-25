Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab1DYRiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:38:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652Ab1DYRiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iGKA61Uo1lG1Zu/BPQfwybJoiG036K5JeQcJTtZS3lSG7QeFgUuYPENyr+N4EBkCSC
         hkau2/gRVLqSnnNP6FS6Mdp5nllZmV98vob5OGvjSNmg52i8UX2auV8l/aFDafdp+8Pv
         /iAuxNSKQhd6qaGQ7SJdClKdV+XV8D8FS3rUM=
Date: Mon, 25 Apr 2011 19:37:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
Message-ID: <20110425173750.GB5055@nowhere>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
 <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg.

I realize you weren't in the Cc list, which wasn't definitly not
intended.

I think you were fine with the change. But to be sure, can I have your ack?

Thanks.

On Fri, Apr 08, 2011 at 07:34:23PM +0200, Frederic Weisbecker wrote:
> When a task is traced and is in a stopped state, the tracer
> may execute a ptrace request to examine the tracee state and
> get its task struct. Right after, the tracee can be killed
> and thus its breakpoints released.
> This can happen concurrently when the tracer is in the middle
> of reading or modifying these breakpoints, leading to dereferencing
> a freed pointer.
> 
> Hence, to prepare the fix, create a generic breakpoint reference
> holding API. When a reference on the breakpoints of a task is
> held, the breakpoints won't be released until the last reference
> is dropped. After that, no more ptrace request on the task's
> breakpoints can be serviced for the tracer.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: v2.6.33.. <stable@kernel.org>
> ---
>  include/linux/ptrace.h |   13 ++++++++++++-
>  include/linux/sched.h  |    3 +++
>  kernel/exit.c          |    2 +-
>  kernel/ptrace.c        |   17 +++++++++++++++++
>  4 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index a1147e5..9178d5c 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -189,6 +189,10 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
>  		child->ptrace = current->ptrace;
>  		__ptrace_link(child, current->parent);
>  	}
> +
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +	atomic_set(&child->ptrace_bp_refcnt, 1);
> +#endif
>  }
>  
>  /**
> @@ -350,6 +354,13 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
>  				unsigned long args[6], unsigned int maxargs,
>  				unsigned long *sp, unsigned long *pc);
>  
> -#endif
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +extern int ptrace_get_breakpoints(struct task_struct *tsk);
> +extern void ptrace_put_breakpoints(struct task_struct *tsk);
> +#else
> +static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
> +#endif /* CONFIG_HAVE_HW_BREAKPOINT */
> +
> +#endif /* __KERNEL */
>  
>  #endif
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 83bd2e2..15badfa 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1534,6 +1534,9 @@ struct task_struct {
>  		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
>  	} memcg_batch;
>  #endif
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +	atomic_t ptrace_bp_refcnt;
> +#endif
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6a488ad..437e327 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1016,7 +1016,7 @@ NORET_TYPE void do_exit(long code)
>  	/*
>  	 * FIXME: do that only when needed, using sched_exit tracepoint
>  	 */
> -	flush_ptrace_hw_breakpoint(tsk);
> +	ptrace_put_breakpoints(tsk);
>  
>  	exit_notify(tsk, group_dead);
>  #ifdef CONFIG_NUMA
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 0fc1eed..dc7ab65 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -22,6 +22,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
>  #include <linux/regset.h>
> +#include <linux/hw_breakpoint.h>
>  
>  
>  /*
> @@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>  	return ret;
>  }
>  #endif	/* CONFIG_COMPAT */
> +
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +int ptrace_get_breakpoints(struct task_struct *tsk)
> +{
> +	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
> +		return 0;
> +
> +	return -1;
> +}
> +
> +void ptrace_put_breakpoints(struct task_struct *tsk)
> +{
> +	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
> +		flush_ptrace_hw_breakpoint(tsk);
> +}
> +#endif /* CONFIG_HAVE_HW_BREAKPOINT */
> -- 
> 1.7.3.2
> 
