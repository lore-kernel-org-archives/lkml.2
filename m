Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1IKSSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 14:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1IKSSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 14:18:02 -0400
Date: Sun, 11 Sep 2011 20:14:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in
	'data' parameter
Message-ID: <20110911181442.GA22239@redhat.com>
References: <201109072340.31460.vda.linux@googlemail.com> <20110908004438.GC3987@mtj.dyndns.org> <20110908181747.GA28120@redhat.com> <20110911020523.GL29319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911020523.GL29319@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/11, Tejun Heo wrote:
>
> On Thu, Sep 08, 2011 at 08:17:47PM +0200, Oleg Nesterov wrote:
> > > There are places which assume ->ptrace is protected by siglock.
> >
> > Really? Once again, I agree. But _afaics_ currently this is not strictly
> > needed. PT_PTRACED/PT_SEIZED should not go away under ->siglock, yes, but
> > it seems that it is fine to set them.
>
> Hmmm.... I haven't checked each direction.  Maybe we don't strictly
> need it on setting it but I definitely was assuming that ->ptrace was
> protected by siglock while coding recent ptrace changes.  Can't the
> following happen?
>
> * ptracer seizes child, sets PT_PTRACED and then OR PT_SEIZED.
>
> * ptracee enters signal delivery path with group stop scheduled.
>   PT_PTRACED is visible and group stop is transformed into
>   JOBCTL_TRAP_STOP.
>
> * ptracee enters do_jobct_trap().  PT_SEIZED is still not visible and
>   it takes the path for the old behavior.
>
> * ptracer SEIZE'd and expects PTRACE_EVENT_STOP but it gets the old
>   no-siginfo trap.

Heh ;) Please look at http://marc.info/?l=linux-kernel&m=131541614232539

	> @@ -263,7 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
	>  	if (task->ptrace)
	>  		goto unlock_tasklist;
	>
	> -	task->ptrace = PT_PTRACED;
	> +	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
	>  	if (seize)
	>  		task->ptrace |= PT_SEIZED;

	Hmm. Tejun, Denys, this doesn't look exactly right.

	I already thought about this before, but somehow I convinced myself
	this is fine.

	I think we should set both PT_PTRACED | PT_SEIZED "atomically", at
	once. Otherwise, say, the tracee can do do_jobctl_trap() in between,
	no? Nothing really bad can happen, but we shouldn't lose EVENT_STOP
	code.

Yes, we need to set them both at once.

And yes, I agree, it is better to do this under ->siglock even if currently
this is not strictly necessary.

> > > and linking are protected by siglock
> >
> > Hmm. Could you explain this? Why do want __ptrace_link under ->siglock ?
>
> Because it's much simpler to assume that w/ siglock locked, everything
> including ->parent is set up properly w.r.t. ->ptrace.

Well, but then we shouldn't rely on tracee's ->siglock. The tracee simply
do not care about its ->ptrace_entry, only the tracer does.

We need to rework the locking, yes. But we need the lock which protects
the parent's list_head (currently we rely on tasklist). Yes, a single
lock can't help. We already use ->cred_guard_mutex though.

This needs more thinking, but imho child->siglock is pointless here.

Oleg.

