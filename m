Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab1LGTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:16:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:16996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab1LGTQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:16:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93606277"
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Wed, 07 Dec 2011 11:20:44 -0800
In-Reply-To: <1323275027.32012.114.camel@twins>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
	 <1322796864.4755.5.camel@marge.simson.net>
	 <1323275027.32012.114.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 08:23 -0800, Peter Zijlstra wrote:
> In fact, Ingo (rightfully) refused to take this due to the x86 specific
> code in scheduler guts..

I noticed this while reviewing/testing the patch and left it because on
the microbenchmark, it had measurable impact of using the direct check
as compared to going through the scheduler domains every time to figure
out if we shared the LLC or not.

> Initially the idea was to provide a new arch interface and a fallback
> and do the Kconfig thing etc. After a bit of thought I decided against
> that for we already have that information in the sched_domain tree
> anyway and it should be a simple matter of representing things
> differently.

This def looks better.

> +DEFINE_PER_CPU(int, sd_top_spr_id);

pkg_srid (shared resource id)?

> +
> +static void update_top_cache_domain(int cpu)
> +{
> +	struct sched_domain *sd;
> +	int id = -1;
> +
> +	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> +	if (sd)
> +		id = cpumask_first(sched_domain_span(sd));

if there is no sd with shared pkg resources, then id has to be set to
'cpu'.

> +	rcu_assign_pointer(per_cpu(sd_top_spr, cpu), sd);
> +	per_cpu(sd_top_spr_id, cpu) = id;

Otherwise it looks good.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

