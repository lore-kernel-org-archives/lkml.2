Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2KRNNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2KRNNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943266"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/7] mei: streamline write complete flow function
Date: Sun, 18 Nov 2012 15:13:16 +0200
Message-Id: <1353244400-9619-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function  _mei_irq_thread_cmpl to
mei_irq_thread_write_complete to make clear it deals
with writing. Remove cl from the parameter list as it
can be extracted from cb block.
Extract the common flow from if statements and document
the logic properly

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |  113 ++++++++++++++++--------------------------
 1 files changed, 43 insertions(+), 70 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 9224646..85e2722 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -734,90 +734,63 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 }
 
 /**
- * _mei_irq_thread_cmpl - processes completed and no-iamthif operation.
+ * mei_irq_thread_write_complete - write messages to device.
  *
  * @dev: the device structure.
  * @slots: free slots.
- * @cb_pos: callback block.
- * @cl: private data of the file object.
+ * @cb: callback block.
  * @cmpl_list: complete list.
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list)
+static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr *mei_hdr;
+	struct mei_cl *cl = cb->cl;
+	size_t len = cb->request_buffer.size - cb->buf_idx;
+	size_t msg_slots = mei_data2slots(len);
+
+	mei_hdr = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
+	mei_hdr->host_addr = cl->host_client_id;
+	mei_hdr->me_addr = cl->me_client_id;
+	mei_hdr->reserved = 0;
 
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			(cb_pos->request_buffer.size - cb_pos->buf_idx))) {
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length = cb_pos->request_buffer.size - cb_pos->buf_idx;
+	if (*slots >= msg_slots) {
+		mei_hdr->length = len;
 		mei_hdr->msg_complete = 1;
-		mei_hdr->reserved = 0;
-		dev_dbg(&dev->pdev->dev, "cb_pos->request_buffer.size =%d"
-			"mei_hdr->msg_complete = %d\n",
-				cb_pos->request_buffer.size,
-				mei_hdr->msg_complete);
-		dev_dbg(&dev->pdev->dev, "cb_pos->buf_idx  =%lu\n",
-				cb_pos->buf_idx);
-		dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
-				mei_hdr->length);
-		*slots -= mei_data2slots(mei_hdr->length);
-		if (mei_write_message(dev, mei_hdr,
-				(unsigned char *)
-				(cb_pos->request_buffer.data +
-				cb_pos->buf_idx),
-				mei_hdr->length)) {
-			cl->status = -ENODEV;
-			list_move_tail(&cb_pos->list, &cmpl_list->list);
-			return -ENODEV;
-		} else {
-			if (mei_flow_ctrl_reduce(dev, cl))
-				return -ENODEV;
-			cl->status = 0;
-			cb_pos->buf_idx += mei_hdr->length;
-			list_move_tail(&cb_pos->list, &dev->write_waiting_list.list);
-		}
+	/* Split the message only if we can write the whole host buffer */
 	} else if (*slots == dev->hbuf_depth) {
-		/* buffer is still empty */
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length =
-			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		msg_slots = *slots;
+		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr->length = len;
 		mei_hdr->msg_complete = 0;
-		mei_hdr->reserved = 0;
-		*slots -= mei_data2slots(mei_hdr->length);
-		if (mei_write_message(dev, mei_hdr,
-					(unsigned char *)
-					(cb_pos->request_buffer.data +
-					cb_pos->buf_idx),
-					mei_hdr->length)) {
-			cl->status = -ENODEV;
-			list_move_tail(&cb_pos->list, &cmpl_list->list);
-			return -ENODEV;
-		} else {
-			cb_pos->buf_idx += mei_hdr->length;
-			dev_dbg(&dev->pdev->dev,
-					"cb_pos->request_buffer.size =%d"
-					" mei_hdr->msg_complete = %d\n",
-					cb_pos->request_buffer.size,
-					mei_hdr->msg_complete);
-			dev_dbg(&dev->pdev->dev, "cb_pos->buf_idx  =%lu\n",
-					cb_pos->buf_idx);
-			dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
-					mei_hdr->length);
-		}
-		return -EMSGSIZE;
 	} else {
-		return -EBADMSG;
+		/* wait for next time the host buffer is empty */
+		return 0;
 	}
 
+	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
+			cb->request_buffer.size, cb->buf_idx);
+	dev_dbg(&dev->pdev->dev, "msg: len = %d complete = %d\n",
+			mei_hdr->length, mei_hdr->msg_complete);
+
+	*slots -=  msg_slots;
+	if (mei_write_message(dev, mei_hdr,
+		cb->request_buffer.data + cb->buf_idx, len)) {
+		cl->status = -ENODEV;
+		list_move_tail(&cb->list, &cmpl_list->list);
+		return -ENODEV;
+	}
+
+	if (mei_flow_ctrl_reduce(dev, cl))
+		return -ENODEV;
+
+	cl->status = 0;
+	cb->buf_idx += mei_hdr->length;
+	if (mei_hdr->msg_complete)
+		list_move_tail(&cb->list, &dev->write_waiting_list.list);
+
 	return 0;
 }
 
@@ -1059,8 +1032,8 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl(dev, slots, pos,
-						cl, cmpl_list);
+			ret = mei_irq_thread_write_complete(dev, slots, pos,
+						cmpl_list);
 			if (ret)
 				return ret;
 
-- 
1.7.4.4

