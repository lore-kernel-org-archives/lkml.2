Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1IAKLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:11:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47456 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab1IAKLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:11:33 -0400
Subject: Re: process time < thread time?
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 12:11:24 +0200
In-Reply-To: <alpine.LFD.2.02.1109011148060.2723@ionos>
References: <20110831.230718.2029810906806382170.davem@davemloft.net>
	 <alpine.LFD.2.02.1109011148060.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314871884.7945.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:56 +0200, Thomas Gleixner wrote:
> The untested patch below should cure this.
> 

> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 58f405b..42378cb 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk,
> struct task_cputime *times)
>         do {
>                 times->utime = cputime_add(times->utime, t->utime);
>                 times->stime = cputime_add(times->stime, t->stime);
> -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> +               times->sum_exec_runtime += task_sched_runtime(t);
>         } while_each_thread(tsk, t);
>  out:
>         rcu_read_unlock(); 

I think we just deadlocked:

cpu_clock_sample_group()
  CPUCLOCK_SCHED: thread_group_sched_runtime()
    task_rq_lock()        <-.
    thread_group_cputime()  |
      task_sched_runtime()  |
       task_rq_lock() ------'


Also, having to take locks here is sad, but yeah if we want to cure this
there's not much we can do about that.
