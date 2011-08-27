Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1H0SL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:57 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38063
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751486Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 17/46] Staging: hv: netvsc: Get rid of the refcnt field in struct netvsc_device
Date: Sat, 27 Aug 2011 11:31:16 -0700
Message-Id: <1314469905-7058-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the refcnt field in struct netvsc_device. We implement the following
logic to manage the life cycle of the device: If the device is being destroyed,
we do not allow any outgoing traffic. Furthermore, if the device is being 
destroyed, we allow incoming traffic only to drain outgoing traffic. Note that
the driver may send some book keeping messages to the host not known to 
upper level Linux code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    1 -
 drivers/staging/hv/netvsc.c     |   62 ++++++++++++--------------------------
 2 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 0b347c1..af8a37f 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -369,7 +369,6 @@ struct nvsp_message {
 struct netvsc_device {
 	struct hv_device *dev;
 
-	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
 	bool destroy;
 	/*
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 388f083..9828f0b 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -40,8 +40,6 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	if (!net_device)
 		return NULL;
 
-	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_set(&net_device->refcnt, 2);
 
 	net_device->destroy = false;
 	net_device->dev = device;
@@ -50,43 +48,37 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	return net_device;
 }
 
-/* Get the net device object iff exists and its refcount > 1 */
 static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
 	net_device = device->ext;
-	if (net_device && (atomic_read(&net_device->refcnt) > 1) &&
-		!net_device->destroy)
-		atomic_inc(&net_device->refcnt);
-	else
+	if (net_device && net_device->destroy)
 		net_device = NULL;
 
 	return net_device;
 }
 
-/* Get the net device object iff exists and its refcount > 0 */
 static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
+	unsigned long flags;
 
+	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	net_device = device->ext;
-	if (net_device && atomic_read(&net_device->refcnt))
-		atomic_inc(&net_device->refcnt);
-	else
+
+	if (!net_device)
+		goto get_in_err;
+
+	if (net_device->destroy &&
+		atomic_read(&net_device->num_outstanding_sends) == 0)
 		net_device = NULL;
 
+get_in_err:
+	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 	return net_device;
 }
 
-static void put_net_device(struct hv_device *device)
-{
-	struct netvsc_device *net_device;
-
-	net_device = device->ext;
-
-	atomic_dec(&net_device->refcnt);
-}
 
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 {
@@ -268,7 +260,6 @@ cleanup:
 	netvsc_destroy_recv_buf(net_device);
 
 exit:
-	put_net_device(device);
 	return ret;
 }
 
@@ -349,7 +340,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	ret = netvsc_init_recv_buf(device);
 
 cleanup:
-	put_net_device(device);
 	return ret;
 }
 
@@ -368,7 +358,6 @@ int netvsc_device_remove(struct hv_device *device)
 	unsigned long flags;
 
 	net_device = (struct netvsc_device *)device->ext;
-	atomic_dec(&net_device->refcnt);
 	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	net_device->destroy = true;
 	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
@@ -383,19 +372,17 @@ int netvsc_device_remove(struct hv_device *device)
 
 	netvsc_disconnect_vsp(net_device);
 
-	atomic_dec(&net_device->refcnt);
-	device->ext = NULL;
 	/*
-	 * Wait until the ref cnt falls to 0.
-	 * We have already stopped any new references
-	 * for outgoing traffic. Also, at this point we don't have any
-	 * incoming traffic as well. So this must be outgoing refrences
-	 * established prior to marking the device as being destroyed.
-	 * Since the send path is non-blocking, it is reasonable to busy
-	 * wait here.
+	 * Since we have already drained, we don't need to busy wait
+	 * as was done in final_release_stor_device()
+	 * Note that we cannot set the ext pointer to NULL until
+	 * we have drained - to drain the outgoing packets, we need to
+	 * allow incoming packets.
 	 */
-	while (atomic_read(&net_device->refcnt))
-		udelay(100);
+
+	spin_lock_irqsave(&device->channel->inbound_lock, flags);
+	device->ext = NULL;
+	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 
 	/* At this point, no one should be accessing netDevice except in here */
 	dev_notice(&device->device, "net device safe to remove");
@@ -456,7 +443,6 @@ static void netvsc_send_completion(struct hv_device *device,
 			   "%d received!!", nvsp_packet->hdr.msg_type);
 	}
 
-	put_net_device(device);
 }
 
 int netvsc_send(struct hv_device *device,
@@ -509,7 +495,6 @@ int netvsc_send(struct hv_device *device,
 			   packet, ret);
 
 	atomic_inc(&net_device->num_outstanding_sends);
-	put_net_device(device);
 	return ret;
 }
 
@@ -602,7 +587,6 @@ static void netvsc_receive_completion(void *context)
 	if (fsend_receive_comp)
 		netvsc_send_recv_completion(device, transaction_id);
 
-	put_net_device(device);
 }
 
 static void netvsc_receive(struct hv_device *device,
@@ -636,7 +620,6 @@ static void netvsc_receive(struct hv_device *device,
 	if (packet->type != VM_PKT_DATA_USING_XFER_PAGES) {
 		dev_err(&device->device, "Unknown packet type received - %d",
 			   packet->type);
-		put_net_device(device);
 		return;
 	}
 
@@ -648,7 +631,6 @@ static void netvsc_receive(struct hv_device *device,
 	    NVSP_MSG1_TYPE_SEND_RNDIS_PKT) {
 		dev_err(&device->device, "Unknown nvsp packet type received-"
 			" %d", nvsp_packet->hdr.msg_type);
-		put_net_device(device);
 		return;
 	}
 
@@ -658,7 +640,6 @@ static void netvsc_receive(struct hv_device *device,
 		dev_err(&device->device, "Invalid xfer page set id - "
 			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
 			   vmxferpage_packet->xfer_pageset_id);
-		put_net_device(device);
 		return;
 	}
 
@@ -698,7 +679,6 @@ static void netvsc_receive(struct hv_device *device,
 		netvsc_send_recv_completion(device,
 					    vmxferpage_packet->d.trans_id);
 
-		put_net_device(device);
 		return;
 	}
 
@@ -786,7 +766,6 @@ static void netvsc_receive(struct hv_device *device,
 				completion.recv.recv_completion_ctx);
 	}
 
-	put_net_device(device);
 }
 
 static void netvsc_channel_cb(void *context)
@@ -869,7 +848,6 @@ static void netvsc_channel_cb(void *context)
 		}
 	} while (1);
 
-	put_net_device(device);
 out:
 	kfree(buffer);
 	return;
-- 
1.7.4.1

