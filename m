Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2FYUqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:46:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:63466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2FYUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115896943"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: revamp host buffer interface function
Date: Mon, 25 Jun 2012 23:46:28 +0300
Message-Id: <1340657188-16953-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1340657188-16953-1-git-send-email-tomas.winkler@intel.com>
References: <1340657188-16953-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Use unified _hbuf_ prefix for host/write buffer functions.
2. Cleanup the code w/o functional changes.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interface.c |   31 ++++++++++++-------------------
 drivers/misc/mei/interface.h |   14 ++++++++------
 drivers/misc/mei/interrupt.c |    8 ++++----
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 784a606..88ada64 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -58,16 +58,18 @@ void mei_disable_interrupts(struct mei_device *dev)
 }
 
 /**
- * _host_get_filled_slots - gets number of device filled buffer slots
+ * mei_hbuf_filled_slots - gets number of device filled buffer slots
  *
  * @device: the device structure
  *
  * returns number of filled slots
  */
-static unsigned char _host_get_filled_slots(const struct mei_device *dev)
+static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
 {
 	char read_ptr, write_ptr;
 
+	dev->host_hw_state = mei_hcsr_read(dev);
+
 	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
 	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
 
@@ -75,38 +77,29 @@ static unsigned char _host_get_filled_slots(const struct mei_device *dev)
 }
 
 /**
- * mei_host_buffer_is_empty - checks if host buffer is empty.
+ * mei_hbuf_is_empty - checks if host buffer is empty.
  *
  * @dev: the device structure
  *
- * returns 1 if empty, 0 - otherwise.
+ * returns true if empty, false - otherwise.
  */
-int mei_host_buffer_is_empty(struct mei_device *dev)
+bool mei_hbuf_is_empty(struct mei_device *dev)
 {
-	unsigned char filled_slots;
-
-	dev->host_hw_state = mei_hcsr_read(dev);
-	filled_slots = _host_get_filled_slots(dev);
-
-	if (filled_slots == 0)
-		return 1;
-
-	return 0;
+	return mei_hbuf_filled_slots(dev) == 0;
 }
 
 /**
- * mei_count_empty_write_slots - counts write empty slots.
+ * mei_hbuf_empty_slots - counts write empty slots.
  *
  * @dev: the device structure
  *
  * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise empty slots count
  */
-int mei_count_empty_write_slots(struct mei_device *dev)
+int mei_hbuf_empty_slots(struct mei_device *dev)
 {
 	unsigned char filled_slots, empty_slots;
 
-	dev->host_hw_state = mei_hcsr_read(dev);
-	filled_slots = _host_get_filled_slots(dev);
+	filled_slots = mei_hbuf_filled_slots(dev);
 	empty_slots = dev->hbuf_depth - filled_slots;
 
 	/* check for overflow */
@@ -139,7 +132,7 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 			"mei_write_message header=%08x.\n",
 			*((u32 *) header));
 
-	empty_slots = mei_count_empty_write_slots(dev);
+	empty_slots = mei_hbuf_empty_slots(dev);
 	dev_dbg(&dev->pdev->dev, "empty slots = %hu.\n", empty_slots);
 
 	dw_cnt = (length + sizeof(*header) + 3) / 4;
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index 8723d88..cd9b778 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -41,19 +41,21 @@ int mei_write_message(struct mei_device *dev,
 			     unsigned char *write_buffer,
 			     unsigned long write_length);
 
-int mei_host_buffer_is_empty(struct mei_device *dev);
+bool mei_hbuf_is_empty(struct mei_device *dev);
 
-int mei_count_full_read_slots(struct mei_device *dev);
-
-int mei_count_empty_write_slots(struct mei_device *dev);
-
-int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbuf_empty_slots(struct mei_device *dev);
 
 static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
 {
 	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
 }
 
+int mei_count_full_read_slots(struct mei_device *dev);
+
+
+int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
+
+
 
 int mei_wd_send(struct mei_device *dev);
 int mei_wd_stop(struct mei_device *dev, bool preserve);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index ebf97d3..013641d 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -280,7 +280,7 @@ static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 	dev->iamthif_msg_buf_index = 0;
 	dev->iamthif_msg_buf_size = 0;
 	dev->iamthif_stall_timer = IAMTHIF_STALL_TIMER;
-	dev->mei_host_buffer_is_empty = mei_host_buffer_is_empty(dev);
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
 	return 0;
 }
 
@@ -1199,11 +1199,11 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	struct mei_io_list *list;
 	int ret;
 
-	if (!mei_host_buffer_is_empty(dev)) {
+	if (!mei_hbuf_is_empty(dev)) {
 		dev_dbg(&dev->pdev->dev, "host buffer is not empty.\n");
 		return 0;
 	}
-	*slots = mei_count_empty_write_slots(dev);
+	*slots = mei_hbuf_empty_slots(dev);
 	if (*slots <= 0)
 		return -EMSGSIZE;
 
@@ -1558,7 +1558,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
 	dev->host_hw_state = mei_hcsr_read(dev);
-	dev->mei_host_buffer_is_empty = mei_host_buffer_is_empty(dev);
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
 
 	bus_message_received = false;
 	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
-- 
1.7.4.4

