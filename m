Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1AEKIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:08:21 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45149 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1AEKIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:08:18 -0500
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, "Luck, Tony" <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1294206320.9261.23.camel@minggr.sh.intel.com>
References: <1293464211.2695.104.camel@localhost>
	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	 <1293526288.2457.4.camel@minggr.sh.intel.com>
	 <1294052312.2016.50.camel@laptop>	<4D222926.9010206@zytor.com>
	 <1294139419.2016.115.camel@laptop>
	 <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
	 <1294148675.2016.139.camel@laptop>
	 <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
	 <1294206320.9261.23.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 11:08:41 +0100
Message-ID: <1294222121.2016.221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 13:45 +0800, Lin Ming wrote:
> static void intel_pmu_cpu_starting(int cpu)
> {
>         struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
>         struct intel_percore *pc;
>         int core_id = topology_core_id(cpu);
>         int i;
> 
>         init_debug_store_on_cpu(cpu);
>         /*
>          * Deal with CPUs that don't clear their LBRs on power-up.
>          */
>         intel_pmu_lbr_reset();
> 
>         if (!ht_enabled(cpu))
>                 return;
> 
>         cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
>                                       GFP_KERNEL, cpu_to_node(cpu));

#define CPU_STARTING            0x000A /* CPU (unsigned)v soon running.
                                        * Called on the new cpu, just before
                                        * enabling interrupts. Must not sleep,
                                        * must not fail */


>         if (!cpuc->per_core)
>                 return;
> 
>         raw_spin_lock_init(&cpuc->per_core->lock);
>         pc = cpuc->per_core;
> 
>         for_each_cpu(i, topology_thread_cpumask(cpu)) {
>                 cpuc = &per_cpu(cpu_hw_events, cpu);
> 
>                 cpuc->per_core = pc;
>                 cpuc->per_core->core_id = core_id;
>                 cpuc->per_core->refcnt++;
>         }
> } 

Anyway, I think something like:

static bool ht_capable(void)
{
	return boot_cpu_has(X86_FEATURE_HT) && smp_num_siblings > 1;
}

is sufficient, the whole hotplug issues makes relying on enumeration
results impractical.
