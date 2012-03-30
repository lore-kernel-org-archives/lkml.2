Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab2C3UXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759571Ab2C3UX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:23:28 -0400
Date: Fri, 30 Mar 2012 22:15:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
Message-ID: <20120330201550.GA16628@redhat.com>
References: <20120330183104.GA12927@redhat.com> <1333134131.23924.191.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333134131.23924.191.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Steven Rostedt wrote:
>
> On Fri, 2012-03-30 at 20:31 +0200, Oleg Nesterov wrote:
> > Hello.
> >
> > I've looked at syscall_regfunc/unregfunc by accident, and I am
> > a bit confused...
> >
> > 	void syscall_regfunc(void)
> > 	{
> > 		unsigned long flags;
> > 		struct task_struct *g, *t;
> >
> > 		if (!sys_tracepoint_refcount) {
> > 			read_lock_irqsave(&tasklist_lock, flags);
> >
> > Why _irqsave? write_lock(tasklist) needs to disable irqs, but read_
> > doesn't. Any subtle reason I missed?
>
> As long as an interrupt doesn't take the tasklist lock as write,

No, this is forbidden.

> > 			do_each_thread(g, t) {
> > 				/* Skip kernel threads. */
> > 				if (t->mm)
> >
> > We should check PF_KTHREAD, not ->mm.
>
> A lot of places test ->mm for kernel threads.

And this is wrong, use_mm() can set ->mm != NULL. This is the common
mistake.

> Just search for ->mm in
> kernel/sched/core.c

Probably normalize_rt_tasks() and __sched_setscheduler() should be fixed.

> > Don't we need something like the patch below?
> >
> > Oleg.
> >
> >
> > --- x/kernel/fork.c
> > +++ x/kernel/fork.c
> > @@ -1446,7 +1446,12 @@ static struct task_struct *copy_process(
> >
> >  	total_forks++;
> >  	spin_unlock(&current->sighand->siglock);
> > +#ifdef CONFIG_TRACEPOINTS
> > +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
> > +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
>
> I'm not so worried about the set (although that should be done) but it
> is entirely possible that we need a clear too. Leaving this flag set
> would cause a task to take the overhead of tracing syscalls without ever
> tracing them.

Agreed. OK, I'll send the patch with "else clear".

But I don't really understand why do you think that "clear" is more
important. Sure, the wrong TIF_SYSCALL_TRACEPOINT triggers the slow
path unnecessary, but this is more or less harmless. But if we do
not set the task obviously won't report trace_sys*, this looks like
a bug even if nothing bad can happen.

Oleg.

