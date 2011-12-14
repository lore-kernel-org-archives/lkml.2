Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1LNDSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:18:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:53347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab1LNDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:18:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86301875"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 3/3] ata: update ata port's runtime status during system resume
Date: Wed, 14 Dec 2011 11:18:01 +0800
Message-Id: <1323832681-7177-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ata port is brought back to full power state during system resume.
So its runtime PM status will have to be updated to reflect
the actual post-system sleep status.

This also fixes below warning during system suspend/resume.

WARNING: at /work/linux/drivers/ata/libata-eh.c:4034
ata_scsi_port_error_handler+0x89/0x557()

4034         WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 15a3d4d..8996758 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
 	return ata_port_suspend_common(dev);
 }
 
-static int ata_port_resume(struct device *dev)
+static int ata_port_resume_common(struct device *dev)
 {
 	struct ata_port *ap = to_ata_port(dev);
 	int rc;
@@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
+}
+
 static int ata_port_runtime_idle(struct device *dev)
 {
 	return pm_runtime_suspend(dev);
@@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.resume = ata_port_resume,
 
 	.runtime_suspend = ata_port_suspend_common,
-	.runtime_resume = ata_port_resume,
+	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
 
-- 
1.7.2.5

