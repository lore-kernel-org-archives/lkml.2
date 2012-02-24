Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2BXBjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2BXBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.135.131 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 3/9] mei: more idiomatic variable/label usage
Date: Thu, 23 Feb 2012 20:38:50 -0500
Message-Id: <1330047536-3827-4-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Rename rets -> ret, and quit -> out.  Also, use return instead of goto
end when end is just a return anyway.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index d1291ae..0601789 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -194,7 +194,7 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 
 	dev_dbg(&dev->pdev->dev, "start client msg\n");
 	if (list_empty(&dev->read_list.mei_cb.cb_list))
-		goto quit;
+		goto out;
 
 	list_for_each_entry_safe(cb_pos, cb_next,
 			&dev->read_list.mei_cb.cb_list, cb_list) {
@@ -239,7 +239,7 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 
 	}
 
-quit:
+out:
 	dev_dbg(&dev->pdev->dev, "message read\n");
 	if (!buffer) {
 		mei_read_slots(dev, (unsigned char *) dev->rd_msg_buf,
@@ -1106,8 +1106,7 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 
 	if (mei_hdr->reserved || !dev->rd_msg_hdr) {
 		dev_dbg(&dev->pdev->dev, "corrupted message header.\n");
-		ret = -EBADMSG;
-		goto end;
+		return -EBADMSG;
 	}
 
 	if (mei_hdr->host_addr || mei_hdr->me_addr) {
@@ -1126,8 +1125,7 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 
 		if (&cl_pos->link == &dev->file_list) {
 			dev_dbg(&dev->pdev->dev, "corrupted message header\n");
-			ret = -EBADMSG;
-			goto end;
+			return -EBADMSG;
 		}
 	}
 	if (((*slots) * sizeof(u32)) < mei_hdr->length) {
@@ -1135,8 +1133,7 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 				"we can't read the message slots =%08x.\n",
 				*slots);
 		/* we can't read the message */
-		ret = -ERANGE;
-		goto end;
+		return -ERANGE;
 	}
 
 	/* decide where to read the message too */
@@ -1153,14 +1150,14 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 		ret = mei_irq_thread_read_amthi_message(cmpl_list,
 							dev, mei_hdr);
 		if (ret)
-			goto end;
+			return ret;
 
 	} else {
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_client_message.\n");
 		ret = mei_irq_thread_read_client_message(cmpl_list,
 							dev, mei_hdr);
 		if (ret)
-			goto end;
+			return ret;
 
 	}
 
@@ -1172,11 +1169,9 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 		/* overflow - reset */
 		dev_dbg(&dev->pdev->dev, "resetting due to slots overflow.\n");
 		/* set the event since message has been read */
-		ret = -ERANGE;
-		goto end;
+		return -ERANGE;
 	}
-end:
-	return ret;
+	return 0;
 }
 
 /**
@@ -1480,7 +1475,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
 	struct mei_cl *cl;
 	s32 slots;
-	int rets;
+	int ret;
 	bool bus_message_received;
 
 	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
@@ -1532,11 +1527,11 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 		dev_dbg(&dev->pdev->dev, "slots =%08x  extra_write_index =%08x.\n",
 				slots, dev->extra_write_index);
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_handler.\n");
-		rets = mei_irq_thread_read_handler(&complete_list, dev, &slots);
-		if (rets)
+		ret = mei_irq_thread_read_handler(&complete_list, dev, &slots);
+		if (ret)
 			goto end;
 	}
-	rets = mei_irq_thread_write_handler(&complete_list, dev, &slots);
+	mei_irq_thread_write_handler(&complete_list, dev, &slots);
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
 	dev->host_hw_state = mei_hcsr_read(dev);
-- 
1.7.9.2

