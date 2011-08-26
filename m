Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1HZPP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1HZPPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:15:55 -0400
Date: Fri, 26 Aug 2011 17:12:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bblum@andrew.cmu.edu, fweisbec@gmail.com,
        lizf@cn.fujitsu.com, paul@paulmenage.org, tj@kernel.org
Subject: Re: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110826151245.GA16243@redhat.com>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Andrew Morton wrote:
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> @@ -2135,14 +2135,17 @@ int cgroup_attach_proc(struct cgroup *cg
>  		oldcgrp = task_cgroup_from_root(tsk, root);
>  		if (cgrp == oldcgrp)
>  			continue;
> -		/* attach each task to each subsystem */
> -		for_each_subsys(root, ss) {
> -			if (ss->attach_task)
> -				ss->attach_task(cgrp, tsk);
> -		}
>  		/* if the thread is PF_EXITING, it can just get skipped. */
>  		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
> -		BUG_ON(retval != 0 && retval != -ESRCH);
> +		if (retval == 0) {
> +			/* attach each task to each subsystem */
> +			for_each_subsys(root, ss) {
> +				if (ss->attach_task)
> +					ss->attach_task(cgrp, tsk);
> +			}

Yes, I think this is what we need, the patch itself looks fine.



But this doesn't answer my another question. After that the code does

	 * step 4: do expensive, non-thread-specific subsystem callbacks.

		ss->attach(ss, cgrp, oldcgrp, leader);

OK, non-thread-specific is nice, but how can this "leader" represent
the process?

It can be zombie (but still group_leader) even without any races.
Say, cpuset_attach() and mem_cgroup_move_task() need get_task_mm(p).
How this can work if the leader is dead?

Also. Even if we add the locking around while_each_thread() (btw,
we need this in any case), we can race with exec which can change
the leader. In this case this task_struct has nothing to do with
the process we are going to attach, at all.

And, ss->can_attach(leader) has the same problems, it seems.




And. Say, devcgroup_can_attach() checks CAP_SYS_ADMIN. This is
security check. Why it is enough to check the leader only? We are
going to attach all threads. OK, this is probably fine, and I never
understood why capable/creds are not per-process, but this looks
so strange.

Oleg.

