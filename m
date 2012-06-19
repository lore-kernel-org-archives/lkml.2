Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2FSGNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:13:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:62481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab2FSGNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159348673"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/4] mei: make mei_write_message more readable
Date: Tue, 19 Jun 2012 09:13:35 +0300
Message-Id: <1340086417-23090-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
References: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. reduce hairy casting
2. replace open code with mei_count_empty_write_slots
4. include header size in check for overflow
3. use concise for loop instead of a while loop

Change-Id: Idb7423bd7bc570a46437568908a0e8f6d7225555
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interface.c |   49 +++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 428d21e..6c05691 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -127,52 +127,39 @@ int mei_count_empty_write_slots(struct mei_device *dev)
  *
  * This function returns -EIO if write has failed
  */
-int mei_write_message(struct mei_device *dev,
-		      struct mei_msg_hdr *header,
-		      unsigned char *write_buffer,
-		      unsigned long write_length)
+int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
+		      unsigned char *buf, unsigned long length)
 {
-	u32 temp_msg = 0;
-	unsigned long bytes_written = 0;
-	unsigned char buffer_depth, filled_slots, empty_slots;
-	unsigned long dw_to_write;
-
-	dev->host_hw_state = mei_hcsr_read(dev);
+	unsigned long rem, dw_cnt;
+	u32 *reg_buf = (u32 *)buf;
+	int i;
+	int empty_slots;
 
-	dev_dbg(&dev->pdev->dev,
-			"host_hw_state = 0x%08x.\n",
-			dev->host_hw_state);
 
 	dev_dbg(&dev->pdev->dev,
 			"mei_write_message header=%08x.\n",
 			*((u32 *) header));
 
-	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
-	filled_slots = _host_get_filled_slots(dev);
-	empty_slots = buffer_depth - filled_slots;
-	dev_dbg(&dev->pdev->dev,
-			"filled = %hu, empty = %hu.\n",
-			filled_slots, empty_slots);
-
-	dw_to_write = ((write_length + 3) / 4);
+	empty_slots = mei_count_empty_write_slots(dev);
+	dev_dbg(&dev->pdev->dev, "empty slots = %hu.\n", empty_slots);
 
-	if (dw_to_write > empty_slots)
+	dw_cnt = (length + sizeof(*header) + 3) / 4;
+	if (empty_slots < 0 || dw_cnt > empty_slots)
 		return -EIO;
 
 	mei_reg_write(dev, H_CB_WW, *((u32 *) header));
 
-	while (write_length >= 4) {
-		mei_reg_write(dev, H_CB_WW,
-				*(u32 *) (write_buffer + bytes_written));
-		bytes_written += 4;
-		write_length -= 4;
-	}
+	for (i = 0; i < length / 4; i++)
+		mei_reg_write(dev, H_CB_WW, reg_buf[i]);
 
-	if (write_length > 0) {
-		memcpy(&temp_msg, &write_buffer[bytes_written], write_length);
-		mei_reg_write(dev, H_CB_WW, temp_msg);
+	rem = length & 0x3;
+	if (rem > 0) {
+		u32 reg = 0;
+		memcpy(&reg, &buf[length - rem], rem);
+		mei_reg_write(dev, H_CB_WW, reg);
 	}
 
+	dev->host_hw_state = mei_hcsr_read(dev);
 	dev->host_hw_state |= H_IG;
 	mei_hcsr_set(dev);
 	dev->me_hw_state = mei_mecsr_read(dev);
-- 
1.7.4.4

