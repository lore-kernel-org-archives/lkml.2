Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0IYA3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:29:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0IYA3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:29:30 -0400
Subject: Re: kgdb segv in the latest tip due to perf ctx changes
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Jiri Olsa <jolsa@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4C9D0A82.5020406@windriver.com>
References: <20100924180417.GC1818@jolsa.brq.redhat.com>
	 <4C9D0A82.5020406@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 25 Sep 2010 02:29:20 +0200
Message-ID: <1285374560.2275.1054.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 15:30 -0500, Jason Wessel wrote:
> Jiri,
> 
> Can you try this simple patch which is attached?
> 
> 
> 
> On 09/24/2010 01:04 PM, Jiri Olsa wrote:
> > while starting kgdb early debug on latest tip tree,
> > I got SIGSEGV inside kernel in following location:
> >
> >   
> [clip]
> > I found out it's due to foolowing commit, that's causing the init code
> > to be called without the ctx field being defined...
> >
> > commit c3f00c70276d8ae82578c8b773e2db657f69a478
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Wed Aug 18 14:37:15 2010 +0200
> >
> >
> >   
> 
> I took a look at the tip core, and the ctx parameter is no longer passed
> into the perf_event_alloc() from perf_event_create_kernel_counter() kgdb
> no longer gets it filled in for free.
> 
> The reality is that kgdb never had a true context or a way to mark the
> hw breakpoint as a kernel only context for the hw breakpoint
> reservations.  The patch is only a short term fix perhaps until on of
> the perf guys explains the right way to use it. :-)

Argh, yes, its using the ctx rather early.. we cannot have a context
before we've initialized the event, and here it looks like hw_breakpoint
wants to use the context to initialize the event, chick, egg, etc..

Frederic, anything we can do about that?

> differences between files attachment
> (0001-Fix-null-dereference-when-using-early-kgdb.patch)
> From 17f3febd001a26aee9a75c61152b60b7e0ae1ea9 Mon Sep 17 00:00:00 2001
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Fri, 24 Sep 2010 15:21:11 -0500
> Subject: [PATCH] Fix null dereference when using early kgdb
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  kernel/hw_breakpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index 3b714e8..3c7ccdf 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
>  	       int weight)
>  {
>  	int cpu = bp->cpu;
> -	struct task_struct *tsk = bp->ctx->task;
> +	struct task_struct *tsk = bp->ctx ? bp->ctx->task : NULL;
>  
>  	/* Pinned counter cpu profiling */
>  	if (!tsk) {

That'll probably screw over some accounting, not sure what tsk is used
for there.
