Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573Ab2C3TCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:02:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2C3TCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:02:13 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wMWVvwg0qUAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=EDzJv-hP_w19qHAYj08A:9 a=q0s2fXWXJgseYUqU11IA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1333134131.23924.191.camel@gandalf.stny.rr.com>
Subject: Re: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2012 15:02:11 -0400
In-Reply-To: <20120330183104.GA12927@redhat.com>
References: <20120330183104.GA12927@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 20:31 +0200, Oleg Nesterov wrote:
> Hello.
> 
> I've looked at syscall_regfunc/unregfunc by accident, and I am
> a bit confused...
> 
> 	void syscall_regfunc(void)
> 	{
> 		unsigned long flags;
> 		struct task_struct *g, *t;
> 
> 		if (!sys_tracepoint_refcount) {
> 			read_lock_irqsave(&tasklist_lock, flags);
> 
> Why _irqsave? write_lock(tasklist) needs to disable irqs, but read_
> doesn't. Any subtle reason I missed?

As long as an interrupt doesn't take the tasklist lock as write, we
don't. If it doesn't then we should be safe not to disable interrupts
here.

> 
> 			do_each_thread(g, t) {
> 				/* Skip kernel threads. */
> 				if (t->mm)
> 
> We should check PF_KTHREAD, not ->mm.

A lot of places test ->mm for kernel threads. Just search for ->mm in
kernel/sched/core.c


> 
> 					set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> 
> But the main question is, can't we race with clone() and miss the
> new child? The new task is not "visible" to do_each_thread() until
> copy_process()->list_add_tail_rcu(thread_group/init_task.tasks).
> 
> Don't we need something like the patch below?
> 
> Oleg.
> 
> 
> --- x/kernel/fork.c
> +++ x/kernel/fork.c
> @@ -1446,7 +1446,12 @@ static struct task_struct *copy_process(
>  
>  	total_forks++;
>  	spin_unlock(&current->sighand->siglock);
> +#ifdef CONFIG_TRACEPOINTS
> +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
> +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);

I'm not so worried about the set (although that should be done) but it
is entirely possible that we need a clear too. Leaving this flag set
would cause a task to take the overhead of tracing syscalls without ever
tracing them.

-- Steve


> +#endif
>  	write_unlock_irq(&tasklist_lock);
> +
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);
>  	if (clone_flags & CLONE_THREAD)


