Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1FFWqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:46:21 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39398
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758152Ab1FFWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 11/49] Staging: hv: vmbus: Don't free the channel when the channel is closed
Date: Mon,  6 Jun 2011 15:49:35 -0700
Message-Id: <1307400613-13234-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the driver unloads, the device must persist. A channel represents the 
device and so we should not free the channel when the channel is closed as 
part of the driver unloading.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index f655e59..aca9ac8 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -552,7 +552,6 @@ void vmbus_close(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	struct vmbus_channel_msginfo *info;
-	unsigned long flags;
 	int ret;
 
 	/* Stop callback and cancel the timer asap */
@@ -591,19 +590,6 @@ void vmbus_close(struct vmbus_channel *channel)
 
 	kfree(info);
 
-	/*
-	 * If we are closing the channel during an error path in
-	 * opening the channel, don't free the channel since the
-	 * caller will free the channel
-	 */
-
-	if (channel->state == CHANNEL_OPEN_STATE) {
-		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
-		list_del(&channel->listentry);
-		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
-
-		free_channel(channel);
-	}
 }
 EXPORT_SYMBOL_GPL(vmbus_close);
 
-- 
1.7.4.1

