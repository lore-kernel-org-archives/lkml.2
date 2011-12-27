Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1L0CiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 21:38:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab1L0CiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 21:38:11 -0500
Message-ID: <4EF93018.5020807@cn.fujitsu.com>
Date: Tue, 27 Dec 2011 10:40:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/2] cgroup: replace tasklist_lock with rcu_read_lock
References: <1324661325-31968-1-git-send-email-msb@chromium.org>
In-Reply-To: <1324661325-31968-1-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 10:37:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-27 10:37:23,
	Serialize complete at 2011-12-27 10:37:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> Since cgroup_attach_proc is protected by a threadgroup_lock, we
> can replace the tasklist_lock in cgroup_attach_proc with an
> rcu_read_lock.

> To keep the complexity of the double-check locking
> in one place, I also moved the thread_group_leader check up into
> attach_task_by_pid. This allows us to use a goto instead of
> returning -EAGAIN.

Please split it into 2 patches, so each patch does one and only
one thing.

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
>  	tsk = leader;
>  	i = 0;
>  	do {
> @@ -2145,7 +2131,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	group_size = i;
>  	tset.tc_array = group;
>  	tset.tc_array_len = group_size;
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  
>  	/* methods shouldn't be called if no task is actually migrating */
>  	retval = 0;
> @@ -2242,22 +2228,14 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
>  	if (!cgroup_lock_live_group(cgrp))
>  		return -ENODEV;
>  
> +retry_find_task:
>  	if (pid) {
>  		rcu_read_lock();
>  		tsk = find_task_by_vpid(pid);
>  		if (!tsk) {
>  			rcu_read_unlock();
> -			cgroup_unlock();
> -			return -ESRCH;
> -		}
> -		if (threadgroup) {
> -			/*
> -			 * RCU protects this access, since tsk was found in the
> -			 * tid map. a race with de_thread may cause group_leader
> -			 * to stop being the leader, but cgroup_attach_proc will
> -			 * detect it later.
> -			 */
> -			tsk = tsk->group_leader;
> +			ret= -ESRCH;

ret = -ESRCH;

> +			goto out_unlock_cgroup;
>  		}
>  		/*
>  		 * even if we're attaching all tasks in the thread group, we
