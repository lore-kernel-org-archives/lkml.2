Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1ASStY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:49:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:56060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1ASStX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:49:23 -0500
Subject: Re: [PATCH 1/2] perf: fix find_get_context() vs
 perf_event_exit_task() race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110119182207.GB12183@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
	 <20110119182207.GB12183@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 19:49:43 +0100
Message-ID: <1295462983.28776.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 19:22 +0100, Oleg Nesterov wrote:
> find_get_context() must not install the new perf_event_context if the
> task has already passed perf_event_exit_task().
> 
> If nothing else, this means the memory leak. Initially ctx->refcount == 2,
> it is supposed that perf_event_exit_task_context() should participate and
> do the necessary put_ctx().
> 
> find_lively_task_by_vpid() checks PF_EXITING but this buys nothing, by the
> time we call find_get_context() this task can be already dead. To the point,
> cmpxchg() can succeed when the task has already done the last schedule().
> 
> Change find_get_context() to populate task->perf_event_ctxp[] under
> task->perf_event_mutex, this way we can trust PF_EXITING because
> perf_event_exit_task() takes the same mutex.
> 
> Also, change perf_event_exit_task_context() to use rcu_dereference().
> Probably this is not strictly needed, but with or without this change
> find_get_context() can race with setup_new_exec()->perf_event_exit_task(),
> rcu_dereference() looks better.

I think initially the idea was that this race couldn't happen because by
that time we would be unhashed from the pidhash and thus invisible for
new events, however from what I can make from the exit path we get
unhashed in exit_notify() which is _after_ perf_event_exit_task(), so
yes this looks to be a proper fix.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
