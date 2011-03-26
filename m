Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1CZPfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:35:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:46958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1CZPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:35:42 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        oleg@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110324164436.GC1930@jolsa.brq.redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 16:37:48 +0100
Message-ID: <1301153868.2250.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 17:44 +0100, Jiri Olsa wrote:
> 
> Now here's what I think is happening..
> 
> - once an event is created by sys_perf_event_open, task context
>   is created and it stays even if the event is closed, until the task
>   is finished ... thats what I see in code and I assume it's correct

Correct, I recently spoke to someone interested in 'curing' that, but as
it stands that's how it is.

> - when the task opens event, perf_sched_events jump label is incremented
>   and following callbacks are started from scheduler
> 
>         __perf_event_task_sched_in
>         __perf_event_task_sched_out
> 
>   These callback *in/out set/unset cpuctx->task_ctx value to the task
>   context.

*nod*

> - close is called on event on CPU 0:
>         - the task is scheduled on CPU 0
>         - __perf_event_task_sched_in is called
>         - cpuctx->task_ctx is set
>         - perf_sched_events jump label is decremented and == 0
>         - __perf_event_task_sched_out is not called
>         - cpuctx->task_ctx on CPU 0 stays set
> 
> - exit is called on CPU 1:
>         - the task is scheduled on CPU 1
>         - perf_event_exit_task is called
>         - task_ctx_sched_out unsets cpuctx->task_ctx on CPU 1
>         - put_ctx destroys the context
> 
> - another call of perf_rotate_context on CPU 0 will use invalid
>   task_ctx pointer, and eventualy panic
> 
> 
> The attached workaround makes sure that the task_ctx is not set
> when the context is being removed.  As I said it's not ment to be
> fix. 

Still having somewhat of a cold, how does the below look?

(completely untested so far, will have to bang on your testcase a bit to
make it work).

---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..2a03cc4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1112,6 +1112,8 @@ static int __perf_remove_from_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
 	list_del_event(event, ctx);
+	if (cpuctx->task_ctx == event->ctx && !event->ctx->nr_active)
+		cpuctx->task_ctx = NULL;
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;


