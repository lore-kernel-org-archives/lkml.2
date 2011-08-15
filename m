Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1HOVwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:52:20 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:57863
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752949Ab1HOVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:52:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc() directly
Date: Mon, 15 Aug 2011 15:12:01 -0700
Message-Id: <1313446327-10650-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313446327-10650-1-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
 <1313446327-10650-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message processing function needs to execute on the same CPU where
the interrupt was taken. tasklets cannot gurantee this; so, invoke the 
function directly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index bb25c5b..1d4e878 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -39,7 +39,6 @@
 
 static struct acpi_device  *hv_acpi_dev;
 
-static struct tasklet_struct msg_dpc;
 static struct tasklet_struct event_dpc;
 
 unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
@@ -425,7 +424,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	/* Check if there are actual msgs to be process */
 	if (msg->header.message_type != HVMSG_NONE) {
 		handled = true;
-		tasklet_schedule(&msg_dpc);
+		vmbus_on_msg_dpc(0);
 	}
 
 	page_addr = hv_context.synic_event_page[cpu];
@@ -465,7 +464,6 @@ static int vmbus_bus_init(int irq)
 	}
 
 	/* Initialize the bus context */
-	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
 	/* Now, register the bus  with LDM */
-- 
1.7.4.1

