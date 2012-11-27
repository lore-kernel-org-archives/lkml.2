Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2K0N0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:26:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2K0N0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:26:13 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=f2n6SYgbXc8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIjj_We_h9UA:10 a=KKAkSRfTAAAA:8 a=nji_MgTUOSGcApYP96oA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354022770.6276.63.camel@gandalf.local.home>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Tue, 27 Nov 2012 08:26:10 -0500
In-Reply-To: <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 16:08 +0530, Viresh Kumar wrote:
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
>  kernel/workqueue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 042d221..d32efa2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1238,7 +1238,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>  		struct global_cwq *last_gcwq;
>  
>  		if (cpu == WORK_CPU_UNBOUND)
> -			cpu = raw_smp_processor_id();
> +			cpu = sched_select_cpu(0);

A couple of things. The sched_select_cpu() is not cheap. It has a double
loop of domains/cpus looking for a non idle cpu. If we have 1024 CPUs,
and we are CPU 1023 and all other CPUs happen to be idle, we could be
searching 1023 CPUs before we come up with our own.

__queue_work() should be fast as there is a reason that it is delaying
the work and not running it itself.

Also, I really don't like this as a default behavior. It seems that this
solution is for a very special case, and this can become very intrusive
for the normal case.

To be honest, I'm uncomfortable with this approach. It seems to be
fighting a symptom and not the disease. I'd rather find a way to keep
work from being queued on wrong CPU. If it is a timer, find a way to
move the timer. If it is something else, lets work to fix that. Doing
searches of possibly all CPUs (unlikely, but it is there), just seems
wrong to me.

-- Steve


>  
>  		/*
>  		 * It's multi cpu.  If @work was previously on a different
> @@ -1383,7 +1383,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
>  		if (gcwq)
>  			lcpu = gcwq->cpu;
>  		if (lcpu == WORK_CPU_UNBOUND)
> -			lcpu = raw_smp_processor_id();
> +			lcpu = sched_select_cpu(0);
>  	} else {
>  		lcpu = WORK_CPU_UNBOUND;
>  	}


