Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1AVBRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:45788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1AVBRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:36 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 02/10] ide-cd: convert to blk_delay_queue() for a short pause
Date: Sat, 22 Jan 2011 01:17:21 +0000
Message-Id: <1295659049-2688-3-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 drivers/ide/ide-cd.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0c73fe3..7ce9caf 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -258,17 +258,10 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
 	if (time_after(jiffies, info->write_timeout))
 		return 0;
 	else {
-		struct request_queue *q = drive->queue;
-		unsigned long flags;
-
 		/*
-		 * take a breather relying on the unplug timer to kick us again
+		 * take a breather
 		 */
-
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_plug_device(q);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-
+		blk_delay_queue(drive->queue, 1);
 		return 1;
 	}
 }
@@ -1514,8 +1507,6 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	blk_queue_dma_alignment(q, 31);
 	blk_queue_update_dma_pad(q, 15);
 
-	q->unplug_delay = max((1 * HZ) / 1000, 1);
-
 	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
 
-- 
1.7.3.2.146.gca209

