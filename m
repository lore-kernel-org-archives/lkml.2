Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2FRDGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 23:06:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:36555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab2FRDGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 23:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113155811"
Message-ID: <4FDE9B1B.8080707@intel.com>
Date: Mon, 18 Jun 2012 11:06:03 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 07/13] perf: Generic pci uncore device support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>  <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com> <1339776173.2559.77.camel@twins>
In-Reply-To: <1339776173.2559.77.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2012 12:02 AM, Peter Zijlstra wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
>> @@ -305,6 +310,22 @@ struct intel_uncore_box *uncore_alloc_box(int cpu)
>>  static struct intel_uncore_box *
>>  uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
>>  {
>> +       static struct intel_uncore_box *box;
>> +
>> +       box =  *per_cpu_ptr(pmu->box, cpu);
>> +       if (box)
>> +               return box;
>> +
>> +       raw_spin_lock(&uncore_box_lock);
>> +       list_for_each_entry(box, &pmu->box_list, list) {
>> +               if (box->phys_id == topology_physical_package_id(cpu)) {
>> +                       atomic_inc(&box->refcnt);
>> +                       *per_cpu_ptr(pmu->box, cpu) = box;
>> +                       break;
>> +               }
>> +       }
>> +       raw_spin_unlock(&uncore_box_lock);
>> +
>>         return *per_cpu_ptr(pmu->box, cpu);
>>  } 
> 
> So why can't we do that lookup from a hotplug notifier?
> 
We can. But I personally prefer not to mix pci uncore initialization
code with cpu hotplug notifier. Because pci hotplug and cpu hotplug
are separate process, I'm not completely sure which one happens first.

Regards
Yan, Zheng 

