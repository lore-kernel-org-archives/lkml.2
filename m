Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab0EUEGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 00:06:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:18270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0EUEGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 00:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,275,1272870000"; 
   d="scan'208";a="519962541"
From: "Guo, Chaohong" <chaohong.guo@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       minskey guo <chaohong_guo@linux.intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "prarit@redhat.com" <prarit@redhat.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, "stable@kernel.org" <stable@kernel.org>
Date: Fri, 21 May 2010 12:05:16 +0800
Subject: RE: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Thread-Topic: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Thread-Index: Acr4XTNFhxPnwoo4RjmGrnB9cZE4oQAPHMfg
Message-ID: <CF2F38D4AE21BB4CB845318E4C5ECB671E718CC9@shsmsx501.ccr.corp.intel.com>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
 <20100520134359.fdfb397e.akpm@linux-foundation.org>
In-Reply-To: <20100520134359.fdfb397e.akpm@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> The operation of "enable CPU to online before memory within a node"
>> fails in some case according to Prarit. The warnings as follows:
>>
>> Pid: 7440, comm: bash Not tainted 2.6.32 #2
>> Call Trace:
>>  [<ffffffff81155985>] pcpu_alloc+0xa05/0xa70
>>  [<ffffffff81155a20>] __alloc_percpu+0x10/0x20
>>  [<ffffffff81089605>] __create_workqueue_key+0x75/0x280
>>  [<ffffffff8110e050>] ? __build_all_zonelists+0x0/0x5d0
>>  [<ffffffff810c1eba>] stop_machine_create+0x3a/0xb0
>>  [<ffffffff810c1f57>] stop_machine+0x27/0x60
>>  [<ffffffff8110f1a0>] build_all_zonelists+0xd0/0x2b0
>>  [<ffffffff814c1d12>] cpu_up+0xb3/0xe3
>>  [<ffffffff814b3c40>] store_online+0x70/0xa0
>>  [<ffffffff81326100>] sysdev_store+0x20/0x30
>>  [<ffffffff811d29a5>] sysfs_write_file+0xe5/0x170
>>  [<ffffffff81163d28>] vfs_write+0xb8/0x1a0
>>  [<ffffffff810cfd22>] ? audit_syscall_entry+0x252/0x280
>>  [<ffffffff81164761>] sys_write+0x51/0x90
>>  [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
>> Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 12331603
>> PERCPU: allocation failed, size=128 align=64, failed to populate
>>
>> With "enable CPU to online before memory" patch, when the 1st CPU of
>> an offlined node is being onlined, we build zonelists for that node.
>> If per-cpu area needs to be extended during zonelists building period,
>> alloc_pages_node() will be called. The routine alloc_pages_node() fails
>> on the node in-onlining because the node doesn't have zonelists created
>> yet.
>>
>> To fix this issue,  we try to alloc memory from current node.
>
>How serious is this issue?  Just a warning?  Dead box?
>
>Because if we want to port this fix into 2.6.34.x, we have a little
>problem.


when onlining CPU within a node without local memory , at that time, if
per-cpu-area were used up and failed to be extended, there will be many
warnings about the failure of pcpu_allco(),  and at last, an out-of-memory 
is triggered and some processes get killed by OOM.


-minskey

















>
>
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -714,13 +714,29 @@ static int pcpu_alloc_pages(struct pcpu_chunk
>*chunk,
>
>In linux-next, Tejun has gone and moved pcpu_alloc_pages() into the new
>mm/percpu-vm.c.  So either
>
>a) the -stable guys will need to patch a different file or
>
>b) we apply this fix first and muck up Tejun's tree or
>
>c) the bug isn't very serious so none of this applies.
>
>>  {
>>  	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
>>  	unsigned int cpu;
>> +	int nid;
>>  	int i;
>>
>>  	for_each_possible_cpu(cpu) {
>>  		for (i = page_start; i < page_end; i++) {
>>  			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
>>
>> -			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
>> +			nid = cpu_to_node(cpu);
>> +
>> +			/*
>> +			 * It is allowable to online a CPU within a NUMA
>> +			 * node which doesn't have onlined local memory.
>> +			 * In this case, we need to create zonelists for
>> +			 * that node when cpu is being onlined. If per-cpu
>> +			 * area needs to be extended at the exact time when
>> +			 * zonelists of that node is being created, we alloc
>> +			 * memory from current node.
>> +			 */
>> +			if ((nid == -1) ||
>> +			    !(node_zonelist(nid, GFP_KERNEL)->_zonerefs->zone))
>> +				nid = numa_node_id();
>> +
>> +			*pagep = alloc_pages_node(nid, gfp, 0);
>>  			if (!*pagep) {
>>  				pcpu_free_pages(chunk, pages, populated,
>>  						page_start, page_end);

