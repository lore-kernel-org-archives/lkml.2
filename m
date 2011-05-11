Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1EKQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:03:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab1EKQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hTcE4xH828SIMDX1UJVgYja+h+U2PH2wq/uHXXOEmfnS7ZIPLloOusIHn9GlmntlmZ
         SOtTSZI1exqGfboxpTnZ0TC7GDT7/52pkfl5eVtJ7b1Y17NPtxPjJFGsO8X7KfOnhcKF
         QPose2SxyrPxS9L444ikGc5rzJb/m9Bdqs7+w=
Date: Wed, 11 May 2011 15:13:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110511131314.GF1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <201105110037.34051.vda.linux@googlemail.com>
 <20110511090551.GC1661@htj.dyndns.org>
 <BANLkTi=qOnVjj9RjHhUdtMJn_4iy6US74A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=qOnVjj9RjHhUdtMJn_4iy6US74A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 11, 2011 at 02:01:16PM +0200, Denys Vlasenko wrote:
> On Wed, May 11, 2011 at 11:05 AM, Tejun Heo <tj@kernel.org> wrote:
> > Debugger may continue tracee and put it in a different trap.  In such
> > cases, group stop may be initiated and lifted multiple times while a
> > tracee is trapped.  It's much nicer to have symmetric notifications in
> > those cases.
> 
> I don't understand what exactly you mean by this.
> You mean that it's better to have one INTERRUPT trap per each
> stop/cont transition? Such as:
> 
> tracer                  tracee                  3rd process
> waitpid <---------------some ptrace stop
> <tracer is doing something,
>  not yet ptrace(CONT)ing>
>                         <-----------------------kill -STOP
>                         <-----------------------kill -CONT
>                         <-----------------------kill -STOP
>                         <-----------------------kill -CONT
> ptrace(CONT)----------->
> waitpid <---------------INTERRUPT
> ptrace(GETSIGINFO)<-----"it's a group stop"
> waitpid <---------------INTERRUPT
> ptrace(GETSIGINFO)<-----"it's a cont"
> ptrace(CONT)----------->
> waitpid <---------------INTERRUPT
> ptrace(GETSIGINFO)<-----"it's a group stop"
> waitpid <---------------INTERRUPT
> ptrace(GETSIGINFO)<-----"it's a cont"
> ptrace(CONT)----------->
> ............................................................
> 
> I agree that it's not a bad thing to deliver ALL notifications.

No, not at all.

> But from what I understood, with your patch it won't do this either:
> you don't remember every stop and cont in a queue, you have just one bit?

What I want to guarantee is that after one or more events, at least
one notification is always delivered in finite userland time.

> And second, I don't think we really need this. We only need this:
> if tracer did see group stop, it MUST see cont (or kill) - cont
> should never be missed. But it's ok to miss whole pairs of stop+cont
> which were done in quick succession (and similarly for cont+stop
> pairs on a stopped tracee, as in example above).

Yeah, sure.  There's no event queueing and I'm not gonna add one.

> > Also, we might end up adding more status flags to si_pt_flags and it's
> > much better to be able to say "INTERRUPT becomes and stays pending
> > until the next GETSIGINFO if any of these flags may have chagned" than
> > "if XXX change from x to y, or YYY changes to x to y or y to x,
> > ... blah blah".
> 
> Why do you want this data to be sticky at all?
> Do you think tracer will "forget" to retrieve it?
> That'd be a bug in the tracer if it doesn't retrieve the data
> and therefore mishandles stop and/or cont.

Please read on.

> >> Can we just add a "group cont" notification which looks like
> >> a waitpid result with WIFCONTINUED(waitpid_status) == 1 to the tracer?
> >
> > Consider the following scenario.
> >
> > 1. A syscall traced tracee enters group stop while returning from a
> >   syscall.  Tracer is notified.
> >
> > 2. SIGCONT generated.  Tracee is woken up and wait state is generated.
> >
> > 3. Tracee traps for syscall completion before tracer has chance to
> >   wait(2).
> 
> The order in (3) seems wrong:
> Tracee doesn't enter group stop while it is in syscall.
> It exits syscall first, and then it enters group stop.
> Therefore in step (3) above it can't "trap for syscall completion".
> It can trap for syscall entry at worst; however:

Okay, whatever other trap then.

> > 4. Oops, continued wait state lost.
> 
> Why is it lost? Why kernel signals syscall entry instead of CONT
> in your scenario?

SIGCONT doesn't have to be delivered by the specific task being traced
and the userland can continue executing without any specific time
limit breaking the 'in finite userland time' part of the guarantee.

> The rest isn't interesting (typical buggy handling of stop
> notification in current strace/kernel):

The whole thing is uninteresting.  The trap type doesn't matter at
all.  The only thing matter is that PTRACE_CONT may race with end of
group stop and control may return to userland and event can be lost.

> Can you describe your scenario in more details. I don't understand it.

Stop thinking about strace(1).  It's the most trivial case.  A tracee
can be in any trap regardless of group stop state and tracer can issue
PTRACE_CONT anytime which can race with SIGCONT generation.  You want
to deliver the notification to the tracer in finite userland time.
Think about SIGCONT and PTRACE_CONT racing each other and SIGCONT
being delivered to another task.

> Why tracer needs to schedule anything? As you see above,
> at this point tracer is in waitpid anyway. It is ALREADY prepared
> to get cont notification. It doesn't need to generate any extra
> ptrace stops for that.

The debugger doesn't want the debuggee to be running.  It wants tracee
to be in basically the same state as in group stop after the temporary
inspection.  It doesn't want to leave it running while group stop is
in effect but still wants to be notified of end of group stop.

Thanks.

-- 
tejun
