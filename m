Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1HQDSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:18:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1HQDSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:18:39 -0400
Message-ID: <4E4B3322.6060608@cn.fujitsu.com>
Date: Wed, 17 Aug 2011 11:18:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1311956010-32076-8-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 11:17:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 11:17:22,
	Serialize complete at 2011-08-17 11:17:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/init/Kconfig b/init/Kconfig
> index 412c21b..bea98d2d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -690,6 +690,13 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>  	  select this option (if, for some reason, they need to disable it
>  	  then noswapaccount does the trick).
>  
> +config CGROUP_TASK_COUNTER
> +        bool "Control number of tasks in a cgroup"

TAB

> +	depends on RESOURCE_COUNTERS
> +	help
> +	  This option let the user to set up an upper bound allowed number

will let?

> +	  of tasks inside a cgroup.
> +
>  config CGROUP_PERF
>  	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
>  	depends on PERF_EVENTS && CGROUPS

...

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

I think we should change the return value of res_counter_charge.
Currently it returns -ENOMEM when we excceed limit.

> +}
> +
> +struct cgroup_subsys tasks_subsys = {
> +	.name			= "tasks",
> +	.subsys_id		= tasks_subsys_id,
> +	.create			= task_counter_create,
> +	.post_clone		= task_counter_post_clone,
> +	.destroy		= task_counter_destroy,
> +	.exit			= task_counter_exit,
> +	.can_attach_task	= task_counter_can_attach_task,
> +	.cancel_attach_task	= task_counter_cancel_attach_task,
> +	.attach_task		= task_counter_attach_task,
> +	.populate		= task_counter_populate,
> +	.early_init		= 1,

Just set early_init to 0, since this subsystem doesn't have to be
initialized early during kernel boot.

> +};
