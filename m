Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3AIRiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:38:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40237 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AIRiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:38:08 -0500
Date: Wed, 9 Jan 2013 17:38:07 +0000
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
Subject: Re: [PATCH v3 04/22] sched: don't need go to smaller sched domain
Message-ID: <20130109173807.GB2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-5-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1357375071-11793-5-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Jan 2013 17:38:03.0969 (UTC) FILETIME=[13DEEB10:01CDEE90]
X-MC-Unique: 113010917380603201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:37:33AM +0000, Alex Shi wrote:
> If parent sched domain has no task allowed cpu find. neither find in
> it's child. So, go out to save useless checking.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3c7b09a..ecfbf8e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3378,10 +3378,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  			load_idx = sd->wake_idx;
>  
>  		group = find_idlest_group(sd, p, cpu, load_idx);

The previous patch changed the behavior of find_idlest_group() to
returning the local group if it is suitable. This effectively means that
you remove the recursive search for a suitable idle sched group. You
could as well merge find_idlest_group() and find_idlest_cpu() to avoid
iterating through the cpus of the same sched group twice.

Morten

> -		if (!group) {
> -			sd = sd->child;
> -			continue;
> -		}
> +		if (!group)
> +			goto unlock;
>  
>  		new_cpu = find_idlest_cpu(group, p, cpu);
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

