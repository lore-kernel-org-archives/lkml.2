Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2EVQzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab2EVQze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:55:34 -0400
Date: Tue, 22 May 2012 18:54:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] pidns: Guarantee that the pidns init will be the last
	pidns process reaped. v2
Message-ID: <20120522165408.GA30922@redhat.com>
References: <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d35x5ank.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Eric W. Biederman wrote:
>
> Andrew can you replace your earlier version of this patch in your tree
> with this one,

Yes, please, the old one is

	pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch

> after Oleg takes a look at it.  I think this is about
> as simple and maintainable and obvious as we can make this bug fix.

I believe the patch is fine.

Thanks Eric.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -64,15 +64,26 @@ static void exit_mm(struct task_struct * tsk);
>  static void __unhash_process(struct task_struct *p, bool group_dead)
>  {
>  	nr_threads--;
> -	detach_pid(p, PIDTYPE_PID);
>  	if (group_dead) {
> +		struct task_struct *parent;
> +
>  		detach_pid(p, PIDTYPE_PGID);
>  		detach_pid(p, PIDTYPE_SID);
>  
>  		list_del_rcu(&p->tasks);
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
> +
> +		/* If we are the last child process in a pid namespace
> +		 * to be reaped notify the child_reaper.
> +		 */
> +		parent = p->real_parent;
> +		if ((task_active_pid_ns(p)->child_reaper == parent) &&
> +		    list_empty(&parent->children) &&
> +		    (parent->flags & PF_EXITING))
> +			wake_up_process(parent);
>  	}
> +	detach_pid(p, PIDTYPE_PID);
>  	list_del_rcu(&p->thread_group);
>  }
>  
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index b98b0ed..ba1cbb8 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
>  
> +	read_lock(&tasklist_lock);
> +	for (;;) {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (list_empty(&current->children))
> +			break;
> +		read_unlock(&tasklist_lock);
> +		schedule();
> +		read_lock(&tasklist_lock);
> +	}
> +	read_unlock(&tasklist_lock);
> +
>  	if (pid_ns->reboot)
>  		current->signal->group_exit_code = pid_ns->reboot;
>  
> -- 
> 1.7.5.4
> 

