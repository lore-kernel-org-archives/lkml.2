Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab2HIUAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:00:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab2HIUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:00:17 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5/6] floppy: remove check for allocated queue on do_floppy_init error handling
Date: Thu,  9 Aug 2012 16:59:50 -0300
Message-Id: <1344542391-16474-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check "if (disks[dr]->queue)" check is bogus, if we reach there
for each dr should exist an queue allocated (note that we decrement dr
first on entering the loop).

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3eafe93..438ffc9 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4332,15 +4332,13 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
-			blk_cleanup_queue(disks[dr]->queue);
-			/*
-			 * put_disk() is not paired with add_disk() and
-			 * will put queue reference one extra time. fix it.
-			 */
-			if (!disk_registered[dr])
-				disks[dr]->queue = NULL;
-		}
+		blk_cleanup_queue(disks[dr]->queue);
+		/*
+		 * put_disk() is not paired with add_disk() and
+		 * will put queue reference one extra time. fix it.
+		 */
+		if (!disk_registered[dr])
+			disks[dr]->queue = NULL;
 		put_disk(disks[dr]);
 	}
 	destroy_workqueue(floppy_wq);
-- 
1.7.9.5

