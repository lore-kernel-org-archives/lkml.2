Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab1ERQtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab1ERQtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:49:45 -0400
Date: Wed, 18 May 2011 18:48:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 02/10] job control: introduce JOBCTL_TRAP_STOP and use
	it for group stop trap
Message-ID: <20110518164814.GA28848@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> This patch adds a new jobctl flag - JOBCTL_TRAP_STOP.  When set, it
> triggers a trap site, which behaves like group stop trap, in
> get_signal_to_deliver() before checking for pending signals.  While
> ptraced, do_signal_stop() doesn't stop itself.  It initiates group
> stop if requested and schedules JOBCTL_TRAP_STOP and returns, which
> makes its caller - get_signal_to_deliver() - to relock, check and
> enter the trap.

Heh. Starting from this patch, I think I will never understand this
code in details ;)

> Although this adds an unlock-relocking between checking of
> JOBCTL_STOP_PENDING and actually trapping for STOP, this doesn't
> affect correctness.

Well, I think it does affect. Although the problem is minor.

> ptrace_stop() already had conditional
> unlock-relocking

Yes, but ptrace_stop() can't send the CLD_STOPPED notfication before
the tracee is ready for do_wait(WNOHANG). Contrary, get_signal_to_deliver()
can if we race with SIGCONT.

> While at it, add proper function comment to do_signal_stop() and make
> it return bool.
> ...
>
> + * RETURNS:
> + * %false if group stop is already cancelled and nothing happened.  %true
> + * if participated in group stop.

Well, the traced task didn't participate yet... Nevermind.



So far I can't really understand why do we have both JOBCTL_TRAP_STOP and
and JOBCTL_TRAPPING... Please ignore, I didn't read other patches yet.


Hmm. And afaics there is a bug in do_signal_stop(), after
"[PATCH 6/9] job control: make task_clear_jobctl_pending() clear TRAPPING automatically"
->jobctl &= ~JOBCTL_STOP_SIGMASK is no longer safe. We can clear _TRAPPING
without wakeup.

Oleg.

