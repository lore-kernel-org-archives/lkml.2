Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2BXBkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:40:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34546 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2BXBjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.69.69 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 7/9] mei: reduce indentation by combining if blocks
Date: Thu, 23 Feb 2012 20:38:54 -0500
Message-Id: <1330047536-3827-8-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   84 +++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 541d018..6ae7a0e 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1231,29 +1231,23 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		*slots -= dev->extra_write_index;
 		dev->extra_write_index = 0;
 	}
-	if (dev->mei_state == MEI_ENABLED) {
-		if (dev->wd_pending &&
+	if (dev->mei_state == MEI_ENABLED && dev->wd_pending &&
 			mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
-			if (mei_wd_send(dev))
-				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
-			else
-				if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
-					return -ENODEV;
+		if (mei_wd_send(dev))
+			dev_dbg(&dev->pdev->dev, "wd send failed.\n");
+		else if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
+			return -ENODEV;
 
-			dev->wd_pending = false;
+		dev->wd_pending = false;
 
-			if (dev->wd_timeout) {
-				*slots -= DIV_ROUND_UP(
-					sizeof(struct mei_msg_hdr) +
+		if (dev->wd_timeout) {
+			*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
 					MEI_START_WD_DATA_SIZE, sizeof(u32));
-				dev->wd_due_counter = 2;
-			} else {
-				*slots -= DIV_ROUND_UP(
-					sizeof(struct mei_msg_hdr) +
+			dev->wd_due_counter = 2;
+		} else {
+			*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
 					MEI_WD_PARAMS_SIZE, sizeof(u32));
-				dev->wd_due_counter = 0;
-			}
-
+			dev->wd_due_counter = 0;
 		}
 	}
 	if (dev->stop)
@@ -1356,46 +1350,40 @@ void mei_timer(struct work_struct *work)
 
 	mutex_lock(&dev->device_lock);
 	if (dev->mei_state != MEI_ENABLED) {
-		if (dev->mei_state == MEI_INIT_CLIENTS) {
-			if (dev->init_clients_timer) {
-				if (--dev->init_clients_timer == 0) {
-					dev_dbg(&dev->pdev->dev, "IMEI reset due to init clients timeout ,init clients state = %d.\n",
-						dev->init_clients_state);
-					mei_reset(dev, 1);
-				}
-			}
+		if (dev->mei_state == MEI_INIT_CLIENTS &&
+				dev->init_clients_timer &&
+				--dev->init_clients_timer == 0) {
+			dev_dbg(&dev->pdev->dev, "IMEI reset due to init clients timeout ,init clients state = %d.\n",
+					dev->init_clients_state);
+			mei_reset(dev, 1);
 		}
 		goto out;
 	}
 	/* connect/disconnect timeouts */
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if (cl_pos->timer_count) {
-			if (--cl_pos->timer_count == 0) {
-				dev_dbg(&dev->pdev->dev, "HECI reset due to connect/disconnect timeout.\n");
-				mei_reset(dev, 1);
-				goto out;
-			}
+		if (cl_pos->timer_count && --cl_pos->timer_count == 0) {
+			dev_dbg(&dev->pdev->dev, "HECI reset due to connect/disconnect timeout.\n");
+			mei_reset(dev, 1);
+			goto out;
 		}
 	}
 
-	if (dev->iamthif_stall_timer) {
-		if (--dev->iamthif_stall_timer == 0) {
-			dev_dbg(&dev->pdev->dev, "reseting because of hang to amthi.\n");
-			mei_reset(dev, 1);
-			dev->iamthif_msg_buf_size = 0;
-			dev->iamthif_msg_buf_index = 0;
-			dev->iamthif_canceled = false;
-			dev->iamthif_ioctl = true;
-			dev->iamthif_state = MEI_IAMTHIF_IDLE;
-			dev->iamthif_timer = 0;
+	if (dev->iamthif_stall_timer && --dev->iamthif_stall_timer == 0) {
+		dev_dbg(&dev->pdev->dev, "reseting because of hang to amthi.\n");
+		mei_reset(dev, 1);
+		dev->iamthif_msg_buf_size = 0;
+		dev->iamthif_msg_buf_index = 0;
+		dev->iamthif_canceled = false;
+		dev->iamthif_ioctl = true;
+		dev->iamthif_state = MEI_IAMTHIF_IDLE;
+		dev->iamthif_timer = 0;
 
-			if (dev->iamthif_current_cb)
-				mei_free_cb_private(dev->iamthif_current_cb);
+		if (dev->iamthif_current_cb)
+			mei_free_cb_private(dev->iamthif_current_cb);
 
-			dev->iamthif_file_object = NULL;
-			dev->iamthif_current_cb = NULL;
-			mei_run_next_iamthif_cmd(dev);
-		}
+		dev->iamthif_file_object = NULL;
+		dev->iamthif_current_cb = NULL;
+		mei_run_next_iamthif_cmd(dev);
 	}
 
 	if (dev->iamthif_timer) {
-- 
1.7.9.2

