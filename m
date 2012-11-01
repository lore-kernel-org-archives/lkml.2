Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077Ab2KATR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:17:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:38876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935144Ab2KATRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495312"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/6] mei: use internal watchdog device registration tracking
Date: Thu,  1 Nov 2012 21:17:17 +0200
Message-Id: <1351797438-26345-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
References: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove bool wd_interface_reg as watchdog device already
keeps track of its registration

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    |    2 --
 drivers/misc/mei/mei_dev.h |    1 -
 drivers/misc/mei/wd.c      |    5 +----
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4a8eb92..8c3c268 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -111,8 +111,6 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
-	dev->wd_interface_reg = false;
-
 
 	mei_io_list_init(&dev->read_list);
 	mei_io_list_init(&dev->write_list);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 57a5a4e..8b96d99 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -249,7 +249,6 @@ struct mei_device {
 
 	struct mei_cl wd_cl;
 	enum mei_wd_states wd_state;
-	bool wd_interface_reg;
 	bool wd_pending;
 	u16 wd_timeout;
 	unsigned char wd_data[MEI_WD_START_MSG_SIZE];
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 8edb054..4fc2b3d 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -360,23 +360,20 @@ void mei_watchdog_register(struct mei_device *dev)
 	if (watchdog_register_device(&amt_wd_dev)) {
 		dev_err(&dev->pdev->dev,
 			"wd: unable to register watchdog device.\n");
-		dev->wd_interface_reg = false;
 		return;
 	}
 
 	dev_dbg(&dev->pdev->dev,
 		"wd: successfully register watchdog interface.\n");
-	dev->wd_interface_reg = true;
 	watchdog_set_drvdata(&amt_wd_dev, dev);
 }
 
 void mei_watchdog_unregister(struct mei_device *dev)
 {
-	if (!dev->wd_interface_reg)
+	if (test_bit(WDOG_UNREGISTERED, &amt_wd_dev.status))
 		return;
 
 	watchdog_set_drvdata(&amt_wd_dev, NULL);
 	watchdog_unregister_device(&amt_wd_dev);
-	dev->wd_interface_reg = false;
 }
 
-- 
1.7.4.4

