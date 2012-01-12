Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2ALKF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:05:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2ALKFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:05:23 -0500
Date: Thu, 12 Jan 2012 11:05:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] mm: __count_immobile_pages make sure the node is online
Message-ID: <20120112100521.GD1042@tiehlicka.suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
 <alpine.DEB.2.00.1201101326080.10821@chino.kir.corp.google.com>
 <20120111084802.GA16466@tiehlicka.suse.cz>
 <20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112082722.GB1042@tiehlicka.suse.cz>
 <20120112173536.db529713.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112092314.GC1042@tiehlicka.suse.cz>
 <20120112183323.1bb62f4d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112183323.1bb62f4d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-01-12 18:33:23, KAMEZAWA Hiroyuki wrote:
[...]
> > From 04f74e6f0ebf28f61650d63f8884e8855fb21b55 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Thu, 12 Jan 2012 10:19:04 +0100
> > Subject: [PATCH] mm: __count_immobile_pages make sure the node is online
> > 
> > page_zone requires to have an online node otherwise we are accessing
> > NULL NODE_DATA. This is not an issue at the moment because node_zones
> > are located at the structure beginning but this might change in the
> > future so better be careful about that.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/page_alloc.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 485be89..c6fb8ea 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5607,14 +5607,21 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
> >  
> >  bool is_pageblock_removable_nolock(struct page *page)
> >  {
> > -	struct zone *zone = page_zone(page);
> > -	unsigned long pfn = page_to_pfn(page);
> > +	struct zone *zone;
> > +	unsigned long pfn;
> >  
> >  	/*
> >  	 * We have to be careful here because we are iterating over memory
> >  	 * sections which are not zone aware so we might end up outside of
> >  	 * the zone but still within the section.
> > +	 * We have to take care about the node as well. If the node is offline
> > +	 * its NODE_DATA will be NULL - see page_zone.
> >  	 */
> > +	if (!node_online(page_to_nid(page)))
> > +		return false;
> > +
> > +	zone = page_zone(page);
> > +	pfn = page_to_pfn(page);
> >  	if (!zone || zone->zone_start_pfn > pfn ||
> >  			zone->zone_start_pfn + zone->spanned_pages <= pfn)
> >  		return false;
> 
> !zone check can be removed because of node_online() check.

Yes you are right. Fixed bellow:
---
>From 39de8df13532150fc4518dad0cb3f6fd88745b8a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 12 Jan 2012 10:19:04 +0100
Subject: [PATCH] mm: __count_immobile_pages make sure the node is online

page_zone requires to have an online node otherwise we are accessing
NULL NODE_DATA. This is not an issue at the moment because node_zones
are located at the structure beginning but this might change in the
future so better be careful about that.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_alloc.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 485be89..b09e8c2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5607,15 +5607,22 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
 
 bool is_pageblock_removable_nolock(struct page *page)
 {
-	struct zone *zone = page_zone(page);
-	unsigned long pfn = page_to_pfn(page);
+	struct zone *zone;
+	unsigned long pfn;
 
 	/*
 	 * We have to be careful here because we are iterating over memory
 	 * sections which are not zone aware so we might end up outside of
 	 * the zone but still within the section.
+	 * We have to take care about the node as well. If the node is offline
+	 * its NODE_DATA will be NULL - see page_zone.
 	 */
-	if (!zone || zone->zone_start_pfn > pfn ||
+	if (!node_online(page_to_nid(page)))
+		return false;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	if (zone->zone_start_pfn > pfn ||
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
-- 
1.7.7.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
