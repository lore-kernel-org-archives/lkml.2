Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2HJIud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:50:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58295 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2HJIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:50:28 -0400
Message-ID: <5024CADC.1010202@huawei.com>
Date: Fri, 10 Aug 2012 16:48:28 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "Christoph Lameter (Open Source)" <cl@linux.com>
CC: Wu Jianguo <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH] mm: introduce N_LRU_MEMORY to distinguish between
 normal and movable memory
References: <1344482788-4984-1-git-send-email-guohanjun@huawei.com> <50233EF5.3050605@huawei.com> <alpine.DEB.2.02.1208090900450.15909@greybox.home>
In-Reply-To: <alpine.DEB.2.02.1208090900450.15909@greybox.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.69.25]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/8/9 22:06, Christoph Lameter (Open Source) wrote:
> On Thu, 9 Aug 2012, Hanjun Guo wrote:
> 
>> Now, We have node masks for both N_NORMAL_MEMORY and
>> N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
>> But we still don't have such a mechanism to distinguish between "normal" and "movable"
>> memory.
> 
> What is the exact difference that you want to establish?

Hi Christoph,
    Thanks for your comments very much!

We want to identify the node only has ZONE_MOVABLE memory.
for example:
	node 0: ZONE_DMA, ZONE_DMA32, ZONE_NORMAL--> N_LRU_MEMORY, N_NORMAL_MEMORY
	node 1: ZONE_MOVABLE			 --> N_LRU_MEMORY
thus, in SLUB allocator, will not allocate memory control structures for node1.

static int init_kmem_cache_nodes(struct kmem_cache *s)
{
	int node;

	for_each_node_state(node, N_NORMAL_MEMORY) { /* <-- skip nodes only has ZONE_MOVABLE memory */
		struct kmem_cache_node *n;

		if (slab_state == DOWN) {
			early_kmem_cache_node_alloc(node);
			continue;
		}
		n = kmem_cache_alloc_node(kmem_cache_node,
						GFP_KERNEL, node);

		...
	}
	...
}

> 
>> As suggested by Christoph Lameter in threads
>> http://marc.info/?l=linux-mm&m=134323057602484&w=2, we introduce N_LRU_MEMORY to
>> distinguish between "normal" and "movable" memory.
> 
> Well seems that I am having second thoughts about this. While is it true
> that current page migration can only move pages on the LRU there are
> already various mechanisms proposed and implemented that can move pages
> not on the LRU (like page table pages). Not sure if this is still a useful
> distinction to make. There is also the issue that segments from
> "N_LRU_MEMORY" may be allocated and then become not movable anymore.

Some kernel pages，like memmap pages，usemap pages are still can not be
migrated.

> 
> For the slab case that you want to solve here you will need to know if the
> node has *only* movable memory and will never have any ZONE_NORMAL memory.
> If so then memory control structures for allocators that do not allow
> movable memory will not need to be allocated for these node. The node can
> be excluded from handling.

I think this is what we are trying to do in this patch.
did I miss something?

> 
> .
> 


