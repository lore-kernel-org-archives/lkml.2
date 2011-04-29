Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab1D2Ucb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:32:31 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37481
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932518Ab1D2Uc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:32:28 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/18] Staging: hv: Get rid of vmbus_release_unattached_channels() as it is not used
Date: Fri, 29 Apr 2011 13:45:00 -0700
Message-Id: <1304109916-24874-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304109916-24874-1-git-send-email-kys@microsoft.com>
References: <1304109779-24819-1-git-send-email-kys@microsoft.com>
 <1304109916-24874-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since vmbus_release_unattached_channels() is only used in module
unload path and since the vmbus driver cannot be unloaded,
get rid of this "dead" code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   33 ---------------------------------
 drivers/staging/hv/channel_mgmt.h |    2 --
 2 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index fe32f7e..1929ab3 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -791,37 +791,4 @@ cleanup:
 	return ret;
 }
 
-/*
- * vmbus_release_unattached_channels - Release channels that are
- * unattached/unconnected ie (no drivers associated)
- */
-void vmbus_release_unattached_channels(void)
-{
-	struct vmbus_channel *channel, *pos;
-	struct vmbus_channel *start = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
-
-	list_for_each_entry_safe(channel, pos, &vmbus_connection.chn_list,
-				 listentry) {
-		if (channel == start)
-			break;
-
-		if (!channel->device_obj->drv) {
-			list_del(&channel->listentry);
-
-			pr_err("Releasing unattached device object\n");
-
-			vmbus_child_device_unregister(channel->device_obj);
-			free_channel(channel);
-		} else {
-			if (!start)
-				start = channel;
-		}
-	}
-
-	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
-}
-
 /* eof */
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index 96f74e2..3b2c393 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -315,6 +315,4 @@ void vmbus_onmessage(void *context);
 
 int vmbus_request_offers(void);
 
-void vmbus_release_unattached_channels(void);
-
 #endif /* _CHANNEL_MGMT_H_ */
-- 
1.7.4.1

