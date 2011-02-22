Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1BVXYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:24:14 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46088
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752299Ab1BVXYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:24:09 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/6] Staging: hv: channel_mgmt.c Removed DPRINT and implemented pr_XX
Date: Tue, 22 Feb 2011 15:32:43 -0800
Message-Id: <1298417565-12356-4-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298417565-12356-3-git-send-email-hjanssen@microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-3-git-send-email-hjanssen@microsoft.com>
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

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   73 +++++++------------------------------
 1 files changed, 14 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 0781c0e..752de54 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -290,9 +290,7 @@ static void release_channel(struct work_struct *work)
 						     struct vmbus_channel,
 						     work);
 
-	DPRINT_DBG(VMBUS, "releasing channel (%p)", channel);
 	destroy_workqueue(channel->controlwq);
-	DPRINT_DBG(VMBUS, "channel released (%p)", channel);
 
 	kfree(channel);
 }
@@ -384,8 +382,6 @@ static void vmbus_process_offer(struct work_struct *work)
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 	if (!fnew) {
-		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
-			   newchannel->offermsg.child_relid);
 		free_channel(newchannel);
 		return;
 	}
@@ -400,9 +396,6 @@ static void vmbus_process_offer(struct work_struct *work)
 		&newchannel->offermsg.offer.if_instance,
 		newchannel);
 
-	DPRINT_DBG(VMBUS, "child device object allocated - %p",
-		   newchannel->device_obj);
-
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
@@ -410,9 +403,8 @@ static void vmbus_process_offer(struct work_struct *work)
 	 */
 	ret = vmbus_child_dev_add(newchannel->device_obj);
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS,
-			   "unable to add child device object (relid %d)",
-			   newchannel->offermsg.child_relid);
+		pr_err("%s: %s Unable to add child device object (relid %d)",
+		       VMBUS_MOD, __func__, newchannel->offermsg.child_relid);
 
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&newchannel->listentry);
@@ -437,8 +429,8 @@ static void vmbus_process_offer(struct work_struct *work)
 						 hv_cb_utils[cnt].callback,
 						 newchannel) == 0) {
 				hv_cb_utils[cnt].channel = newchannel;
-				DPRINT_INFO(VMBUS, "%s",
-						hv_cb_utils[cnt].log_msg);
+				pr_info("%s: %s",
+					VMBUS_MOD, hv_cb_utils[cnt].log_msg);
 				count_hv_channel();
 			}
 		}
@@ -471,48 +463,20 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 	}
 
 	if (!fsupported) {
-		DPRINT_DBG(VMBUS, "Ignoring channel offer notification for "
-			   "child relid %d", offer->child_relid);
 		return;
 	}
 
 	guidtype = &offer->offer.if_type;
 	guidinstance = &offer->offer.if_instance;
 
-	DPRINT_INFO(VMBUS, "Channel offer notification - "
-		    "child relid %d monitor id %d allocated %d, "
-		    "type {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x} "
-		    "instance {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    offer->child_relid, offer->monitorid,
-		    offer->monitor_allocated,
-		    guidtype->data[3], guidtype->data[2],
-		    guidtype->data[1], guidtype->data[0],
-		    guidtype->data[5], guidtype->data[4],
-		    guidtype->data[7], guidtype->data[6],
-		    guidtype->data[8], guidtype->data[9],
-		    guidtype->data[10], guidtype->data[11],
-		    guidtype->data[12], guidtype->data[13],
-		    guidtype->data[14], guidtype->data[15],
-		    guidinstance->data[3], guidinstance->data[2],
-		    guidinstance->data[1], guidinstance->data[0],
-		    guidinstance->data[5], guidinstance->data[4],
-		    guidinstance->data[7], guidinstance->data[6],
-		    guidinstance->data[8], guidinstance->data[9],
-		    guidinstance->data[10], guidinstance->data[11],
-		    guidinstance->data[12], guidinstance->data[13],
-		    guidinstance->data[14], guidinstance->data[15]);
-
 	/* Allocate the channel object and save this offer. */
 	newchannel = alloc_channel();
 	if (!newchannel) {
-		DPRINT_ERR(VMBUS, "unable to allocate channel object");
+		pr_err("%s: %s Unable to allocate channel object",
+		       VMBUS_MOD, __func__);
 		return;
 	}
 
-	DPRINT_DBG(VMBUS, "channel object allocated - %p", newchannel);
-
 	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
 	newchannel->monitor_grp = (u8)offer->monitorid / 32;
@@ -536,8 +500,6 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 	rescind = (struct vmbus_channel_rescind_offer *)hdr;
 	channel = relid2channel(rescind->child_relid);
 	if (channel == NULL) {
-		DPRINT_DBG(VMBUS, "channel not found for relId %d",
-			   rescind->child_relid);
 		return;
 	}
 
@@ -573,7 +535,6 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	unsigned long flags;
 
 	result = (struct vmbus_channel_open_result *)hdr;
-	DPRINT_DBG(VMBUS, "vmbus open result - %d", result->status);
 
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
@@ -618,8 +579,6 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	unsigned long flags;
 
 	gpadlcreated = (struct vmbus_channel_gpadl_created *)hdr;
-	DPRINT_DBG(VMBUS, "vmbus gpadl created result - %d",
-		   gpadlcreated->creation_status);
 
 	/*
 	 * Find the establish msg, copy the result and signal/unblock the wait
@@ -770,12 +729,9 @@ void vmbus_onmessage(void *context)
 	hdr = (struct vmbus_channel_message_header *)msg->u.payload;
 	size = msg->header.payload_size;
 
-	DPRINT_DBG(VMBUS, "message type %d size %d", hdr->msgtype, size);
-
 	if (hdr->msgtype >= CHANNELMSG_COUNT) {
-		DPRINT_ERR(VMBUS,
-			   "Received invalid channel message type %d size %d",
-			   hdr->msgtype, size);
+		pr_err("%s: %s Received invalid channel msg type %d size %d",
+		       VMBUS_MOD, __func__, hdr->msgtype, size);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
 				     (unsigned char *)msg->u.payload, size);
 		return;
@@ -784,8 +740,8 @@ void vmbus_onmessage(void *context)
 	if (gChannelMessageTable[hdr->msgtype].messageHandler)
 		gChannelMessageTable[hdr->msgtype].messageHandler(hdr);
 	else
-		DPRINT_ERR(VMBUS, "Unhandled channel message type %d",
-			   hdr->msgtype);
+		pr_err("%s: %s Unhandled channel message type %d",
+		       VMBUS_MOD, __func__, hdr->msgtype);
 }
 
 /*
@@ -813,8 +769,8 @@ int vmbus_request_offers(void)
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_message_header));
 	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "Unable to request offers - %d", ret);
-
+		pr_err("%s: %s Unable to request offers - %d",
+		       VMBUS_MOD, __func__, ret);
 		goto cleanup;
 	}
 
@@ -854,9 +810,8 @@ void vmbus_release_unattached_channels(void)
 
 		if (!channel->device_obj->drv) {
 			list_del(&channel->listentry);
-			DPRINT_INFO(VMBUS,
-				    "Releasing unattached device object %p",
-				    channel->device_obj);
+			pr_info("%s: Releasing unattached dev object %p",
+				VMBUS_MOD, channel->device_obj);
 
 			vmbus_child_device_unregister(channel->device_obj);
 			free_channel(channel);
-- 
1.6.0.2

