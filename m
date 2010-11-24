Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab0KXOGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:06:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:9320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0KXOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:06:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,248,1288594800"; 
   d="scan'208";a="860968176"
Date: Wed, 24 Nov 2010 22:06:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
Message-ID: <20101124140610.GB8333@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042850.002299964@intel.com>
 <1290596302.2072.445.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290596302.2072.445.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 06:58:22PM +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> 
> > @@ -555,8 +592,10 @@ static void balance_dirty_pages(struct a
> >  		pause = clamp_val(pause, 1, HZ/10);
> >  
> >  pause:
> > +		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
> >  		__set_current_state(TASK_INTERRUPTIBLE);
> >  		io_schedule_timeout(pause);
> > +		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
> >  
> >  		/*
> >  		 * The bdi thresh is somehow "soft" limit derived from the
> 
> So its really a two part bandwidth calculation, the first call is:
> 
>   bdi_get_bandwidth()
> 
> and the second call is:
> 
>   bdi_update_bandwidth()
> 
> Would it make sense to actually implement it with two functions instead
> of overloading the functionality of the one function?

Thanks, it's good suggestion indeed. However after looking around, I
find it hard to split it up cleanly.. To make it clear, how about this
comment update?

Thanks,
Fengguang
---

--- linux-next.orig/mm/page-writeback.c	2010-11-24 19:05:01.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-11-24 22:01:43.000000000 +0800
@@ -554,6 +554,14 @@ out:
 	return a;
 }
 
+/*
+ * This can be repeatedly called inside a long run loop, eg. by wb_writeback().
+ *
+ * On first invocation it will find *bw_written=0 and take the initial snapshot.
+ * On follow up calls it will update the bandwidth if
+ * - at least 10ms data have been collected
+ * - the bandwidth for the time range has not been updated in parallel by others
+ */
 void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
 				unsigned long *bw_time,
 				s64 *bw_written)
@@ -575,9 +583,12 @@ void bdi_update_write_bandwidth(struct b
 	 * When there lots of tasks throttled in balance_dirty_pages(), they
 	 * will each try to update the bandwidth for the same period, making
 	 * the bandwidth drift much faster than the desired rate (as in the
-	 * single dirtier case). So do some rate limiting.
+	 * single dirtier case).
+	 *
+	 * If someone changed bdi->write_bandwidth_update_time, he has done
+	 * overlapped estimation with us. So start the next round of estimation.
 	 */
-	if (jiffies - bdi->write_bandwidth_update_time < elapsed)
+	if (jiffies - bdi->write_bandwidth_update_time != elapsed)
 		goto snapshot;
 
 	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
