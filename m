Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1BGNuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:50:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1BGNug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:50:36 -0500
Date: Mon, 7 Feb 2011 14:42:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110207134235.GB22538@redhat.com>
References: <1296227324-25295-11-git-send-email-tj@kernel.org> <20110203204122.GA26371@redhat.com> <20110203204154.GB26371@redhat.com> <20110203213640.1F516180995@magilla.sf.frob.com> <20110203214450.GA29496@redhat.com> <20110204105343.GA12133@htj.dyndns.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <20110204170602.GB15301@redhat.com> <20110205133926.GM12133@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205133926.GM12133@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Tejun Heo wrote:
>
> On Fri, Feb 04, 2011 at 06:06:02PM +0100, Oleg Nesterov wrote:
>
> > > We are already skipping all notifications to the real parent for
> > > ptraced children, there's no pressing need to change that.  If
> > > there becomes a real pressing requirement to change that.
> >
> > And this looks just wrong to me. Say, why the ptraced application
> > doesn't react to ^Z ? It does, just it parent have no chance to see
> > this. (yes, yes, we should also change do_wait).
>
> That's the shortcomings of the current implementation.  The specific
> problem sure can be fixed by putting group stop on top of ptrace but
> that is not the only direction.  In fact, that actually is the
> direction we CAN'T take with ptrace because changing that will create
> a lot more problems that can't be worked around.

Which problems?

> We can introduce something completely new but we can also augment the
> current implementation with what's necessary to remedy the problem.
> The ptracer is already notified when the ptracee enters group stop.
> There's nothing stopping us giving ptracer the ability to tell ptracee
> to participate in group stop completion and notify the real parent.
> It will be an extra feature, probably a new PTRACE_ operation.

Yes. But I still can't understand the point, please see below.

For the moment, please forget about CLD_CONTINUED. Forget that do_wait()
doesn't work for the real_parent, this is simple (afaics) to fix.

> This
> way, the existing users behave the same way

Wait. The current behaviour is just broken. This is bad. But, at the
same time, this is good: it gives us more rights to introduce the
user-visible changes once we decide what exactly we want.

Firstly, the current behaviour is unpredictable. Suppose that we have
two threads, T1 and T2. Only one thread is ptraced. Now, real_parent
will be notified or not, depending on which thread calls do_signal_stop()
last. I see no point to preserve this randomness. And note that
real_parent can be notified anyway.

Otoh, I don't really understand why should we delay the notification
to real_parent until detach in the simplest case (with your patches)
by default.

> while the ones which are
> updated to use the new feature would behave better w.r.t. group stop
> while being ptraced.

OK, perhaps the extra feature is fine since it gives more control,
but simplicity is the nice goal too. Especially if we are talking
about incremental changes.

> "oh, we'll have something completely new which cures
> everything at once, so let's reject changes to the current code as
> much as possible"

No, no, sorry, I didn't mean exactly this. At least I certainly didn't
mean we should not fix the bugs ;)

> For example, the problem in this thread is cleanly solved by
> really examining the problem and fixing the problem at the source (the
> mixup of group and ptrace stop)

Yes, but I am worried that this change (in its current form) makes
impossible to create a TASK_STOPPED tracee, but you already know this.

> So, let's stop chasing unicorns.  Cake is a lie.  Let's work on what
> we already have and incrementally improve it.

OK. But what I can't understand is why the alternative change is
not better. Once again:

	- the stopping thread always notifies the debugger

	- the last thread notifies both: debugger and real_parent

	- do_wait() is modified so that WSTOPPED always works
	  for real_parent, even if its child is ptraced.

(to remind, please ignore SIGCONT/ptrace_resume problems, and of
 course ptrace_stop() playing with group_stop_count should be fixed).

Roland, Tejun, seriously, could you explain why this is bad?

This is much simpler (including implementation) and straightforward.
Easy to understand. No need to remember the state of the tracee wrt
group-stop.

If we are going to add the new ptrace options, I'd rather prefer
to add PTRACE_O_DONT_NOTIFY_REAL_PARENT is we want to control this
behaviour.

What do you think?

Oleg.

