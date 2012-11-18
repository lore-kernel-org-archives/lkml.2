Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2KRNNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2KRNNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943259"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/7] mei: use structured buffer for extra write buffer
Date: Sun, 18 Nov 2012 15:13:15 +0200
Message-Id: <1353244400-9619-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure of the message is static so we don't have
to use and cast the buffer. We can also drop extra_write_index
variable as this information can be extracted directly
from the message header

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |    2 +-
 drivers/misc/mei/interrupt.c |   36 ++++++++++++++----------------------
 drivers/misc/mei/mei_dev.h   |   11 +++++++----
 3 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 02784af..49600d6 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -288,7 +288,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		mei_me_cl_unlink(dev, &dev->iamthif_cl);
 
 		mei_amthif_reset_params(dev);
-		dev->extra_write_index = 0;
+		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 	}
 
 	dev->me_clients_num = 0;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 14becc0..9224646 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -446,15 +446,14 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 				dev->iamthif_timer = 0;
 
 			/* prepare disconnect response */
-			(void)mei_hbm_hdr(&dev->ext_msg_buf[0], len);
+			(void)mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
 			disconnect_res =
 				(struct hbm_client_connect_response *)
-				&dev->ext_msg_buf[1];
+				&dev->wr_ext_msg.data;
 			disconnect_res->hbm_cmd = CLIENT_DISCONNECT_RES_CMD;
 			disconnect_res->host_addr = pos->host_client_id;
 			disconnect_res->me_addr = pos->me_client_id;
 			disconnect_res->status = 0;
-			dev->extra_write_index = 2;
 			break;
 		}
 	}
@@ -643,16 +642,13 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	{
 		/* prepare stop request: sent in next interrupt event */
 
-		u32 *buf = dev->ext_msg_buf;
 		const size_t len = sizeof(struct hbm_host_stop_request);
 
-		mei_hdr = mei_hbm_hdr(&buf[0], len);
-		stop_req = (struct hbm_host_stop_request *)&buf[1];
+		mei_hdr = mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
+		stop_req = (struct hbm_host_stop_request *)&dev->wr_ext_msg.data;
 		memset(stop_req, 0, len);
 		stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
 		stop_req->reason = DRIVER_STOP_REQUEST;
-
-		dev->extra_write_index = 2;
 		break;
 	}
 	default:
@@ -988,15 +984,11 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 		wake_up_interruptible(&dev->wait_stop_wd);
 	}
 
-	if (dev->extra_write_index) {
-		dev_dbg(&dev->pdev->dev, "extra_write_index =%d.\n",
-				dev->extra_write_index);
-		mei_write_message(dev,
-				(struct mei_msg_hdr *) &dev->ext_msg_buf[0],
-				(unsigned char *) &dev->ext_msg_buf[1],
-				(dev->extra_write_index - 1) * sizeof(u32));
-		*slots -= dev->extra_write_index;
-		dev->extra_write_index = 0;
+	if (dev->wr_ext_msg.hdr.length) {
+		mei_write_message(dev, &dev->wr_ext_msg.hdr,
+			dev->wr_ext_msg.data, dev->wr_ext_msg.hdr.length);
+		*slots -= mei_data2slots(dev->wr_ext_msg.hdr.length);
+		dev->wr_ext_msg.hdr.length = 0;
 	}
 	if (dev->dev_state == MEI_DEV_ENABLED) {
 		if (dev->wd_pending &&
@@ -1263,11 +1255,11 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	}
 	/* check slots available for reading */
 	slots = mei_count_full_read_slots(dev);
-	dev_dbg(&dev->pdev->dev, "slots =%08x  extra_write_index =%08x.\n",
-		slots, dev->extra_write_index);
-	while (slots > 0 && !dev->extra_write_index) {
-		dev_dbg(&dev->pdev->dev, "slots =%08x  extra_write_index =%08x.\n",
-				slots, dev->extra_write_index);
+	while (slots > 0) {
+		/* we have urgent data to send so break the read */
+		if (dev->wr_ext_msg.hdr.length)
+			break;
+		dev_dbg(&dev->pdev->dev, "slots =%08x\n", slots);
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_handler.\n");
 		rets = mei_irq_thread_read_handler(&complete_list, dev, &slots);
 		if (rets)
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index e511b84..2a38e95 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -192,8 +192,9 @@ struct mei_cl {
 };
 
 /**
- * struct mei_deive -  MEI private device struct
+ * struct mei_device -  MEI private device struct
  * @hbuf_depth - depth of host(write) buffer
+ * @wr_ext_msg - buffer for hbm control responses (set in read cycle)
  */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
@@ -244,11 +245,13 @@ struct mei_device {
 	u16 init_clients_timer;
 	bool need_reset;
 
-	u32 extra_write_index;
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
-	u32 wr_msg_buf[128];	/* used for control messages */
-	u32 ext_msg_buf[8];	/* for control responses */
 	u32 rd_msg_hdr;
+	u32 wr_msg_buf[128];	/* used for control messages */
+	struct {
+		struct mei_msg_hdr hdr;
+		unsigned char data[4];	/* All HBM messages are 4 bytes */
+	} wr_ext_msg;		/* for control responses */
 
 	struct hbm_version version;
 
-- 
1.7.4.4

