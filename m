Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2KETR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:17:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2KETR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:17:27 -0500
Date: Mon, 5 Nov 2012 13:17:14 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, rjw@sisk.pl,
        linux-pm@vger.kernel.org, fweisbec@gmail.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mhocko@suse.cz, cgroups@vger.kernel.org
Subject: Re: [RFC] cgroup: deprecate clone_children
Message-ID: <20121105191714.GA24560@sergelap>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <5097C23B.3040808@parallels.com>
 <20121105180213.GB19354@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105180213.GB19354@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> clone_children makes cgroup invoke ->post_clone() callback if it
> exists and sets CGRP_CLONE_CHILDREN.  ->post_clone(), while being
> named generically, is only supposed to copy configuration from its
> parent.
> 
> This is an entirely convenience feature which is only used by cpuset
> to alter its configuration propagation.  As the mount option and
> cgroupfs knobs are cgroup-wide and different controllers differ in
> their configuration propagations, it's awkward to use for multiple
> controllers especially if they're co-mounted.  At this point, we can't
> use this flag for any other controller anyway as it would implicitly
> change the behavior.
> 
> As this is unnecessary feature with very limited use and awkward in

clone_children is currently required by lxc.  Of course lxc could
manually set the .cpus and .mems in the newly created child, but if
those interfaces or others like it ever change (i.e. any new ones which
must be set before a task can join a cgroup) we'll get into yet more of
a rats nets of code to support different kernel versions.

(Just as an idea, if there was a way to generically tell from the list
of files in my cgroups dir which files need to be initialized before a
task can join, I think that would suffice.  Maybe a cgroups.needssetup
file which right now contains 'cpuset.mems\ncpuset.cpus'. Then if we
find a file we don't recognize in there we can throw an intelligent
error, or guess at duplicating the parent value.)

> co-mounted use cases, let's try to deprecate it.  Whine on the mount
> option and accesses to cgroupfs knobs.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
> Glauber, I think this is more befitting change for .post_clone().  If

What do you mean by that?  That he is working on a patch-set which will
remove post_clone and this belongs there, or that there is a proposed
alternative?

> people aren't depending on this, I'd much prefer to just remove it.
> 
> Thanks.
> 
>  kernel/cgroup.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1162,6 +1162,8 @@ static int parse_cgroupfs_options(char *
>  			continue;
>  		}
>  		if (!strcmp(token, "clone_children")) {
> +			pr_warning("cgroup: mount option clone_children is deprecated (pid=%d comm=%s)\n",
> +				   task_tgid_nr(current), current->comm);
>  			opts->clone_children = true;
>  			continue;
>  		}
> @@ -3837,6 +3839,9 @@ fail:
>  static u64 cgroup_clone_children_read(struct cgroup *cgrp,
>  				    struct cftype *cft)
>  {
> +	printk_ratelimited(KERN_WARNING "cgroup: clone_children is deprecated (pid=%d comm=%s)\n",
> +			   task_tgid_nr(current), current->comm);
> +
>  	return clone_children(cgrp);
>  }
>  
> @@ -3844,6 +3849,9 @@ static int cgroup_clone_children_write(s
>  				     struct cftype *cft,
>  				     u64 val)
>  {
> +	printk_ratelimited(KERN_WARNING "cgroup: clone_children is deprecated (pid=%d comm=%s)\n",
> +			   task_tgid_nr(current), current->comm);
> +
>  	if (val)
>  		set_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
>  	else
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
