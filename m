Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1EJIi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:38:27 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35427
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756093Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 206/206] Staging: hv: Get rid of the function count_hv_channel()
Date: Mon,  9 May 2011 14:58:08 -0700
Message-Id: <1304978288-22999-206-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the function count_hv_channel()
by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 0e4e05a..ef43b00 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -28,10 +28,12 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/completion.h>
+#include <linux/atomic.h>
 
 #include <linux/hyperv.h>
 #include "hyperv_vmbus.h"
 
+static atomic_t num_channels;
 struct vmbus_channel_message_table_entry {
 	enum vmbus_channel_message_type message_type;
 	void (*message_handler)(struct vmbus_channel_message_header *msg);
@@ -316,21 +318,6 @@ void free_channel(struct vmbus_channel *channel)
 DECLARE_COMPLETION(hv_channel_ready);
 
 /*
- * Count initialized channels, and ensure all channels are ready when hv_vmbus
- * module loading completes.
- */
-static void count_hv_channel(void)
-{
-	static int counter;
-	unsigned long flags;
-
-	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
-	if (++counter == MAX_MSG_TYPES)
-		complete(&hv_channel_ready);
-	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
-}
-
-/*
  * vmbus_process_rescind_offer -
  * Rescind the offer by initiating a device removal
  */
@@ -433,7 +420,16 @@ static void vmbus_process_offer(struct work_struct *work)
 
 				pr_info("%s\n", hv_cb_utils[cnt].log_msg);
 
-				count_hv_channel();
+				/*
+				 * Count initialized channels, and ensure
+				 * all channels are ready when hv_vmbus
+				 * module loading completes.
+				 */
+
+				atomic_inc(&num_channels);
+				if (atomic_read(&num_channels)
+					 == MAX_MSG_TYPES)
+					complete(&hv_channel_ready);
 			}
 		}
 	}
-- 
1.7.4.1

