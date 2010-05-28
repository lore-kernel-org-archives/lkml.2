Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0E1XWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:22:51 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:59746 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0E1XWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:22:47 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix race condition on vmbus channel
 initialization
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on vmbus channel
 initialization
Thread-Index: Acr+vKzuFbL48vNVTBK3k69F8A0hFg==
Date: Fri, 28 May 2010 23:22:44 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8D340@TK5EX14MBXC128.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: [PATCH] staging: hv: Fix race condition on vmbus channel initialization
There is a possible race condition when hv_utils starts to load immediately
after hv_vmbus is loading - null pointer error could happen.
This patch added wait/completion to ensure all channels are ready before
vmbus loading completes. So another module won't have any uninitialized channel.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   41 +++++++++++++++++++++++++++----------
 drivers/staging/hv/vmbus.h        |    2 +
 drivers/staging/hv/vmbus_drv.c    |    3 ++
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 3f53b4d..12db555 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/completion.h>
 #include "osd.h"
 #include "logging.h"
 #include "vmbus_private.h"
@@ -293,6 +294,25 @@ void FreeVmbusChannel(struct vmbus_channel *Channel)
 			      Channel);
 }
 
+
+DECLARE_COMPLETION(hv_channel_ready);
+
+/*
+ * Count initialized channels, and ensure all channels are ready when hv_vmbus
+ * module loading completes.
+ */
+static void count_hv_channel(void)
+{
+	static int counter;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+	if (++counter == MAX_MSG_TYPES)
+		complete(&hv_channel_ready);
+	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+}
+
+
 /*
  * VmbusChannelProcessOffer - Process the offer by creating a channel/device
  * associated with this offer
@@ -373,22 +393,21 @@ static void VmbusChannelProcessOffer(void *context)
 		 * can cleanup properly
 		 */
 		newChannel->State = CHANNEL_OPEN_STATE;
-		cnt = 0;
 
-		while (cnt != MAX_MSG_TYPES) {
+		/* Open IC channels */
+		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
 			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
-				   sizeof(struct hv_guid)) == 0) {
+				   sizeof(struct hv_guid)) == 0 &&
+				VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
+						 2 * PAGE_SIZE, NULL, 0,
+						 hv_cb_utils[cnt].callback,
+						 newChannel) == 0) {
+				hv_cb_utils[cnt].channel = newChannel;
 				DPRINT_INFO(VMBUS, "%s",
-					    hv_cb_utils[cnt].log_msg);
-
-				if (VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
-						    2 * PAGE_SIZE, NULL, 0,
-						    hv_cb_utils[cnt].callback,
-						    newChannel) == 0)
-					hv_cb_utils[cnt].channel = newChannel;
+						hv_cb_utils[cnt].log_msg);
+				count_hv_channel();
 			}
-			cnt++;
 		}
 	}
 	DPRINT_EXIT(VMBUS);
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 0c6ee0f..3c14b29 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -74,4 +74,6 @@ int vmbus_child_driver_register(struct driver_context *driver_ctx);
 void vmbus_child_driver_unregister(struct driver_context *driver_ctx);
 void vmbus_get_interface(struct vmbus_channel_interface *interface);
 
+extern struct completion hv_channel_ready;
+
 #endif /* _VMBUS_H_ */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index c21731a..22c80ec 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/completion.h>
 #include "version_info.h"
 #include "osd.h"
 #include "logging.h"
@@ -356,6 +357,8 @@ static int vmbus_bus_init(int (*drv_init)(struct hv_driver *drv))
 
 	vmbus_drv_obj->GetChannelOffers();
 
+	wait_for_completion(&hv_channel_ready);
+
 cleanup:
 	DPRINT_EXIT(VMBUS_DRV);
 
-- 
1.6.3.2

