Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2GZKG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:06:27 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25073
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab2GZKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:06:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RIQ3-02-3OO-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v3 4/7] scsi: sr: block events when runtime suspended
Date: Thu, 26 Jul 2012 18:05:26 +0800
Message-ID: <1343297129-28174-5-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 26 Jul 2012 10:05:58.0503 (UTC) FILETIME=[40D90770:01CD6B16]
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
index 2573a42..fd1c2f6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -204,6 +204,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 		return -EBUSY;
 	}
 
+	disk_block_events(cd->disk);
+
 	return 0;
 }
 
@@ -225,6 +227,8 @@ static int sr_resume(struct device *dev)
 		atomic_set(&cd->suspend_count, 1);
 	}
 
+	disk_unblock_events(cd->disk);
+
 	return 0;
 }
 
@@ -314,9 +318,6 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
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


