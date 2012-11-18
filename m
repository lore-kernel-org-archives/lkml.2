Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2KRNNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2KRNNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943274"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/7] mei: streamline amthif write complete function
Date: Sun, 18 Nov 2012 15:13:17 +0200
Message-Id: <1353244400-9619-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function mei_amthif_irq_process_completed
to mei_amthif_irq_write_complete
Remove cl from the parameter list as it
can be extracted from cb block.
Extract the common flow from if statements
and document the logic properly

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   98 +++++++++++++++++++-----------------------
 drivers/misc/mei/interrupt.c |    4 +-
 drivers/misc/mei/mei_dev.h   |    6 +--
 3 files changed, 48 insertions(+), 60 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 095d059..18794ae 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -431,74 +431,64 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
  *
  * returns 0, OK; otherwise, error.
  */
-int mei_amthif_irq_process_completed(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list)
+int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr *mei_hdr;
+	struct mei_cl *cl = cb->cl;
+	size_t len = dev->iamthif_msg_buf_size - dev->iamthif_msg_buf_index;
+	size_t msg_slots = mei_data2slots(len);
 
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			dev->iamthif_msg_buf_size -
-			dev->iamthif_msg_buf_index)) {
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length = dev->iamthif_msg_buf_size -
-			dev->iamthif_msg_buf_index;
+	mei_hdr = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
+	mei_hdr->host_addr = cl->host_client_id;
+	mei_hdr->me_addr = cl->me_client_id;
+	mei_hdr->reserved = 0;
+
+	if (*slots >= msg_slots) {
+		mei_hdr->length = len;
 		mei_hdr->msg_complete = 1;
-		mei_hdr->reserved = 0;
+	/* Split the message only if we can write the whole host buffer */
+	} else if (*slots == dev->hbuf_depth) {
+		msg_slots = *slots;
+		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr->length = len;
+		mei_hdr->msg_complete = 0;
+	} else {
+		/* wait for next time the host buffer is empty */
+		return 0;
+	}
 
-		*slots -= mei_data2slots(mei_hdr->length);
+	dev_dbg(&dev->pdev->dev, "msg: len = %d complete = %d\n",
+			mei_hdr->length, mei_hdr->msg_complete);
 
-		if (mei_write_message(dev, mei_hdr,
-					(dev->iamthif_msg_buf +
-					dev->iamthif_msg_buf_index),
-					mei_hdr->length)) {
+	*slots -=  msg_slots;
+	if (mei_write_message(dev, mei_hdr,
+		dev->iamthif_msg_buf + dev->iamthif_msg_buf_index,
+		mei_hdr->length)) {
 			dev->iamthif_state = MEI_IAMTHIF_IDLE;
 			cl->status = -ENODEV;
-			list_del(&cb_pos->list);
+			list_del(&cb->list);
 			return -ENODEV;
-		} else {
-			if (mei_flow_ctrl_reduce(dev, cl))
-				return -ENODEV;
-			dev->iamthif_msg_buf_index += mei_hdr->length;
-			cb_pos->buf_idx = dev->iamthif_msg_buf_index;
-			cl->status = 0;
-			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev->iamthif_flow_control_pending = true;
-			/* save iamthif cb sent to amthi client */
-			dev->iamthif_current_cb = cb_pos;
-			list_move_tail(&cb_pos->list,
-					&dev->write_waiting_list.list);
+	}
 
-		}
-	} else if (*slots == dev->hbuf_depth) {
-		/* buffer is still empty */
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length =
-			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
-		mei_hdr->msg_complete = 0;
-		mei_hdr->reserved = 0;
+	if (mei_flow_ctrl_reduce(dev, cl))
+		return -ENODEV;
 
-		*slots -= mei_data2slots(mei_hdr->length);
+	dev->iamthif_msg_buf_index += mei_hdr->length;
+	cl->status = 0;
 
-		if (mei_write_message(dev, mei_hdr,
-					(dev->iamthif_msg_buf +
-					dev->iamthif_msg_buf_index),
-					mei_hdr->length)) {
-			cl->status = -ENODEV;
-			list_del(&cb_pos->list);
-		} else {
-			dev->iamthif_msg_buf_index += mei_hdr->length;
-		}
-		return -EMSGSIZE;
-	} else {
-		return -EBADMSG;
+	if (mei_hdr->msg_complete) {
+		dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+		dev->iamthif_flow_control_pending = true;
+
+		/* save iamthif cb sent to amthi client */
+		cb->buf_idx = dev->iamthif_msg_buf_index;
+		dev->iamthif_current_cb = cb;
+
+		list_move_tail(&cb->list, &dev->write_waiting_list.list);
 	}
 
+
 	return 0;
 }
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 85e2722..d30db38 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1046,8 +1046,8 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 					cl->host_client_id);
 				continue;
 			}
-			ret = mei_amthif_irq_process_completed(dev, slots, pos,
-								cl, cmpl_list);
+			ret = mei_amthif_irq_write_complete(dev, slots,
+							pos, cmpl_list);
 			if (ret)
 				return ret;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 2a38e95..17d00aa 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -407,10 +407,8 @@ void mei_amthif_run_next_cmd(struct mei_device *dev);
 int mei_amthif_read_message(struct mei_cl_cb *complete_list,
 		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
 
-int mei_amthif_irq_process_completed(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list);
+int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
 
 void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
 int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
-- 
1.7.4.4

