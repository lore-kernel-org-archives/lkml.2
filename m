Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946052Ab2JaVYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:24:05 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39900 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946038Ab2JaVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:24:01 -0400
Date: Wed, 31 Oct 2012 22:23:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
Message-ID: <20121031212359.GC5286@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351712650-23709-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 12:44:06, Tejun Heo wrote:
[...]
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f22e3cd..66204a6 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
[...]
> @@ -4122,13 +4079,30 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
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

Do you think that BUG_ON would be too harsh?

-- 
Michal Hocko
SUSE Labs
