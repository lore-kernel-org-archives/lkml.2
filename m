Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2JSNmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:42:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2JSNmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:42:37 -0400
Message-ID: <1350654126.2768.5.camel@twins>
Subject: Re: [PATCH] sched, autogroup: fix kernel crashes caused by runtime
 disable autogroup
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 19 Oct 2012 15:42:06 +0200
In-Reply-To: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always try and CC people who wrote the code..

On Fri, 2012-10-19 at 16:36 +0800, Xiaotian Feng wrote:
> There's a regression from commit 800d4d30, in autogroup_move_group()
> 
> 	p->signal->autogroup = autogroup_kref_get(ag);
> 
> 	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> 		goto out;
> 	...
>     out:
> 	autogroup_kref_put(prev);
> 
> So kernel changed p's autogroup to ag, but never sched_move_task(p).
> Then previous autogroup of p is released, which may release task_group
> related with p. After commit 8323f26ce, p->sched_task_group might point
> to this stale value, and thus caused kernel crashes.
> 
> This is very easy to reproduce, add "kernel.sched_autogroup_enabled = 0"
> to your /etc/sysctl.conf, your system will never boot up. It is not reasonable
> to put the sysctl enabled check in autogroup_move_group(), kernel should check
> it before autogroup_create in sched_autogroup_create_attach().
> 
> Reported-by: cwillu <cwillu@cwillu.com>
> Reported-by: Luis Henriques <luis.henriques@canonical.com>
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/auto_group.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
> index 0984a21..ac62415 100644
> --- a/kernel/sched/auto_group.c
> +++ b/kernel/sched/auto_group.c
> @@ -143,15 +143,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
>  
>  	p->signal->autogroup = autogroup_kref_get(ag);
>  
> -	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> -		goto out;
> -
>  	t = p;
>  	do {
>  		sched_move_task(t);
>  	} while_each_thread(p, t);
>  
> -out:
>  	unlock_task_sighand(p, &flags);
>  	autogroup_kref_put(prev);
>  }

So I've looked at this for all of 1 minute, but why isn't moving that
check up one line to be above the p->signal->autogroup assignment
enough?

> @@ -159,8 +155,12 @@ out:
>  /* Allocates GFP_KERNEL, cannot be called under any spinlock */
>  void sched_autogroup_create_attach(struct task_struct *p)
>  {
> -	struct autogroup *ag = autogroup_create();
> +	struct autogroup *ag;
> +
> +	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
> +		return;
>  
> +	ag = autogroup_create();
>  	autogroup_move_group(p, ag);
>  	/* drop extra reference added by autogroup_create() */
>  	autogroup_kref_put(ag);

Man,.. so on memory allocation fail we'll put the group in
autogroup_default, which I think ends up being the root cgroup.

But what happens when sysctl_sched_autogroup_enabled is false?

It looks like sched_autogroup_fork() is effective in that case, which
would mean we'll stay in whatever group our parent is in, which is not
the same as being disabled.


