Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1IFUEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:04:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36167 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab1IFUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:03:59 -0400
Date: Tue, 06 Sep 2011 20:05:44 +0000
From: Ayan George <ayan@ayan.net>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, psusi@cfl.rr.com
Subject: [PATCH 2/2] Remove unnecessary bdev argument from loop_clr_fd().
Message-ID: <4e667d18.0rgGxJF/jVXuYhTi%ayan.george@canonical.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the loop device is associated (lo->lo_state == Lo_bound), it will
have a valid bdev pointed to by lo->lo_device.  There is no reason to
ever pass an additional block_device pointer.

Signed-off-by: Ayan George <ayan.george@canonical.com>
---
 drivers/block/loop.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6d0f28d..f6b552e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -980,10 +980,11 @@ loop_init_xfer(struct loop_device *lo, struct loop_func_table *xfer,
 	return err;
 }
 
-static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
+static int loop_clr_fd(struct loop_device *lo)
 {
 	struct file *filp = lo->lo_backing_file;
 	gfp_t gfp = lo->old_gfp_mask;
+	struct block_device *bdev = lo->lo_device;
 
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
@@ -1293,7 +1294,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_CLR_FD:
 		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
-		err = loop_clr_fd(lo, bdev);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 		break;
@@ -1513,7 +1514,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, lo->lo_device);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 	} else {
-- 
1.7.4.1


