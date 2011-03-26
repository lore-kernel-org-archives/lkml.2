Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1CZSfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1CZSfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:35:46 -0400
Date: Sat, 26 Mar 2011 19:25:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
	interaction
Message-ID: <20110326182554.GA24315@redhat.com>
References: <1300874766-12941-1-git-send-email-tj@kernel.org> <20110323183837.GA27680@redhat.com> <20110325142630.GD1409@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325142630.GD1409@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 03/25, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Wed, Mar 23, 2011 at 07:38:37PM +0100, Oleg Nesterov wrote:
> > But of course we need more changes. In particular, there is still the
> > small problem with the CLD_CONTINUED notification.
> >
> > __ptrace_unlink() does signal_wake_up() if it adds SIGNAL_STOP_STOPPED.
> > This is correct, but it should also add TIF_SIGPENDING if
> > (signal->flags & SIGNAL_CLD_MASK) != 0.
> >
> > Otherwise, if the stopped tracee was PTRACE_CONT'ed and then SIGCONT
> > ends the group-stop, the real_parent won't be notified after detach.
>
> Heh, that's an interesting one.  I don't think it has much to do with
> __ptrace_unlink() tho.  Isn't the proper solution using something akin
> to signal_wake_up() in SIGCONT generation path in prepare_signal()?

I am not sure... but please see below.

> Explicit wake_up_state() without kick_process() is okay there because
> if the code assumes that the tasks are guaranteed to pass through
> signal delivery path whenever event worthy of notification happens
> (either SIGNAL_STOP_STOPPED or group_stop_count is set).  PTRACE_CONT
> breaks that as the tracee could be running in userland and thus the
> solution is to add kick_process() as in signal_wake_up().
>
> Am I making any sense?

Perhaps. This depends on how we define/implement the new behaviour.

It is not clear to me what the new trap should actually do. And how.
Either way, prepare_signal(SIGCONT) should do something with the
ptraced threads, and this is what we should care about. Probably
we can set TIF_SIGPENDING if task_ptrace() is true.

Anyway we should ensure SIGCONT can't race with detach.

> > Unfortunately, this means that recalc_sigpending_tsk() has to check
> > SIGNAL_CLD_MASK as well. Do you see another solution?
>
> Hmmm... I think the above subtle breakage exists for !ptrace case too.
> Please consider the following scenario.
>
> * SIGSTOP is sent to a task and group stop is initiated.
>
> * Before the task participates in group stop, SIGCONT is sent.

In this case we are doing nothing intentionally, as if SIGSTOP wasn't
sent.

> * Before CLD_STOPPED notification for the incomplete-stop/cont
>   sequence can be made, recalc_sigpending() happens.
>
> * CLD_STOPPED notification is pending but TIF_SIGPENDING isn't set and
>   the task isn't in signal delivery path and can continue execution.

This doesn't matter, or I misunderstood.

We only add "SIGNAL_CLD_* | SIGNAL_STOP_CONTINUED" if we know there
is at least one thread in get_signal_to_deliver()->do_signal_stop()
paths. In this case we do not rely on TIF_SIGPENDING at all.


(just in case, I am ignoring the current problems with group-stop
 and PTRACE_CONT).

Oleg.

