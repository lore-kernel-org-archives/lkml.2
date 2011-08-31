Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1HaPUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:20:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab1HaPUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:20:47 -0400
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
From: Peter Zijlstra <peterz@infradead.org>
To: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 31 Aug 2011 17:20:41 +0200
In-Reply-To: <1314796663-4215-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
References: <1314796663-4215-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314804041.3578.42.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 14:17 +0100, Ripduman Sohan wrote:
> Rescuer threads may be migrated (and are bound) to particular CPUs when
> active.  However, the allowed_cpus mask is not restored when they return
> to sleep rendering inconsistent the presented and actual set of CPUs the
> process may potentially run on.  This patch fixes this oversight by
> recording the allowed_cpus mask for rescuer threads when it enters the
> rescuer_thread() main loop and restoring it every time the thread sleeps.
> 
> Signed-off-by: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
> ---
>  kernel/workqueue.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 25fb1b0..0a4e785 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2031,6 +2031,7 @@ static int rescuer_thread(void *__wq)
>  	struct list_head *scheduled = &rescuer->scheduled;
>  	bool is_unbound = wq->flags & WQ_UNBOUND;
>  	unsigned int cpu;
> +        cpumask_t allowed_cpus = current->cpus_allowed;

except you cannot just allocate a cpumask_t like that on the stack,
those things can be massive.

>  	set_user_nice(current, RESCUER_NICE_LEVEL);
>  repeat:
> @@ -2078,6 +2079,8 @@ repeat:
>  		spin_unlock_irq(&gcwq->lock);
>  	}
>  
> +        set_cpus_allowed_ptr(current, &allowed_cpus);
> +
>  	schedule();
>  	goto repeat;
>  }

