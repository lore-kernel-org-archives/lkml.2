Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1BBF5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1BBF5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:57:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from
 ptrace_stop() iff the task is trapping for group stop
In-Reply-To: Tejun Heo's message of  Monday, 31 January 2011 12:26:34 +0100 <20110131112634.GG7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-9-git-send-email-tj@kernel.org>
	<20110128213009.340C7183C1E@magilla.sf.frob.com>
	<20110131112634.GG7459@htj.dyndns.org>
X-Windows: you'll envy the dead.
Message-Id: <20110202055711.368B6183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:57:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I do have some other ideas.  When a ptraced task gets a stop
> signal, its delivery is controlled by the tracer, right?  So, right
> from the beginning, group stop having consistent precedence over
> ptrace breaks.

I would not agree with that way of describing it.  The tracer controls
what signals actually get delivered.  A group stop doesn't begin until
a stop signal is actually delivered (or a core dump is started).  What
I'm talking about when I say that group stop should have precedence is
that once a group stop is initiated by one thread, then it should
happen fully and immediately to all threads.  When a tracer intercepts
a signal and does not specify it for delivery, then no signal is
delivered and so no thread initiates a group stop at all.  That's an
entirely different kettle of fish.

> As long as the interaction is consistent and well defined, I don't
> really think it matters one way or the other but given the above
> precedence and the current ptracers' expectations, I can't see how we
> would be able to prioritize group stop over ptrace at this point.

I don't follow this logic at all.  Perhaps it is predicated on the
wrong idea of what "initiating a group stop" means, and you would not
say this given my paragraph above.  If you mean something different
than the misperception that a group stop exists at all before a signal
is truly delivered, then I don't understand what you mean.

> The problem is that those loose ends can't be tied up without breaking
> the current users.  PTRACE_CONT has priority over group stop and it's
> a very visible from userland.  I'm afraid the window of opportunity to
> make that behavior the default had already passed quite some time ago.

I am not convinced of that at all, though I certainly wouldn't say now
that it's a settled question yet.  The userland expectations are
pretty convoluted too.  I suspect that what you are calling the
userland expectations for PTRACE_CONT to ignore the state of a pending
group stop are in fact just fallout of userland confusion about what's
a job control stop and what's a ptrace stop.

> > If there is a group stop in progress but not yet complete, then
> > PTRACE_CONT on a thread in the group should probably just move it
> > from TASK_TRACED to TASK_STOPPED without resuming it at all.
> 
> I really don't think that's an option at this point and can't see how
> such behavior could be made consistent given ptracer has inherent
> superiority over signal delivery.  That would make initiation of group
> stop controllerd by ptracer but participation not.  The behavior
> becomes essentially indeterministic depending on which task in the
> group gets the signal.  :-(

I don't think I follow your logic and I certainly don't agree with
your conclusion.  It's simple: if a stop signal is actually delivered,
then every thread stops.  If one thread is traced and another is not,
then the tracer can prevent a signal from being delivered to one
thread and cannot prevent it from being delivered to another.

> > Once a group stop is complete, then probably the ideal is that
> > PTRACE_CONT would not resume a thread until a real SIGCONT cleared
> > the job control stop condition.  But it's likely that existing
> > ptrace users have expectations contrary to that, so we'll have to
> > see.
> 
> So, no, I don't think that would be possible or even desirable.

Of course it's possible.  We have to work out the entire web of
assumptions and ramifications to be sure what's desireable given
practical compatibility constraints.  I think it's just plain obvious
that it's the desireable thing in the abstract--that tracing stops and
job control stops should be independent functions.


Thanks,
Roland
