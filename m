Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1KNSqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:46:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40436 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1KNSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:46:43 -0500
Date: Mon, 14 Nov 2011 19:46:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 04/10] cgroup: always lock threadgroup during migration
Message-ID: <20111114184630.GE9446@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320191193-8110-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:46:27PM -0700, Tejun Heo wrote:
> Update cgroup to take advantage of the fack that threadgroup_lock()
> guarantees stable threadgroup.
> 
> * Lock threadgroup even if the target is a single task.  This
>   guarantees that when the target tasks stay stable during migration
>   regardless of the target type.
> 
> * Remove PF_EXITING early exit optimization from attach_task_by_pid()
>   and check it in cgroup_task_migrate() instead.  The optimization was
>   for rather cold path to begin with and PF_EXITING state can be
>   trusted throughout migration by checking it after locking
>   threadgroup.
> 
> * Don't add PF_EXITING tasks to target task array in
>   cgroup_attach_proc().  This ensures that task migration is performed
>   only for live tasks.
> 
> * Remove -ESRCH failure path from cgroup_task_migrate().  With the
>   above changes, it's guaranteed to be called only for live tasks.
> 
> After the changes, only live tasks are migrated and they're guaranteed
> to stay alive until migration is complete.  This removes problems
> caused by exec and exit racing against cgroup migration including
> symmetry among cgroup attach methods and different cgroup methods
> racing each other.
> 
> v2: Oleg pointed out that one more PF_EXITING check can be removed
>     from cgroup_attach_proc().  Removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

Just a little thing:

> ---
>  kernel/cgroup.c |   51 +++++++++++++++++++++++----------------------------
>  1 files changed, 23 insertions(+), 28 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f0e099f..83e10f9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1762,7 +1762,7 @@ EXPORT_SYMBOL_GPL(cgroup_path);
>   *
>   * 'guarantee' is set if the caller promises that a new css_set for the task
>   * will already exist. If not set, this function might sleep, and can fail with
> - * -ENOMEM. Otherwise, it can only fail with -ESRCH.
> + * -ENOMEM. Must be called with cgroup_mutex and threadgroup locked.
>   */
>  static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  			       struct task_struct *tsk, bool guarantee)
> @@ -1800,13 +1800,9 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	}
>  	put_css_set(oldcg);
>  
> -	/* if PF_EXITING is set, the tsk->cgroups pointer is no longer safe. */
> +	/* @tsk can't exit as its threadgroup is locked */
>  	task_lock(tsk);
> -	if (tsk->flags & PF_EXITING) {
> -		task_unlock(tsk);
> -		put_css_set(newcg);
> -		return -ESRCH;
> -	}
> +	WARN_ON_ONCE(tsk->flags & PF_EXITING);

I have the feeling the task_lock is now useless given that we are synchronized
against cgroup_exit() with the threadgroup_lock.

It's probably also useless in cgroup_exit(). But that's something for a further
patch...

Thanks.
