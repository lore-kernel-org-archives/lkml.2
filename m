Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2BXEc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:32:59 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62477 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab2BXEc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:32:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.229.77.5 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Fri, 24 Feb 2012 05:32:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [RFC][PATCH] cgroups: Run subsystem fork callback from
 cgroup_post_fork()
Message-ID: <20120224043250.GA9342@somewhere.redhat.com>
References: <1330057410-9375-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330057410-9375-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 05:23:30AM +0100, Frederic Weisbecker wrote:
> When a user freezes a cgroup, the freezer sets the subsystem state
> to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> 
> But there is a possible race here, although unlikely, if a task
> forks and the parent is preempted between write_unlock(tasklist_lock)
> and cgroup_post_fork(). If we freeze the cgroup while the parent
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
>  include/linux/cgroup.h |    4 ++--
>  kernel/cgroup.c        |   44 ++++++++++++++++----------------------------
>  kernel/exit.c          |    2 +-
>  kernel/fork.c          |    8 --------
>  4 files changed, 19 insertions(+), 39 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 501adb1..1d3f3ce 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -34,7 +34,7 @@ extern void cgroup_unlock(void);
>  extern void cgroup_fork(struct task_struct *p);
>  extern void cgroup_fork_callbacks(struct task_struct *p);
>  extern void cgroup_post_fork(struct task_struct *p);
> -extern void cgroup_exit(struct task_struct *p, int run_callbacks);
> +extern void cgroup_exit(struct task_struct *p);
>  extern int cgroupstats_build(struct cgroupstats *stats,
>  				struct dentry *dentry);
>  extern int cgroup_load_subsys(struct cgroup_subsys *ss);
> @@ -611,7 +611,7 @@ static inline int cgroup_init(void) { return 0; }
>  static inline void cgroup_fork(struct task_struct *p) {}
>  static inline void cgroup_fork_callbacks(struct task_struct *p) {}
>  static inline void cgroup_post_fork(struct task_struct *p) {}
> -static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
> +static inline void cgroup_exit(struct task_struct *p) {}
>  
>  static inline void cgroup_lock(void) {}
>  static inline void cgroup_unlock(void) {}
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c6877fe..bdf874b 100644
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
> @@ -4559,11 +4534,24 @@ void cgroup_post_fork(struct task_struct *child)
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
>   * @tsk: pointer to task_struct of exiting process
> - * @run_callback: run exit callbacks?
>   *
>   * Description: Detach cgroup from @tsk and release it.
>   *
> @@ -4595,7 +4583,7 @@ void cgroup_post_fork(struct task_struct *child)
>   *    which wards off any cgroup_attach_task() attempts, or task is a failed
>   *    fork, never visible to cgroup_attach_task.
>   */
> -void cgroup_exit(struct task_struct *tsk, int run_callbacks)
> +void cgroup_exit(struct task_struct *tsk)
>  {
>  	struct css_set *cg;
>  	int i;
> @@ -4617,7 +4605,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  	cg = tsk->cgroups;
>  	tsk->cgroups = &init_css_set;
>  
> -	if (run_callbacks && need_forkexit_callback) {
> +	if (need_forkexit_callback) {
>  		/*
>  		 * modular subsystems can't use callbacks, so no need to lock
>  		 * the subsys array
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 294b170..d975233 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -990,7 +990,7 @@ void do_exit(long code)
>  	 */
>  	perf_event_exit_task(tsk);
>  
> -	cgroup_exit(tsk, 1);
> +	cgroup_exit(tsk);
>  
>  	if (group_dead)
>  		disassociate_ctty(1);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 051f090..d016fe9 100644
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
> @@ -1413,7 +1406,6 @@ bad_fork_cleanup_cgroup:
>  #endif
>  	if (clone_flags & CLONE_THREAD)
>  		threadgroup_change_end(current);
> -	cgroup_exit(p, cgroup_callbacks_done);

Ah, we still need the cgroup_exit() to put the css_set.
Will fix.

>  	delayacct_tsk_free(p);
>  	module_put(task_thread_info(p)->exec_domain->module);
>  bad_fork_cleanup_count:
> -- 
> 1.7.5.4
> 
