Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1K1BQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:16:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:18591 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab1K1BQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:16:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,580,1315206000"; 
   d="scan'208";a="41553744"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v4 4/6] [SCSI] sd: check runtime PM status in sd_shutdown
Date: Mon, 28 Nov 2011 09:15:48 +0800
Message-Id: <1322442950-16268-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd_shutdown is called during reboot/poweroff.
It may fail if parent device, for example, ata port, was runtime suspended.

Fix it by checking runtime PM status of sd.
Exit immediately if sd was runtime suspended already.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..7b3f807 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -2741,6 +2742,9 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
+	if (pm_runtime_suspended(dev))
+		goto exit;
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
@@ -2751,6 +2755,7 @@ static void sd_shutdown(struct device *dev)
 		sd_start_stop_device(sdkp, 0);
 	}
 
+exit:
 	scsi_disk_put(sdkp);
 }
 
-- 
1.7.2.5

