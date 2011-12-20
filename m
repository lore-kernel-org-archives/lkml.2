Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1LTXa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:30:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42339 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1LTXaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:30:55 -0500
Date: Tue, 20 Dec 2011 15:30:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 4/5] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20111220233050.GM10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-5-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324422873-31001-5-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 20, 2011 at 03:14:32PM -0800, Mandeep Singh Baines wrote:
> @@ -1942,9 +1917,17 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  		}
>  	}
>  
> -	retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, false);
> -	if (retval)
> +	task_lock(tsk);
> +	oldcg = tsk->cgroups;
> +	task_unlock(tsk);

Probably this is patch order issue w/ Frederic's patch but we don't
need task_lock here, right?

> @@ -2171,17 +2088,18 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	 * step 2: make sure css_sets exist for all threads to be migrated.
>  	 * we use find_css_set, which allocates a new one if necessary.
>  	 */
> -	INIT_LIST_HEAD(&newcg_list);
>  	for (i = 0; i < group_size; i++) {
>  		tc = flex_array_get(group, i);
>  		/* get old css_set pointer */
>  		task_lock(tc->task);
>  		oldcg = tc->task->cgroups;
>  		task_unlock(tc->task);
> -		/* if we don't already have it in the list get a new one */
> -		if (!css_set_fetched(cgrp, tc->task, oldcg, &newcg_list))
> -			if (retval = css_set_prefetch(cgrp, oldcg, &newcg_list))
> -				goto out_list_teardown;
> +		tc->cg = find_css_set(oldcg, cgrp);
> +		if (!tc->cg) {
> +			retval = -ENOMEM;
> +			css_set_refs = i + 1;
> +			goto out_list_teardown;
> +		}

Nice cleanup, but can't the above be merged into the loop which builds
the flex array?

Thanks.

-- 
tejun
