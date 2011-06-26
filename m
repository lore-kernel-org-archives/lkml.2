Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1FZUzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1FZUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:54:03 -0400
Date: Sun, 26 Jun 2011 22:51:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110626205157.GB16293@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com> <20110622210834.GC20549@redhat.com> <20110623122253.GM30101@htj.dyndns.org> <20110623132126.GA10410@redhat.com> <20110623132754.GO30101@htj.dyndns.org> <20110623132831.GA11453@redhat.com> <20110623170650.GA14601@redhat.com> <20110625141553.GX30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110625141553.GX30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Tejun Heo wrote:
>
> Hello,
>
> On Thu, Jun 23, 2011 at 07:06:50PM +0200, Oleg Nesterov wrote:
> > [PATCH v2 2/8] kill tracehook_notify_death()
> >
> > Kill tracehook_notify_death(), reimplement the logic in its caller,
> > exit_notify().
> >
> > Also, change the exec_id's check to use thread_group_leader() instead
> > of task_detached(), this is more clear. This logic only applies to
> > the exiting leader, a sub-thread must never change its exit_signal.
> >
> > Note: when the traced group leader exits the exit_signal-or-SIGCHLD
> > logic looks really strange:
> >
> > 	- we notify the tracer even if !thread_group_empty() but
> > 	   do_wait(WEXITED) can't work until all threads exit
>
> Yeap, we've discussed this before and this indeed is odd.  However, is
> there something ptracer can't do with PTRACE_EVENT_EXIT instead?

Firstly, I think PTRACE_EVENT_EXIT should not stop the tracee if it
was SIGKILL'ed. Even if the tracee stops, it can be killed later.
The tracer can't detach after that, it can't even wait() to detecte
a zombie leader.

> rather than trying to change the behavior.

Yes, perhaps we shouldn't (or can't) change this behaviour, I am not
sure. We will see.

> > 	- if the tracer is real_parent, it is not clear why can't
> > 	  we use ->exit_signal event if !thread_group_empty()
>
> I've been thinking a bit more about this and it doesn't seem that
> changing this is necessarily a good idea.

Yes, agreed. This doesn't buy us something really useful.

> The current behavior does
> make certain sense (overridden exit_signal is used only for the real
> parent when the process is being reaped)

Oh, but this is the traced task. I do not think this behaviour was
really designed, I can be wrong of course. For example, what "being
reaped" actually means? Say, the group leader can exit after all
other sub-threads have already exited, but thread_group_empty() == F
exactly because a sub-thread is traced and wasn't reaped yet.

To me, it would be more clean to do

	if (tsk->ptrace) {
		int sig = ptrace_reparented(tsk) ?
			SIGCHLD : tsk->group_leader->exit_signal;
		
	}

> and doesn't cause any actual
> problem, so I don't think we need to change this behavior.

Agreed.

> > +	if (unlikely(tsk->ptrace)) {
> > +		int sig = thread_group_leader(tsk) &&
> > +				thread_group_empty(tsk) &&
> > +				!ptrace_reparented(tsk) ?
> > +			tsk->exit_signal : SIGCHLD;
>
> Heh, I think this needs to be prettier even at the cost of an inline
> function.

May be, but the code is sooooo simple. In fact I thought about the helper,
but can't find a good name.

Anyway, this is so minor, unless you strongly object I am going to push
this patch as is. We can add a helper later although I don't think it is
needed.

The same logic could be written as

	if (thread_group_empty(tsk)) {
		int sig = ptrace_reparented(tsk) ?
			SIGCHLD : tsk->exit_signal;
		autoreap = do_notify_parent(tsk, sig);
	} else if (task->ptrace) {
		autoreap = do_notify_parent(tsk, SIGCHLD);
	} else {
		autoreap = !thread_group_leader();
	}

note that it certainly looks "prettier". However, personaly I strongly
prefer the non-pretty code above, imho it is more straighforward and
understandable. It is hardly possible to misread/misunderstand it.

Oleg.

