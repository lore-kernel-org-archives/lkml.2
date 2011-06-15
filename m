Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1FPHlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:41:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43204 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab1FPHAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:21 -0400
X-Sasl-enc: Cyid3EklEpn5O3SEEXu+MX6xXiqD/NqgXzoHLC1/R+F5 1308207620
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.377726335@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [14/89] block: blkdev_get() should access ->bd_disk only after
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 success

From: Tejun Heo <tj@kernel.org>

commit 4c49ff3fe128ca68dabd07537415c419ad7f82f9 upstream.

d4dc210f69 (block: don't block events on excl write for non-optical
devices) added dereferencing of bdev->bd_disk to test
GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE; however, bdev->bd_disk can be
%NULL if open failed which can lead to an oops.

Test the flag after testing open was successful, not before.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Miller <davem@davemloft.net>
Tested-by: David Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1272,8 +1272,8 @@ int blkdev_get(struct block_device *bdev
 		 * individual writeable reference is too fragile given the
 		 * way @mode is used in blkdev_get/put().
 		 */
-		if ((disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE) &&
-		    !res && (mode & FMODE_WRITE) && !bdev->bd_write_holder) {
+		if (!res && (mode & FMODE_WRITE) && !bdev->bd_write_holder &&
+		    (disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE)) {
 			bdev->bd_write_holder = true;
 			disk_block_events(disk);
 		}


