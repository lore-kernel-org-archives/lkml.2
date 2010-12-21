Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0LURnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:43:33 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42636 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0LURnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZHcwzVXevQu4Pf60oknBDxOrFpD4ewYFLuXirjTrgkfpzjxPhpRbM/y3aHtTpPb8kz
         tc9wRqT5ooQ68Zl8eJBe64vy6i7V/27RXrUVFBxy45ep9Gpei6a1vWVTmOANzcru5hjl
         yi4++wQpzRtObtuT+Dn+OQ+lvQpzDurHjdzts=
Date: Tue, 21 Dec 2010 18:43:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 12/16] ptrace: make group stop notification reliable
 against ptrace
Message-ID: <20101221174319.GH13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-13-git-send-email-tj@kernel.org>
 <20101220173425.GA18070@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220173425.GA18070@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 06:34:25PM +0100, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
> >
> > This patch adds a new signal flag SIGNAL_NOTIFY_STOP which is set on
> > group stop completion and cleared on notification to the real parent
> > or together with other stopped flags on SIGCONT/KILL.  This guarantees
> > that the real parent is notified correctly regardless of ptrace.
> 
> OK, I am a bit confused. I do not understand exactly what this
> "correctly" actually means.

It means that the ptracer wouldn't eat the notification.  The
notification is buffered and delivered when ptrace detaches.

> > If a ptraced task is the last task to stop, the notification is
> > postponed till ptrace detach or canceled if SIGCONT/KILL is
> > received inbetween.
> 
> OK. But what if the last task to stop is not ptraced? In this case
> ->real_parent gets the notification.
> 
> Of course, the current behaviour is not better, it is obviously wrong.
> But if we want to fix things, perhaps we should invite the new and
> clear rules. Isn't it better to always notify ->real_parent when the
> last thread stops in STOPPED/TRACED state? Otherwise the behaviour is
> not predictable, it depends on task_ptrace() state of the last thead
> which sees SIGNAL_NOTIFY_STOP.

I see.  My focus was to make ptrace attach/detach transparent.  IOW,
minimizing the effect of a debugger (or gcore or whatever) attaching
and then leaving.  So, this patch just makes sure that the
notification isn't absorbed by a ptracer.

> Actually, I think it would be even better to never notify ->real_parent
> until debugger detaches all threads, but this is not simple to implement.

But, yes, this is gonna change the behavior in subtle ways anyway so
it would be better to take care of that too.

> > @@ -1901,21 +1925,12 @@ retry:
> >  	__set_current_state(TASK_STOPPED);
> >
> >  	if (likely(!task_ptrace(current))) {
> > -		int notify = 0;
> > -
> > -		/*
> > -		 * If there are no other threads in the group, or if there
> > -		 * is a group stop in progress and we are the last to stop,
> > -		 * report to the parent.
> > -		 */
> > -		if (task_participate_group_stop(current))
> > -			notify = CLD_STOPPED;
> > -
> > +		task_participate_group_stop(current);
> >  		spin_unlock_irq(&current->sighand->siglock);
> >
> > -		if (notify) {
> > +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
> >  			read_lock(&tasklist_lock);
> > -			do_notify_parent_cldstop(current, notify);
> > +			do_notify_parent_cldstop(current, CLD_STOPPED);
> 
> Suppose that debugger attaches right after spin_unlock(->siglock).
> 
> Nothing really bad can happen afaics, but in this case the debugger
> will be notified twice. Hmm. If the debugger does do_wait() immediately
> after the first notification, it has all rights to see the stopped
> tracee but wait_task_stopped() fails, not good.

Hmmm?  ptrace_attach() can't happen while tasklist_lock is held.

Thanks.

-- 
tejun
