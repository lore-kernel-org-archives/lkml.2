Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1IHOjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:39:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51285
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751630Ab1IHOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:39:40 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 11/25] Staging: hv: util: Properly handle util services in the util driver
Date: Thu,  8 Sep 2011 07:24:22 -0700
Message-Id: <1315491876-9554-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now properly handle util services in the util driver and eliminate code
that will not be necessary. In the current code, util services were
all handled not as other vmbus devices (net, block) but rather through
special handling (channel setup etc.). In this patch we handle all
services using the standard Linux driver Model.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   39 +----------------------
 drivers/staging/hv/hv_kvp.c       |    7 ++++
 drivers/staging/hv/hv_util.c      |   63 ++++++++++++++++--------------------
 3 files changed, 36 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index c68e5fa..3c67e4c 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -181,24 +181,6 @@ void chn_cb_negotiate(void *context)
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
 
-	if (channel->util_index >= 0) {
-		/*
-		 * This is a properly initialized util channel.
-		 * Route this callback appropriately and setup state
-		 * so that we don't need to reroute again.
-		 */
-		if (hv_cb_utils[channel->util_index].callback != NULL) {
-			/*
-			 * The util driver has established a handler for
-			 * this service; do the magic.
-			 */
-			channel->onchannel_callback =
-			hv_cb_utils[channel->util_index].callback;
-			(hv_cb_utils[channel->util_index].callback)(channel);
-			return;
-		}
-	}
-
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
@@ -348,7 +330,6 @@ static void vmbus_process_offer(struct work_struct *work)
 	struct vmbus_channel *channel;
 	bool fnew = true;
 	int ret;
-	int cnt;
 	unsigned long flags;
 
 	/* The next possible work is rescind handling */
@@ -403,31 +384,13 @@ static void vmbus_process_offer(struct work_struct *work)
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 		free_channel(newchannel);
-	} else {
+	} else
 		/*
 		 * This state is used to indicate a successful open
 		 * so that when we do close the channel normally, we
 		 * can cleanup properly
 		 */
 		newchannel->state = CHANNEL_OPEN_STATE;
-		newchannel->util_index = -1; /* Invalid index */
-
-		/* Open IC channels */
-		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
-			if (!uuid_le_cmp(newchannel->offermsg.offer.if_type,
-				   hv_cb_utils[cnt].data) &&
-				vmbus_open(newchannel, 2 * PAGE_SIZE,
-						 2 * PAGE_SIZE, NULL, 0,
-						 chn_cb_negotiate,
-						 newchannel) == 0) {
-				hv_cb_utils[cnt].channel = newchannel;
-				newchannel->util_index = cnt;
-
-				pr_info("%s\n", hv_cb_utils[cnt].log_msg);
-
-			}
-		}
-	}
 }
 
 /*
diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index 13b0ecf..844c429 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -177,6 +177,13 @@ kvp_respond_to_host(char *key, char *value, int error)
 	channel = kvp_transaction.recv_channel;
 	req_id = kvp_transaction.recv_req_id;
 
+	if (channel->onchannel_callback == NULL)
+		/*
+		 * We have raced with util driver being unloaded;
+		 * silently return.
+		 */
+		return;
+
 	icmsghdrp = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
 	kvp_msg = (struct hv_kvp_msg *)
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 2475ab2..e2f1632 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -251,29 +251,40 @@ static int util_probe(struct hv_device *dev,
 {
 	void *buf = NULL;
 	int service = dev_id->driver_data;
+	void (*util_cb)(void *);
+	int ret = -ENOMEM;
+	char *msg = "Util: unknown service\n";
 
 	switch (service) {
 	case HV_SHUTDOWN:
 		buf = shut_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!shut_txf_buf)
 			goto error;
+		util_cb = shutdown_onchannelcallback;
+		msg = "Shutdown channel functionality initialized\n";
 		break;
 
 	case HV_TIMESYNC:
 		buf = time_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!time_txf_buf)
 			goto error;
+		util_cb = timesync_onchannelcallback;
+		msg = "Timesync channel functionality initialized\n";
 		break;
 
 	case HV_HEARTBEAT:
 		buf = hbeat_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!hbeat_txf_buf)
 			goto error;
+		util_cb = heartbeat_onchannelcallback;
+		msg = "Heartbeat channel functionality initialized\n";
 		break;
 
 	case HV_KVP:
 		if (hv_kvp_init())
 			return -ENODEV;
+		util_cb = hv_kvp_onchannelcallback;
+		msg = "KVP channel functionality initialized\n";
 		break;
 
 	default:
@@ -281,8 +292,22 @@ static int util_probe(struct hv_device *dev,
 		return -ENODEV;
 	}
 
+	ret = vmbus_open(dev->channel, 2 * PAGE_SIZE, 2 * PAGE_SIZE, NULL, 0,
+		util_cb, dev->channel);
+
+	if (ret)
+		goto error1;
+
+	pr_info("%s", msg);
+
 	return 0;
 
+error1:
+	if (service == HV_KVP)
+		hv_kvp_deinit();
+	else
+		kfree(buf);
+
 error:
 	return -ENOMEM;
 
@@ -293,6 +318,8 @@ static int util_remove(struct hv_device *dev,
 {
 	int service = dev_id->driver_data;
 
+	vmbus_close(dev->channel);
+
 	switch (service) {
 	case HV_SHUTDOWN:
 		kfree(shut_txf_buf);
@@ -350,23 +377,9 @@ static  struct hv_driver util_drv = {
 
 static int __init init_hyperv_utils(void)
 {
-	int ret;
 	pr_info("Registering HyperV Utility Driver\n");
 
-	ret = vmbus_driver_register(&util_drv);
-
-	if (ret != 0)
-		return ret;
-
-	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
-
-	hv_cb_utils[HV_TIMESYNC_MSG].callback = &timesync_onchannelcallback;
-
-	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &heartbeat_onchannelcallback;
-
-	hv_cb_utils[HV_KVP_MSG].callback = &hv_kvp_onchannelcallback;
-
-	return 0;
+	return vmbus_driver_register(&util_drv);
 
 }
 
@@ -374,26 +387,6 @@ static void exit_hyperv_utils(void)
 {
 	pr_info("De-Registered HyperV Utility Driver\n");
 
-	if (hv_cb_utils[HV_SHUTDOWN_MSG].channel != NULL)
-		hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
-			&chn_cb_negotiate;
-	hv_cb_utils[HV_SHUTDOWN_MSG].callback = NULL;
-
-	if (hv_cb_utils[HV_TIMESYNC_MSG].channel != NULL)
-		hv_cb_utils[HV_TIMESYNC_MSG].channel->onchannel_callback =
-			&chn_cb_negotiate;
-	hv_cb_utils[HV_TIMESYNC_MSG].callback = NULL;
-
-	if (hv_cb_utils[HV_HEARTBEAT_MSG].channel != NULL)
-		hv_cb_utils[HV_HEARTBEAT_MSG].channel->onchannel_callback =
-			&chn_cb_negotiate;
-	hv_cb_utils[HV_HEARTBEAT_MSG].callback = NULL;
-
-	if (hv_cb_utils[HV_KVP_MSG].channel != NULL)
-		hv_cb_utils[HV_KVP_MSG].channel->onchannel_callback =
-			&chn_cb_negotiate;
-	hv_cb_utils[HV_KVP_MSG].callback = NULL;
-
 	vmbus_driver_unregister(&util_drv);
 }
 
-- 
1.7.4.1

