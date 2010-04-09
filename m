Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0DIJqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:46:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0DIJqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:46:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Mike Chan <mike@android.com>, menage@google.com
Subject: Re: [PATCH] sched: cpuacct: Track cpuusage for CPU frequencies
Date: Fri, 9 Apr 2010 11:47:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com, dwalker@fifo99.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1270603319-28907-1-git-send-email-mike@android.com>
In-Reply-To: <1270603319-28907-1-git-send-email-mike@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004091147.32505.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010 03:21:59 Mike Chan wrote:
> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
> 
> cpuacct.cpufreq reports the CPU time (nanoseconds) spent at each CPU frequency
> 
> Maximum number of frequencies supported is 32. As future architectures are
> added that support more than 32 frequency levels, CPUFREQ_TABLE_MAX in sched.c
> needs to be updated.
Why is accounting of each frequency needed?
pcc-cpufreq driver can do every frequency in a range and supports hundreds of
different frequencies, thus it does not depend on CPU_FREQ_TABLE.
Would the average frequency be enough to track/account?
This would avoid the static interface of listing each available freq.
It would also count "boosted" frequency case which is avail on most recent
X86 cpus.

> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  Documentation/cgroups/cpuacct.txt |    3 +
>  kernel/sched.c                    |  112 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 115 insertions(+), 0 deletions(-)
... 
>  static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
> @@ -9031,6 +9132,17 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>  
>  	for (; ca; ca = ca->parent) {
>  		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +#ifdef CONFIG_CPU_FREQ_STAT
> +		struct cpufreq_table *cpufreq_table =
> +			per_cpu_ptr(ca->cpufreq_table, cpu);
> +
> +		if (cpufreq_index > CPUFREQ_TABLE_MAX)
> +			printk_once(KERN_WARNING "cpuacct_charge: "
> +					"cpufreq_index: %d exceeds max table "
> +					"size\n", cpufreq_index);
> +		else
> +			cpufreq_table->freq[cpufreq_index] += cputime;
> +#endif
Can the frequency change somewhere in the middle between cpuacct_charge is
called?
What guarantees that the task run at cpufreq_table->freq[cpufreq_index]
all the time?

     Thomas

>  		*cpuusage += cputime;
>  	}
>  
> -- 
