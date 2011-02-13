Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1BMW0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:26:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49350 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1BMW0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=T+3AOy95oCbNrhvqiMt3Zy1gF+vvceiU82GngmEi/BZ9MtHUHU2SfXfgS8/Sx0o/fq
         8yzinKT1TTIVxFRoSFxN32cmAS3zgHgcx/bR6IRctuEHaB+j/FqrXEcivdxpJE14OW2T
         u+KN6xmXmjNdiFRtSDGNUCot7fTxun2dMfd98=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Sun, 13 Feb 2011 23:25:55 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org>
In-Reply-To: <20110209141803.GH3770@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102132325.55353.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 February 2011 15:18, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Mon, Feb 07, 2011 at 06:48:21PM +0100, Oleg Nesterov wrote:
> > > I don't know.  Maybe it's more consistent that way and I'm not
> > > fundamentally against that but it is a big behavior change
> > 
> > Hmm. I tried to describe the current behaviour...
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
> 
>   Note that { the task is put into TASK_TRACED state and group stop
>   resume by SIGCONT is ignored. | the task is put into TASK_STOPPED
>   state and the following PTRACE request will transition it into
>   TASK_TRACED.  If SIGCONT is received before transition to
>   TASK_TRACED is made, the task will resume execution.  If PTRACE
>   request faces with SIGCONT, PTRACE request may fail. }
> 
>   The ptracer may resume execution of the task using PTRACE_CONT
>   without affecting other tasks in the group.  The task will not stop
>   for the same group stop again while ptraced.
> 
>   On ptrace detach, if group stop is in effect, the task will be put
>   into TASK_STOPPED state and if it is the first time the task is
>   stopping for the current group stop, it will participate in group
>   stop completion.
> 
> This can be phrased better but it seems well defined enough for me.  I
> take it that one of your concerns is direct transition into
> TASK_TRACED on group stop while ptraced which prevents the tracee from
> reacting to the following SIGCONT.  I'm not sure how much of an actual
> problem it is given that our notification to real parent hasn't worked
> at all till now but we can definitely implement proper TASK_STOPPED ->
> TRACED transition on the next PTRACE request.  There exists a
> fundamental race condition between SIGCONT and the next PTRACE call
> but I don't think it's such a big deal as long as the transition
> itself is done properly.
> 
> If we don't go that route, another solution would be to add a ptrace
> call which can listen to SIGCONT.  ie. PTRACE_WAIT_CONT or whatever
> which the ptracer can call once it knows the tracee entered group
> stop.
> 
> In either case, the fundamentals of ptrace operation don't really
> change.  All ptrace operations are still per-task and ptracer almost
> always has control over execution of the tracee.  Sure, it allows
> ptraced task to escape group stop but it seems defined clear enough
> and IMHO actually is a helpful debugging feature.  After all, it's not
> like stop signals can be used for absoultely reliable job control.
> There's an inherent race against SIGCONT.
> 
> > > What do you do about PTRACE requests while a task is group stopped?
> > > Reject them?  Block them?
> > 
> > Yes, another known oddity. Of course we shouldn't reject or block.
> > Perhaps we can ignore this initially. If SIGCONT comes after another
> > request does STOPPED/TRACED it clears SIGNAL_STOP_STOPPED, but the
> > tracee won't run until the next PTRACE_CONT, this makes sense.
> 
> That conceptually might make sense but other than the conceptual
> integrity it widely changes the assumptions and is less useful than
> the current behavior.  I don't really see why we would want to do
> that.
> 
> > The problem is, gdb can't leave the tracee in STOPPED state if it
> > wants. We need to improve this somehow (like in your previous example
> > with gdb).
> >
> > Only if it attaches to every thread in the thread group. Otherwise,
> > if the non-thread has already initiated the group-stop, the tracee
> > will notice TIF_SIGPENDING eventually and call do_signal_stop(),
> > debugger can't control this.
> 
> The debugger is still notified and can override it.  gdb already can
> and does.
> 
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
> change and secondly the resulting behavior might look conceptually
> pleasing but is not as useful as the current one.  Why make a change
> which results in reduced usefulness while noticeably breaking existing
> users?
> 
> > > The only thing it achieves is the integrity of group
> > > stop
> > 
> > Given that SIGCHLD doesn't queue and with or without your changes
> > we send it per-thread, it is not trivial for gdb to detect the
> > group-stop anyway. Again, the kernel should help somehow.
> 
> Hmmm?  Isn't this discoverable from the exit code from wait?
> 
> > > and I'm not really sure whether that's something worth achieving
> > > at the cost of debugging capabilities especially when we don't _have_
> > > to lose them.
> > 
> > But we do not? I mean, at least this is not worse than the current
> > behaviour.
> 
> I think it's worse.  With your changes, debuggers can't diddle the
> tasks behind group stop's back which the current users already expect.

But this "diddling behind group stop's back" is exactly the current
problem with stop signals.

Here I try to stop a ptraced process:

$ strace -tt sleep 30
23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
...
23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
    (I forgot again why we see it twice. Another quirk I guess...)
23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
23:02:45.622433 close(1)                = 0
23:02:45.622743 close(2)                = 0
23:02:45.622885 exit_group(0)           = ?

Why sleep didn't stop?

Because PTRACE_SYSCALL brought the task out of group stop at once,
even though strace did try hard to not do so:

    ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!

PTRACE_CONT in this situation would do the same.

You are saying that it is useful that gdb restarts group-stopped task
with mere PTRACE_CONT. Above is a counter-example where it is anti-useful:
I would muchly prefer strace to see task sit stopped until it gets SIGCONT
(or some fatal signal).

Why gdb can't use SIGCONT instead of PTRACE_CONT, just like every
other tool which needs to resume stopped tasks?


Hmm... it occurred to me that we can use 4th argument of
PTRACE_CONT/SYSCALL to distinguish between the case when tracer wants
to leave tracee stopped (pass SIGSTOP), or wants it to be resumed
(pass 0), or even wants to simulate "real" signal
arriving (pass other SIGfoo).

This will automagically fix "strace sleep" case, because
strace already is sending SIGSTOP in PTRACE_SYSCALL (currently,
in vain).

-- 
vda
