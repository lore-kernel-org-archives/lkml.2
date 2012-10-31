Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab2JaOh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:37:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934348Ab2JaOhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:37:55 -0400
Date: Wed, 31 Oct 2012 15:37:51 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031143751.GA22809@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-10-12 21:22:38, Tejun Heo wrote:
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
>   ->pre_destroy() failures.  This reduces cgroup_call_pre_destroy() to
>   a simple loop surrounding ->pre_destory().  Remove
>   cgroup_call_pre_destroy() and open-code the loop into
>   cgroup_rmdir().
> 
> * cgroup_clear_css_refs() can no longer fail.  All that needs to be
>   done are deactivating refcnts, setting CSS_REMOVED and putting the
>   base reference on each css.  Remove cgroup_clear_css_refs() and the
>   failure path, and open-code the loops into cgroup_rmdir().
> 
> Note that cgroup_rmdir() will see more cleanup soon.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good to me and the diffstat is really encouraging
Reviewed-by: Michal Hocko <mhocko@suse.cz>

with a minor note bellow
> ---
>  include/linux/cgroup.h |  12 ----
>  kernel/cgroup.c        | 159 ++++++++++++-------------------------------------
>  2 files changed, 38 insertions(+), 133 deletions(-)
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

Hmm, I am not sure I like this WARN_ON_ONCE. First it can happen for
more than one controller and second we can just clear CGRP_WAIT_ON_RMDIR
and return with EBUSY. The only possible failure at the moment is when a
new task or a child group appear.
I know it is not a big deal because it will disappear later in the
series but it would be more readable IMO.

Thanks!
-- 
Michal Hocko
SUSE Labs
