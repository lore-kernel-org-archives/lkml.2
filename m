Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab1IUNrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:47:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:59136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1IUNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="51478497"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 1/2] staging: mei: Organize the initialization state machine.
Date: Wed, 21 Sep 2011 16:45:30 +0300
Message-Id: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moving the final state, clearing of the client maps and
updating of mei state out from mei_host_client_properties function.

Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/init.c      |   30 ++++++++----------------------
 drivers/staging/mei/interrupt.c |   34 +++++++++++++++++++++++++++++++++-
 drivers/staging/mei/mei_dev.h   |    2 +-
 3 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index cb0ebbe..8bf3479 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -470,9 +470,12 @@ void mei_allocate_me_clients_storage(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns none.
+ * returns:
+ * 	< 0 - Error.
+ *  = 0 - no more clients.
+ *  = 1 - still have clients to send properties request.
  */
-void mei_host_client_properties(struct mei_device *dev)
+int mei_host_client_properties(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_header;
 	struct hbm_props_request *host_cli_req;
@@ -504,32 +507,15 @@ void mei_host_client_properties(struct mei_device *dev)
 			dev->mei_state = MEI_RESETING;
 			dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 			mei_reset(dev, 1);
-			return;
+			return -EIO;
 		}
 
 		dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
 		dev->me_client_index = b;
-		return;
+		return 1;
 	}
 
-
-	/*
-	 * Clear Map for indicating now ME clients
-	 * with associated host client
-	 */
-	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
-	dev->open_handle_count = 0;
-	bitmap_set(dev->host_clients_map, 0, 3);
-	dev->mei_state = MEI_ENABLED;
-
-	/* if wd initialization fails, initialization the AMTHI client,
-	 * otherwise the AMTHI client will be initialized after the WD client connect response
-	 * will be received
-	 */
-	if (mei_wd_host_init(dev))
-		mei_host_init_iamthif(dev);
-
-	return;
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index d1da3aa..882d106 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -653,6 +653,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	struct hbm_host_enum_response *enum_res;
 	struct hbm_client_disconnect_request *disconnect_req;
 	struct hbm_host_stop_request *host_stop_req;
+	int res;
 
 	unsigned char *buffer;
 
@@ -746,7 +747,38 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 					MEI_CLIENT_PROPERTIES_MESSAGE) {
 				dev->me_client_index++;
 				dev->me_client_presentation_num++;
-				mei_host_client_properties(dev);
+
+				/** Send Client Propeties request **/
+				res = mei_host_client_properties(dev);
+				if (res < 0) {
+					dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
+					return;
+				} else if (!res) {
+					/*
+					 * No more clients to send to.
+					 * Clear Map for indicating now ME clients
+					 * with associated host client
+					 */
+					bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+					dev->open_handle_count = 0;
+
+					/*
+					 * Reserving the first three client IDs
+					 * Client Id 0 - Reserved for MEI Bus Message communications
+					 * Client Id 1 - Reserved for Watchdog
+					 * Client ID 2 - Reserved for AMTHI
+					 */
+					bitmap_set(dev->host_clients_map, 0, 3);
+					dev->mei_state = MEI_ENABLED;
+
+					/* if wd initialization fails, initialization the AMTHI client,
+					 * otherwise the AMTHI client will be initialized after the WD client connect response
+					 * will be received
+					 */
+					if (mei_wd_host_init(dev))
+						mei_host_init_iamthif(dev);
+				}
+
 			} else {
 				dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message");
 				mei_reset(dev, 1);
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index 6487be1..af4b1af 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -329,7 +329,7 @@ static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
  */
 void mei_host_start_message(struct mei_device *dev);
 void mei_host_enum_clients_message(struct mei_device *dev);
-void mei_host_client_properties(struct mei_device *dev);
+int mei_host_client_properties(struct mei_device *dev);
 
 /*
  *  MEI interrupt functions prototype
-- 
1.7.4.1

