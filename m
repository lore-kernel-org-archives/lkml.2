Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1BGR4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:56:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab1BGR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:56:53 -0500
Date: Mon, 7 Feb 2011 18:48:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110207174821.GA1237@redhat.com>
References: <20110203214450.GA29496@redhat.com> <20110204105343.GA12133@htj.dyndns.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <20110204170602.GB15301@redhat.com> <20110205133926.GM12133@htj.dyndns.org> <20110207134235.GB22538@redhat.com> <20110207141135.GA16992@htj.dyndns.org> <20110207153723.GA27997@redhat.com> <20110207163121.GB16992@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207163121.GB16992@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07, Tejun Heo wrote:
>
> Hey, Oleg.
>
> On Mon, Feb 07, 2011 at 04:37:23PM +0100, Oleg Nesterov wrote:
> >
> > 	> Yes, I do have some other ideas.  When a ptraced task gets a stop
> > 	> signal, its delivery is controlled by the tracer, right?
> >
> > Right, but note that the tracer does not fully control the group-stop.
> > One a thread dequeues SIGSTOP (and please note this thread can be !traced),
> > all other threads (traced or not) should participate.
>
> I don't know.  Maybe it's more consistent that way and I'm not
> fundamentally against that but it is a big behavior change

Hmm. I tried to describe the current behaviour...

> > > Notifying the parent w/o making group stop superior to ptrace sure is
> > > a possibility.
> >
> > Could you please reiterate? I think I missed something before, and
> > now I do not really understand what do you mean.
>
> I was trying to say that it's still possible to deliver group stop
> notifications to the real parent while letting the ptracer override
> group stop with PTRACE_CONT.

Do you mean the current code? Yes, this is possible. And yes, this
doesn't look good. PTRACE_CONT should either notify the real parent
or do not resume the tracee.

> > > A ptraced task stops in TASK_TRACED.
> >
> > Unless it reacts to SIGSTOP/group_stop_count.
>
> What do you do about PTRACE requests while a task is group stopped?
> Reject them?  Block them?

Yes, another known oddity. Of course we shouldn't reject or block.
Perhaps we can ignore this initially. If SIGCONT comes after another
request does STOPPED/TRACED it clears SIGNAL_STOP_STOPPED, but the
tracee won't run until the next PTRACE_CONT, this makes sense.

The problem is, gdb can't leave the tracee in STOPPED state if it
wants. We need to improve this somehow (like in your previous example
with gdb).

> > > I agree that what
> > > you're describing seems like a good compromise.  What I was objecting
> > > to was putting group stop mechanism in general on top of ptrace.  I
> > > can't see how that would work.
> >
> > And I still can't understand why this can't work ;)
> >
> > And I don't really understand "putting group stop mechanism in general
> > on top of ptrace". It is very possible I am wrong, but I see this from
> > the different angle: stop/ptrace should be "parallel".
>
> Hmmm... currently ptrace overrides group stop and has full control
> over when and where the tracee stops and continues,

Only if it attaches to every thread in the thread group. Otherwise,
if the non-thread has already initiated the group-stop, the tracee
will notice TIF_SIGPENDING eventually and call do_signal_stop(),
debugger can't control this.

> I don't think it's an extreme corner case
> we can break.  For example, if a user gdb's a program which raises one
> of the stop signals, currently the user expects to be able to continue
> the program from whithin the gdb.  If we make group stop override
> ptrace, there's no other recourse than sending signal from outside.

Yes. Of course, gdb can be "fixed", it can send SIGCONT.

But yes, this is the noticeable change, that is why I suggested
ptrace_resume-acts-as-SIGCONT logic. Ugly, yes, but more or less
compatible. (although let me repeat, _pesonally_ I'd prefer to
simply tell user-space to learn the new rules ;)

> > > I think it should only include the case where the
> > > tracee actually stops for group stop excluding all other trapping
> > > points.
> >
> > I was thinking about this too and probably this makes sense. But
> > I think at least initial changes should keep the current behaviour
> > (assuming this behaviour is fixed).
>
> But if you make the other change but not this one, we end up with
> ptrace which doesn't notify the ptracer what's going on.  Apart from
> _polling_ /proc/tid/status, there is no mechanism to discover the
> tracee's state.

(Don't forget, ptrace_stop() should be fixed to notify and set
 SIGNAL_STOP_STOPPED if needed. Damn, it is not exactly trivial as
 I though initially... but hopefully possible anyway)

If gdb attaches to all threads it can detect this case, otherwise
it doesn't fully control the group-stop anyway.

But,

> The only thing it achieves is the integrity of group
> stop

Given that SIGCHLD doesn't queue and with or without your changes
we send it per-thread, it is not trivial for gdb to detect the
group-stop anyway. Again, the kernel should help somehow.

> and I'm not really sure whether that's something worth achieving
> at the cost of debugging capabilities especially when we don't _have_
> to lose them.

But we do not? I mean, at least this is not worse than the current
behaviour.

> > As for SIGCONT. Roland suggests (roughly) to change ptrace_resume()
> > so that it doesn't wakeup the stopped tracee until the real SIGCONT
> > comes. And this makes sense to me.
>
> I agree it adds more integrity to group stop but at the cost of
> debugging capabilities.  I'm not yet convinced integrity of group stop
> is that important.  Why is it such a big deal?

Of course I can't "prove" it is that important. But I think so.

> > But yes, I see your point. And while I think that Roland's suggestion is
> > fine, I also have another proposal
> >
> > 	- never send CLD_CONTINUED to the tracer, always send it to parent.
> >
> > 	  Firstly, this is completely pointless: ptrace is per-thread, while
> > 	  this notification is per-process
>
> CLD_STOPPED is too but while ptrace is attached the notifications are
> made per-task and delivered to the tracer.

No, there is a difference. Sure, CLD_STOPPED is per-process without
ptrace. But CLD_CONTINUED continues to be per-process even if all
threads are traced.

> > 	- change do_wait() so that WCONTINUED for real_parent
> >
> > 	- change ptrace_resume() to check SIGNAL_STOP_STOPPED case. It should
> > 	  act as SIGCONT in this case. Yes: "act as SIGCONT" needs more
> > 	  discussion.
>
> I don't know.

Heh, if only I could say I know ;)

> I think this is the key question.  Whether to de-throne
> PTRACE_CONT such that it cannot override group stop.  As I've already
> said several times already, I think it is a pretty fundamental
> property of ptrace

Again, I am a bit confused. Note that PTRACE_CONT overrides
group stop if we do the above. It should wake up the tracee, in
SIGCONT-compatible way (yes, the latter is not exactly clear).

But at least this should be visible to real parent. We shouldn't
silently make the stopped tracee running while its real_parent
thinks everything is stopped.

> and change to it would be quite visible,

If you meant Roland's suggestion (PTRACE_CONT doesn't wakeup
but needs SIGCONT) - yes.

> in
> negative way, from userland.

At least, in a non-compatible way.

Oleg.

