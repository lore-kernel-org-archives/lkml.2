Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2KRNNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2KRNNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943298"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 7/7] mei: Simplify the ME client enumeration code
Date: Sun, 18 Nov 2012 15:13:20 +0200
Message-Id: <1353244400-9619-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

After enumerating all ME clients we call the client init functions for
all matching UUIDs from a separate context.
This remove the hackish cascading client initialisation process that was
interleaving properties and connection command replies.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |   99 ++++++++++++++++++++++++++++--------------
 drivers/misc/mei/interrupt.c |   75 ++++++++++----------------------
 drivers/misc/mei/main.c      |    2 +
 drivers/misc/mei/mei_dev.h   |    5 ++-
 4 files changed, 95 insertions(+), 86 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 49600d6..a54cd55 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -423,54 +423,87 @@ void mei_allocate_me_clients_storage(struct mei_device *dev)
 	dev->me_clients = clients;
 	return ;
 }
-/**
- * host_client_properties - reads properties for client
- *
- * @dev: the device structure
- *
- * returns:
- * 	< 0 - Error.
- *  = 0 - no more clients.
- *  = 1 - still have clients to send properties request.
- */
-int mei_host_client_properties(struct mei_device *dev)
+
+void mei_host_client_init(struct work_struct *work)
+{
+	struct mei_device *dev = container_of(work,
+					      struct mei_device, init_work);
+	struct mei_client_properties *client_props;
+	int i;
+
+	mutex_lock(&dev->device_lock);
+
+	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+	dev->open_handle_count = 0;
+
+	/*
+	 * Reserving the first three client IDs
+	 * 0: Reserved for MEI Bus Message communications
+	 * 1: Reserved for Watchdog
+	 * 2: Reserved for AMTHI
+	 */
+	bitmap_set(dev->host_clients_map, 0, 3);
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		client_props = &dev->me_clients[i].props;
+
+		if (!uuid_le_cmp(client_props->protocol_name, mei_amthi_guid))
+			mei_amthif_host_init(dev);
+		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
+			mei_wd_host_init(dev);
+	}
+
+	dev->dev_state = MEI_DEV_ENABLED;
+
+	mutex_unlock(&dev->device_lock);
+}
+
+int mei_host_client_enumerate(struct mei_device *dev)
 {
 
 	struct mei_msg_hdr *mei_hdr;
 	struct hbm_props_request *prop_req;
 	const size_t len = sizeof(struct hbm_props_request);
+	unsigned long next_client_index;
+	u8 client_num;
 
-	int b;
-	u8 client_num = dev->me_client_presentation_num;
 
-	prop_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
+	client_num = dev->me_client_presentation_num;
 
-	b = dev->me_client_index;
-	b = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX, b);
-	if (b < MEI_CLIENTS_MAX) {
-		dev->me_clients[client_num].client_id = b;
-		dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
-		mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	next_client_index = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX,
+					  dev->me_client_index);
 
+	/* We got all client properties */
+	if (next_client_index == MEI_CLIENTS_MAX) {
+		schedule_work(&dev->init_work);
 
-		memset(prop_req, 0, sizeof(struct hbm_props_request));
+		return 0;
+	}
 
-		prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
-		prop_req->address = b;
+	dev->me_clients[client_num].client_id = next_client_index;
+	dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
+
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	prop_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
+
+	memset(prop_req, 0, sizeof(struct hbm_props_request));
 
-		if (mei_write_message(dev, mei_hdr,
-				(unsigned char *)prop_req, len)) {
-			dev->dev_state = MEI_DEV_RESETING;
-			dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
-			mei_reset(dev, 1);
-			return -EIO;
-		}
 
-		dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
-		dev->me_client_index = b;
-		return 1;
+	prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
+	prop_req->address = next_client_index;
+
+	if (mei_write_message(dev, mei_hdr, (unsigned char *) prop_req,
+			      mei_hdr->length)) {
+		dev->dev_state = MEI_DEV_RESETING;
+		dev_err(&dev->pdev->dev, "Properties request command failed\n");
+		mei_reset(dev, 1);
+
+		return -EIO;
 	}
 
+	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
+	dev->me_client_index = next_client_index;
+
 	return 0;
 }
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index e5aa0ed..04fa213 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -252,8 +252,6 @@ static void mei_client_connect_response(struct mei_device *dev,
 		dev_dbg(&dev->pdev->dev, "successfully connected to WD client.\n");
 		mei_watchdog_register(dev);
 
-		/* next step in the state maching */
-		mei_amthif_host_init(dev);
 		return;
 	}
 
@@ -470,6 +468,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 		struct mei_msg_hdr *mei_hdr)
 {
 	struct mei_bus_message *mei_msg;
+	struct mei_me_client *me_client;
 	struct hbm_host_version_response *version_res;
 	struct hbm_client_connect_response *connect_res;
 	struct hbm_client_connect_response *disconnect_res;
@@ -478,8 +477,6 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	struct hbm_props_response *props_res;
 	struct hbm_host_enum_response *enum_res;
 	struct hbm_host_stop_request *stop_req;
-	int res;
-
 
 	/* read the message to our buffer */
 	BUG_ON(mei_hdr->length >= sizeof(dev->rd_msg_buf));
@@ -547,64 +544,37 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 
 	case HOST_CLIENT_PROPERTIES_RES_CMD:
 		props_res = (struct hbm_props_response *)mei_msg;
+		me_client = &dev->me_clients[dev->me_client_presentation_num];
+
 		if (props_res->status || !dev->me_clients) {
 			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message wrong status.\n");
 			mei_reset(dev, 1);
 			return;
 		}
-		if (dev->me_clients[dev->me_client_presentation_num]
-					.client_id == props_res->address) {
 
-			dev->me_clients[dev->me_client_presentation_num].props
-						= props_res->client_properties;
+		if (me_client->client_id != props_res->address) {
+			dev_err(&dev->pdev->dev,
+				"Host client properties reply mismatch\n");
+			mei_reset(dev, 1);
 
-			if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
-			    dev->init_clients_state ==
-					MEI_CLIENT_PROPERTIES_MESSAGE) {
-				dev->me_client_index++;
-				dev->me_client_presentation_num++;
-
-				/** Send Client Properties request **/
-				res = mei_host_client_properties(dev);
-				if (res < 0) {
-					dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
-					return;
-				} else if (!res) {
-					/*
-					 * No more clients to send to.
-					 * Clear Map for indicating now ME clients
-					 * with associated host client
-					 */
-					bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
-					dev->open_handle_count = 0;
-
-					/*
-					 * Reserving the first three client IDs
-					 * Client Id 0 - Reserved for MEI Bus Message communications
-					 * Client Id 1 - Reserved for Watchdog
-					 * Client ID 2 - Reserved for AMTHI
-					 */
-					bitmap_set(dev->host_clients_map, 0, 3);
-					dev->dev_state = MEI_DEV_ENABLED;
-
-					/* if wd initialization fails, initialization the AMTHI client,
-					 * otherwise the AMTHI client will be initialized after the WD client connect response
-					 * will be received
-					 */
-					if (mei_wd_host_init(dev))
-						mei_amthif_host_init(dev);
-				}
+			return;
+		}
 
-			} else {
-				dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message");
-				mei_reset(dev, 1);
-				return;
-			}
-		} else {
-			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message for wrong client ID\n");
+		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
+		    dev->init_clients_state != MEI_CLIENT_PROPERTIES_MESSAGE) {
+			dev_err(&dev->pdev->dev,
+				"Unexpected client properties reply\n");
 			mei_reset(dev, 1);
+
 			return;
 		}
+
+		me_client->props = props_res->client_properties;
+		dev->me_client_index++;
+		dev->me_client_presentation_num++;
+
+		mei_host_client_enumerate(dev);
+
 		break;
 
 	case HOST_ENUM_RES_CMD:
@@ -618,7 +588,8 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 				mei_allocate_me_clients_storage(dev);
 				dev->init_clients_state =
 					MEI_CLIENT_PROPERTIES_MESSAGE;
-				mei_host_client_properties(dev);
+
+				mei_host_client_enumerate(dev);
 		} else {
 			dev_dbg(&dev->pdev->dev, "reset due to received host enumeration clients response bus message.\n");
 			mei_reset(dev, 1);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 251aaff..7c9c381 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -829,6 +829,8 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		goto disable_msi;
 	}
 	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
+	INIT_WORK(&dev->init_work, mei_host_client_init);
+
 	if (mei_hw_init(dev)) {
 		dev_err(&pdev->dev, "init hw failure.\n");
 		err = -ENODEV;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 17d00aa..25da045 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -287,6 +287,8 @@ struct mei_device {
 	bool iamthif_flow_control_pending;
 	bool iamthif_ioctl;
 	bool iamthif_canceled;
+
+	struct work_struct init_work;
 };
 
 static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
@@ -363,7 +365,8 @@ static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
  */
 void mei_host_start_message(struct mei_device *dev);
 void mei_host_enum_clients_message(struct mei_device *dev);
-int mei_host_client_properties(struct mei_device *dev);
+int mei_host_client_enumerate(struct mei_device *dev);
+void mei_host_client_init(struct work_struct *work);
 
 /*
  *  MEI interrupt functions prototype
-- 
1.7.4.4

