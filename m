Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0KHTYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0KHTYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:24:42 -0500
Date: Mon, 8 Nov 2010 20:18:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20101108191813.GA15223@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108184057.GB5375@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108184057.GB5375@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Frederic Weisbecker wrote:
>
> On Mon, Nov 08, 2010 at 03:56:47PM +0100, Oleg Nesterov wrote:
> > Hello.
> >
> > I am trying to understand the usage of hw-breakpoints in arch_ptrace().
> > ptrace_set_debugreg() and related code looks obviously racy. Nothing
> > protects us against flush_ptrace_hw_breakpoint() called by the dying
> > tracee. Afaics we can leak perf_event or use the already freed memory
> > or both.
> >
> > Am I missed something?
> >
> > Looking into the git history, I don't even know which patch should be
> > blamed (if I am right), there were too many changes. I noticed that
> > 2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
> > search into helper" moved the PF_EXITING check from find_get_context().
> > This check coould help if sys_ptrace() races with SIGKILL, but it was
> > racy anyway.
> >
> > It is not clear to me what should be done. Looking more, I do not
> > understand the scope of perf_event/ctx at all, sys_perf_event_open()
> > looks wrong too, see the next email I am going to send.
> >
> > Oleg.
>
> But I don't understand how ptrace_set_debugreg() and flush_old_exec() can
> happen at the same time.

This can't happen. But I meant do_exit()->flush_ptrace_hw_breakpoint()

> The parent can only do the ptrace request when
> the child is stopped, right?

Yes. But nothing can "pin" TASK_TRACED.

We know that a) the tracee was stopped() when sys_ptrace() was called
and b) its task_struct can't go away. That is all. The tracee can be
killed at any moment, and sys_ptrace() can race with with
flush_ptrace_hw_breakpoint().

> I am certainly missing something obvious.

Perhaps ;) Or, it is quite possible I missed something, I never read
this code before and it is certainly not trivial.

Oleg.

