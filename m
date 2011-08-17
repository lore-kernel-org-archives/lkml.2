Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1HQCoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:44:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1HQCoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:44:01 -0400
Message-ID: <4E4B2B06.4010108@cn.fujitsu.com>
Date: Wed, 17 Aug 2011 10:44:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 8/8] res_counter: Allow charge failure pointer to be null
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-9-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1311956010-32076-9-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:42:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:42:45,
	Serialize complete at 2011-08-17 10:42:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> So that callers of res_counter_charge() don't have to create and
> pass this pointer even if they aren't interested in it.
> 

Why not make this change early, or even do this in "[PATCH 5/8]".

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/cgroup_task_counter.c |    6 ++----
>  kernel/res_counter.c         |    6 ++++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cgroup_task_counter.c b/kernel/cgroup_task_counter.c
> index 7f12ac9..dacc4a9 100644
> --- a/kernel/cgroup_task_counter.c
> +++ b/kernel/cgroup_task_counter.c
> @@ -93,11 +93,10 @@ static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_
>  {
>  	struct res_counter *res = cgroup_task_counter_res(cgrp);
>  	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
> -	struct res_counter *limit_fail_at;
>  
>  	common_ancestor = res_counter_common_ancestor(res, old_res);
>  
> -	return res_counter_charge_until(res, common_ancestor, 1, &limit_fail_at);
> +	return res_counter_charge_until(res, common_ancestor, 1, NULL);
>  }
>  
>  static void task_counter_cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> @@ -154,13 +153,12 @@ int cgroup_task_counter_fork(struct task_struct *child)
>  {
>  	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
>  	struct cgroup *cgrp = css->cgroup;
> -	struct res_counter *limit_fail_at;
>  
>  	/* Optimize for the root cgroup case, which doesn't have a limit */
>  	if (!cgrp->parent)
>  		return 0;
>  
> -	return res_counter_charge(cgroup_task_counter_res(cgrp), 1, &limit_fail_at);
> +	return res_counter_charge(cgroup_task_counter_res(cgrp), 1, NULL);
>  }
>  
>  struct cgroup_subsys tasks_subsys = {
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 725dfa6..7eac803 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -43,14 +43,16 @@ int res_counter_charge_until(struct res_counter *counter,
>  	unsigned long flags;
>  	struct res_counter *c, *u;
>  
> -	*limit_fail_at = NULL;
> +	if (limit_fail_at)
> +		*limit_fail_at = NULL;
>  	local_irq_save(flags);
>  	for (c = counter; c != limit; c = c->parent) {
>  		spin_lock(&c->lock);
>  		ret = res_counter_charge_locked(c, val);
>  		spin_unlock(&c->lock);
>  		if (ret < 0) {
> -			*limit_fail_at = c;
> +			if (limit_fail_at)
> +				*limit_fail_at = c;
>  			goto undo;
>  		}
>  	}
