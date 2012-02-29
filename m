Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab2B2PzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:55:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab2B2PzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:55:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of msb@google.com designates 10.68.204.1 as permitted sender) smtp.mail=msb@google.com; dkim=pass header.i=msb@google.com
Date: Wed, 29 Feb 2012 07:55:00 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [RFC][PATCH v2] cgroups: Run subsystem fork callback from
 cgroup_post_fork()
Message-ID: <20120229155500.GU3090@google.com>
References: <1330057410-9375-1-git-send-email-fweisbec@gmail.com>
 <1330362171-30697-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330362171-30697-1-git-send-email-fweisbec@gmail.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker (fweisbec@gmail.com) wrote:
> When a user freezes a cgroup, the freezer sets the subsystem state
> to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> 
> But there is a possible race here, although unlikely, if a task
> forks and the parent is preempted between write_unlock(tasklist_lock)
> and cgroup_post_fork(). If we freeze the cgroup while the parent

So what if you moved cgroup_post_forks() a few lines up to be
inside the tasklist_lock?

I agree with you on the race and believe your solution is correct.

> is sleeping and the parent wakes up thereafter, its child will
> be missing from the set of tasks to freeze because:
> 
> - The child was not yet linked to its css_set->tasks, as is done
> from cgroup_post_fork(). cgroup_iter_start() has thus missed it.
> 
> - The cgroup freezer's fork callback can handle that child but
> cgroup_fork_callbacks() has been called already.
> 
> One way to fix this is to call the fork callbacks after we link
> the task to the css set. The cgroup freezer is the only user of
> this callback anyway.
> 
> v2: Keep the call to cgroup_exit to put the css_set on fork error.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> ---
> 
> Not sure this is the right solution, especially as I still need
> a cancellable fork callback for my task counter and for this I
> need the fork callbacks to be called before the task is added
> on the tasklist. But anyway at least that reports this race.
> 

I'm new to the task counter stuff. Would you mind providing a
reference.

Regards,
Mandeep

>  kernel/cgroup.c |   39 ++++++++++++++-------------------------
>  kernel/fork.c   |    9 +--------
>  2 files changed, 15 insertions(+), 33 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c6877fe..de21e52 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4496,31 +4496,6 @@ void cgroup_fork(struct task_struct *child)
>  }
>  
>  /**
> - * cgroup_fork_callbacks - run fork callbacks
> - * @child: the new task
> - *
> - * Called on a new task very soon before adding it to the
> - * tasklist. No need to take any locks since no-one can
> - * be operating on this task.
> - */
> -void cgroup_fork_callbacks(struct task_struct *child)
> -{
> -	if (need_forkexit_callback) {
> -		int i;
> -		/*
> -		 * forkexit callbacks are only supported for builtin
> -		 * subsystems, and the builtin section of the subsys array is
> -		 * immutable, so we don't need to lock the subsys array here.
> -		 */
> -		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> -			struct cgroup_subsys *ss = subsys[i];
> -			if (ss->fork)
> -				ss->fork(child);
> -		}
> -	}
> -}
> -
> -/**
>   * cgroup_post_fork - called on a new task after adding it to the task list
>   * @child: the task in question
>   *
> @@ -4559,6 +4534,20 @@ void cgroup_post_fork(struct task_struct *child)
>  		}
>  		write_unlock(&css_set_lock);
>  	}
> +
> +	if (need_forkexit_callback) {
> +		int i;
> +		/*
> +		 * forkexit callbacks are only supported for builtin
> +		 * subsystems, and the builtin section of the subsys array is
> +		 * immutable, so we don't need to lock the subsys array here.
> +		 */
> +		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +			struct cgroup_subsys *ss = subsys[i];
> +			if (ss->fork)
> +				ss->fork(child);
> +		}
> +	}
>  }
>  /**
>   * cgroup_exit - detach cgroup from exiting task
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 051f090..551cfe0 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1053,7 +1053,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  {
>  	int retval;
>  	struct task_struct *p;
> -	int cgroup_callbacks_done = 0;
>  
>  	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>  		return ERR_PTR(-EINVAL);
> @@ -1305,12 +1304,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->group_leader = p;
>  	INIT_LIST_HEAD(&p->thread_group);
>  
> -	/* Now that the task is set up, run cgroup callbacks if
> -	 * necessary. We need to run them before the task is visible
> -	 * on the tasklist. */
> -	cgroup_fork_callbacks(p);
> -	cgroup_callbacks_done = 1;
> -
>  	/* Need tasklist lock for parent etc handling! */
>  	write_lock_irq(&tasklist_lock);
>  
> @@ -1413,7 +1406,7 @@ bad_fork_cleanup_cgroup:
>  #endif
>  	if (clone_flags & CLONE_THREAD)
>  		threadgroup_change_end(current);
> -	cgroup_exit(p, cgroup_callbacks_done);
> +	cgroup_exit(p, 0);
>  	delayacct_tsk_free(p);
>  	module_put(task_thread_info(p)->exec_domain->module);
>  bad_fork_cleanup_count:
> -- 
> 1.7.5.4
> 
