Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2IDPhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab2IDPhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:37:14 -0400
Date: Tue, 4 Sep 2012 17:39:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC] semantics of singlestepping vs. tracer exiting
Message-ID: <20120904153938.GA8199@redhat.com>
References: <20120903001436.GG23464@ZenIV.linux.org.uk> <20120903160538.GA10114@redhat.com> <20120903173108.GH23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903173108.GH23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Al Viro wrote:
>
> On Mon, Sep 03, 2012 at 06:05:38PM +0200, Oleg Nesterov wrote:
>
> > This is not easy to fix. ptrace_disable() and user_disable_single_step()
> > is arch dependant, but at least on x86 it assumes that the tracee is not
> > running, so exit_ptrace() can't do this.
>
> True (IOW, proposed fix is hopeless - we definitely want the detachees to be
> in kernel space, and not only on x86).

And, once again, even if we could play with the running task, this
can't help in general. For example, the tracer can exit just before
the tracee dequeues SIGTRAP.

We can only makes the things a bit better.

> > > 	Related question: should execve(2) clear (ptrace-inflicted)
> > > singlestepping?
> >
> > Perhaps, but
> >
> > > Tracer
> > > exit(), however, does *not* do that right now, so the state after
> > > execve(2) is theoretically observable.
> >
> > ... why execve() is special?
>
> Because that behaviour had been changed over the history, for one thing:
> commit e1f287735c1e58c653b516931b5d3dd899edcb77
> Author: Roland McGrath <roland@redhat.com>
> Date:   Wed Jan 30 13:30:50 2008 +0100
>
>     x86 single_step: TIF_FORCED_TF
> had done that for x86, unless I'm misreading something.

Still can't understand what do you mean :/

Yes, if the tracer exits while the tracee does exec with TIF_SINGLESTEP
the tracee will be killed by SIGTRAP, but this doesn't differ from any
other syscall? The only difference is that start_thread() always clears
X86_EFLAGS_TF, but this doesn't matter.

And I do not think this commit actually changed this behaviour, although
I can be easily wrong. Yes, before this patch PT_DTRACE was cleared after
do_execve() but this doesn't prevent do_debug()->force_sig_info(SIGTRAP)
afaics, the comment in traps_64.c was wrong.

_Perhaps_ this was changed by be61bff7
"x86_64: Some fixes for single step handling"

	@@ -688,8 +688,14 @@ asmlinkage void *do_debug(struct pt_regs * regs, unsigned long error_code)
			 */
			 if ((regs->cs & 3) == 0)
				goto clear_TF_reenable;
	-		if ((tsk->ptrace & (PT_DTRACE|PT_PTRACED)) == PT_DTRACE)
	-			goto clear_TF;
	+		/*
	+		 * Was the TF flag set by a debugger? If so, clear it now,
	+		 * so that register information is correct.
	+		 */
	+		if (tsk->ptrace & PT_DTRACE) {
	+			regs->eflags &= ~TF_MASK;
	+			tsk->ptrace &= ~PT_DTRACE;
	+		}
		}
	 
		/* Ok, finally something we can handle */

It seems that before this patch do_debug() tried to avoid SIGTRAP if
the tracer has died, but I bet this logic was buggy in any case.

Now that we have TIF_FORCED_TF we can add the "right" check to detect
this case, but again this can't help if the tracer dies after this
check.


> BTW, now that
> I've looked at that, alpha

Just in case, of course I know nothing about this code and I see it
the first time ;)

> seems to have a really unpleasant bug with
> single-stepping through execve() - it *must* reset ->bpt_nsaved to 0
> in start_thread(), simply because the address space the breakpoints used
> to be in is gone at that point.  I don't see any place where that would
> be done; suppose we single-step right into callsys insn

in this case user_enable_single_step() sets ->bpt_nsaved = -1,

> and do PTRACE_CONT
> when stopped on the way out.  Won't that end up with ptrace_cancel_bpt()
> done in *new* address space, silently buggering new .text contents?

so ptrace_cancel_bpt() just resets ->bpt_nsaved = 0 and returns true.

> BTW, speaking of alpha, what about PTRACE_SINGLESTEP when the task is stopped
> on syscall entry/exit after previous PTRACE_SYSCALL, BTW?  Looks like it will
> be like PTRACE_CONT until we hit the first signal, at which point it converts
> to singlesteping mode; unless I'm seriously misreading that code, we rely
> on ptrace_set_bpt() done shortly after returning from get_signal_to_deliver()
> if we found that we'd been singlestepping.  Fine, but in this case we
> had been resumed *not* in get_signal_to_deliver()...

Again, "single_stepping |= ptrace_cancel_bpt()" after get_signal_to_deliver()
should work I think... Not sure.

Oleg.

