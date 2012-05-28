Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2E1FKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 01:10:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:32734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2E1FJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 01:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145291458"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v4 10/13] [SCSI] pm: resume device if suspend failed
Date: Mon, 28 May 2012 13:08:37 +0800
Message-Id: <1338181720-4149-11-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

V2: use scsi_device instead of device in scsi_device_resume

V1:
For scsi devices which use scsi bus runtime callback, runtime suspend
will call scsi_dev_type_suspend, and if the drv->suspend failed, the
device will still be in active state. But since scsi_device_quiesce is
called, the device will not be able to respond any more commands.
So add a check here to see if err occured, if so, bring the device back
to normal state with scsi_device_resume.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/scsi/scsi_pm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index c467064..a06dd56 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -24,8 +24,11 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
 		drv = dev->driver;
-		if (drv && drv->suspend)
+		if (drv && drv->suspend) {
 			err = drv->suspend(dev, msg);
+			if (err)
+				scsi_device_resume(to_scsi_device(dev));
+		}
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
 	return err;
-- 
1.7.2.5

