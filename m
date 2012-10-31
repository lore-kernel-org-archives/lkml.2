Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2JaHEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:04:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2JaHD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:03:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,686,1344182400"; 
   d="scan'208";a="6106412"
Message-ID: <5090CD48.30604@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 15:03:36 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [V5 PATCH 05/26] node_states: introduce N_MEMORY
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com> <1351524078-20363-4-git-send-email-laijs@cn.fujitsu.com> <alpine.DEB.2.00.1210291342090.18552@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210291342090.18552@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:57:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:57:12,
	Serialize complete at 2012/10/31 14:57:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/30/2012 04:46 AM, David Rientjes Wrote:
> On Mon, 29 Oct 2012, Lai Jiangshan wrote:
> 
>> We have N_NORMAL_MEMORY for standing for the nodes that have normal memory with
>> zone_type <= ZONE_NORMAL.
>>
>> And we have N_HIGH_MEMORY for standing for the nodes that have normal or high
>> memory.
>>
> 
> (In other words, all memory.)
> 
>> But we don't have any word to stand for the nodes that have *any* memory.
>>
> 
> It's N_HIGH_MEMORY, or at least it's supposed to be.  Is there a problem 
> where the bit isn't getting set for a node with memory?
> 
>> A)	But this reusing is bad for *readability*. Because the name
>> 	N_HIGH_MEMORY just stands for high or normal:
>>
>> A.example 1)
>> 	mem_cgroup_nr_lru_pages():
>> 		for_each_node_state(nid, N_HIGH_MEMORY)
>>
>> 	The user will be confused(why this function just counts for high or
>> 	normal memory node? does it counts for ZONE_MOVABLE's lru pages?)
>> 	until someone else tell them N_HIGH_MEMORY is reused to stand for
>> 	nodes that have any memory.
>>
>> A.cont) If we introduce N_MEMORY, we can reduce this confusing
>> 	AND make the code more clearly:
>>
>> A.example 2) mm/page_cgroup.c use N_HIGH_MEMORY twice:
>>
>> 	One is in page_cgroup_init(void):
>> 		for_each_node_state(nid, N_HIGH_MEMORY) {
>>
>> 	It means if the node have memory, we will allocate page_cgroup map for
>> 	the node. We should use N_MEMORY instead here to gaim more clearly.
>>
>> 	The second using is in alloc_page_cgroup():
>> 		if (node_state(nid, N_HIGH_MEMORY))
>> 			addr = vzalloc_node(size, nid);
>>
>> 	It means if the node has high or normal memory that can be allocated
>> 	from kernel. We should keep N_HIGH_MEMORY here, and it will be better
>> 	if the "any memory" semantic of N_HIGH_MEMORY is removed.
>>
>> B)	This reusing is out-dated if we introduce MOVABLE-dedicated node.
>> 	The MOVABLE-dedicated node should not appear in
>> 	node_stats[N_HIGH_MEMORY] nor node_stats[N_NORMAL_MEMORY],
>> 	because MOVABLE-dedicated node has no high or normal memory.
>>
>> 	In x86_64, N_HIGH_MEMORY=N_NORMAL_MEMORY, if a MOVABLE-dedicated node
>> 	is in node_stats[N_HIGH_MEMORY], it is also means it is in
>> 	node_stats[N_NORMAL_MEMORY], it causes SLUB wrong.
>>
>> 	The slub uses
>> 		for_each_node_state(nid, N_NORMAL_MEMORY)
>> 	and creates kmem_cache_node for MOVABLE-dedicated node and cause problem.
>>
>> In one word, we need a N_MEMORY. We just intrude it as an alias to
>> N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late patches.
>>
> 
> If this is really that problematic (and it appears it's not given that 
> there are many use cases of it and people tend to get it right), then why 
> not simply rename N_HIGH_MEMORY instead of introducing yet another 
> nodemask to the equation?

The reason is that we need a node which only contains movable memory. This
feature is very important for node hotplug. So we will add a new nodemask
for movable memory. N_MEMORY contains movable memory but N_HIGH_MEMORY
doesn't contain it.

Thanks
Wen Congyang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

