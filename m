Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2GXJlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:41:10 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19934
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab2GXJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:39:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7NS66-02-1NO-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Wu <jeff.wu@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 2/7] scsi: pm: use autosuspend if device supports it
Date: Tue, 24 Jul 2012 17:37:40 +0800
Message-ID: <1343122665-18711-3-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 24 Jul 2012 09:39:30.0617 (UTC) FILETIME=[39915A90:01CD6980]
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
 drivers/scsi/scsi_pm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..a002fbf 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -196,7 +196,12 @@ EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
 
 void scsi_autopm_put_device(struct scsi_device *sdev)
 {
-	pm_runtime_put_sync(&sdev->sdev_gendev);
+	if (sdev->sdev_gendev.power.use_autosuspend) {
+		pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+		pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+	} else {
+		pm_runtime_put_sync(&sdev->sdev_gendev);
+	}
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
 
-- 
1.7.11.3


