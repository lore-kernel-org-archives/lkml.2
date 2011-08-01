Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HAXOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:14:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab1HAXN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:13:59 -0400
Date: Mon, 1 Aug 2011 16:13:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-Id: <20110801161347.5f4aeeeb.akpm@linux-foundation.org>
In-Reply-To: <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
	<1311956010-32076-8-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 18:13:29 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Add a new subsystem to limit the number of running tasks,
> similar to the NR_PROC rlimit but in the scope of a cgroup.
> 
> This is a step to be able to isolate a bit more a cgroup against
> the rest of the system and limit the global impact of a fork bomb
> inside a given cgroup.
> 
> ...
>
> +config CGROUP_TASK_COUNTER
> +        bool "Control number of tasks in a cgroup"
> +	depends on RESOURCE_COUNTERS
> +	help
> +	  This option let the user to set up an upper bound allowed number
> +	  of tasks inside a cgroup.

whitespace went weird.

> 
> ...
>
 +
> +static void task_counter_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
> +{
> +	res_counter_inherit(cgroup_task_counter_res(cgrp), RES_LIMIT);

cgroup_task_counter_res() has code in it to carefully return NULL in
one situation, but if it does this, res_counter_inherit() will then
cheerily oops.  This makes no sense.

> +}
> +
> 
> ...
>
> +/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
> +static struct res_counter *common_ancestor;
> +
> +static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
> +					struct task_struct *tsk)
> +{
> +	struct res_counter *res = cgroup_task_counter_res(cgrp);
> +	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> +	struct res_counter *limit_fail_at;
> +
> +	common_ancestor = res_counter_common_ancestor(res, old_res);

This might oops too?

> +	return res_counter_charge_until(res, common_ancestor, 1, &limit_fail_at);
> +}
> +
> 
> ...
>
> +int cgroup_task_counter_fork(struct task_struct *child)
> +{
> +	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
> +	struct cgroup *cgrp = css->cgroup;
> +	struct res_counter *limit_fail_at;
> +
> +	/* Optimize for the root cgroup case, which doesn't have a limit */
> +	if (!cgrp->parent)
> +		return 0;
> +
> +	return res_counter_charge(cgroup_task_counter_res(cgrp), 1, &limit_fail_at);
> +}

It took a while for me to work out the meaning of the return value from
this function.  Some documentation would be nice?


