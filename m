Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0EGH3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:29:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55747 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0EGH3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:29:00 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ramzswap: Handler for swap slot free callback
Date: Fri,  7 May 2010 12:55:07 +0530
Message-Id: <1273217107-2023-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Install handler for swap_slot_free_notify callback which is called
when a swap slot is no longer used. This handler immediately frees
memory allocated corresponding to the given swap slot.

Signed-off-by: Nitin Gupta
---
 drivers/staging/ramzswap/TODO           |    5 -----
 drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
 2 files changed, 13 insertions(+), 14 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/TODO

diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
deleted file mode 100644
index 8d64e28..0000000
--- a/drivers/staging/ramzswap/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO:
-	- Add support for swap notifiers
-
-Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
-Nitin Gupta <ngupta@vflare.org>
diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index ee5eb12..ab15276 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -795,14 +795,6 @@ static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
 
 	src = rzs->compress_buffer;
 
-	/*
-	 * System swaps to same sector again when the stored page
-	 * is no longer referenced by any process. So, its now safe
-	 * to free the memory that was allocated for this page.
-	 */
-	if (rzs->table[index].page || rzs_test_flag(rzs, index, RZS_ZERO))
-		ramzswap_free_page(rzs, index);
-
 	mutex_lock(&rzs->lock);
 
 	user_mem = kmap_atomic(page, KM_USER0);
@@ -1295,9 +1287,21 @@ out:
 	return ret;
 }
 
+void ramzswap_slot_free_notify(struct block_device *bdev, unsigned long index)
+{
+	struct ramzswap *rzs;
+
+	rzs = bdev->bd_disk->private_data;
+	ramzswap_free_page(rzs, index);
+	rzs_stat64_inc(rzs, &rzs->stats.notify_free);
+
+	return;
+}
+
 static struct block_device_operations ramzswap_devops = {
 	.ioctl = ramzswap_ioctl,
-	.owner = THIS_MODULE,
+	.swap_slot_free_notify = ramzswap_slot_free_notify,
+	.owner = THIS_MODULE
 };
 
 static int create_device(struct ramzswap *rzs, int device_id)
-- 
1.6.6.1

