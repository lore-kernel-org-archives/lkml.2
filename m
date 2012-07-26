Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GZKIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:08:43 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:12404
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab2GZKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:06:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RIQD-02-3P0-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 18:05:24 +0800
Message-ID: <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 26 Jul 2012 10:05:58.0472 (UTC) FILETIME=[40D44C80:01CD6B16]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is using autosuspend, when scsi_autopm_put_device is
called for it, use autosuspend runtime pm calls instead of the sync
call.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/scsi_pm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..7c93723 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -197,7 +197,13 @@ EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
 
 void scsi_autopm_put_device(struct scsi_device *sdev)
 {
-	pm_runtime_put_sync(&sdev->sdev_gendev);
+	if (sdev->sdev_gendev.power.use_autosuspend) {
+		pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+		pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+	} else {
+		pm_runtime_put_sync(&sdev->sdev_gendev);
+	}
+
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
 
-- 
1.7.11.3


