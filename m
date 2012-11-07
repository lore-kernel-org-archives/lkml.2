Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2KGQzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:55:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2KGQzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:55:01 -0500
Date: Wed, 7 Nov 2012 17:54:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Message-ID: <20121107165457.GD4131@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351931915-1701-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 03-11-12 01:38:29, Tejun Heo wrote:
[...]
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index cc5d2a0..8bd662c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2985,6 +2985,92 @@ static void cgroup_enable_task_cg_lists(void)
>  	write_unlock(&css_set_lock);
>  }
>  
> +/**
> + * cgroup_next_descendant_pre - find the next descendant for pre-order walk
> + * @pos: the current position (%NULL to initiate traversal)
> + * @cgroup: cgroup whose descendants to walk
> + *
> + * To be used by cgroup_for_each_descendant_pre().  Find the next
> + * descendant to visit for pre-order traversal of @cgroup's descendants.
> + */
> +struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
> +					  struct cgroup *cgroup)
> +{
> +	struct cgroup *next;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	/* if first iteration, pretend we just visited @cgroup */
> +	if (!pos) {
> +		if (list_empty(&cgroup->children))
> +			return NULL;
> +		pos = cgroup;
> +	}

Is there any specific reason why the root of the tree is excluded?
This is bit impractical because you have to special case the root
in the code.

> +
> +	/* visit the first child if exists */
> +	next = list_first_or_null_rcu(&pos->children, struct cgroup, sibling);
> +	if (next)
> +		return next;
> +
> +	/* no child, visit my or the closest ancestor's next sibling */
> +	do {
> +		next = list_entry_rcu(pos->sibling.next, struct cgroup,
> +				      sibling);
> +		if (&next->sibling != &pos->parent->children)
> +			return next;
> +
> +		pos = pos->parent;
> +	} while (pos != cgroup);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(cgroup_next_descendant_pre);
[...]

-- 
Michal Hocko
SUSE Labs
