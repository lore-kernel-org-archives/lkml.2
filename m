Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab0I0Nqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:46:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57838 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab0I0Nqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xVrp67C3fc1NqKWFOrVL4zr6DXMsJW5gBij1WLcxAaQS0ZNt6j5MWu3T8BAXt3Hjpv
         hzJ2MaeWKkOYa0RMq4X1dyIq5S7DGNW1YJ0b/GKBSDrAdGaTtOqMmQ+6TJEqFguE6am/
         Ek3fZ1fwupmhSgeysTsj2pqQEXjRK7wVoCygs=
Date: Mon, 27 Sep 2010 15:46:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Wrap perf_lock_task_context using
	__cond_lock()
Message-ID: <20100927134641.GA5456@nowhere>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com> <1285583997-1262-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285583997-1262-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 07:39:53PM +0900, Namhyung Kim wrote:
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



That's a pity we need to make the code less readable just to make a tool
happy.

How do functions like mutex_lock_interruptible() that may
or may not lock? I don't see __cond_lock adds there.

Thanks.

