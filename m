Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1FMNjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:39:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:30869 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1FMNjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:39:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,358,1304319600"; 
   d="scan'208";a="15620840"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@suse.de, a.miskiewicz@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [staging] staging/mei: fix suspend failure
Date: Mon, 13 Jun 2011 16:39:31 +0300
Message-Id: <1307972371-14815-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_event_interruptible_timeout return value was wrongly used.
The remaining timeout was used as the error code.
This fix translated wait_event_interruptible_timeout return value
into error code that can be propagated.

[10291.674121] pci_pm_suspend(): mei_pci_suspend+0x0/0x8b [mei] returns 2500
It's thinkpad t400 with
00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series Chipset MEI Controller [8086:2a44] (rev 07)

Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/init.c |    2 +-
 drivers/staging/mei/wd.c   |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index eb70e70..0fa8216 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -185,7 +185,7 @@ int mei_hw_init(struct mei_device *dev)
 		mutex_lock(&dev->device_lock);
 	}
 
-	if (!err && !dev->recvd_msg) {
+	if (err <= 0 && !dev->recvd_msg) {
 		dev->mei_state = MEI_DISABLED;
 		dev_dbg(&dev->pdev->dev,
 			"wait_event_interruptible_timeout failed"
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 18516a8..42f04ef 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -169,10 +169,15 @@ int mei_wd_stop(struct mei_device *dev, bool preserve)
 	ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
 					dev->wd_stopped, 10 * HZ);
 	mutex_lock(&dev->device_lock);
-	if (!dev->wd_stopped)
-		dev_dbg(&dev->pdev->dev, "stop wd failed to complete.\n");
-	else
-		dev_dbg(&dev->pdev->dev, "stop wd complete.\n");
+	if (dev->wd_stopped) {
+		dev_dbg(&dev->pdev->dev, "stop wd complete ret=%d.\n", ret);
+		ret = 0;
+	} else {
+		if (!ret)
+			ret = -ETIMEDOUT;
+		dev_warn(&dev->pdev->dev,
+			"stop wd failed to complete ret=%d.\n", ret);
+	}
 
 	if (preserve)
 		dev->wd_timeout = wd_timeout;
-- 
1.7.4.4

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

