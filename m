Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1LVGvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:51:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:37668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1LVGvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:51:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="49654465"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v3 3/3] ata: add ata port hibernate callbacks
Date: Thu, 22 Dec 2011 14:50:49 +0800
Message-Id: <1324536649-5796-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 84aa741..8fbcad2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5281,12 +5281,24 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 #define to_ata_port(d) container_of(d, struct ata_port, tdev)
 
-static int ata_port_suspend_common(struct device *dev)
+static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
-	rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+	/*
+	 * On some hardware, device fails to respond after spun down
+	 * for suspend.  As the device won't be used before being
+	 * resumed, we don't need to touch the device.  Ask EH to skip
+	 * the usual stuff and proceed directly to suspend.
+	 *
+	 * http://thread.gmane.org/gmane.linux.ide/46764
+	 */
+	if (mesg.event == PM_EVENT_SUSPEND)
+		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
+
+	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, 1);
 	return rc;
 }
 
@@ -5295,7 +5307,23 @@ static int ata_port_suspend(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev);
+	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+}
+
+static int ata_port_do_freeze(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
+	return ata_port_suspend_common(dev, PMSG_FREEZE);
+}
+
+static int ata_port_poweroff(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
 }
 
 static int ata_port_resume_common(struct device *dev)
@@ -5330,8 +5358,12 @@ static int ata_port_runtime_idle(struct device *dev)
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
+	.freeze = ata_port_do_freeze,
+	.thaw = ata_port_resume,
+	.poweroff = ata_port_poweroff,
+	.restore = ata_port_resume,
 
-	.runtime_suspend = ata_port_suspend_common,
+	.runtime_suspend = ata_port_suspend,
 	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
-- 
1.7.2.5

