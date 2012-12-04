Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2LDOIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:08:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2LDOE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:04:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975246"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/15] mei: use unified format for printing mei message header
Date: Tue,  4 Dec 2012 16:04:31 +0200
Message-Id: <1354629884-3202-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    3 +--
 drivers/misc/mei/interface.c |    4 +---
 drivers/misc/mei/interrupt.c |   14 ++++++--------
 drivers/misc/mei/main.c      |    5 +++--
 drivers/misc/mei/mei_dev.h   |    5 +++++
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 8a9313a..77acd23 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -457,8 +457,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 		return 0;
 	}
 
-	dev_dbg(&dev->pdev->dev, "msg: len = %d complete = %d\n",
-			mei_hdr->length, mei_hdr->msg_complete);
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(mei_hdr));
 
 	*slots -=  msg_slots;
 	if (mei_write_message(dev, mei_hdr,
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 21ccbe6..17d93f7 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -127,9 +127,7 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 	int i;
 	int empty_slots;
 
-	dev_dbg(&dev->pdev->dev,
-			"mei_write_message header=%08x.\n",
-			*((u32 *) header));
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
 
 	empty_slots = mei_hbuf_empty_slots(dev);
 	dev_dbg(&dev->pdev->dev, "empty slots = %hu.\n", empty_slots);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index b72fa81..fe93d1c 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -150,8 +150,8 @@ quit:
 	dev_dbg(&dev->pdev->dev, "message read\n");
 	if (!buffer) {
 		mei_read_slots(dev, dev->rd_msg_buf, mei_hdr->length);
-		dev_dbg(&dev->pdev->dev, "discarding message, header =%08x.\n",
-				*(u32 *) dev->rd_msg_buf);
+		dev_dbg(&dev->pdev->dev, "discarding message " MEI_HDR_FMT "\n",
+				MEI_HDR_PRM(mei_hdr));
 	}
 
 	return 0;
@@ -742,8 +742,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 
 	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
 			cb->request_buffer.size, cb->buf_idx);
-	dev_dbg(&dev->pdev->dev, "msg: len = %d complete = %d\n",
-			mei_hdr->length, mei_hdr->msg_complete);
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 	*slots -=  msg_slots;
 	if (mei_write_message(dev, mei_hdr,
@@ -790,7 +789,7 @@ static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
 		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
 	}
 	mei_hdr = (struct mei_msg_hdr *) &dev->rd_msg_hdr;
-	dev_dbg(&dev->pdev->dev, "mei_hdr->length =%d\n", mei_hdr->length);
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 	if (mei_hdr->reserved || !dev->rd_msg_hdr) {
 		dev_dbg(&dev->pdev->dev, "corrupted message header.\n");
@@ -835,13 +834,12 @@ static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
 		   (MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
 		   (dev->iamthif_state == MEI_IAMTHIF_READING)) {
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
-		dev_dbg(&dev->pdev->dev, "mei_hdr->length =%d\n",
-				mei_hdr->length);
+
+		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 		ret = mei_amthif_irq_read_message(cmpl_list, dev, mei_hdr);
 		if (ret)
 			goto end;
-
 	} else {
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_client_message.\n");
 		ret = mei_irq_thread_read_client_message(cmpl_list,
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index b281c23..7751b58 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -552,8 +552,9 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	mei_hdr.host_addr = cl->host_client_id;
 	mei_hdr.me_addr = cl->me_client_id;
 	mei_hdr.reserved = 0;
-	dev_dbg(&dev->pdev->dev, "call mei_write_message header=%08x.\n",
-	    *((u32 *) &mei_hdr));
+
+	dev_dbg(&dev->pdev->dev, "write " MEI_HDR_FMT "\n",
+		MEI_HDR_PRM(&mei_hdr));
 	if (mei_write_message(dev, &mei_hdr, write_cb->request_buffer.data)) {
 		rets = -ENODEV;
 		goto err;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 25da045..da09805 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -506,4 +506,9 @@ static inline struct mei_msg_hdr *mei_hbm_hdr(u32 *buf, size_t length)
 	return hdr;
 }
 
+#define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
+#define MEI_HDR_PRM(hdr)                  \
+	(hdr)->host_addr, (hdr)->me_addr, \
+	(hdr)->length, (hdr)->msg_complete
+
 #endif
-- 
1.7.4.4

