Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2FMVwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:52:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2FMVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:52:52 -0400
Date: Wed, 13 Jun 2012 14:52:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pidns: guarantee that the pidns init will be the
 last pidns process reaped
Message-Id: <20120613145248.f5caab7e.akpm@linux-foundation.org>
In-Reply-To: <20120530181500.GA20130@redhat.com>
References: <20120530175745.GA19327@redhat.com>
	<20120530181429.GA19989@redhat.com>
	<20120530181500.GA20130@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012 20:15:00 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
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
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -64,7 +64,6 @@ static void exit_mm(struct task_struct * tsk);
>  static void __unhash_process(struct task_struct *p, bool group_dead)
>  {
>  	nr_threads--;
> -	detach_pid(p, PIDTYPE_PID);
>  	if (group_dead) {
>  		detach_pid(p, PIDTYPE_PGID);
>  		detach_pid(p, PIDTYPE_SID);
> @@ -72,7 +71,20 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  		list_del_rcu(&p->tasks);
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
> +		/*
> +		 * If we are the last child process in a pid namespace to be
> +		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
> +		 */
> +		if (IS_ENABLED(CONFIG_PID_NS)) {
> +			struct task_struct *parent = p->real_parent;
> +
> +			if ((task_active_pid_ns(p)->child_reaper == parent) &&
> +			    list_empty(&parent->children) &&
> +			    (parent->flags & PF_EXITING))
> +				wake_up_process(parent);
> +		}
>  	}
> +	detach_pid(p, PIDTYPE_PID);
>  	list_del_rcu(&p->thread_group);
>  }
>  
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 57bc1fd..41ed867 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -179,11 +179,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	}
>  	read_unlock(&tasklist_lock);
>  
> +	/* Firstly reap the EXIT_ZOMBIE children we may have. */
>  	do {
>  		clear_thread_flag(TIF_SIGPENDING);
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
>  
> +	/*
> +	 * sys_wait4() above can't reap the TASK_DEAD children.
> +	 * Make sure they all go away, see __unhash_process().
> +	 */
> +	for (;;) {
> +		bool need_wait = false;
> +
> +		read_lock(&tasklist_lock);
> +		if (!list_empty(&current->children)) {
> +			__set_current_state(TASK_UNINTERRUPTIBLE);
> +			need_wait = true;
> +		}
> +		read_unlock(&tasklist_lock);
> +
> +		if (!need_wait)
> +			break;
> +		schedule();

This sleep is terminated by the above wake_up_process(), yes?

But that wake_up_process() only happens if CONFIG_PID_NS.  It's
unobvious (to me) that we can't get stuck in D state if
CONFIG_PID_NS=n.  If bug, please fix.  If not bug, please make obvious
to me ;)

<looks at the locking a bit>

<gets distracted>

That tty_kref_put() in __exit_signal() is running with tasklist_lock
held, yes?  It does a ton of work and calls out to random drivers and
none of this needs tasklist_lock.  Seems risky.
