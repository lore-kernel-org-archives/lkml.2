Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1HaVPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:15:07 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59590
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755580Ab1HaVPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:15:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/4] Staging: hv: vmbus: Check for events before messages
Date: Wed, 31 Aug 2011 14:35:56 -0700
Message-Id: <1314826557-28755-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314826557-28755-1-git-send-email-kys@microsoft.com>
References: <1314826529-28716-1-git-send-email-kys@microsoft.com>
 <1314826557-28755-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Windows team has informed us that on Windows guests on Hyper-V,
they check for events before messages. They also recommended that we do
the same. This patch addresses this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b5e06d6..cd43ddd 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -442,14 +442,11 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
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
+	/*
+	 * Check for events before checking for messages. This is the order
+	 * in which events and messages are checked in Windows guests on
+	 * Hyper-V, and the Windows team suggested we do the same.
+	 */
 
 	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
@@ -460,6 +457,15 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
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

