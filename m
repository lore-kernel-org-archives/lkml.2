Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0JATOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:14:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55841 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0JATOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:14:53 -0400
Subject: [RFC][PATCH] try not to let dirty inodes fester
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, lnxninja@linux.vnet.ibm.com, axboe@kernel.dk,
        pbadari@us.ibm.com, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 Oct 2010 12:14:49 -0700
Message-Id: <20101001191449.0AA0E233@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've got a bug that I've been investigating.  The inode cache for a
certain fs grows and grows, desptite running

	echo 2 > /proc/sys/vm/drop_caches

all the time.  Not that running drop_caches is a good idea, but it
_should_ force things to stay under control.  That is, unless the
inodes are dirty.

I think I'm seeing a case where the inode's dentry goes away, it
hits iput_final().  It is dirty, so it stays off the inode_unused
list waiting around for writeback.

Then, the periodic writeback happens, and we end up in
wb_writeback().  One of the first things we do in the loop (before
writing out inodes) is this:

	if (work->for_background && !over_bground_thresh())
		break;

over_bground_thresh() doesn't take dirty inodes into account.  So
if we are in a situation where there are no dirty pages, we will
trip this, and break.  If the system continues to dirty inodes
without dirtying any pages along the way, I don't think we will
ever do periodic writeback of the dirty inodes.

The attached patch moves the check down below some of the inode
writeback.  It seems to do some good, but I'm worried that it
will cause additional I/O when we are below the writeback
thresholds.


---

 linux-2.6.git-dave/fs/fs-writeback.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/fs-writeback.c~wb.diff fs/fs-writeback.c
--- linux-2.6.git/fs/fs-writeback.c~wb.diff	2010-10-01 12:12:11.000000000 -0700
+++ linux-2.6.git-dave/fs/fs-writeback.c	2010-10-01 12:12:11.000000000 -0700
@@ -625,12 +625,10 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
-		 * For background writeout, stop when we are below the
-		 * background dirty threshold
+		 * inodes are not accounted for in the background thresholds
+		 * so we might leave too many of them dirty unless we do
+		 * _some_ writeout without concern for over_bground_thresh()
 		 */
-		if (work->for_background && !over_bground_thresh())
-			break;
-
 		wbc.more_io = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -646,6 +644,13 @@ static long wb_writeback(struct bdi_writ
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
+		 * For background writeout, stop when we are below the
+		 * background dirty threshold
+		 */
+		if (work->for_background && !over_bground_thresh())
+			break;
+
+		/*
 		 * If we consumed everything, see if we have more
 		 */
 		if (wbc.nr_to_write <= 0)
diff -puN MAINTAINERS~wb.diff MAINTAINERS
_
