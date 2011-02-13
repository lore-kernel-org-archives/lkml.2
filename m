Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1BMXCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:02:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1BMXBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rEq/ijhBF8H4rF4K7YrkIHKIEQIrepEdP4zF5tX5pQ4yVdwjEdYL7N/MXcAkWTe4P4
         wyjsJ8oM9utY7UwUtWLao2nux8dIGJaGiuOEkEUNKcvYMsvUp1uANwkBEM96KCKKedsG
         OeYb6FlQQEcKIYv++EsagoNREhervASxxkDhs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Mon, 14 Feb 2011 00:01:47 +0100
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110204130455.GA3671@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <20110209212526.GA9999@redhat.com>
In-Reply-To: <20110209212526.GA9999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201102140001.47218.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 February 2011 22:25, Oleg Nesterov wrote:
> >   Note that { the task is put into TASK_TRACED state and group stop
> >   resume by SIGCONT is ignored. | the task is put into TASK_STOPPED
> >   state and the following PTRACE request will transition it into
> >   TASK_TRACED.  If SIGCONT is received before transition to
> >   TASK_TRACED is made, the task will resume execution.  If PTRACE
> >   request faces with SIGCONT, PTRACE request may fail. }
> 
> To me, the first variant looks better. But, only because it is closer
> to the current behaviour. I mean, it is better to change the things
> incrementally.
> 
> But in the longer term - I do not know. Personally, I like the
> TASK_STOPPED variant. To the point, I was thinking that (perhaps)
> we can change ptrace_stop() so that it simply calls do_signal_stop()
> if it notices ->group_stop_count != 0.
> 
> >   The ptracer may resume execution of the task using PTRACE_CONT
> >   without affecting other tasks in the group.
> 
> And this is what I do not like. I just can't accept the fact there
> is a running thread in the SIGNAL_STOP_STOPPED group.
> 
> But yes: this is what the current code does, I am not sure we can
> change this, and both PTRACE_CONT-doesnt-resume-until-SIGCONT and
> PTRACE_CONT-acts-as-SIGCONT are not "perfect" too.

Can you enumerate reasons why each of them are not perfect?
I want to understand your thinking better here.


> > There exists a
> > fundamental race condition between SIGCONT and the next PTRACE call
> 
> Yes, and this race is already here, ptracer should take care.

>From the API POV, there is no race, if we assume Oleg's interpretation
that "stopped/not-stopped" and "traced/not-traced" states are
completely orthogonal:

As long as task is in "traced" state and it is in ptrace-stop, SIGCONT
delivered to it does not make it run. Only next PTRACE_CONT (or SYSCALL)
will. Neither will SIGCONT delivered to any other thread group member:
even though this will terminate group-stop state and all untraced
tasks will start running, all tasks which are in ptrace-stop will not:
they will wait for the next PTRACE_CONT (or SYSCALL).

I realize that currently it doesn't work like this, because
group-stop and ptrace-stop are intermingled concepts right now.
My point is, it can be made to work that way, and become free
of this particular race.


> > In either case, the fundamentals of ptrace operation don't really
> > change.  All ptrace operations are still per-task and ptracer almost
> > always has control over execution of the tracee.  Sure, it allows
> > ptraced task to escape group stop but it seems defined clear enough
> > and IMHO actually is a helpful debugging feature.
> 
> Heh, I think we found the place where we can't convince each other.
> What if we toss a coin?

I'm with Oleg on this. If debugger wants to terminate group-stop,
it should just send SIGCONT, not depend on the obscure feature (it is not
documented, right?) that PTRACE_CONT somehow affects group-stop state.


> > > > What do you do about PTRACE requests while a task is group stopped?
> > > > Reject them?  Block them?
> > >
> > > Yes, another known oddity. Of course we shouldn't reject or block.

Why they need to be rejected or blocked? Think again about
"strace sleep" interrupted by SIGSTOP (or SIGTSTP):

* sleep runs in nanosleep
* SIGSTOP arrives, strace sees it
* strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
* sleep process enters group-stop
* nothing happens until some other signal arrives
* say, SIGCONT arrives
* strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGCONT)

I believe your question is "what if tracer wants to do a ptrace op
on tracee while it is in group-stop" (step 4 above)?

The answer is simple:
the same as if tracer wants to do a ptrace op on tracee while it is running,
that is - ptrace() should return error. For the tracer (in my example,
strace) there is no difference in state after ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
and ptrace(PTRACE_SYSCALL, ..., <0 or SIGWINCH or any other sig>):
in both cases tracer must wait for tracee to enter ptrace-stop before
any ptrace op is allowed.

Jan, from gdb developer's POV, do you have a problem with this?


> > Heh, I'm not asking for proof that it is more useful. :-) But I'm still
> > curious why you think it's important because the benefits aren't
> > apparent to me.  Roland and you seem to share this opinion without
> > much dicussion so maybe I'm missing something?
> 
> I can't!
> 
> I hate this from the time when I noticed that the application doesn't
> respond to ^Z under strace. And I used strace exactly because I wanted
> do debug some (I can't recall exactly) problems with jctl. That is all.

Recently I had exactly this experience too. It's frustrating.


> > To me, it
> > isn't too objectionable to allow debuggers to diddle with tracees
> > behind the real parent's back.  In fact, it would be quite useful when
> > debugging job control related behaviors.  I wouldn't have much problem
> > accepting the other way around - ie. strict job control even while
> > being debugged, but given that it is already allowed and visible, I
> > fail to see why we should change the behavior.  It doesn't seem to
> > have enough benefits to warrant such visible change.
> 
> All I can say is: sure, I see your point, and perhaps you are right
> and I am wrong.
> 
> I'd really like to force CC list to participate ;)

You just succeeded :)

-- 
vda
