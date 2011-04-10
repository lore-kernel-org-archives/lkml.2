Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1DJINV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 04:13:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1DJINQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 04:13:16 -0400
Subject: Re: [RFC][PATCH 5/9] perf: Simplify and fix
 __perf_install_in_context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
In-Reply-To: <20110409192141.870894224@chello.nl>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.870894224@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 10 Apr 2011 10:13:05 +0200
Message-ID: <1302423185.2388.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-09 at 21:17 +0200, Peter Zijlstra wrote:
> +       if (task_ctx) {
> +               task_ctx_sched_out(task_ctx);
> +               /*
> +                * If the context we're installing events in is not the
> +                * active task_ctx, flip them.
> +                */
> +               if (ctx->task && task_ctx != ctx) {
> +                       raw_spin_unlock(&cpuctx->ctx.lock);
> +                       raw_spin_lock(&ctx->lock);
> +                       cpuctx->task_ctx = task_ctx = ctx;
> +               }
> +               task = task_ctx->task;
> +       } 

That is actually buggy, it should read something like:

	if (task_ctx)
		task_ctx_sched_out(task_ctx);

	if (ctx->task && task_ctx != ctx) {
		raw_spin_unlock(&task_ctx->lock);
		raw_spin_lock(&ctx->lock);
		cpuctx->task_ctx = task_ctx = ctx;
	}

	if (task_ctx)
		task = task_ctx->task;

Aside from the trivial locking bug fixed, the previous version wouldn't
actually deal with installing a task_ctx where there was none before.
