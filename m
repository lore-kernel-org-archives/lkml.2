Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0I3LmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:42:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0I3LmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:42:12 -0400
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jiri Olsa <jolsa@redhat.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20100925135532.GA5349@nowhere>
References: <20100924180417.GC1818@jolsa.brq.redhat.com>
	 <4C9D0A82.5020406@windriver.com> <1285374560.2275.1054.camel@laptop>
	 <20100925135532.GA5349@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:42:01 +0200
Message-ID: <1285846921.2144.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 15:55 +0200, Frederic Weisbecker wrote:

> > Frederic, anything we can do about that?
> 
> 
> 
> Jason's patch is partially good, it just lacks one place to handle.
> Jiri, can you test that?
> 
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index d71a987..d727c58 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -134,7 +134,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
>  		    enum bp_type_idx type)
>  {
>  	int cpu = bp->cpu;
> -	struct task_struct *tsk = bp->ctx->task;
> +	struct task_struct *tsk = bp->ctx ? bp->ctx->task : NULL;
>  
>  	if (cpu >= 0) {
>  		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
> @@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
>  	       int weight)
>  {
>  	int cpu = bp->cpu;
> -	struct task_struct *tsk = bp->ctx->task;
> +	struct task_struct *tsk = bp->ctx ? bp->ctx->task : NULL;
>  
>  	/* Pinned counter cpu profiling */
>  	if (!tsk) {

That's identical to writing *tsk = NULL;

You seem to be missing the detail that perf_event->ctx will _always_ be
NULL during pmu::event_init()


> > That'll probably screw over some accounting, not sure what tsk is used
> > for there.
> 
> 
> Nope it's ok. tsk is used to know if we are dealing with
> a task/cpu bound breakpoint or a cpu wide bound one.
> 
> If tsk ends up being NULL, it will think it's a cpu wide bound
> breakpoint, which it is in the case of kgdb breakpoints.

See above, there's currently no way to know that in pmu::event_init().

