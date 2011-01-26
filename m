Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1AZRt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:49:57 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39510
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753431Ab1AZRty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:49:54 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 1/8] staging: hv: Convert camel cased variables in connection.c to lower cases
Date: Wed, 26 Jan 2011 09:49:59 -0800
Message-Id: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c       |   48 ++++++------
 drivers/staging/hv/channel_mgmt.c  |   48 ++++++------
 drivers/staging/hv/connection.c    |  154 ++++++++++++++++++------------------
 drivers/staging/hv/vmbus_drv.c     |    2 +-
 drivers/staging/hv/vmbus_private.h |    2 +-
 5 files changed, 128 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 69e7856..99b2d2a 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -77,10 +77,10 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 	if (channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
 		set_bit(channel->offermsg.child_relid & 31,
-			(unsigned long *) gVmbusConnection.SendInterruptPage +
+			(unsigned long *) vmbus_connection.SendInterruptPage +
 			(channel->offermsg.child_relid >> 5));
 
-		monitorpage = gVmbusConnection.MonitorPages;
+		monitorpage = vmbus_connection.MonitorPages;
 		monitorpage++; /* Get the child to parent monitor page */
 
 		set_bit(channel->monitor_bit,
@@ -100,11 +100,11 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 	if (Channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
 		clear_bit(Channel->offermsg.child_relid & 31,
-			  (unsigned long *)gVmbusConnection.SendInterruptPage +
+			  (unsigned long *)vmbus_connection.SendInterruptPage +
 			  (Channel->offermsg.child_relid >> 5));
 
 		monitorPage =
-			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
+			(struct hv_monitor_page *)vmbus_connection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
 		clear_bit(Channel->monitor_bit,
@@ -133,7 +133,7 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	       &channel->offermsg.offer.InterfaceInstance,
 	       sizeof(struct hv_guid));
 
-	monitorpage = (struct hv_monitor_page *)gVmbusConnection.MonitorPages;
+	monitorpage = (struct hv_monitor_page *)vmbus_connection.MonitorPages;
 
 	debuginfo->monitorid = channel->offermsg.monitorid;
 
@@ -265,10 +265,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	if (userdatalen)
 		memcpy(openMsg->userdata, userdata, userdatalen);
 
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&openInfo->msglistentry,
-		      &gVmbusConnection.ChannelMsgList);
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+		      &vmbus_connection.ChannelMsgList);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	DPRINT_DBG(VMBUS, "Sending channel open msg...");
 
@@ -289,9 +289,9 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 			    newchannel, openInfo->response.open_result.status);
 
 Cleanup:
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&openInfo->msglistentry);
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(openInfo->waitevent);
 	kfree(openInfo);
@@ -501,8 +501,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	unsigned long flags;
 	int ret = 0;
 
-	next_gpadl_handle = atomic_read(&gVmbusConnection.NextGpadlHandle);
-	atomic_inc(&gVmbusConnection.NextGpadlHandle);
+	next_gpadl_handle = atomic_read(&vmbus_connection.NextGpadlHandle);
+	atomic_inc(&vmbus_connection.NextGpadlHandle);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
@@ -521,11 +521,11 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 	dump_gpadl_header(gpadlmsg);
 
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&msginfo->msglistentry,
-		      &gVmbusConnection.ChannelMsgList);
+		      &vmbus_connection.ChannelMsgList);
 
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 	DPRINT_DBG(VMBUS, "buffer %p, size %d msg cnt %d",
 		   kbuffer, size, msgcount);
 
@@ -577,9 +577,9 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	*gpadl_handle = gpadlmsg->gpadl;
 
 Cleanup:
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(msginfo->waitevent);
 	kfree(msginfo);
@@ -616,10 +616,10 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	msg->child_relid = channel->offermsg.child_relid;
 	msg->gpadl = gpadl_handle;
 
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&info->msglistentry,
-		      &gVmbusConnection.ChannelMsgList);
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+		      &vmbus_connection.ChannelMsgList);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	ret = VmbusPostMessage(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
@@ -631,9 +631,9 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	osd_waitevent_wait(info->waitevent);
 
 	/* Received a torndown response */
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&info->msglistentry);
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(info->waitevent);
 	kfree(info);
@@ -697,9 +697,9 @@ void vmbus_close(struct vmbus_channel *channel)
 	 */
 
 	if (channel->state == CHANNEL_OPEN_STATE) {
-		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&channel->listentry);
-		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 		free_channel(channel);
 	}
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index fb71f88..351ebeb 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -308,7 +308,7 @@ void free_channel(struct vmbus_channel *channel)
 	 * ie we can't destroy ourselves.
 	 */
 	INIT_WORK(&channel->work, release_channel);
-	queue_work(gVmbusConnection.WorkQueue, &channel->work);
+	queue_work(vmbus_connection.WorkQueue, &channel->work);
 }
 
 
@@ -323,10 +323,10 @@ static void count_hv_channel(void)
 	static int counter;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 	if (++counter == MAX_MSG_TYPES)
 		complete(&hv_channel_ready);
-	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 }
 
 /*
@@ -361,9 +361,9 @@ static void vmbus_process_offer(struct work_struct *work)
 	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
 
 	/* Make sure this is a new offer */
-	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
-	list_for_each_entry(channel, &gVmbusConnection.ChannelList, listentry) {
+	list_for_each_entry(channel, &vmbus_connection.ChannelList, listentry) {
 		if (!memcmp(&channel->offermsg.offer.InterfaceType,
 			    &newchannel->offermsg.offer.InterfaceType,
 			    sizeof(struct hv_guid)) &&
@@ -377,9 +377,9 @@ static void vmbus_process_offer(struct work_struct *work)
 
 	if (fnew)
 		list_add_tail(&newchannel->listentry,
-			      &gVmbusConnection.ChannelList);
+			      &vmbus_connection.ChannelList);
 
-	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 	if (!fnew) {
 		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
@@ -412,9 +412,9 @@ static void vmbus_process_offer(struct work_struct *work)
 			   "unable to add child device object (relid %d)",
 			   newchannel->offermsg.child_relid);
 
-		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&newchannel->listentry);
-		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 		free_channel(newchannel);
 	} else {
@@ -577,9 +577,9 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
 	 */
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -598,7 +598,7 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 }
 
 /*
@@ -625,9 +625,9 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	 * Find the establish msg, copy the result and signal/unblock the wait
 	 * event
 	 */
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -648,7 +648,7 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 }
 
 /*
@@ -673,9 +673,9 @@ static void vmbus_ongpadl_torndown(
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
 	 */
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -694,7 +694,7 @@ static void vmbus_ongpadl_torndown(
 			}
 		}
 	}
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 }
 
 /*
@@ -715,9 +715,9 @@ static void vmbus_onversion_response(
 	unsigned long flags;
 
 	version_response = (struct vmbus_channel_version_response *)hdr;
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -733,7 +733,7 @@ static void vmbus_onversion_response(
 			osd_waitevent_set(msginfo->waitevent);
 		}
 	}
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 }
 
 /* Channel message dispatch table */
@@ -857,9 +857,9 @@ void vmbus_release_unattached_channels(void)
 	struct vmbus_channel *start = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
+	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
-	list_for_each_entry_safe(channel, pos, &gVmbusConnection.ChannelList,
+	list_for_each_entry_safe(channel, pos, &vmbus_connection.ChannelList,
 				 listentry) {
 		if (channel == start)
 			break;
@@ -878,7 +878,7 @@ void vmbus_release_unattached_channels(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 }
 
 /* eof */
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index c2e298f..a30b98d 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -29,7 +29,7 @@
 #include "vmbus_private.h"
 
 
-struct VMBUS_CONNECTION gVmbusConnection = {
+struct VMBUS_CONNECTION vmbus_connection = {
 	.ConnectState		= Disconnected,
 	.NextGpadlHandle	= ATOMIC_INIT(0xE1E10),
 };
@@ -40,86 +40,86 @@ struct VMBUS_CONNECTION gVmbusConnection = {
 int VmbusConnect(void)
 {
 	int ret = 0;
-	struct vmbus_channel_msginfo *msgInfo = NULL;
+	struct vmbus_channel_msginfo *msginfo = NULL;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
 
 	/* Make sure we are not connecting or connected */
-	if (gVmbusConnection.ConnectState != Disconnected)
+	if (vmbus_connection.ConnectState != Disconnected)
 		return -1;
 
 	/* Initialize the vmbus connection */
-	gVmbusConnection.ConnectState = Connecting;
-	gVmbusConnection.WorkQueue = create_workqueue("hv_vmbus_con");
-	if (!gVmbusConnection.WorkQueue) {
+	vmbus_connection.ConnectState = Connecting;
+	vmbus_connection.WorkQueue = create_workqueue("hv_vmbus_con");
+	if (!vmbus_connection.WorkQueue) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	INIT_LIST_HEAD(&gVmbusConnection.ChannelMsgList);
-	spin_lock_init(&gVmbusConnection.channelmsg_lock);
+	INIT_LIST_HEAD(&vmbus_connection.ChannelMsgList);
+	spin_lock_init(&vmbus_connection.channelmsg_lock);
 
-	INIT_LIST_HEAD(&gVmbusConnection.ChannelList);
-	spin_lock_init(&gVmbusConnection.channel_lock);
+	INIT_LIST_HEAD(&vmbus_connection.ChannelList);
+	spin_lock_init(&vmbus_connection.channel_lock);
 
 	/*
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	gVmbusConnection.InterruptPage = osd_page_alloc(1);
-	if (gVmbusConnection.InterruptPage == NULL) {
+	vmbus_connection.InterruptPage = osd_page_alloc(1);
+	if (vmbus_connection.InterruptPage == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	gVmbusConnection.RecvInterruptPage = gVmbusConnection.InterruptPage;
-	gVmbusConnection.SendInterruptPage =
-		(void *)((unsigned long)gVmbusConnection.InterruptPage +
+	vmbus_connection.RecvInterruptPage = vmbus_connection.InterruptPage;
+	vmbus_connection.SendInterruptPage =
+		(void *)((unsigned long)vmbus_connection.InterruptPage +
 			(PAGE_SIZE >> 1));
 
 	/*
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	gVmbusConnection.MonitorPages = osd_page_alloc(2);
-	if (gVmbusConnection.MonitorPages == NULL) {
+	vmbus_connection.MonitorPages = osd_page_alloc(2);
+	if (vmbus_connection.MonitorPages == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	msgInfo = kzalloc(sizeof(*msgInfo) +
+	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
 			  GFP_KERNEL);
-	if (msgInfo == NULL) {
+	if (msginfo == NULL) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
-	msgInfo->waitevent = osd_waitevent_create();
-	if (!msgInfo->waitevent) {
+	msginfo->waitevent = osd_waitevent_create();
+	if (!msginfo->waitevent) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
-	msg = (struct vmbus_channel_initiate_contact *)msgInfo->msg;
+	msg = (struct vmbus_channel_initiate_contact *)msginfo->msg;
 
 	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
 	msg->vmbus_version_requested = VMBUS_REVISION_NUMBER;
-	msg->interrupt_page = virt_to_phys(gVmbusConnection.InterruptPage);
-	msg->monitor_page1 = virt_to_phys(gVmbusConnection.MonitorPages);
+	msg->interrupt_page = virt_to_phys(vmbus_connection.InterruptPage);
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.MonitorPages);
 	msg->monitor_page2 = virt_to_phys(
-			(void *)((unsigned long)gVmbusConnection.MonitorPages +
+			(void *)((unsigned long)vmbus_connection.MonitorPages +
 				 PAGE_SIZE));
 
 	/*
 	 * Add to list before we send the request since we may
 	 * receive the response before returning from this routine
 	 */
-	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&msgInfo->msglistentry,
-		      &gVmbusConnection.ChannelMsgList);
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_add_tail(&msginfo->msglistentry,
+		      &vmbus_connection.ChannelMsgList);
 
-	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	DPRINT_DBG(VMBUS, "Vmbus connection - interrupt pfn %llx, "
 		   "monitor1 pfn %llx,, monitor2 pfn %llx",
@@ -129,19 +129,19 @@ int VmbusConnect(void)
 	ret = VmbusPostMessage(msg,
 			       sizeof(struct vmbus_channel_initiate_contact));
 	if (ret != 0) {
-		list_del(&msgInfo->msglistentry);
+		list_del(&msginfo->msglistentry);
 		goto Cleanup;
 	}
 
 	/* Wait for the connection response */
-	osd_waitevent_wait(msgInfo->waitevent);
+	osd_waitevent_wait(msginfo->waitevent);
 
-	list_del(&msgInfo->msglistentry);
+	list_del(&msginfo->msglistentry);
 
 	/* Check if successful */
-	if (msgInfo->response.version_response.version_supported) {
+	if (msginfo->response.version_response.version_supported) {
 		DPRINT_INFO(VMBUS, "Vmbus connected!!");
-		gVmbusConnection.ConnectState = Connected;
+		vmbus_connection.ConnectState = Connected;
 
 	} else {
 		DPRINT_ERR(VMBUS, "Vmbus connection failed!!..."
@@ -151,29 +151,29 @@ int VmbusConnect(void)
 		goto Cleanup;
 	}
 
-	kfree(msgInfo->waitevent);
-	kfree(msgInfo);
+	kfree(msginfo->waitevent);
+	kfree(msginfo);
 	return 0;
 
 Cleanup:
-	gVmbusConnection.ConnectState = Disconnected;
+	vmbus_connection.ConnectState = Disconnected;
 
-	if (gVmbusConnection.WorkQueue)
-		destroy_workqueue(gVmbusConnection.WorkQueue);
+	if (vmbus_connection.WorkQueue)
+		destroy_workqueue(vmbus_connection.WorkQueue);
 
-	if (gVmbusConnection.InterruptPage) {
-		osd_page_free(gVmbusConnection.InterruptPage, 1);
-		gVmbusConnection.InterruptPage = NULL;
+	if (vmbus_connection.InterruptPage) {
+		osd_page_free(vmbus_connection.InterruptPage, 1);
+		vmbus_connection.InterruptPage = NULL;
 	}
 
-	if (gVmbusConnection.MonitorPages) {
-		osd_page_free(gVmbusConnection.MonitorPages, 2);
-		gVmbusConnection.MonitorPages = NULL;
+	if (vmbus_connection.MonitorPages) {
+		osd_page_free(vmbus_connection.MonitorPages, 2);
+		vmbus_connection.MonitorPages = NULL;
 	}
 
-	if (msgInfo) {
-		kfree(msgInfo->waitevent);
-		kfree(msgInfo);
+	if (msginfo) {
+		kfree(msginfo->waitevent);
+		kfree(msginfo);
 	}
 
 	return ret;
@@ -188,7 +188,7 @@ int VmbusDisconnect(void)
 	struct vmbus_channel_message_header *msg;
 
 	/* Make sure we are connected */
-	if (gVmbusConnection.ConnectState != Connected)
+	if (vmbus_connection.ConnectState != Connected)
 		return -1;
 
 	msg = kzalloc(sizeof(struct vmbus_channel_message_header), GFP_KERNEL);
@@ -202,12 +202,12 @@ int VmbusDisconnect(void)
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_page_free(gVmbusConnection.InterruptPage, 1);
+	osd_page_free(vmbus_connection.InterruptPage, 1);
 
 	/* TODO: iterate thru the msg list and free up */
-	destroy_workqueue(gVmbusConnection.WorkQueue);
+	destroy_workqueue(vmbus_connection.WorkQueue);
 
-	gVmbusConnection.ConnectState = Disconnected;
+	vmbus_connection.ConnectState = Disconnected;
 
 	DPRINT_INFO(VMBUS, "Vmbus disconnected!!");
 
@@ -219,22 +219,22 @@ Cleanup:
 /*
  * GetChannelFromRelId - Get the channel object given its child relative id (ie channel id)
  */
-struct vmbus_channel *GetChannelFromRelId(u32 relId)
+struct vmbus_channel *GetChannelFromRelId(u32 relid)
 {
 	struct vmbus_channel *channel;
-	struct vmbus_channel *foundChannel  = NULL;
+	struct vmbus_channel *found_channel  = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-	list_for_each_entry(channel, &gVmbusConnection.ChannelList, listentry) {
-		if (channel->offermsg.child_relid == relId) {
-			foundChannel = channel;
+	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
+	list_for_each_entry(channel, &vmbus_connection.ChannelList, listentry) {
+		if (channel->offermsg.child_relid == relid) {
+			found_channel = channel;
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
+	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
-	return foundChannel;
+	return found_channel;
 }
 
 /*
@@ -243,7 +243,7 @@ struct vmbus_channel *GetChannelFromRelId(u32 relId)
 static void VmbusProcessChannelEvent(void *context)
 {
 	struct vmbus_channel *channel;
-	u32 relId = (u32)(unsigned long)context;
+	u32 relid = (u32)(unsigned long)context;
 
 	/* ASSERT(relId > 0); */
 
@@ -251,7 +251,7 @@ static void VmbusProcessChannelEvent(void *context)
 	 * Find the channel based on this relid and invokes the
 	 * channel callback to process the event
 	 */
-	channel = GetChannelFromRelId(relId);
+	channel = GetChannelFromRelId(relid);
 
 	if (channel) {
 		vmbus_onchannel_event(channel);
@@ -261,7 +261,7 @@ static void VmbusProcessChannelEvent(void *context)
 		 *			  (void*)channel);
 		 */
 	} else {
-		DPRINT_ERR(VMBUS, "channel not found for relid - %d.", relId);
+		DPRINT_ERR(VMBUS, "channel not found for relid - %d.", relid);
 	}
 }
 
@@ -274,14 +274,16 @@ void VmbusOnEvents(void)
 	int maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
 	int bit;
 	int relid;
-	u32 *recvInterruptPage = gVmbusConnection.RecvInterruptPage;
+	u32 *recv_int_page = vmbus_connection.RecvInterruptPage;
 
 	/* Check events */
-	if (recvInterruptPage) {
+	if (recv_int_page) {
 		for (dword = 0; dword < maxdword; dword++) {
-			if (recvInterruptPage[dword]) {
+			if (recv_int_page[dword]) {
 				for (bit = 0; bit < 32; bit++) {
-					if (test_and_clear_bit(bit, (unsigned long *)&recvInterruptPage[dword])) {
+					if (test_and_clear_bit(bit,
+						(unsigned long *)
+						&recv_int_page[dword])) {
 						relid = (dword << 5) + bit;
 						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
@@ -305,24 +307,24 @@ void VmbusOnEvents(void)
 /*
  * VmbusPostMessage - Send a msg on the vmbus's message connection
  */
-int VmbusPostMessage(void *buffer, size_t bufferLen)
+int VmbusPostMessage(void *buffer, size_t buflen)
 {
-	union hv_connection_id connId;
+	union hv_connection_id conn_id;
 
-	connId.asu32 = 0;
-	connId.u.id = VMBUS_MESSAGE_CONNECTION_ID;
-	return hv_post_message(connId, 1, buffer, bufferLen);
+	conn_id.asu32 = 0;
+	conn_id.u.id = VMBUS_MESSAGE_CONNECTION_ID;
+	return hv_post_message(conn_id, 1, buffer, buflen);
 }
 
 /*
  * VmbusSetEvent - Send an event notification to the parent
  */
-int VmbusSetEvent(u32 childRelId)
+int VmbusSetEvent(u32 child_relid)
 {
 	/* Each u32 represents 32 channels */
-	set_bit(childRelId & 31,
-		(unsigned long *)gVmbusConnection.SendInterruptPage +
-		(childRelId >> 5));
+	set_bit(child_relid & 31,
+		(unsigned long *)vmbus_connection.SendInterruptPage +
+		(child_relid >> 5));
 
 	return hv_signal_event();
 }
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 84fdb64..fd0881a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -239,7 +239,7 @@ static void vmbus_on_msg_dpc(struct hv_driver *drv)
 				continue;
 			INIT_WORK(&ctx->work, vmbus_onmessage_work);
 			memcpy(&ctx->msg, msg, sizeof(*msg));
-			queue_work(gVmbusConnection.WorkQueue, &ctx->work);
+			queue_work(vmbus_connection.WorkQueue, &ctx->work);
 		}
 
 		msg->header.message_type = HVMSG_NONE;
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 07f6d22..9b51ac1 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -98,7 +98,7 @@ struct VMBUS_MSGINFO {
 };
 
 
-extern struct VMBUS_CONNECTION gVmbusConnection;
+extern struct VMBUS_CONNECTION vmbus_connection;
 
 /* General vmbus interface */
 
-- 
1.6.3.2

