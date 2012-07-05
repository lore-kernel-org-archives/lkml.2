Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2GEP4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:56:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2GEP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:56:13 -0400
Message-ID: <4FF5B909.30409@gmail.com>
Date: Thu, 05 Jul 2012 23:55:53 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] mm: introduce a safer interface to check whether
 a page is managed by SLxB
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207050942540.4984@router.home>
In-Reply-To: <alpine.DEB.2.00.1207050942540.4984@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 10:45 PM, Christoph Lameter wrote:
> On Tue, 3 Jul 2012, Jiang Liu wrote:
> 
>> Several subsystems, including memory-failure, swap, sparse, DRBD etc,
>> use PageSlab() to check whether a page is managed by SLAB/SLUB/SLOB.
>> And they treat slab pages differently from pagecache/anonymous pages.
>>
>> But it's unsafe to use PageSlab() to detect whether a page is managed by
>> SLUB. SLUB allocates compound pages when page order is bigger than 0 and
>> only sets PG_slab on head pages. So if a SLUB object is hosted by a tail
>> page, PageSlab() will incorrectly return false for that object.
> 
> This is not an issue only with slab allocators. Multiple kernel systems
> may do a compound order allocation for some or the other metadata and
> will not mark the page in any special way. What makes the slab allocators
> so special that you need to do this?
HI Chris,
	I think here PageSlab() is used to check whether a page hosting a memory
object is managed/allocated by the slab allocator. If it's allocated by slab 
allocator, we could use kfree() to free the object.
	For SLUB allocator, if the memory space needed to host a memory object
is bigger than 2 pages, it directly depends on page allocator to fulfill the
request. But SLUB may allocate a compound page of two pages and only sets
PG_slab on the head page. So if a memory object is hosted by the second page,
we will get a wrong conclusion that the memory object wasn't allocated by slab.
	We encountered this issue when trying to implement physical memory hot-removal.
After removing a memory device, we need to tear down memory management structures
of the removed memory device. Those memory management structures may be allocated
by bootmem allocator at boot time, or allocated by slab allocator at runtime when
hot-adding memory device. So in our case, PageSlab() is used to distinguish between
bootmem allocator and slab allocator. With SLUB, some pages will never be released
due to the issue described above.
	Thanks!
	Gerry
