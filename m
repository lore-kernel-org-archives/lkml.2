Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2A3PAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:00:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2A3PAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:00:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, sjayaraman@suse.com, gouders@et.bocholt.fh-gelsenkirchen.de,
        vgoyal@redhat.com
Subject: [PATCH 2/2] floppy: Fix a crash during rmmod
Date: Mon, 30 Jan 2012 09:59:51 -0500
Message-Id: <1327935591-26812-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
References: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

floppy driver does not call add_disk() on all the drives hence we don't take
gendisk reference on request queue for these drives. Don't call put_disk()
with disk->queue set, otherwise we try to put the reference we never took.

Reported-and-tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Signed-off-by: Vivek Goyal<vgoyal@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/floppy.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 401ba78..9baf11e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4585,6 +4585,15 @@ static void __exit floppy_module_exit(void)
 			platform_device_unregister(&floppy_device[drive]);
 		}
 		blk_cleanup_queue(disks[drive]->queue);
+
+		/*
+		 * These disks have not called add_disk().  Don't put down
+		 * queue reference in put_disk().
+		 */
+		if (!(allowed_drive_mask & (1 << drive)) ||
+		    fdc_state[FDC(drive)].version == FDC_NONE)
+			disks[drive]->queue = NULL;
+
 		put_disk(disks[drive]);
 	}
 
-- 
1.7.4.4

