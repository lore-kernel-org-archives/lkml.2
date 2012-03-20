Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2CTQtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:49:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43939 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2CTQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:49:20 -0400
Date: Tue, 20 Mar 2012 09:49:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com
Subject: Re: [PATCH 09/10] cgroup: introduce struct cfent
Message-ID: <20120320164915.GF5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-10-git-send-email-tj@kernel.org>
 <4F688EA9.8050905@parallels.com>
 <20120320160228.GD5684@google.com>
 <4F68AA37.80604@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F68AA37.80604@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 08:03:03PM +0400, Glauber Costa wrote:
> From 04604201411ab0a14fa1447072cd1b273d0774ed Mon Sep 17 00:00:00 2001
> From: Glauber Costa <glommer@parallels.com>
> Date: Tue, 20 Mar 2012 18:12:55 +0400
> Subject: [PATCH] don't trigger warning when d_subdirs is not empty.
> 
> It is never empty at this point, because of the self references.
> a better test is to see if any of them gets d_inode set.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index cf7b298..b45a653 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -947,10 +947,16 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
>  static void cgroup_clear_directory(struct dentry *dir)
>  {
>  	struct cgroup *cgrp = __d_cgrp(dir);
> +	struct list_head *child;
>  
>  	while (!list_empty(&cgrp->files))
>  		cgroup_rm_file(cgrp, NULL);
> -	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
> +
> +	list_for_each(child, &dir->d_subdirs) {
> +		struct dentry *d;
> +		d = list_entry(child, struct dentry, d_u.d_child);
> +		WARN_ON_ONCE(d->d_inode);
> +	}

This seems correct and I'll apply this but I still can't reproduce the
warning at will before the patch.  How do I a get negative dentry on
the d_subdirs when d_delete always returns 1?  Glauber, can you
trigger the warning at will?

Thanks.

-- 
tejun
