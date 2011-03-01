Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1CAXQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:16:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab1CAXQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NcxaNkmEVtCDqVLeWGdN/X6vMRZmngwe3rs21v7ONxRIc7xow78Z+5hn4IyR8Hu06F
         0K7oQjQqmKtvo80+FdxemimNa4ElCOa35F0c8dACircNtJzdK3LkZzWqd90yr3KTnioV
         XTTufCrEJ/FnvrTMBtxqKn1c5Bm7tsROa818E=
MIME-Version: 1.0
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 00:16:23 +0100
Message-ID: <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 4:24 PM, Tejun Heo <tj@kernel.org> wrote:
> PROPOSAL
> --------
> ...
> P5. "^Z" and "fg" for tracees
>
> A ptracer, as it currently stands and proposed here, has full control
> over the execution state of its tracee.  The tracer is notified
> whenever the tracee stops and can always resume its execution;
> however, there is one missing piece.
>
> As proposed, when a tracee enters jctl stop, it enters TASK_TRACED
> from which emission of SIGCONT can't resume the tracee.  This makes it
> impossible for a tracer to become transparent with respect to jctl.
> For example, after strace(1) is attached to a task, the task can be
> ^Z'd but then can't be fg'd.
>
> One approach to this problem is somehow making it work implicitly from
> the kernel - as in putting the tracee into TASK_STOPPED or somehow
> handling TASK_TRACED for jctl stop differently; however, I think such
> approach is cumbersome in both concept and implementation.  Instead of
> being able to say "while ptraced, a tracee's execution is fully under
> the control of its tracer", subtle and fragile exceptions need to be
> introduced.
>
> A better way to solve this is simply giving the tracer the capability
> to listen for the end of jctl stop.  That way, the problem is solved
> in a manner which is consistent, may not be to everyone's liking but
> nonetheless consistent, with the rest of ptrace.  Execution state of
> the tracee is always under the control of the tracer.  The only thing
> which changes is that the tracer now can find out when jctl stop ends,
> which also could be an additional useful debugging feature.
>
> It would be most fitting to use wait(2) for delivery of this
> notification.  WCONTINUED is the obvious candidate but I think it is
> better to use STOPPED notification because the task is not really
> resumed.  Only its mode of stop changes.  What state the tracee is in
> can be determined by retriving siginfo using PTRACE_GETSIGINFO.
>
> This also effectively makes the notification level-triggered instead
> of edge-triggered, which is a big plus.  No matter which state the
> tracee is in, a jctl stopped notification is guaranteed to happen
> after the lastest event and the tracer can always find out the latest
> state with PTRACE_GETSIGINFO.
>
> Using stopped notification also makes the new addition harmless to the
> existing users.  It's just another stopped notification.  Both
> strace(1) and gdb(1) don't distinguish the signal delivery and jctl
> stop notifications and react the same way by resuming the tracee
> unconditionally.  One more stopped notification on SIGCONT emission
> doesn't change much.

Let's spell this out in detail. Please correct me if
I misunderstood your proposal:

We have a stopped task under ptrace.
(More precisely: debugger got a WSTOPPED notification via waitpid.
Debugger decided to emulate the job control stop, therefore it
keeps tracee stopped, therefore it just waits on waitpid
without doing any PTRACE_CONTs).

Another task sends SIGCONT to the tracee.

Debugger gets waitpid notification of the
WSTOPPED, WSTOPSIG == SIGCONT form.

Debugger can check PTRACE_GETSIGINFO, which succeeds.
Debugger now knows it's a signal delivery notification.
(This step looks optional, since currently
WSTOPPED, WSTOPSIG == SIGCONT combination is only possible
on signal delivery, unlike, for example,
WSTOPPED, WSTOPSIG == SIGSTOP, which is ambiguous).

Debugger performs PTRACE_CONT(SIGCONT) - it injects the signal.
[Question: what if debugger doesn't? IOW: is it possible
for debugger to suppress SIGCONTs, or not?
IOW2: what should happen if debugger
(a) does not do any PTRACE_CONT at all? or
(b) does PTRACE_CONT(<other_sig>)? or
(c) does PTRACE_CONT(0)?
]

Debugger gets WCONTINUED waitpid notification.
[question: do we need this?]


-- 
vda
