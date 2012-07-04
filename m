Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2GDQZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:25:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2GDQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:25:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923195"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/6] mei: remove write only wariable wd_due_counter
Date: Wed,  4 Jul 2012 19:24:50 +0300
Message-Id: <1341419094-4204-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
References: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |    1 -
 drivers/misc/mei/interrupt.c |   12 ++++--------
 drivers/misc/mei/mei_dev.h   |    1 -
 drivers/misc/mei/wd.c        |    3 ---
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index d39b277..e77f86e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -306,7 +306,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 				dev->iamthif_cl.host_client_id);
 
 		mei_reset_iamthif_params(dev);
-		dev->wd_due_counter = 0;
 		dev->extra_write_index = 0;
 	}
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 013641d..d0ccb66 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -575,10 +575,9 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 					disconnect_req->me_addr);
 			cl_pos->state = MEI_FILE_DISCONNECTED;
 			cl_pos->timer_count = 0;
-			if (cl_pos == &dev->wd_cl) {
-				dev->wd_due_counter = 0;
+			if (cl_pos == &dev->wd_cl)
 				dev->wd_pending = false;
-			} else if (cl_pos == &dev->iamthif_cl)
+			else if (cl_pos == &dev->iamthif_cl)
 				dev->iamthif_timer = 0;
 
 			/* prepare disconnect response */
@@ -1266,15 +1265,12 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 
 			dev->wd_pending = false;
 
-			if (dev->wd_timeout) {
+			if (dev->wd_timeout)
 				*slots -= (sizeof(struct mei_msg_hdr) +
 					 MEI_START_WD_DATA_SIZE + 3) / 4;
-				dev->wd_due_counter = 2;
-			} else {
+			else
 				*slots -= (sizeof(struct mei_msg_hdr) +
 					 MEI_WD_PARAMS_SIZE + 3) / 4;
-				dev->wd_due_counter = 0;
-			}
 
 		}
 	}
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 772f74d..d61c4dd 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -246,7 +246,6 @@ struct mei_device {
 	bool wd_stopped;
 	bool wd_bypass;	/* if false, don't refresh watchdog ME client */
 	u16 wd_timeout;	/* seconds ((wd_data[1] << 8) + wd_data[0]) */
-	u16 wd_due_counter;
 	unsigned char wd_data[MEI_START_WD_DATA_SIZE];
 
 
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index e2ec050..ae60c3f 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -137,7 +137,6 @@ int mei_wd_stop(struct mei_device *dev, bool preserve)
 		return 0;
 
 	dev->wd_timeout = 0;
-	dev->wd_due_counter = 0;
 	memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE);
 	dev->stop = true;
 
@@ -357,8 +356,6 @@ void  mei_watchdog_register(struct mei_device *dev)
 {
 	dev_dbg(&dev->pdev->dev, "dev->wd_timeout =%d.\n", dev->wd_timeout);
 
-	dev->wd_due_counter = !!dev->wd_timeout;
-
 	if (watchdog_register_device(&amt_wd_dev)) {
 		dev_err(&dev->pdev->dev,
 			"wd: unable to register watchdog device.\n");
-- 
1.7.4.4

