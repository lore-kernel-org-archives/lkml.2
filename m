Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2IFC5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:57:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63209 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2IFC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:57:38 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-20-5048112045cb
Date: Thu, 6 Sep 2012 11:59:12 +0900
From: Minchan Kim <minchan@kernel.org>
To: qiuxishi <qiuxishi@gmail.com>
Cc: mgorman@suse.de, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, qiuxishi@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memory-hotplug: bug fix race between isolation and
 allocation
Message-ID: <20120906025912.GE31615@bbox>
References: <50480BFB.8050501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50480BFB.8050501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xishi,

On Thu, Sep 06, 2012 at 10:35:39AM +0800, qiuxishi wrote:
> On 2012/9/5 17:40, Mel Gorman wrote:
> 
> > On Wed, Sep 05, 2012 at 04:26:02PM +0900, Minchan Kim wrote:
> >> Like below, memory-hotplug makes race between page-isolation
> >> and page-allocation so it can hit BUG_ON in __offline_isolated_pages.
> >>
> >> 	CPU A					CPU B
> >>
> >> start_isolate_page_range
> >> set_migratetype_isolate
> >> spin_lock_irqsave(zone->lock)
> >>
> >> 				free_hot_cold_page(Page A)
> >> 				/* without zone->lock */
> >> 				migratetype = get_pageblock_migratetype(Page A);
> >> 				/*
> >> 				 * Page could be moved into MIGRATE_MOVABLE
> >> 				 * of per_cpu_pages
> >> 				 */
> >> 				list_add_tail(&page->lru, &pcp->lists[migratetype]);
> >>
> >> set_pageblock_isolate
> >> move_freepages_block
> >> drain_all_pages
> 
> I think here is the problem you want to fix, it is not sure that pcp will be moved
> into MIGRATE_ISOLATE list. They may be moved into MIGRATE_MOVABLE list because
> page_private() maybe 2, it uses page_private() not get_pageblock_migratetype()
> 
> So when finish migrating pages, the free pages from pcp may be allocated again, and
> failed in check_pages_isolated().
> 
> drain_all_pages()
> 	drain_local_pages()
> 		drain_pages()
> 			free_pcppages_bulk()
> 				__free_one_page(page, zone, 0, page_private(page))
> 
> I reported this problem too. http://marc.info/?l=linux-mm&m=134555113706068&w=2
> How about this change:
> 	free_pcppages_bulk()
> 		__free_one_page(page, zone, 0, get_pageblock_migratetype(page))

I already explained why it was not good solution.
Again, here it goes from my previous reply.

"
Anyway, I don't like your approach which I already considered because it hurts hotpath
while the race is really unlikely. Get_pageblock_migratetype is never trivial.
We should avoid the overhead in hotpath and move into memory-hotplug itself.
Do you see my patch in https://patchwork.kernel.org/patch/1225081/ ?
"

-- 
Kind regards,
Minchan Kim
