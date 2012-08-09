Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab2HIUAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:00:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab2HIUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:00:08 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3/6] floppy: avoid leaking extra reference to queue on do_floppy_init error handling
Date: Thu,  9 Aug 2012 16:59:48 -0300
Message-Id: <1344542391-16474-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 3f9a5aa ("floppy: Cleanup disk->queue before caling
put_disk() if add_disk() was never called"), if something fails in the
add_disk loop, we unconditionally set disks[dr]->queue to NULL. But
that's wrong, since we may have succesfully done an add_disk on some of
the drives previously in the loop, and in this case we would end up with
an extra reference to the disks[dr]->queue.

Add a new global array to mark "registered" disks, and use that to check
if we did an add_disk on one of the disks already. Using an array to
track added disks also will help to simplify/cleanup code later, as
suggested by Vivek Goyal.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: stable@vger.kernel.org
---
 drivers/block/floppy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1e09e99..9272203 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -409,6 +409,7 @@ static struct floppy_drive_struct drive_state[N_DRIVE];
 static struct floppy_write_errors write_errors[N_DRIVE];
 static struct timer_list motor_off_timer[N_DRIVE];
 static struct gendisk *disks[N_DRIVE];
+static bool disk_registered[N_DRIVE];
 static struct block_device *opened_bdev[N_DRIVE];
 static DEFINE_MUTEX(open_lock);
 static struct floppy_raw_cmd *raw_cmd, default_raw_cmd;
@@ -4305,6 +4306,7 @@ static int __init do_floppy_init(void)
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
 		disks[drive]->driverfs_dev = &floppy_device[drive].dev;
 		add_disk(disks[drive]);
+		disk_registered[drive] = true;
 	}
 
 	return 0;
@@ -4328,7 +4330,8 @@ out_put_disk:
 			 * put_disk() is not paired with add_disk() and
 			 * will put queue reference one extra time. fix it.
 			 */
-			disks[dr]->queue = NULL;
+			if (!disk_registered[dr])
+				disks[dr]->queue = NULL;
 		}
 		put_disk(disks[dr]);
 	}
-- 
1.7.9.5

