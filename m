Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2G0JC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:02:56 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:17275
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab2G0JCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:02:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7TAFR-02-6OO-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>
CC: Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v4 2/7] scsi: pm: add interface to autosuspend scsi device
Date: Fri, 27 Jul 2012 17:00:45 +0800
Message-ID: <1343379650-2867-3-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 27 Jul 2012 09:01:59.0252 (UTC) FILETIME=[7AE39140:01CD6BD6]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new interface scsi_autopm_put_device_autosuspend to mark
last busy for the device and then put autosuspend the device.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/scsi_pm.c     | 7 +++++++
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..83edb93 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -201,6 +201,13 @@ void scsi_autopm_put_device(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
 
+void scsi_autopm_put_device_autosuspend(struct scsi_device *sdev)
+{
+	pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+	pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL_GPL(scsi_autopm_put_device_autosuspend);
+
 void scsi_autopm_get_target(struct scsi_target *starget)
 {
 	pm_runtime_get_sync(&starget->dev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..3636146 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -395,9 +395,11 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
 extern void scsi_autopm_put_device(struct scsi_device *);
+extern void scsi_autopm_put_device_autosuspend(struct scsi_device *);
 #else
 static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
 static inline void scsi_autopm_put_device(struct scsi_device *d) {}
+static inline void scsi_autopm_put_device_autosuspend(struct scsi_device *d) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
-- 
1.7.11.3


