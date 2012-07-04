Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2GDQZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:25:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab2GDQZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:25:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923233"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/6] mei: streamline the _mei_irq_thread_close/ioctol functions
Date: Wed,  4 Jul 2012 19:24:53 +0300
Message-Id: <1341419094-4204-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
References: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change statements of types

	if (ok)
		do something
	else
		return err

into

	if (err)
		return err

	do something

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

---
 drivers/misc/mei/interrupt.c |   63 ++++++++++++++++++++----------------------
 1 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 8679f22..4a3b117 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -299,27 +299,25 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 				struct mei_cl *cl,
 				struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_disconnect_request))) {
-		*slots -= mei_data2slots(sizeof(struct hbm_client_disconnect_request));
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request)))
+		return -EBADMSG;
 
-		if (mei_disconnect(dev, cl)) {
-			cl->status = 0;
-			cb_pos->information = 0;
-			list_move_tail(&cb_pos->cb_list,
-					&cmpl_list->mei_cb.cb_list);
-			return -EMSGSIZE;
-		} else {
-			cl->state = MEI_FILE_DISCONNECTING;
-			cl->status = 0;
-			cb_pos->information = 0;
-			list_move_tail(&cb_pos->cb_list,
-					&dev->ctrl_rd_list.mei_cb.cb_list);
-			cl->timer_count = MEI_CONNECT_TIMEOUT;
-		}
+	*slots -= mei_data2slots(sizeof(struct hbm_client_disconnect_request));
+
+	if (mei_disconnect(dev, cl)) {
+		cl->status = 0;
+		cb_pos->information = 0;
+		list_move_tail(&cb_pos->cb_list,
+				&cmpl_list->mei_cb.cb_list);
+		return -EMSGSIZE;
 	} else {
-		/* return the cancel routine */
-		return -EBADMSG;
+		cl->state = MEI_FILE_DISCONNECTING;
+		cl->status = 0;
+		cb_pos->information = 0;
+		list_move_tail(&cb_pos->cb_list,
+				&dev->ctrl_rd_list.mei_cb.cb_list);
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
 	}
 
 	return 0;
@@ -869,26 +867,25 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_connect_request))) {
-		cl->state = MEI_FILE_CONNECTING;
-		 *slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
-		if (mei_connect(dev, cl)) {
-			cl->status = -ENODEV;
-			cb_pos->information = 0;
-			list_del(&cb_pos->cb_list);
-			return -ENODEV;
-		} else {
-			list_move_tail(&cb_pos->cb_list,
-				&dev->ctrl_rd_list.mei_cb.cb_list);
-			cl->timer_count = MEI_CONNECT_TIMEOUT;
-		}
-	} else {
 		/* return the cancel routine */
 		list_del(&cb_pos->cb_list);
 		return -EBADMSG;
 	}
 
+	cl->state = MEI_FILE_CONNECTING;
+	 *slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
+	if (mei_connect(dev, cl)) {
+		cl->status = -ENODEV;
+		cb_pos->information = 0;
+		list_del(&cb_pos->cb_list);
+		return -ENODEV;
+	} else {
+		list_move_tail(&cb_pos->cb_list,
+			&dev->ctrl_rd_list.mei_cb.cb_list);
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
+	}
 	return 0;
 }
 
-- 
1.7.4.4

