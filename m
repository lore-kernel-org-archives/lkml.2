Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1EZOpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab1EZOpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:45:40 -0400
Date: Thu, 26 May 2011 16:44:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110526144402.GA12525@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-11-git-send-email-tj@kernel.org> <20110519163246.GF17265@redhat.com> <20110519165833.GA19418@redhat.com> <20110523114559.GA5279@redhat.com> <20110524134411.GE10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524134411.GE10334@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 05/24, Tejun Heo wrote:
>
> On Mon, May 23, 2011 at 01:45:59PM +0200, Oleg Nesterov wrote:
> > Now about the API. Can't we avoid the "asynchronous" re-trapping and the
> > subsequent complications like PTRACE_GETSIGINFO-must-be-called-to-cont?
> >
> > What if we simply add the new request, say, PTRACE_JOBCTL_CONT which acts
> > as "do not cont, but please report me the next change in jctl state". IOW,
> > in short, instead of JOBCTL_BLOCK_NOTIFY we add JOBCTL_PLEASE_NOTIFY which
> > is set by this request.
> >
> > Roughly, PTRACE_JOBCTL_CONT works as follows:
> >
> > 	- it is only valid if the tracee reported PTRACE_EVENT_STOP
> >
> > 	- SIGCONT/do_signal_stop/prepare_signal(SIGCONT) set
> > 	  JOBCTL_TRAP_NOTIFY but do not wakeup unless
> > 	  JOBCTL_PLEASE_NOTIFY was set by PTRACE_JOBCTL_CONT
> >
> > 	- of course, PTRACE_JOBCTL_CONT checks if JOBCTL_TRAP_NOTIFY
> > 	  is already set.
>
> While ptraced, group stop is a separate and asynchronous event and I
> think it would be best if the interface reflects

I agree. And it continues to be asynchronous, just the tracer can
explicitly tell when it wants to know about the state change.

> What is the state of the tracee after PTRACE_JOBCTL_CONT?  It is
> trapped

Yes,

> but could be waken asynchronously and the ptracer isn't
> equipped to deal with that.

It can be waken by SIGCONT, yes, but the tracer is equipped, it asked
for this.

> What happens if the ptracer issues
> further PTRACE requests to the tracee?  Are they rejected?

Yes. Except PTRACE_INTERRUPT, of course. (OK, may be PTRACE_CONT makes
sense too but this is minor).

> it mean to PTRACE_INTERRUPT while tracee is in this state?

It should guarentee PTRACE_EVENT_STOP, as if the tracee was running.

IOW. The tracee is no longer quiescent after PTRACE_JOBCTL_CONT. It is
still TASK_TRACED (although we could use another state), but it is
waiting for another jobctl state change. The tracer should wait for
notification (or call wait) as usual. No need to hide the TRACED->
RUNNING->TRACED transition during the re-trapping.

> > As for PTRACE_CONT, it should set JOBCTL_PLEASE_NOTIFY if we resume the
> > stopped tracee. Or the tracer can do PTRACE_JOBCTL_CONT + PTRACE_CONT.
>
> Hmmm... so, if tracee is PTRACE_CONT'd from group stop and then
> SIGCONT happens, what happens?  Does the tracee trap?

Yes. This is (almost) the same case as above, ignoring the small
implementation details.

To me this looks really simpler and more understandable for the user
space. If the simple tracer doesn't care about SIGCONT it can simply
do PTRACE_CONT without PTRACE_GETSIGINFO.

> > jobctl stop, it can simply do PTRACE_JOBCTL_CONT and wait(). This looks
> > much simpler to me. The only (afaics) complication is: PTRACE_INTERRUPT
> > should guarantee the trap after PTRACE_JOBCTL_CONT (in this case we can
> > simply set ->exit_code, no need to re-trap).
> >
> > si_pt_flags (or whatever we use to report the jobctl state) can be recorded
> > during the trap, not at the time of ptrace() syscall.
>
> The reason why si_pt_flags is generated on PTRACE_GETSIGINFO is
> because it reflects information which is asynchronous in nature.

I see. And I understand that this is necessary if the tracee re-traps
asynchronously. Either the tracer gets the up-to-date info, or the
tracee can't be continued without another trap. Honestly, I do not
like this, but I agree this works.

> It
> doesn't make sense to sample the state when the task is going into
> trap.  When a task enters a trap is fundamentally unrelated to how
> group stop state changes.

Sure. But:

> I think sampling it on GETSIGINFO is the
> right thing to do as group stop state _is_ asynchronous to whatever
> the task itself is doing;

The group stop state _is_ asynchronous to GETSIGINFO as well. Once again,
I understand (I hope) how this works, but dislike.


If we add PTRACE_JOBCTL_CONT, I think we can sample the state when
the task is going into trap. If the tracer cares about the next state
change, the tracee will trap again.

> > The implementation should be simpler too. Only ptrace_attach() needs the
> > wait_trapping() logic, no need to complicate do_wait(). The tracee re-traps
> > only if the tracer asks for this.
>
> Ah, okay, so, it does re-trap on SIGCONT but it happens only after
> JOBCTLY_PLEASE_NOTIFY is set.  Then the only thing which changes is
> removal of wait(2) retry logic at the cost of requiring the user to
> use a new request and stating that WNOHANG wait might fail
> unexpectedly after PTRACE_JOBCTL_CONT.

Yes. Except "unexpectedly" is a bit confusing. Once again, the tracee
is no longer quiescent.

> > And _imho_ this is more understandable from the user-space pov. To me it
> > is a bit strange a TASK_TRACED tracee can run and then take another trap
> > without some sort of CONT from debugger, even if we hide the transition.
>
> I think it's best to represent a consistent interface / information
> which reflects the actual interworking of job control and tracees.
> Trying to mask it ultimately makes it more confusing, so I think it
> makes sense to actually report job control state changes as
> asynchronous notifications.

Hmm. Here we start to disagree ;)

> If we take a step back and forget about the implementation itself for
> a while,

I must admit, I am a bit biased because I think this makes the
implementation more simple. But my point is, _in my opinion_
PTRACE_JOBCTL_CONT is better from the user-space pov.

> the re-trapping and on-the-fly GETSIGINFO are adding a rather
> generic async notification mechanism for ptrace,

For what? Why this is good?

It was always true that once the tracee reports the trap it is
completely quiescent untill debugger resumes it (except SIGKILL).
This is simple and understandable. Why should we change this?

Oleg.

