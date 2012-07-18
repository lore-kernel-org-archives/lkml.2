Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2GRQxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:53:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51990 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2GRQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:53:07 -0400
Message-ID: <5006E9E6.2030004@gmail.com>
Date: Thu, 19 Jul 2012 00:52:54 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Jianguo Wu <wujianguo@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
References: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207171237320.15177@router.home>
In-Reply-To: <alpine.DEB.2.00.1207171237320.15177@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
	I found the previous analysis of the BUG_ON() issue is incorrect after
another round of code review. 
	The really issue is that function early_kmem_cache_node_alloc() calls
inc_slabs_node(kmem_cache_node, node, page->objects) to increase the object 
count on local node no matter whether page is allocated from local or remote
node. With current implementation it's OK because every memory node has normal
memory so page is allocated from local node. Now we are working on a patch set
to improve memory hotplug. The basic idea is to to let some memory nodes only
host ZONE_MOVABLE zone, so we could easily remove the whole memory node when 
needed. That means some memory nodes have no ZONE_NORMAL/ZONE_DMA, and the page
will be allocated from remote node in function early_kmem_cache_node_alloc().
But early_kmem_cache_node_alloc() still increases object count on local node,
which triggers the BUG_ON eventually when removing the affected memory node.
	I will try to work out another version for it.
	Thanks!
	Gerry

On 07/18/2012 01:39 AM, Christoph Lameter wrote:
> On Wed, 18 Jul 2012, Jiang Liu wrote:
> 
>> From: Jianguo Wu <wujianguo@huawei.com>
>>
>> From: Jianguo Wu <wujianguo@huawei.com>
>>
>> SLUB allocator may cause a BUG_ON() when offlining a memory node if
>> CONFIG_SLUB_DEBUG is on. The scenario is:
>>
>> 1) when creating kmem_cache_node slab, it cause inc_slabs_node() twice.
>> early_kmem_cache_node_alloc
>> 	->new_slab
>> 		->inc_slabs_node
>> 	->inc_slabs_node
> 
> New slab will not be able to increment the slab counter. It will
> check that there is no per node structure yet and then skip the inc slabs
> node.
> 
> This suggests that a call to early_kmem_cache_node_alloc was not needed
> because the per node structure already existed. Lets fix that instead.
> 


