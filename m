Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3AHVNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:13:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:26469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3AHVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604989"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 07/21] mei: drop read_pending member form struct mei_cl
Date: Tue,  8 Jan 2013 23:07:18 +0200
Message-Id: <1357679252-12958-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_pending never changes, it is a leftover from the old code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c  |    2 +-
 drivers/misc/mei/main.c    |    4 +---
 drivers/misc/mei/mei_dev.h |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e2e9cb7..231eda2 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -631,7 +631,7 @@ int mei_cl_read_start(struct mei_cl *cl)
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		return -ENODEV;
 
-	if (cl->read_pending || cl->read_cb) {
+	if (cl->read_cb) {
 		dev_dbg(&dev->pdev->dev, "read is pending.\n");
 		return -EBUSY;
 	}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index e31ade3..5c7c855 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -380,7 +380,6 @@ free:
 	mei_io_cb_free(cb);
 	cl->reading_state = MEI_IDLE;
 	cl->read_cb = NULL;
-	cl->read_pending = 0;
 out:
 	dev_dbg(&dev->pdev->dev, "end mei read rets= %d\n", rets);
 	mutex_unlock(&dev->device_lock);
@@ -462,9 +461,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			write_cb = NULL;
 			cl->reading_state = MEI_IDLE;
 			cl->read_cb = NULL;
-			cl->read_pending = 0;
 		}
-	} else if (cl->reading_state == MEI_IDLE && !cl->read_pending)
+	} else if (cl->reading_state == MEI_IDLE)
 		*offset = 0;
 
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 87b1f6a..11ff875 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -199,7 +199,6 @@ struct mei_cl {
 	wait_queue_head_t tx_wait;
 	wait_queue_head_t rx_wait;
 	wait_queue_head_t wait;
-	int read_pending;
 	int status;
 	/* ID of client connected */
 	u8 host_client_id;
-- 
1.7.4.4

