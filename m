Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0H0Eed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:34:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:58629 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0H0Eea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,277,1280732400"; 
   d="scan'208";a="600894411"
Date: Fri, 27 Aug 2010 12:34:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [RFC PATCH 0/3] Do not wait the full timeout on
 congestion_wait when there is no congestion
Message-ID: <20100827043426.GA6659@localhost>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <20100826172038.GA6873@barrios-desktop>
 <20100827012147.GC7353@localhost>
 <AANLkTimLhZcP=eqB9TFfO_rgb-dhXUJh8iNTXuceuCq0@mail.gmail.com>
 <20100827015041.GF7353@localhost>
 <AANLkTin0PZu=ceoeyYa6qSv_piHL1yrfyEgTw35=gnex@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin0PZu=ceoeyYa6qSv_piHL1yrfyEgTw35=gnex@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:02:52AM +0800, Minchan Kim wrote:
> On Fri, Aug 27, 2010 at 10:50 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Fri, Aug 27, 2010 at 09:41:48AM +0800, Minchan Kim wrote:
> >> Hi, Wu.
> >>
> >> On Fri, Aug 27, 2010 at 10:21 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> >> > Minchan,
> >> >
> >> > It's much cleaner to keep the unchanged congestion_wait() and add a
> >> > congestion_wait_check() for converting problematic wait sites. The
> >> > too_many_isolated() wait is merely a protective mechanism, I won't
> >> > bother to improve it at the cost of more code.
> >>
> >> You means following as?
> >
> > No, I mean do not change the too_many_isolated() related code at all :)
> > And to use congestion_wait_check() in other places that we can prove
> > there is a problem that can be rightly fixed by changing to
> > congestion_wait_check().
> 
> I always suffer from understanding your comment.
> Apparently, my eyes have a problem. ;(

> This patch is dependent of Mel's series.
> With changing congestion_wait with just return when no congestion, it
> would have CPU hogging in too_many_isolated. I think it would apply in
> Li's congestion_wait_check, too.
> If no change is current congestion_wait, we doesn't need this patch.
> 
> Still, maybe I can't understand your comment. Sorry.

Sorry! The confusion must come from the modified congestion_wait() by
Mel. My proposal is to _not_ modify congestion_wait(), but add another
congestion_wait_check() which won't sleep 100ms when no IO. In this
way, the following chunks become unnecessary.

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -253,7 +253,11 @@ static unsigned long isolate_migratepages(struct zone *zone,
         * delay for some time until fewer pages are isolated
         */
        while (unlikely(too_many_isolated(zone))) {
-               congestion_wait(BLK_RW_ASYNC, HZ/10);
+               long timeout = HZ/10;
+               if (timeout == congestion_wait(BLK_RW_ASYNC, timeout)) {
+                       set_current_state(TASK_INTERRUPTIBLE);
+                       schedule_timeout(timeout);
+               }
               
                if (fatal_signal_pending(current))
                        return 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3109ff7..f5e3e28 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1337,7 +1337,11 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
        unsigned long nr_dirty;
        while (unlikely(too_many_isolated(zone, file, sc))) {
-               congestion_wait(BLK_RW_ASYNC, HZ/10);
+               long timeout = HZ/10;
+               if (timeout == congestion_wait(BLK_RW_ASYNC, timeout)) {
+                       set_current_state(TASK_INTERRUPTIBLE);
+                       schedule_timeout(timeout);
+               }
               
                /* We are about to die and free our memory. Return now. */
                if (fatal_signal_pending(current))

Thanks,
Fengguang
