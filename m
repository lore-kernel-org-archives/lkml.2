Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2LAO2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:28:54 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:39118
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab2LAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 18/28] Drivers: hv: Modify the interrupt handling code to support win8 and beyond
Date: Sat,  1 Dec 2012 06:46:49 -0800
Message-Id: <1354373219-31374-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with Win8 (WS2012), the event page can be used to directly get the
channel ID that needs servicing. Modify the channel event handling code
to take advantage of this feature. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |   26 ++++++++++++++++++++++++--
 drivers/hv/vmbus_drv.c  |   27 ++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 114050d..ac71653 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -321,10 +321,32 @@ static void process_chn_event(u32 relid)
 void vmbus_on_event(unsigned long data)
 {
 	u32 dword;
-	u32 maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
+	u32 maxdword;
 	int bit;
 	u32 relid;
-	u32 *recv_int_page = vmbus_connection.recv_int_page;
+	u32 *recv_int_page = NULL;
+	void *page_addr;
+	int cpu = smp_processor_id();
+	union hv_synic_event_flags *event;
+
+	if ((vmbus_proto_version == VERSION_WS2008) ||
+		(vmbus_proto_version == VERSION_WIN7)) {
+		maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
+		recv_int_page = vmbus_connection.recv_int_page;
+	} else {
+		/*
+		 * When the host is win8 and beyond, the event page
+		 * can be directly checked to get the id of the channel
+		 * that has the interrupt pending.
+		 */
+		maxdword = HV_EVENT_FLAGS_DWORD_COUNT;
+		page_addr = hv_context.synic_event_page[cpu];
+		event = (union hv_synic_event_flags *)page_addr +
+						 VMBUS_MESSAGE_SINT;
+		recv_int_page = event->flags32;
+	}
+
+
 
 	/* Check events */
 	if (!recv_int_page)
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 8e1a9ec..c583a04 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -460,15 +460,32 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	 * Hyper-V, and the Windows team suggested we do the same.
 	 */
 
-	page_addr = hv_context.synic_event_page[cpu];
-	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
+	if ((vmbus_proto_version == VERSION_WS2008) ||
+		(vmbus_proto_version == VERSION_WIN7)) {
 
-	/* Since we are a child, we only need to check bit 0 */
-	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
+		page_addr = hv_context.synic_event_page[cpu];
+		event = (union hv_synic_event_flags *)page_addr +
+					 VMBUS_MESSAGE_SINT;
+
+		/* Since we are a child, we only need to check bit 0 */
+		if (sync_test_and_clear_bit(0,
+			(unsigned long *) &event->flags32[0])) {
+			handled = true;
+		}
+	} else {
+		/*
+		 * Our host is win8 or above. The signaling mechanism
+		 * has changed and we can directly look at the event page.
+		 * If bit n is set then we have an interrup on the channel
+		 * whose id is n.
+		 */
 		handled = true;
-		tasklet_schedule(&event_dpc);
 	}
 
+	if (handled)
+		tasklet_schedule(&event_dpc);
+
+
 	page_addr = hv_context.synic_message_page[cpu];
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
-- 
1.7.4.1

