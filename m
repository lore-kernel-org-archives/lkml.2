Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1LVIxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:53:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1LVIxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:53:46 -0500
Message-ID: <4EF2F095.90207@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 16:55:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [RFC PATCH] cgroup: Remove task_lock() from cgroup_post_fork()
References: <1324516711-26913-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1324516711-26913-1-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 16:52:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 16:52:57,
	Serialize complete at 2011-12-22 16:52:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> cgroup_post_fork() is protected between threadgroup_change_begin()
> and threadgroup_change_end() against concurrent changes of the
> child's css_set in cgroup_task_migrate(). Also the child can't
> exit and call cgroup_exit() at this stage, this means it's css_set
> can't be changed with init_css_set concurrently.
> 
> For these reasons, we don't need to hold task_lock() on the child
> because it's css_set can only remain stable in this place.
> 
> Let's remove the lock there.
> 
> NOTE: We could do something else: move threadgroup_change_end()
> before cgroup_post_fork() and keep the task_lock() which, combined
> with the css_set_lock, would be enough to synchronize against
> cgroup_task_migrate()'s change on child->cgroup and its cglist.
> Because outside that, the threadgroup lock doesn't appear to be
> needed on cgroup_post_fork().
> 

To narrow the scope of the threadgroup lock? I think it's preferable to keep
cgroup_post_fork() inside the lock, to make things simpler and we have
the same lock rule for both cgroup_fork() and cgroup_post_fork().

> Let's debate!
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> ---
>  kernel/cgroup.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 4936d88..d0dbf72 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4622,10 +4622,15 @@ void cgroup_post_fork(struct task_struct *child)
>  {
>  	if (use_task_css_set_links) {
>  		write_lock(&css_set_lock);
> -		task_lock(child);
> -		if (list_empty(&child->cg_list))
> +		if (list_empty(&child->cg_list)) {
> +			/*
> +			 * It's safe to use child->cgroups without task_lock()
> +			 * here because we are protected through
> +			 * threadgroup_change_begin() against concurrent
> +			 * css_set change in cgroup_task_migrate()
> +			 */

Also explain why it won't race with cgroup_exit()? You were not quite confident
about that before Oleg's explanation. ;)

>  			list_add(&child->cg_list, &child->cgroups->tasks);
> -		task_unlock(child);
> +		}
>  		write_unlock(&css_set_lock);
>  	}
>  }
