Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1BGOLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:11:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1BGOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fP7vr/bv8t760AUDg06TtoAPUoEDZDuSWDv42yT/bLA9tQ00N7ofdzimN9cbA2mevz
         3/5keqofNxzrUXMoBNQkB79z+Y7YnFtkuIKgj/VFDnwH3aFaCf2OHR54sYMrp2YlSvp4
         xFr+UhktJAvdQfTpmLR9PYbxnhFUJjzhlOXWY=
Date: Mon, 7 Feb 2011 15:11:35 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110207141135.GA16992@htj.dyndns.org>
References: <20110203204122.GA26371@redhat.com>
 <20110203204154.GB26371@redhat.com>
 <20110203213640.1F516180995@magilla.sf.frob.com>
 <20110203214450.GA29496@redhat.com>
 <20110204105343.GA12133@htj.dyndns.org>
 <20110204130455.GA3671@redhat.com>
 <20110204144858.GI12133@htj.dyndns.org>
 <20110204170602.GB15301@redhat.com>
 <20110205133926.GM12133@htj.dyndns.org>
 <20110207134235.GB22538@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207134235.GB22538@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Feb 07, 2011 at 02:42:35PM +0100, Oleg Nesterov wrote:
> > That's the shortcomings of the current implementation.  The specific
> > problem sure can be fixed by putting group stop on top of ptrace but
> > that is not the only direction.  In fact, that actually is the
> > direction we CAN'T take with ptrace because changing that will create
> > a lot more problems that can't be worked around.
> 
> Which problems?

I was talking about prioritizing group stop over ptrace in general.
Please see the following messages.

 http://article.gmane.org/gmane.linux.kernel/1095119
 http://article.gmane.org/gmane.linux.kernel/1095603

Notifying the parent w/o making group stop superior to ptrace sure is
a possibility.

> > This way, the existing users behave the same way
> 
> Wait. The current behaviour is just broken. This is bad. But, at the
> same time, this is good: it gives us more rights to introduce the
> user-visible changes once we decide what exactly we want.
> 
> Firstly, the current behaviour is unpredictable. Suppose that we have
> two threads, T1 and T2. Only one thread is ptraced. Now, real_parent
> will be notified or not, depending on which thread calls do_signal_stop()
> last. I see no point to preserve this randomness. And note that
> real_parent can be notified anyway.
> 
> Otoh, I don't really understand why should we delay the notification
> to real_parent until detach in the simplest case (with your patches)
> by default.

Yeah, agreed regarding the notification.

> > For example, the problem in this thread is cleanly solved by
> > really examining the problem and fixing the problem at the source (the
> > mixup of group and ptrace stop)
> 
> Yes, but I am worried that this change (in its current form) makes
> impossible to create a TASK_STOPPED tracee, but you already know this.

Why is that a problem?  A ptraced task stops in TASK_TRACED.  It
should for a number of different reasons.  We can augment the group
stop notification if desirable.

> OK. But what I can't understand is why the alternative change is
> not better. Once again:
> 
> 	- the stopping thread always notifies the debugger
> 
> 	- the last thread notifies both: debugger and real_parent
> 
> 	- do_wait() is modified so that WSTOPPED always works
> 	  for real_parent, even if its child is ptraced.

I think the disconnection comes from the scope of the problem.  If we
restrict our attention to group stop notification.  I agree that what
you're describing seems like a good compromise.  What I was objecting
to was putting group stop mechanism in general on top of ptrace.  I
can't see how that would work.

Also, for a ptraced task, what would you consider to be participating
in a group stop?  I think it should only include the case where the
tracee actually stops for group stop excluding all other trapping
points.  That way ptracer also can tell that the tracee has stopped
for group stop and participated in group stop completion/notification.

But, I don't think this really changes the need for state tracking.
We would still have to put the tracee into approriate mode on detach.

Thanks.

-- 
tejun
