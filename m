Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab2KBJh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:37:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48651 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2KBJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:37:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5093945E.3050504@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 18:37:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-4-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/31 13:22), Tejun Heo wrote:
> This patch makes cgroup_create() fail if @parent is marked removed.
> This is to prepare for further updates to cgroup_rmdir() path.
> 
> Note that this change isn't strictly necessary.  cgroup can only be
> created via mkdir and the removed marking and dentry removal happen
> without releasing cgroup_mutex, so cgroup_create() can never race with
> cgroup_rmdir().  Even after the scheduled updates to cgroup_rmdir(),
> cgroup_mkdir() and cgroup_rmdir() are synchronized by i_mutex
> rendering the added liveliness check unnecessary.
> 
> Do it anyway such that locking is contained inside cgroup proper and
> we don't get nasty surprises if we ever grow another caller of
> cgroup_create().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

I welcome this change.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>   kernel/cgroup.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a49cdbc..b3010ae 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3906,6 +3906,18 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>   	if (!cgrp)
>   		return -ENOMEM;
>   
> +	/*
> +	 * Only live parents can have children.  Note that the liveliness
> +	 * check isn't strictly necessary because cgroup_mkdir() and
> +	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
> +	 * anyway so that locking is contained inside cgroup proper and we
> +	 * don't get nasty surprises if we ever grow another caller.
> +	 */
> +	if (!cgroup_lock_live_group(parent)) {
> +		err = -ENODEV;
> +		goto err_free;
> +	}
> +
>   	/* Grab a reference on the superblock so the hierarchy doesn't
>   	 * get deleted on unmount if there are child cgroups.  This
>   	 * can be done outside cgroup_mutex, since the sb can't
> @@ -3913,8 +3925,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>   	 * fs */
>   	atomic_inc(&sb->s_active);
>   
> -	mutex_lock(&cgroup_mutex);
> -
>   	init_cgroup_housekeeping(cgrp);
>   
>   	cgrp->parent = parent;
> @@ -3985,7 +3995,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>   
>   	/* Release the reference count that we took on the superblock */
>   	deactivate_super(sb);
> -
> +err_free:
>   	kfree(cgrp);
>   	return err;
>   }
> 


