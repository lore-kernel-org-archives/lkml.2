Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HOVwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:52:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36435
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752601Ab1HOVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:52:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/8] Staging: hv: vmbus: Check for events before messages
Date: Mon, 15 Aug 2011 15:12:02 -0700
Message-Id: <1313446327-10650-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313446327-10650-1-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
 <1313446327-10650-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V requires that events be processed before processing messages. Make the
necessary code adjustments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 1d4e878..536466b 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -418,15 +418,6 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	union hv_synic_event_flags *event;
 	bool handled = false;
 
-	page_addr = hv_context.synic_message_page[cpu];
-	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
-
-	/* Check if there are actual msgs to be process */
-	if (msg->header.message_type != HVMSG_NONE) {
-		handled = true;
-		vmbus_on_msg_dpc(0);
-	}
-
 	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
@@ -436,6 +427,15 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 		tasklet_schedule(&event_dpc);
 	}
 
+	page_addr = hv_context.synic_message_page[cpu];
+	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
+
+	/* Check if there are actual msgs to be process */
+	if (msg->header.message_type != HVMSG_NONE) {
+		handled = true;
+		vmbus_on_msg_dpc(0);
+	}
+
 	if (handled)
 		return IRQ_HANDLED;
 	else
-- 
1.7.4.1

