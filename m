Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab0GSSjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:17 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11289 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936475Ab0GSSjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:14 -0400
Subject: [PATCH 01/26] cciss: Set the performant mode bit in the scsi half of
	the driver
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:44:45 -0500
Message-ID: <20100719184445.7908.3848.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Set the performant mode bit in the scsi half of the driver
In a couple of places, the performant mode bit wasn't being set in
the scsi half of the driver, causing commands to seem to hang.  Use
enqueue_cmd_and_start_io() where appropriate.  This fixes a bug that

	echo engage scsi > /proc/driver/cciss/cciss0

would hang.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 8e0a709..3604b72 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -921,7 +921,6 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *c,
 			unsigned char *buf, int bufsize,
 			int direction)
 {
-	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
 	cp->cmd_type = CMD_IOCTL_PEND;		// treat this like an ioctl 
@@ -948,14 +947,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *c,
 			bufsize, DMA_FROM_DEVICE); 
 
 	cp->waiting = &wait;
-
-	/* Put the request on the tail of the request queue */
-	spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
-	addQ(&c->reqQ, cp);
-	c->Qdepth++;
-	start_io(c);
-	spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
-
+	enqueue_cmd_and_start_io(c, cp);
 	wait_for_completion(&wait);
 
 	/* undo the dma mapping */
@@ -1525,15 +1517,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		break;
 	}
 	cciss_scatter_gather(c, cp, cmd);
-
-	/* Put the request on the tail of the request queue */
-
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	addQ(&c->reqQ, cp);
-	c->Qdepth++;
-	start_io(c);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-
+	enqueue_cmd_and_start_io(c, cp);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
 }

