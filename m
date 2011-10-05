Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab1JEJqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:46:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab1JEJqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:46:37 -0400
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>
Date: Wed, 05 Oct 2011 11:46:28 +0200
In-Reply-To: <1317583287-18300-10-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	 <1317583287-18300-10-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317807988.6766.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> +/*
> + * charge this task's execution time to its accounting group.
> + *
> + * called with rq->lock held.
> + */
> +static void cpuusage_charge(struct task_struct *tsk, u64 cputime)
> +{
> +       int cpu;
> +
> +#ifdef CONFIG_CGROUP_CPUACCT
> +       struct cpuacct *ca;
> +#endif
> +#ifdef CONFIG_CGROUP_SCHED
> +       struct task_group *tg;
> +#endif
> +       cpu = task_cpu(tsk);
> +
> +       rcu_read_lock();
> +
> +#ifdef CONFIG_CGROUP_CPUACCT
> +       ca = task_ca(tsk);
> +
> +       if (unlikely(!cpuacct_subsys.active))
> +               goto no_cpuacct;
> +
> +       for (; ca; ca = ca->parent) {
> +               u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +               *cpuusage += cputime;
> +       }
> +no_cpuacct:
> +#endif
> +
> +#ifdef CONFIG_CGROUP_SCHED
> +       tg = task_group(tsk);
> +       for (; tg; tg = tg->parent) {
> +               u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
> +               *cpuusage += cputime;
> +       }
> +#endif
> +       rcu_read_unlock();
> +} 

I don't actually think we need to do this. tg->se[cpu]->sum_exec_runtime
should contain the same information.
