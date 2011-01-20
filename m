Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1ATTi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:38:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1ATTi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:38:27 -0500
Date: Thu, 20 Jan 2011 20:30:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110120193033.GA13924@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119182141.GA12183@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Oleg Nesterov wrote:
>
> Also. I believe there are more problems in perf_install_event(), but
> I need to recheck.

Help! I can't believe it can be so trivially wrong, but otoh I can't
understand how this can be correct.

So, ignoring details and !task case, __perf_install_in_context() does:

	if (cpuctx->task_ctx || ctx->task != current)
		return;

	cpuctx->task_ctx = ctx;
	event_sched_in(event);

Stupid question, what if this task has already passed
perf_event_exit_task() and thus it doesn't have ->perf_event_ctxp[] ?
Given that perf_event_context_sched_out() does nothing if !ctx, who
will event_sched_out() this event?

OK, even if I am right this is trivial, we just need the additional
check.



But, it seems, there is another problem. Forget about the exiting,
I can't understand why we can trust current in the code above.
With __ARCH_WANT_INTERRUPTS_ON_CTXSW schedule() does:

	// sets cpuctx->task_ctx = NULL
	perf_event_task_sched_out();

	// enables irqs
	prepare_lock_switch();


	// updates current_task
	switch_to();

What if IPI comes in the window before switch_to() ?

(the same questions for __perf_event_enable).

Oleg.

