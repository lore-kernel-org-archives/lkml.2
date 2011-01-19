Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1ASPpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:45:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab1ASPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:45:41 -0500
Date: Wed, 19 Jan 2011 16:37:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110119153746.GA32563@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20110117203459.GA32700@redhat.com> <20110118184234.GA1808@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118184234.GA1808@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Frederic Weisbecker wrote:
>
> On Mon, Jan 17, 2011 at 09:34:59PM +0100, Oleg Nesterov wrote:
> >
> > Any idea how to fix this cleanly? May be we can reuse perf_event_mutex,
> > but this looks soooo ugly. And do_exit()->flush_ptrace_hw_breakpoint()
> > has the strange "FIXME:" comment which doesn't help me to understand
> > what can we do.
>
> Yeah forget about the FIXME, it's a stale thing I need to remove.

OK, good.

> > Probably the best fix is to change this code so that the tracer owns
> > ->ptrace_bps[], not the tracee. But this is not trivial, and needs a
> > lot of changes in ptrace code.
>
> How much complicated would it be?

The problem is, ptrace_detach/release_task can't sleep currently.
The necessary changes are nasty.

> Because I see three solutions to solve this:
>
> - Have a mutex inside thread->ptrace_bps. The contention must be
> rare and only concern ptrace and tracee exit. That's the simplest.

I think we can reuse perf_event_mutex for this. Not very good too,
but simple. But this depends on what can we do under this mutex...

I am going to report a couple more bugs (at least, it looks like
a bug when I am trying to understand the code ;), probably they
should be fixed first.

Oleg.

