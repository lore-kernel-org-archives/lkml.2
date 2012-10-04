Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2JDG6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:58:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47097 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2JDG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-8-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-8-git-send-email-morten.rasmussen@arm.com>
Date: Thu, 4 Oct 2012 12:28:45 +0530
Message-ID: <CAKohpokqC9Okav5HfNuN-Jd=58qoMvNO9SxVxDJWA7rqmsrkWA@mail.gmail.com>
Subject: Re: [RFC PATCH 07/10] ARM: sched: Setup SCHED_HMP domains
From: Viresh Kumar <viresh.kumar@linaro.org>
To: morten.rasmussen@arm.com
Cc: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Arvind.Chauhan@arm.com, Robin Randhawa <robin.randhawa@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c

> +void __init arch_get_hmp_domains(struct list_head *hmp_domains_list)
> +{
> +       struct cpumask hmp_fast_cpu_mask;
> +       struct cpumask hmp_slow_cpu_mask;

can be merged to single line.

> +       struct hmp_domain *domain;
> +
> +       arch_get_fast_and_slow_cpus(&hmp_fast_cpu_mask, &hmp_slow_cpu_mask);
> +
> +       /*
> +        * Initialize hmp_domains
> +        * Must be ordered with respect to compute capacity.
> +        * Fastest domain at head of list.
> +        */
> +       domain = (struct hmp_domain *)
> +               kmalloc(sizeof(struct hmp_domain), GFP_KERNEL);

should be:

domain = kmalloc(sizeof(*domain), GFP_KERNEL);

> +       cpumask_copy(&domain->cpus, &hmp_slow_cpu_mask);

what if kmalloc failed?

> +       list_add(&domain->hmp_domains, hmp_domains_list);
> +       domain = (struct hmp_domain *)
> +               kmalloc(sizeof(struct hmp_domain), GFP_KERNEL);

would be better to kmalloc only once with size 2* sizeof(*domain)

> +       cpumask_copy(&domain->cpus, &hmp_fast_cpu_mask);
> +       list_add(&domain->hmp_domains, hmp_domains_list);

Also would be better to create a macro for above two lines to remove
code redundancy.
