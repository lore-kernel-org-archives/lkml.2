Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1KDIzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:55:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45398 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1KDIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:55:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 17:54:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 04/10] cgroup: always lock threadgroup during migration
Message-Id: <20111104175413.30afaf8e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320191193-8110-5-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
	<1320191193-8110-5-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Nov 2011 16:46:27 -0700
Tejun Heo <tj@kernel.org> wrote:

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

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
A few questions below.


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
>  	rcu_assign_pointer(tsk->cgroups, newcg);
>  	task_unlock(tsk);

Is this task_lock/unlock is required ?



>
> @@ -2116,11 +2120,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  			continue;
>  		/* get old css_set pointer */
>  		task_lock(tsk);
> -		if (tsk->flags & PF_EXITING) {
> -			/* ignore this task if it's going away */
> -			task_unlock(tsk);
> -			continue;
> -		}
>  		oldcg = tsk->cgroups;
>  		get_css_set(oldcg);
>  		task_unlock(tsk);

ditto.


Thanks,
-Kame

