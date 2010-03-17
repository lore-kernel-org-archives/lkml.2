Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0CQKcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:32:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36081 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0CQKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:32:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/11] Memory compaction core
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1268412087-13536-8-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-8-git-send-email-mel@csn.ul.ie>
Message-Id: <20100317170116.870A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 19:31:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nit

> +static int compact_zone(struct zone *zone, struct compact_control *cc)
> +{
> +	int ret = COMPACT_INCOMPLETE;
> +
> +	/* Setup to move all movable pages to the end of the zone */
> +	cc->migrate_pfn = zone->zone_start_pfn;
> +	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
> +	cc->free_pfn &= ~(pageblock_nr_pages-1);
> +
> +	for (; ret == COMPACT_INCOMPLETE; ret = compact_finished(zone, cc)) {
> +		unsigned long nr_migrate, nr_remaining;
> +		if (!isolate_migratepages(zone, cc))
> +			continue;
> +
> +		nr_migrate = cc->nr_migratepages;
> +		migrate_pages(&cc->migratepages, compaction_alloc,
> +						(unsigned long)cc, 0);
> +		update_nr_listpages(cc);
> +		nr_remaining = cc->nr_migratepages;
> +
> +		count_vm_event(COMPACTBLOCKS);

V1 did compaction per pageblock. but current patch doesn't.
so, Is COMPACTBLOCKS still good name?


> +		count_vm_events(COMPACTPAGES, nr_migrate - nr_remaining);
> +		if (nr_remaining)
> +			count_vm_events(COMPACTPAGEFAILED, nr_remaining);
> +
> +		/* Release LRU pages not migrated */
> +		if (!list_empty(&cc->migratepages)) {
> +			putback_lru_pages(&cc->migratepages);
> +			cc->nr_migratepages = 0;
> +		}
> +
> +		mod_zone_page_state(zone, NR_ISOLATED_ANON, -cc->nr_anon);
> +		mod_zone_page_state(zone, NR_ISOLATED_FILE, -cc->nr_file);

I think you don't need decrease this vmstatistics here. migrate_pages() and
putback_lru_pages() alredy does.


other parts, looks good.




