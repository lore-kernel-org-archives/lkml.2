Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0HZRUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:20:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42145 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0HZRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fJRGKc67GVfqQRvYfxka9f+h8A9O8T0Il/il9OfBj3Pv9rn3QD6mIVLVlkBAcYfR84
         D20/dRZI9rGoxCc5Jdt4T7awLadgLOqaiGub345L7gm7Qc6SHIzMBIsUV7nce+rqHItL
         zoKb3OCMAMRjzVaARt3v7XLPNCkpLiDGTVVpI=
Date: Fri, 27 Aug 2010 02:20:38 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/3] Do not wait the full timeout on
 congestion_wait when there is no congestion
Message-ID: <20100826172038.GA6873@barrios-desktop>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:13PM +0100, Mel Gorman wrote:
> congestion_wait() is a bit stupid in that it goes to sleep even when there
> is no congestion. This causes stalls in a number of situations and may be
> partially responsible for bug reports about desktop interactivity.
> 
> This patch series aims to account for these unnecessary congestion_waits()
> and to avoid going to sleep when there is no congestion available. Patches
> 1 and 2 add instrumentation related to congestion which should be reuable
> by alternative solutions to congestion_wait. Patch 3 calls cond_resched()
> instead of going to sleep if there is no congestion.
> 
> Once again, I shoved this through performance test. Unlike previous tests,
> I ran this on a ported version of my usual test-suite that should be suitable
> for release soon. It's not quite as good as my old set but it's sufficient
> for this and related series. The tests I ran were kernbench vmr-stream
> iozone hackbench-sockets hackbench-pipes netperf-udp netperf-tcp sysbench
> stress-highalloc. Sysbench was a read/write tests and stress-highalloc is
> the usual stress the number of high order allocations that can be made while
> the system is under severe stress. The suite contains the necessary analysis
> scripts as well and I'd release it now except the documentation blows.
> 
> x86:    Intel Pentium D 3GHz with 3G RAM (no-brand machine)
> x86-64:	AMD Phenom 9950 1.3GHz with 3G RAM (no-brand machine)
> ppc64:	PPC970MP 2.5GHz with 3GB RAM (it's a terrasoft powerstation)
> 
> The disks on all of them were single disks and not particularly fast.
> 
> Comparison was between a 2.6.36-rc1 with patches 1 and 2 applied for
> instrumentation and a second test with patch 3 applied.
> 
> In all cases, kernbench, hackbench, STREAM and iozone did not show any
> performance difference because none of them were pressuring the system
> enough to be calling congestion_wait() so I won't post the results.
> About all worth noting for them is that nothing horrible appeared to break.
> 
> In the analysis scripts, I record unnecessary sleeps to be a sleep that
> had no congestion. The post-processing scripts for cond_resched() will only
> count an uncongested call to congestion_wait() as unnecessary if the process
> actually gets scheduled. Ordinarily, we'd expect it to continue uninterrupted.
> 
> One vague concern I have is when too many pages are isolated, we call
> congestion_wait(). This could now actively spin in the loop for its quanta
> before calling cond_resched(). If it's calling with no congestion, it's
> hard to know what the proper thing to do there is.

Suddenly, many processes could enter into the direct reclaim path by another
reason(ex, fork bomb) regradless of congestion. backing dev congestion is 
just one of them. 

I think if congestion_wait returns without calling io_schedule_timeout 
by your patch, too_many_isolated can schedule_timeout to wait for the system's 
calm to preventing OOM killing.

How about this?

If you don't mind, I will send the patch based on this patch series 
after your patch settle down or Could you add this to your patch series?
But I admit this doesn't almost affect your experiment. 

>From 70d6584e125c3954d74a69bfcb72de17244635d2 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Fri, 27 Aug 2010 02:06:45 +0900
Subject: [PATCH] Wait regardless of congestion if too many pages are isolated

Suddenly, many processes could enter into the direct reclaim path
regradless of congestion. backing dev congestion is just one of them.
But current implementation calls congestion_wait if too many pages are isolated.

if congestion_wait returns without calling io_schedule_timeout,
too_many_isolated can schedule_timeout to wait for the system's calm
to preventing OOM killing.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/backing-dev.c |    5 ++---
 mm/compaction.c  |    6 +++++-
 mm/vmscan.c      |    6 +++++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6abe860..9431bca 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -756,8 +756,7 @@ EXPORT_SYMBOL(set_bdi_congested);
  * @timeout: timeout in jiffies
  *
  * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
- * write congestion.  If no backing_devs are congested then just wait for the
- * next write to be completed.
+ * write congestion.  If no backing_devs are congested then just returns.
  */  
 long congestion_wait(int sync, long timeout)
 {
@@ -776,7 +775,7 @@ long congestion_wait(int sync, long timeout)
        if (atomic_read(&nr_bdi_congested[sync]) == 0) {
                unnecessary = true;
                cond_resched();
-               ret = 0;
+               ret = timeout;
        } else {
                prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
                ret = io_schedule_timeout(timeout);
diff --git a/mm/compaction.c b/mm/compaction.c
index 94cce51..7370683 100644
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
-- 
1.7.0.5


-- 
Kind regards,
Minchan Kim
