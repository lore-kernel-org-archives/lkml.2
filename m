Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab1CARJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:09:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab1CARJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:09:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mdSOhXZj/C+dqOmEGrIcDzYMZU/y+LKfuo4WO5IxXQqVYpEJbdiM4mEukkf/p5FCxm
         YWUw1TeO1yh0/OhIxZOFEiBa/T38SuAORw51aAeOb4nL0qdl7HDQ6NK/7lCSm4Ww6AFx
         gQQlWJ74v1zcWl9/oODNhfGN8CC0Yi5Y98eF0=
Date: Tue, 1 Mar 2011 18:09:53 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110301170953.GB17933@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103011757.48593.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Tue, Mar 01, 2011 at 05:57:48PM +0100, Denys Vlasenko wrote:
> > * jctl stop initiates when one of the stop signals is received and
> >   completes when all the member tasks participate in the group stop,
> >   where participation preciesly means that a member task stops in
> >   do_signal_stop().  Any member task can only participate once in any
> >   given group stop.  ptrace does NOT make any difference in this
> >   regard.
> 
> This proposal adds a new rule for handling of stop notification
> by debuggers. Let's spell it out, because currently strace
> doesn't act according to this new rule:
> 
> "When waitpid indicates stop on a *stop* signal, then it may be either:
> * a signal delivery (strace will inject this signal with PTRACE_SYSCALL(sig));
> * or it may be a stop notification, in which case strace *must not*
>   try to inject this signal (this would be a bug, it'd make task running).
>   Instead, strace should just go back to waiting in waitpid().
> 
> These two possibilities can be distinquished by querying
> PTRACE_GETSIGINFO. On stop notifications, PTRACE_GETSIGINFO
> errors out - stop notification is not a signal delivery
> and therefore it has no siginfo."

Hmmm... but the above also holds for the current kernel too.  That
hasn't really changed and the current broken behavior - unconditional
PTRACE_SYSCALL(sig) - will behave the same regardless of the proposed
changes.

The difference would be that if you implement the above on the current
kernel, there will be no way to tell when the job control stop ends,
so the current broken behavior seems to be justified.

> This is easy to implement (in strace at least).

Yeay!

> > * However, PTRACE_DETACH should maintain the integrity of group stop.
> >   After a tracee is detached, it should be in a state which is
> >   conformant to the current jctl state.  If jctl stop is in effect,
> >   the task should be put into TASK_STOPPED; otherwise, TASK_RUNNING.
> 
> This means that without changes to gdb, this:
> 
> # gdb -p pid_of_application_currently_in_jctl_stop
> (gdb) print getpid()
> (gdb) print show_me_your_internal_debug_dump()
> (gdb) continue
> 
> will make application run, whereas this:
> 
> # gdb -p pid_of_application_currently_in_jctl_stop
> (gdb) print getpid()
> (gdb) print show_me_your_internal_debug_dump()
> (gdb) quit
> 
> will leave application stopped. This looks a bit inconsistent to me.
> 
> Do you propose gdb to be chaged so that "continue" command
> issues PTRACE_CONT only if gdb knows that application is not
> in jctl stop?

gdb can do whatever it wants to do but I don't think the above needs
fixing.  In the first case, the user is explicitly telling gdb to
continue the tracee, so it continues as it always has.  In the latter
case, the debugging session is over.  The tracee now should do
whatever it's supposed to do.  I don't see any conflict there.  In
fact, with the recent removal of the unditional extra
wake_up_process() from ptrace detach, you're already likely to see the
above behavior (it isn't deterministic tho).

Thanks.

-- 
tejun
