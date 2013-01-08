Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3AHVIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:63355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3AHVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604996"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 08/21] mei: move me client storage allocation to hbm.c
Date: Tue,  8 Jan 2013 23:07:19 +0200
Message-Id: <1357679252-12958-9-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename function to mei_me_cl_allocate to match the current
names convention: mei_hbm_me_cl_allocate

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c     |   39 ++++++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/init.c    |   39 ---------------------------------------
 drivers/misc/mei/mei_dev.h |    1 -
 3 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index f0c3fc4..fb9e63b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -24,6 +24,43 @@
 #include "hw-me.h"
 
 /**
+ * mei_hbm_me_cl_allocate - allocates storage for me clients
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
+static void mei_hbm_me_cl_allocate(struct mei_device *dev)
+{
+	struct mei_me_client *clients;
+	int b;
+
+	/* count how many ME clients we have */
+	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
+		dev->me_clients_num++;
+
+	if (dev->me_clients_num <= 0)
+		return;
+
+	kfree(dev->me_clients);
+	dev->me_clients = NULL;
+
+	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%zd.\n",
+		dev->me_clients_num * sizeof(struct mei_me_client));
+	/* allocate storage for ME clients representation */
+	clients = kcalloc(dev->me_clients_num,
+			sizeof(struct mei_me_client), GFP_KERNEL);
+	if (!clients) {
+		dev_err(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
+		dev->dev_state = MEI_DEV_RESETING;
+		mei_reset(dev, 1);
+		return;
+	}
+	dev->me_clients = clients;
+	return;
+}
+
+/**
  * mei_hbm_cl_hdr - construct client hbm header
  * @cl: - client
  * @hbm_cmd: host bus message command
@@ -593,7 +630,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 				dev->init_clients_timer = 0;
 				dev->me_client_presentation_num = 0;
 				dev->me_client_index = 0;
-				mei_allocate_me_clients_storage(dev);
+				mei_hbm_me_cl_allocate(dev);
 				dev->init_clients_state =
 					MEI_CLIENT_PROPERTIES_MESSAGE;
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 88407df..636639f 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -278,44 +278,5 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 }
 
 
-/**
- * allocate_me_clients_storage - allocates storage for me clients
- *
- * @dev: the device structure
- *
- * returns none.
- */
-void mei_allocate_me_clients_storage(struct mei_device *dev)
-{
-	struct mei_me_client *clients;
-	int b;
-
-	/* count how many ME clients we have */
-	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
-		dev->me_clients_num++;
-
-	if (dev->me_clients_num <= 0)
-		return ;
-
-
-	if (dev->me_clients != NULL) {
-		kfree(dev->me_clients);
-		dev->me_clients = NULL;
-	}
-	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%zd.\n",
-		dev->me_clients_num * sizeof(struct mei_me_client));
-	/* allocate storage for ME clients representation */
-	clients = kcalloc(dev->me_clients_num,
-			sizeof(struct mei_me_client), GFP_KERNEL);
-	if (!clients) {
-		dev_dbg(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
-		dev->dev_state = MEI_DEV_RESETING;
-		mei_reset(dev, 1);
-		return ;
-	}
-	dev->me_clients = clients;
-	return ;
-}
-
 
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 11ff875..d07d81f 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -328,7 +328,6 @@ void mei_reset(struct mei_device *dev, int interrupts);
 int mei_hw_init(struct mei_device *dev);
 int mei_task_initialize_clients(void *data);
 int mei_initialize_clients(struct mei_device *dev);
-void mei_allocate_me_clients_storage(struct mei_device *dev);
 
 
 
-- 
1.7.4.4

