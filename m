Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1EKPsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:48:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38874 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1EKPsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FNkbUVdVfw8UN74j9EoXP3v9gR9pd8e5iIMPCQejCNrFC1XmvQfxM/stAXqMRKNxnc
         SLPdgyvU7Ig1840MIk5O8WAbfYQmzfm2NrOynsJx9oE6b7zd21ojZQb+7tMo1Ps3HCez
         KgqUyctKLPaNn8flJc7LY17FB1kTj1CfgaLeA=
MIME-Version: 1.0
In-Reply-To: <20110511090551.GC1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org> <201105110037.34051.vda.linux@googlemail.com>
 <20110511090551.GC1661@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 11 May 2011 14:01:16 +0200
Message-ID: <BANLkTi=qOnVjj9RjHhUdtMJn_4iy6US74A@mail.gmail.com>
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for ptracer
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:05 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Denys.
>
> On Wed, May 11, 2011 at 12:37:34AM +0200, Denys Vlasenko wrote:
>> > When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
>> > is set, which triggers INTERRUPT trap but is sticky until the next
>> > PTRACE_GETSIGINFO.
>>
>> Why INTERRUPT trap? For group stops, we already have perfectly working
>> way to detect such a stop.
>
> Debugger may continue tracee and put it in a different trap.  In such
> cases, group stop may be initiated and lifted multiple times while a
> tracee is trapped.  It's much nicer to have symmetric notifications in
> those cases.

I don't understand what exactly you mean by this.
You mean that it's better to have one INTERRUPT trap per each
stop/cont transition? Such as:

tracer                  tracee                  3rd process
waitpid <---------------some ptrace stop
<tracer is doing something,
 not yet ptrace(CONT)ing>
                        <-----------------------kill -STOP
                        <-----------------------kill -CONT
                        <-----------------------kill -STOP
                        <-----------------------kill -CONT
ptrace(CONT)----------->
waitpid <---------------INTERRUPT
ptrace(GETSIGINFO)<-----"it's a group stop"
waitpid <---------------INTERRUPT
ptrace(GETSIGINFO)<-----"it's a cont"
ptrace(CONT)----------->
waitpid <---------------INTERRUPT
ptrace(GETSIGINFO)<-----"it's a group stop"
waitpid <---------------INTERRUPT
ptrace(GETSIGINFO)<-----"it's a cont"
ptrace(CONT)----------->
............................................................

I agree that it's not a bad thing to deliver ALL notifications.

But from what I understood, with your patch it won't do this either:
you don't remember every stop and cont in a queue, you have just one bit?

And second, I don't think we really need this. We only need this:
if tracer did see group stop, it MUST see cont (or kill) - cont
should never be missed. But it's ok to miss whole pairs of stop+cont
which were done in quick succession (and similarly for cont+stop
pairs on a stopped tracee, as in example above).

> Also, we might end up adding more status flags to si_pt_flags and it's
> much better to be able to say "INTERRUPT becomes and stays pending
> until the next GETSIGINFO if any of these flags may have chagned" than
> "if XXX change from x to y, or YYY changes to x to y or y to x,
> ... blah blah".

Why do you want this data to be sticky at all?
Do you think tracer will "forget" to retrieve it?
That'd be a bug in the tracer if it doesn't retrieve the data
and therefore mishandles stop and/or cont.

>> Can we just add a "group cont" notification which looks like
>> a waitpid result with WIFCONTINUED(waitpid_status) == 1 to the tracer?
>
> Consider the following scenario.
>
> 1. A syscall traced tracee enters group stop while returning from a
>   syscall.  Tracer is notified.
>
> 2. SIGCONT generated.  Tracee is woken up and wait state is generated.
>
> 3. Tracee traps for syscall completion before tracer has chance to
>   wait(2).

The order in (3) seems wrong:
Tracee doesn't enter group stop while it is in syscall.
It exits syscall first, and then it enters group stop.
Therefore in step (3) above it can't "trap for syscall completion".
It can trap for syscall entry at worst; however:

> 4. Oops, continued wait state lost.

Why is it lost? Why kernel signals syscall entry instead of CONT
in your scenario?

Here's the example how stop and syscall tracing interact in current kernels:

sh -c 'echo $$; exec strace -tt -s999 -oLOG strace sleep 999'
kill -STOP 24655
kill -KILL 24655

inner strace prints:

nanosleep({999, 0}, NULL)               = ? ERESTART_RESTARTBLOCK (To
be restarted)
--- {si_signo=SIGSTOP, si_code=SI_USER, si_pid=24647, si_uid=0,
si_value={int=15, ptr=0xf}} (Stopped (signal)) ---
--- Stopped (signal) by SIGSTOP ---
restart_syscall(<... resuming interrupted call ...> <unfinished ...>
+++ killed by SIGKILL +++

inner strace's strace:

13:17:54.776431 write(2, "nanosleep({999, 0}, ", 20) = 20
13:17:54.776490 ptrace(PTRACE_SYSCALL, 24655, 0x1, SIG_0) = 0
13:17:54.776542 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
13:17:54.776591 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTRAP}],
__WALL, NULL) = 24655
13:18:02.430991 --- {si_signo=SIGCHLD, si_code=CLD_TRAPPED,
si_pid=24655, si_status=SIGTRAP, si_utime=0, si_stime=0} (Child
exited) ---
13:18:02.431238 write(2, "NULL)               = ?
ERESTART_RESTARTBLOCK (To be restarted)\n", 64) = 64
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
See? We got syscall exit notification *first*. And only now:

13:18:02.431369 ptrace(PTRACE_SYSCALL, 24655, 0x1, SIG_0) = 0
13:18:02.431461 --- {si_signo=SIGCHLD, si_code=CLD_TRAPPED,
si_pid=24655, si_status=SIGSTOP, si_utime=0, si_stime=0} (Child
exited) ---
13:18:02.431583 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
__WALL, NULL) = 24655
13:18:02.431737 ptrace(PTRACE_GETSIGINFO, 24655, 0, {si_signo=SIGSTOP,
si_code=SI_USER, si_pid=24647, si_uid=0, si_value={int=15, ptr=0xf}})
= 0
13:18:02.431871 write(2, "--- {si_signo=SIGSTOP, si_code=SI_USER,
si_pid=24647, si_uid=0, si_value={int=15, ptr=0xf}} (Stopped (signal))
---\n", 115) = 115
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...we got signal notification. We inject it:

13:18:02.431995 ptrace(PTRACE_SYSCALL, 24655, 0x1, SIGSTOP) = 0
13:18:02.432068 --- {si_signo=SIGCHLD, si_code=CLD_STOPPED,
si_pid=24655, si_status=SIGSTOP, si_utime=0, si_stime=0} (Child
exited) ---
13:18:02.432183 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
__WALL, NULL) = 24655
13:18:02.432338 ptrace(PTRACE_GETSIGINFO, 24655, 0, 0xbffc4fd8) = -1
EINVAL (Invalid argument)
13:18:02.432413 write(2, "--- Stopped (signal) by SIGSTOP ---\n", 36) = 36
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...and only now we got group stop notification. My point: ***we aren't
inside syscall***.
The rest isn't interesting (typical buggy handling of stop
notification in current strace/kernel):

13:18:02.432501 ptrace(PTRACE_SYSCALL, 24655, 0x1, SIGSTOP) = 0
13:18:02.432573 --- {si_signo=SIGCHLD, si_code=CLD_TRAPPED,
si_pid=24655, si_status=SIGTRAP, si_utime=0, si_stime=0} (Child
exited) ---
13:18:02.432697 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTRAP}],
__WALL, NULL) = 24655
13:18:02.432993 write(2, "restart_syscall(<... resuming interrupted
call ...>", 51) = 51
13:18:02.433089 ptrace(PTRACE_SYSCALL, 24655, 0x1, SIG_0) = 0
13:18:02.433237 wait4(-1, [{WIFSIGNALED(s) && WTERMSIG(s) ==
SIGKILL}], __WALL, NULL) = 24655
13:18:12.031145 --- {si_signo=SIGCHLD, si_code=CLD_KILLED,
si_pid=24655, si_status=SIGKILL, si_utime=0, si_stime=0} (Child
exited) ---
13:18:12.031297 write(2, " <unfinished ...>\n", 18) = 18
13:18:12.031422 write(2, "+++ killed by SIGKILL +++\n", 26) = 26
13:18:12.031670 gettid()                = 24654
13:18:12.031747 tgkill(24654, 24654, SIGKILL <unfinished ...>
13:18:12.031877 +++ killed by SIGKILL +++


> Note that generation of another trap can't be used to determine end of
> group stop.  It might already have been PTRACE_CONT'd.
>
> This happens because wait states don't queue and shows why edge (or
> instance) notifications are usually worse than level ones.  Think
> about RT signals which are jokes.

Can you describe your scenario in more details. I don't understand it.


>> > Re-trapping is used only for group stop and INTERRUPT traps.  If
>> > tracer wants to get notified about group stop, it either leaves tracee
>> > in the initial group stop trap or puts it into INTERRUPT trap.  When
>> > INTERRUPT trap is scheduled while tracee is already in a trap,
>>
>> Sane tracer has no need to do PTRACE_INTERRUPT on a tracee
>> which is already stopped (for whatever reason): it already knows
>> it's stopped, and why. PTRACE_INTERRUPT is useful to cleanly stop
>> _running_ tracees.
>
> 1. User wants to continue stopped task to investigate.

You mean like this? -
waitpid <---------------INTERRUPT
ptrace(GETSIGINFO)<-----"it's a group stop"
ptrace(CONT)----------->
...

> 2. Investigation done, now the user wants to wait for the end of group
>   stop which will happen externally.

You mean, continuing above example like this? -

case 1: tracee stops
...
ptrace(CONT)----------->
waitpid <---------------some ptrace stop
(tracer doesnt PTRACE_CONT! it wants to wait till SIGCONT)
waitpid <---------------...

case 2: tracee runs
...
ptrace(CONT)----------->
waitpid <---------------...

> 3. Regardless of the current trap tracee is in, debugger can schedule
>   INTERRUPT and be sure that tracee will trap into INTERRUPT without
>   returning to userland and that it will be notified of group stop
>   state changes.

Why tracer needs to schedule anything? As you see above,
at this point tracer is in waitpid anyway. It is ALREADY prepared
to get cont notification. It doesn't need to generate any extra
ptrace stops for that.

-- 
vda
