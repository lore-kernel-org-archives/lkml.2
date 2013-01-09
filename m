Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab3AISVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:21:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54953 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3AISVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:21:02 -0500
Date: Wed, 9 Jan 2013 18:21:03 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in
 fork/exec/wake
Message-ID: <20130109182102.GC2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-6-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1357375071-11793-6-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Jan 2013 18:20:59.0656 (UTC) FILETIME=[13199080:01CDEE96]
X-MC-Unique: 113010918210000801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:37:34AM +0000, Alex Shi wrote:
> Guess the search cpu from bottom to up in domain tree come from
> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
> balancing over tasks on all level domains.
> 
> This balancing cost much if there has many domain/groups in a large
> system. And force spreading task among different domains may cause
> performance issue due to bad locality.
> 
> If we remove this code, we will get quick fork/exec/wake, plus better
> balancing among whole system, that also reduce migrations in future
> load balancing.
> 
> This patch increases 10+% performance of hackbench on my 4 sockets
> NHM and SNB machines.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ecfbf8e..895a3f4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3364,15 +3364,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		goto unlock;
>  	}
>  
> -	while (sd) {
> +	if (sd) {
>  		int load_idx = sd->forkexec_idx;
>  		struct sched_group *group;
> -		int weight;
> -
> -		if (!(sd->flags & sd_flag)) {
> -			sd = sd->child;
> -			continue;
> -		}
>  
>  		if (sd_flag & SD_BALANCE_WAKE)
>  			load_idx = sd->wake_idx;
> @@ -3382,18 +3376,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  			goto unlock;
>  
>  		new_cpu = find_idlest_cpu(group, p, cpu);
> -
> -		/* Now try balancing at a lower domain level of new_cpu */
> -		cpu = new_cpu;
> -		weight = sd->span_weight;
> -		sd = NULL;
> -		for_each_domain(cpu, tmp) {
> -			if (weight <= tmp->span_weight)
> -				break;
> -			if (tmp->flags & sd_flag)
> -				sd = tmp;
> -		}
> -		/* while loop will break here if sd == NULL */

I agree that this should be a major optimization. I just can't figure
out why the existing recursive search for an idle cpu switches to the
new cpu near the end and then starts a search for an idle cpu in the new
cpu's domain. Is this to handle some exotic sched domain configurations?
If so, they probably wouldn't work with your optimizations.

Morten

>  	}
>  unlock:
>  	rcu_read_unlock();
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

