Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2EDFK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:10:57 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39095 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2EDFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:10:56 -0400
Message-ID: <4FA36045.9080504@linux.vnet.ibm.com>
Date: Fri, 04 May 2012 10:21:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH v1 3/6] workqueue: introduce schedule_on_each_cpu_cond
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-4-git-send-email-gilad@benyossef.com>
In-Reply-To: <1336056962-10465-4-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050319-3568-0000-0000-000001A773F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 08:25 PM, Gilad Ben-Yossef wrote:

> Introduce the schedule_on_each_cpu_cond() function that schedules
> a work item on each online CPU for which the supplied condition
> function returns true.
> 
> This function should be used instead of schedule_on_each_cpu()
> when only some of the CPUs have actual work to do and a predicate
> function can tell if a certain CPU does or does not have work to do,
> thus saving unneeded wakeups and schedules.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---


> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 1c9782b..3322d30 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2828,6 +2828,43 @@ int schedule_on_each_cpu_mask(work_func_t func, const struct cpumask *mask)
>  }
> 
>  /**
> + * schedule_on_each_cpu_cond - execute a function synchronously on each
> + * online CPU for which the supplied condition function returns true
> + * @func: the function to run on the selected CPUs
> + * @cond_func: the function to call to select the CPUs
> + *
> + * schedule_on_each_cpu_cond() executes @func on each online CPU for
> + * @cond_func returns true using the system workqueue and blocks until

    ^^^
(for) which

Regards,
Srivatsa S. Bhat

> + * all CPUs have completed.
> + * schedule_on_each_cpu_cond() is very slow.
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int schedule_on_each_cpu_cond(work_func_t func, bool (*cond_func)(int cpu))
> +{
> +	int cpu, ret;
> +	cpumask_var_t mask;
> +
> +	if (unlikely(!zalloc_cpumask_var(&mask, GFP_KERNEL)))
> +		return -ENOMEM;
> +
> +	get_online_cpus();
> +
> +	for_each_online_cpu(cpu)
> +		if (cond_func(cpu))
> +			cpumask_set_cpu(cpu, mask);
> +
> +	ret = schedule_on_each_cpu_mask(func, mask);
> +
> +	put_online_cpus();
> +
> +	free_cpumask_var(mask);
> +
> +	return ret;

