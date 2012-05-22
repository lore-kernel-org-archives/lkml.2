Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2EVTXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:23:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2EVTXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:23:16 -0400
Date: Tue, 22 May 2012 12:23:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] pidns: Guarantee that the pidns init will be the last
 pidns process reaped. v2
Message-Id: <20120522122315.c3f2118c.akpm@linux-foundation.org>
In-Reply-To: <87d35x5ank.fsf_-_@xmission.com>
References: <m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com>
	<8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com>
	<878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com>
	<87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com>
	<87zk95kper.fsf@xmission.com>
	<20120521124414.GA20391@redhat.com>
	<87d35x5ank.fsf_-_@xmission.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 18:20:31 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> Today we have a two-fold bug.  Sometimes release_task on pid == 1 in a
> pid namespace can run before other processes in a pid namespace have had
> release task called.  With the result that pid_ns_release_proc can be
> called before the last proc_flus_task() is done using
> upid->ns->proc_mnt, resulting in the use of a stale pointer.  This same
> set of circumstances can lead to waitpid(...) returning for a processes
> started with clone(CLONE_NEWPID) before the every process in the pid
> namespace has actually exited.
> 
> To fix this modify zap_pid_ns_processess wait until all other processes
> in the pid namespace have exited, even EXIT_DEAD zombies.
> 
> The delay_group_leader and related tests ensure that the thread gruop
> leader will be the last thread of a process group to be reaped, or to
> become EXIT_DEAD and self reap.  With the change to zap_pid_ns_processes
> we get the guarantee that pid == 1 in a pid namespace will be the last
> task that release_task is called on.
> 
> With pid == 1 being the last task to pass through release_task
> pid_ns_release_proc can no longer be called too early nor can wait
> return before all of the EXIT_DEAD tasks in a pid namespace have exited.
> 
> ...
>
> index d8bd3b42..abc4fc0 100644
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

like this:
		/*
		 * If ...

> +		 * to be reaped notify the child_reaper.

s/reaped/reaped,/

More seriously, it isn't a very good comment.  It tells us "what" the
code is doing (which is pretty obvious from reading it), but it didn't
tell us "why" it is doing this.  Why do PID namespaces need special
handling here?  What's the backstory??

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

Well.

a) This loop can leave the thread in state TASK_UNINTERRUPTIBLE,
   which looks wrong.

b) Given that the waking side is also testing list_empty(), I think
   you might need set_current_state() here, with the barrier.  So that
   this thread gets the correct view of the list_head wrt the waker's
   view.

c) Did we really need to bang on tasklist_lock so many times?  There
   doesn't seem a nicer way of structuring this :(

d) Anyone who reads this code a year from now will come away
   thinking "wtf".

   IOW, wtf?  We sit in a dead loop waiting for ->children to drain.
   But why?  Who is draining them?  What are the dynamics here? Why
   do we care?

   IOW, it needs a comment!!
