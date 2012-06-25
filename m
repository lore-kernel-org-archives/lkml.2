Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2FYUqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:46:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:63466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab2FYUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115896926"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: don't query HCSR for host buffer depth
Date: Mon, 25 Jun 2012 23:46:27 +0300
Message-Id: <1340657188-16953-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. We record host (write) buffer depth during reset
 so we don't need to query HCSR register later on.
 The host buffer depth doesn't change after the reset
2. Use mei_hbuf_max_data function to compute payload size in bytes

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |    3 +++
 drivers/misc/mei/interface.c |    7 +++----
 drivers/misc/mei/interface.h |    6 ++++++
 drivers/misc/mei/interrupt.c |    6 +++---
 drivers/misc/mei/iorw.c      |    8 ++------
 drivers/misc/mei/main.c      |    9 ++-------
 drivers/misc/mei/mei_dev.h   |    6 +++++-
 7 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index a7d0bb0..d39b277 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -162,6 +162,9 @@ int mei_hw_init(struct mei_device *dev)
 	if ((dev->host_hw_state & H_IS) == H_IS)
 		mei_reg_write(dev, H_CSR, dev->host_hw_state);
 
+	/* Doesn't change in runtime */
+	dev->hbuf_depth = (dev->host_hw_state & H_CBD) >> 24;
+
 	dev->recvd_msg = false;
 	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
 
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 6c05691..784a606 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -103,15 +103,14 @@ int mei_host_buffer_is_empty(struct mei_device *dev)
  */
 int mei_count_empty_write_slots(struct mei_device *dev)
 {
-	unsigned char buffer_depth, filled_slots, empty_slots;
+	unsigned char filled_slots, empty_slots;
 
 	dev->host_hw_state = mei_hcsr_read(dev);
-	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
 	filled_slots = _host_get_filled_slots(dev);
-	empty_slots = buffer_depth - filled_slots;
+	empty_slots = dev->hbuf_depth - filled_slots;
 
 	/* check for overflow */
-	if (filled_slots > buffer_depth)
+	if (filled_slots > dev->hbuf_depth)
 		return -EOVERFLOW;
 
 	return empty_slots;
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index ddff5d1..8723d88 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -49,6 +49,12 @@ int mei_count_empty_write_slots(struct mei_device *dev);
 
 int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
 
+static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
+{
+	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
+}
+
+
 int mei_wd_send(struct mei_device *dev);
 int mei_wd_stop(struct mei_device *dev, bool preserve);
 int mei_wd_host_init(struct mei_device *dev);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7ea0254..ebf97d3 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -951,7 +951,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 			list_move_tail(&cb_pos->cb_list,
 				&dev->write_waiting_list.mei_cb.cb_list);
 		}
-	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
+	} else if (*slots == dev->hbuf_depth) {
 		/* buffer is still empty */
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 		mei_hdr->host_addr = cl->host_client_id;
@@ -1046,8 +1046,8 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 				&dev->write_waiting_list.mei_cb.cb_list);
 
 		}
-	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
-			/* buffer is still empty */
+	} else if (*slots == dev->hbuf_depth) {
+		/* buffer is still empty */
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 		mei_hdr->host_addr = cl->host_client_id;
 		mei_hdr->me_addr = cl->me_client_id;
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index f9cced6..50f52e2 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -481,12 +481,8 @@ int amthi_write(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (ret && dev->mei_host_buffer_is_empty) {
 		ret = 0;
 		dev->mei_host_buffer_is_empty = false;
-		if (cb->request_buffer.size >
-			(((dev->host_hw_state & H_CBD) >> 24) * sizeof(u32))
-				-sizeof(struct mei_msg_hdr)) {
-			mei_hdr.length =
-			    (((dev->host_hw_state & H_CBD) >> 24) *
-			    sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		if (cb->request_buffer.size > mei_hbuf_max_data(dev)) {
+			mei_hdr.length = mei_hbuf_max_data(dev);
 			mei_hdr.msg_complete = 0;
 		} else {
 			mei_hdr.length = cb->request_buffer.size;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7de1389..1c1df04 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -714,13 +714,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (rets && dev->mei_host_buffer_is_empty) {
 		rets = 0;
 		dev->mei_host_buffer_is_empty = false;
-		if (length > ((((dev->host_hw_state & H_CBD) >> 24) *
-			sizeof(u32)) - sizeof(struct mei_msg_hdr))) {
-
-			mei_hdr.length =
-				(((dev->host_hw_state & H_CBD) >> 24) *
-				sizeof(u32)) -
-				sizeof(struct mei_msg_hdr);
+		if (length >  mei_hbuf_max_data(dev)) {
+			mei_hdr.length = mei_hbuf_max_data(dev);
 			mei_hdr.msg_complete = 0;
 		} else {
 			mei_hdr.length = length;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 4fe6533..d60250d 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -167,7 +167,10 @@ struct mei_io_list {
 	struct mei_cl_cb mei_cb;
 };
 
-/* MEI private device struct */
+/**
+ * struct mei_deive -  MEI private device struct
+ * @hbuf_depth - depth of host(write) buffer
+ */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
 	/*
@@ -205,6 +208,7 @@ struct mei_device {
 	 */
 	u32 host_hw_state;
 	u32 me_hw_state;
+	u8  hbuf_depth;
 	/*
 	 * waiting queue for receive message from FW
 	 */
-- 
1.7.4.4

