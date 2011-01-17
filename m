Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1AQUms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1AQUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:42:45 -0500
Date: Mon, 17 Jan 2011 21:34:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110117203459.GA32700@redhat.com>
References: <20101108145647.GA3426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145647.GA3426@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Oleg Nesterov wrote:
>
> I am trying to understand the usage of hw-breakpoints in arch_ptrace().
> ptrace_set_debugreg() and related code looks obviously racy. Nothing
> protects us against flush_ptrace_hw_breakpoint() called by the dying
> tracee. Afaics we can leak perf_event or use the already freed memory
> or both.
>
> Am I missed something?
>
> Looking into the git history, I don't even know which patch should be
> blamed (if I am right), there were too many changes. I noticed that
> 2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
> search into helper" moved the PF_EXITING check from find_get_context().
> This check coould help if sys_ptrace() races with SIGKILL, but it was
> racy anyway.

Ping.

Any idea how to fix this cleanly? May be we can reuse perf_event_mutex,
but this looks soooo ugly. And do_exit()->flush_ptrace_hw_breakpoint()
has the strange "FIXME:" comment which doesn't help me to understand
what can we do.

Probably the best fix is to change this code so that the tracer owns
->ptrace_bps[], not the tracee. But this is not trivial, and needs a
lot of changes in ptrace code.


I am reading perf_event.c, but all I found so far is a couple of trivial
methods to crash the kernel via sys_perf_event_open(), will report
tomorrow...

Oleg.

