Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1LXCai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 21:30:38 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47234 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1LXCah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 21:30:37 -0500
Date: Sat, 24 Dec 2011 03:30:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/2] cgroup: replace tasklist_lock with rcu_read_lock
Message-ID: <20111224023028.GD28309@somewhere.redhat.com>
References: <1324661325-31968-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324661325-31968-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 09:28:44AM -0800, Mandeep Singh Baines wrote:
> Since cgroup_attach_proc is protected by a threadgroup_lock, we
> can replace the tasklist_lock in cgroup_attach_proc with an
> rcu_read_lock. To keep the complexity of the double-check locking
> in one place, I also moved the thread_group_leader check up into
> attach_task_by_pid. This allows us to use a goto instead of
> returning -EAGAIN.
> 
> While at it, also converted a couple of returns to gotos.
> 
> Changes in V3:
> * https://lkml.org/lkml/2011/12/22/419 (Frederic Weisbecker)
>   * Add an rcu_read_lock to protect against exit
> Changes in V2:
> * https://lkml.org/lkml/2011/12/22/86 (Tejun Heo)
>   * Use a goto instead of returning -EAGAIN
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   74 +++++++++++++++++++-----------------------------------
>  1 files changed, 26 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1042b3c..6ee1438 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2102,21 +2102,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	if (retval)
>  		goto out_free_group_list;
>  
> -	/* prevent changes to the threadgroup list while we take a snapshot. */
> -	read_lock(&tasklist_lock);
> -	if (!thread_group_leader(leader)) {
> -		/*
> -		 * a race with de_thread from another thread's exec() may strip
> -		 * us of our leadership, making while_each_thread unsafe to use
> -		 * on this task. if this happens, there is no choice but to
> -		 * throw this task away and try again (from cgroup_procs_write);
> -		 * this is "double-double-toil-and-trouble-check locking".
> -		 */
> -		read_unlock(&tasklist_lock);
> -		retval = -EAGAIN;
> -		goto out_free_group_list;
> -	}
> -
> +	rcu_read_lock();

Please add a comment to explain why we need this. This may not be obvious
to other people that are not familiar with that code.

>  	tsk = leader;
>  	i = 0;

Also you can move rcu_read_lock() straight here. The two above operations don't need to
be protected.

>  	do {
> @@ -2145,7 +2131,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	group_size = i;
>  	tset.tc_array = group;
>  	tset.tc_array_len = group_size;
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();

In a similar way, you can move rcu_read_unlock() right after while_each_thread().

Thanks.
