Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1EaNvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:51:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40680 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1EaNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eNuv+w8+P7cULyUFYssGEDHWuofce2Z5kSqYFLGoCqBMPgr7t/3LZNT7aM//iL7PI+
         P3+zDKygqQMZ6xlSkNlzEzIwClPDtVDHH3xd1+6udVtOUr4ploVHT+6hwNEMwwEzshBW
         fW8oAwiNlYi86xRxhBGNasHTwvXTfgVpymoVE=
Date: Tue, 31 May 2011 22:51:29 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 06/10] vmscan: make isolate_lru_page with filter
 aware
Message-ID: <20110531135129.GA13418@barrios-laptop>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <48bcb7597cd5695f30381715630dc66a5d32c638.1306689214.git.minchan.kim@gmail.com>
 <20110531134609.GB4594@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531134609.GB4594@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:46:09PM +0200, Johannes Weiner wrote:
> On Mon, May 30, 2011 at 03:13:45AM +0900, Minchan Kim wrote:
> > In __zone_reclaim case, we don't want to shrink mapped page.
> > Nonetheless, we have isolated mapped page and re-add it into
> > LRU's head. It's unnecessary CPU overhead and makes LRU churning.
> > 
> > Of course, when we isolate the page, the page might be mapped but
> > when we try to migrate the page, the page would be not mapped.
> > So it could be migrated. But race is rare and although it happens,
> > it's no big deal.
> > 
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/vmscan.c |   29 +++++++++++++++++++++--------
> >  1 files changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9972356..39941c7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1395,6 +1395,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
> >  	unsigned long nr_taken;
> >  	unsigned long nr_anon;
> >  	unsigned long nr_file;
> > +	enum ISOLATE_PAGE_MODE mode = ISOLATE_NONE;
> >  
> >  	while (unlikely(too_many_isolated(zone, file, sc))) {
> >  		congestion_wait(BLK_RW_ASYNC, HZ/10);
> > @@ -1406,13 +1407,20 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
> >  
> >  	set_reclaim_mode(priority, sc, false);
> >  	lru_add_drain();
> > +
> > +	if (!sc->may_unmap)
> > +		mode |= ISOLATE_UNMAPPED;
> > +	if (!sc->may_writepage)
> > +		mode |= ISOLATE_CLEAN;
> > +	mode |= sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
> > +				ISOLATE_BOTH : ISOLATE_INACTIVE;
> 
> Hmm, it would probably be cleaner to fully convert the isolation mode
> into independent flags.  INACTIVE, ACTIVE, BOTH is currently a
> tri-state among flags, which is a bit ugly.
> 
> 	mode = ISOLATE_INACTIVE;
> 	if (!sc->may_unmap)
> 		mode |= ISOLATE_UNMAPPED;
> 	if (!sc->may_writepage)
> 		mode |= ISOLATE_CLEAN;
> 	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
> 		mode |= ISOLATE_ACTIVE;
> 
> What do you think?

It's good point.
Actually, I am trying it for unevictable page migration.
I removed BOTH and insert ISOLATE_UNEVICTABLE.
But it's in my queue and doesn't published yet.
The summary is that I am going on that way.
I will clean up it in v3, too. 

==
Subject: [PATCH 1/2] Cleanup ISOLATE_BOTH

Before 2.6.38, we just had two lru list(active/inactive).
Now we have added one more lru type list. ie, unevictable.
So ISOLATE_BOTH is not clear naming.
This patch removes ISOLATE_BOTH and instead of it,
it require to use more explicit word.

This patch should not change old behavir and it's used by
next patch series.
==

-- 
Kind regards
Minchan Kim
