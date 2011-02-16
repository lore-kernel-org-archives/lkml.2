Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1BPVwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:52:22 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:55839 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041Ab1BPVwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:52:18 -0500
Date: Wed, 16 Feb 2011 22:51:57 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110216215157.GA6054@host1.dyn.jankratochvil.net>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 18:20:52 +0100, Denys Vlasenko wrote:
> Jan, please put on your gdb maintainer's hat, we need your opinion here.
> Is it a problem from gdb's POV?

Here is a summary of current and my wished behavior:

Make PTRACE_DETACH (data=SIGSTOP) working - that is to leave the process in
`T (stopped)' without any single PC step.  This works in some kernels and
does not work in other kernels, it is "detach-stopped" test in:
cvs -d :pserver:anoncvs:anoncvs@sourceware.org:/cvs/systemtap co ptrace-tests 

The current upstream GDB trick of
  PTRACE_ATTACH
  if /proc/PID/status->State: == `T (stopped)'
    tgkill(SIGSTOP)
    PTRACE_CONT(0)
  waitpid->SIGSTOP (or preceded by some other signal but 1x SIGSTOP will come)
should remain compatible, as is implemented in:
http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/linux-nat.c.diff?r1=1.80&r2=1.81&cvsroot=src

Make the GDB trick above no longer needed, so that in the case it was invented
for a simple PTRACE_ATTACH, wait->SIGSTOP, PTRACE_DETACH(0) also works:
  foreign process: kill(child process, SIGSTOP)
  parent process:  wait() -> SIGSTOP (the notification is now eaten-out)
  child process is now in `T (stopped)'
  debugger: PTRACE_ATTACH(child process)
  debugger: waitpid -> should get SIGSTOP, even despite it was eaten-out above
This works in some kernels and does not work in other kernels.

A new proposal is to preserve the process's `T (stopped)' for
a naive/legacy debugger / ptrace tool doing PTRACE_ATTACH, wait->SIGSTOP,
PTRACE_DETACH(0), incl. GDB doing the "GDB trick" above.
That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
iff the process was `T (stopped)' before PTRACE_ATTACH.
 - PTRACE_DETACH(0)       should preserve `T (stopped)'.
but also:
 - PTRACE_DETACH(SIGSTOP) should force `T (stopped)'.
 - PTRACE_DETACH(SIGCONT) should force freely running process.


The behavior of SIGSTOP and SIGCONT received during active ptrace session
I find as a new feature without having much to keep backward compatibibility.
+
You have concluded a plan how to do a real `T (stopped)' on received SIGSTOP
using PTRACE_GETSIGINFO, OK, go with that.
+
Personally I would keep it completely hidden from the debugger and only
remember the last SIGCONT vs. SIGSTOP for the case the session ends with
PTRACE_DETACH(0).  Debugger/strace would not be able to display any externally
received SIGSTOP/SIGCONT.  PTRACE_CONT(SIGSTOP) and PTRACE_CONT(SIGCONT)
should behave as PTRACE_CONT(0) to clean up compatibility with existing tools.
For a general transparent tracing there is at least systemtap.


Thanks,
Jan
