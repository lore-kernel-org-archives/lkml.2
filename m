Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1ADGSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:18:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:39962 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1ADGSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:18:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,270,1291622400"; 
   d="scan'208";a="874197539"
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1294052530.2016.52.camel@laptop>
References: <1293464287.2695.106.camel@localhost>
	 <1294052530.2016.52.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 14:18:37 +0800
Message-ID: <1294121917.23205.123.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 19:02 +0800, Peter Zijlstra wrote:
> On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> > Currently we iterate the full machine looking for a matching core_id/nb
> > for the percore and the amd northbridge stuff , using a smaller topology
> > mask makes sense. 
> 
> Does topology_thread_cpumask() include offline cpus? I tried looking at
> it, but I cannot find any code clearing bits in that mask on offline.

No, it does not include offline cpus.
For x86 code, remove_siblinginfo() clears the bits.

take_cpu_down ->
  __cpu_disable ->
    native_cpu_disable ->
      cpu_disable_common ->
        remove_siblinginfo

static void remove_siblinginfo(int cpu)
{
        int sibling;
        struct cpuinfo_x86 *c = &cpu_data(cpu);

        for_each_cpu(sibling, cpu_core_mask(cpu)) {
                cpumask_clear_cpu(cpu, cpu_core_mask(sibling));
                /*/
                 * last thread sibling in this cpu core going down
                 */
                if (cpumask_weight(cpu_sibling_mask(cpu)) == 1)
                        cpu_data(sibling).booted_cores--;
        }

        for_each_cpu(sibling, cpu_sibling_mask(cpu))
                cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
        cpumask_clear(cpu_sibling_mask(cpu));
        cpumask_clear(cpu_core_mask(cpu));
        c->phys_proc_id = 0;
        c->cpu_core_id = 0;
        cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
}

Lin Ming

> 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
> >  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > index 67e2202..5a3b7b8 100644
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -323,7 +323,7 @@ static void amd_pmu_cpu_starting(int cpu)
> >  	nb_id = amd_get_nb_id(cpu);
> >  	WARN_ON_ONCE(nb_id == BAD_APICID);
> >  
> > -	for_each_online_cpu(i) {
> > +	for_each_cpu(i, topology_core_cpumask(cpu)) {
> >  		nb = per_cpu(cpu_hw_events, i).amd_nb;
> >  		if (WARN_ON_ONCE(!nb))
> >  			continue;
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 354d1de..ad70c2c 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -1111,7 +1111,7 @@ static void intel_pmu_cpu_starting(int cpu)
> >  	if (!ht_enabled(cpu))
> >  		return;
> >  
> > -	for_each_online_cpu(i) {
> > +	for_each_cpu(i, topology_thread_cpumask(cpu)) {
> >  		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
> >  
> >  		if (pc && pc->core_id == core_id) {
> 
> 


