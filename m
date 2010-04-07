Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0DGQcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:32:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53255 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0DGQch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:32:37 -0400
Date: Wed, 7 Apr 2010 17:32:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/14] Do not compact within a preferred zone after a
	compaction failure
Message-ID: <20100407163217.GV17882@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie> <1270224168-14775-14-git-send-email-mel@csn.ul.ie> <20100406170616.7d0f24b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100406170616.7d0f24b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 05:06:16PM -0700, Andrew Morton wrote:
> On Fri,  2 Apr 2010 17:02:47 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The fragmentation index may indicate that a failure is due to external
> > fragmentation but after a compaction run completes, it is still possible
> > for an allocation to fail. There are two obvious reasons as to why
> > 
> >   o Page migration cannot move all pages so fragmentation remains
> >   o A suitable page may exist but watermarks are not met
> > 
> > In the event of compaction followed by an allocation failure, this patch
> > defers further compaction in the zone for a period of time. The zone that
> > is deferred is the first zone in the zonelist - i.e. the preferred zone.
> > To defer compaction in the other zones, the information would need to be
> > stored in the zonelist or implemented similar to the zonelist_cache.
> > This would impact the fast-paths and is not justified at this time.
> > 
> 
> Your patch, it sucks!
> 
> > ---
> >  include/linux/compaction.h |   35 +++++++++++++++++++++++++++++++++++
> >  include/linux/mmzone.h     |    7 +++++++
> >  mm/page_alloc.c            |    5 ++++-
> >  3 files changed, 46 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> > index ae98afc..2a02719 100644
> > --- a/include/linux/compaction.h
> > +++ b/include/linux/compaction.h
> > @@ -18,6 +18,32 @@ extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
> >  extern int fragmentation_index(struct zone *zone, unsigned int order);
> >  extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
> >  			int order, gfp_t gfp_mask, nodemask_t *mask);
> > +
> > +/* defer_compaction - Do not compact within a zone until a given time */
> > +static inline void defer_compaction(struct zone *zone, unsigned long resume)
> > +{
> > +	/*
> > +	 * This function is called when compaction fails to result in a page
> > +	 * allocation success. This is somewhat unsatisfactory as the failure
> > +	 * to compact has nothing to do with time and everything to do with
> > +	 * the requested order, the number of free pages and watermarks. How
> > +	 * to wait on that is more unclear, but the answer would apply to
> > +	 * other areas where the VM waits based on time.
> > +	 */
> 
> c'mon, let's not make this rod for our backs.
> 
> The "A suitable page may exist but watermarks are not met" case can be
> addressed by testing the watermarks up-front, surely?
> 

Nope, because the number of pages free at each order changes before and
after compaction and you don't know by how much in advance. It wouldn't
be appropriate to assume perfect compaction because unmovable and
reclaimable pages are free.

> I bet the "Page migration cannot move all pages so fragmentation
> remains" case can be addressed by setting some metric in the zone, and
> suitably modifying that as a result on ongoing activity. 
> To tell the
> zone "hey, compaction migth be worth trying now".  that sucks too, but not
> so much.
> 
> Or something.  Putting a wallclock-based throttle on it like this
> really does reduce the usefulness of the whole feature.
> 

When it gets down to it, this patch was about paranoia. If the
heuristics on compaction-avoidance didn't work out, I didn't want
compaction to keep pounding.

That said, this patch would also hide the bug report telling us this happened
and was a mistake. A bug report detailing high oprofile usage in compaction
will be much easier to come across than a report on defer_compaction()
being called too often.

Please drop this patch.

> Internet: "My application works OK on a hard disk but fails when I use an SSD!". 
> 
> akpm: "Tell Mel!"
> 

Mel is in and he is listening.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
