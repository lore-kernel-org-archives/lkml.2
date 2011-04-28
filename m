Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351Ab1D1Nug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:50:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760220Ab1D1Nue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:50:34 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=0i_OOtiXEx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CDHobQcqmbK4uHqxNqgA:9 a=PWNpyGOGx3nfHWfv2fwA:7 a=PUjeQqilurYA:10 a=oyh4hECdg1pM_Ti1:21 a=4c0YaOT7MAUvgBEM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <1303960136-14298-2-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 09:50:29 -0400
Message-ID: <1303998629.18763.149.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 22:08 -0500, Will Drewry wrote:

> -typedef struct { int mode; } seccomp_t;
> +/**
> + * struct seccomp_state - the state of a seccomp'ed process
> + *
> + * @mode:
> + *     if this is 1, the process is under standard seccomp rules
> + *             is 2, the process is only allowed to make system calls where
> + *                   the corresponding bit is set in bitmask and any
> + *                   associated filters evaluate successfully.

I hate arbitrary numbers. This is not a big deal, but can we create an
enum or define that puts names for the modes.

SECCOMP_MODE_BASIC
SECCOMP_MODE_FILTER

??

> + * @usage: number of references to the current instance.
> + * @bitmask: a mask of allowed or filtered system calls and additional flags.
> + * @filter_count: number of seccomp filters in @filters.
> + * @filters: list of seccomp_filter entries for  system calls.
> + */
> +struct seccomp_state {
> +	uint16_t mode;
> +	atomic_t usage;
> +	DECLARE_BITMAP(bitmask, NR_syscalls + 1);
> +	int filter_count;
> +	struct list_head filters;
> +};
> +
> +typedef struct { struct seccomp_state *state; } seccomp_t;
>  
>  extern void __secure_computing(int);
>  static inline void secure_computing(int this_syscall)
> @@ -16,8 +39,14 @@ static inline void secure_computing(int this_syscall)
>  		__secure_computing(this_syscall);
>  }
>  


> diff --git a/kernel/fork.c b/kernel/fork.c
> index e7548de..bdcf70b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -34,6 +34,7 @@
>  #include <linux/cgroup.h>
>  #include <linux/security.h>
>  #include <linux/hugetlb.h>
> +#include <linux/seccomp.h>
>  #include <linux/swap.h>
>  #include <linux/syscalls.h>
>  #include <linux/jiffies.h>
> @@ -169,6 +170,9 @@ void free_task(struct task_struct *tsk)
>  	free_thread_info(tsk->stack);
>  	rt_mutex_debug_task_free(tsk);
>  	ftrace_graph_exit_task(tsk);
> +#ifdef CONFIG_SECCOMP
> +	put_seccomp_state(tsk->seccomp.state);
> +#endif
>  	free_task_struct(tsk);
>  }
>  EXPORT_SYMBOL(free_task);
> @@ -280,6 +284,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
>  	if (err)
>  		goto out;
>  
> +#ifdef CONFIG_SECCOMP
> +	tsk->seccomp.state = get_seccomp_state(orig->seccomp.state);
> +#endif

I wonder if we could macro these to get rid of the #ifdefs in fork.c.

#define put_seccomp_state(state)	do { } while (0)
#define assign_seccomp_state(src, state) do { } while (0)

??

> +
>  	setup_thread_stack(tsk, orig);
>  	clear_user_return_notifier(tsk);
>  	clear_tsk_need_resched(tsk);
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 57d4b13..1bee87c 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -8,10 +8,11 @@
>  
>  #include <linux/seccomp.h>
>  #include <linux/sched.h>
> +#include <linux/slab.h>
>  #include <linux/compat.h>
>  
>  /* #define SECCOMP_DEBUG 1 */
> -#define NR_SECCOMP_MODES 1
> +#define NR_SECCOMP_MODES 2
>  
>  /*
>   * Secure computing mode 1 allows only read/write/exit/sigreturn.
> @@ -32,9 +33,11 @@ static int mode1_syscalls_32[] = {
>  
>  void __secure_computing(int this_syscall)
>  {
> -	int mode = current->seccomp.mode;
> +	int mode = -1;
>  	int * syscall;
> -
> +	/* Do we need an RCU read lock to access current's state? */

I'm actually confused to why you are using RCU. What are you protecting.
Currently, I see the state is always accessed from current->seccomp. But
current should not be fighting with itself.

Maybe I'm missing something.

-- Steve

> +	if (current->seccomp.state)
> +		mode = current->seccomp.state->mode;
>  	switch (mode) {
>  	case 1:
>  		syscall = mode1_syscalls;
> @@ -47,6 +50,16 @@ void __secure_computing(int this_syscall)
>  				return;
>  		} while (*++syscall);
>  		break;
> +	case 2:
> +#ifdef CONFIG_COMPAT
> +		if (is_compat_task())
> +			/* XXX: No compat support yet. */
> +			break;
> +#endif
> +		if (!seccomp_test_filters(current->seccomp.state,
> +					  this_syscall))
> +			return;
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -57,30 +70,139 @@ void __secure_computing(int this_syscall)
>  	do_exit(SIGKILL);


