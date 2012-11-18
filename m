Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KRNOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:14:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2KRNNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943284"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/7] mei: don't mix read and write slots
Date: Sun, 18 Nov 2012 15:13:18 +0200
Message-Id: <1353244400-9619-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
References: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not pass read slots pointer into function
mei_irq_thread_write_handler, the write
slots management is handled internally in the write
handler

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d30db38..cccb63a 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -901,27 +901,27 @@ end:
  * mei_irq_thread_write_handler - bottom half write routine after
  * ISR to handle the write processing.
  *
- * @cmpl_list: An instance of our list structure
  * @dev: the device structure
- * @slots: slots to write.
+ * @cmpl_list: An instance of our list structure
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
-		struct mei_device *dev, s32 *slots)
+static int mei_irq_thread_write_handler(struct mei_device *dev,
+				struct mei_cl_cb *cmpl_list)
 {
 
 	struct mei_cl *cl;
 	struct mei_cl_cb *pos = NULL, *next = NULL;
 	struct mei_cl_cb *list;
+	s32 slots;
 	int ret;
 
 	if (!mei_hbuf_is_empty(dev)) {
 		dev_dbg(&dev->pdev->dev, "host buffer is not empty.\n");
 		return 0;
 	}
-	*slots = mei_hbuf_empty_slots(dev);
-	if (*slots <= 0)
+	slots = mei_hbuf_empty_slots(dev);
+	if (slots <= 0)
 		return -EMSGSIZE;
 
 	/* complete all waiting for write CB */
@@ -945,7 +945,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 		if (cl == &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
 			if (dev->iamthif_flow_control_pending) {
-				ret = mei_amthif_irq_read(dev, slots);
+				ret = mei_amthif_irq_read(dev, &slots);
 				if (ret)
 					return ret;
 			}
@@ -960,7 +960,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 	if (dev->wr_ext_msg.hdr.length) {
 		mei_write_message(dev, &dev->wr_ext_msg.hdr,
 			dev->wr_ext_msg.data, dev->wr_ext_msg.hdr.length);
-		*slots -= mei_data2slots(dev->wr_ext_msg.hdr.length);
+		slots -= mei_data2slots(dev->wr_ext_msg.hdr.length);
 		dev->wr_ext_msg.hdr.length = 0;
 	}
 	if (dev->dev_state == MEI_DEV_ENABLED) {
@@ -974,9 +974,9 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 			dev->wd_pending = false;
 
 			if (dev->wd_state == MEI_WD_RUNNING)
-				*slots -= mei_data2slots(MEI_WD_START_MSG_SIZE);
+				slots -= mei_data2slots(MEI_WD_START_MSG_SIZE);
 			else
-				*slots -= mei_data2slots(MEI_WD_STOP_MSG_SIZE);
+				slots -= mei_data2slots(MEI_WD_STOP_MSG_SIZE);
 		}
 	}
 
@@ -991,14 +991,16 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 		switch (pos->fop_type) {
 		case MEI_FOP_CLOSE:
 			/* send disconnect message */
-			ret = _mei_irq_thread_close(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_close(dev, &slots, pos,
+						cl, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
 		case MEI_FOP_READ:
 			/* send flow control message */
-			ret = _mei_irq_thread_read(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_read(dev, &slots, pos,
+						cl, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -1007,7 +1009,8 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 			/* connect message */
 			if (mei_other_client_is_connecting(dev, cl))
 				continue;
-			ret = _mei_irq_thread_ioctl(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_ioctl(dev, &slots, pos,
+						cl, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -1032,7 +1035,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 					cl->host_client_id);
 				continue;
 			}
-			ret = mei_irq_thread_write_complete(dev, slots, pos,
+			ret = mei_irq_thread_write_complete(dev, &slots, pos,
 						cmpl_list);
 			if (ret)
 				return ret;
@@ -1046,7 +1049,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 					cl->host_client_id);
 				continue;
 			}
-			ret = mei_amthif_irq_write_complete(dev, slots,
+			ret = mei_amthif_irq_write_complete(dev, &slots,
 							pos, cmpl_list);
 			if (ret)
 				return ret;
@@ -1238,7 +1241,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 		if (rets)
 			goto end;
 	}
-	rets = mei_irq_thread_write_handler(&complete_list, dev, &slots);
+	rets = mei_irq_thread_write_handler(dev, &complete_list);
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
 	dev->host_hw_state = mei_hcsr_read(dev);
-- 
1.7.4.4

