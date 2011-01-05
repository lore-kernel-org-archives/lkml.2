Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab1AEFXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:23:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:29515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab1AEFXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:23:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,276,1291622400"; 
   d="scan'208";a="693685199"
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20110104142203.GA5207@aftab>
References: <1293464287.2695.106.camel@localhost>
	 <1294142776.2016.133.camel@laptop>  <20110104142203.GA5207@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 13:24:00 +0800
Message-ID: <1294205040.9261.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 22:22 +0800, Borislav Petkov wrote:
> Adding Andreas since this is his code.
> 
> On Tue, Jan 04, 2011 at 07:06:16AM -0500, Peter Zijlstra wrote:
> > On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> > > Currently we iterate the full machine looking for a matching core_id/nb
> > > for the percore and the amd northbridge stuff , using a smaller topology
> > > mask makes sense. 
> > > 
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
> > >  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > > index 67e2202..5a3b7b8 100644
> > > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > > @@ -323,7 +323,7 @@ static void amd_pmu_cpu_starting(int cpu)
> > >  	nb_id = amd_get_nb_id(cpu);
> > >  	WARN_ON_ONCE(nb_id == BAD_APICID);
> > >  
> > > -	for_each_online_cpu(i) {
> > > +	for_each_cpu(i, topology_core_cpumask(cpu)) {
> > >  		nb = per_cpu(cpu_hw_events, i).amd_nb;
> > >  		if (WARN_ON_ONCE(!nb))
> > >  			continue;
> > 
> > Borislav, is topology_core_cpumask() the right mask for northbridge_id
> > span? I could imagine Magny-Cours would have all 12 cores in the
> > core_cpumask() and have the node_mask() be half that.
> 
> So, topology_core_cpumask() or cpu_core_mask() both are cpu_core_map
> which represents the socket mask. I.e., on a multisocket cpu you'll have
> in it all the cores on one socket. A 12-cores Magny-Cours contains two
> internal northbridges and this mask will have 12 bits set.
> 
> AFAICT, you want to iterate over the cores on a single node here
> (an internal node in the Magny-Cours case) so for this we have the
> llc_shared_map. See near the top of cache_shared_cpu_map_setup() in
> <arch/x86/kernel/cpu/intel_cacheinfo.c> for an example.

cpu_coregroup_mask() seems the right mask for northbridge_id span.

arch/x86/kernel/smpboot.c:

/* maps the cpu to the sched domain representing multi-core */
const struct cpumask *cpu_coregroup_mask(int cpu)
{
        struct cpuinfo_x86 *c = &cpu_data(cpu);
        /*
         * For perf, we return last level cache shared map.
         * And for power savings, we return cpu_core_map
         */
        if ((sched_mc_power_savings || sched_smt_power_savings) &&
            !(cpu_has(c, X86_FEATURE_AMD_DCM)))
                return cpu_core_mask(cpu);
        else
                return c->llc_shared_map;
}


> 
> node_mask() is roughly the same but contains correct info only with
> CONFIG_NUMA on and correct SRAT table on the system.
> 
> HTH.
> 


