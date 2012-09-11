Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab2IKOxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab2IKOxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:53:43 -0400
Date: Tue, 11 Sep 2012 10:51:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911145106.GG12039@redhat.com>
References: <20120910223125.GC7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910223125.GC7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:31:25PM -0700, Tejun Heo wrote:
> Currently, cgroup hierarchy support is a mess.  cpu related subsystems
> behave correctly - configuration, accounting and control on a parent
> properly cover its children.  blkio and freezer completely ignore
> hierarchy and treat all cgroups as if they're directly under the root
> cgroup.  Others show yet different behaviors.
> 
> These differing interpretations of cgroup hierarchy make using cgroup
> confusing and it impossible to co-mount controllers into the same
> hierarchy and obtain sane behavior.
> 
> Eventually, we want full hierarchy support from all subsystems and
> probably a unified hierarchy.  Users using separate hierarchies
> expecting completely different behaviors depending on the mounted
> subsystem is deterimental to making any progress on this front.
> 
> This patch adds cgroup_subsys.broken_hierarchy and sets it to %true
> for controllers which are lacking in hierarchy support.  The goal of
> this patch is two-fold.
> 
> * Move users away from using hierarchy on currently non-hierarchical
>   subsystems, so that implementing proper hierarchy support on those
>   doesn't surprise them.

I know two current/potential users. systemd and libvirt. They are
anyway going to create hierarchy irrespective of the fact whether
controller supports it or not.

So even if we start screaming, nothing is going to change there, I 
suspect. Just that by default they expect every controller supports
hiearchies. 

> 
> * Keep track of which controllers are broken how and nudge the
>   subsystems to implement proper hierarchy support.

I thought we can easily keep track of this in a simple .txt file and
we really don't have to  provide explicit warnings.

I think for these controllers it is a known fact that they don't support
hiearchy yet. I am skeptical that providing explicit warnings is going
to help.

Thanks
Vivek


> 
> For now, start with a single warning message.  We can whine louder
> later on.
> 
> (I tried to document what's broken and how it should be fixed.  If I
>  got something wrong, please let me know.)
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Turner <pjt@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  block/blk-cgroup.c        |    8 ++++++++
>  include/linux/cgroup.h    |   15 +++++++++++++++
>  kernel/cgroup.c           |   11 ++++++++++-
>  kernel/cgroup_freezer.c   |    8 ++++++++
>  kernel/events/core.c      |    7 +++++++
>  mm/memcontrol.c           |   12 +++++++++---
>  net/core/netprio_cgroup.c |   12 +++++++++++-
>  net/sched/cls_cgroup.c    |    9 +++++++++
>  security/device_cgroup.c  |    9 +++++++++
>  9 files changed, 86 insertions(+), 5 deletions(-)
> 
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -737,6 +737,14 @@ struct cgroup_subsys blkio_subsys = {
>  	.subsys_id = blkio_subsys_id,
>  	.base_cftypes = blkcg_files,
>  	.module = THIS_MODULE,
> +
> +	/*
> +	 * blkio subsystem is utterly broken in terms of hierarchy support.
> +	 * It treats all cgroups equally regardless of where they're
> +	 * located in the hierarchy - all cgroups are treated as if they're
> +	 * right below the root.  Fix it and remove the following.
> +	 */
> +	.broken_hierarchy = true,
>  };
>  EXPORT_SYMBOL_GPL(blkio_subsys);
>  
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -503,6 +503,21 @@ struct cgroup_subsys {
>  	 */
>  	bool __DEPRECATED_clear_css_refs;
>  
> +	/*
> +	 * If %false, this subsystem is properly hierarchical -
> +	 * configuration, resource accounting and restriction on a parent
> +	 * cgroup cover those of its children.  If %true, hierarchy support
> +	 * is broken in some ways - some subsystems ignore hierarchy
> +	 * completely while others are only implemented half-way.
> +	 *
> +	 * It's now diallowed to create nested cgroups if the subsystem is
> +	 * broken and cgroup core will emit a warning message on such
> +	 * cases.  Eventually, all subsystems will be made properly
> +	 * hierarchical and this will go away.
> +	 */
> +	bool broken_hierarchy;
> +	bool warned_broken_hierarchy;
> +
>  #define MAX_CGROUP_TYPE_NAMELEN 32
>  	const char *name;
>  
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4075,8 +4075,17 @@ static long cgroup_create(struct cgroup 
>  		set_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
>  
>  	for_each_subsys(root, ss) {
> -		struct cgroup_subsys_state *css = ss->create(cgrp);
> +		struct cgroup_subsys_state *css;
> +
> +		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
> +		    parent->parent) {
> +			pr_warning("cgroup: \"%s\" is not properly hierarchical yet, do not nest cgroups.\n",
> +				   ss->name);
> +			pr_warning("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
> +			ss->warned_broken_hierarchy = true;
> +		}
>  
> +		css = ss->create(cgrp);
>  		if (IS_ERR(css)) {
>  			err = PTR_ERR(css);
>  			goto err_destroy;
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -373,4 +373,12 @@ struct cgroup_subsys freezer_subsys = {
>  	.can_attach	= freezer_can_attach,
>  	.fork		= freezer_fork,
>  	.base_cftypes	= files,
> +
> +	/*
> +	 * freezer subsys doesn't handle hierarchy at all.  Frozen state
> +	 * should be inherited through the hierarchy - if a parent is
> +	 * frozen, all its children should be frozen.  Fix it and remove
> +	 * the following.
> +	 */
> +	.broken_hierarchy = true,
>  };
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7285,5 +7285,12 @@ struct cgroup_subsys perf_subsys = {
>  	.destroy	= perf_cgroup_destroy,
>  	.exit		= perf_cgroup_exit,
>  	.attach		= perf_cgroup_attach,
> +
> +	/*
> +	 * perf_event cgroup doesn't handle nesting correctly.
> +	 * ctx->nr_cgroups adjustments should be propagated through the
> +	 * cgroup hierarchy.  Fix it and remove the following.
> +	 */
> +	.broken_hierarchy = true,
>  };
>  #endif /* CONFIG_CGROUP_PERF */
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3855,12 +3855,17 @@ static int mem_cgroup_hierarchy_write(st
>  	 */
>  	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
>  				(val == 1 || val == 0)) {
> -		if (list_empty(&cont->children))
> +		if (list_empty(&cont->children)) {
>  			memcg->use_hierarchy = val;
> -		else
> +			/* we're fully hierarchical iff root uses hierarchy */
> +			if (mem_cgroup_is_root(memcg))
> +				mem_cgroup_subsys.broken_hierarchy = !val;
> +		} else {
>  			retval = -EBUSY;
> -	} else
> +		}
> +	} else {
>  		retval = -EINVAL;
> +	}
>  
>  out:
>  	cgroup_unlock();
> @@ -4953,6 +4958,7 @@ mem_cgroup_create(struct cgroup *cont)
>  						&per_cpu(memcg_stock, cpu);
>  			INIT_WORK(&stock->work, drain_local_stock);
>  		}
> +		mem_cgroup_subsys.broken_hierarchy = !memcg->use_hierarchy;
>  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
>  	} else {
>  		parent = mem_cgroup_from_cont(cont->parent);
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -330,7 +330,17 @@ struct cgroup_subsys net_prio_subsys = {
>  	.subsys_id	= net_prio_subsys_id,
>  #endif
>  	.base_cftypes	= ss_files,
> -	.module		= THIS_MODULE
> +	.module		= THIS_MODULE,
> +
> +	/*
> +	 * net_prio has artificial limit on the number of cgroups and
> +	 * disallows nesting making it impossible to co-mount it with other
> +	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
> +	 * limit and properly nest configuration such that children follow
> +	 * their parents' configurations by default and are allowed to
> +	 * override and remove the following.
> +	 */
> +	.broken_hierarchy = trye,
>  };
>  
>  static int netprio_device_event(struct notifier_block *unused,
> --- a/net/sched/cls_cgroup.c
> +++ b/net/sched/cls_cgroup.c
> @@ -82,6 +82,15 @@ struct cgroup_subsys net_cls_subsys = {
>  #endif
>  	.base_cftypes	= ss_files,
>  	.module		= THIS_MODULE,
> +
> +	/*
> +	 * While net_cls cgroup has the rudimentary hierarchy support of
> +	 * inheriting the parent's classid on cgroup creation, it doesn't
> +	 * properly propagates config changes in ancestors to their
> +	 * descendents.  A child should follow the parent's configuration
> +	 * but be allowed to override it.  Fix it and remove the following.
> +	 */
> +	.broken_hierarchy = true,
>  };
>  
>  struct cls_cgroup_head {
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -457,6 +457,15 @@ struct cgroup_subsys devices_subsys = {
>  	.destroy = devcgroup_destroy,
>  	.subsys_id = devices_subsys_id,
>  	.base_cftypes = dev_cgroup_files,
> +
> +	/*
> +	 * While devices cgroup has the rudimentary hierarchy support which
> +	 * checks the parent's restriction, it doesn't properly propagates
> +	 * config changes in ancestors to their descendents.  A child
> +	 * should only be allowed to add more restrictions to the parent's
> +	 * configuration.  Fix it and remove the following.
> +	 */
> +	.broken_hierarchy = true,
>  };
>  
>  int __devcgroup_inode_permission(struct inode *inode, int mask)
