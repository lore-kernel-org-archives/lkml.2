Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab0FISy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:54:56 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758227Ab0FISyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:21 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183626.499637581@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:57 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] floppy: use warning macros
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-warn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert assertions to use WARN().  There are several error checks
in the code for things that should never happen. Convert them to
standard warnings so kerneloops.org will see them.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2010-06-08 08:08:36.363245707 -0700
+++ b/drivers/block/floppy.c	2010-06-08 08:08:40.360468297 -0700
@@ -2532,10 +2532,8 @@ static int make_raw_rw_request(void)
 	int tracksize;
 	int ssize;
 
-	if (max_buffer_sectors == 0) {
-		pr_info("VFS: Block I/O scheduled on unopened device\n");
+	if (WARN(max_buffer_sectors == 0, "VFS: Block I/O scheduled on unopened device\n"))
 		return 0;
-	}
 
 	set_fdc((long)current_req->rq_disk->private_data);
 
@@ -2895,19 +2893,16 @@ static void process_fd_request(void)
 
 static void do_fd_request(struct request_queue *q)
 {
-	if (max_buffer_sectors == 0) {
-		pr_info("VFS: %s called on non-open device\n", __func__);
+	if (WARN(max_buffer_sectors == 0,
+		 "VFS: %s called on non-open device\n", __func__))
 		return;
-	}
 
-	if (atomic_read(&usage_count) == 0) {
-		pr_info("warning: usage count=0, current_req=%p exiting\n",
-			current_req);
-		pr_info("sect=%ld type=%x flags=%x\n",
-			(long)blk_rq_pos(current_req), current_req->cmd_type,
-			current_req->cmd_flags);
+	if (WARN(atomic_read(&usage_count) == 0,
+		 "warning: usage count=0, current_req=%p sect=%ld type=%x flags=%x\n",
+		 current_req, (long)blk_rq_pos(current_req), current_req->cmd_type,
+		 current_req->cmd_flags))
 		return;
-	}
+
 	if (test_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
@@ -3817,10 +3812,10 @@ static int floppy_revalidate(struct gend
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) || NO_GEOM) {
-		if (atomic_read(&usage_count) == 0) {
-			pr_info("VFS: revalidate called on non-open device.\n");
+		if (WARN(atomic_read(&usage_count) == 0,
+			 "VFS: revalidate called on non-open device.\n"))
 			return -EFAULT;
-		}
+
 		lock_fdc(drive, false);
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));


