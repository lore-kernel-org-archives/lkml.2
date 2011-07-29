Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1G2Kag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:30:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:57890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab1G2Kaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="33717707"
Date: Fri, 29 Jul 2011 18:30:33 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, "mgorman@suse.de" <mgorman@suse.de>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: add block plug for page reclaim
Message-ID: <20110729103033.GA7120@sli10-conroe.sh.intel.com>
References: <1311130413.15392.326.camel@sli10-conroe>
 <CAEwNFnDj30Bipuxrfe9upD-OyuL4v21tLs0ayUKYUfye5TcGyA@mail.gmail.com>
 <1311142253.15392.361.camel@sli10-conroe>
 <CAEwNFnD3iCMBpZK95Ks+Z7DYbrzbZbSTLf3t6WXDQdeHrE6bLQ@mail.gmail.com>
 <1311144559.15392.366.camel@sli10-conroe>
 <4E287EC0.4030208@fusionio.com>
 <1311311695.15392.369.camel@sli10-conroe>
 <4E2B17A6.6080602@fusionio.com>
 <20110727164523.c2b1d569.akpm@linux-foundation.org>
 <20110729083847.GB1843@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729083847.GB1843@barrios-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:38:47PM +0800, Minchan Kim wrote:
> On Wed, Jul 27, 2011 at 04:45:23PM -0700, Andrew Morton wrote:
> > On Sat, 23 Jul 2011 20:49:10 +0200
> > Jens Axboe <jaxboe@fusionio.com> wrote:
> > 
> > > > I can observe the average request size changes. Before the patch, the
> > > > average request size is about 90k from iostat (but the variation is
> > > > big). With the patch, the request size is about 100k and variation is
> > > > small.
> > > 
> > > That's a good win right there, imho.
> > 
> > yup.  Reduced CPU consumption on that path isn't terribly exciting IMO,
> > but improved request size is significant.
> 
> Fair enough.
> He didn't write down it in the description.
> At least, The description should include request size and variation instead of
> CPU consumption thing.
> 
> Shaohua, Please rewrite the description although it's annoying.
that's fine. I add more description here.



per-task block plug can reduce block queue lock contention and increase request
merge. Currently page reclaim doesn't support it. I originally thought page
reclaim doesn't need it, because kswapd thread count is limited and file cache
write is done at flusher mostly.
When I test a workload with heavy swap in a 4-node machine, each CPU is doing
direct page reclaim and swap. This causes block queue lock contention. In my
test, without below patch, the CPU utilization is about 2% ~ 7%. With the
patch, the CPU utilization is about 1% ~ 3%. Disk throughput isn't changed.
>From iostat, the average request size is increased too. Before the patch,
the average request size is about 90k and the variation is big. With the patch,
the size is about 100k and the variation is small.
This should improve normal kswapd write and file cache write too (increase
request merge for example), but might not be so obvious as I explain above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed24b9..8ec04b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1933,12 +1933,14 @@ static void shrink_zone(int priority, struct zone *zone,
 	enum lru_list l;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	struct blk_plug plug;
 
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(zone, sc, nr, priority);
 
+	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -1962,6 +1964,7 @@ restart:
 		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
+	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
 
 	/*
