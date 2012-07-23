Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2GWHGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:06:07 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:20246
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386Ab2GWHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:06:04 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2012 03:06:04 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7LPOT-02-5HS-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 3/5] scsi: sr: block events when runtime suspended
Date: Mon, 23 Jul 2012 14:49:38 +0800
Message-ID: <1343026180-22236-4-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 23 Jul 2012 06:50:38.0873 (UTC) FILETIME=[782A2890:01CD689F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ODD is runtime suspended, there is no need to poll it for
events, so block events poll for it and unblock when resumed.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 block/genhd.c     | 2 ++
 drivers/scsi/sr.c | 7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9cf5583..bdb3682 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1458,6 +1458,7 @@ void disk_block_events(struct gendisk *disk)
 
 	mutex_unlock(&ev->block_mutex);
 }
+EXPORT_SYMBOL(disk_block_events);
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 {
@@ -1502,6 +1503,7 @@ void disk_unblock_events(struct gendisk *disk)
 	if (disk->ev)
 		__disk_unblock_events(disk, false);
 }
+EXPORT_SYMBOL(disk_unblock_events);
 
 /**
  * disk_flush_events - schedule immediate event checking and flushing
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f7a7635..69c9e22 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -208,6 +208,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 		return -EBUSY;
 	}
 
+	disk_block_events(cd->disk);
+
 	return 0;
 }
 
@@ -230,6 +232,8 @@ static int sr_resume(struct device *dev)
 		atomic_set(&cd->suspend_count, 1);
 	}
 
+	disk_unblock_events(cd->disk);
+
 	return 0;
 }
 
@@ -318,9 +322,6 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
-	if (pm_runtime_suspended(&cd->device->sdev_gendev))
-		return 0;
-
 	/* if the logical unit just finished loading/unloading, do a TUR */
 	if (cd->device->can_power_off && cd->dbml && sr_unit_load_done(cd)) {
 		events = 0;
-- 
1.7.11.3


