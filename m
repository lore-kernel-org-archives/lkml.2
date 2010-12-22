Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0LVMCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:02:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab0LVMB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:01:59 -0500
Date: Wed, 22 Dec 2010 12:54:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 12/16] ptrace: make group stop notification reliable
	against ptrace
Message-ID: <20101222115409.GB30266@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-13-git-send-email-tj@kernel.org> <20101220173425.GA18070@redhat.com> <20101221174319.GH13285@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221174319.GH13285@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Tejun Heo wrote:
>
> On Mon, Dec 20, 2010 at 06:34:25PM +0100, Oleg Nesterov wrote:
> > On 12/06, Tejun Heo wrote:
> > >
> > > This patch adds a new signal flag SIGNAL_NOTIFY_STOP which is set on
> > > group stop completion and cleared on notification to the real parent
> > > or together with other stopped flags on SIGCONT/KILL.  This guarantees
> > > that the real parent is notified correctly regardless of ptrace.
> >
> > OK, I am a bit confused. I do not understand exactly what this
> > "correctly" actually means.
>
> It means that the ptracer wouldn't eat the notification.  The
> notification is buffered and delivered when ptrace detaches.

Yes, I understand. I am a bit worried it is not easy to describe the
new behaviour exactly.

> I see.  My focus was to make ptrace attach/detach transparent.  IOW,
> minimizing the effect of a debugger (or gcore or whatever) attaching
> and then leaving.  So, this patch just makes sure that the
> notification isn't absorbed by a ptracer.

Agreed. And the code itself certainly becomes correct/consistent,
contrary to "everything is broken" we currently have.


Tejun, I'll try to summarize my (very foggy) concerns in a separate
email. Don't get me wrong, I think this series rightly addresses the
numerous problems we have. My only question is, can't we go a bit
further and create the new (and simple) rules. Probably not.

> > > @@ -1901,21 +1925,12 @@ retry:
> > >  	__set_current_state(TASK_STOPPED);
> > >
> > >  	if (likely(!task_ptrace(current))) {
> > > -		int notify = 0;
> > > -
> > > -		/*
> > > -		 * If there are no other threads in the group, or if there
> > > -		 * is a group stop in progress and we are the last to stop,
> > > -		 * report to the parent.
> > > -		 */
> > > -		if (task_participate_group_stop(current))
> > > -			notify = CLD_STOPPED;
> > > -
> > > +		task_participate_group_stop(current);
> > >  		spin_unlock_irq(&current->sighand->siglock);
> > >
> > > -		if (notify) {
> > > +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
> > >  			read_lock(&tasklist_lock);
> > > -			do_notify_parent_cldstop(current, notify);
> > > +			do_notify_parent_cldstop(current, CLD_STOPPED);
> >
> > Suppose that debugger attaches right after spin_unlock(->siglock).
> >
> > Nothing really bad can happen afaics, but in this case the debugger
> > will be notified twice. Hmm. If the debugger does do_wait() immediately
> > after the first notification, it has all rights to see the stopped
> > tracee but wait_task_stopped() fails, not good.
>
> Hmmm?  ptrace_attach() can't happen while tasklist_lock is held.

Sure, but is is not held after we drop ->siglock. And ptrace_attach() can
happen in the window before we take it for do_notify_parent_cldstop().

Oleg.

