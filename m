Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2FNNAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:00:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35888 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755682Ab2FNNAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:00:11 -0400
Message-ID: <1339678809.24180.5.camel@joe2Laptop>
Subject: Re: [PATCH 3/6] x86/apic: Fix ugly casting and branching in
 cpu_mask_to_apicid_and()
From: Joe Perches <joe@perches.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Date: Thu, 14 Jun 2012 06:00:09 -0700
In-Reply-To: <20120614074954.GF3383@dhcp-26-207.brq.redhat.com>
References: <cover.1339657103.git.agordeev@redhat.com>
	 <20120614074954.GF3383@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 09:49 +0200, Alexander Gordeev wrote:
[]
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
[]
> @@ -2127,19 +2127,19 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
>  				   const struct cpumask *andmask,
>  				   unsigned int *apicid)
>  {
> -	int cpu;
> +	unsigned int cpu;
>  
>  	for_each_cpu_and(cpu, cpumask, andmask) {
>  		if (cpumask_test_cpu(cpu, cpu_online_mask))
>  			break;
>  	}
>  
> -	if (likely((unsigned int)cpu < nr_cpu_ids)) {
> +	if (likely(cpu < nr_cpu_ids)) {
>  		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
>  		return 0;
> -	} else {
> -		return -EINVAL;
>  	}
> +
> +	return -EINVAL;

I think you should reverse the test and make the
expected common case the normal non-indented return.

	if (unlikely(cpu >= nr_cpu_ids))
		return -EINVAL;

	*apicid = per_cpu(x86_cpu_to_apicid, cpu);
	return 0;
}

Perhaps the unlikely isn't necessary.

> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
[]
> @@ -285,12 +285,12 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
>  			break;
>  	}
>  
> -	if (likely((unsigned int)cpu < nr_cpu_ids)) {
> +	if (likely(cpu < nr_cpu_ids)) {
>  		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
>  		return 0;
> -	} else {
> -		return -EINVAL;
>  	}
> +
> +	return -EINVAL;

here too

