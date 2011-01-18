Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1ARSmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:42:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61925 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1ARSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G7au9d8C7DaPw3/V3uNhac4GgV5XWL25RvjujoLPsX1ZpNKn176y/VaYAEnaoX/TLR
         ntbWP/cQ7yuT5xtrSebJPAefl/odQMAspjeSc0n+4mIj6ZQSxqRHPsCe5Z+wLcuhjWy7
         m5GOv4QaL0O1kP/LEnD9l/FSErLk4v5y3nQfk=
Date: Tue, 18 Jan 2011 19:42:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110118184234.GA1808@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20110117203459.GA32700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117203459.GA32700@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:34:59PM +0100, Oleg Nesterov wrote:
> On 11/08, Oleg Nesterov wrote:
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
> 
> Ping.
> 
> Any idea how to fix this cleanly? May be we can reuse perf_event_mutex,
> but this looks soooo ugly. And do_exit()->flush_ptrace_hw_breakpoint()
> has the strange "FIXME:" comment which doesn't help me to understand
> what can we do.

Yeah forget about the FIXME, it's a stale thing I need to remove.

> 
> Probably the best fix is to change this code so that the tracer owns
> ->ptrace_bps[], not the tracee. But this is not trivial, and needs a
> lot of changes in ptrace code.


How much complicated would it be?

Because I see three solutions to solve this:

- Have a mutex inside thread->ptrace_bps. The contention must be
rare and only concern ptrace and tracee exit. That's the simplest.

- Have an atomic refcount inside thread->ptrace_bps so that the actual
flush can be delayed until necessary. Same as above, but exit and ptrace
can execute concurrently, code must be a bit more complicated though.

- Your solution. I'm just not sure how much change it involves. Seems
like we need to notify the parent for it to flush the breakpoints
when a task exits. Same when ptrace detaches we need to flush.

What do you guys think? At a glance it seems a mutex or a refcount
would take more memory for each thread, but I can manage to have
->ptrace_bps a block only allocated if necessary. It would be only
a pointer if no breakpoint is queued.
