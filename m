Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1F0OXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1F0OXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:23:37 -0400
Date: Mon, 27 Jun 2011 16:21:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110627142136.GA5812@redhat.com>
References: <20110622210757.GA20549@redhat.com> <20110622210834.GC20549@redhat.com> <20110623122253.GM30101@htj.dyndns.org> <20110623132126.GA10410@redhat.com> <20110623132754.GO30101@htj.dyndns.org> <20110623132831.GA11453@redhat.com> <20110623170650.GA14601@redhat.com> <20110625141553.GX30101@htj.dyndns.org> <20110626205157.GB16293@redhat.com> <20110627082443.GA30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627082443.GA30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/27, Tejun Heo wrote:
>
> On Sun, Jun 26, 2011 at 10:51:57PM +0200, Oleg Nesterov wrote:
> > > Yeap, we've discussed this before and this indeed is odd.  However, is
> > > there something ptracer can't do with PTRACE_EVENT_EXIT instead?
> >
> > Firstly, I think PTRACE_EVENT_EXIT should not stop the tracee if it
> > was SIGKILL'ed. Even if the tracee stops, it can be killed later.
> > The tracer can't detach after that, it can't even wait() to detecte
> > a zombie leader.
>
> For SIGKILL, yes, it is different, but if PTRACE_EVENT_EXIT is enough
> for all other cases, I think we're mostly set.

I think this is not that simple. I already mentioned this before, I think
we need a separate discussion. I'll try to return to this in a few days.

Firstly, we should decide when PTRACE_EVENT_EXIT should stop, and when it
shouldn't. In this discussion I'll assume sys_exit_group() should respect
PTRACE_EVENT_EXIT.

> BTW, it seems like we
> would actually stop at PTRACE_EVENT_EXIT even after SIGKILL. This is
> wrong & racy.

Yes! because the tracee can call ptrace_stop() after the pending SIGKILL
was already dequeued from task->pending, this fools
schedule()->signal_pending_state().

So, __fatal_signal_pending() is too "weak",

> may_ptrace_stop() should be checking for
> sigkill_pending(), right?

Yes, but at the same time even __fatal_signal_pending() is too strong!
What if the tracee exits on its own, and its sys_exit() races with
exit_group() from another thread? In this case I think it should stop,
but __fatal_signal_pending() is true.


And worse. What if the tracee stops in PTRACE_EVENT_EXIT, and _then_
another thread does sys_exit_group()? The tracee will be "killed".
I do not think this is right. I think the "implicit" SIGKILL in this
case should _not_ wake up the tracee. Only the real SIGKILL (or any
fatal signal which mutates to SIGKILL). Otherwise we simply can't
guarantee PTRACE_EVENT_EXIT works "reliably" in this case.


We have signal_group_exit()/SIGNAL_GROUP_EXIT. I think we also need
SIGNAL_THE_REAL_SIGKILL_WAS_SENT flag. Note also we have the similar
problems with the coredump. SIGKILL should abort it. Also, we should
define what TIF_SIGPENDIND and interruptible wait mean after exit_signals()
and/or exit_notify(). Some drivers (tty? I do not remember) expect that
the exiting task can do wait_event_interruptible() and react to ^C.



> I don't have
> any major problem with the original.  Please go ahead.

Thanks. Can I add your reviewed-by/acked-by ?

Oleg.

