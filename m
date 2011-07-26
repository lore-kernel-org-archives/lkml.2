Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1GZBRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:17:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1GZBRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:17:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=R/vd0xE9V5X1ZKE7n89pSyCGzi1/UJmzHbfob5POCIi86uvtYJlfGI2xsVPvg3xA7
	EluUqQKhC6o4S8dOzFjiQ==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-8-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-8-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 18:17:08 -0700
Message-ID: <CAJniumW7ZKLLDaXSZ4TZ_=PX0ARERTeEyL-iTir12hciOArJqA@mail.gmail.com>
Subject: Re: [PATCH 7/7] cgroups: Add a max number of tasks subsystem
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>  /* */
> +
> +#ifdef CONFIG_CGROUP_MAX_TASKS
> +SUBSYS(max_tasks)
> +#endif

I think I'd be inclined to make the naming slightly (IMO) cleaner:
call the subsystem 'tasks' and the files 'limit' and 'count' (or maybe
'usage' to be more in line with memcg).
>
> +config CGROUP_MAX_TASKS
> +        bool "Control max number of tasks in a cgroup"
> +       depends on RESOURCE_COUNTERS
> +       help
> +         This option let the user to set up an upper bound allowed number
> +         of tasks.
> +

Needs to depend on CGROUPS too?

> +
> +
> +struct task_counter {
> +       struct res_counter              res;
> +       struct cgroup_subsys_state      css;
> +};

All other CSS structures put the "css" field as the first thing in the
structure. Not sure that anything relies on that, but consistency
can't hurt and it probably makes the code fractionally smaller since
the translation between CSS and task_counter becomes a no-op.

> +static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +                             struct cgroup *old_cgrp, struct task_struct *task)
> +{
> +       struct task_counter *cnt = cgroup_task_counter(old_cgrp);
> +
> +       if (cnt != &root_counter)
> +               res_counter_uncharge_until(&cnt->res, &root_counter.res, 1);
> +}

Do we even need the root_counter to be exposed in any way? Why not
make children of the root cgroup just have a NULL parent res_counter?

You'll still need a task_counter object so that the cgroups framework
has a CSS object for cgroups housekeeping, but I don't think it needs
to actually be used for anything.

Paul
