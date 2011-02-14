Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1BNTKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:10:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1BNTKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:10:18 -0500
Date: Mon, 14 Feb 2011 20:01:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214190141.GA19221@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214175144.GC15847@redhat.com> <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Denys Vlasenko wrote:
>
> I tried to simply not do ptrace(PTRACE_SYSCALL, ..., 0) at all.
> Behavior changes, but it is still wrong. Now tracee doesn't wake up
> on SIGCONT.

please see below,

> 19:41:09.601764 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
> __WALL, NULL) = 25339
> 19:41:09.601914 rt_sigprocmask(SIG_BLOCK, [HUP INT QUIT PIPE TERM], NULL, 8) = 0
> 19:41:09.602081 ptrace(PTRACE_GETSIGINFO, 25339, 0, {si_signo=SIGSTOP,
> si_code=SI_USER, si_pid=10105, si_uid=0, si_value={int=0, ptr=0}}) = 0
> 19:41:09.602273 write(2, "--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> STOP: si_signo:19 si_code:0 si_status:0 si_value:(nil) \n", 99) = 99
> 19:41:09.602456 ptrace(PTRACE_SYSCALL, 25339, 0x1, SIGSTOP) = 0
> 19:41:09.602582 --- SIGCHLD (Child exited) @ 0 (0) ---
> 19:41:09.602652 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> 19:41:09.602792 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
> __WALL, NULL) = 25339

OK, it is stopped.

> 19:41:09.603081 ptrace(PTRACE_GETSIGINFO, 25339, 0, 0x7fff436fc730) =

And this changes the state to TASK_TRACED. See another email from me.
That is why SIGCONT doesn't work.

This is another problem, the kernel should help somehow. This was
already discussed a bit, but it is not clear what exactly we can do.

Oleg.

