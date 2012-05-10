Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2EJHex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:34:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:64179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab2EJHew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164314889"
Message-ID: <4FAB6F99.6010408@intel.com>
Date: Thu, 10 May 2012 15:34:49 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>  <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com> <1336065156.22523.34.camel@twins>
In-Reply-To: <1336065156.22523.34.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 01:12 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
>> +static struct intel_uncore_box *
>> +__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
>> +{
>> +       struct intel_uncore_box *box;
>> +       struct hlist_head *head;
>> +       struct hlist_node *node;
>> +
>> +       head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
>> +       hlist_for_each_entry_rcu(box, node, head, hlist) {
>> +               if (box->phy_id == phyid)
>> +                       return box;
>> +       }
>> +
>> +       return NULL;
>> +} 
> 
> I still don't get why something like:
> 
> static struct intel_uncore_box *
> pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
> {
> 	return per_cpu_ptr(pmu->box, cpu);
> }
> 
> doesn't work.
> 
> Last time you mumbled something about PCI devices, but afaict those are
> in all respects identical to MSR devices except you talk to them using
> PCI-mmio instead of MSR registers.
> 
> In fact, since its all local to the generic code there's nothing
> different between pci/msr already.
> 
> So how about something like this:
> 
> ---
>  Makefile                  |    4 +-
>  perf_event_intel_uncore.c |   92 ++++++++++++++++++----------------------------
>  perf_event_intel_uncore.h |    4 +-
>  3 files changed, 42 insertions(+), 58 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -32,7 +32,9 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event
>  
>  ifdef CONFIG_PERF_EVENTS
>  obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
> -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o perf_event_intel_uncore.o
> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o 
> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o 
> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
>  endif
>  
>  obj-$(CONFIG_X86_MCE)			+= mcheck/
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -116,40 +116,21 @@ struct intel_uncore_box *uncore_alloc_bo
>  }
>  
>  static struct intel_uncore_box *
> -__uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
> +uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
>  {
> -	struct intel_uncore_box *box;
> -	struct hlist_head *head;
> -	struct hlist_node *node;
> -
> -	head = &pmu->box_hash[phyid % UNCORE_BOX_HASH_SIZE];
> -	hlist_for_each_entry_rcu(box, node, head, hlist) {
> -		if (box->phy_id == phyid)
> -			return box;
> -	}
> -
> -	return NULL;
> -}
> -
> -static struct intel_uncore_box *
> -uncore_pmu_find_box(struct intel_uncore_pmu *pmu, int phyid)
> -{
> -	struct intel_uncore_box *box;
> -
> -	rcu_read_lock();
> -	box = __uncore_pmu_find_box(pmu, phyid);
> -	rcu_read_unlock();
> -
> -	return box;
> +	return per_cpu_ptr(pmu->box, cpu);
>  }
>  
>  static void uncore_pmu_add_box(struct intel_uncore_pmu *pmu,
>  				struct intel_uncore_box *box)
>  {
> -	struct hlist_head *head;
> +	int cpu;
>  
> -	head = &pmu->box_hash[box->phy_id % UNCORE_BOX_HASH_SIZE];
> -	hlist_add_head_rcu(&box->hlist, head);
> +	for_each_cpu(cpu) {
> +		if (box->phys_id != topology_physical_package_id(cpu))
> +			continue;
> +		per_cpu_ptr(pmu->box, cpu) = box;
> +	}
>  }

This code doesn't work for PCI uncore device if there are offline CPUs,
because topology_physical_package_id() always return 0 for offline CPUs.
So besides the per CPU variable, we still need another data structure
to track the uncore boxes. Do you still want to use per CPU variable?

Regards
Yan, Zheng

