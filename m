Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab0CRCfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 22:35:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43042 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0CRCfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 22:35:53 -0400
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
In-Reply-To: <20100317114045.GE12388@csn.ul.ie>
References: <20100317170116.870A.A69D9226@jp.fujitsu.com> <20100317114045.GE12388@csn.ul.ie>
Message-Id: <20100318085741.8729.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 18 Mar 2010 11:35:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 17, 2010 at 07:31:53PM +0900, KOSAKI Motohiro wrote:
> > nit
> > 
> > > +static int compact_zone(struct zone *zone, struct compact_control *cc)
> > > +{
> > > +	int ret = COMPACT_INCOMPLETE;
> > > +
> > > +	/* Setup to move all movable pages to the end of the zone */
> > > +	cc->migrate_pfn = zone->zone_start_pfn;
> > > +	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
> > > +	cc->free_pfn &= ~(pageblock_nr_pages-1);
> > > +
> > > +	for (; ret == COMPACT_INCOMPLETE; ret = compact_finished(zone, cc)) {
> > > +		unsigned long nr_migrate, nr_remaining;
> > > +		if (!isolate_migratepages(zone, cc))
> > > +			continue;
> > > +
> > > +		nr_migrate = cc->nr_migratepages;
> > > +		migrate_pages(&cc->migratepages, compaction_alloc,
> > > +						(unsigned long)cc, 0);
> > > +		update_nr_listpages(cc);
> > > +		nr_remaining = cc->nr_migratepages;
> > > +
> > > +		count_vm_event(COMPACTBLOCKS);
> > 
> > V1 did compaction per pageblock. but current patch doesn't.
> > so, Is COMPACTBLOCKS still good name?
> 
> It's not such a minor nit. I wondered about that myself but it's still a
> block - just not a pageblock. Would COMPACTCLUSTER be a better name as it's
> related to COMPACT_CLUSTER_MAX?

I've looked at this code again. honestly I'm a abit confusing even though both your
suggestions seems reasonable.  

now COMPACTBLOCKS is tracking #-of-called-migrate_pages. but I can't imazine
how to use it. can you please explain this ststics purpose? probably this is only useful
when conbination other stats, and the name should be consist with such combination one.


> > > +		count_vm_events(COMPACTPAGES, nr_migrate - nr_remaining);
> > > +		if (nr_remaining)
> > > +			count_vm_events(COMPACTPAGEFAILED, nr_remaining);
> > > +
> > > +		/* Release LRU pages not migrated */
> > > +		if (!list_empty(&cc->migratepages)) {
> > > +			putback_lru_pages(&cc->migratepages);
> > > +			cc->nr_migratepages = 0;
> > > +		}
> > > +
> > > +		mod_zone_page_state(zone, NR_ISOLATED_ANON, -cc->nr_anon);
> > > +		mod_zone_page_state(zone, NR_ISOLATED_FILE, -cc->nr_file);
> > 
> > I think you don't need decrease this vmstatistics here. migrate_pages() and
> > putback_lru_pages() alredy does.
> > 
> 
> Hmm, I do need to decrease the vmstats here but not by this much. The
> pages migrated need to be accounted for but not the ones that failed. I
> missed this because migration was always succeeding. Thanks. I'll get it
> fixed for V5

thanks.


