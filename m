Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2AFDdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 22:33:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442Ab2AFDdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 22:33:42 -0500
Date: Fri, 6 Jan 2012 11:35:55 +0800
From: Dave Young <dyoung@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH] loop: zero fill bio instead of return -EIO for partial read
Message-ID: <20120106033555.GA27916@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8268f5a7415d914fc855a86aa2284ac819dc6b2e trying to fix the loop device
partial read information leak problem. But it changed the semantics of read
behavior. When we read beyond the end of the device we should get 0 bytes,
which is normal behavior, we should not just return -EIO

Instead of return -EIO, zero out the bio to avoid information leak in case of
partail read. 

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/block/loop.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- linux-2.6.orig/drivers/block/loop.c	2012-01-06 11:19:48.000000000 +0800
+++ linux-2.6/drivers/block/loop.c	2012-01-06 11:20:18.842630580 +0800
@@ -357,14 +357,14 @@ lo_direct_splice_actor(struct pipe_inode
 	return __splice_from_pipe(pipe, sd, lo_splice_actor);
 }
 
-static int
+static ssize_t
 do_lo_receive(struct loop_device *lo,
 	      struct bio_vec *bvec, int bsize, loff_t pos)
 {
 	struct lo_read_data cookie;
 	struct splice_desc sd;
 	struct file *file;
-	long retval;
+	ssize_t retval;
 
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
@@ -380,26 +380,28 @@ do_lo_receive(struct loop_device *lo,
 	file = lo->lo_backing_file;
 	retval = splice_direct_to_actor(file, &sd, lo_direct_splice_actor);
 
-	if (retval < 0)
-		return retval;
-	if (retval != bvec->bv_len)
-		return -EIO;
-	return 0;
+	return retval;
 }
 
 static int
 lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
 {
 	struct bio_vec *bvec;
-	int i, ret = 0;
+	ssize_t s;
+	int i;
 
 	bio_for_each_segment(bvec, bio, i) {
-		ret = do_lo_receive(lo, bvec, bsize, pos);
-		if (ret < 0)
+		s = do_lo_receive(lo, bvec, bsize, pos);
+		if (s < 0)
+			return s;
+
+		if (s != bvec->bv_len) {
+			zero_fill_bio(bio);
 			break;
+		}
 		pos += bvec->bv_len;
 	}
-	return ret;
+	return 0;
 }
 
 static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
