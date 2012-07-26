Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2GZKGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:06:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:15739
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab2GZKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:06:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RIQ7-02-3OX-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v3 6/7] scsi: sr: balance sr disk events block depth
Date: Thu, 26 Jul 2012 18:05:28 +0800
Message-ID: <1343297129-28174-7-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 26 Jul 2012 10:05:58.0534 (UTC) FILETIME=[40DDC260:01CD6B16]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ODD is resumed, disk_unblock_events should be called when:
1 The ODD is runtime resumed;
2 System is resuming from S3 and the ODD is runtime suspended before S3;
But not when the system is resuming from S3 and the ODD is runtime
active before S3.

So seperate the resume calls, one for system resume and one for runtime
resume to do different things accordingly.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fd1c2f6..b8c2f9d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -82,6 +82,11 @@ static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
 static int sr_suspend(struct device *dev, pm_message_t msg);
 static int sr_resume(struct device *dev);
+static int sr_runtime_resume(struct device *dev);
+
+static struct dev_pm_ops sr_pm_ops = {
+	.runtime_resume = sr_runtime_resume,
+};
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -91,6 +96,7 @@ static struct scsi_driver sr_template = {
 		.remove		= sr_remove,
 		.suspend	= sr_suspend,
 		.resume		= sr_resume,
+		.pm		= &sr_pm_ops,
 	},
 	.done			= sr_done,
 };
@@ -211,6 +217,21 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 
 static int sr_resume(struct device *dev)
 {
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/*
+	 * If ODD is runtime suspended before system pm, unblock disk
+	 * events now since on system resume, we will fully resume it
+	 * and set its rumtime status to active.
+	 */
+	if (pm_runtime_suspended(dev))
+		disk_unblock_events(cd->disk);
+
+	return 0;
+}
+
+static int sr_runtime_resume(struct device *dev)
+{
 	struct scsi_cd *cd;
 	struct scsi_sense_hdr sshdr;
 
-- 
1.7.11.3


