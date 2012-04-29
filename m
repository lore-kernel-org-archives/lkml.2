Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2D2Q7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab2D2Q7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:59:43 -0400
Date: Sun, 29 Apr 2012 18:58:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
Message-ID: <20120429165846.GA19054@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net> <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ns355ru.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Heh. Please look at http://marc.info/?l=linux-kernel&m=127687751003902
> > and the whole thread, there are a lot more problems here.
>
> I don't remember seeing a leak in that conversation.

It was discussed many times ;) in particular, from the link above:

	Note: afaics we have another problem. What if copy_process(CLONE_NEWPID)
	fails after pid_ns_prepare_proc() ? Who will do mntput() ?

But we all forgot about this (relatively minor) problem.

> > But this particular one looks simple iirc.
> >
> >> @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> >>  	rcu_assign_pointer(p->nsproxy, new);
> >>
> >>  	if (ns && atomic_dec_and_test(&ns->count)) {
> >> +		/* Handle fork() failure, unmount proc before proceeding */
> >> +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
> >> +			struct pid_namespace *pid_ns = ns->pid_ns;
> >> +
> >> +			if (pid_ns && pid_ns != &init_pid_ns)
> >> +				pid_ns_release_proc(pid_ns);
> >> +		}
> >> +
> >>  		/*
> >>  		 * wait for others to get what they want from this nsproxy.
> >>  		 *
> >
> > At first glance this looks correct. But the PF_EXITING check doesn't
> > look very nice imho. It is needed to detect the case when the caller
> > is copy_process()->bad_fork_cleanup_namespaces and p is not current.
>
> Mike's proposed change to switch_task_namespace is most definitely not
> correct.  This will potentially get called on unshare

Yes, but please note that this change also checks "new == NULL", so I
still think the patch is correct.

But,

> > 	 bad_fork_cleanup_namespaces:
> > 	+	if (unlikely(clone_flags & CLONE_NEWPID))
> > 	+		pid_ns_release_proc(...);
> > 		exit_task_namespaces(p);
> > 		
> > 		
> > code into this error path in copy_process?
>
> For now Oleg your minimal patch looks good.

Good.

Mike, could you please re-send the patch to akpm? Feel free to add my ack.
I guess Eric will ack this fix too.

> Part of me would like to call proc_flush_task instead,

Yes, I thought about this too, it checks upid->nr == 1. But

> pid_ns_release_proc but we have no assurance task_pid and task_tgid are
> valid when we get here so proc_flush_task is out.

Yes.

> There are crazy code paths like daemonize()

Forget. It has no callers anymore, should be killed. A user-space process
should never use kernel_thread() and thus daemonize() is not needed.

Oleg.

