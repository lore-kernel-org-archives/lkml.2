Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab1EaX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:56:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49637 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab1EaX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JF+N6GkEhk87tp1cxd5BlE54Jmfi8Q2oy0JHRH0AYVqTL/oXtS8seknQ3btK1U6SAh
         zHpN/70+WgUPwpSrb1SK5qlS4xq0MKA3cgPA1vCymB+J1Ou5gepDDNorRiXaS/taKX6s
         U5Ypw1izWhJW96vnHWdoA/Gqs8VjywybYLs/w=
Date: Wed, 1 Jun 2011 08:56:47 +0900
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] block: blkdev_get() should acess ->bd_disk only after success
Message-ID: <20110531235647.GD9048@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d4dc210f69 (block: don't block events on excl write for non-optical
devices) added dereferencing of bdev->bd_disk to test
GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE; however, bdev->bd_disk can be
%NULL if open failed which can lead to an oops.

Test the flag after testing open was successful, not before.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Miller <davem@davemloft.net>
Tested-by: David Miller <davem@davemloft.net>
Cc: stable@kernel.org
---
 fs/block_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1f2b199..1a2421f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1272,8 +1272,8 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
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
