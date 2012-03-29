Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2C2XrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:47:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35185
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932551Ab2C2XrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:47:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Properly handle errors from the host
Date: Thu, 29 Mar 2012 16:54:43 -0700
Message-Id: <1333065283-30484-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the host returns error for pass through commands, deal with
appropriately. I would like to thank James for patiently helping
me with this patch.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 83a1972..5053769 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -785,12 +785,24 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	/*
 	 * If there is an error; offline the device since all
 	 * error recovery strategies would have already been
-	 * deployed on the host side.
+	 * deployed on the host side. However, if the command
+	 * were a pass-through command deal with it appropriately.
 	 */
-	if (vm_srb->srb_status == SRB_STATUS_ERROR)
-		scmnd->result = DID_TARGET_FAILURE << 16;
-	else
+	switch (vm_srb->srb_status) {
+	case SRB_STATUS_ERROR:
+		switch (scmnd->cmnd[0]) {
+		case ATA_16:
+		case ATA_12:
+			scmnd->result = DID_PASSTHROUGH << 16;
+			break;
+		default:
+			scmnd->result = DID_TARGET_FAILURE << 16;
+		}
+		break;
+	default:
 		scmnd->result = vm_srb->scsi_status;
+	}
+
 
 	/*
 	 * If the LUN is invalid; remove the device.
-- 
1.7.4.1

