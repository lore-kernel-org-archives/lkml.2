Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KSJCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:02:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46582 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2KSJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:02:50 -0500
Message-ID: <50A9F5B2.5080509@huawei.com>
Date: Mon, 19 Nov 2012 17:02:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mhocko@suse.cz>,
        <glommer@parallels.com>
Subject: Re: [PATCH 06/17] cgroup: remove duplicate RCU free on struct cgroup
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-7-git-send-email-tj@kernel.org>
In-Reply-To: <1352775704-9023-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/13 11:01, Tejun Heo wrote:
> struct cgroup is made RCU-safe by synchronize_rcu() in cgroup_diput().

but synchronize_rcu() is called before ss->destroy().

rcu_read_lock();
for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
	print_cfs_rq(m, cpu, cfs_rq);
	-> call cgroup_path(task_group->css.cgroup);
rcu_read_unlock();

With this patch, if the above code race with cgroup_diput(), we might
end up accessing a cgroup which has been freed.

> There is no reason to use RCU safe kfree on it after it.  Remove
> cgroup->rcu_head and use kfree() instead of kfree_rcu() in
> cgroup_diput().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/cgroup.h | 3 ---
>  kernel/cgroup.c        | 2 +-
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index d605857..9dcbfa1 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -196,9 +196,6 @@ struct cgroup {
>  	struct list_head pidlists;
>  	struct mutex pidlist_mutex;
>  
> -	/* For RCU-protected deletion */
> -	struct rcu_head rcu_head;
> -
>  	/* List of events which userspace want to receive */
>  	struct list_head event_list;
>  	spinlock_t event_list_lock;
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 278752e..a91e7ad 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -893,7 +893,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  
>  		simple_xattrs_free(&cgrp->xattrs);
>  
> -		kfree_rcu(cgrp, rcu_head);
> +		kfree(cgrp);

This was also added to prevent a race in group scheduling code, and I think the race still
exists.



>  	} else {
>  		struct cfent *cfe = __d_cfe(dentry);
>  		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
> 

