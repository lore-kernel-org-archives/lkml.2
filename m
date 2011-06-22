Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab1FVOME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:12:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:24208 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1FVOMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:12:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,406,1304319600"; 
   d="scan'208";a="16834568"
Date: Wed, 22 Jun 2011 22:11:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-ID: <20110622141156.GA4413@localhost>
References: <20110619150108.691351746@intel.com>
 <20110619150510.246140117@intel.com>
 <20110619153636.GC20424@infradead.org>
 <20110619155546.GA14338@localhost>
 <20110621165905.3c7180a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621165905.3c7180a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 07:59:05AM +0800, Andrew Morton wrote:
> On Sun, 19 Jun 2011 23:55:47 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Sun, Jun 19, 2011 at 11:36:37PM +0800, Christoph Hellwig wrote:
> > > On Sun, Jun 19, 2011 at 11:01:11PM +0800, Wu Fengguang wrote:
> > > > The start of a heavy weight application (ie. KVM) may instantly knock
> > > > down determine_dirtyable_memory() and hence the global/bdi dirty
> > > > thresholds.
> > > > 
> > > > So introduce global_dirty_limit for tracking the global dirty threshold
> > > > with policies
> > > > 
> > > > - follow downwards slowly
> > > > - follow up in one shot
> > > > 
> > > > global_dirty_limit can effectively mask out the impact of sudden drop of
> > > > dirtyable memory. It will be used in the next patch for two new type of
> > > > dirty limits.
> > > 
> > > This needs to be explained in more detail in comments near the actual
> > > code.
> > 
> > Good point! This is the added comment for the update_dirty_limit() function.
> > 
> > /*
> >  * The global dirtyable memory and dirty threshold could be suddenly knocked
> >  * down by a large amount (eg. on the startup of KVM). This may throw the
> >  * system into deep dirty exceeded state and throttled to "death" for a couple
> >  * of seconds. The solution is to maintain global_dirty_limit for tracking
> >  * slowly down to the knocked down dirty threshold.
> >  */
> > static void update_dirty_limit(unsigned long thresh,
> >                                unsigned long dirty)
> > 
> 
> Neither this nor the changelog explain things well. 

Yeah sorry.. it's vague and partially flawed as you discovered below.

> Looking at the code, KVM starts, allocates memory,
> global_page_state(NR_FREE_PAGES) decreases by N and
> global_reclaimable_pages() increases by N.  Nothing changed.

...if you enabled swap. As my test boxes typically don't have swap
enabled, I literally see the sudden drop of dirty threshold...

> So what's going on here?

Here is the patch with more changelogs and comments. Hope they are
more clear this time.

Thanks,
Fengguang
---
Subject: writeback: introduce smoothed global dirty limit
Date: Wed Mar 02 15:54:09 CST 2011

The start of a heavy weight application (ie. KVM) may instantly knock
down determine_dirtyable_memory() if the swap is not enabled or full.
global_dirty_limits() and bdi_dirty_limit() will in turn get global/bdi
dirty thresholds that are _much_ lower than the global/bdi dirty pages.

balance_dirty_pages() will then heavily throttle all dirtiers including
the light ones, until the dirty pages drop below the new dirty thresholds.
During this _deep_ dirty-exceeded state, the system may appear rather
unresponsive to the users.

About "deep" dirty-exceeded: task_dirty_limit() assigns 1/8 lower dirty
threshold to heavy dirtiers than light ones, and the dirty pages will
be throttled around the heavy dirtiers' dirty threshold and reasonably
below the light dirtiers' dirty threshold. In this state, only the heavy
dirtiers will be throttled and the dirty pages are carefully controlled
to not exceed the light dirtiers' dirty threshold. However if the
threshold itself suddenly drops below the number of dirty pages, the
light dirtiers will get heavily throttled.

So introduce global_dirty_limit for tracking the global dirty threshold
with policies

- follow downwards slowly
- follow up in one shot

global_dirty_limit can effectively mask out the impact of sudden drop of
dirtyable memory. It will be used in the next patch for two new type of
dirty limits. Note that the new dirty limits are not going to avoid
throttling the light dirtiers, but could limit their sleep time to 200ms.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    2 -
 include/linux/writeback.h |    5 ++
 mm/page-writeback.c       |   72 +++++++++++++++++++++++++++++++++++-
 3 files changed, 76 insertions(+), 3 deletions(-)

--- linux-next.orig/include/linux/writeback.h	2011-06-20 00:23:59.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-22 20:43:13.000000000 +0800
@@ -84,6 +84,8 @@ static inline void laptop_sync_completio
 #endif
 void throttle_vm_writeout(gfp_t gfp_mask);
 
+extern unsigned long global_dirty_limit;
+
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
 extern unsigned long dirty_background_bytes;
@@ -119,6 +121,9 @@ unsigned long bdi_dirty_limit(struct bac
 			       unsigned long dirty);
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long thresh,
+			    unsigned long dirty,
+			    unsigned long bdi_dirty,
 			    unsigned long start_time);
 
 void page_writeback_init(void);
--- linux-next.orig/mm/page-writeback.c	2011-06-20 00:23:59.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-22 22:06:29.000000000 +0800
@@ -116,6 +116,7 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+unsigned long global_dirty_limit;
 
 /*
  * Scale the writeback cache size proportional to the relative writeout speeds.
@@ -510,7 +511,66 @@ static void bdi_update_write_bandwidth(s
 	bdi->avg_write_bandwidth = avg;
 }
 
+/*
+ * The global dirtyable memory and dirty threshold could be suddenly knocked
+ * down by a large amount (eg. on the startup of KVM in a swapless system).
+ * This may throw the system into deep dirty exceeded state and throttle
+ * heavy/light dirtiers alike. To retain good responsiveness, maintain
+ * global_dirty_limit for tracking slowly down to the knocked down dirty
+ * threshold.
+ */
+static void update_dirty_limit(unsigned long thresh, unsigned long dirty)
+{
+	unsigned long limit = global_dirty_limit;
+
+	/*
+	 * Follow up in one step.
+	 */
+	if (limit < thresh) {
+		limit = thresh;
+		goto update;
+	}
+
+	/*
+	 * Follow down slowly. Use the higher one as the target, because thresh
+	 * may drop below dirty. This is exactly the reason to introduce
+	 * global_dirty_limit which is guaranteed to lie above the dirty pages.
+	 */
+	thresh = max(thresh, dirty);
+	if (limit > thresh) {
+		limit -= (limit - thresh) >> 5;
+		goto update;
+	}
+	return;
+update:
+	global_dirty_limit = limit;
+}
+
+static void global_update_bandwidth(unsigned long thresh,
+				    unsigned long dirty,
+				    unsigned long now)
+{
+	static DEFINE_SPINLOCK(dirty_lock);
+	static unsigned long update_time;
+
+	/*
+	 * Do a lockless check first to optimize away locking for most time.
+	 */
+	if (now - update_time < MAX_PAUSE)
+		return;
+
+	spin_lock(&dirty_lock);
+	if (now - update_time >= MAX_PAUSE) {
+		update_dirty_limit(thresh, dirty);
+		update_time = now;
+	}
+	spin_unlock(&dirty_lock);
+}
+
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
+			    unsigned long thresh,
+			    unsigned long dirty,
+			    unsigned long bdi_dirty,
 			    unsigned long start_time)
 {
 	unsigned long now = jiffies;
@@ -532,6 +592,9 @@ void __bdi_update_bandwidth(struct backi
 	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
 		goto snapshot;
 
+	if (thresh)
+		global_update_bandwidth(thresh, dirty, now);
+
 	bdi_update_write_bandwidth(bdi, elapsed, written);
 
 snapshot:
@@ -540,12 +603,16 @@ snapshot:
 }
 
 static void bdi_update_bandwidth(struct backing_dev_info *bdi,
+				 unsigned long thresh,
+				 unsigned long dirty,
+				 unsigned long bdi_dirty,
 				 unsigned long start_time)
 {
 	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)
 		return;
 	if (spin_trylock(&bdi->wb.list_lock)) {
-		__bdi_update_bandwidth(bdi, start_time);
+		__bdi_update_bandwidth(bdi, thresh, dirty, bdi_dirty,
+				       start_time);
 		spin_unlock(&bdi->wb.list_lock);
 	}
 }
@@ -625,7 +692,8 @@ static void balance_dirty_pages(struct a
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
-		bdi_update_bandwidth(bdi, start_time);
+		bdi_update_bandwidth(bdi, dirty_thresh, nr_dirty, bdi_dirty,
+				     start_time);
 
 		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
 		 * Unstable writes are a feature of certain networked
--- linux-next.orig/fs/fs-writeback.c	2011-06-20 00:23:59.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-06-22 20:43:12.000000000 +0800
@@ -699,7 +699,7 @@ static inline bool over_bground_thresh(v
 static void wb_update_bandwidth(struct bdi_writeback *wb,
 				unsigned long start_time)
 {
-	__bdi_update_bandwidth(wb->bdi, start_time);
+	__bdi_update_bandwidth(wb->bdi, 0, 0, 0, start_time);
 }
 
 /*
