Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1IRRpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab1IRRpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:45:30 -0400
Date: Sun, 18 Sep 2011 19:41:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>
Subject: Re: [PATCH 4/4] cgroup: always lock threadgroup during migration
Message-ID: <20110918174117.GB2384@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-5-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315159280-25032-5-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Tejun Heo wrote:
>
> * Remove -ESRCH failure path from cgroup_task_migrate().  With the
>   above changes, it's guaranteed to be called only for live tasks.

I think you can remove another similar check,

> @@ -2044,6 +2044,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	tsk = leader;
>  	i = 0;
>  	do {
> +		/* @tsk either already exited or can't exit until the end */
> +		if (tsk->flags & PF_EXITING)
> +			continue;
> +
>  		/* as per above, nr_threads may decrease, but not increase. */
>  		BUG_ON(i >= group_size);
>  		get_task_struct(tsk);

And then cgroup_attach_proc() does

	for (i = 0; i < group_size; i++) {
		...
		task_lock(tsk);
		if (tsk->flags & PF_EXITING) {
			task_unlock(tsk);
			continue;

Afaics, this is no longer needed.

Oleg.

