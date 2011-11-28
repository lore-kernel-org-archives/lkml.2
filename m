Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1K1BQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:16:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:18591 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab1K1BQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:16:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,580,1315206000"; 
   d="scan'208";a="41553732"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v4 3/6] [SCSI] check runtime PM status in system PM
Date: Mon, 28 Nov 2011 09:15:47 +0800
Message-Id: <1322442950-16268-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only high-level SCSI driver that currently implements runtime PM is
sd, and sd treats runtime suspend exactly the same as the SUSPEND and
HIBERNATE stages of system sleep, but not the same as the FREEZE stage.

Therefore, when entering the SUSPEND or HIBERNATE stages of system
sleep, we can skip the callback to the driver if the device is already
in runtime suspend.  When entering the FREEZE stage, however, we should
first issue a runtime resume.  The overhead of doing this is
negligible, because a suspended drive would be spun up during the THAW
stage of hibernation anyway.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/scsi/scsi_pm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d329f8b..a633076 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -49,8 +49,22 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically (but not system freeze).
+		 */
+		if (pm_runtime_suspended(dev)) {
+			if (msg.event == PM_EVENT_SUSPEND ||
+			    msg.event == PM_EVENT_HIBERNATE)
+				return 0;	/* already suspended */
+
+			/* wake up device so that FREEZE will succeed */
+			pm_runtime_resume(dev);
+		}
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }
 
-- 
1.7.2.5

