Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935758Ab2JaQFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:05:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423237Ab2JaQFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:05:41 -0400
Date: Wed, 31 Oct 2012 17:05:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
Message-ID: <20121031160539.GE22809@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-10-12 21:22:41, Tejun Heo wrote:
> Because ->pre_destroy() could fail and can't be called under
> cgroup_mutex, cgroup destruction did something very ugly.

You are referring to a commit in the comment but I would rather see it
here.

>   1. Grab cgroup_mutex and verify it can be destroyed; fail otherwise.
> 
>   2. Release cgroup_mutex and call ->pre_destroy().
> 
>   3. Re-grab cgroup_mutex and verify it can still be destroyed; fail
>      otherwise.
> 
>   4. Continue destroying.
> 
> In addition to being ugly, it has been always broken in various ways.
> For example, memcg ->pre_destroy() expects the cgroup to be inactive
> after it's done but tasks can be attached and detached between #2 and
> #3 and the conditions that memcg verified in ->pre_destroy() might no
> longer hold by the time control reaches #3.
> 
> Now that ->pre_destroy() is no longer allowed to fail.  We can switch
> to the following.
> 
>   1. Grab cgroup_mutex and fail if it can't be destroyed; fail
>      otherwise.

the other fail is superfluous and too negative ;)

>   2. Deactivate CSS's and mark the cgroup removed thus preventing any
>      further operations which can invalidate the verification from #1.
> 
>   3. Release cgroup_mutex and call ->pre_destroy().
> 
>   4. Re-grab cgroup_mutex and continue destroying.
> 
> After this change, controllers can safely assume that ->pre_destroy()
> will only be called only once for a given cgroup and, once
> ->pre_destroy() is called, the cgroup will stay dormant till it's
> destroyed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  kernel/cgroup.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b3010ae..66204a6 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4058,18 +4058,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	struct cgroup_event *event, *tmp;
>  	struct cgroup_subsys *ss;
>  
> -	/* the vfs holds both inode->i_mutex already */
> -	mutex_lock(&cgroup_mutex);
> -	if (atomic_read(&cgrp->count) != 0) {
> -		mutex_unlock(&cgroup_mutex);
> -		return -EBUSY;
> -	}
> -	if (!list_empty(&cgrp->children)) {
> -		mutex_unlock(&cgroup_mutex);
> -		return -EBUSY;
> -	}
> -	mutex_unlock(&cgroup_mutex);
> -
>  	/*
>  	 * In general, subsystem has no css->refcnt after pre_destroy(). But
>  	 * in racy cases, subsystem may have to get css->refcnt after
> @@ -4081,14 +4069,7 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	 */
>  	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>  
> -	/*
> -	 * Call pre_destroy handlers of subsys. Notify subsystems
> -	 * that rmdir() request comes.
> -	 */
> -	for_each_subsys(cgrp->root, ss)
> -		if (ss->pre_destroy)
> -			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> -
> +	/* the vfs holds both inode->i_mutex already */
>  	mutex_lock(&cgroup_mutex);
>  	parent = cgrp->parent;
>  	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
> @@ -4098,13 +4079,30 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	}
>  	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
>  
> -	/* block new css_tryget() by deactivating refcnt */
> +	/*
> +	 * Block new css_tryget() by deactivating refcnt and mark @cgrp
> +	 * removed.  This makes future css_tryget() and child creation
> +	 * attempts fail thus maintaining the removal conditions verified
> +	 * above.
> +	 */
>  	for_each_subsys(cgrp->root, ss) {
>  		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
>  
>  		WARN_ON(atomic_read(&css->refcnt) < 0);
>  		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
>  	}
> +	set_bit(CGRP_REMOVED, &cgrp->flags);
> +
> +	/*
> +	 * Tell subsystems to initate destruction.  pre_destroy() should be
> +	 * called with cgroup_mutex unlocked.  See 3fa59dfbc3 ("cgroup: fix
> +	 * potential deadlock in pre_destroy") for details.
> +	 */
> +	mutex_unlock(&cgroup_mutex);
> +	for_each_subsys(cgrp->root, ss)
> +		if (ss->pre_destroy)
> +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> +	mutex_lock(&cgroup_mutex);
>  
>  	/*
>  	 * Put all the base refs.  Each css holds an extra reference to the
> @@ -4120,7 +4118,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>  	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>  
>  	raw_spin_lock(&release_list_lock);
> -	set_bit(CGRP_REMOVED, &cgrp->flags);
>  	if (!list_empty(&cgrp->release_list))
>  		list_del_init(&cgrp->release_list);
>  	raw_spin_unlock(&release_list_lock);
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
