Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0LRBKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:10:05 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:6425 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756381Ab0LRBKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:10:02 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bhz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D0C09C8.4090200@am.sony.com>
Date: Fri, 17 Dec 2010 17:09:28 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/5] sched: Clean up ttwu stats
References: <20101216145602.899838254@chello.nl> <20101216150920.917068045@chello.nl>
In-Reply-To: <20101216150920.917068045@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 06:56, Peter Zijlstra wrote:
> Collect all ttwu stat code into a single function and ensure its
> always called for an actual wakeup (changing p->state to
> TASK_RUNNING).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   66 ++++++++++++++++++++++++++-------------------------------
>  1 file changed, 31 insertions(+), 35 deletions(-)

Looks good to me.  Nice cleanup...

A couple of nits inline if you want them.

Acked-by: Frank Rowand <frank.rowand@am.sony.com>

> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2310,21 +2310,35 @@ static void update_avg(u64 *avg, u64 sam
>  }
>  #endif
>  
> -static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
> -				 bool is_sync, bool is_migrate, bool is_local,
> -				 unsigned long en_flags)
> +static void
> +ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
>  {
> +#ifdef CONFIG_SCHEDSTATS
> +

        int this_cpu = smp_processor_id();

> +	schedstat_inc(rq, ttwu_count);
>  	schedstat_inc(p, se.statistics.nr_wakeups);
> -	if (is_sync)
> +
> +	if (wake_flags & WF_SYNC)
>  		schedstat_inc(p, se.statistics.nr_wakeups_sync);
> -	if (is_migrate)
> +
> +	if (cpu != task_cpu(p))
>  		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
> -	if (is_local)
> +
> +	if (cpu == smp_processor_id()) {

                    ^^^^^^  this_cpu

> +		schedstat_inc(rq, ttwu_local);
>  		schedstat_inc(p, se.statistics.nr_wakeups_local);
> -	else
> -		schedstat_inc(p, se.statistics.nr_wakeups_remote);
> +	} else {
> +		struct sched_domain *sd;
>  
> -	activate_task(rq, p, en_flags);
> +		schedstat_inc(p, se.statistics.nr_wakeups_remote);
> +		for_each_domain(smp_processor_id(), sd) {

                                ^^^^^ this_cpu

> +			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
> +				schedstat_inc(sd, ttwu_wake_remote);
> +				break;
> +			}
> +		}
> +	}
> +#endif /* CONFIG_SCHEDSTATS */
>  }
>  
>  static void

