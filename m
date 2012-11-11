Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2KKPiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab2KKPiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934052"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/7] mei: extract amthif specific code from mei_poll to mei_amthif_poll
Date: Sun, 11 Nov 2012 17:38:02 +0200
Message-Id: <1352648284-8838-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |   19 +++++++++++++++++++
 drivers/misc/mei/main.c    |   10 +---------
 drivers/misc/mei/mei_dev.h |    6 +++++-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 8f4373a..7416241 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -401,6 +401,25 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 	}
 }
 
+
+unsigned int mei_amthif_poll(struct mei_device *dev,
+		struct file *file, poll_table *wait)
+{
+	unsigned int mask = 0;
+	mutex_unlock(&dev->device_lock);
+	poll_wait(file, &dev->iamthif_cl.wait, wait);
+	mutex_lock(&dev->device_lock);
+	if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
+		dev->iamthif_file_object == file) {
+		mask |= (POLLIN | POLLRDNORM);
+		dev_dbg(&dev->pdev->dev, "run next amthi cb\n");
+		mei_amthif_run_next_cmd(dev);
+	}
+	return mask;
+}
+
+
+
 /**
  * mei_amthif_irq_process_completed - processes completed iamthif operation.
  *
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 43512e5..2cc1ebb 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -694,15 +694,7 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 
 
 	if (cl == &dev->iamthif_cl) {
-		mutex_unlock(&dev->device_lock);
-		poll_wait(file, &dev->iamthif_cl.wait, wait);
-		mutex_lock(&dev->device_lock);
-		if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
-			dev->iamthif_file_object == file) {
-			mask |= (POLLIN | POLLRDNORM);
-			dev_dbg(&dev->pdev->dev, "run next amthi cb\n");
-			mei_amthif_run_next_cmd(dev);
-		}
+		mask = mei_amthif_poll(dev, file, wait);
 		goto out;
 	}
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index bdad35e..dad85f3 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -19,6 +19,7 @@
 
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/poll.h>
 #include <linux/mei.h>
 #include "hw.h"
 
@@ -387,7 +388,10 @@ void mei_amthif_host_init(struct mei_device *dev);
 int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
 
 int mei_amthif_read(struct mei_device *dev, struct file *file,
-	      char __user *ubuf, size_t length, loff_t *offset);
+		char __user *ubuf, size_t length, loff_t *offset);
+
+unsigned int mei_amthif_poll(struct mei_device *dev,
+		struct file *file, poll_table *wait);
 
 int mei_amthif_release(struct mei_device *dev, struct file *file);
 
-- 
1.7.4.4

