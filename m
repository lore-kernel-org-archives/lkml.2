Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0LVP0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:26:32 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:64359 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0LVP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:26:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TckiZl5JoeTuDuuTCxhIE59z3BmFw63GZVEM74CDuUtReEBX0Dkpa7/gpouNLexaIB
         MWHMoxc8rspxiIbhZXTtvQ6tBoA+vHMiN/K4maAzja1azcJ7mMDV5xpf5ps4a/4hLZKQ
         e+XTUcnhQrPm53gQTVi+8k0D7Ess4W50+vp10=
Date: Wed, 22 Dec 2010 16:26:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 12/16] ptrace: make group stop notification reliable
 against ptrace
Message-ID: <20101222152621.GD8061@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-13-git-send-email-tj@kernel.org>
 <20101220173425.GA18070@redhat.com>
 <20101221174319.GH13285@htj.dyndns.org>
 <20101222115409.GB30266@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222115409.GB30266@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 22, 2010 at 12:54:09PM +0100, Oleg Nesterov wrote:
> On 12/21, Tejun Heo wrote:
> > I see.  My focus was to make ptrace attach/detach transparent.  IOW,
> > minimizing the effect of a debugger (or gcore or whatever) attaching
> > and then leaving.  So, this patch just makes sure that the
> > notification isn't absorbed by a ptracer.
> 
> Agreed. And the code itself certainly becomes correct/consistent,
> contrary to "everything is broken" we currently have.
> 
> Tejun, I'll try to summarize my (very foggy) concerns in a separate
> email. Don't get me wrong, I think this series rightly addresses the
> numerous problems we have. My only question is, can't we go a bit
> further and create the new (and simple) rules. Probably not.

Yeah, definitely, if we're gonna make some userland visible changes,
let's get it right once and for all (at least in terms of the intended
behaviors, that is).  It's sure gonna take more work but I think it'll
be manageable both in terms of the required effort and implementation
complexity.  Well, actually, in terms of the latter, I think we're
likely to improve the situation by making the rules and intentions
clear.

> > > > @@ -1901,21 +1925,12 @@ retry:
> > > >  	__set_current_state(TASK_STOPPED);
> > > >
> > > >  	if (likely(!task_ptrace(current))) {
> > > > -		int notify = 0;
> > > > -
> > > > -		/*
> > > > -		 * If there are no other threads in the group, or if there
> > > > -		 * is a group stop in progress and we are the last to stop,
> > > > -		 * report to the parent.
> > > > -		 */
> > > > -		if (task_participate_group_stop(current))
> > > > -			notify = CLD_STOPPED;
> > > > -
> > > > +		task_participate_group_stop(current);
> > > >  		spin_unlock_irq(&current->sighand->siglock);
> > > >
> > > > -		if (notify) {
> > > > +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
> > > >  			read_lock(&tasklist_lock);
> > > > -			do_notify_parent_cldstop(current, notify);
> > > > +			do_notify_parent_cldstop(current, CLD_STOPPED);
> > >
> > > Suppose that debugger attaches right after spin_unlock(->siglock).
> > >
> > > Nothing really bad can happen afaics, but in this case the debugger
> > > will be notified twice. Hmm. If the debugger does do_wait() immediately
> > > after the first notification, it has all rights to see the stopped
> > > tracee but wait_task_stopped() fails, not good.
> >
> > Hmmm?  ptrace_attach() can't happen while tasklist_lock is held.
> 
> Sure, but is is not held after we drop ->siglock. And ptrace_attach() can
> happen in the window before we take it for do_notify_parent_cldstop().

I thought the code snippet was from inside do_notify_parent_cldstop()
for some reason.  Okay, so the debugger can attach there
and... hmmm... right.  Yeah, the debugger gets the extra notification.
I don't think the previous code fared any better tho.  Anyways, I'll
think about how to fix this.

Thanks.

-- 
tejun
