Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1KYOBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:01:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39744 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1KYOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:01:45 -0500
Date: Fri, 25 Nov 2011 15:01:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock() to
 cover exit and exec
Message-ID: <20111125140136.GC23307@somewhere.redhat.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124225054.GA14828@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 02:50:54PM -0800, Tejun Heo wrote:
> threadgroup_lock() protected only protected against new addition to
> the threadgroup, which was inherently somewhat incomplete and
> problematic for its only user cgroup.  On-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
> 
> This patch extends threadgroup_lock() such that it protects against
> all three threadgroup altering operations - fork, exit and exec.  For
> exit, threadgroup_change_begin/end() calls are added to exit path.
> For exec, threadgroup_[un]lock() are updated to also grab and release
> cred_guard_mutex.
> 
> With this change, threadgroup_lock() guarantees that the target
> threadgroup will remain stable - no new task will be added, no new
> PF_EXITING will be set and exec won't happen.
> 
> The next patch will update cgroup so that it can take full advantage
> of this change.
> 
> -v2: beefed up comment as suggested by Frederic.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> 
> Linus, this is something being scheduled for the next merge window.
> It extends threadgroup locking which cgroup used to do to exclude only
> fork path so that it includes exit and exec paths.  threadgroup
> locking is used by cgroup to implement process-scope cgroup migration.
> 
> Migration happens in multiple steps, at each of which the matching
> method of each cgroup plugin is called.  When a whole process is being
> migrated, methods being called at those different steps expect to see
> consistent image of the thread group.
> 
> cgroup currently only locks out addition of new tasks into the thread
> group and holds extra ref to member tasks.  This mandates all cgroup
> plugins to deal with tasks being torn down and exec morphing the
> threadgroup.  This patch extends the scope of threadgroup locking such
> that the thread group is guaranteed to be stable (no new task, tasks
> are either live or dead and no exec morphing) while locked.
> 
> This is part of changes to clean up cgroup methods and iron out corner
> case fuzziness and should make difficult-to-reproduce race conditions
> less likely and cgroup plugins easier to implement and verify.
> 
> The synchronization is strictly per-threadgroup and goes away if
> cgroup is not configured.
> 
> The whole series is avilable at
> 
>   http://thread.gmane.org/gmane.linux.kernel.containers/21716
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.3
> 
> Thank you.
> 
>  include/linux/sched.h |   47 +++++++++++++++++++++++++++++++++++++++++------
>  kernel/exit.c         |   19 +++++++++++++++----
>  2 files changed, 56 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c5acbce..481c5ed 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -635,11 +635,12 @@ struct signal_struct {
>  #endif
>  #ifdef CONFIG_CGROUPS
>  	/*
> -	 * The group_rwsem prevents threads from forking with
> -	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
> -	 * threadgroup-wide operations. It's taken for reading in fork.c in
> -	 * copy_process().
> -	 * Currently only needed write-side by cgroups.
> +	 * group_rwsem prevents new tasks from entering the threadgroup and
> +	 * member tasks from exiting.  fork and exit paths are protected
> +	 * with this rwsem using threadgroup_change_begin/end().  Users
> +	 * which require threadgroup to remain stable should use
> +	 * threadgroup_[un]lock() which also takes care of exec path.
> +	 * Currently, cgroup is the only user.
>  	 */
>  	struct rw_semaphore group_rwsem;
>  #endif
> @@ -2374,7 +2375,6 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
>  	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
>  }
>  
> -/* See the declaration of group_rwsem in signal_struct. */
>  #ifdef CONFIG_CGROUPS
>  static inline void threadgroup_change_begin(struct task_struct *tsk)
>  {
> @@ -2384,13 +2384,48 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
>  {
>  	up_read(&tsk->signal->group_rwsem);
>  }
> +
> +/**
> + * threadgroup_lock - lock threadgroup
> + * @tsk: member task of the threadgroup to lock
> + *
> + * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
> + * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
> + * perform exec.  This is useful for cases where the threadgroup needs to
> + * stay stable across blockable operations.
> + *
> + * fork and exit explicitly call threadgroup_change_{begin|end}() for
> + * synchronization.  This excludes most of do_exit() to ensure that, while
> + * locked, tasks belonging to a locked group are not in the process of
> + * deconstruction - they're either alive or dead.
> + *
> + * During exec, a task goes and puts its thread group through unusual
> + * changes.  After de-threading, exclusive access is assumed to resources
> + * which are usually shared by tasks in the same group - e.g. sighand may
> + * be replaced with a new one.  Also, the exec'ing task takes over group
> + * leader role including its pid.  Exclude these changes while locked by
> + * grabbing cred_guard_mutex which is used to synchronize exec path.
> + */
>  static inline void threadgroup_lock(struct task_struct *tsk)
>  {
> +	/*
> +	 * exec uses exit for de-threading nesting group_rwsem inside
> +	 * cred_guard_mutex. Grab cred_guard_mutex first.
> +	 */
> +	mutex_lock(&tsk->signal->cred_guard_mutex);
>  	down_write(&tsk->signal->group_rwsem);
>  }
> +
> +/**
> + * threadgroup_unlock - unlock threadgroup
> + * @tsk: member task of the threadgroup to unlock
> + *
> + * Reverse threadgroup_lock().
> + */
>  static inline void threadgroup_unlock(struct task_struct *tsk)
>  {
>  	up_write(&tsk->signal->group_rwsem);
> +	mutex_unlock(&tsk->signal->cred_guard_mutex);
>  }
>  #else
>  static inline void threadgroup_change_begin(struct task_struct *tsk) {}
> diff --git a/kernel/exit.c b/kernel/exit.c
> index d0b7d98..b2cb562 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -936,6 +936,14 @@ NORET_TYPE void do_exit(long code)
>  		schedule();
>  	}
>  
> +	/*
> +	 * @tsk's threadgroup is going through changes - lock out users
> +	 * which expect stable threadgroup.  Do this before actually
> +	 * starting tearing down @tsk so that locked threadgroup has either
> +	 * alive or dead tasks, not something inbetween.
> +	 */
> +	threadgroup_change_begin(tsk);
> +

I still wonder why there is a so big coverage of this lock. I mean
why is it called right before exit_irq_thread() and released so late.
All we want is to lock cgroup_exit() I think, after which tasks can't be
migrated.

Thanks.
