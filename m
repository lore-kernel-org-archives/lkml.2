Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1CZS7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:59:05 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47145 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1CZS7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:59:03 -0400
X-ASG-Debug-ID: 1301165941-03d6a57329006b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8E3772.5030507@fusionio.com>
Date: Sat, 26 Mar 2011 19:58:58 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PUL] Two small block fixes for 2.6.39-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PUL] Two small block fixes for 2.6.39-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301165941
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59047
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two things here:

- The fix for the IDE queue re-run on early request_fn exit (or
  otherwise old plug re-run use).

- A bug in the ->check_events() conversion in a staging driver.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      ide: ensure that we re-run the queue handler

Tejun Heo (1):
      staging: Fix bdops->check_events() misconversion in cyasblkdev_block.c

 drivers/ide/ide-io.c                               |   12 +++++++++++-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index f407784..0e406d73 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -440,6 +440,7 @@ void do_ide_request(struct request_queue *q)
 	struct ide_host *host = hwif->host;
 	struct request	*rq = NULL;
 	ide_startstop_t	startstop;
+	unsigned long queue_run_ms = 3; /* old plug delay */
 
 	spin_unlock_irq(q->queue_lock);
 
@@ -459,6 +460,9 @@ repeat:
 		prev_port = hwif->host->cur_port;
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
 		    time_after(drive->sleep, jiffies)) {
+			unsigned long left = jiffies - drive->sleep;
+
+			queue_run_ms = jiffies_to_msecs(left + 1);
 			ide_unlock_port(hwif);
 			goto plug_device;
 		}
@@ -547,8 +551,10 @@ plug_device:
 plug_device_2:
 	spin_lock_irq(q->queue_lock);
 
-	if (rq)
+	if (rq) {
 		blk_requeue_request(q, rq);
+		blk_delay_queue(q, queue_run_ms);
+	}
 }
 
 void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
@@ -562,6 +568,10 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
 		blk_requeue_request(q, rq);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/* Use 3ms as that was the old plug delay */
+	if (rq)
+		blk_delay_queue(q, 3);
 }
 
 static int drive_is_ready(ide_drive_t *drive)
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index 842cd92..289729d 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -1191,7 +1191,7 @@ static int cyasblkdev_add_disks(int bus_num,
 		bd->user_disk_1->first_minor = (devidx + 1) << CYASBLKDEV_SHIFT;
 		bd->user_disk_1->minors = 8;
 		bd->user_disk_1->fops = &cyasblkdev_bdops;
-		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
+		bd->user_disk_1->events = DISK_EVENT_MEDIA_CHANGE;
 		bd->user_disk_1->private_data = bd;
 		bd->user_disk_1->queue = bd->queue.queue;
 		bd->dbgprn_flags = DBGPRN_RD_RQ;

-- 
Jens Axboe

