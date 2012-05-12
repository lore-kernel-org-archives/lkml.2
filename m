Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab2ELRjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 13:39:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2ELRjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 13:39:21 -0400
Message-ID: <1336844345.2443.3.camel@twins>
Subject: Re: [RFC] [x86]: abort secondary cpu bringup gracefully
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, johnstul@us.ibm.com, arjan@linux.intel.com
Date: Sat, 12 May 2012 19:39:05 +0200
In-Reply-To: <1336851129-7821-1-git-send-email-imammedo@redhat.com>
References: <alpine.LFD.2.02.1205112256220.3231@ionos>
	 <1336851129-7821-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-12 at 21:32 +0200, Igor Mammedov wrote:

> @@ -232,12 +233,36 @@ static void __cpuinit smp_callin(void)
>  	set_cpu_sibling_map(raw_smp_processor_id());
>  	wmb();
>  
> -	notify_cpu_starting(cpuid);
> -
>  	/*
>  	 * Allow the master to continue.
>  	 */
>  	cpumask_set_cpu(cpuid, cpu_callin_mask);
> +
> +	/*
> +	 * Wait for master to continue.
> +	 */
> +	for (timeout = 0; timeout < 50000; timeout++) {
> +		if (cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
> +			break;
> +
> +		if (!cpumask_test_cpu(cpuid, cpu_callout_mask))
> +			break;
> +
> +		udelay(100);
> +	}
> +
> +	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
> +		goto die;
> +
> +	notify_cpu_starting(cpuid);

Its absolutely broken to call CPU_STARTING after the master cpu is told
to continue. Once it returns from cpu_up() it assumes the secondary is
completely initialized and ready to run.

> +	return;
> +
> +die:

You've forgotten to clean up the bits set by set_cpu_sibling_map().

> +	/* was set by cpu_init() */
> +	cpumask_clear_cpu(smp_processor_id(), cpu_initialized_mask);
> +	cpumask_clear_cpu(smp_processor_id(), cpu_callin_mask);
> +	clear_local_APIC();
> +	play_dead();
>  }
>  
>  /*
> @@ -774,6 +799,8 @@ do_rest:
>  		}
>  
>  		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
> +			/* Signal AP that it may continue to boot */
> +			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
>  			print_cpu_msr(&cpu_data(cpu));
>  			pr_debug("CPU%d: has booted.\n", cpu);
>  		} else {
> @@ -1250,6 +1277,7 @@ static void __ref remove_cpu_from_maps(int cpu)
>  	cpumask_clear_cpu(cpu, cpu_callin_mask);
>  	/* was set by cpu_init() */
>  	cpumask_clear_cpu(cpu, cpu_initialized_mask);
> +	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
>  	numa_remove_cpu(cpu);
>  }
>  

