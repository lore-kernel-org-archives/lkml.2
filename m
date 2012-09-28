Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2I1GDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:03:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64648 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2I1GDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
	<7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
Date: Fri, 28 Sep 2012 11:33:23 +0530
Message-ID: <CAKohpomEc7wAdvSK5dUfyeywwWt9+Z_DkQ56xoFRPy2-x9+A7w@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Arvind.Chauhan@arm.com, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2012 14:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Workqueues queues work on current cpu, if the caller haven't passed a preferred
> cpu. This may wake up an idle CPU, which is actually not required.
>
> This work can be processed by any CPU and so we must select a non-idle CPU here.
> This patch adds in support in workqueue framework to get preferred CPU details
> from the scheduler, instead of using current CPU.
>
> Most of the time when a work is queued, the current cpu isn't idle and so we
> will choose it only. There are cases when a cpu is idle when it queues some
> work. For example, consider following scenario:
> - A cpu has programmed a timer and is IDLE now.
> - CPU gets into interrupt handler due to timer and queues a work. As the CPU is
>   currently IDLE, we can queue this work to some other CPU.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 143fd8c..5fa4ba4 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1238,7 +1238,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>                 struct global_cwq *last_gcwq;
>
>                 if (cpu == WORK_CPU_UNBOUND)
> -                       cpu = raw_smp_processor_id();
> +                       cpu = sched_select_cpu(0);

Hi Tejun,

Following change is also required with this patch:


--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1383,7 +1383,7 @@ static void __queue_delayed_work(int cpu, struct
workqueue_struct *wq,
                if (gcwq)
                        lcpu = gcwq->cpu;
                if (lcpu == WORK_CPU_UNBOUND)
-                       lcpu = raw_smp_processor_id();
+                       lcpu = sched_select_cpu(0);
        } else {
                lcpu = WORK_CPU_UNBOUND;
        }

Otherwise, we will end up running the re-reentrancy check, which we are trying
to skip for delayed work.

--
viresh
