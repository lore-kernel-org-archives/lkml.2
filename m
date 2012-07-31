Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2GaR0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:26:14 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:55925 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752353Ab2GaR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:26:13 -0400
Message-ID: <501814F0.5050008@xenotime.net>
Date: Tue, 31 Jul 2012 10:25:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org
Subject: Re: [PATCH] sched: Document schedule() entry points
References: <1343715300-6315-1-git-send-email-penberg@kernel.org>
In-Reply-To: <1343715300-6315-1-git-send-email-penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 11:15 PM, Pekka Enberg wrote:

> This patch adds a comment on top of the schedule() function to explain
> to scheduler newbies how the main scheduler function is entered.
> 
> Explained-by: Ingo Molnar <mingo@kernel.org>
> Explained-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>  kernel/sched/core.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 468bdd4..9f31bbd 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3361,6 +3361,40 @@ pick_next_task(struct rq *rq)
>  
>  /*
>   * __schedule() is the main scheduler function.
> + *
> + * The main means of driving the scheduler and thus entering this function are:
> + *
> + *   1. Explicit blocking: mutex, semaphore, waitqueue, etc.
> + *
> + *   2. TIF_NEED_RESCHED flag is checked on interrupt and userspace return
> + *      paths. For example, see arch/x86/entry_64.S.
> + *
> + *      To drive preemption between tasks, the scheduler sets the flag is set


eh?

> + *      in timer interrupt handler scheduler_tick().
> + *
> + *   3. Wakeups don't really cause entry into schedule(). They add a
> + *      task to the run-queue and that's it.
> + *
> + *      Now, if the new task added to the run-queue preempts the current
> + *      task, then the wakeup sets TIF_NEED_RESCHED and schedule() gets
> + *      called on the nearest possible occasion:
> + *
> + *       - If the kernel is preemptible (CONFIG_PREEMPT=y):
> + *
> + *         - in syscall or exception context, at the next outmost
> + *           preempt_enable(). (this might be as soon as the wake_up()'s
> + *           spin_unlock()!)
> + *
> + *         - in IRQ context, return from interrupt-handler to
> + *           preemptible context
> + *
> + *       - If the kernel is not preemptible (CONFIG_PREEMPT is not set)
> + *         then at the next:
> + *
> + *          - cond_resched() call
> + *          - explicit schedule() call
> + *          - return from syscall or exception to user-space
> + *          - return from interrupt-handler to user-space
>   */
>  static void __sched __schedule(void)
>  {



-- 
~Randy
