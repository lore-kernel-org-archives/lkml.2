Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2JaTCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:02:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab2JaTCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:02:41 -0400
Date: Wed, 31 Oct 2012 20:02:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031190237.GA1271@dhcp22.suse.cz>
References: <1351707391-22287-1-git-send-email-tj@kernel.org>
 <1351707391-22287-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351707391-22287-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 11:16:24, Tejun Heo wrote:
> 2ef37d3fe4 ("memcg: Simplify mem_cgroup_force_empty_list error
> handling") removed the last user of __DEPRECATED_clear_css_refs.  This
> patch removes __DEPRECATED_clear_css_refs and mechanisms to support
> it.
> 
> * Conditionals dependent on __DEPRECATED_clear_css_refs removed.
> 
> * ->pre_destroy() now can only fail if a new task is attached or child
>   cgroup is created while ->pre_destroy()s are being called.  As the
>   condition is checked again after re-acquiring cgroup_mutex
>   afterwards, we don't need to take any immediate action on
>   ->pre_destroy() failures.  

Well, this is racy because the task can exit until we reach the
re-check. As the result there might still be some pages on the memcg
LRUs left.
As I said in the previous version, I do not see any reason why we
shouldn't just return EBUSY here. I would even skip WARN_ON_ONCE because
it doesn't give us any valueable information. One can trigger that
easily as well.

[...]
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7981850..033bf4b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
[...]
> @@ -4168,11 +4075,9 @@ again:
>  	 * Call pre_destroy handlers of subsys. Notify subsystems
>  	 * that rmdir() request comes.
>  	 */
> -	ret = cgroup_call_pre_destroy(cgrp);
> -	if (ret) {
> -		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> -		return ret;
> -	}
> +	for_each_subsys(cgrp->root, ss)
> +		if (ss->pre_destroy)
> +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
	for_each_subsys(cgrp->root, ss)
		if (ss->pre_destroy) {
			int ret = ss->pre_destroy(cgrp);
			clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
			return ret;
		}
>  
>  	mutex_lock(&cgroup_mutex);
>  	parent = cgrp->parent;
[...]
-- 
Michal Hocko
SUSE Labs
