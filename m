Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1BNRxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:53:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1BNRxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:53:31 -0500
Date: Mon, 14 Feb 2011 18:45:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214174503.GB15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214173012.GA18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110214173012.GA18742@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Tejun Heo wrote:
>
> On Mon, Feb 14, 2011 at 06:20:52PM +0100, Denys Vlasenko wrote:
> > >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> > >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> > >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> > >>     (I forgot again why we see it twice. Another quirk I guess...)
> > >> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> > >> 23:02:45.622433 close(1)                = 0
> > >> 23:02:45.622743 close(2)                = 0
> > >> 23:02:45.622885 exit_group(0)           = ?
> ...
> > > This can be fixed by updating strace, right?  strace can look at the
> > > wait(2) exit code and if the tracee stopped for group stop, wait for
> > > the tracee to be continued instead of issuing PTRACE_SYSCALL.
> >
> > But tracee didn't stop _yet_. Signal is not delivered _yet_, debugger
> > can decide at this point whether to deliver it:
> > ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
> > or ignore:
> > ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)
> >
> > strace has to deliver SIGSTOP if it wants to make program run exactly
> > as it would run without strace. So it tries to do so.
> > Currently, ptrace machinery doesn't react as strace, its user, expects it to.
>
> Okay, maybe I'm missing something but so once SIGSTOP is determined to
> be delivered, then the tracee enters group stop and that's the second
> SIGSTOP notification you get.

Yes, this is correct.

But my head spins ;) I have already lost the picture.

> At that point, strace should wait for
> the tracee to be continued by SIGCONT.  That should work, right?

Again, given that strace is the real parent, in this particular
case I think strace can work as you suggest.

Oleg.

