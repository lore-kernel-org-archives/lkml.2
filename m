Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1AEJu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:50:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40041 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1AEJu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:50:57 -0500
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <1294205040.9261.4.camel@minggr.sh.intel.com>
References: <1293464287.2695.106.camel@localhost>
	 <1294142776.2016.133.camel@laptop>  <20110104142203.GA5207@aftab>
	 <1294205040.9261.4.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:51:11 +0100
Message-ID: <1294221071.2016.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 13:24 +0800, Lin Ming wrote:
> > > > + for_each_cpu(i, topology_core_cpumask(cpu)) {
> > > >           nb = per_cpu(cpu_hw_events, i).amd_nb;
> > > >           if (WARN_ON_ONCE(!nb))
> > > >                   continue;
> > > 
> > > Borislav, is topology_core_cpumask() the right mask for northbridge_id
> > > span? I could imagine Magny-Cours would have all 12 cores in the
> > > core_cpumask() and have the node_mask() be half that.
> > 
> > So, topology_core_cpumask() or cpu_core_mask() both are cpu_core_map
> > which represents the socket mask. I.e., on a multisocket cpu you'll have
> > in it all the cores on one socket. A 12-cores Magny-Cours contains two
> > internal northbridges and this mask will have 12 bits set.
> > 
> > AFAICT, you want to iterate over the cores on a single node here
> > (an internal node in the Magny-Cours case) so for this we have the
> > llc_shared_map. See near the top of cache_shared_cpu_map_setup() in
> > <arch/x86/kernel/cpu/intel_cacheinfo.c> for an example.
> 
> cpu_coregroup_mask() seems the right mask for northbridge_id span.
> 
> arch/x86/kernel/smpboot.c:
> 
> /* maps the cpu to the sched domain representing multi-core */
> const struct cpumask *cpu_coregroup_mask(int cpu)
> {
>         struct cpuinfo_x86 *c = &cpu_data(cpu);
>         /*
>          * For perf, we return last level cache shared map.
>          * And for power savings, we return cpu_core_map
>          */
>         if ((sched_mc_power_savings || sched_smt_power_savings) &&
>             !(cpu_has(c, X86_FEATURE_AMD_DCM)))
>                 return cpu_core_mask(cpu);
>         else
>                 return c->llc_shared_map;
> } 

Argh, that function really must die, its the most horrible brain damage
around. Andreas promised he'd clean that up after making it worse for
Magny-Cours.

But yes, assuming all Magny-Cours have this AMD_DCM thing set, it seems
to return the right map.
