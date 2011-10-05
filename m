Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab1JEJFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:05:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622Ab1JEJFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:05:01 -0400
Subject: Re: [PATCH 04/10] Display /proc/stat information per cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 05 Oct 2011 11:04:55 +0200
In-Reply-To: <1317583287-18300-5-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	 <1317583287-18300-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317805495.6766.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> @@ -3868,10 +3897,14 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>   */
>  void account_steal_time(cputime_t cputime)
>  {
> -       u64 *cpustat = kstat_this_cpu->cpustat;
> +       struct kernel_stat *kstat;
>         u64 cputime64 = cputime_to_cputime64(cputime);
> -
> -       cpustat[STEAL] += cputime64;
> +#ifdef CONFIG_CGROUP_SCHED
> +       kstat = this_cpu_ptr(root_task_group.cpustat);
> +#else
> +       kstat = __get_cpu_var(kstat);
> +#endif
> +       kstat->cpustat[STEAL] += cputime64;
>  }

> @@ -9111,17 +9179,28 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
>         jif = boottime.tv_sec;
>  
>         for_each_possible_cpu(i) {
> -               user += kstat_this_cpu->cpustat[USER];
> -               nice += kstat_this_cpu->cpustat[NICE];
> -               system += kstat_this_cpu->cpustat[SYSTEM];
> -               idle += kstat_this_cpu->cpustat[IDLE];
> +               struct kernel_stat *kstat, *idle_kstat;
> +#ifdef CONFIG_CGROUP_SCHED
> +               kstat = per_cpu_ptr(tg->cpustat, i);
> +               idle_kstat = per_cpu_ptr(root_task_group.cpustat, i);
> +#else
> +               kstat = per_cpu(kstat, i);
> +               idle_kstat = kstat;
> +#endif
> +
> +               user += kstat->cpustat[USER];
> +               nice += kstat->cpustat[NICE];
> +               system += kstat->cpustat[SYSTEM]; 

That if-deffery just begs to be killed by some helper function. Both
variants appear multiple times I think.
