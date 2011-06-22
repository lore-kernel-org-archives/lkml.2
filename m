Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab1FVTaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:30:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:41551 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab1FVTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:30:11 -0400
Date: Wed, 22 Jun 2011 21:30:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
In-Reply-To: <20110622174919.135236139@linutronix.de>
Message-ID: <alpine.LFD.2.02.1106222128480.11814@ionos>
References: <20110622174659.496793734@linutronix.de> <20110622174919.135236139@linutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Thomas Gleixner wrote:
> +void wq_worker_sleeping(struct task_struct *task)
>  {
> -	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
> -	struct global_cwq *gcwq = get_gcwq(cpu);
> -	atomic_t *nr_running = get_gcwq_nr_running(cpu);
> +	struct worker *worker = kthread_data(task);
> +	struct global_cwq *gcwq;
> +	int cpu;
>  
>  	if (worker->flags & WORKER_NOT_RUNNING)
> -		return NULL;
> +		return;
>  
> -	/* this can only happen on the local cpu */
> -	BUG_ON(cpu != raw_smp_processor_id());
> +	if (WARN_ON_ONCE(worker->sleeping))
> +		return;

Darn, forgot to add 

      worker->sleeping = 1;

back when I added the WARN_ON.
  
