Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2ELSwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 14:52:12 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:38142 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2ELSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 14:52:11 -0400
Date: Sat, 12 May 2012 14:51:53 -0400 (EDT)
From: Igor Mammedov <imammedo@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh b siddha <suresh.b.siddha@intel.com>, avi@redhat.com,
        johnstul@us.ibm.com, arjan@linux.intel.com,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [RFC] [x86]: abort secondary cpu bringup gracefully
Message-ID: <27b5952f-0f5f-418a-9e22-e6ea12980eee@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1336844345.2443.3.camel@twins>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.227.59]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
> To: "Igor Mammedov" <imammedo@redhat.com>
> On Sat, 2012-05-12 at 21:32 +0200, Igor Mammedov wrote:
> 
> > @@ -232,12 +233,36 @@ static void __cpuinit smp_callin(void)
> >  	set_cpu_sibling_map(raw_smp_processor_id());
> >  	wmb();
> >  
> > -	notify_cpu_starting(cpuid);
> > -
> >  	/*
> >  	 * Allow the master to continue.
> >  	 */
> >  	cpumask_set_cpu(cpuid, cpu_callin_mask);
> > +
> > +	/*
> > +	 * Wait for master to continue.
> > +	 */
> > +	for (timeout = 0; timeout < 50000; timeout++) {
> > +		if (cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
> > +			break;
> > +
> > +		if (!cpumask_test_cpu(cpuid, cpu_callout_mask))
> > +			break;
> > +
> > +		udelay(100);
> > +	}
> > +
> > +	if (!cpumask_test_cpu(cpuid, cpu_may_complete_boot_mask))
> > +		goto die;
> > +
> > +	notify_cpu_starting(cpuid);
> 
> Its absolutely broken to call CPU_STARTING after the master cpu is
> told
> to continue. Once it returns from cpu_up() it assumes the secondary
> is
> completely initialized and ready to run.
Wouldn't master cpu stop in  native_cpu_up() and wait till AP will set cpu_online_mask?

        local_irq_save(flags);
        check_tsc_sync_source(cpu);
        local_irq_restore(flags);

        while (!cpu_online(cpu)) {
                cpu_rela);
                touch_nmi_watchdog();
        }

So it shouldn't do anything till AP is online.

> 
> > +	return;
> > +
> > +die:
> 
> You've forgotten to clean up the bits set by set_cpu_sibling_map().
Thanks, I'll fix it.

> 
> > +	/* was set by cpu_init() */
> > +	cpumask_clear_cpu(smp_processor_id(), cpu_initialized_mask);
> > +	cpumask_clear_cpu(smp_processor_id(), cpu_callin_mask);
> > +	clear_local_APIC();
> > +	play_dead();
> >  }
> >  
> >  /*
> > @@ -774,6 +799,8 @@ do_rest:
> >  		}
> >  
> >  		if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
> > +			/* Signal AP that it may continue to boot */
> > +			cpumask_set_cpu(cpu, cpu_may_complete_boot_mask);
> >  			print_cpu_msr(&cpu_data(cpu));
> >  			pr_debug("CPU%d: has booted.\n", cpu);
> >  		} else {
> > @@ -1250,6 +1277,7 @@ static void __ref remove_cpu_from_maps(int
> > cpu)
> >  	cpumask_clear_cpu(cpu, cpu_callin_mask);
> >  	/* was set by cpu_init() */
> >  	cpumask_clear_cpu(cpu, cpu_initialized_mask);
> > +	cpumask_clear_cpu(cpu, cpu_may_complete_boot_mask);
> >  	numa_remove_cpu(cpu);
> >  }
> >  
> 
> 
