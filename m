Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1AZUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:05:27 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52200
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753971Ab1AZUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:05:24 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 2/8] staging: hv: Convert camel cased functions in connection.c to lower cases
Date: Wed, 26 Jan 2011 12:12:08 -0800
Message-Id: <1296072734-11963-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296072734-11963-1-git-send-email-haiyangz@microsoft.com>
References: <1296072734-11963-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c       |   12 +++++-----
 drivers/staging/hv/channel_mgmt.c  |    4 +-
 drivers/staging/hv/connection.c    |   39 +++++++++++++++++++----------------
 drivers/staging/hv/vmbus_drv.c     |    6 ++--
 drivers/staging/hv/vmbus_private.h |   12 +++++-----
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 99b2d2a..ca76098 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -88,7 +88,7 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 					[channel->monitor_grp].pending);
 
 	} else {
-		VmbusSetEvent(channel->offermsg.child_relid);
+		vmbus_set_event(channel->offermsg.child_relid);
 	}
 }
 
@@ -272,7 +272,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	DPRINT_DBG(VMBUS, "Sending channel open msg...");
 
-	ret = VmbusPostMessage(openMsg,
+	ret = vmbus_post_msg(openMsg,
 			       sizeof(struct vmbus_channel_open_channel));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "unable to open channel - %d", ret);
@@ -532,7 +532,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
 		   msginfo->msgsize - sizeof(*msginfo));
 
-	ret = VmbusPostMessage(gpadlmsg, msginfo->msgsize -
+	ret = vmbus_post_msg(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "Unable to open channel - %d", ret);
@@ -557,7 +557,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 			dump_gpadl_body(gpadl_body, submsginfo->msgsize -
 				      sizeof(*submsginfo));
-			ret = VmbusPostMessage(gpadl_body,
+			ret = vmbus_post_msg(gpadl_body,
 					       submsginfo->msgsize -
 					       sizeof(*submsginfo));
 			if (ret != 0)
@@ -621,7 +621,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 		      &vmbus_connection.ChannelMsgList);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	ret = VmbusPostMessage(msg,
+	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
 	if (ret != 0) {
 		/* TODO: */
@@ -669,7 +669,7 @@ void vmbus_close(struct vmbus_channel *channel)
 	msg->header.msgtype = CHANNELMSG_CLOSECHANNEL;
 	msg->child_relid = channel->offermsg.child_relid;
 
-	ret = VmbusPostMessage(msg, sizeof(struct vmbus_channel_close_channel));
+	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
 	if (ret != 0) {
 		/* TODO: */
 		/* something... */
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 351ebeb..0ce8f54 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -532,7 +532,7 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 	struct vmbus_channel *channel;
 
 	rescind = (struct vmbus_channel_rescind_offer *)hdr;
-	channel = GetChannelFromRelId(rescind->child_relid);
+	channel = relid2channel(rescind->child_relid);
 	if (channel == NULL) {
 		DPRINT_DBG(VMBUS, "channel not found for relId %d",
 			   rescind->child_relid);
@@ -820,7 +820,7 @@ int vmbus_request_offers(void)
 			 &msgInfo->msgListEntry);
 	SpinlockRelease(gVmbusConnection.channelMsgLock);*/
 
-	ret = VmbusPostMessage(msg,
+	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_message_header));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "Unable to request offers - %d", ret);
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index a30b98d..002e86c 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -35,9 +35,9 @@ struct VMBUS_CONNECTION vmbus_connection = {
 };
 
 /*
- * VmbusConnect - Sends a connect request on the partition service connection
+ * vmbus_connect - Sends a connect request on the partition service connection
  */
-int VmbusConnect(void)
+int vmbus_connect(void)
 {
 	int ret = 0;
 	struct vmbus_channel_msginfo *msginfo = NULL;
@@ -126,7 +126,7 @@ int VmbusConnect(void)
 		   msg->interrupt_page, msg->monitor_page1, msg->monitor_page2);
 
 	DPRINT_DBG(VMBUS, "Sending channel initiate msg...");
-	ret = VmbusPostMessage(msg,
+	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_initiate_contact));
 	if (ret != 0) {
 		list_del(&msginfo->msglistentry);
@@ -180,9 +180,10 @@ Cleanup:
 }
 
 /*
- * VmbusDisconnect - Sends a disconnect request on the partition service connection
+ * vmbus_disconnect -
+ * Sends a disconnect request on the partition service connection
  */
-int VmbusDisconnect(void)
+int vmbus_disconnect(void)
 {
 	int ret = 0;
 	struct vmbus_channel_message_header *msg;
@@ -197,7 +198,7 @@ int VmbusDisconnect(void)
 
 	msg->msgtype = CHANNELMSG_UNLOAD;
 
-	ret = VmbusPostMessage(msg,
+	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_message_header));
 	if (ret != 0)
 		goto Cleanup;
@@ -217,9 +218,10 @@ Cleanup:
 }
 
 /*
- * GetChannelFromRelId - Get the channel object given its child relative id (ie channel id)
+ * relid2channel - Get the channel object given its
+ * child relative id (ie channel id)
  */
-struct vmbus_channel *GetChannelFromRelId(u32 relid)
+struct vmbus_channel *relid2channel(u32 relid)
 {
 	struct vmbus_channel *channel;
 	struct vmbus_channel *found_channel  = NULL;
@@ -238,9 +240,9 @@ struct vmbus_channel *GetChannelFromRelId(u32 relid)
 }
 
 /*
- * VmbusProcessChannelEvent - Process a channel event notification
+ * process_chn_event - Process a channel event notification
  */
-static void VmbusProcessChannelEvent(void *context)
+static void process_chn_event(void *context)
 {
 	struct vmbus_channel *channel;
 	u32 relid = (u32)(unsigned long)context;
@@ -251,7 +253,7 @@ static void VmbusProcessChannelEvent(void *context)
 	 * Find the channel based on this relid and invokes the
 	 * channel callback to process the event
 	 */
-	channel = GetChannelFromRelId(relid);
+	channel = relid2channel(relid);
 
 	if (channel) {
 		vmbus_onchannel_event(channel);
@@ -266,9 +268,9 @@ static void VmbusProcessChannelEvent(void *context)
 }
 
 /*
- * VmbusOnEvents - Handler for events
+ * vmbus_on_event - Handler for events
  */
-void VmbusOnEvents(void)
+void vmbus_on_event(void)
 {
 	int dword;
 	int maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
@@ -294,7 +296,8 @@ void VmbusOnEvents(void)
 						} else {
 							/* QueueWorkItem(VmbusProcessEvent, (void*)relid); */
 							/* ret = WorkQueueQueueWorkItem(gVmbusConnection.workQueue, VmbusProcessChannelEvent, (void*)relid); */
-							VmbusProcessChannelEvent((void *)(unsigned long)relid);
+						process_chn_event((void *)
+						(unsigned long)relid);
 						}
 					}
 				}
@@ -305,9 +308,9 @@ void VmbusOnEvents(void)
 }
 
 /*
- * VmbusPostMessage - Send a msg on the vmbus's message connection
+ * vmbus_post_msg - Send a msg on the vmbus's message connection
  */
-int VmbusPostMessage(void *buffer, size_t buflen)
+int vmbus_post_msg(void *buffer, size_t buflen)
 {
 	union hv_connection_id conn_id;
 
@@ -317,9 +320,9 @@ int VmbusPostMessage(void *buffer, size_t buflen)
 }
 
 /*
- * VmbusSetEvent - Send an event notification to the parent
+ * vmbus_set_event - Send an event notification to the parent
  */
-int VmbusSetEvent(u32 child_relid)
+int vmbus_set_event(u32 child_relid)
 {
 	/* Each u32 represents 32 channels */
 	set_bit(child_relid & 31,
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index fd0881a..b33f497 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -174,7 +174,7 @@ static int VmbusOnDeviceAdd(struct hv_device *dev, void *AdditionalInfo)
 	on_each_cpu(hv_synic_init, (void *)irqvector, 1);
 
 	/* Connect to VMBus in the root partition */
-	ret = VmbusConnect();
+	ret = vmbus_connect();
 
 	/* VmbusSendEvent(device->localPortId+1); */
 	return ret;
@@ -188,7 +188,7 @@ static int VmbusOnDeviceRemove(struct hv_device *dev)
 	int ret = 0;
 
 	vmbus_release_unattached_channels();
-	VmbusDisconnect();
+	vmbus_disconnect();
 	on_each_cpu(hv_synic_cleanup, NULL, 1);
 	return ret;
 }
@@ -1045,7 +1045,7 @@ static void vmbus_msg_dpc(unsigned long data)
 static void vmbus_event_dpc(unsigned long data)
 {
 	/* Call to bus driver to handle interrupt */
-	VmbusOnEvents();
+	vmbus_on_event();
 }
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 9b51ac1..e3b0663 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -115,20 +115,20 @@ void vmbus_child_device_unregister(struct hv_device *device_obj);
 /* VmbusChildDeviceDestroy( */
 /* struct hv_device *); */
 
-struct vmbus_channel *GetChannelFromRelId(u32 relId);
+struct vmbus_channel *relid2channel(u32 relid);
 
 
 /* Connection interface */
 
-int VmbusConnect(void);
+int vmbus_connect(void);
 
-int VmbusDisconnect(void);
+int vmbus_disconnect(void);
 
-int VmbusPostMessage(void *buffer, size_t bufSize);
+int vmbus_post_msg(void *buffer, size_t buflen);
 
-int VmbusSetEvent(u32 childRelId);
+int vmbus_set_event(u32 child_relid);
 
-void VmbusOnEvents(void);
+void vmbus_on_event(void);
 
 
 #endif /* _VMBUS_PRIVATE_H_ */
-- 
1.6.3.2

