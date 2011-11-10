Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1KJGXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:23:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:30670 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1KJGXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,487,1315206000"; 
   d="scan'208";a="72745976"
From: Lin Ming <ming.m.lin@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v2 2/4] scsi: add flag to skip the runtime PM calls on host in EH
Date: Thu, 10 Nov 2011 14:22:44 +0800
Message-Id: <1320906166-15459-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With previous change, now the ata port runtime suspend will happen as:

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend

ata port(parent device) suspend need to schedule scsi EH which will resume
scsi host(child device). Then the child device resume will in turn make
parent device resume first. This is kind of dead lock.

This patch adds a new flag Scsi_Host::eh_noresume.
ata port will set this flag to skip the runtime PM calls on scsi host
in the error handler.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_error.c |    5 +++--
 include/scsi/scsi_host.h  |    3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc6131e..5f84a14 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1812,7 +1812,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (scsi_autopm_get_host(shost) != 0) {
+		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk(KERN_ERR "Error handler scsi_eh_%d "
 						"unable to autoresume\n",
@@ -1833,7 +1833,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		scsi_autopm_put_host(shost);
+		if (!shost->eh_noresume)
+			scsi_autopm_put_host(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 50266c9..5f7d5b3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -669,6 +669,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* Don't resume host in EH */
+	unsigned eh_noresume:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.7.2.5

