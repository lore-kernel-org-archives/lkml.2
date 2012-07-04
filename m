Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2GDQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:25:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2GDQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923222"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/6] mei: introduce mei_data2slots wrapper
Date: Wed,  4 Jul 2012 19:24:52 +0300
Message-Id: <1341419094-4204-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
References: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mei_data2slots wrapper for sake of
readability. This wrapper close up the open code
for computing slots from a message length:
rond up dwords count from payload and header byte size

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interface.c |    2 +-
 drivers/misc/mei/interface.h |    6 ++++++
 drivers/misc/mei/interrupt.c |   33 +++++++++++----------------------
 3 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 88ada64..509c395 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -135,7 +135,7 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 	empty_slots = mei_hbuf_empty_slots(dev);
 	dev_dbg(&dev->pdev->dev, "empty slots = %hu.\n", empty_slots);
 
-	dw_cnt = (length + sizeof(*header) + 3) / 4;
+	dw_cnt = mei_data2slots(length);
 	if (empty_slots < 0 || dw_cnt > empty_slots)
 		return -EIO;
 
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index cd9b778..fb5c7db 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -50,6 +50,12 @@ static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
 	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
 }
 
+/* get slots (dwords) from a message length + header (bytes) */
+static inline unsigned char mei_data2slots(size_t length)
+{
+	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
+}
+
 int mei_count_full_read_slots(struct mei_device *dev);
 
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d0ccb66..8679f22 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -267,8 +267,7 @@ static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 			+ sizeof(struct hbm_flow_control))) {
 		return -EMSGSIZE;
 	}
-	*slots -= (sizeof(struct mei_msg_hdr) +
-				sizeof(struct hbm_flow_control) + 3) / 4;
+	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
 	if (mei_send_flow_control(dev, &dev->iamthif_cl)) {
 		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
 		return -EIO;
@@ -302,8 +301,7 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 {
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_disconnect_request))) {
-		*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_disconnect_request) + 3) / 4;
+		*slots -= mei_data2slots(sizeof(struct hbm_client_disconnect_request));
 
 		if (mei_disconnect(dev, cl)) {
 			cl->status = 0;
@@ -841,8 +839,8 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 		return -EBADMSG;
 	}
 
-	*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_flow_control) + 3) / 4;
+	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
+
 	if (mei_send_flow_control(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->information = 0;
@@ -874,8 +872,7 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_connect_request))) {
 		cl->state = MEI_FILE_CONNECTING;
-		*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_connect_request) + 3) / 4;
+		 *slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
 		if (mei_connect(dev, cl)) {
 			cl->status = -ENODEV;
 			cb_pos->information = 0;
@@ -931,8 +928,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 				cb_pos->information);
 		dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
 				mei_hdr->length);
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= mei_data2slots(mei_hdr->length);
 		if (mei_write_message(dev, mei_hdr,
 				(unsigned char *)
 				(cb_pos->request_buffer.data +
@@ -959,9 +955,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
 		mei_hdr->msg_complete = 0;
 		mei_hdr->reserved = 0;
-
-		(*slots) -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= mei_data2slots(mei_hdr->length);
 		if (mei_write_message(dev, mei_hdr,
 					(unsigned char *)
 					(cb_pos->request_buffer.data +
@@ -1020,8 +1014,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 		mei_hdr->msg_complete = 1;
 		mei_hdr->reserved = 0;
 
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= mei_data2slots(mei_hdr->length);
 
 		if (mei_write_message(dev, mei_hdr,
 					(dev->iamthif_msg_buf +
@@ -1055,8 +1048,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 		mei_hdr->msg_complete = 0;
 		mei_hdr->reserved = 0;
 
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= mei_data2slots(mei_hdr->length);
 
 		if (mei_write_message(dev, mei_hdr,
 					(dev->iamthif_msg_buf +
@@ -1266,12 +1258,9 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			dev->wd_pending = false;
 
 			if (dev->wd_timeout)
-				*slots -= (sizeof(struct mei_msg_hdr) +
-					 MEI_START_WD_DATA_SIZE + 3) / 4;
+				*slots -= mei_data2slots(MEI_START_WD_DATA_SIZE);
 			else
-				*slots -= (sizeof(struct mei_msg_hdr) +
-					 MEI_WD_PARAMS_SIZE + 3) / 4;
-
+				*slots -= mei_data2slots(MEI_START_WD_DATA_SIZE);
 		}
 	}
 	if (dev->stop)
-- 
1.7.4.4

