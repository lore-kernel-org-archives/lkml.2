Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2HVINw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:13:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49896 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2HVINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:13:48 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-a8-503494b95959
Date: Wed, 22 Aug 2012 17:14:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: qiuxishi <qiuxishi@gmail.com>
Cc: akpm@linux-foundation.org, lliubbo@gmail.com, jiang.liu@huawei.com,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, qiuxishi@huawei.com,
        wujianguo@huawei.com, bessel.wang@huawei.com, guohanjun@huawei.com,
        chenkeping@huawei.com, yinghai@kernel.org, wency@cn.fujitsu.com
Subject: Re: [PATCH] memory-hotplug: fix a drain pcp bug when offline pages
Message-ID: <20120822081410.GA5369@bbox>
References: <50337B15.2090701@gmail.com>
 <20120822033441.GB24667@bbox>
 <503490F9.2050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503490F9.2050805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:57:45PM +0800, qiuxishi wrote:
> On 2012-8-22 11:34, Minchan Kim wrote:
> > Hello Xishi,
> > 
> > On Tue, Aug 21, 2012 at 08:12:05PM +0800, qiuxishi wrote:
> >> From: Xishi Qiu <qiuxishi@huawei.com>
> >>
> >> When offline a section, we move all the free pages and pcp into MIGRATE_ISOLATE list first.
> >> start_isolate_page_range()
> >> 	set_migratetype_isolate()
> >> 		drain_all_pages(),
> >>
> >> Here is a problem, it is not sure that pcp will be moved into MIGRATE_ISOLATE list. They may
> >> be moved into MIGRATE_MOVABLE list because page_private() maybe 2. So when finish migrating
> >> pages, the free pages from pcp may be allocated again, and faild in check_pages_isolated().
> >> drain_all_pages()
> >> 	drain_local_pages()
> >> 		drain_pages()
> >> 			free_pcppages_bulk()
> >> 				__free_one_page(page, zone, 0, page_private(page));
> >>
> >> If we add move_freepages_block() after drain_all_pages(), it can not sure that all the pcp
> >> will be moved into MIGRATE_ISOLATE list when the system works on high load. The free pages
> >> which from pcp may immediately be allocated again.
> >>
> >> I think the similar bug described in http://marc.info/?t=134250882300003&r=1&w=2
> > 
> > Yes. I reported the problem a few month ago but it's not real bug in practice
> > but found by my eyes during looking the code so I wanted to confirm the problem.
> > 
> > Do you find that problem in real practice? or just code review?
> > 
> 
> I use /sys/devices/system/memory/soft_offline_page to offline a lot of pages when the
> system works on high load, then I find some unknown zero refcount pages, such as
> get_any_page: 0x650422: unknown zero refcount page type 19400c00000000
> get_any_page: 0x650867: unknown zero refcount page type 19400c00000000
> 
> soft_offline_page()
> 	get_any_page()
> 		set_migratetype_isolate()
> 			drain_all_pages()
> 
> I think after drain_all_pages(), pcp are moved into MIGRATE_MOVABLE list which managed by
> buddy allocator, but they are allocated and becaome pcp again as the system works on high
> load. There will be no this problem by applying this patch.
> 
> > Anyway, I don't like your approach which I already considered because it hurts hotpath
> > while the race is really unlikely. Get_pageblock_migratetype is never trivial.
> > We should avoid the overhead in hotpath and move into memory-hotplug itself.
> > Do you see my patch in https://patchwork.kernel.org/patch/1225081/ ?
> 
> Yes, you are right, I will try to find another way to fix this problem.
> How about doing this work in set_migratetype_isolate(), find the pcp and change the value
> of private to get_pageblock_migratetype(page)?
> 

Allocator doesn't have any lock when he allocates the page from pcp.
How could you prevent race between allocator and memory-hotplug
routine(ie, set_migratetype_isolate) without hurting hotpath?

-- 
Kind regards,
Minchan Kim
