Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1C1NXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1C1NXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:23:22 -0400
Date: Mon, 28 Mar 2011 14:14:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
	interaction
Message-ID: <20110328121401.GA4099@redhat.com>
References: <1300874766-12941-1-git-send-email-tj@kernel.org> <20110323183837.GA27680@redhat.com> <20110325142630.GD1409@htj.dyndns.org> <20110326182554.GA24315@redhat.com> <20110328085824.GE16530@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328085824.GE16530@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Tejun Heo wrote:
>
> Hey,
>
> On Sat, Mar 26, 2011 at 07:25:54PM +0100, Oleg Nesterov wrote:
> > > Explicit wake_up_state() without kick_process() is okay there because
> > > if the code assumes that the tasks are guaranteed to pass through
> > > signal delivery path whenever event worthy of notification happens
> > > (either SIGNAL_STOP_STOPPED or group_stop_count is set).  PTRACE_CONT
> > > breaks that as the tracee could be running in userland and thus the
> > > solution is to add kick_process() as in signal_wake_up().
> > >
> > > Am I making any sense?
> >
> > Perhaps. This depends on how we define/implement the new behaviour.
> >
> > It is not clear to me what the new trap should actually do. And how.
> > Either way, prepare_signal(SIGCONT) should do something with the
> > ptraced threads, and this is what we should care about. Probably
> > we can set TIF_SIGPENDING if task_ptrace() is true.
> >
> > Anyway we should ensure SIGCONT can't race with detach.
>
> Hmmm... setting TIF_SIGPENDING and kicking the task to enter signal
> delivery path doesn't have any side effect when it's running in
> userland,

Yes. We should avoid the spurious TIF_SIGPENDING, if possible. But in
this case we don't care.

But, unless the thread is ptraced, it can't be running in userland,
why should we set TIF_SIGPENDING?

> > > * Before CLD_STOPPED notification for the incomplete-stop/cont
> > >   sequence can be made, recalc_sigpending() happens.
> > >
> > > * CLD_STOPPED notification is pending but TIF_SIGPENDING isn't set and
> > >   the task isn't in signal delivery path and can continue execution.
> >
> > This doesn't matter, or I misunderstood.
> >
> > We only add "SIGNAL_CLD_* | SIGNAL_STOP_CONTINUED" if we know there
> > is at least one thread in get_signal_to_deliver()->do_signal_stop()
> > paths. In this case we do not rely on TIF_SIGPENDING at all.
>
> We set SIGNAL_CLD_STOPPED if group_stop_count wasn't zero, ie. if
> group stop has initiated, which will be delivered as soon as any task
> enters signal delivery path.

Yes. And that task T has already called do_signal_stop() and it is
TASK_STOPPED.

> So, there's a path that we schedule a
> notification and doesn't enforce the delivery until something happens

prepare_signal(SIGCONT) wakes up all threads, including T. Once it
returns from do_signal_stop() to get_signal_to_deliver(), it will
check signal->flags.

> and a task in the group gets called into signal delivery path somehow,
> which is wrong.

Afaics, no. No need to force any thread to enter into the signal
delivery path. If group_stop_count != 0 (or SIGNAL_STOP_STOPPED is
set) there must be at least one thread which should _return_ to
get_signal_to_deliver() after wakeup.

No?

Oleg.

