Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1CAW7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:59:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1CAW7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ju9gmbVtLOgtpN30v//k5PRi5FxMkCSSgXxmROfx69Gsr0El0eldgVchhpV5nJsVur
         k1quSVKje6E5wDLhY9VhVgQKBqlrGE8JarKd0pj2DNM3kwFv+4HD35b7MsMnFgVA+YAH
         pp7NQprTajd2AnN99aFWIlvkvZapao2xB3wHU=
MIME-Version: 1.0
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 1 Mar 2011 23:59:02 +0100
Message-ID: <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 4:24 PM, Tejun Heo <tj@kernel.org> wrote:
> PROPOSAL
> --------
>
> P1. Always TASK_TRACED while ptraced
> P2. Fix notifications to the real parent
> P3. Keep ptrace resume separate from and beneath jctl stop
> P4. PTRACE_SEIZE
> P5. "^Z" and "fg" for tracees

Since this plan might get transformed into a file in Documentation/,
I would like to chime in a few less important things we might want
to clarify while we are at it.



P6. Make PTRACE_GETSIGINFO useful for determining the type of ptrace stop.

PTRACE_GETSIGINFO on real signal should return associated struct siginfo.

PTRACE_GETSIGINFO on job control stops and process exits (WEXITED /
WSIGNALED) should error out.

What does PTRACE_GETSIGINFO return on various ptrace-generated
SIGTRAPs and SIGSTOPs?
Error? If not, what value is returned in siginfo->si_code?

We have the following kinds of SIGTRAPs:

* real SIGTRAP signal sent by breakpoint instruction
* real SIGTRAP signal sent by other process
* entering syscall (after PTRACE_SYSCALL)
* exiting syscall (after PTRACE_SYSCALL)
* after single step (after PTRACE_SINGLESTEP)
* after execve (if PTRACE_O_TRACEEXEC opt is not on)
* after execve (if PTRACE_O_TRACEEXEC opt is on)
* in parent after fork (if PTRACE_O_TRACEFORK opt is on)
* in parent after vfork (if PTRACE_O_TRACEVFORK opt is on)
* in parent after clone (if PTRACE_O_TRACECLONE opt is on)
* in child after vfork (if PTRACE_O_TRACEVFORKDONE opt is on)
* before exit (if PTRACE_O_TRACEEXIT opt is on)

Currently strace has to keep precise track on the alternating sequence
of syscall enter/syscall exit stops. Which gets even trickier
with extra magic SIGTRAP thrown in by execve and such.
There were (and I suspect will be) hard to debug bugs when strace
was getting out-of sync and printing garbage.

Defining the PTRACE_GETSIGINFO's si_code so that each of these stops
can be easily distinguished would be useful. I propose using values
of SI_KERNEL + 1, SI_KERNEL + 2 etc, suitably #defined of course.


We also have magic SIGSTOPs (magic in a sense they aren't
real signals sent by other processes):
* at PTRACE_ATTACH
* in child (if PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE opt is on)

For example, flagging PTRACE_ATTACH SIGSTOP so that it can be
uniquely identified would solve some problems gdb is having with it.

I propose to similarly do it by using unique si_code for each.

-- 
vda
