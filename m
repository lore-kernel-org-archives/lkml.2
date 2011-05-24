Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1EXNoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:44:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49519 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab1EXNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EwZb2i+krH4cgIkNiMb1o467IvOAJceJJNgrt9R/8VuhKt1drWGa9IlYpNZp1ARmHy
         5DLB4q0hXos+ii7ZIqpgRsQLmwGzxA8OjufqNNU84saBV4yAQ5ZZWoGheS5TNeiGotG8
         imNTl8bCt9kHhNbfuy1YHPZnF+JoSlooAHeEU=
Date: Tue, 24 May 2011 15:44:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110524134411.GE10334@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-11-git-send-email-tj@kernel.org>
 <20110519163246.GF17265@redhat.com>
 <20110519165833.GA19418@redhat.com>
 <20110523114559.GA5279@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523114559.GA5279@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, May 23, 2011 at 01:45:59PM +0200, Oleg Nesterov wrote:
> On 05/19, Oleg Nesterov wrote:
> >
> > I only meant
> > that I got lost in details and I feel I'll ask more questions later.
> 
> ... and I am greatly disappointed by the fact all technical problems I
> noticed were bogus, I should try more ;)

Yay, do I get to win for once? :)

> 1. __ptrace_unlink:
> 
> 	task_clear_jobctl_pending(child, JOBCTL_PENDING_MASK);
> 
> 	/*
> 	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
> 	 * @child isn't dead.
> 	 */
> 	if (!(child->flags & PF_EXITING) &&
> 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
> 	     child->signal->group_stop_count))
> 		child->jobctl |= JOBCTL_STOP_PENDING;
> 
> Yes, we set JOBCTL_STOP_PENDING correctly. But what about JOBCTL_STOP_CONSUME?
> It was potentially flushed by task_clear_jobctl_pending() above.

Right, will fix.  Probably best to just clear trap ones there.

> 2. ptrace_trap_notify() always sets JOBCTL_TRAP_NOTIFY. Even if the caller
> is prepare_signal(SIGCONT) and there were no SIGSTOP in the past. This looks
> a bit strange to me. I mean, perhaps it would be better to provoke the trap
> only if this SIGCONT is going to change the jobctl state.

Sure.  It doesn't really matter tho and might even be better for
weeding out invalid assumptions.

> In any case, we shouldn't set JOBCTL_TRAP_NOTIFY if fatal_signal_pending().
> do_signal_stop() is fine, and prepare_signal(SIGCONT) can't race with SIGKILL.
> but it can race with the zap_other_threads-like code (exec, coredump).
> If we set JOBCTL_TRAP_NOTIFY when fatal_signal_pending() is true, the tracee
> can't stop, it will call get_signal_to_deliver()->ptrace_stop() in a loop
> forever and the tracer can't clear this bit.
> 
> Minor, but perhaps it would be more consistent to check PF_EXITING in
> the !task_is_traced() case.

Yes, indeed.  Will update.  It would be nice if we have a helper which
checks PF_EXITING before manipulating the flags.  It seems a bit too
fragile as it currently stands.

> 3. The similar (but currently theoretical) problem with PTRACE_TRAP_STOP.
> We shouldn't assume anything about arch_ptrace_stop_needed(), the code
> should work correctly even if it always returns true. This means that,
> say, PTRACE_INTERRUPT should not set JOBCTL_TRAP_STOP if the tracee was
> killed, or ptrace_stop() should clear JOBCTL_TRAP_MASK if it aborts.

Hmmm... yes.  I think I'll add a wrapper to raise trap conditions
which always check PF_EXITING.

> -------------------------------------------------------------------------------
> Now about the API. Can't we avoid the "asynchronous" re-trapping and the
> subsequent complications like PTRACE_GETSIGINFO-must-be-called-to-cont?
> 
> What if we simply add the new request, say, PTRACE_JOBCTL_CONT which acts
> as "do not cont, but please report me the next change in jctl state". IOW,
> in short, instead of JOBCTL_BLOCK_NOTIFY we add JOBCTL_PLEASE_NOTIFY which
> is set by this request.
> 
> Roughly, PTRACE_JOBCTL_CONT works as follows:
> 
> 	- it is only valid if the tracee reported PTRACE_EVENT_STOP
> 
> 	- SIGCONT/do_signal_stop/prepare_signal(SIGCONT) set
> 	  JOBCTL_TRAP_NOTIFY but do not wakeup unless
> 	  JOBCTL_PLEASE_NOTIFY was set by PTRACE_JOBCTL_CONT
> 
> 	- of course, PTRACE_JOBCTL_CONT checks if JOBCTL_TRAP_NOTIFY
> 	  is already set.

The main idea was that per-task execution state while ptraced is
separate, and thus asynchronous, from group stop state.  Group stop
affects task execution but is ultimiately a separate attribute.  This
is reflected in the modifications made upto this point - which
exit_code to use, and PTRACE_CONT working beneath group stop state.

While ptraced, group stop is a separate and asynchronous event and I
think it would be best if the interface reflects that rather than
trying to make it look like something different.

IIUC, the interface you suggested doesn't remove asynchronousity but,
rather, confines it, but to me it seems to be a too thin a veil.
e.g. What is the state of the tracee after PTRACE_JOBCTL_CONT?  It is
trapped but could be waken asynchronously and the ptracer isn't
equipped to deal with that.  What happens if the ptracer issues
further PTRACE requests to the tracee?  Are they rejected?  What does
it mean to PTRACE_INTERRUPT while tracee is in this state?

I'm somewhat uncomfortable with the fact that SIGCONT is directly
resuming tracee.  Re-trapping is different.  The implementation might
not be the easiest to swallow but conceptually it's just generating a
notification telling the ptracer that something has changed (and we
can try to do that from SIGCONT generator although I think re-trapping
is cleaner).  The execution state is still fully under the control of
ptracer.

(oops, please read on before replying.  I thought you were suggesting
 resuming tracee without tracer intervention.)

> As for PTRACE_CONT, it should set JOBCTL_PLEASE_NOTIFY if we resume the
> stopped tracee. Or the tracer can do PTRACE_JOBCTL_CONT + PTRACE_CONT.

Hmmm... so, if tracee is PTRACE_CONT'd from group stop and then
SIGCONT happens, what happens?  Does the tracee trap?  IOW, what does
it mean to have JOBCTL_PLEASE_NOTIFY set while tracee is not in
TRAP_STOP?

> jobctl stop, it can simply do PTRACE_JOBCTL_CONT and wait(). This looks
> much simpler to me. The only (afaics) complication is: PTRACE_INTERRUPT
> should guarantee the trap after PTRACE_JOBCTL_CONT (in this case we can
> simply set ->exit_code, no need to re-trap).
> 
> si_pt_flags (or whatever we use to report the jobctl state) can be recorded
> during the trap, not at the time of ptrace() syscall.

The reason why si_pt_flags is generated on PTRACE_GETSIGINFO is
because it reflects information which is asynchronous in nature.  It
doesn't make sense to sample the state when the task is going into
trap.  When a task enters a trap is fundamentally unrelated to how
group stop state changes.  I think sampling it on GETSIGINFO is the
right thing to do as group stop state _is_ asynchronous to whatever
the task itself is doing; otherwise, we end up with situation where no
job control state is being changed but two tracees consistently report
different group stop state depending on when they took trap.  How
should that be interpreted?  What does that even mean?  It gets
weirder if there are untraced tasks in the group.

> The implementation should be simpler too. Only ptrace_attach() needs the
> wait_trapping() logic, no need to complicate do_wait(). The tracee re-traps
> only if the tracer asks for this.

Ah, okay, so, it does re-trap on SIGCONT but it happens only after
JOBCTLY_PLEASE_NOTIFY is set.  Then the only thing which changes is
removal of wait(2) retry logic at the cost of requiring the user to
use a new request and stating that WNOHANG wait might fail
unexpectedly after PTRACE_JOBCTL_CONT.  Am I misunderstanding
something?

> And _imho_ this is more understandable from the user-space pov. To me it
> is a bit strange a TASK_TRACED tracee can run and then take another trap
> without some sort of CONT from debugger, even if we hide the transition.

I think it's best to represent a consistent interface / information
which reflects the actual interworking of job control and tracees.
Trying to mask it ultimately makes it more confusing, so I think it
makes sense to actually report job control state changes as
asynchronous notifications.  Re-trapping is an implementation detail
which is chosen to generate such notifications - we can try a
different approach - which I think would be worse but anyways.

If we take a step back and forget about the implementation itself for
a while, the re-trapping and on-the-fly GETSIGINFO are adding a rather
generic async notification mechanism for ptrace, and I still think
that's the better way to take.

Thanks.

-- 
tejun
