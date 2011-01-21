Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1AUSSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:18:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:54609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1AUSSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:18:08 -0500
Subject: Re: perf_events: question about __perf_event_read()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
References: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 19:18:45 +0100
Message-ID: <1295633925.28776.308.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 19:06 +0100, Stephane Eranian wrote:
> Hi,
> 
> I think the code below still has a problem in case of a per-cpu event.
> 
> If you issue a read() on a different CPU, then you IPI to the event's cpu.
> By the time you get there, the event may be de-scheduled in which
> case you don't want to issue event->pmu_read() nor update context
> timings. The function has a test but it seems to be checking the per-cpu
> case only.
> 
> I have seen panics on P4 with this code because it goes all the way
> down to rdmsrl() with a bogus counter index (like -1).
> 
> Am I missing something here?
> 
> static void __perf_event_read(void *info)
> {
>         struct perf_event *event = info;
>         struct perf_event_context *ctx = event->ctx;
>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
> 
>         /*
>          * If this is a task context, we need to check whether it is
>          * the current task context of this cpu.  If not it has been
>          * scheduled out before the smp call arrived.  In that case
>          * event->count would have been updated to a recent sample
>          * when the event was scheduled out.
>          */
>         if (ctx->task && cpuctx->task_ctx != ctx)
>                 return;
> 
>         raw_spin_lock(&ctx->lock);

Shouldn't we re-check event->state once we hold this lock?

>         update_context_time(ctx);
>         update_event_times(event);
>         raw_spin_unlock(&ctx->lock);
> 
>         event->pmu->read(event);
> }


