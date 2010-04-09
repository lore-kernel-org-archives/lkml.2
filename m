Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0DIOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:01:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:45342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0DIOBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:21 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 01/12] osst: Update ppos instead of using file->f_pos
Date: Fri,  9 Apr 2010 16:00:44 +0200
Message-Id: <1270821655-4368-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

osst_read()/osst_write() modify file->f_pos directly instead of the ppos
given to them. The VFS later updates the file->f_pos and overwrites it
with the value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/scsi/osst.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..9dc0b9a 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -3586,7 +3586,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 		if (i == (-ENOSPC)) {
 			transfer = STp->buffer->writing;	/* FIXME -- check this logic */
 			if (transfer <= do_count) {
-				filp->f_pos += do_count - transfer;
+				*ppos += do_count - transfer;
 				count -= do_count - transfer;
 				if (STps->drv_block >= 0) {
 					STps->drv_block += (do_count - transfer) / STp->block_size;
@@ -3624,7 +3624,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 			goto out;
 		}
 
-		filp->f_pos += do_count;
+		*ppos += do_count;
 		b_point += do_count;
 		count -= do_count;
 		if (STps->drv_block >= 0) {
@@ -3646,7 +3646,7 @@ if (SRpnt) printk(KERN_ERR "%s:A: Not supposed to have SRpnt at line %d\n", name
 		if (STps->drv_block >= 0) {
 			STps->drv_block += blks;
 		}
-		filp->f_pos += count;
+		*ppos += count;
 		count = 0;
 	}
 
@@ -3822,7 +3822,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
 			}
 			STp->logical_blk_num += transfer / STp->block_size;
 			STps->drv_block      += transfer / STp->block_size;
-			filp->f_pos          += transfer;
+			*ppos          += transfer;
 			buf                  += transfer;
 			total                += transfer;
 		}
-- 
1.6.4.2

