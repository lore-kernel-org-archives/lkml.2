Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1HSGIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:08:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:47005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1HSGII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,249,1312182000"; 
   d="scan'208";a="41516079"
Date: Fri, 19 Aug 2011 14:08:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] writeback: Per-block device
 bdi->dirty_writeback_interval and bdi->dirty_expire_interval.
Message-ID: <20110819060803.GA7887@localhost>
References: <CAFPAmTSrh4r71eQqW-+_nS2KFK2S2RQvYBEpa3QnNkZBy8ncbw@mail.gmail.com>
 <20110818094824.GA25752@localhost>
 <1313669702.6607.24.camel@sauron>
 <20110818131343.GA17473@localhost>
 <CAFPAmTShNRykOEbUfRan_2uAAbBoRHE0RhOh4DrbWKq7a4-Z9Q@mail.gmail.com>
 <20110819023406.GA12732@localhost>
 <CAFPAmTSzYg5n150_ykv-Vvc4QVbz14Oxn_Mm+EqxzbUL3c39tg@mail.gmail.com>
 <20110819052839.GB28266@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819052839.GB28266@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kautuk,

Here is a quick demo for bdi->dirty_background_time. Totally untested.

Thanks,
Fengguang

---
 fs/fs-writeback.c           |   16 +++++++++++-----
 include/linux/backing-dev.h |    1 +
 include/linux/writeback.h   |    1 +
 mm/backing-dev.c            |   23 +++++++++++++++++++++++
 mm/page-writeback.c         |    3 ++-
 5 files changed, 38 insertions(+), 6 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-08-19 13:59:41.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-08-19 14:00:36.000000000 +0800
@@ -653,14 +653,20 @@ long writeback_inodes_wb(struct bdi_writ
 	return nr_pages - work.nr_pages;
 }
 
-static inline bool over_bground_thresh(void)
+bool over_bground_thresh(struct backing_dev_info *bdi)
 {
 	unsigned long background_thresh, dirty_thresh;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
-	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
+	if (global_page_state(NR_FILE_DIRTY) +
+	    global_page_state(NR_UNSTABLE_NFS) > background_thresh)
+		return true;
+
+	background_thresh = bdi->avg_write_bandwidth *
+					(u64)bdi->dirty_background_time / 1000;
+
+	return bdi_stat(bdi, BDI_RECLAIMABLE) > background_thresh;
 }
 
 /*
@@ -722,7 +728,7 @@ static long wb_writeback(struct bdi_writ
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
-		if (work->for_background && !over_bground_thresh())
+		if (work->for_background && !over_bground_thresh(wb->bdi))
 			break;
 
 		if (work->for_kupdate) {
@@ -806,7 +812,7 @@ static unsigned long get_nr_dirty_pages(
 
 static long wb_check_background_flush(struct bdi_writeback *wb)
 {
-	if (over_bground_thresh()) {
+	if (over_bground_thresh(wb->bdi)) {
 
 		struct wb_writeback_work work = {
 			.nr_pages	= LONG_MAX,
--- linux-next.orig/include/linux/backing-dev.h	2011-08-19 13:59:41.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-08-19 14:00:07.000000000 +0800
@@ -91,6 +91,7 @@ struct backing_dev_info {
 
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
+	unsigned int dirty_background_time;
 
 	struct bdi_writeback wb;  /* default writeback info for this bdi */
 	spinlock_t wb_lock;	  /* protects work_list */
--- linux-next.orig/mm/backing-dev.c	2011-08-19 13:59:41.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-08-19 14:03:15.000000000 +0800
@@ -225,12 +225,33 @@ static ssize_t max_ratio_store(struct de
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
+static ssize_t dirty_background_time_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ms;
+	ssize_t ret = -EINVAL;
+
+	ms = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		bdi->dirty_background_time = ms;
+		if (!ret)
+			ret = count;
+		if (over_bground_thresh(bdi))
+			bdi_start_background_writeback(bdi);
+	}
+	return ret;
+}
+BDI_SHOW(dirty_background_time, bdi->dirty_background_time)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
 	__ATTR_RW(max_ratio),
+	__ATTR_RW(dirty_background_time),
 	__ATTR_NULL,
 };
 
@@ -657,6 +678,8 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
+	bdi->dirty_background_time = 10000;
+
 	spin_lock_init(&bdi->wb_lock);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->work_list);
--- linux-next.orig/mm/page-writeback.c	2011-08-19 14:00:07.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-19 14:00:07.000000000 +0800
@@ -1163,7 +1163,8 @@ pause:
 	if (laptop_mode)
 		return;
 
-	if (nr_reclaimable > background_thresh)
+	if (nr_reclaimable > background_thresh ||
+	    over_bground_thresh(bdi))
 		bdi_start_background_writeback(bdi);
 }
 
--- linux-next.orig/include/linux/writeback.h	2011-08-19 14:00:41.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-08-19 14:01:19.000000000 +0800
@@ -132,6 +132,7 @@ extern int block_dump;
 extern int laptop_mode;
 
 extern unsigned long determine_dirtyable_memory(void);
+extern bool over_bground_thresh(struct backing_dev_info *bdi);
 
 extern int dirty_background_ratio_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
