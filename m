Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2GWGvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:51:24 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21485
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab2GWGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:50:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7LPOU-02-5HU-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 1/5] scsi: sr: fix for sr suspend and resume
Date: Mon, 23 Jul 2012 14:49:36 +0800
Message-ID: <1343026180-22236-2-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
References: <1343026180-22236-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 23 Jul 2012 06:50:37.0404 (UTC) FILETIME=[774A01C0:01CD689F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sr_suspend, we do not need to do anything if it is not a runtime pm
request, so just return by checking the PM_EVENT_AUTO flag.
And in sr_resume, only reset the suspend_count back to 1 if the ODD is
waken up by the user, or the usage count of the scsi device will not
balance.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3da0879..5f4d19a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -178,8 +178,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	/* no action for system suspend */
-	if (msg.event == PM_EVENT_SUSPEND)
+	/* no action for system pm operations */
+	if (!(msg.event & PM_EVENT_AUTO))
 		return 0;
 
 	/* do another TUR to see if the ODD is still ready to be powered off */
@@ -217,9 +217,9 @@ static int sr_resume(struct device *dev)
 		cd->device->wakeup_by_user = 0;
 		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
 			sr_tray_move(&cd->cdi, 1);
-	}
 
-	atomic_set(&cd->suspend_count, 1);
+		atomic_set(&cd->suspend_count, 1);
+	}
 
 	return 0;
 }
-- 
1.7.11.3


