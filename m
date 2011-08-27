Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1H0SMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54822
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751506Ab1H0SLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 37/46] Staging: hv: vmbus: Check for events before messages
Date: Sat, 27 Aug 2011 11:31:36 -0700
Message-Id: <1314469905-7058-37-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conform to Windows specification by checking for events before messages.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 5dcc8c3..4e07d4f 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -445,15 +445,6 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	union hv_synic_event_flags *event;
 	bool handled = false;
 
-	page_addr = hv_context.synic_message_page[cpu];
-	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
-
-	/* Check if there are actual msgs to be process */
-	if (msg->header.message_type != HVMSG_NONE) {
-		handled = true;
-		tasklet_schedule(&msg_dpc);
-	}
-
 	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
@@ -463,6 +454,15 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 		tasklet_schedule(&event_dpc);
 	}
 
+	page_addr = hv_context.synic_message_page[cpu];
+	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
+
+	/* Check if there are actual msgs to be processed */
+	if (msg->header.message_type != HVMSG_NONE) {
+		handled = true;
+		tasklet_schedule(&msg_dpc);
+	}
+
 	if (handled)
 		return IRQ_HANDLED;
 	else
-- 
1.7.4.1

