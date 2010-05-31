Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0EaRzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:55:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab0EaRzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:55:14 -0400
Date: Mon, 31 May 2010 19:52:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com, menage@google.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100531175242.GA14691@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I only glanced into one function, cgroup_attach_proc(), and some things
look "obviously wrong". Sorry, I can't really read these patches now,
most probably I misunderstood the code...

> +int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> +{
> +	int retval;
> +	struct cgroup_subsys *ss, *failed_ss = NULL;
> +	struct cgroup *oldcgrp;
> +	struct css_set *oldcg;
> +	struct cgroupfs_root *root = cgrp->root;
> +	/* threadgroup list cursor */
> +	struct task_struct *tsk;
> +	/*
> +	 * we need to make sure we have css_sets for all the tasks we're
> +	 * going to move -before- we actually start moving them, so that in
> +	 * case we get an ENOMEM we can bail out before making any changes.
> +	 */
> +	struct list_head newcg_list;
> +	struct cg_list_entry *cg_entry, *temp_nobe;
> +
> +	/*
> +	 * Note: Because of possible races with de_thread(), we can't
> +	 * distinguish between the case where the user gives a non-leader tid
> +	 * and the case where it changes out from under us. So both are allowed.
> +	 */

OK, the caller has a reference to the argument, leader,

> +	leader = leader->group_leader;

But why it is safe to use leader->group_leader if we race with exec?

> +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {

Even if we didn't change "leader" above, this is not safe in theory.
We already discussed this, list_for_each_rcu(head) is only safe when
we know that "head" itself is valid.

Suppose that this leader exits, then leader->thread_group.next exits
too before we take rcu_read_lock().

> +	oldcgrp = task_cgroup_from_root(leader, root);
> +	if (cgrp != oldcgrp) {
> +		retval = cgroup_task_migrate(cgrp, oldcgrp, leader, true);
> +		BUG_ON(retval != 0 && retval != -ESRCH);
> +	}
> +	/* Now iterate over each thread in the group. */
> +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
> +		BUG_ON(tsk->signal != leader->signal);
> +		/* leave current thread as it is if it's already there */
> +		oldcgrp = task_cgroup_from_root(tsk, root);
> +		if (cgrp == oldcgrp)
> +			continue;
> +		/* we don't care whether these threads are exiting */
> +		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
> +		BUG_ON(retval != 0 && retval != -ESRCH);
> +	}

This looks strange. Why do we move leader outside of the loop ?
Of course, list_for_each_entry() can't work to move all sub-threads,
but "do while_each_thread()" can.

>From 0/2:
>
> recentish changes to signal_struct's lifetime rules (which don't seem to
> appear when I check out mmotm with git clone,

already in Linus's tree.

Oleg.

