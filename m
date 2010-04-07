Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0DGA4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab0DGA40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:56:26 -0400
Date: Wed, 7 Apr 2010 02:55:47 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/14] Do not compact within a preferred zone after a
 compaction failure
Message-ID: <20100407005547.GD5706@random.random>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
 <1270224168-14775-14-git-send-email-mel@csn.ul.ie>
 <20100406170616.7d0f24b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406170616.7d0f24b1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 05:06:16PM -0700, Andrew Morton wrote:
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

Actually I skipped this one in the unified tree (I'm running both
patchsets at the same time as I write this and I should have tweaked
it so that the defrag sysfs control in transparent hugepage turns
memory compaction on and off, plus I embedded the
set_recommended_min_free_kbytes() code inside huge_memory.c
initialization). I merged the whole V7 except the above. It also
didn't pass my threshold, also because this only checks 1 jiffy that
is random and too short to matter.
