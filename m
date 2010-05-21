Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0EUJM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:12:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:26598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab0EUJMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,277,1272870000"; 
   d="scan'208";a="520018097"
Message-ID: <4BF64E79.4010401@linux.intel.com>
Date: Fri, 21 May 2010 17:12:25 +0800
From: minskey guo <chaohong_guo@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       minskey guo <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>	<20100520134359.fdfb397e.akpm@linux-foundation.org>	<20100521105512.0c2cf254.sfr@canb.auug.org.au>	<20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>	<4BF642BB.2020402@linux.intel.com> <20100521173940.8f130205.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100521173940.8f130205.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2010 04:39 PM, KAMEZAWA Hiroyuki wrote:
> On Fri, 21 May 2010 16:22:19 +0800
> minskey guo<chaohong_guo@linux.intel.com>  wrote:
>
>> Yes.  I can use cpu_to_mem().  only some little difference during
>> CPU online:  1st cpu within memoryless node gets memory from current
>> node or the node to which the cpu0 belongs,
>>
>>
>> But I have a question about the patch:
>>
>>      numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch,
>>
>>
>>
>>
>> @@ -2968,9 +2991,23 @@ static int __build_all_zonelists(void *d
>> ...
>>
>> -	for_each_possible_cpu(cpu)
>> +	for_each_possible_cpu(cpu) {
>> 		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
>> ...
>>
>> +#ifdef CONFIG_HAVE_MEMORYLESS_NODES
>> + 	if (cpu_online(cpu))
>> +		cpu_to_mem(cpu) = local_memory_node(cpu_to_node(cpu));
>> +#endif

Look at the above code,  int __build_all_zonelists(),  cpu_to_mem(cpu)
is set only when cpu is onlined.  Suppose that a node with local memory,
all memory segments are onlined first, and then,  cpus within that node
are onlined one by one,  in this case,  where does the cpu_to_mem(cpu)
for the last cpu get its value ?


>
> So, cpu_to_node(cpu) for possible cpus will have NUMA_NO_NODE(-1)
> or the number of the nearest node.
>
> IIUC, if SRAT is not broken, all pxm has its own node_id.

Thank you very much for the info,  I have been thinking why node_id
is (-1) in some cases.


-minskey
