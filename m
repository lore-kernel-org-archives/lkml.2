Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2KTEfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:35:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41054 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2KTEfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:35:34 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AB086E.70901@jp.fujitsu.com>
Date: Tue, 20 Nov 2012 13:34:54 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
References: <1353093624-22608-1-git-send-email-tj@kernel.org> <1353093624-22608-2-git-send-email-tj@kernel.org>
In-Reply-To: <1353093624-22608-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/17 4:20), Tejun Heo wrote:
> With the introduction of generic cgroup hierarchy iterators, css_id is
> being phased out.  It was unnecessarily complex, id'ing the wrong
> thing (cgroups need IDs, not CSSes) and has other oddities like not
> being available at ->css_alloc().
> 
> This patch adds cgroup->id, which is a simple per-hierarchy
> ida-allocated ID which is assigned before ->css_alloc() and released
> after ->css_free().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>


I'm sorry if I misunderstand ... current usage of css-id in memory/swap cgroup
is for recording information of memory cgroup which may be destroyed. In some case,
a memcg's cgroup is freed but a struct memcgroup and its css are available, swap_cgroup
may contain id ot if.
This patch puts cgroup's id at diput(), so, the id used in swap_cgroup can be
reused while it's in use. Right ?

Thanks,
-Kame

> ---
>   include/linux/cgroup.h |  2 ++
>   kernel/cgroup.c        | 15 ++++++++++++++-
>   2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index d5fc8a7..b512469 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -159,6 +159,8 @@ struct cgroup {
>   	 */
>   	atomic_t count;
>   
> +	int id;				/* ida allocated in-hierarchy ID */
> +
>   	/*
>   	 * We link our 'sibling' struct into our parent's 'children'.
>   	 * Our children link their 'sibling' into our 'children'.
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 99d5e69..0b25dcb 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -138,6 +138,9 @@ struct cgroupfs_root {
>   	/* Hierarchy-specific flags */
>   	unsigned long flags;
>   
> +	/* IDs for cgroups in this hierarchy */
> +	struct ida cgroup_ida;
> +
>   	/* The path to use for release notifications. */
>   	char release_agent_path[PATH_MAX];
>   
> @@ -890,6 +893,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>   
>   		simple_xattrs_free(&cgrp->xattrs);
>   
> +		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
>   		kfree(cgrp);
>   	} else {
>   		struct cfent *cfe = __d_cfe(dentry);
> @@ -1465,6 +1469,7 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
>   
>   	root->subsys_mask = opts->subsys_mask;
>   	root->flags = opts->flags;
> +	ida_init(&root->cgroup_ida);
>   	if (opts->release_agent)
>   		strcpy(root->release_agent_path, opts->release_agent);
>   	if (opts->name)
> @@ -1483,6 +1488,7 @@ static void cgroup_drop_root(struct cgroupfs_root *root)
>   	spin_lock(&hierarchy_id_lock);
>   	ida_remove(&hierarchy_ida, root->hierarchy_id);
>   	spin_unlock(&hierarchy_id_lock);
> +	ida_destroy(&root->cgroup_ida);
>   	kfree(root);
>   }
>   
> @@ -4093,10 +4099,15 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>   	struct cgroup_subsys *ss;
>   	struct super_block *sb = root->sb;
>   
> +	/* allocate the cgroup and its ID, 0 is reserved for the root */
>   	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
>   	if (!cgrp)
>   		return -ENOMEM;
>   
> +	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
> +	if (cgrp->id < 0)
> +		goto err_free_cgrp;
> +
>   	/*
>   	 * Only live parents can have children.  Note that the liveliness
>   	 * check isn't strictly necessary because cgroup_mkdir() and
> @@ -4106,7 +4117,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>   	 */
>   	if (!cgroup_lock_live_group(parent)) {
>   		err = -ENODEV;
> -		goto err_free_cgrp;
> +		goto err_free_id;
>   	}
>   
>   	/* Grab a reference on the superblock so the hierarchy doesn't
> @@ -4198,6 +4209,8 @@ err_free_all:
>   	mutex_unlock(&cgroup_mutex);
>   	/* Release the reference count that we took on the superblock */
>   	deactivate_super(sb);
> +err_free_id:
> +	ida_simple_remove(&root->cgroup_ida, cgrp->id);
>   err_free_cgrp:
>   	kfree(cgrp);
>   	return err;
> 


