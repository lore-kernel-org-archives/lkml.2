Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1GORby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:31:54 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60256
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754282Ab1GORaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 115/117] Staging: hv: vmbus: Properly deal with de-registering channel callback
Date: Fri, 15 Jul 2011 10:47:43 -0700
Message-Id: <1310752065-27895-115-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we correctly handle racing invocations of the channel callback
when the channel is being closed. We do this using the channel's inbound_lock.
A side-effect of this strategy is that we avoid repeatedly picking up this lock
as we drain the inbound ring-buffer.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel.c    |   20 +++++---------------
 drivers/staging/hv/connection.c |    3 +++
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index ac92c1f..b6f3d38 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -513,9 +513,12 @@ void vmbus_close(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	int ret;
+	unsigned long flags;
 
 	/* Stop callback and cancel the timer asap */
+	spin_lock_irqsave(&channel->inbound_lock, flags);
 	channel->onchannel_callback = NULL;
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 	/* Send a closing message */
 
@@ -735,19 +738,15 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	u32 packetlen;
 	u32 userlen;
 	int ret;
-	unsigned long flags;
 
 	*buffer_actual_len = 0;
 	*requestid = 0;
 
-	spin_lock_irqsave(&channel->inbound_lock, flags);
 
 	ret = hv_ringbuffer_peek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
-	if (ret != 0) {
-		spin_unlock_irqrestore(&channel->inbound_lock, flags);
+	if (ret != 0)
 		return 0;
-	}
 
 	packetlen = desc.len8 << 3;
 	userlen = packetlen - (desc.offset8 << 3);
@@ -755,7 +754,6 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	*buffer_actual_len = userlen;
 
 	if (userlen > bufferlen) {
-		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		pr_err("Buffer too small - got %d needs %d\n",
 			   bufferlen, userlen);
@@ -768,7 +766,6 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	ret = hv_ringbuffer_read(&channel->inbound, buffer, userlen,
 			     (desc.offset8 << 3));
 
-	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 	return 0;
 }
@@ -785,19 +782,15 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	u32 packetlen;
 	u32 userlen;
 	int ret;
-	unsigned long flags;
 
 	*buffer_actual_len = 0;
 	*requestid = 0;
 
-	spin_lock_irqsave(&channel->inbound_lock, flags);
 
 	ret = hv_ringbuffer_peek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
-	if (ret != 0) {
-		spin_unlock_irqrestore(&channel->inbound_lock, flags);
+	if (ret != 0)
 		return 0;
-	}
 
 
 	packetlen = desc.len8 << 3;
@@ -806,8 +799,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	*buffer_actual_len = packetlen;
 
 	if (packetlen > bufferlen) {
-		spin_unlock_irqrestore(&channel->inbound_lock, flags);
-
 		pr_err("Buffer too small - needed %d bytes but "
 			"got space for only %d bytes\n",
 			packetlen, bufferlen);
@@ -819,7 +810,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	/* Copy over the entire packet to the user buffer */
 	ret = hv_ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
 
-	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 7a3ec75..6aab802 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -215,6 +215,7 @@ struct vmbus_channel *relid2channel(u32 relid)
 static void process_chn_event(u32 relid)
 {
 	struct vmbus_channel *channel;
+	unsigned long flags;
 
 	/*
 	 * Find the channel based on this relid and invokes the
@@ -222,11 +223,13 @@ static void process_chn_event(u32 relid)
 	 */
 	channel = relid2channel(relid);
 
+	spin_lock_irqsave(&channel->inbound_lock, flags);
 	if (channel && (channel->onchannel_callback != NULL)) {
 		channel->onchannel_callback(channel->channel_callback_context);
 	} else {
 		pr_err("channel not found for relid - %u\n", relid);
 	}
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 }
 
 /*
-- 
1.7.4.1

