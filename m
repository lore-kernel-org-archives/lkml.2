Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab1BKR6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:58:30 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41031
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757429Ab1BKR63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:58:29 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 2/3]: Staging: hv: Use native wait primitives
Date: Fri, 11 Feb 2011 09:59:43 -0800
Message-Id: <1297447183-21807-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for getting rid of the osd layer; change
the code to use native wait interfaces. As part of this,
fixed the buggy implementation in the osd_wait_primitive
where the condition was cleared potentially after the 
condition was signalled.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c       |   58 +++++++++-----------
 drivers/staging/hv/channel_mgmt.c  |   46 +++++++---------
 drivers/staging/hv/channel_mgmt.h  |    4 +-
 drivers/staging/hv/connection.c    |   28 +++++++---
 drivers/staging/hv/netvsc.c        |  102 ++++++++++++++++++-----------------
 drivers/staging/hv/netvsc.h        |    3 +-
 drivers/staging/hv/rndis_filter.c  |   38 +++++++++----
 drivers/staging/hv/storvsc.c       |   98 ++++++++++++++++++++--------------
 drivers/staging/hv/vmbus_private.h |    3 +-
 9 files changed, 208 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 6c292e6..5a0923c 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -243,11 +245,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto errorout;
 	}
 
-	openInfo->waitevent = osd_waitevent_create();
-	if (!openInfo->waitevent) {
-		err = -ENOMEM;
-		goto errorout;
-	}
+	init_waitqueue_head(&openInfo->waitevent);
 
 	openMsg = (struct vmbus_channel_open_channel *)openInfo->msg;
 	openMsg->header.msgtype = CHANNELMSG_OPENCHANNEL;
@@ -280,8 +278,15 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto Cleanup;
 	}
 
-	/* FIXME: Need to time-out here */
-	osd_waitevent_wait(openInfo->waitevent);
+	openInfo->wait_condition = 0;
+	wait_event_timeout(openInfo->waitevent,
+			openInfo->wait_condition,
+			msecs_to_jiffies(1000));
+	if (openInfo->wait_condition == 0) {
+		err = -ETIMEDOUT;
+		goto errorout;
+	}
+
 
 	if (openInfo->response.open_result.status == 0)
 		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
@@ -294,7 +299,6 @@ Cleanup:
 	list_del(&openInfo->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	kfree(openInfo->waitevent);
 	kfree(openInfo);
 	return 0;
 
@@ -509,11 +513,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	if (ret)
 		return ret;
 
-	msginfo->waitevent = osd_waitevent_create();
-	if (!msginfo->waitevent) {
-		ret = -ENOMEM;
-		goto Cleanup;
-	}
+	init_waitqueue_head(&msginfo->waitevent);
 
 	gpadlmsg = (struct vmbus_channel_gpadl_header *)msginfo->msg;
 	gpadlmsg->header.msgtype = CHANNELMSG_GPADL_HEADER;
@@ -533,6 +533,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
 		   msginfo->msgsize - sizeof(*msginfo));
 
+	msginfo->wait_condition = 0;
 	ret = vmbus_post_msg(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
 	if (ret != 0) {
@@ -566,7 +567,11 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 		}
 	}
-	osd_waitevent_wait(msginfo->waitevent);
+	wait_event_timeout(msginfo->waitevent,
+				msginfo->wait_condition,
+				msecs_to_jiffies(1000));
+	BUG_ON(msginfo->wait_condition == 0);
+
 
 	/* At this point, we received the gpadl created msg */
 	DPRINT_DBG(VMBUS, "Received GPADL created "
@@ -582,7 +587,6 @@ Cleanup:
 	list_del(&msginfo->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	kfree(msginfo->waitevent);
 	kfree(msginfo);
 	return ret;
 }
@@ -605,11 +609,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	if (!info)
 		return -ENOMEM;
 
-	info->waitevent = osd_waitevent_create();
-	if (!info->waitevent) {
-		kfree(info);
-		return -ENOMEM;
-	}
+	init_waitqueue_head(&info->waitevent);
 
 	msg = (struct vmbus_channel_gpadl_teardown *)info->msg;
 
@@ -621,22 +621,20 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	list_add_tail(&info->msglistentry,
 		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-
+	info->wait_condition = 0;
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
-	if (ret != 0) {
-		/* TODO: */
-		/* something... */
-	}
 
-	osd_waitevent_wait(info->waitevent);
+	BUG_ON(ret != 0);
+	wait_event_timeout(info->waitevent,
+			info->wait_condition, msecs_to_jiffies(1000));
+	BUG_ON(info->wait_condition == 0);
 
 	/* Received a torndown response */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	kfree(info->waitevent);
 	kfree(info);
 	return ret;
 }
@@ -664,18 +662,14 @@ void vmbus_close(struct vmbus_channel *channel)
 	if (!info)
 		return;
 
-	/* info->waitEvent = osd_waitevent_create(); */
 
 	msg = (struct vmbus_channel_close_channel *)info->msg;
 	msg->header.msgtype = CHANNELMSG_CLOSECHANNEL;
 	msg->child_relid = channel->offermsg.child_relid;
 
 	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
-	if (ret != 0) {
-		/* TODO: */
-		/* something... */
-	}
 
+	BUG_ON(ret != 0);
 	/* Tear down the gpadl for the channel's ring buffer */
 	if (channel->ringbuffer_gpadlhandle)
 		vmbus_teardown_gpadl(channel,
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index a9c9d49..da1e56a 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -593,7 +595,8 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 				memcpy(&msginfo->response.open_result,
 				       result,
 				       sizeof(struct vmbus_channel_open_result));
-				osd_waitevent_set(msginfo->waitevent);
+				msginfo->wait_condition = 1;
+				wake_up(&msginfo->waitevent);
 				break;
 			}
 		}
@@ -643,7 +646,8 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 				memcpy(&msginfo->response.gpadl_created,
 				       gpadlcreated,
 				       sizeof(struct vmbus_channel_gpadl_created));
-				osd_waitevent_set(msginfo->waitevent);
+				msginfo->wait_condition = 1;
+				wake_up(&msginfo->waitevent);
 				break;
 			}
 		}
@@ -689,7 +693,8 @@ static void vmbus_ongpadl_torndown(
 				memcpy(&msginfo->response.gpadl_torndown,
 				       gpadl_torndown,
 				       sizeof(struct vmbus_channel_gpadl_torndown));
-				osd_waitevent_set(msginfo->waitevent);
+				msginfo->wait_condition = 1;
+				wake_up(&msginfo->waitevent);
 				break;
 			}
 		}
@@ -730,7 +735,8 @@ static void vmbus_onversion_response(
 			memcpy(&msginfo->response.version_response,
 			      version_response,
 			      sizeof(struct vmbus_channel_version_response));
-			osd_waitevent_set(msginfo->waitevent);
+			msginfo->wait_condition = 1;
+			wake_up(&msginfo->waitevent);
 		}
 	}
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
@@ -805,44 +811,34 @@ int vmbus_request_offers(void)
 	if (!msginfo)
 		return -ENOMEM;
 
-	msginfo->waitevent = osd_waitevent_create();
-	if (!msginfo->waitevent) {
-		kfree(msginfo);
-		return -ENOMEM;
-	}
+	init_waitqueue_head(&msginfo->waitevent);
 
 	msg = (struct vmbus_channel_message_header *)msginfo->msg;
 
 	msg->msgtype = CHANNELMSG_REQUESTOFFERS;
 
-	/*SpinlockAcquire(gVmbusConnection.channelMsgLock);
-	INSERT_TAIL_LIST(&gVmbusConnection.channelMsgList,
-			 &msgInfo->msgListEntry);
-	SpinlockRelease(gVmbusConnection.channelMsgLock);*/
 
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_message_header));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "Unable to request offers - %d", ret);
 
-		/*SpinlockAcquire(gVmbusConnection.channelMsgLock);
-		REMOVE_ENTRY_LIST(&msgInfo->msgListEntry);
-		SpinlockRelease(gVmbusConnection.channelMsgLock);*/
+		goto cleanup;
+	}
 
-		goto Cleanup;
+	msginfo->wait_condition = 0;
+	wait_event_timeout(msginfo->waitevent, msginfo->wait_condition,
+			msecs_to_jiffies(1000));
+	if (msginfo->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
 	}
-	/* osd_waitevent_wait(msgInfo->waitEvent); */
 
-	/*SpinlockAcquire(gVmbusConnection.channelMsgLock);
-	REMOVE_ENTRY_LIST(&msgInfo->msgListEntry);
-	SpinlockRelease(gVmbusConnection.channelMsgLock);*/
 
 
-Cleanup:
-	if (msginfo) {
-		kfree(msginfo->waitevent);
+cleanup:
+	if (msginfo)
 		kfree(msginfo);
-	}
 
 	return ret;
 }
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index fe40bf2..3368bf1 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -289,8 +289,8 @@ struct vmbus_channel_msginfo {
 	struct list_head submsglist;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *waitevent;
-
+	int wait_condition;
+	wait_queue_head_t waitevent;
 	union {
 		struct vmbus_channel_version_supported version_supported;
 		struct vmbus_channel_open_result open_result;
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index ed0976a..51dd362 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -21,6 +21,8 @@
  *
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -97,11 +99,7 @@ int vmbus_connect(void)
 		goto Cleanup;
 	}
 
-	msginfo->waitevent = osd_waitevent_create();
-	if (!msginfo->waitevent) {
-		ret = -ENOMEM;
-		goto Cleanup;
-	}
+	init_waitqueue_head(&msginfo->waitevent);
 
 	msg = (struct vmbus_channel_initiate_contact *)msginfo->msg;
 
@@ -131,14 +129,30 @@ int vmbus_connect(void)
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_initiate_contact));
 	if (ret != 0) {
+		spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 		list_del(&msginfo->msglistentry);
+		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
+					flags);
 		goto Cleanup;
 	}
 
 	/* Wait for the connection response */
-	osd_waitevent_wait(msginfo->waitevent);
+	msginfo->wait_condition = 0;
+	wait_event_timeout(msginfo->waitevent, msginfo->wait_condition,
+			msecs_to_jiffies(1000));
+	if (msginfo->wait_condition == 0) {
+		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
+				flags);
+		list_del(&msginfo->msglistentry);
+		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
+					flags);
+		ret = -ETIMEDOUT;
+		goto Cleanup;
+	}
 
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	/* Check if successful */
 	if (msginfo->response.version_response.version_supported) {
@@ -153,7 +167,6 @@ int vmbus_connect(void)
 		goto Cleanup;
 	}
 
-	kfree(msginfo->waitevent);
 	kfree(msginfo);
 	return 0;
 
@@ -174,7 +187,6 @@ Cleanup:
 	}
 
 	if (msginfo) {
-		kfree(msginfo->waitevent);
 		kfree(msginfo);
 	}
 
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index a271aa7..7233564 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -230,7 +232,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			   "unable to allocate receive buffer of size %d",
 			   net_device->recv_buf_size);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 	/* page-aligned buffer */
 	/* ASSERT(((unsigned long)netDevice->ReceiveBuffer & (PAGE_SIZE - 1)) == */
@@ -249,10 +251,9 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to establish receive buffer's gpadl");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	/* osd_waitevent_wait(ext->ChannelInitEvent); */
 
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendReceiveBuffer...");
@@ -268,6 +269,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		send_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
 
 	/* Send the gpadl notification request */
+	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -276,10 +278,14 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to send receive buffer's gpadl to netvsp");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(net_device->channel_init_event);
+	wait_event_timeout(net_device->channel_init_wait,
+			net_device->wait_condition,
+			msecs_to_jiffies(1000));
+	BUG_ON(net_device->wait_condition == 0);
+
 
 	/* Check the response */
 	if (init_packet->msg.v1_msg.
@@ -289,7 +295,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			   init_packet->msg.v1_msg.
 			   send_recv_buf_complete.status);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* Parse the response */
@@ -303,7 +309,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		* sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
 	if (net_device->recv_section == NULL) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	memcpy(net_device->recv_section,
@@ -327,15 +333,15 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (net_device->recv_section_cnt != 1 ||
 	    net_device->recv_section->offset != 0) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	goto Exit;
+	goto exit;
 
-Cleanup:
+cleanup:
 	netvsc_destroy_recv_buf(net_device);
 
-Exit:
+exit:
 	put_net_device(device);
 	return ret;
 }
@@ -354,7 +360,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	}
 	if (net_device->send_buf_size <= 0) {
 		ret = -EINVAL;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* page-size grandularity */
@@ -367,7 +373,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
 			   net_device->send_buf_size);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 	/* page-aligned buffer */
 	/* ASSERT(((unsigned long)netDevice->SendBuffer & (PAGE_SIZE - 1)) == 0); */
@@ -384,11 +390,9 @@ static int netvsc_init_send_buf(struct hv_device *device)
 				    &net_device->send_buf_gpadl_handle);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to establish send buffer's gpadl");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	/* osd_waitevent_wait(ext->ChannelInitEvent); */
-
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendSendBuffer...");
 
@@ -403,6 +407,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		NETVSC_SEND_BUFFER_ID;
 
 	/* Send the gpadl notification request */
+	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -411,10 +416,13 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to send receive buffer's gpadl to netvsp");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(net_device->channel_init_event);
+	wait_event_timeout(net_device->channel_init_wait,
+			net_device->wait_condition,
+			msecs_to_jiffies(1000));
+	BUG_ON(net_device->wait_condition == 0);
 
 	/* Check the response */
 	if (init_packet->msg.v1_msg.
@@ -424,18 +432,18 @@ static int netvsc_init_send_buf(struct hv_device *device)
 			   init_packet->msg.v1_msg.
 			   send_send_buf_complete.status);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	net_device->send_section_size = init_packet->
 	msg.v1_msg.send_send_buf_complete.section_size;
 
-	goto Exit;
+	goto exit;
 
-Cleanup:
+cleanup:
 	netvsc_destroy_send_buf(net_device);
 
-Exit:
+exit:
 	put_net_device(device);
 	return ret;
 }
@@ -611,6 +619,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	DPRINT_INFO(NETVSC, "Sending NvspMessageTypeInit...");
 
 	/* Send the init request */
+	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -619,10 +628,16 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to send NvspMessageTypeInit");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(net_device->channel_init_event);
+	wait_event_timeout(net_device->channel_init_wait,
+			net_device->wait_condition,
+			msecs_to_jiffies(1000));
+	if (net_device->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
 	/* Now, check the response */
 	/* ASSERT(initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength <= MAX_MULTIPAGE_BUFFER_COUNT); */
@@ -637,7 +652,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 			"unable to initialize with netvsp (status 0x%x)",
 			init_packet->msg.init_msg.init_complete.status);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	if (init_packet->msg.init_msg.init_complete.
@@ -647,7 +662,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 			   init_packet->msg.init_msg.
 			   init_complete.negotiated_protocol_ver);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendNdisVersion...");
 
@@ -666,29 +681,22 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	/* Send the init request */
 	ret = vmbus_sendpacket(device->channel, init_packet,
-			       sizeof(struct nvsp_message),
-			       (unsigned long)init_packet,
-			       VM_PKT_DATA_INBAND, 0);
+				sizeof(struct nvsp_message),
+				(unsigned long)init_packet,
+				VM_PKT_DATA_INBAND, 0);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to send NvspMessage1TypeSendNdisVersion");
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
-	/*
-	 * BUGBUG - We have to wait for the above msg since the
-	 * netvsp uses KMCL which acknowledges packet (completion
-	 * packet) since our Vmbus always set the
-	 * VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED flag
-	 */
-	 /* osd_waitevent_wait(NetVscChannel->ChannelInitEvent); */
 
 	/* Post the big receive buffer to NetVSP */
 	ret = netvsc_init_recv_buf(device);
 	if (ret == 0)
 		ret = netvsc_init_send_buf(device);
 
-Cleanup:
+cleanup:
 	put_net_device(device);
 	return ret;
 }
@@ -715,7 +723,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	net_device = alloc_net_device(device);
 	if (!net_device) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	DPRINT_DBG(NETVSC, "netvsc channel object allocated - %p", net_device);
@@ -741,11 +749,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 		list_add_tail(&packet->list_ent,
 			      &net_device->recv_pkt_list);
 	}
-	net_device->channel_init_event = osd_waitevent_create();
-	if (!net_device->channel_init_event) {
-		ret = -ENOMEM;
-		goto Cleanup;
-	}
+	init_waitqueue_head(&net_device->channel_init_wait);
 
 	/* Open the channel */
 	ret = vmbus_open(device->channel, net_driver->ring_buf_size,
@@ -755,7 +759,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to open channel: %d", ret);
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* Channel is opened */
@@ -778,11 +782,9 @@ close:
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
 
-Cleanup:
+cleanup:
 
 	if (net_device) {
-		kfree(net_device->channel_init_event);
-
 		list_for_each_entry_safe(packet, pos,
 					 &net_device->recv_pkt_list,
 					 list_ent) {
@@ -847,7 +849,6 @@ static int netvsc_device_remove(struct hv_device *device)
 		kfree(netvsc_packet);
 	}
 
-	kfree(net_device->channel_init_event);
 	free_net_device(net_device);
 	return 0;
 }
@@ -887,7 +888,8 @@ static void netvsc_send_completion(struct hv_device *device,
 		/* Copy the response back */
 		memcpy(&net_device->channel_init_pkt, nvsp_packet,
 		       sizeof(struct nvsp_message));
-		osd_waitevent_set(net_device->channel_init_event);
+		net_device->wait_condition = 1;
+		wake_up(&net_device->channel_init_wait);
 	} else if (nvsp_packet->hdr.msg_type ==
 		   NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE) {
 		/* Get the send context */
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index 5f6dcf1..45d24b9 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -318,7 +318,8 @@ struct netvsc_device {
 	struct nvsp_1_receive_buffer_section *recv_section;
 
 	/* Used for NetVSP initialization protocol */
-	struct osd_waitevent *channel_init_event;
+	int wait_condition;
+	wait_queue_head_t channel_init_wait;
 	struct nvsp_message channel_init_pkt;
 
 	struct nvsp_message revoke_packet;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 287e12e..e3bf004 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -57,7 +59,8 @@ struct rndis_device {
 
 struct rndis_request {
 	struct list_head list_ent;
-	struct osd_waitevent *waitevent;
+	int wait_condition;
+	wait_queue_head_t wait_event;
 
 	/*
 	 * FIXME: We assumed a fixed size response here. If we do ever need to
@@ -129,11 +132,7 @@ static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 	if (!request)
 		return NULL;
 
-	request->waitevent = osd_waitevent_create();
-	if (!request->waitevent) {
-		kfree(request);
-		return NULL;
-	}
+	init_waitqueue_head(&request->wait_event);
 
 	rndis_msg = &request->request_msg;
 	rndis_msg->ndis_msg_type = msg_type;
@@ -164,7 +163,6 @@ static void put_rndis_request(struct rndis_device *dev,
 	list_del(&req->list_ent);
 	spin_unlock_irqrestore(&dev->request_lock, flags);
 
-	kfree(req->waitevent);
 	kfree(req);
 }
 
@@ -321,7 +319,8 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 			}
 		}
 
-		osd_waitevent_set(request->waitevent);
+		request->wait_condition = 1;
+		wake_up(&request->wait_event);
 	} else {
 		DPRINT_ERR(NETVSC, "no rndis request found for this response "
 			   "(id 0x%x res type 0x%x)",
@@ -503,11 +502,17 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	query->info_buflen = 0;
 	query->dev_vc_handle = 0;
 
+	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_waitevent_wait(request->waitevent);
+	wait_event_timeout(request->wait_event, request->wait_condition,
+				msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto Cleanup;
+	}
 
 	/* Copy the response back */
 	query_complete = &request->response_msg.msg.query_complete;
@@ -578,12 +583,14 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
 	       &new_filter, sizeof(u32));
 
+	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	ret = osd_waitevent_waitex(request->waitevent, 2000/*2sec*/);
-	if (!ret) {
+	wait_event_timeout(request->wait_event, request->wait_condition,
+		msecs_to_jiffies(2000));
+	if (request->wait_condition == 0) {
 		ret = -1;
 		DPRINT_ERR(NETVSC, "timeout before we got a set response...");
 		/*
@@ -669,13 +676,20 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
+	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0) {
 		dev->state = RNDIS_DEV_UNINITIALIZED;
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->waitevent);
+
+	wait_event_timeout(request->wait_event, request->wait_condition,
+		msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto Cleanup;
+	}
 
 	init_complete = &request->response_msg.msg.init_complete;
 	status = init_complete->status;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index a612109..2560342 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -19,6 +19,8 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -38,7 +40,8 @@ struct storvsc_request_extension {
 	struct hv_device *device;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *wait_event;
+	int wait_condition;
+	wait_queue_head_t wait_event;
 
 	struct vstor_packet vstor_packet;
 };
@@ -200,21 +203,13 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	 * channel
 	 */
 	memset(request, 0, sizeof(struct storvsc_request_extension));
-	request->wait_event = osd_waitevent_create();
-	if (!request->wait_event) {
-		ret = -ENOMEM;
-		goto nomem;
-	}
-
+	init_waitqueue_head(&request->wait_event);
 	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	/*SpinlockAcquire(gDriverExt.packetListLock);
-	INSERT_TAIL_LIST(&gDriverExt.packetList, &packet->listEntry.entry);
-	SpinlockRelease(gDriverExt.packetListLock);*/
-
 	DPRINT_INFO(STORVSC, "BEGIN_INITIALIZATION_OPERATION...");
 
+	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -223,17 +218,23 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
 			   "unable to send BEGIN_INITIALIZATION_OPERATION");
-		goto Cleanup;
+		goto cleanup;
+	}
+
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(request->wait_event);
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "BEGIN_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
 			   vstor_packet->operation, vstor_packet->status);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	DPRINT_INFO(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION...");
@@ -246,6 +247,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
 	FILL_VMSTOR_REVISION(vstor_packet->version.revision);
 
+	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -254,10 +256,15 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
 			   "unable to send BEGIN_INITIALIZATION_OPERATION");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(request->wait_event);
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
 	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
@@ -265,7 +272,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		DPRINT_ERR(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION failed "
 			   "(op %d status 0x%x)",
 			   vstor_packet->operation, vstor_packet->status);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* Query channel properties */
@@ -277,6 +284,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->storage_channel_properties.port_number =
 					stor_device->port_number;
 
+	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -286,10 +294,15 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
 			   "unable to send QUERY_PROPERTIES_OPERATION");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(request->wait_event);
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
 	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
@@ -297,7 +310,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 		DPRINT_ERR(STORVSC, "QUERY_PROPERTIES_OPERATION failed "
 			   "(op %d status 0x%x)",
 			   vstor_packet->operation, vstor_packet->status);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
@@ -314,6 +327,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
+	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
@@ -323,25 +337,27 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
 			   "unable to send END_INITIALIZATION_OPERATION");
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	osd_waitevent_wait(request->wait_event);
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "END_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
 			   vstor_packet->operation, vstor_packet->status);
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	DPRINT_INFO(STORVSC, "**** storage channel up and running!! ****");
 
-Cleanup:
-	kfree(request->wait_event);
-	request->wait_event = NULL;
-nomem:
+cleanup:
 	put_stor_device(device);
 	return ret;
 }
@@ -476,8 +492,8 @@ static void stor_vsc_on_channel_callback(void *context)
 
 				memcpy(&request->vstor_packet, packet,
 				       sizeof(struct vstor_packet));
-
-				osd_waitevent_set(request->wait_event);
+				request->wait_condition = 1;
+				wake_up(&request->wait_event);
 			} else {
 				stor_vsc_on_receive(device,
 						(struct vstor_packet *)packet,
@@ -539,7 +555,7 @@ static int stor_vsc_on_device_add(struct hv_device *device,
 	stor_device = alloc_stor_device(device);
 	if (!stor_device) {
 		ret = -1;
-		goto Cleanup;
+		goto cleanup;
 	}
 
 	/* Save the channel properties to our storvsc channel */
@@ -569,7 +585,7 @@ static int stor_vsc_on_device_add(struct hv_device *device,
 		   stor_device->port_number, stor_device->path_id,
 		   stor_device->target_id);
 
-Cleanup:
+cleanup:
 	return ret;
 }
 
@@ -629,16 +645,13 @@ int stor_vsc_on_host_reset(struct hv_device *device)
 	request = &stor_device->reset_request;
 	vstor_packet = &request->vstor_packet;
 
-	request->wait_event = osd_waitevent_create();
-	if (!request->wait_event) {
-		ret = -ENOMEM;
-		goto Cleanup;
-	}
+	init_waitqueue_head(&request->wait_event);
 
 	vstor_packet->operation = VSTOR_OPERATION_RESET_BUS;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 	vstor_packet->vm_srb.path_id = stor_device->path_id;
 
+	request->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)&stor_device->reset_request,
@@ -647,13 +660,16 @@ int stor_vsc_on_host_reset(struct hv_device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
 			   vstor_packet, ret);
-		goto Cleanup;
+		goto cleanup;
 	}
 
-	/* FIXME: Add a timeout */
-	osd_waitevent_wait(request->wait_event);
+	wait_event_timeout(request->wait_event, request->wait_condition,
+			msecs_to_jiffies(1000));
+	if (request->wait_condition == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
 
-	kfree(request->wait_event);
 	DPRINT_INFO(STORVSC, "host adapter reset completed");
 
 	/*
@@ -661,7 +677,7 @@ int stor_vsc_on_host_reset(struct hv_device *device)
 	 * should have been flushed out and return to us
 	 */
 
-Cleanup:
+cleanup:
 	put_stor_device(device);
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 004d8de..9f505c4 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -91,7 +91,8 @@ struct vmbus_msginfo {
 	struct list_head msglist_entry;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *wait_event;
+	int wait_condition;
+	wait_queue_head_t  wait_event;
 
 	/* The message itself */
 	unsigned char msg[0];
-- 
1.5.5.6

