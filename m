Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab1BIVeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:34:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab1BIVeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:34:00 -0500
Date: Wed, 9 Feb 2011 22:25:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110209212526.GA9999@redhat.com>
References: <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <20110204170602.GB15301@redhat.com> <20110205133926.GM12133@htj.dyndns.org> <20110207134235.GB22538@redhat.com> <20110207141135.GA16992@htj.dyndns.org> <20110207153723.GA27997@redhat.com> <20110207163121.GB16992@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209141803.GH3770@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Tejun Heo wrote:
>
> We can make it behave like the following.  { | } denotes two
> alternative behaviors regarding SIGCONT.
>
>   If a group stop is initiated while, or was in progress when a task
>   is ptraced, the task will stop for group stop and notify the ptracer
>   accordingly.  Note that the task could be trapped elsewhere delaying
>   this from happening.  When the task stops for group stop, it
>   participates in group stop as if it is not ptraced and the real
>   parent is notified of group stop completion.

OK,

>   Note that { the task is put into TASK_TRACED state and group stop
>   resume by SIGCONT is ignored. | the task is put into TASK_STOPPED
>   state and the following PTRACE request will transition it into
>   TASK_TRACED.  If SIGCONT is received before transition to
>   TASK_TRACED is made, the task will resume execution.  If PTRACE
>   request faces with SIGCONT, PTRACE request may fail. }

To me, the first variant looks better. But, only because it is closer
to the current behaviour. I mean, it is better to change the things
incrementally.

But in the longer term - I do not know. Personally, I like the
TASK_STOPPED variant. To the point, I was thinking that (perhaps)
we can change ptrace_stop() so that it simply calls do_signal_stop()
if it notices ->group_stop_count != 0.

>   The ptracer may resume execution of the task using PTRACE_CONT
>   without affecting other tasks in the group.

And this is what I do not like. I just can't accept the fact there
is a running thread in the SIGNAL_STOP_STOPPED group.

But yes: this is what the current code does, I am not sure we can
change this, and both PTRACE_CONT-doesnt-resume-until-SIGCONT and
PTRACE_CONT-acts-as-SIGCONT are not "perfect" too.

>   On ptrace detach, if group stop is in effect, the task will be put
>   into TASK_STOPPED state and if it is the first time the task is
>   stopping for the current group stop, it will participate in group
>   stop completion.

Yes. (but depends on above).

> This can be phrased better but it seems well defined enough for me.  I
> take it that one of your concerns is direct transition into
> TASK_TRACED on group stop while ptraced which prevents the tracee from
> reacting to the following SIGCONT.

Yes,

> I'm not sure how much of an actual
> problem it is given that our notification to real parent hasn't worked
> at all till now

Yes! and this is very good argument in favour of all your objections ;)

Yes, this doesn't work anyway. But I _think_ this is the bug, if
we are going to change this code we should fix this bug as well.

Again, again, this is very subjective, I agree.

> but we can definitely implement proper TASK_STOPPED ->
> TRACED transition on the next PTRACE request.

I guess, you mean that the current code bypasses the
ptrace_stop()->arch_ptrace_stop_needed() code while doing s/STOPPED/TRACED ?

Oh, currently I am ignoring this, my only concern is how this all
looks to the userland. But this is the good point, and I have to admit
that I never realized this is just wrong. Yes, I agree, we should do
something, but this is not visible to user-space (except this should
fix the bug ;)

> There exists a
> fundamental race condition between SIGCONT and the next PTRACE call

Yes, and this race is already here, ptracer should take care.

> If we don't go that route, another solution would be to add a ptrace
> call which can listen to SIGCONT.  ie. PTRACE_WAIT_CONT or whatever
> which the ptracer can call once it knows the tracee entered group
> stop.

Perhaps... Or something else, but surely there is a room for improvements.
Fortunately, the changes like this are "safe". I mean, they can
break nothing. Just we should try to not make them wrong ;)

> In either case, the fundamentals of ptrace operation don't really
> change.  All ptrace operations are still per-task and ptracer almost
> always has control over execution of the tracee.  Sure, it allows
> ptraced task to escape group stop but it seems defined clear enough
> and IMHO actually is a helpful debugging feature.

Heh, I think we found the place where we can't convince each other.
What if we toss a coin?

> After all, it's not
> like stop signals can be used for absoultely reliable job control.
> There's an inherent race against SIGCONT.

Sure, if we are talking about SIGCONT from "nowhere". But, the same
way ^Z is not reliable too.

> > > What do you do about PTRACE requests while a task is group stopped?
> > > Reject them?  Block them?
> >
> > Yes, another known oddity. Of course we shouldn't reject or block.
> > Perhaps we can ignore this initially. If SIGCONT comes after another
> > request does STOPPED/TRACED it clears SIGNAL_STOP_STOPPED, but the
> > tracee won't run until the next PTRACE_CONT, this makes sense.
>
> That conceptually might make sense

I only meant, this makes sense initially.

> but other than the conceptual
> integrity it widely changes the assumptions and is less useful than
> the current behavior.

Hmm, this is what we currently have?

> I don't really see why we would want to do
> that.

No, I think we do not really want this in the longer term. But I
can't say what exactly we want.

> > Only if it attaches to every thread in the thread group. Otherwise,
> > if the non-thread has already initiated the group-stop, the tracee
> > will notice TIF_SIGPENDING eventually and call do_signal_stop(),
> > debugger can't control this.
>
> The debugger is still notified and can override it.

Hmm... no, it can't? Of course it is notified after the tracee
participates and calls do_signal_stop() and gdb can resume it then.
But it can't prevent the tracee from stopping.

> > > I don't think it's an extreme corner case
> > > we can break.  For example, if a user gdb's a program which raises one
> > > of the stop signals, currently the user expects to be able to continue
> > > the program from whithin the gdb.  If we make group stop override
> > > ptrace, there's no other recourse than sending signal from outside.
> >
> > Yes. Of course, gdb can be "fixed", it can send SIGCONT.
> >
> > But yes, this is the noticeable change, that is why I suggested
> > ptrace_resume-acts-as-SIGCONT logic. Ugly, yes, but more or less
> > compatible. (although let me repeat, _pesonally_ I'd prefer to
> > simply tell user-space to learn the new rules ;)
>
> I can't really agree there.  First, to me, it seems like too radical a
> change

(I assume you mean PTRACE_CONT-doesnt-resume variant?)

> and secondly the resulting behavior might look conceptually
> pleasing but is not as useful as the current one.  Why make a change
> which results in reduced usefulness while noticeably breaking existing
> users?

I don't really agree with "not as useful", but this doesn't matter.
I agree with "noticeably breaking", this is enough. (assuming my
guess above is correct).

> > Given that SIGCHLD doesn't queue and with or without your changes
> > we send it per-thread, it is not trivial for gdb to detect the
> > group-stop anyway. Again, the kernel should help somehow.
>
> Hmmm?  Isn't this discoverable from the exit code from wait?

Sure. Probably I misunderstood. I thought, you mean we need something
like per-process "the whole group is stopped" notification for the
debugger.

> > > and I'm not really sure whether that's something worth achieving
> > > at the cost of debugging capabilities especially when we don't _have_
> > > to lose them.
> >
> > But we do not? I mean, at least this is not worse than the current
> > behaviour.
>
> I think it's worse.  With your changes, debuggers can't diddle the
> tasks behind group stop's back which the current users already expect.

OK, I certainly misunderstood you, and now I can't restore the context.
Could you spell?

> > > I agree it adds more integrity to group stop but at the cost of
> > > debugging capabilities.  I'm not yet convinced integrity of group stop
> > > is that important.  Why is it such a big deal?
> >
> > Of course I can't "prove" it is that important. But I think so.
>
> Heh, I'm not asking for proof that it is more useful. :-) But I'm still
> curious why you think it's important because the benefits aren't
> apparent to me.  Roland and you seem to share this opinion without
> much dicussion so maybe I'm missing something?

I can't!

I hate this from the time when I noticed that the application doesn't
respond to ^Z under strace. And I used strace exactly because I wanted
do debug some (I can't recall exactly) problems with jctl. That is all.

But in any case. Some users run the services under ptrace. I mean,
the application borns/runs/dies under ptrace. That is why personally
I certainly do not like anything which delays until detach (say,
the-tracee-doesnt-participate-in-group-stop-until-detach logic).

> > > CLD_STOPPED is too but while ptrace is attached the notifications are
> > > made per-task and delivered to the tracer.
> >
> > No, there is a difference. Sure, CLD_STOPPED is per-process without
> > ptrace. But CLD_CONTINUED continues to be per-process even if all
> > threads are traced.
>
> Hmm... I need to think more about it.  I'm not fully following your
> point.

This is simple. No matter how many threads we have, no matter how
many of them are ptraced, we send a single CLD_CONTINUED notification.
The only difference ptrace can make is: we look at ->group_leader
to decide who will get this notification.

> > > I think this is the key question.  Whether to de-throne
> > > PTRACE_CONT such that it cannot override group stop.  As I've already
> > > said several times already, I think it is a pretty fundamental
> > > property of ptrace
> >
> > Again, I am a bit confused. Note that PTRACE_CONT overrides
> > group stop if we do the above. It should wake up the tracee, in
> > SIGCONT-compatible way (yes, the latter is not exactly clear).
>
> What do you mean?  Waking up in SIGCONT-compatible way?  Sending
> SIGCONT ending the whole group stop?

Yes. I do not mean we should literally do send_sig_info(SIGCONT)
of course.

> > But at least this should be visible to real parent. We shouldn't
> > silently make the stopped tracee running while its real_parent
> > thinks everything is stopped.
>
> I think maybe this is where our different POVs come from.

Yes, probably.

> To me, it
> isn't too objectionable to allow debuggers to diddle with tracees
> behind the real parent's back.  In fact, it would be quite useful when
> debugging job control related behaviors.  I wouldn't have much problem
> accepting the other way around - ie. strict job control even while
> being debugged, but given that it is already allowed and visible, I
> fail to see why we should change the behavior.  It doesn't seem to
> have enough benefits to warrant such visible change.

All I can say is: sure, I see your point, and perhaps you are right
and I am wrong.

I'd really like to force CC list to participate ;)

> If I change the patchset such that group stop while ptraced first
> enters TASK_STOPPED and then transitions into TASK_TRACED on the next
> PTRACE call,

Again, I am not sure I understand what exactly you mean... If you
mean that it is wrong to simply change the state of the tracee in
ptrace_check_attach() without arch_ptrace_stop() - I agree, this
probably should be fixed.

I am wondering, if there is a simpler change... probably not.

But. this looks a bit off-topic (I mean, this looks orthogonal
to the other things we are discussing), or I missed something else?

> there will be race window which would be visible

Personally, I think this is fine.

Oleg.

