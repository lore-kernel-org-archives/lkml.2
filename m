Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1CARW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:22:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1CARW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D/U3LXwhFv2KIVOOI2AeULLZn9266LB41P0G9zeiYrrHTULONJ9lbp7AqQ2ExnLCKR
         /kYMexKjkofPid2pdywL4bC8jYeD3uG96R43aqTDMWw4lNquyjSAI2Z+sCR7pC2Hzlhg
         Dq6P9WvzCLIbvWdRyvq+X/JqgBZa/sYfG8h5I=
MIME-Version: 1.0
In-Reply-To: <20110301170953.GB17933@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 1 Mar 2011 18:21:49 +0100
Message-ID: <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
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

On Tue, Mar 1, 2011 at 6:09 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Denys.
>
> On Tue, Mar 01, 2011 at 05:57:48PM +0100, Denys Vlasenko wrote:
>> > * jctl stop initiates when one of the stop signals is received and
>> >   completes when all the member tasks participate in the group stop,
>> >   where participation preciesly means that a member task stops in
>> >   do_signal_stop().  Any member task can only participate once in any
>> >   given group stop.  ptrace does NOT make any difference in this
>> >   regard.
>>
>> This proposal adds a new rule for handling of stop notification
>> by debuggers. Let's spell it out, because currently strace
>> doesn't act according to this new rule:
>>
>> "When waitpid indicates stop on a *stop* signal, then it may be either:
>> * a signal delivery (strace will inject this signal with PTRACE_SYSCALL(sig));
>> * or it may be a stop notification, in which case strace *must not*
>>   try to inject this signal (this would be a bug, it'd make task running).
>>   Instead, strace should just go back to waiting in waitpid().
>>
>> These two possibilities can be distinquished by querying
>> PTRACE_GETSIGINFO. On stop notifications, PTRACE_GETSIGINFO
>> errors out - stop notification is not a signal delivery
>> and therefore it has no siginfo."
>
> Hmmm... but the above also holds for the current kernel too.  That
> hasn't really changed and the current broken behavior - unconditional
> PTRACE_SYSCALL(sig) - will behave the same regardless of the proposed
> changes.

There is a different proposal under which current strace behavior
would be a correct one.

I'm not saying that I like that other proposal more -
I am saying that your proposal needs to specify whether strace
needs to be changed, and how exactly, to correctly handle
SIGSTOPs under this proposal.


>> > * However, PTRACE_DETACH should maintain the integrity of group stop.
>> >   After a tracee is detached, it should be in a state which is
>> >   conformant to the current jctl state.  If jctl stop is in effect,
>> >   the task should be put into TASK_STOPPED; otherwise, TASK_RUNNING.
>>
>> This means that without changes to gdb, this:
>>
>> # gdb -p pid_of_application_currently_in_jctl_stop
>> (gdb) print getpid()
>> (gdb) print show_me_your_internal_debug_dump()
>> (gdb) continue
>>
>> will make application run, whereas this:
>>
>> # gdb -p pid_of_application_currently_in_jctl_stop
>> (gdb) print getpid()
>> (gdb) print show_me_your_internal_debug_dump()
>> (gdb) quit
>>
>> will leave application stopped. This looks a bit inconsistent to me.
>>
>> Do you propose gdb to be chaged so that "continue" command
>> issues PTRACE_CONT only if gdb knows that application is not
>> in jctl stop?
>
> gdb can do whatever it wants to do but I don't think the above needs
> fixing.  In the first case, the user is explicitly telling gdb to
> continue the tracee, so it continues as it always has.

It does not look like that to me.

User attached to some process. User might be unaware that
the process is currently stopped (imagine a group of processes
which use SIGSTOP/SIGCONT in their normal interactions).

User peeked some state, and then wants to let process
continue whatever process was doing, but remain in the debugger.

What user did not know is that "whatever process was doing" =
"being stopped by SIGSTOP, waiting to be woken up".
Therefore, if "continue" makes process run, it does not
return process to whatever process was doing.

> In the latter
> case, the debugging session is over.  The tracee now should do
> whatever it's supposed to do.

It should do that in both cases.

-- 
vda
