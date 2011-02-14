Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1BNQX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:23:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1BNQXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:23:23 -0500
Date: Mon, 14 Feb 2011 17:15:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214161515.GA11605@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214151340.GP18742@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Tejun Heo wrote:
>
> Hello, Denys.
>
> On Sun, Feb 13, 2011 at 11:25:55PM +0100, Denys Vlasenko wrote:
>
> > $ strace -tt sleep 30
> > 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
> > ...
> > 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> > 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> > 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> >     (I forgot again why we see it twice. Another quirk I guess...)
> > 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> > 23:02:45.622433 close(1)                = 0
> > 23:02:45.622743 close(2)                = 0
> > 23:02:45.622885 exit_group(0)           = ?
> >
> > Why sleep didn't stop?
> >
> > Because PTRACE_SYSCALL brought the task out of group stop at once,
> > even though strace did try hard to not do so:
> >
> >     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!
> >
> > PTRACE_CONT in this situation would do the same.
>
> This can be fixed by updating strace, right?  strace can look at the
> wait(2) exit code and if the tracee stopped for group stop, wait for
> the tracee to be continued instead of issuing PTRACE_SYSCALL.

Yes, in this particular case strace could be more clever.

But. The tracee should react to SIGCONT after that, this means we
shouldn't "delay" this stop or force the TASK_TRACED state.

And note that in this case real_parent == debugger. Another case
is more interesting, and this means we shouldn't delay or hide the
notifications.

(I just tried to summarize the previous discussion for Denys)

> > Why gdb can't use SIGCONT instead of PTRACE_CONT, just like every
> > other tool which needs to resume stopped tasks?
>
> Because that's how PTRACE_CONT behaved the whole time.

Unfortunately, this is true.

Oleg.

