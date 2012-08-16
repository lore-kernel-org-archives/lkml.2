Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2HPQkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:40:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:14514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab2HPQkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="202837029"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/4] mei: wd: rename watchdog constants to be more descriptive
Date: Thu, 16 Aug 2012 19:39:42 +0300
Message-Id: <1345135184-23915-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
References: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. rename defines to more be descriptive
2. remove duplicated defines from interface.h
3. add common prefix MEI_

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interface.h |    8 --------
 drivers/misc/mei/interrupt.c |    4 ++--
 drivers/misc/mei/mei_dev.h   |   13 +++++++++----
 drivers/misc/mei/wd.c        |   24 ++++++++++++------------
 4 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index fb5c7db..c1988f5 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -23,14 +23,6 @@
 #include "mei_dev.h"
 
 
-#define AMT_WD_DEFAULT_TIMEOUT 120	/* seconds */
-#define AMT_WD_MIN_TIMEOUT 120	/* seconds */
-#define AMT_WD_MAX_TIMEOUT 65535	/* seconds */
-
-#define MEI_WATCHDOG_DATA_SIZE         16
-#define MEI_START_WD_DATA_SIZE         20
-#define MEI_WD_PARAMS_SIZE             4
-
 
 void mei_read_slots(struct mei_device *dev,
 		     unsigned char *buffer,
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7d9a912..0f25cee 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1251,9 +1251,9 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			dev->wd_pending = false;
 
 			if (dev->wd_timeout)
-				*slots -= mei_data2slots(MEI_START_WD_DATA_SIZE);
+				*slots -= mei_data2slots(MEI_WD_START_MSG_SIZE);
 			else
-				*slots -= mei_data2slots(MEI_WD_PARAMS_SIZE);
+				*slots -= mei_data2slots(MEI_WD_STOP_MSG_SIZE);
 		}
 	}
 	if (dev->stop)
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 35d0538..64a4f17 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -25,9 +25,14 @@
 /*
  * watch dog definition
  */
-#define MEI_WATCHDOG_DATA_SIZE         16
-#define MEI_START_WD_DATA_SIZE         20
-#define MEI_WD_PARAMS_SIZE             4
+#define MEI_WD_HDR_SIZE       4
+#define MEI_WD_STOP_MSG_SIZE  MEI_WD_HDR_SIZE
+#define MEI_WD_START_MSG_SIZE (MEI_WD_HDR_SIZE + 16)
+
+#define MEI_WD_DEFAULT_TIMEOUT   120  /* seconds */
+#define MEI_WD_MIN_TIMEOUT       120  /* seconds */
+#define MEI_WD_MAX_TIMEOUT     65535  /* seconds */
+
 #define MEI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
 
 #define MEI_RD_MSG_BUF_SIZE           (128 * sizeof(u32))
@@ -248,7 +253,7 @@ struct mei_device {
 	bool wd_stopped;
 	bool wd_bypass;	/* if false, don't refresh watchdog ME client */
 	u16 wd_timeout;	/* seconds ((wd_data[1] << 8) + wd_data[0]) */
-	unsigned char wd_data[MEI_START_WD_DATA_SIZE];
+	unsigned char wd_data[MEI_WD_START_MSG_SIZE];
 
 
 	struct file *iamthif_file_object;
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 94f2c0a..755a583 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -48,8 +48,8 @@ const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
 static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 {
 	dev_dbg(&dev->pdev->dev, "wd: set timeout=%d.\n", timeout);
-	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE);
-	memcpy(dev->wd_data + MEI_WD_PARAMS_SIZE, &timeout, sizeof(u16));
+	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE);
+	memcpy(dev->wd_data + MEI_WD_HDR_SIZE, &timeout, sizeof(u16));
 }
 
 /**
@@ -66,7 +66,7 @@ int mei_wd_host_init(struct mei_device *dev)
 
 	/* look for WD client and connect to it */
 	dev->wd_cl.state = MEI_FILE_DISCONNECTED;
-	dev->wd_timeout = AMT_WD_DEFAULT_TIMEOUT;
+	dev->wd_timeout = MEI_WD_DEFAULT_TIMEOUT;
 
 	/* find ME WD client */
 	mei_me_cl_update_filext(dev, &dev->wd_cl,
@@ -108,10 +108,10 @@ int mei_wd_send(struct mei_device *dev)
 	mei_hdr->msg_complete = 1;
 	mei_hdr->reserved = 0;
 
-	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE))
-		mei_hdr->length = MEI_START_WD_DATA_SIZE;
-	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE))
-		mei_hdr->length = MEI_WD_PARAMS_SIZE;
+	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE))
+		mei_hdr->length = MEI_WD_START_MSG_SIZE;
+	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_HDR_SIZE))
+		mei_hdr->length = MEI_WD_STOP_MSG_SIZE;
 	else
 		return -EINVAL;
 
@@ -138,7 +138,7 @@ int mei_wd_stop(struct mei_device *dev, bool preserve)
 		return 0;
 
 	dev->wd_timeout = 0;
-	memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE);
+	memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_STOP_MSG_SIZE);
 	dev->stop = true;
 
 	ret = mei_flow_ctrl_creds(dev, &dev->wd_cl);
@@ -315,7 +315,7 @@ static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int t
 		return -ENODEV;
 
 	/* Check Timeout value */
-	if (timeout < AMT_WD_MIN_TIMEOUT || timeout > AMT_WD_MAX_TIMEOUT)
+	if (timeout < MEI_WD_MIN_TIMEOUT || timeout > MEI_WD_MAX_TIMEOUT)
 		return -EINVAL;
 
 	mutex_lock(&dev->device_lock);
@@ -349,9 +349,9 @@ static const struct watchdog_info wd_info = {
 static struct watchdog_device amt_wd_dev = {
 		.info = &wd_info,
 		.ops = &wd_ops,
-		.timeout = AMT_WD_DEFAULT_TIMEOUT,
-		.min_timeout = AMT_WD_MIN_TIMEOUT,
-		.max_timeout = AMT_WD_MAX_TIMEOUT,
+		.timeout = MEI_WD_DEFAULT_TIMEOUT,
+		.min_timeout = MEI_WD_MIN_TIMEOUT,
+		.max_timeout = MEI_WD_MAX_TIMEOUT,
 };
 
 
-- 
1.7.4.4

