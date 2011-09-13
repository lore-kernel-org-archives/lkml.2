Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1IMRjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:39:14 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41818
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755855Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 06/20] Staging: hv: util: Properly handle util services in the util driver
Date: Tue, 13 Sep 2011 10:59:42 -0700
Message-Id: <1315936796-20662-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, properly handle util services in the util driver and eliminate code
that will not be necessary. In the current code, util services were
all handled not as other vmbus devices (net, block) but rather through
special handling (channel setup etc.). In this patch we handle all
services using the standard Linux Driver Model.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   39 +-------------------------
 drivers/staging/hv/hv_kvp.c       |    7 ++++
 drivers/staging/hv/hv_util.c      |   56 +++++++++++-------------------------
 3 files changed, 25 insertions(+), 77 deletions(-)

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
index ff0d9ab..9aa9ede 100644
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
index f082e5a..31abe9e 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -273,19 +273,33 @@ static int util_probe(struct hv_device *dev,
 	if (srv->util_init) {
 		ret = srv->util_init(srv);
 		if (ret) {
-			kfree(srv->recv_buffer);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto error1;
 		}
 	}
 
+	ret = vmbus_open(dev->channel, 2 * PAGE_SIZE, 2 * PAGE_SIZE, NULL, 0,
+			srv->util_cb, dev->channel);
+	if (ret)
+		goto error;
+
+	pr_info("%s", srv->service_name);
 	hv_set_drvdata(dev, srv);
 	return 0;
+
+error:
+	if (srv->util_deinit)
+		srv->util_deinit();
+error1:
+	kfree(srv->recv_buffer);
+	return ret;
 }
 
 static int util_remove(struct hv_device *dev)
 {
 	struct hv_util_service *srv = hv_get_drvdata(dev);
 
+	vmbus_close(dev->channel);
 	if (srv->util_deinit)
 		srv->util_deinit();
 	kfree(srv->recv_buffer);
@@ -325,51 +339,15 @@ static  struct hv_driver util_drv = {
 
 static int __init init_hyperv_utils(void)
 {
-	int ret;
 	pr_info("Registering HyperV Utility Driver\n");
 
-
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
-
+	return vmbus_driver_register(&util_drv);
 }
 
 static void exit_hyperv_utils(void)
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

