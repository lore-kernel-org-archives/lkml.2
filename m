Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab2HPQk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:40:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:14514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2HPQkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:40:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="202837396"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/4] mei: wd: use watchdog_set/get_drvdata for passing mei_device
Date: Thu, 16 Aug 2012 19:39:44 +0300
Message-Id: <1345135184-23915-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
References: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use watchdog_set/get_drvdata for passing mei_device
to watchdog_ops handlers instead of using global mei_device

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

---
 drivers/misc/mei/wd.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 0824166..d96c537 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -194,7 +194,7 @@ static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 	int err = -ENODEV;
 	struct mei_device *dev;
 
-	dev = pci_get_drvdata(mei_device);
+	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
 		return -ENODEV;
 
@@ -231,8 +231,8 @@ end_unlock:
 static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 {
 	struct mei_device *dev;
-	dev = pci_get_drvdata(mei_device);
 
+	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
 		return -ENODEV;
 
@@ -254,8 +254,8 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 {
 	int ret = 0;
 	struct mei_device *dev;
-	dev = pci_get_drvdata(mei_device);
 
+	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
 		return -ENODEV;
 
@@ -309,8 +309,8 @@ end:
 static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int timeout)
 {
 	struct mei_device *dev;
-	dev = pci_get_drvdata(mei_device);
 
+	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
 		return -ENODEV;
 
@@ -355,25 +355,28 @@ static struct watchdog_device amt_wd_dev = {
 };
 
 
-void  mei_watchdog_register(struct mei_device *dev)
+void mei_watchdog_register(struct mei_device *dev)
 {
-	dev_dbg(&dev->pdev->dev, "dev->wd_timeout =%d.\n", dev->wd_timeout);
-
 	if (watchdog_register_device(&amt_wd_dev)) {
 		dev_err(&dev->pdev->dev,
 			"wd: unable to register watchdog device.\n");
 		dev->wd_interface_reg = false;
-	} else {
-		dev_dbg(&dev->pdev->dev,
-			"wd: successfully register watchdog interface.\n");
-		dev->wd_interface_reg = true;
+		return;
 	}
+
+	dev_dbg(&dev->pdev->dev,
+		"wd: successfully register watchdog interface.\n");
+	dev->wd_interface_reg = true;
+	watchdog_set_drvdata(&amt_wd_dev, dev);
 }
 
 void mei_watchdog_unregister(struct mei_device *dev)
 {
-	if (dev->wd_interface_reg)
-		watchdog_unregister_device(&amt_wd_dev);
+	if (!dev->wd_interface_reg)
+		return;
+
+	watchdog_set_drvdata(&amt_wd_dev, NULL);
+	watchdog_unregister_device(&amt_wd_dev);
 	dev->wd_interface_reg = false;
 }
 
-- 
1.7.4.4

