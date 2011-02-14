Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1BNPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:40:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1BNPkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:40:25 -0500
Date: Mon, 14 Feb 2011 16:31:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214153149.GB8761@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102132325.55353.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13, Denys Vlasenko wrote:
>
> On Wednesday 09 February 2011 15:18, Tejun Heo wrote:
> >
> > > > and I'm not really sure whether that's something worth achieving
> > > > at the cost of debugging capabilities especially when we don't _have_
> > > > to lose them.
> > >
> > > But we do not? I mean, at least this is not worse than the current
> > > behaviour.
> >
> > I think it's worse.  With your changes, debuggers can't diddle the
> > tasks behind group stop's back which the current users already expect.
>
> But this "diddling behind group stop's back" is exactly the current
> problem with stop signals.
>
> Here I try to stop a ptraced process:
>
> $ strace -tt sleep 30
> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
> ...
> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>     (I forgot again why we see it twice. Another quirk I guess...)

      (this is correct, the tracee reports the signal=SIGSTOP, then
       it reports it actually stopps with exit_code=SIGSTOP)

> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> 23:02:45.622433 close(1)                = 0
> 23:02:45.622743 close(2)                = 0
> 23:02:45.622885 exit_group(0)           = ?
>
> Why sleep didn't stop?

Yes. And I think this all should be fixed.

Although, depending on how we change the kernel, strace may need the
fixes too.

> Because PTRACE_SYSCALL brought the task out of group stop at once,
> even though strace did try hard to not do so:
>
>     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!

Yes.

(just to clarify, data=SIGSTOP has no effect when the tracee reports
 from do_signal_stop. iow, when it reports i-am-stopped)

But otherwise I agree, and that was my point too.

Oleg.

