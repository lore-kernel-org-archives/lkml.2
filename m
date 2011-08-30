Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1H3UKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:10:40 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50052 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab1H3UKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:10:37 -0400
Date: Tue, 30 Aug 2011 22:10:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] cgroup: kill subsys->can_attach_task(), pre_attach()
 and attach_task()
Message-ID: <20110830201030.GC15953@somewhere.redhat.com>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314312192-26885-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 12:43:12AM +0200, Tejun Heo wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f3c7f7a..ce765ec 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2075,7 +2064,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  {
>  	int retval, i, group_size, nr_migrating_tasks;
>  	struct cgroup_subsys *ss, *failed_ss = NULL;
> -	bool cancel_failed_ss = false;
>  	/* guaranteed to be initialized later, but the compiler needs this */
>  	struct css_set *oldcg;
>  	struct cgroupfs_root *root = cgrp->root;
> @@ -2166,21 +2154,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  				goto out_cancel_attach;
>  			}
>  		}
> -		/* a callback to be run on every thread in the threadgroup. */
> -		if (ss->can_attach_task) {
> -			/* run on each task in the threadgroup. */
> -			for (i = 0; i < group_size; i++) {
> -				tc = flex_array_get(group, i);
> -				if (tc->cgrp == cgrp)
> -					continue;
> -				retval = ss->can_attach_task(cgrp, tc->task);
> -				if (retval) {
> -					failed_ss = ss;
> -					cancel_failed_ss = true;
> -					goto out_cancel_attach;
> -				}
> -			}
> -		}
>  	}
>  
>  	/*
> @@ -2217,15 +2190,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	}
>  
>  	/*
> -	 * step 3: now that we're guaranteed success wrt the css_sets, proceed
> -	 * to move all tasks to the new cgroup, calling ss->attach_task for each
> -	 * one along the way. there are no failure cases after here, so this is
> -	 * the commit point.
> +	 * step 3: now that we're guaranteed success wrt the css_sets,
> +	 * proceed to move all tasks to the new cgroup.  There are no
> +	 * failure cases after here, so this is the commit point.
>  	 */
> -	for_each_subsys(root, ss) {
> -		if (ss->pre_attach)
> -			ss->pre_attach(cgrp);
> -	}
>  	for (i = 0; i < group_size; i++) {
>  		tc = flex_array_get(group, i);
>  		/* leave current thread as it is if it's already there */
> @@ -2235,19 +2203,11 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  		/* if the thread is PF_EXITING, it can just get skipped. */
>  		retval = cgroup_task_migrate(cgrp, tc->cgrp, tc->task, true);
>  		BUG_ON(retval != 0 && retval != -ESRCH);
> -
> -		/* attach each task to each subsystem */
> -		for_each_subsys(root, ss) {
> -			if (ss->attach_task)
> -				ss->attach_task(cgrp, tc->task);
> -		}

In order to keep the fix queued in -mm (https://lkml.org/lkml/2011/8/26/262)
the tasks that have failed to migrate should be removed from the iterator
so that they are not included in the batch in ->attach().

>  	}
>  	/* nothing is sensitive to fork() after this point. */
>  
>  	/*
> -	 * step 4: do expensive, non-thread-specific subsystem callbacks.
> -	 * TODO: if ever a subsystem needs to know the oldcgrp for each task
> -	 * being moved, this call will need to be reworked to communicate that.
> +	 * step 4: do subsystem attach callbacks.
>  	 */
>  	for_each_subsys(root, ss) {
>  		if (ss->attach)
> @@ -2271,11 +2231,8 @@ out_cancel_attach:
>  	/* same deal as in cgroup_attach_task */
>  	if (retval) {
>  		for_each_subsys(root, ss) {
> -			if (ss == failed_ss) {
> -				if (cancel_failed_ss && ss->cancel_attach)
> -					ss->cancel_attach(ss, cgrp, &tset);
> +			if (ss == failed_ss)
>  				break;
> -			}
>  			if (ss->cancel_attach)
>  				ss->cancel_attach(ss, cgrp, &tset);
>  		}
> -- 
> 1.7.6
> 
