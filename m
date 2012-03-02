Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2CBGOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:14:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:22732 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510Ab2CBGOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:14:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="132145869"
Date: Fri, 2 Mar 2012 14:14:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: use global_dirty_limit in throttle_vm_writeout()
Message-ID: <20120302061451.GA6468@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When starting a memory hog task, a desktop box w/o swap is found to go
unresponsive for a long time. It's solely caused by lots of congestion
waits in throttle_vm_writeout():

 gnome-system-mo-4201 553.073384: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
 gnome-system-mo-4201 553.073386: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
           gtali-4237 553.080377: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
           gtali-4237 553.080378: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
            Xorg-3483 553.103375: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
            Xorg-3483 553.103377: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000

The root cause is, the dirty threshold is knocked down a lot by the
memory hog task. Fixed by using global_dirty_limit which decreases
gradually on such events and can guarantee we stay above (the also
decreasing) nr_dirty in the progress of following down to the new
dirty threshold.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/mm/page-writeback.c	2012-03-02 14:05:01.633763187 +0800
+++ linux/mm/page-writeback.c	2012-03-02 14:11:52.929772962 +0800
@@ -1472,6 +1472,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 
         for ( ; ; ) {
 		global_dirty_limits(&background_thresh, &dirty_thresh);
+		dirty_thresh = hard_dirty_limit(dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
