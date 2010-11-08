Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KHPDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:03:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0KHPDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:03:53 -0500
Date: Mon, 8 Nov 2010 15:57:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: sys_perf_event_open() && PF_EXITING
Message-ID: <20101108145725.GA3434@redhat.com>
References: <20101108145647.GA3426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145647.GA3426@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am puzzled by PF_EXITING check in find_lively_task_by_vpid().

How can it help? The task can call do_exit() right after the check.

And why do we need it? The comment only says "Can't attach events to
a dying task". Maybe it tries protect sys_perf_event_open() against
perf_event_exit_task_context(), but it can't.

c93f7669 "perf_counter: Fix race in attaching counters to tasks and
exiting" says:

    There is also a race between perf_counter_exit_task and
    find_get_context; this solves the race by moving the get_ctx that
    was in perf_counter_alloc into the locked region in find_get_context,
    so that once find_get_context has got the context for a task, it
    won't get freed even if the task calls perf_counter_exit_task.

OK, the code was changed since that commit, but afaics "it won't be
freed" is still true.

However,

    It
    doesn't matter if new top-level (non-inherited) counters get attached
    to the context after perf_counter_exit_task has detached the context
    from the task.  They will just stay there and never get scheduled in
    until the counters' fds get closed, and then perf_release will remove
    them from the context and eventually free the context.

This looks wrong. perf_release() does free_event()->put_ctx(), this pairs
get_ctx() after alloc_perf_context().

But __perf_event_init_context() sets ctx->refcount = 1, and I guess this
reference should be dropped by ctx->task ? If yes, then it is not OK to
attach the event after sys_perf_event_open().

No?


Hmm. jump_label_inc/dec looks obviously racy too. Say, free_event() races
with perf_event_alloc(). There is a window between atomic_xxx() and
jump_label_update(), afaics it is possible to call jump_label_disable()
when perf_task_events/perf_swevent_enabled != 0.

Oleg.

