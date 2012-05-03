Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2ECPjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:39:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54278 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2ECPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:39:47 -0400
Date: Thu, 3 May 2012 08:39:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
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
Message-ID: <20120503153941.GA5528@google.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
 <1336056962-10465-4-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336056962-10465-4-git-send-email-gilad@benyossef.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 03, 2012 at 05:55:59PM +0300, Gilad Ben-Yossef wrote:
> Introduce the schedule_on_each_cpu_cond() function that schedules
> a work item on each online CPU for which the supplied condition
> function returns true.
> 
> This function should be used instead of schedule_on_each_cpu()
> when only some of the CPUs have actual work to do and a predicate
> function can tell if a certain CPU does or does not have work to do,
> thus saving unneeded wakeups and schedules.
>
>  /**
> + * schedule_on_each_cpu_cond - execute a function synchronously on each
> + * online CPU for which the supplied condition function returns true
> + * @func: the function to run on the selected CPUs
> + * @cond_func: the function to call to select the CPUs
> + *
> + * schedule_on_each_cpu_cond() executes @func on each online CPU for
> + * @cond_func returns true using the system workqueue and blocks until
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
> +}

I'm usually not a big fan of callback based interface.  They tend to
be quite clunky to use.  e.g. in this case, wouldn't it be better to
have helper functions which allocate cpumask and disables cpu hotplug
and undo that afterwards?  That is, if such convenience helpers are
necessary at all.  Also, callback which doesn't have a private data
argument tends to be PITA.

Thanks.

-- 
tejun
