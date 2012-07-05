Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2GEGs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:48:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:20204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2GEGs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173570103"
Subject: [PATCH] [SCSI] scsi_pm: set device runtime state before parent
 suspended
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 05 Jul 2012 14:48:04 +0800
Message-ID: <1341470884.3484.12.camel@chief-river-32>
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
CC: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_pm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..d2a80de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -85,14 +85,14 @@ static int scsi_bus_resume_common(struct device *dev)
 		 */
 		pm_runtime_get_sync(dev->parent);
 		err = scsi_dev_type_resume(dev);
+		if (err == 0) {
+			pm_runtime_disable(dev);
+			pm_runtime_set_active(dev);
+			pm_runtime_enable(dev);
+		}
 		pm_runtime_put_sync(dev->parent);
 	}
 
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
 	return err;
 }
 
-- 
1.7.10



