Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab2GFEHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:07:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:48061 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab2GFEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119392462"
Subject: [PATCH v2] [SCSI] scsi_pm: set device runtime state before parent
 suspended
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 06 Jul 2012 12:06:57 +0800
Message-ID: <1341547617.6401.1.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race in scsi_bus_resume_common when set device's runtime
state to active after pm_runtime_put_sync(dev->parent).

Parent device may have been suspended so pm_runtime_set_active(dev) will
fail with -EBUSY.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..dc0ad85 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -76,23 +76,24 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev)) {
-		/*
-		 * Parent device may have runtime suspended as soon as
-		 * it is woken up during the system resume.
-		 *
-		 * Resume it on behalf of child.
-		 */
-		pm_runtime_get_sync(dev->parent);
-		err = scsi_dev_type_resume(dev);
-		pm_runtime_put_sync(dev->parent);
-	}
+	/*
+	 * Parent device may have runtime suspended as soon as
+	 * it is woken up during the system resume.
+	 *
+	 * Resume it on behalf of child.
+	 */
+	pm_runtime_get_sync(dev->parent);
 
+	if (scsi_is_sdev_device(dev))
+		err = scsi_dev_type_resume(dev);
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
+
+	pm_runtime_put_sync(dev->parent);
+
 	return err;
 }
 
-- 
1.7.10



