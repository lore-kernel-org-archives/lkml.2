Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1LTV3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:29:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44715 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1LTV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:29:26 -0500
Date: Tue, 20 Dec 2011 13:29:05 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/2] cgroup: Remove unnecessary task_lock before
 fetching css_set on migration
Message-ID: <20111220212905.GU13529@google.com>
References: <1324320274-18485-1-git-send-email-msb@chromium.org>
 <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker (fweisbec@gmail.com) wrote:
> When we fetch the css_set of the tasks on cgroup migration, we don't need
> anymore to synchronize against cgroup_exit() that could swap the old one
> with init_css_set. Now that we are using threadgroup_lock() during
> the migrations, we don't need to worry about it anymore.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>

Reviewed-by: Mandeep Singh Baines <msb@chromium.org>

> ---
>  kernel/cgroup.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5fdd98c..6b5f693 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1850,13 +1850,13 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	struct css_set *newcg;
>  
>  	/*
> -	 * get old css_set. we need to take task_lock and refcount it, because
> -	 * an exiting task can change its css_set to init_css_set and drop its
> -	 * old one without taking cgroup_mutex.
> +	 * get old css_set. We are synchronized through threadgroup_lock()
> +	 * against PF_EXITING setting such that we can't race against
> +	 * cgroup_exit() changing the css_set to init_css_set and dropping the
> +	 * old one.
>  	 */
> -	task_lock(tsk);
> +	WARN_ON_ONCE(tsk->flags & PF_EXITING);
>  	oldcg = tsk->cgroups;
> -	task_unlock(tsk);
>  
>  	/* locate or allocate a new css_set for this task. */
>  	if (guarantee) {
> @@ -1875,9 +1875,7 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  			return -ENOMEM;
>  	}
>  
> -	/* @tsk can't exit as its threadgroup is locked */
>  	task_lock(tsk);
> -	WARN_ON_ONCE(tsk->flags & PF_EXITING);
>  	rcu_assign_pointer(tsk->cgroups, newcg);
>  	task_unlock(tsk);
>  
> @@ -2177,10 +2175,13 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  		/* nothing to do if this task is already in the cgroup */
>  		if (tc->cgrp == cgrp)
>  			continue;
> -		/* get old css_set pointer */
> -		task_lock(tc->task);
> +		/*
> +		 * get old css_set pointer. threadgroup is locked so this is
> +		 * safe against concurrent cgroup_exit() changing this to
> +		 * init_css_set.
> +		 */
>  		oldcg = tc->task->cgroups;
> -		task_unlock(tc->task);
> +
>  		/* if we don't already have it in the list get a new one */
>  		if (!css_set_fetched(cgrp, tc->task, oldcg, &newcg_list))
>  			if (css_set_prefetch(cgrp, oldcg, &newcg_list))
> -- 
> 1.7.5.4
> 
