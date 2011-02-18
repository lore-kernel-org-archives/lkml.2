Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1BRVet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:34:49 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:42302 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962Ab1BRVer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:34:47 -0500
Date: Fri, 18 Feb 2011 22:34:29 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110218213429.GB2066@host1.dyn.jankratochvil.net>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110216215157.GA6054@host1.dyn.jankratochvil.net>
 <20110217164906.GA5167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217164906.GA5167@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 17:49:06 +0100, Oleg Nesterov wrote:
> > - that is to leave the process in
> > `T (stopped)' without any single PC step.
> 
> This is not exactly clear to me... I mean "without any single PC step".
> Why?

Engineers investigating problems of applications SIGSTOP it when it is in the
critical situation.  Then they run gcore, gstack etc.  After they are
satisfied with the analsysis they send SIGCONT.

If the application being investigated changes state between the various tools
it may be confusing as the dumps will not match.  Ale in some cases some
critical state being investigated may get lost.


> > A new proposal is to preserve the process's `T (stopped)' for
> > a naive/legacy debugger / ptrace tool doing PTRACE_ATTACH, wait->SIGSTOP,
> > PTRACE_DETACH(0), incl. GDB doing the "GDB trick" above.
> > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > iff the process was `T (stopped)' before PTRACE_ATTACH.
> >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
> 
> Hmm. OK, but I assume you meant "unless the tracee was resumed in between".

You described the exact behavior of current Fedora/RHEL gdb.  But in general
I do not insist on it, one can for example run an inferior function call
during the investigation-under-SIGSTOP described above, even in such case one
still wants to detach the application still in the `T (stopped)' mode.

Detaching process as '(T) stopped' is not such a problem as the app/user can
send SIGCONT to it.  But accidentally unstopping the process during detach
cannot be fixed/workarounded.


> But. Let me remind. PTRACE_DETACH(SIGXXX) does not always work as
> gdb thinks, SIGXXX can be ignored.

In such case it is a bug.  Due to this bug there is probably the
tgkill(SIGSTOP)+PTRACE_DETACH(0) used by the "detach-stopped-rhel5"
ptrace-testsuite testfile, IIUC.


> > Personally I would keep it completely hidden from the debugger and only
> > remember the last SIGCONT vs. SIGSTOP for the case the session ends with
> > PTRACE_DETACH(0).  Debugger/strace would not be able to display any externally
> > received SIGSTOP/SIGCONT.  PTRACE_CONT(SIGSTOP) and PTRACE_CONT(SIGCONT)
> > should behave as PTRACE_CONT(0) to clean up compatibility with existing tools.
> 
> Can't understand... could you explain?

A process is not in the `T (stopped)' state randomly.  AFAIK it is there due
to an engineer sending it SIGSTOP.  Applications themselves do not use SIGSTOP
themselves to get into `T (stopped)' during their execution.

And if the engineer sent SIGSTOP it was intentional.  The engineer does not
want some tool to accidentally cancel his intentional SIGSTOP.  When the
engineer decides so (s)he can send SIGCONT appropriately.

SIGSTOP I find as a hard stop and thus even the tracers/debuggers of
the `T (stopped)' process should just get no response from it.  I do not think
ptrace is a good tool for some general system monitoring - to see any
SIGCONT/SIGSTOP deliveries - because ptrace is (a) single-master limited
(second PTRACE_ATTACH gets EPERM) and (b) ptrace-control is not transparent
due to the threads/races timing (on `t (tracing stop)').  For global system
tracing incl. the SIGCONT/SIGSTOP deliveries there are more suitable the fully
transparent tools like systemtap.

Therefore if the debugger sends some SIGSTOP/SIGCONT those should be rather
ignored for compatibility reasons as they may be either just bogus or used as
workarounds (such as in the FSF GDB PTRACE_ATTACH-SIGSTOP-trick) of ptrace
bugs which should no longer be needed.



Thanks,
Jan
