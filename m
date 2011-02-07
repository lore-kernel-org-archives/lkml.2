Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1BGPpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:45:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1BGPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:45:41 -0500
Date: Mon, 7 Feb 2011 16:37:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110207153723.GA27997@redhat.com>
References: <20110203204154.GB26371@redhat.com> <20110203213640.1F516180995@magilla.sf.frob.com> <20110203214450.GA29496@redhat.com> <20110204105343.GA12133@htj.dyndns.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <20110204170602.GB15301@redhat.com> <20110205133926.GM12133@htj.dyndns.org> <20110207134235.GB22538@redhat.com> <20110207141135.GA16992@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207141135.GA16992@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Mon, Feb 07, 2011 at 02:42:35PM +0100, Oleg Nesterov wrote:
> > > That's the shortcomings of the current implementation.  The specific
> > > problem sure can be fixed by putting group stop on top of ptrace but
> > > that is not the only direction.  In fact, that actually is the
> > > direction we CAN'T take with ptrace because changing that will create
> > > a lot more problems that can't be worked around.
> >
> > Which problems?
>
> I was talking about prioritizing group stop over ptrace in general.
> Please see the following messages.
>
>  http://article.gmane.org/gmane.linux.kernel/1095119
>  http://article.gmane.org/gmane.linux.kernel/1095603

Yes, I tried to read this... But I have to admit I can hardly understand
your discussion with Roland. More precisely, I don't understand what
exactly you have in mind.

One (may be off-topic) note,

	On 01/31, Tejun Heo wrote:
	>
	> On Fri, Jan 28, 2011 at 01:30:09PM -0800, Roland McGrath wrote:
	> > > A visible behavior change is increased likelihood of delayed group
	> > > stop completion if the thread group contains one or more ptraced
	> > > tasks.
	> >
	> > I object to that difference in behavior.  As I've said before, I don't
	> > think there should be any option to circumvent a group stop via ptrace.
	> > If you think otherwise, you have a hard road to convince me of it.

I agree with Roland here.

	> Yes, I do have some other ideas.  When a ptraced task gets a stop
	> signal, its delivery is controlled by the tracer, right?

Right, but note that the tracer does not fully control the group-stop.
One a thread dequeues SIGSTOP (and please note this thread can be !traced),
all other threads (traced or not) should participate.

As for SIGCONT priority, see below.

> Notifying the parent w/o making group stop superior to ptrace sure is
> a possibility.

Could you please reiterate? I think I missed something before, and
now I do not really understand what do you mean.

> > > For example, the problem in this thread is cleanly solved by
> > > really examining the problem and fixing the problem at the source (the
> > > mixup of group and ptrace stop)
> >
> > Yes, but I am worried that this change (in its current form) makes
> > impossible to create a TASK_STOPPED tracee, but you already know this.
>
> Why is that a problem?

See above. Because I think ptrace should not "hide" jctl stops (at
least by default), and SIGCONT should work in this case.

> A ptraced task stops in TASK_TRACED.

Unless it reacts to SIGSTOP/group_stop_count.

> > OK. But what I can't understand is why the alternative change is
> > not better. Once again:
> >
> > 	- the stopping thread always notifies the debugger
> >
> > 	- the last thread notifies both: debugger and real_parent
> >
> > 	- do_wait() is modified so that WSTOPPED always works
> > 	  for real_parent, even if its child is ptraced.
>
> I think the disconnection comes from the scope of the problem.  If we
> restrict our attention to group stop notification.

Of course, we shouldn't restrict.

> I agree that what
> you're describing seems like a good compromise.  What I was objecting
> to was putting group stop mechanism in general on top of ptrace.  I
> can't see how that would work.

And I still can't understand why this can't work ;)

And I don't really understand "putting group stop mechanism in general
on top of ptrace". It is very possible I am wrong, but I see this from
the different angle: stop/ptrace should be "parallel".

> Also, for a ptraced task, what would you consider to be participating
> in a group stop?

Yes, this is the question.

> I think it should only include the case where the
> tracee actually stops for group stop excluding all other trapping
> points.

I was thinking about this too and probably this makes sense. But
I think at least initial changes should keep the current behaviour
(assuming this behaviour is fixed).

> But, I don't think this really changes the need for state tracking.
> We would still have to put the tracee into approriate mode on detach.

Sure, but we already have SIGNAL_STOP_STOPPED/group_signal_stop. I meant,
we do not need to remember the state per-thread.


As for SIGCONT. Roland suggests (roughly) to change ptrace_resume()
so that it doesn't wakeup the stopped tracee until the real SIGCONT
comes. And this makes sense to me.

	On 02/03, Tejun Heo wrote:
	>
	> I've been thinking about this and the more I think about it I don't
	> see how we can make this priority flipping without adversely affecting
	> the expect userland behavior.
	>
	> For example, if a gdb traced task is instructed to participate in a
	> group stop and then hits a ptrace trap, it would have to participate
	> in the group stop as it enters ptrace trap, right?  gdb's wait(2)
	> would complete indicating ptrace trap.  After the user tells the task
	> to continue, the task shouldn't resume until SIGCONT is received;

Yes. But to me, this looks correct! The tracee shouldn't resume exactly
because it is stopped.

	> however, at this point, there's no way for gdb to tell what's going on
	> with the tracee.

Yes. I think this should be improved somehow, currently gdb can only
look in /proc/tid/status to detect this case.

	> If ptrace behaved like that from the beginning, gdb would have behaved
	> differently and worked around those cases but that hasn't been the
	> case

Cough... I thought we agreed it is better to break some corner cases
but make ptrace more consistent ;)

But yes, I see your point. And while I think that Roland's suggestion is
fine, I also have another proposal

	- never send CLD_CONTINUED to the tracer, always send it to parent.

	  Firstly, this is completely pointless: ptrace is per-thread, while
	  this notification is per-process

	- change do_wait() so that WCONTINUED for real_parent

	- change ptrace_resume() to check SIGNAL_STOP_STOPPED case. It should
	  act as SIGCONT in this case. Yes: "act as SIGCONT" needs more
	  discussion.

Oleg.

