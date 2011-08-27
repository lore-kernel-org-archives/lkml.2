Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1H0SMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:12 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39863
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751520Ab1H0SLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 36/46] Staging: hv: vmbus: Get rid of vmbus_on_isr() by inlining the code
Date: Sat, 27 Aug 2011 11:31:35 -0700
Message-Id: <1314469905-7058-36-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of vmbus_on_isr() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   41 +++++++++++----------------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 51002c0..5dcc8c3 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -437,53 +437,36 @@ static void vmbus_on_msg_dpc(unsigned long data)
 	}
 }
 
-/*
- * vmbus_on_isr - ISR routine
- */
-static int vmbus_on_isr(void)
+static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-	int ret = 0;
 	int cpu = smp_processor_id();
 	void *page_addr;
 	struct hv_message *msg;
 	union hv_synic_event_flags *event;
+	bool handled = false;
 
 	page_addr = hv_context.synic_message_page[cpu];
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be process */
-	if (msg->header.message_type != HVMSG_NONE)
-		ret |= 0x1;
+	if (msg->header.message_type != HVMSG_NONE) {
+		handled = true;
+		tasklet_schedule(&msg_dpc);
+	}
 
 	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0]))
-		ret |= 0x2;
-
-	return ret;
-}
-
-
-static irqreturn_t vmbus_isr(int irq, void *dev_id)
-{
-	int ret;
-
-	ret = vmbus_on_isr();
-
-	/* Schedules a dpc if necessary */
-	if (ret > 0) {
-		if (test_bit(0, (unsigned long *)&ret))
-			tasklet_schedule(&msg_dpc);
-
-		if (test_bit(1, (unsigned long *)&ret))
-			tasklet_schedule(&event_dpc);
+	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
+		handled = true;
+		tasklet_schedule(&event_dpc);
+	}
 
+	if (handled)
 		return IRQ_HANDLED;
-	} else {
+	else
 		return IRQ_NONE;
-	}
 }
 
 /*
-- 
1.7.4.1

