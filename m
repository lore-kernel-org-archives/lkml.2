Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1HIPPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab1HIPPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:15:20 -0400
Date: Tue, 9 Aug 2011 17:11:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809151155.GA15311@redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Frederic Weisbecker wrote:
>
> +static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> +					struct task_struct *tsk)
> +{
> +	struct res_counter *res = cgroup_task_counter_res(cgrp);
> +	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> +	struct res_counter *limit_fail_at;
> +
> +	common_ancestor = res_counter_common_ancestor(res, old_res);
> +
> +	return res_counter_charge_until(res, common_ancestor, 1, &limit_fail_at);
> +}
>
> ...
>
> +static void task_counter_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> +				     struct task_struct *tsk)
> +{
> +	res_counter_uncharge_until(cgroup_task_counter_res(old_cgrp), common_ancestor, 1);
> +}

This doesn't look right or I missed something.

What if tsk exits in between? Afaics this can happen with both
cgroup_attach_task() and cgroup_attach_proc().

Let's look at cgroup_attach_task(). Suppose that
task_counter_can_attach_task() succeeds and charges the new cgrp,
Then cgroup_task_migrate() returns -ESRCH. Who will uncharge the
new cgrp?


cgroup_attach_proc() is different, it calls cgroup_task_migrate()
after ->attach_task(). Cough.

In this case old_cgrp can be uncharged twice, no? And again, nobody
will uncharge the new cgrp?



->attach_task() can be skipped if cgrp == oldcgrp... Probably this
is fine, in this case can_attach_task() shouldn't actually charge.


> @@ -1295,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->group_leader = p;
>  	INIT_LIST_HEAD(&p->thread_group);
>
> +	retval = cgroup_task_counter_fork(p);
> +	if (retval)
> +		goto bad_fork_free_pid;
> +

Well, imho this is not good. You are adding yet another cgroup hook.
Why you can not reuse cgroup_fork_callbacks() ?

Yes, it returns void. Can't we chane ->fork() to return the error and
make it boolean?

Better yet,

	-	cgroup_fork_callbacks(p);
	-	cgroup_callbacks_done = 1;
	+	failed_ss = cgroup_fork_callbacks(p);
	+	if (failed_ss)
	+		goto bad_fork_free_pid;

	...

	-	cgroup_exit(p, cgroup_callbacks_done);
	+	cgroup_exit(p, failed_ss);

What do you think?

Oleg.

