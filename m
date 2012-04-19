Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2DSPeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:34:31 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:50924 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DSPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:34:29 -0400
Date: Thu, 19 Apr 2012 17:34:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Konrad Eisele <konrad@gaisler.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Cc: sparclinux@vger.kernel.org, davem@davemloft.net, daniel@gaisler.com
Subject: Re: [PATCH 1/1] sparc: task_cpu() for stopper thread on sparc32
	returns 0
Message-ID: <20120419153428.GB1120@merkur.ravnborg.org>
References: <1334827362-3434-1-git-send-email-konrad@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334827362-3434-1-git-send-email-konrad@gaisler.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a few more people - as this patch touches a core file.

I expect we have an issue on sparc32 - that manifest
in this bug. But I do not know this code at all.

	Sam

On Thu, Apr 19, 2012 at 11:22:42AM +0200, Konrad Eisele wrote:
> The stopper thread for CPU > 0 (at least in sparc32)
> has on initialization task_cpu() set to zero even
> for CPUs > 0. The patch explicitly checks weather the
> CPU is allowed to run on the cpu that task_cpu()
> return or changes the return cpu.
> 
> Signed-off-by: Konrad Eisele <konrad@gaisler.com>
> ---
>  kernel/sched/stop_task.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
> index 7b386e8..9201866 100644
> --- a/kernel/sched/stop_task.c
> +++ b/kernel/sched/stop_task.c
> @@ -13,7 +13,14 @@
>  static int
>  select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
>  {
> -	return task_cpu(p); /* stop tasks as never migrate */
> +	int ccpu, cpu , dcpu;
> +	ccpu = cpu = task_cpu(p);
> +	if (unlikely(!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))) {
> +		cpu = cpumask_first(tsk_cpus_allowed(p));
> +		if (cpu >= nr_cpu_ids)
> +			cpu = ccpu;
> +	}
> +	return cpu;
>  }
>  #endif /* CONFIG_SMP */
>  
> -- 
> 1.6.1.3
> 
