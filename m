Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1AZGLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:11:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47727 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1AZGLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:11:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4D3FBAD5.1070307@jp.fujitsu.com>
Date: Wed, 26 Jan 2011 15:10:29 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 1/2 v2.0]sched: Removing unused fields from /proc/schedstat
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D3F3676.1030601@linux.vnet.ibm.com>
In-Reply-To: <4D3F3676.1030601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ciju,

(2011/01/26 5:45), Ciju Rajan K wrote:
>
> sched: Updating the fields of /proc/schedstat
>
> This patch removes the unused statistics from /proc/schedstat.
> Also updates the request queue structure fields.
>
> Signed-off-by: Ciju Rajan K<ciju@linux.vnet.ibm.com>

This patch is logically correct, succeeded to compile and works
fine. But I came to be worried about whether it is good to kill
all fields you said after reading old and upstream scheduler
code again.

I think we can remove rq->sched_switch and rq->sched_switch
without no problem because they are meaningless. The former
is for old O(1) scheduler and means the number of runqueue
switching among active/expired queue. The latter is for
SD_WAKE_BALANCE flag and its logic is already gone.

However sbe_* are for SD_BALANCE_EXEC flag and sbf_* are for
SD_BALANCE_FORK flag. Since both logic for them are still alive,
the absence of these accounting is regression in my perspective.
In addition, these fields would be useful for analyzing load
balance behavior.

# although I haven't been able to notice they are always zero ;-(

I prefer not to remove these fields({sbe,sbf}_*) but to add
accounting code for these flags again. What do you think?

Thanks,
Satoru

>
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d747f94..1c0ac12 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -954,20 +954,9 @@ struct sched_domain {
>   	unsigned int alb_failed;
>   	unsigned int alb_pushed;
>
> -	/* SD_BALANCE_EXEC stats */
> -	unsigned int sbe_count;
> -	unsigned int sbe_balanced;
> -	unsigned int sbe_pushed;
> -
> -	/* SD_BALANCE_FORK stats */
> -	unsigned int sbf_count;
> -	unsigned int sbf_balanced;
> -	unsigned int sbf_pushed;
> -
>   	/* try_to_wake_up() stats */
>   	unsigned int ttwu_wake_remote;
>   	unsigned int ttwu_move_affine;
> -	unsigned int ttwu_move_balance;
>   #endif
>   #ifdef CONFIG_SCHED_DEBUG
>   	char *name;
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index eb6cb8e..99893be 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -286,7 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)
>
>   	P(yld_count);
>
> -	P(sched_switch);
>   	P(sched_count);
>   	P(sched_goidle);
>   #ifdef CONFIG_SMP
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 48ddf43..8869ed9 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -4,7 +4,7 @@
>    * bump this up when changing the output format or the meaning of an existing
>    * format, so that tools can adapt (or abort)
>    */
> -#define SCHEDSTAT_VERSION 15
> +#define SCHEDSTAT_VERSION 16
>
>   static int show_schedstat(struct seq_file *seq, void *v)
>   {
> @@ -26,9 +26,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
>
>   		/* runqueue-specific stats */
>   		seq_printf(seq,
> -		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> +		    "cpu%d %u %u %u %u %u %llu %llu %lu",
>   		    cpu, rq->yld_count,
> -		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
> +		    rq->sched_count, rq->sched_goidle,
>   		    rq->ttwu_count, rq->ttwu_local,
>   		    rq->rq_cpu_time,
>   		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
> @@ -57,12 +57,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
>   				    sd->lb_nobusyg[itype]);
>   			}
>   			seq_printf(seq,
> -				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
> +				   " %u %u %u %u %u\n",
>   			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
> -			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
> -			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
> -			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
> -			    sd->ttwu_move_balance);
> +			    sd->ttwu_wake_remote, sd->ttwu_move_affine);
>   		}
>   		preempt_enable();
>   #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


