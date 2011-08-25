Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1HYUdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab1HYUda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:33:30 -0400
Date: Thu, 25 Aug 2011 16:32:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Ryan Harper <ryanh@us.ibm.com>
Subject: [PATCH] blk-throttle: Do not trim slices if there is remainder after
 division
Message-ID: <20110825203225.GD27162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throttling code divides a second into smaller slices of 100ms each and
then decides how many IOPs are allowed in that 100ms. Once IO has been
dispatched, these slices are reaped off from effective slice.

Division by a factor of 10, can lead to error if input IOPS rate is
not a mulitple of 10. As remainder is discarded. So if input rate is
69 IOPS, then we effectively get only 60 IOPS.

Hence do not trim slice at every 100ms period if input rate is not
a multiple of 10. Instead wait for full second to complete and 
then trim 10 slices at one go.

Reported-by: Ryan Harper <ryanh@us.ibm.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-08-25 16:27:55.869757580 -0400
+++ linux-2.6/block/blk-throttle.c	2011-08-25 16:28:34.866572646 -0400
@@ -534,7 +534,7 @@ throtl_slice_used(struct throtl_data *td
 static inline void
 throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
 {
-	unsigned long nr_slices, time_elapsed, io_trim;
+	unsigned long nr_slices, time_elapsed, io_trim, io_remainder;
 	u64 bytes_trim, tmp;
 
 	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
@@ -569,6 +569,19 @@ throtl_trim_slice(struct throtl_data *td
 
 	io_trim = (tg->iops[rw] * throtl_slice * nr_slices)/HZ;
 
+	/*
+	 * Due to division operation of input rate, we can lose some accuracy
+	 * as raminder is discarded. For example with iops=69, we will dispatch
+	 * 6 ios but then trim slice after 100ms and never extend slice enough
+	 * so that over a period of 1 second 69 IOs are dispatched. Instead we
+	 * dispatch 6 IO at each slice interval and trim the slice. So go
+	 * ahead with trim operation only when there is no remainder. That
+	 */
+	io_remainder = (tg->iops[rw] * throtl_slice * nr_slices)%HZ;
+
+	if (io_remainder)
+		return;
+
 	if (!bytes_trim && !io_trim)
 		return;
 
