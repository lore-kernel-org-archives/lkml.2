Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2JDG1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:27:03 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50553 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2JDG1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:27:01 -0400
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
Date: Thu, 4 Oct 2012 11:57:00 +0530
Message-ID: <CAKohpo=gvA4o=d3rw18O8sMOfXCh1M=39OcdOre4c4Azs42REg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] sched: Introduce priority-based task migration filter
From: Viresh Kumar <viresh.kumar@linaro.org>
To: morten.rasmussen@arm.com
Cc: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>, Arvind.Chauhan@arm.com,
        Robin Randhawa <robin.randhawa@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:

> +config SCHED_HMP_PRIO_FILTER
> +       bool "(EXPERIMENTAL) Filter HMP migrations by task priority"
> +       depends on SCHED_HMP

Should it depend on EXPERIMENTAL?

> +       help
> +         Enables task priority based HMP migration filter. Any task with
> +         a NICE value above the threshold will always be on low-power cpus
> +         with less compute capacity.
> +
> +config SCHED_HMP_PRIO_FILTER_VAL
> +       int "NICE priority threshold"
> +       default 5
> +       depends on SCHED_HMP_PRIO_FILTER
> +
>  config HAVE_ARM_SCU
>         bool
>         help
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 490f1f0..8f0f3b9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3129,9 +3129,12 @@ static int __init hmp_cpu_mask_setup(void)
>   * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
>   * The default values (512, 256) offer good responsiveness, but may need
>   * tweaking suit particular needs.
> + *
> + * hmp_up_prio: Only up migrate task with high priority (<hmp_up_prio)
>   */
>  unsigned int hmp_up_threshold = 512;
>  unsigned int hmp_down_threshold = 256;
> +unsigned int hmp_up_prio = NICE_TO_PRIO(CONFIG_SCHED_HMP_PRIO_FILTER_VAL);
>
>  static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
>  static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
> @@ -5491,6 +5494,12 @@ static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
>         if (hmp_cpu_is_fastest(cpu))
>                 return 0;
>
> +#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
> +       /* Filter by task priority */
> +       if (p->prio >= hmp_up_prio)
> +               return 0;
> +#endif
> +
>         if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
>                                         tsk_cpus_allowed(p))
>                 && se->avg.load_avg_ratio > hmp_up_threshold) {
> @@ -5507,6 +5516,12 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
>         if (hmp_cpu_is_slowest(cpu))
>                 return 0;
>
> +#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
> +       /* Filter by task priority */
> +       if (p->prio >= hmp_up_prio)
> +               return 1;
> +#endif

Even if below cpumask_intersects() fails?

>         if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
>                                         tsk_cpus_allowed(p))
>                 && se->avg.load_avg_ratio < hmp_down_threshold) {

--
viresh
