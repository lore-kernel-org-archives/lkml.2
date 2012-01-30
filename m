Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2A3PAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:00:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2A3PAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:00:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, sjayaraman@suse.com, gouders@et.bocholt.fh-gelsenkirchen.de,
        vgoyal@redhat.com
Subject: [PATCH 1/2] floppy: Cleanup disk->queue before caling put_disk() if add_disk() was never called
Date: Mon, 30 Jan 2012 09:59:50 -0500
Message-Id: <1327935591-26812-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
References: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_disk() takes gendisk reference on request queue. If driver failed during
initialization and never called add_disk() then that extra reference is not
taken. That reference is put in put_disk(). floppy driver allocates the
disk, allocates queue, sets disk->queue and then relizes that floppy
controller is not present. It tries to tear down everything and tries to
put a reference down in put_disk() which was never taken.

In such error cases cleanup disk->queue before calling put_disk() so that
we never try to put down a reference which was never taken in first place.

Reported-and-tested-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/floppy.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 510fb10..401ba78 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4368,8 +4368,14 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue)
+		if (disks[dr]->queue) {
 			blk_cleanup_queue(disks[dr]->queue);
+			/*
+			 * put_disk() is not paired with add_disk() and
+			 * will put queue reference one extra time. fix it.
+			 */
+			disks[dr]->queue = NULL;
+		}
 		put_disk(disks[dr]);
 	}
 	return err;
-- 
1.7.4.4

