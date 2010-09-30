Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0I3LjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:39:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:47100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0I3LjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:39:03 -0400
Subject: Re: [PATCH 1/5] perf: Wrap perf_lock_task_context using
 __cond_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285583997-1262-2-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
	 <1285583997-1262-2-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:38:49 +0200
Message-ID: <1285846729.2144.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 19:39 +0900, Namhyung Kim wrote:
> perf_lock_task_context() conditionally grabs ctx->lock in case of
> returning non-NULL. Rename and wrap it using __cond_lock to make
> sparse happy.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/perf_event.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index db5b560..c058a42 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -151,7 +151,7 @@ static u64 primary_event_id(struct perf_event *event)
>   * the context could get moved to another task.
>   */
>  static struct perf_event_context *
> -perf_lock_task_context(struct task_struct *task, unsigned long *flags)
> +__perf_lock_task_context(struct task_struct *task, unsigned long *flags)
>  {
>  	struct perf_event_context *ctx;
>  
> @@ -184,6 +184,14 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
>  	return ctx;
>  }
>  
> +static inline struct perf_event_context *
> +perf_lock_task_context(struct task_struct *task, unsigned long *flags)
> +{
> +	struct perf_event_context *ctx;
> +	__cond_lock(&ctx->lock, ctx = __perf_lock_task_context(task, flags));
> +	return ctx;
> +}
> +
>  /*
>   * Get the context for a task and increment its pin_count so it
>   * can't get swapped to another task.  This also increments its

This is a rather ugly annotation... why can't sparse use something like
the regular __acquire() function annotation but instead all it
__cond_acquire() ?


