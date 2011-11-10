Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1KJK1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:27:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50852 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1KJK1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <1320182360-20043-10-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-10-git-send-email-glommer@parallels.com>
Date: Thu, 10 Nov 2011 13:27:21 +0300
Message-ID: <CANaxB-yma9W3WdDwC+UZ3HnOHgWbc0WGC6a3S-qt+C_ThtPGbQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] Keep nr_iowait per cgroup
From: Andrew Wagin <avagin@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code has a race condition.
A task may be moved in another group between  task_group_nr_iowait_inc
and task_group_nr_iowait_dec.

# dd if=/dev/sda of=//dev/null bs=4095 & pid=$!
# echo $pid > /cgroup/1/tasks
# kill $pid
# cat /cgroup/1/cpu.proc.stat  | grep procs_blocked
procs_blocked 18446744073709551615

> +static inline void task_group_nr_iowait_inc(struct task_struct *p, int cpu)
> +{
> +
> +       atomic_inc(&per_cpu(kernel_cpustat, cpu).nr_iowait);
> +
> +#ifdef CONFIG_CGROUP_SCHED
> +       if (static_branch(&sched_cgroup_enabled)) {
> +               struct kernel_cpustat *kcpustat;
> +               struct task_group *tg;
> +
> +               rcu_read_lock();
> +               tg = task_group(p);
> +               while (tg && (tg != &root_task_group)) {
> +                       kcpustat = per_cpu_ptr(tg->cpustat, cpu);
> +                       atomic_inc(&kcpustat->nr_iowait);
> +                       tg = tg->parent;
> +               }
> +               rcu_read_unlock();
> +       }
> +#endif
> +}
> +
> +static inline void task_group_nr_iowait_dec(struct task_struct *p, int cpu)
> +{
> +
> +       atomic_dec(&per_cpu(kernel_cpustat, cpu).nr_iowait);
> +
> +#ifdef CONFIG_CGROUP_SCHED
> +       if (static_branch(&sched_cgroup_enabled)) {
> +               struct kernel_cpustat *kcpustat;
> +               struct task_group *tg;
> +
> +               rcu_read_lock();
> +               tg = task_group(p);
> +               while (tg && (tg != &root_task_group)) {
> +                       kcpustat = per_cpu_ptr(tg->cpustat, cpu);
> +                       atomic_dec(&kcpustat->nr_iowait);
> +                       tg = tg->parent;
> +               }
> +               rcu_read_unlock();
> +       }
> +#endif
> +}
> +
