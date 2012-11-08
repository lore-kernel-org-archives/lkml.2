Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2KHOI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:08:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab2KHOIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:08:55 -0500
Date: Thu, 8 Nov 2012 15:08:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Message-ID: <20121108140852.GI31821@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107163919.GC2660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-11-12 08:39:19, Tejun Heo wrote:
[...]
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
[...]
> @@ -320,14 +388,39 @@ static void freezer_apply_state(struct f
>   * @freezer: freezer of interest
>   * @freeze: whether to freeze or thaw
>   *
> - * Freeze or thaw @cgroup according to @freeze.
> + * Freeze or thaw @freezer according to @freeze.  The operations are
> + * recursive - all descendants of @freezer will be affected.
>   */
>  static void freezer_change_state(struct freezer *freezer, bool freeze)
>  {
> +	struct cgroup *pos;
> +
>  	/* update @freezer */
>  	spin_lock_irq(&freezer->lock);
>  	freezer_apply_state(freezer, freeze, CGROUP_FREEZING_SELF);
>  	spin_unlock_irq(&freezer->lock);
> +
> +	/*
> +	 * Update all its descendants in pre-order traversal.  Each
> +	 * descendant will try to inherit its parent's FREEZING state as
> +	 * CGROUP_FREEZING_PARENT.
> +	 */
> +	rcu_read_lock();
> +	cgroup_for_each_descendant_pre(pos, freezer->css.cgroup) {
> +		struct freezer *pos_f = cgroup_freezer(pos);
> +		struct freezer *parent = parent_freezer(pos_f);
> +
> +		/*
> +		 * Our update to @parent->state is already visible which is
> +		 * all we need.  No need to lock @parent.  For more info on
> +		 * synchronization, see freezer_post_create().
> +		 */
> +		spin_lock_irq(&pos_f->lock);
> +		freezer_apply_state(pos_f, parent->state & CGROUP_FREEZING,
> +				    CGROUP_FREEZING_PARENT);
> +		spin_unlock_irq(&pos_f->lock);
> +	}
> +	rcu_read_unlock();
>  }

This seems to be racy because parent->state access is not linearized.
Say we have parallel freeze and thawing on a tree like the following:
	A
	|
	B
        |
        C 

pre_order will visit them in B, C order.
	CPU1						CPU2
freezer_apply_state(A, true)
A->state & FREEZING == true		freezer_apply_state(A, false)
					A->state & FREEZING == false
					freezer_apply_state(B, false)
					B->state & FREEZING == false
freezer_apply_state(B, true)

B->state & FREEZING == true
freezer_apply_state(C, true)
					freezer_apply_state(C, false)

So A, C are thawed while B is frozen. Or am I missing something which
would prevent from this kind of race?

The easy fix is to move spin_unlock_irq(&freezer->lock); after
rcu_read_unlock.
-- 
Michal Hocko
SUSE Labs
