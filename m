Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1BNSAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:00:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1BNSAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:00:21 -0500
Date: Mon, 14 Feb 2011 18:51:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214175144.GC15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Denys Vlasenko wrote:
>
> >> $ strace -tt sleep 30
> >> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
> >> ...
> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> >>     (I forgot again why we see it twice. Another quirk I guess...)
> >> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> >> 23:02:45.622433 close(1)                = 0
> >> 23:02:45.622743 close(2)                = 0
> >> 23:02:45.622885 exit_group(0)           = ?
> >>
> >> Why sleep didn't stop?
> >>
> >> Because PTRACE_SYSCALL brought the task out of group stop at once,
> >> even though strace did try hard to not do so:
> >>
> >>     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!
> >>
> >> PTRACE_CONT in this situation would do the same.
> >
> > This can be fixed by updating strace, right?  strace can look at the
> > wait(2) exit code and if the tracee stopped for group stop, wait for
> > the tracee to be continued instead of issuing PTRACE_SYSCALL.

Ah, I seem to understand the confusion, let me repeat...

> But tracee didn't stop _yet_.

This depends on "_yet_". strace does ptrace(SYSCALL, SIGSTOP) twice.
The first time it does this after the tracee reports the signal, and
the tracee stopps.

> Signal is not delivered _yet_, debugger
> can decide at this point whether to deliver it:
> ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
> or ignore:
> ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)
>
> strace has to deliver SIGSTOP if it wants to make program run exactly
> as it would run without strace. So it tries to do so.
> Currently, ptrace machinery doesn't react as strace, its user, expects it to.

It does, see above. But then the tracee actually stopps, and report
this to the tracer. However, strace handles this case as if this was
another signal=SIGSTOP, so it does ptrace(SYSCALL, SIGSTOP) again.

SIGSTOP has no effect, but PTRACE_SYSCALL wakeups the tracee.

> >> Why gdb can't use SIGCONT instead of PTRACE_CONT, just like every
> >> other tool which needs to resume stopped tasks?
> >
> > Because that's how PTRACE_CONT behaved the whole time.  It can but
> > just hasn't needed to.
>
> Jan, please put on your gdb maintainer's hat, we need your opinion here.
> Is it a problem from gdb's POV?

Yes, please ;)

Oleg.

