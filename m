Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0DVTzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:55:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38511 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab0DVTzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:55:39 -0400
Date: Thu, 22 Apr 2010 12:55:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] cgroup: Fix an RCU warning in cgroup_path()
Message-ID: <20100422195533.GI2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD016F4.8060108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD016F4.8060108@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:29:24PM +0800, Li Zefan wrote:
> with CONFIG_PROVE_RCU=y, a warning can be triggered:
> 
>   # mount -t cgroup -o debug xxx /mnt
>   # cat /proc/$$/cgroup
> 
> ...
> kernel/cgroup.c:1649 invoked rcu_dereference_check() without protection!
> ...
> 
> This is a false-positive, because cgroup_path() can be called
> with either rcu_read_lock() held or cgroup_mutex held.

Queued for 2.6.34, thank you Li!

							Thanx, Paul

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e2769e1..4ca928d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1646,7 +1646,9 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
>  int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
>  {
>  	char *start;
> -	struct dentry *dentry = rcu_dereference(cgrp->dentry);
> +	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
> +						      rcu_read_lock_held() ||
> +						      cgroup_lock_is_held());
> 
>  	if (!dentry || cgrp == dummytop) {
>  		/*
> @@ -1662,13 +1664,17 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
>  	*--start = '\0';
>  	for (;;) {
>  		int len = dentry->d_name.len;
> +
>  		if ((start -= len) < buf)
>  			return -ENAMETOOLONG;
> -		memcpy(start, cgrp->dentry->d_name.name, len);
> +		memcpy(start, dentry->d_name.name, len);
>  		cgrp = cgrp->parent;
>  		if (!cgrp)
>  			break;
> -		dentry = rcu_dereference(cgrp->dentry);
> +
> +		dentry = rcu_dereference_check(cgrp->dentry,
> +					       rcu_read_lock_held() ||
> +					       cgroup_lock_is_held());
>  		if (!cgrp->parent)
>  			continue;
>  		if (--start < buf)
> -- 
> 1.6.3
> 
