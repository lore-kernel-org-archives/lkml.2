Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1CYTTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab1CYTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:19:49 -0400
Date: Fri, 25 Mar 2011 20:10:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110325191034.GA26454@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324164436.GC1930@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Jiri Olsa wrote:
>
> - close is called on event on CPU 0:
> 	- the task is scheduled on CPU 0
> 	- __perf_event_task_sched_in is called
> 	- cpuctx->task_ctx is set
> 	- perf_sched_events jump label is decremented and == 0
> 	- __perf_event_task_sched_out is not called
> 	- cpuctx->task_ctx on CPU 0 stays set

I think you are right.

And this is already wrong afaics, even if we add the workaround into
free_ctx/etc.

For example, suppose that we attach another PERF_ATTACH_TASK counter
to this task later. perf_sched_events will be incremented again, but
perf_install_in_context() should hang retrying until this task runs
again, ->is_active == T.

Or, even if sys_perf_event_open() succeeds the next
perf_event_context_sched_in() will do nothing because it checks
cpuctx->task_ctx != ctx (unless another task has a counter and
schedules in on that CPU).

This should be fixed somehow, but so far I have no ideas.

Oleg.

