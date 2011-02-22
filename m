Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1BVXYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:24:11 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53727
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752037Ab1BVXYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:24:09 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/6] Staging: hv: channel.c Removed debug DPRINTS use pr_err for errors
Date: Tue, 22 Feb 2011 15:32:42 -0800
Message-Id: <1298417565-12356-3-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This group of patches removes all DPRINT from hv_vmbus.ko.
It is divided in several patches due to size.

All DPRINT calls have been removed, and where needed have been
replaced with pr_XX native calls. Many debug DPRINT calls have
been removed outright.

The amount of clutter this driver prints has been 
significantly reduced.

Several DPRINT calls remain in this file, they will be removed
in a subsequent patch. They are designed to print out a common
debug stream that will be implemented differently.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/channel.c |   71 ++++++-----------------------------------
 1 files changed, 11 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 775a52a..654e80c 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -213,9 +213,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 
 	/* Establish the gpadl for the ring buffer */
-	DPRINT_DBG(VMBUS, "Establishing ring buffer's gpadl for channel %p...",
-		   newchannel);
-
 	newchannel->ringbuffer_gpadlhandle = 0;
 
 	ret = vmbus_establish_gpadl(newchannel,
@@ -229,16 +226,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto errorout;
 	}
 
-	DPRINT_DBG(VMBUS, "channel %p <relid %d gpadl 0x%x send ring %p "
-		   "size %d recv ring %p size %d, downstreamoffset %d>",
-		   newchannel, newchannel->offermsg.child_relid,
-		   newchannel->ringbuffer_gpadlhandle,
-		   newchannel->outbound.ring_buffer,
-		   newchannel->outbound.ring_size,
-		   newchannel->inbound.ring_buffer,
-		   newchannel->inbound.ring_size,
-		   send_ringbuffer_size);
-
 	/* Create and init the channel open message */
 	openInfo = kmalloc(sizeof(*openInfo) +
 			   sizeof(struct vmbus_channel_open_channel),
@@ -272,12 +259,11 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	DPRINT_DBG(VMBUS, "Sending channel open msg...");
-
 	ret = vmbus_post_msg(openMsg,
 			       sizeof(struct vmbus_channel_open_channel));
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "unable to open channel - %d", ret);
+		pr_err("%s: %s Unable to open channel - %d",
+		       VMBUS_MOD, __func__, ret);
 		goto Cleanup;
 	}
 
@@ -291,10 +277,9 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 
-	if (openInfo->response.open_result.status == 0)
-		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
-	else
-		DPRINT_INFO(VMBUS, "channel <%p> open failed - %d!!",
+	if (openInfo->response.open_result.status)
+		pr_err("%s: %s Channel <%p> open failed - %d!!",
+		       VMBUS_MOD, __func__,
 			    newchannel, openInfo->response.open_result.status);
 
 Cleanup:
@@ -530,17 +515,13 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 		      &vmbus_connection.chn_msg_list);
 
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-	DPRINT_DBG(VMBUS, "buffer %p, size %d msg cnt %d",
-		   kbuffer, size, msgcount);
-
-	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
-		   msginfo->msgsize - sizeof(*msginfo));
 
 	msginfo->wait_condition = 0;
 	ret = vmbus_post_msg(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "Unable to open channel - %d", ret);
+		pr_err("%s: %s Unable to open channel - %d",
+		       VMBUS_MOD, __func__, ret);
 		goto Cleanup;
 	}
 
@@ -556,10 +537,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 				CHANNELMSG_GPADL_BODY;
 			gpadl_body->gpadl = next_gpadl_handle;
 
-			DPRINT_DBG(VMBUS, "Sending GPADL Body - len %zd",
-				   submsginfo->msgsize -
-				   sizeof(*submsginfo));
-
 			dump_gpadl_body(gpadl_body, submsginfo->msgsize -
 				      sizeof(*submsginfo));
 			ret = vmbus_post_msg(gpadl_body,
@@ -577,12 +554,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 
 	/* At this point, we received the gpadl created msg */
-	DPRINT_DBG(VMBUS, "Received GPADL created "
-		   "(relid %d, status %d handle %x)",
-		   channel->offermsg.child_relid,
-		   msginfo->response.gpadl_created.creation_status,
-		   gpadlmsg->gpadl);
-
 	*gpadl_handle = gpadlmsg->gpadl;
 
 Cleanup:
@@ -730,9 +701,6 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	u64 aligned_data = 0;
 	int ret;
 
-	DPRINT_DBG(VMBUS, "channel %p buffer %p len %d",
-		   channel, buffer, bufferlen);
-
 	dump_vmbus_channel(channel);
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
@@ -846,10 +814,6 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 
 	dump_vmbus_channel(channel);
 
-	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
-		multi_pagebuffer->offset,
-		multi_pagebuffer->len, pfncount);
-
 	if ((pfncount < 0) || (pfncount > MAX_MULTIPAGE_BUFFER_COUNT))
 		return -EINVAL;
 
@@ -927,7 +891,6 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
 	}
 
@@ -937,18 +900,13 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	userlen = packetlen - (desc.offset8 << 3);
 	/* ASSERT(userLen > 0); */
 
-	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
-		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.type,
-		   desc.flags, desc.trans_id, packetlen, userlen);
-
 	*buffer_actual_len = userlen;
 
 	if (userlen > bufferlen) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		DPRINT_ERR(VMBUS, "buffer too small - got %d needs %d",
-			   bufferlen, userlen);
+		pr_err("%s: %s Buffer too small - got %d need %d",
+		       VMBUS_MOD, __func__, bufferlen, userlen);
 		return -1;
 	}
 
@@ -987,7 +945,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
 	}
 
@@ -996,18 +953,13 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	packetlen = desc.len8 << 3;
 	userlen = packetlen - (desc.offset8 << 3);
 
-	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
-		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.type,
-		   desc.flags, desc.trans_id, packetlen, userlen);
-
 	*buffer_actual_len = packetlen;
 
 	if (packetlen > bufferlen) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
-		DPRINT_ERR(VMBUS, "buffer too small - needed %d bytes but "
-			   "got space for only %d bytes", packetlen, bufferlen);
+		pr_err("%s: %s Buffer too small - needed %d bytes got "
+		       "%d bytes", VMBUS_MOD, __func__, packetlen, bufferlen);
 		return -2;
 	}
 
@@ -1050,7 +1002,6 @@ void vmbus_ontimer(unsigned long data)
  */
 static void dump_vmbus_channel(struct vmbus_channel *channel)
 {
-	DPRINT_DBG(VMBUS, "Channel (%d)", channel->offermsg.child_relid);
 	dump_ring_info(&channel->outbound, "Outbound ");
 	dump_ring_info(&channel->inbound, "Inbound ");
 }
-- 
1.6.0.2

