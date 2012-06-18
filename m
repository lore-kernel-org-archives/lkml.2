Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2FRIrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:47:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50503 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2FRIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:47:12 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-aa-4fdeeb0bf0d9
From: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch V2 2/7] kthread: Implement park/unpark facility
References: <20120615140217.933711648@linutronix.de>
	<20120615140714.456322600@linutronix.de>
Date: Mon, 18 Jun 2012 17:43:41 +0900
In-Reply-To: <20120615140714.456322600@linutronix.de> (Thomas Gleixner's
	message of "Fri, 15 Jun 2012 14:13:21 -0000")
Message-ID: <87hau9huwy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 14:13:21 -0000, Thomas Gleixner wrote:
> To avoid the full teardown/setup of per cpu kthreads in the case of
> cpu hot(un)plug, provide a facility which allows to put the kthread
> into a park position and unpark it when the cpu comes online again.
>

Please see a comment below. Other than that, you can add my

  Reviewed-by: Namhyung Kim <namhyung@kernel.org>

if you want.


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/kthread.h |   11 ++
>  kernel/kthread.c        |  184 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 175 insertions(+), 20 deletions(-)
[snip]
>  /**
> + * kthread_create_on_cpu - Create a cpu bound kthread
> + * @threadfn: the function to run until signal_pending(current).
> + * @data: data ptr for @threadfn.
> + * @cpu: The cpu on which the thread should be bound,
> + * @namefmt: printf-style name for the thread.

How about adding a comment that @namefmt can handle a single %u only
for the cpu number in the current implementation?

Thanks,
Namhyung


> + *
> + * Description: This helper function creates and names a kernel thread
> + * The thread will be woken and put into park mode.
> + */
> +struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
> +					  void *data, unsigned int cpu,
> +					  const char *namefmt)
> +{
> +	struct task_struct *p;
> +
> +	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
> +				   cpu);
> +	if (IS_ERR(p))
> +		return p;
> +	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
> +	to_kthread(p)->cpu = cpu;
> +	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
> +	kthread_park(p);
> +	return p;
> +}
> +
