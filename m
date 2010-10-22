Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0JVVi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:38:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53334 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0JVViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:38:24 -0400
Date: Fri, 22 Oct 2010 14:38:19 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup
 hierarchy
Message-ID: <20101022213819.GK10119@count0.beaverton.ibm.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
 <4CC146D4.7030009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC146D4.7030009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 04:09:56PM +0800, Li Zefan wrote:
> Stephane posted a patchset to add perf_cgroup subsystem, so perf can
> be used to monitor all threads belonging to a cgroup.
> 
> But if you already mounted a cgroup hierarchy but without perf_cgroup
> and the hierarchy has sub-cgroups, you can't bind perf_cgroup to it,
> and thus you're not able to use per-cgroup perf feature.
> 
> This patchset alleviates the pain, and then a subsytem can be bind/unbind
> to/from a hierarchy which has sub-cgroups in it.
> 
> For a cgroup subsystem to become bindable, the can_bind flag of
> struct cgroup_subsys should be set, and provide ->bind() callback
> if necessary.
> 
> But for some constraints, not all subsystems can take advantage of
> this patch. For example, we can't decide a cgroup's cpuset.mems and
> cpuset.cpus automatically, so cpuset is not bindable.

<snip>

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 6c36750..46df5f8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c

<snip>

> +/*
> + * cgroup_walk_herarchy - iterate through a cgroup hierarchy
> + * @process_cgroup: callback called on each cgroup in the hierarchy
> + * @data: will be passed to @process_cgroup
> + * @top_cgrp: the root cgroup of the hierarchy
> + *
> + * For such a hierarchy:
> + *        a1        c1
> + *      /         /
> + * Root - a2 - b1 - c2
> + *      \
> + *        a3
> + *
> + * The iterating order is: a1, a2, b1, c1, c2, a3. So a parent will be
> + * processed before its children.
> + */

You could just say it's a depth-first walk except we process the parent before
its children.

> +static int cgroup_walk_hierarchy(int (*process_cgroup)(struct cgroup *, void *),
> +				 void *data, struct cgroup *top_cgrp)

<snip>

> +static int hierarchy_populate_dir(struct cgroup *cgrp, void *data)
> +{
> +	mutex_lock_nested(&cgrp->dentry->d_inode->i_mutex, I_MUTEX_CHILD);
> +	cgroup_populate_dir(cgrp);
> +	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
> +	return 0;
> +}
> +
>  /*
>   * Call with cgroup_mutex held. Drops reference counts on modules, including
>   * any duplicate ones that parse_cgroupfs_options took. If this function
> @@ -945,36 +1079,53 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>  	unsigned long added_bits, removed_bits;
>  	struct cgroup *cgrp = &root->top_cgroup;
>  	int i;
> +	int err;
> 
>  	BUG_ON(!mutex_is_locked(&cgroup_mutex));
> 
>  	removed_bits = root->actual_subsys_bits & ~final_bits;
>  	added_bits = final_bits & ~root->actual_subsys_bits;
> +
>  	/* Check that any added subsystems are currently free */
> -	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> -		unsigned long bit = 1UL << i;
> -		struct cgroup_subsys *ss = subsys[i];
> -		if (!(bit & added_bits))
> -			continue;
> +	for_each_set_bit(i, &added_bits, CGROUP_SUBSYS_COUNT) {
>  		/*
>  		 * Nobody should tell us to do a subsys that doesn't exist:
>  		 * parse_cgroupfs_options should catch that case and refcounts
>  		 * ensure that subsystems won't disappear once selected.
>  		 */
> -		BUG_ON(ss == NULL);
> -		if (ss->root != &rootnode) {
> +		BUG_ON(subsys[i] == NULL);
> +		if (subsys[i]->root != &rootnode) {
>  			/* Subsystem isn't free */
>  			return -EBUSY;
>  		}
>  	}
> 
> -	/* Currently we don't handle adding/removing subsystems when
> -	 * any child cgroups exist. This is theoretically supportable
> -	 * but involves complex error handling, so it's being left until
> -	 * later */
> -	if (root->number_of_cgroups > 1)
> +	/* removing will be supported later */
> +	if (root->number_of_cgroups > 1 && removed_bits)
>  		return -EBUSY;
> 
> +	if (root->number_of_cgroups > 1) {

Is there something wrong with the indentation here? I can't
see the closing brace for the "if (root->number_of_cgroups > 1)"
that should precede the for_each_set_bit() loop below.

> +		for_each_set_bit(i, &added_bits, CGROUP_SUBSYS_COUNT)
> +			if (!subsys[i]->can_bind)
> +				return -EBUSY;

I think you could avoid the can_bind flag field entirely and do:

			if (!subsys[i]->bind)

Also, if we're going with my "split out unbind" suggestion I think
the part here would be:

		for_each_set_bit(i, &removed_bits, CGROUP_SUBSYS_COUNT)
			if (!subsys[i]->unbind)
				return -EBUSY;

<snip>

Cheers,
	-Matt Helsley
