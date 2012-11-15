Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2KOGtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:49:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:35585 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2KOGtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:49:51 -0500
X-IronPort-AV: E=Sophos;i="4.83,255,1352044800"; 
   d="scan'208";a="6203968"
Message-ID: <50A48CCD.4090604@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 14:33:49 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART3 Patch 00/14] introduce N_MEMORY
References: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com>	<alpine.DEB.2.00.1210311112010.8809@chino.kir.corp.google.com>	<509212FC.8070802@cn.fujitsu.com>	<alpine.DEB.2.00.1211011431130.19373@chino.kir.corp.google.com>	<50937943.2040302@cn.fujitsu.com> <20121114115227.8763c3cd.akpm@linux-foundation.org>
In-Reply-To: <20121114115227.8763c3cd.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:27:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/15 14:27:35,
	Serialize complete at 2012/11/15 14:27:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/15/2012 03:52 AM, Andrew Morton Wrote:
> On Fri, 02 Nov 2012 15:41:55 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> At 11/02/2012 05:36 AM, David Rientjes Wrote:
>>> On Thu, 1 Nov 2012, Wen Congyang wrote:
>>>
>>>>> This doesn't describe why we need the new node state, unfortunately.  It 
>>>>
>>>> 1. Somethimes, we use the node which contains the memory that can be used by
>>>>    kernel.
>>>> 2. Sometimes, we use the node which contains the memory.
>>>>
>>>> In case1, we use N_HIGH_MEMORY, and we use N_MEMORY in case2.
>>>>
>>>
>>> Yeah, that's clear, but the question is still _why_ we want two different 
>>> nodemasks.  I know that this part of the patchset simply introduces the 
>>> new nodemask because the name "N_MEMORY" is more clear than 
>>> "N_HIGH_MEMORY", but there's no real incentive for making that change by 
>>> introducing a new nodemask where a simple rename would suffice.
>>>
>>> I can only assume that you want to later use one of them for a different 
>>> purpose: those that do not include nodes that consist of only 
>>> ZONE_MOVABLE.  But that change for MPOL_BIND is nacked since it 
>>> significantly changes the semantics of set_mempolicy() and you can't break 
>>> userspace (see my response to that from yesterday).  Until that problem is 
>>> addressed, then there's no reason for the additional nodemask so nack on 
>>> this series as well.
> 
> I cannot locate "my response to that from yesterday".  Specificity, please!
> 
>>
>> I still think that we need two nodemasks: one store the node which has memory
>> that the kernel can use, and one store the node which has memory.
>>
>> For example:
>>
>> ==========================
>> static void *__meminit alloc_page_cgroup(size_t size, int nid)
>> {
>> 	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
>> 	void *addr = NULL;
>>
>> 	addr = alloc_pages_exact_nid(nid, size, flags);
>> 	if (addr) {
>> 		kmemleak_alloc(addr, size, 1, flags);
>> 		return addr;
>> 	}
>>
>> 	if (node_state(nid, N_HIGH_MEMORY))
>> 		addr = vzalloc_node(size, nid);
>> 	else
>> 		addr = vzalloc(size);
>>
>> 	return addr;
>> }
>> ==========================
>> If the node only has ZONE_MOVABLE memory, we should use vzalloc().
>> So we should have a mask that stores the node which has memory that
>> the kernel can use.
>>
>> ==========================
>> static int mpol_set_nodemask(struct mempolicy *pol,
>> 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
>> {
>> 	int ret;
>>
>> 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
>> 	if (pol == NULL)
>> 		return 0;
>> 	/* Check N_HIGH_MEMORY */
>> 	nodes_and(nsc->mask1,
>> 		  cpuset_current_mems_allowed, node_states[N_HIGH_MEMORY]);
>> ...
>> 		if (pol->flags & MPOL_F_RELATIVE_NODES)
>> 			mpol_relative_nodemask(&nsc->mask2, nodes,&nsc->mask1);
>> 		else
>> 			nodes_and(nsc->mask2, *nodes, nsc->mask1);
>> ...
>> }
>> ==========================
>> If the user specifies 2 nodes: one has ZONE_MOVABLE memory, and the other one doesn't.
>> nsc->mask2 should contain these 2 nodes. So we should hava a mask that store the node
>> which has memory.
>>
>> There maybe something wrong in the change for MPOL_BIND. But this patchset is needed.
> 
> Well, let's discuss the userspace-visible non-back-compatible mpol
> change.  What is it, why did it happen, what is its impact, is it
> acceptable?

With the all patchsets, we can make a node which only has ZONE_MOVABLE memory.
When we test this feature, we found a problem: we can't bind a task to
such node, because there is no normal memory on this node.

According to the comment in policy_nodemask():
===============
static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy)
{
	/* Lower zones don't get a nodemask applied for MPOL_BIND */
	if (unlikely(policy->mode == MPOL_BIND) &&
			gfp_zone(gfp) >= policy_zone &&
			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
		return &policy->v.nodes;

	return NULL;
}
===============

The mempolicy may only affect the memory for userspace. So I think we should
allow the user to bind a task to a movable node.

So we modify the function is_valid_nodemask() in part6 to allow the user to
do this.

We modify the function policy_nodemask() in part6, because:
we may allocate memory in task context(For example: fork a process, and allocate
memory to manage the new task), and the memory is used by the kernel(we can't
access it in userspace). In this case, gfp_zone() is ZONE_NORMAL, and
gfp_zone() >= policy_zone is true. Now we will return policy->v.nodes, and will
try allocate the memory in movable node. We can't allocate memory now.
So we modify the function policy_nodemask() to fix this problem.

Does this change mpol?

Thanks
Wen Congyang

> 
> I grabbed "PART1" and "PART2", but that's as far as I got with the six
> memory hotplug patch series.
> 

