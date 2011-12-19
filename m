Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1LSRUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:20:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34796 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1LSRUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:20:32 -0500
Date: Mon, 19 Dec 2011 09:20:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroup: remove redundate get/put of old css_set from
 migrate
Message-ID: <20111219172027.GJ24519@google.com>
References: <1324053511-24591-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324053511-24591-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 08:38:31AM -0800, Mandeep Singh Baines wrote:
> We can now assume that the css_set reference held by the task
> will not go away for an exiting task. PF_EXITING state can be
> trusted throughout migration by checking it after locking
> threadgroup.
> 
> This patch depends on:
> 
> commit cd3d095275374220921fcf0d4e0c16584b26ddbc
> Author: Tejun Heo <tj@kernel.org>
> Date:   Mon Dec 12 18:12:21 2011 -0800
> 
>     cgroup: always lock threadgroup during migration
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   25 ++++++-------------------
>  1 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1b3b841..eb95e32 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1856,7 +1856,6 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	 */
>  	task_lock(tsk);
>  	oldcg = tsk->cgroups;
> -	get_css_set(oldcg);
>  	task_unlock(tsk);
>  
>  	/* locate or allocate a new css_set for this task. */
> @@ -1872,12 +1871,9 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  		might_sleep();
>  		/* find_css_set will give us newcg already referenced. */
>  		newcg = find_css_set(oldcg, cgrp);
> -		if (!newcg) {
> -			put_css_set(oldcg);
> +		if (!newcg)
>  			return -ENOMEM;
> -		}
>  	}
> -	put_css_set(oldcg);
>  
>  	/* @tsk can't exit as its threadgroup is locked */
>  	task_lock(tsk);
> @@ -2015,9 +2011,8 @@ struct cg_list_entry {
>  	struct list_head links;
>  };
>  
> -static bool css_set_check_fetched(struct cgroup *cgrp,
> -				  struct task_struct *tsk, struct css_set *cg,
> -				  struct list_head *newcg_list)
> +static bool css_set_fetched(struct cgroup *cgrp, struct task_struct *tsk,
> +			    struct css_set *cg, struct list_head *newcg_list)

I know this is a trivial change and am generally okay with somewhat
related trivial stuff being tacked on other changes but can you please
note it in the patch description, so that it's clear the change is
intentional and not from patch contamination?  I usually add a
paragraph starting with "while at it" at the end.

Thanks.

-- 
tejun
