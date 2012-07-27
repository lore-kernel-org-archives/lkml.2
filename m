Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2G0JCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:02:44 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:27491
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab2G0JCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:02:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7TAFH-02-6O7-02
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
Subject: [PATCH v4 5/7] scsi: pm: use runtime resume callback if available
Date: Fri, 27 Jul 2012 17:00:48 +0800
Message-ID: <1343379650-2867-6-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 27 Jul 2012 09:01:59.0361 (UTC) FILETIME=[7AF43310:01CD6BD6]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When runtime resume a scsi device, if the device's driver has
implemented runtime resume callback, use that.

sr driver needs this to do different things for system resume and
runtime resume.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/scsi_pm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 83edb93..690136c 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -34,14 +34,19 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev)
+static int scsi_dev_type_resume(struct device *dev, bool runtime)
 {
 	struct device_driver *drv;
 	int err = 0;
+	int (*resume)(struct device *);
 
 	drv = dev->driver;
-	if (drv && drv->resume)
-		err = drv->resume(dev);
+	if (runtime && drv && drv->pm && drv->pm->runtime_resume)
+		resume = drv->pm->runtime_resume;
+	else
+		resume = drv ? drv->resume : NULL;
+	if (resume)
+		err = resume(dev);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
@@ -85,7 +90,7 @@ static int scsi_bus_resume_common(struct device *dev)
 	pm_runtime_get_sync(dev->parent);
 
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, false);
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -160,7 +165,7 @@ static int scsi_runtime_resume(struct device *dev)
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, true);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-- 
1.7.11.3


