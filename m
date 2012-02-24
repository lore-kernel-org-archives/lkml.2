Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2BXBjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:35 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48576 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2BXBjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.134.194 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 8/9] mei: reduce indentation in read_client_message
Date: Thu, 23 Feb 2012 20:38:55 -0500
Message-Id: <1330047536-3827-9-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Removes the empty check since that's handled by foreach.  Moves a big
chunk of code out of the foreach since it's followed by a break anyway.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   67 ++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 6ae7a0e..f2c864e 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -193,51 +193,44 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 	unsigned char *buffer = NULL;
 
 	dev_dbg(&dev->pdev->dev, "start client msg\n");
-	if (list_empty(&dev->read_list.mei_cb.cb_list))
-		goto out;
 
 	list_for_each_entry_safe(cb_pos, cb_next,
 			&dev->read_list.mei_cb.cb_list, cb_list) {
 		cl = (struct mei_cl *)cb_pos->file_private;
-		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr)) {
-			cl->reading_state = MEI_READING;
-			buffer = (unsigned char *)
-				(cb_pos->response_buffer.data +
-				cb_pos->information);
-
-			if (cb_pos->response_buffer.size <
-					mei_hdr->length + cb_pos->information) {
-				dev_dbg(&dev->pdev->dev, "message overflow.\n");
-				list_del(&cb_pos->cb_list);
-				return -ENOMEM;
-			}
-			if (buffer)
-				mei_read_slots(dev, buffer, mei_hdr->length);
+		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr))
+			break;
+	}
 
-			cb_pos->information += mei_hdr->length;
-			if (mei_hdr->msg_complete) {
-				cl->status = 0;
-				list_del(&cb_pos->cb_list);
-				dev_dbg(&dev->pdev->dev,
-					"completed read host client = %d,"
-					"ME client = %d, "
-					"data length = %lu\n",
-					cl->host_client_id,
-					cl->me_client_id,
-					cb_pos->information);
-
-				*(cb_pos->response_buffer.data +
-					cb_pos->information) = '\0';
-				dev_dbg(&dev->pdev->dev, "cb_pos->res_buffer - %s\n",
-					cb_pos->response_buffer.data);
-				list_add_tail(&cb_pos->cb_list,
-					&complete_list->mei_cb.cb_list);
-			}
+	/* List empty, or client not found */
+	if (&cb_pos->cb_list == &dev->read_list.mei_cb.cb_list)
+		goto out;
 
-			break;
-		}
+	cl->reading_state = MEI_READING;
+	buffer = cb_pos->response_buffer.data + cb_pos->information;
 
+	if (cb_pos->response_buffer.size <
+			mei_hdr->length + cb_pos->information) {
+		dev_dbg(&dev->pdev->dev, "message overflow.\n");
+		list_del(&cb_pos->cb_list);
+		return -ENOMEM;
 	}
+	if (buffer)
+		mei_read_slots(dev, buffer, mei_hdr->length);
+
+	cb_pos->information += mei_hdr->length;
+	if (!mei_hdr->msg_complete)
+		goto out;
+
+	cl->status = 0;
+	list_del(&cb_pos->cb_list);
+	dev_dbg(&dev->pdev->dev, "completed read host client = %d, "
+		"ME client = %d, data length = %lu\n",
+		cl->host_client_id, cl->me_client_id, cb_pos->information);
+
+	cb_pos->response_buffer.data[cb_pos->information] = '\0';
+	dev_dbg(&dev->pdev->dev, "cb_pos->res_buffer - %s\n",
+		cb_pos->response_buffer.data);
+	list_add_tail(&cb_pos->cb_list, &complete_list->mei_cb.cb_list);
 
 out:
 	dev_dbg(&dev->pdev->dev, "message read\n");
-- 
1.7.9.2

