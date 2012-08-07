Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225Ab2HGDxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:53:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59641 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757289Ab2HGDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:12 -0400
Message-Id: <20120807032756.478538531@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:27:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vivek Goyal <vgoyal@redhat.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [ 02/70] floppy: Cleanup disk->queue before caling put_disk() if add_disk()
 was never called
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Goyal <vgoyal@redhat.com>

commit 3f9a5aabd0a9fe0e0cd308506f48963d79169aa7 upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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


