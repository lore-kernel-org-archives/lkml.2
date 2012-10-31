Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423045Ab2JaPzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:55:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422913Ab2JaPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:55:17 -0400
Date: Wed, 31 Oct 2012 16:55:14 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Message-ID: <20121031155514.GD22809@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-10-12 21:22:40, Tejun Heo wrote:
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

Looks good. Just a nit bellow
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  kernel/cgroup.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a49cdbc..b3010ae 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3906,6 +3906,18 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  	if (!cgrp)
>  		return -ENOMEM;
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

I think this should be moved up before we try to allocate any memory.
Or is your motivation to keep cgroup_lock held for shorter time?
I could agree with that but a small comment would be helpful.

-- 
Michal Hocko
SUSE Labs
