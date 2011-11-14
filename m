Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1KNOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:42:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1KNOm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <1320182360-20043-13-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-13-git-send-email-glommer@parallels.com>
Date: Mon, 14 Nov 2011 17:42:25 +0300
Message-ID: <CANaxB-yM+46cWuVU8bLnL5iAzRvofa2FAqDRgYmY=Df7-RO=2w@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] Keep number of running processes per-cgroup
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

> This relies on the fact that the scheduler classes keep the number
> of running processes internally in their entities.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> ---
....

> +#ifdef CONFIG_CGROUP_SCHED
> +               /* root task group has autogrouping, so this doesn't hold */
> +               if  (tg != &root_task_group) {
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +                       tg_nr_running += cpu_rq(i)->cfs.nr_running;

I think you want to say tg->cfs_rq[i]->nr_running, otherwise it will
show nr_running for root_task_group.

# mount -t cgroup -o cpu xxx /mnt/
# echo $$ > /mnt/1/tasks
# while :; do :; done &
[1] 1679
# while :; do :; done &
[2] 1682
# while :; do :; done &
[3] 1684
# while :; do :; done &
[4] 1686
# while :; do :; done &
[5] 1688
# cat /mnt/1/cpu.proc.stat  | grep procs_running
procs_running 2

> +#endif
> +#ifdef CONFIG_RT_GROUP_SCHED
> +                       tg_nr_running += cpu_rq(i)->rt.rt_nr_running;
> +#endif
> +               } else
> +#endif
> +                       tg_nr_running += cpu_rq(i)->nr_running;
>
>                for (j = 0; j < NR_SOFTIRQS; j++) {
>                        unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
> @@ -9911,7 +9924,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>                tg_nr_switches,
>                (unsigned long)jif,
>                total_forks,
> -               nr_running(),
> +               tg_nr_running,
>                tg_iowait),
>
>        seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
