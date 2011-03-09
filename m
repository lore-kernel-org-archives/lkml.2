Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1CIJOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1CIJNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bn9g/RsVHdx+EunHznqAZvYpIfgYIaML6llSwyXaJy8WTNuZjVG/dKKeFOmVTjPrUk
         h/ml7q3VP+zH5UJAuL6O8uVwQD3QanD5QO9YgwAqhyTjr5dneD3n7AyXUsS7WCfUYnjQ
         CHFJ/8OjuuE/Br+llWgeMWDOcqLFFlhhumEvI=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] block: Don't check events on close unless it was blocked
Date: Wed,  9 Mar 2011 10:13:22 +0100
Message-Id: <1299662016-7721-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block event mechanism currently always checks events when the
device is being closed regardless of the open mode.  The intention was
to allow detection of EJECT_REQUEST when a device is closed whether
disk event polling is enabled or not.

This is unnecessary as, for devices of interest, events are checked
from either userland or kernel and in the former case ->check_events()
is performed on open of each poll attempt anyway.  Furthermore, this
unconditional event check on close makes the code susceptible to event
loop if the block driver doesn't clear reported events correctly - an
event triggers userland to open and close the device which in turn
causes another event, rinse and repeat.

Check events on close only if it was blocked by excl write open.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 fs/block_dev.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fffdf86..7dd2c65 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1448,13 +1448,11 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 				disk_unblock_events(bdev->bd_disk);
 				disk_check_events(bdev->bd_disk);
 				bdev->bd_write_holder = false;
-			} else
-				disk_check_events(bdev->bd_disk);
+			}
 		}
 
 		mutex_unlock(&bdev->bd_mutex);
-	} else
-		disk_check_events(bdev->bd_disk);
+	}
 
 	return __blkdev_put(bdev, mode, 0);
 }
-- 
1.7.1

