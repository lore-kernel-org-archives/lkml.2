Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1C2UtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:49:16 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54140
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754053Ab1C2UsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:10 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 05/07] replace DPRINT with native primitives in hv_netvsc
Date: Tue, 29 Mar 2011 13:58:48 -0700
Message-Id: <1301432330-1705-6-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all remaining DPRINT calls with their native dev_ and
netvsc_ calls. And also change some of the verbiage to be more useful.

rndis_filter has a few remaining DPRINT calls in it that will be removed
in a future patch because the debug will be implemented differently.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/netvsc.c       |  115 +++++++++++++++++++------------------
 drivers/staging/hv/netvsc_drv.c   |   36 ++++++------
 drivers/staging/hv/rndis_filter.c |   51 +++++++++--------
 3 files changed, 103 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index be572b4..ddf7546 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -18,6 +18,8 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -200,7 +202,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
 	}
@@ -209,9 +211,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				get_order(net_device->recv_buf_size));
 	if (!net_device->recv_buf) {
-		DPRINT_ERR(NETVSC,
-			   "unable to allocate receive buffer of size %d",
-			   net_device->recv_buf_size);
+		dev_err(&device->device, "unable to allocate receive "
+			"buffer of size %d", net_device->recv_buf_size);
 		ret = -1;
 		goto cleanup;
 	}
@@ -225,8 +226,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 				    net_device->recv_buf_size,
 				    &net_device->recv_buf_gpadl_handle);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC,
-			   "unable to establish receive buffer's gpadl");
+		dev_err(&device->device,
+			"unable to establish receive buffer's gpadl");
 		goto cleanup;
 	}
 
@@ -250,8 +251,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC,
-			   "unable to send receive buffer's gpadl to netvsp");
+		dev_err(&device->device,
+			"unable to send receive buffer's gpadl to netvsp");
 		goto cleanup;
 	}
 
@@ -264,7 +265,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	/* Check the response */
 	if (init_packet->msg.v1_msg.
 	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
-		DPRINT_ERR(NETVSC, "Unable to complete receive buffer "
+		dev_err(&device->device, "Unable to complete receive buffer "
 			   "initialzation with NetVsp - status %d",
 			   init_packet->msg.v1_msg.
 			   send_recv_buf_complete.status);
@@ -318,7 +319,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
 	}
@@ -331,8 +332,8 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				get_order(net_device->send_buf_size));
 	if (!net_device->send_buf) {
-		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
-			   net_device->send_buf_size);
+		dev_err(&device->device, "unable to allocate send "
+			"buffer of size %d", net_device->send_buf_size);
 		ret = -1;
 		goto cleanup;
 	}
@@ -346,7 +347,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 				    net_device->send_buf_size,
 				    &net_device->send_buf_gpadl_handle);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC, "unable to establish send buffer's gpadl");
+		dev_err(&device->device, "unable to establish send buffer's gpadl");
 		goto cleanup;
 	}
 
@@ -369,7 +370,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC,
+		dev_err(&device->device,
 			   "unable to send receive buffer's gpadl to netvsp");
 		goto cleanup;
 	}
@@ -382,7 +383,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	/* Check the response */
 	if (init_packet->msg.v1_msg.
 	    send_send_buf_complete.status != NVSP_STAT_SUCCESS) {
-		DPRINT_ERR(NETVSC, "Unable to complete send buffer "
+		dev_err(&device->device, "Unable to complete send buffer "
 			   "initialzation with NetVsp - status %d",
 			   init_packet->msg.v1_msg.
 			   send_send_buf_complete.status);
@@ -434,8 +435,8 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		 * have a leak rather than continue and a bugchk
 		 */
 		if (ret != 0) {
-			DPRINT_ERR(NETVSC, "unable to send revoke receive "
-				   "buffer to netvsp");
+			dev_err(&net_device->dev->device, "unable to send "
+				"revoke receive buffer to netvsp");
 			return -1;
 		}
 	}
@@ -447,7 +448,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 
 		/* If we failed here, we might as well return and have a leak rather than continue and a bugchk */
 		if (ret != 0) {
-			DPRINT_ERR(NETVSC,
+			dev_err(&net_device->dev->device,
 				   "unable to teardown receive buffer's gpadl");
 			return -1;
 		}
@@ -501,8 +502,8 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 		 * rather than continue and a bugchk
 		 */
 		if (ret != 0) {
-			DPRINT_ERR(NETVSC, "unable to send revoke send buffer "
-				   "to netvsp");
+			dev_err(&net_device->dev->device, "unable to send "
+				"revoke send buffer to netvsp");
 			return -1;
 		}
 	}
@@ -517,8 +518,8 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 		 * rather than continue and a bugchk
 		 */
 		if (ret != 0) {
-			DPRINT_ERR(NETVSC, "unable to teardown send buffer's "
-				   "gpadl");
+			dev_err(&net_device->dev->device,
+				"unable to teardown send buffer's gpadl");
 			return -1;
 		}
 		net_device->send_buf_gpadl_handle = 0;
@@ -544,7 +545,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
 	}
@@ -672,18 +673,19 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 			 netvsc_channel_cb, device);
 
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC, "unable to open channel: %d", ret);
+		dev_err(&device->device, "unable to open channel: %d", ret);
 		ret = -1;
 		goto cleanup;
 	}
 
 	/* Channel is opened */
-	DPRINT_INFO(NETVSC, "*** NetVSC channel opened successfully! ***");
+	pr_info("hv_netvsc channel opened successfully");
 
 	/* Connect with the NetVsp */
 	ret = netvsc_connect_vsp(device);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC, "unable to connect to NetVSP - %d", ret);
+		dev_err(&device->device,
+			"unable to connect to NetVSP - %d", ret);
 		ret = -1;
 		goto close;
 	}
@@ -724,14 +726,15 @@ static int netvsc_device_remove(struct hv_device *device)
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "No net device present!!");
+		dev_err(&device->device, "No net device present!!");
 		return -1;
 	}
 
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
-		DPRINT_INFO(NETVSC, "waiting for %d requests to complete...",
-			    atomic_read(&net_device->num_outstanding_sends));
+		dev_err(&device->device,
+			"waiting for %d requests to complete...",
+			atomic_read(&net_device->num_outstanding_sends));
 		udelay(100);
 	}
 
@@ -741,7 +744,7 @@ static int netvsc_device_remove(struct hv_device *device)
 	net_device = release_inbound_net_device(device);
 
 	/* At this point, no one should be accessing netDevice except in here */
-	DPRINT_INFO(NETVSC, "net device (%p) safe to remove", net_device);
+	dev_notice(&device->device, "net device safe to remove");
 
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
@@ -773,7 +776,7 @@ static void netvsc_send_completion(struct hv_device *device,
 
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return;
 	}
@@ -803,7 +806,7 @@ static void netvsc_send_completion(struct hv_device *device,
 
 		atomic_dec(&net_device->num_outstanding_sends);
 	} else {
-		DPRINT_ERR(NETVSC, "Unknown send completion packet type - "
+		dev_err(&device->device, "Unknown send completion packet type- "
 			   "%d received!!", nvsp_packet->hdr.msg_type);
 	}
 
@@ -820,7 +823,7 @@ static int netvsc_send(struct hv_device *device,
 
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
+		dev_err(&device->device, "net device (%p) shutting down..."
 			   "ignoring outbound packets", net_device);
 		return -2;
 	}
@@ -856,7 +859,7 @@ static int netvsc_send(struct hv_device *device,
 	}
 
 	if (ret != 0)
-		DPRINT_ERR(NETVSC, "Unable to send packet %p ret %d",
+		dev_err(&device->device, "Unable to send packet %p ret %d",
 			   packet, ret);
 
 	atomic_inc(&net_device->num_outstanding_sends);
@@ -882,7 +885,7 @@ static void netvsc_receive(struct hv_device *device,
 
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return;
 	}
@@ -892,7 +895,7 @@ static void netvsc_receive(struct hv_device *device,
 	 * packet
 	 */
 	if (packet->type != VM_PKT_DATA_USING_XFER_PAGES) {
-		DPRINT_ERR(NETVSC, "Unknown packet type received - %d",
+		dev_err(&device->device, "Unknown packet type received - %d",
 			   packet->type);
 		put_net_device(device);
 		return;
@@ -904,8 +907,8 @@ static void netvsc_receive(struct hv_device *device,
 	/* Make sure this is a valid nvsp packet */
 	if (nvsp_packet->hdr.msg_type !=
 	    NVSP_MSG1_TYPE_SEND_RNDIS_PKT) {
-		DPRINT_ERR(NETVSC, "Unknown nvsp packet type received - %d",
-			   nvsp_packet->hdr.msg_type);
+		dev_err(&device->device, "Unknown nvsp packet type received-"
+			" %d", nvsp_packet->hdr.msg_type);
 		put_net_device(device);
 		return;
 	}
@@ -913,7 +916,7 @@ static void netvsc_receive(struct hv_device *device,
 	vmxferpage_packet = (struct vmtransfer_page_packet_header *)packet;
 
 	if (vmxferpage_packet->xfer_pageset_id != NETVSC_RECEIVE_BUFFER_ID) {
-		DPRINT_ERR(NETVSC, "Invalid xfer page set id - "
+		dev_err(&device->device, "Invalid xfer page set id - "
 			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
 			   vmxferpage_packet->xfer_pageset_id);
 		put_net_device(device);
@@ -940,9 +943,9 @@ static void netvsc_receive(struct hv_device *device,
 	 * some of the xfer page packet ranges...
 	 */
 	if (count < 2) {
-		DPRINT_ERR(NETVSC, "Got only %d netvsc pkt...needed %d pkts. "
-			   "Dropping this xfer page packet completely!",
-			   count, vmxferpage_packet->range_cnt + 1);
+		dev_err(&device->device, "Got only %d netvsc pkt...needed "
+			"%d pkts. Dropping this xfer page packet completely!",
+			count, vmxferpage_packet->range_cnt + 1);
 
 		/* Return it to the freelist */
 		spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
@@ -968,9 +971,9 @@ static void netvsc_receive(struct hv_device *device,
 	xferpage_packet->count = count - 1;
 
 	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
-		DPRINT_INFO(NETVSC, "Needed %d netvsc pkts to satisy this xfer "
-			    "page...got %d", vmxferpage_packet->range_cnt,
-			    xferpage_packet->count);
+		dev_err(&device->device, "Needed %d netvsc pkts to satisy "
+			"this xfer page...got %d",
+			vmxferpage_packet->range_cnt, xferpage_packet->count);
 	}
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
@@ -1073,20 +1076,20 @@ retry_send_cmplt:
 	} else if (ret == -1) {
 		/* no more room...wait a bit and attempt to retry 3 times */
 		retries++;
-		DPRINT_ERR(NETVSC, "unable to send receive completion pkt "
-			   "(tid %llx)...retrying %d", transaction_id, retries);
+		dev_err(&device->device, "unable to send receive completion pkt"
+			" (tid %llx)...retrying %d", transaction_id, retries);
 
 		if (retries < 4) {
 			udelay(100);
 			goto retry_send_cmplt;
 		} else {
-			DPRINT_ERR(NETVSC, "unable to send receive completion "
-				  "pkt (tid %llx)...give up retrying",
-				  transaction_id);
+			dev_err(&device->device, "unable to send receive "
+				"completion pkt (tid %llx)...give up retrying",
+				transaction_id);
 		}
 	} else {
-		DPRINT_ERR(NETVSC, "unable to send receive completion pkt - "
-			   "%llx", transaction_id);
+		dev_err(&device->device, "unable to send receive "
+			"completion pkt - %llx", transaction_id);
 	}
 }
 
@@ -1107,7 +1110,7 @@ static void netvsc_receive_completion(void *context)
 	 */
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "unable to get net device..."
+		dev_err(&device->device, "unable to get net device..."
 			   "device being destroyed?");
 		return;
 	}
@@ -1160,7 +1163,7 @@ static void netvsc_channel_cb(void *context)
 
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
-		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
+		dev_err(&device->device, "net device (%p) shutting down..."
 			   "ignoring inbound packets", net_device);
 		goto out;
 	}
@@ -1181,7 +1184,7 @@ static void netvsc_channel_cb(void *context)
 					break;
 
 				default:
-					DPRINT_ERR(NETVSC,
+					dev_err(&device->device,
 						   "unhandled packet type %d, "
 						   "tid %llx len %d\n",
 						   desc->type, request_id,
@@ -1210,7 +1213,7 @@ static void netvsc_channel_cb(void *context)
 			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 			if (buffer == NULL) {
 				/* Try again next time around */
-				DPRINT_ERR(NETVSC,
+				dev_err(&device->device,
 					   "unable to allocate buffer of size "
 					   "(%d)!!", bytes_recvd);
 				break;
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 1772a19..54a203b 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -18,6 +18,8 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
@@ -77,14 +79,14 @@ static int netvsc_open(struct net_device *net)
 		/* Open up the device */
 		ret = rndis_filter_open(device_obj);
 		if (ret != 0) {
-			DPRINT_ERR(NETVSC_DRV,
-				   "unable to open device (ret %d).", ret);
+			netdev_err(net, "unable to open device (ret %d).\n",
+				   ret);
 			return ret;
 		}
 
 		netif_start_queue(net);
 	} else {
-		DPRINT_ERR(NETVSC_DRV, "unable to open device...link is down.");
+		netdev_err(net, "unable to open device...link is down.\n");
 	}
 
 	return ret;
@@ -100,7 +102,7 @@ static int netvsc_close(struct net_device *net)
 
 	ret = rndis_filter_close(device_obj);
 	if (ret != 0)
-		DPRINT_ERR(NETVSC_DRV, "unable to close device (ret %d).", ret);
+		netdev_err(net, "unable to close device (ret %d).\n", ret);
 
 	return ret;
 }
@@ -147,7 +149,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 			 net_drv_obj->req_ext_size, GFP_ATOMIC);
 	if (!packet) {
 		/* out of memory, silently drop packet */
-		DPRINT_ERR(NETVSC_DRV, "unable to allocate hv_netvsc_packet");
+		netdev_err(net, "unable to allocate hv_netvsc_packet\n");
 
 		dev_kfree_skb(skb);
 		net->stats.tx_dropped++;
@@ -214,8 +216,8 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
 
 	if (!net) {
-		DPRINT_ERR(NETVSC_DRV, "got link status but net device "
-				"not initialized yet");
+		netdev_err(net, "got link status but net device "
+				"not initialized yet\n");
 		return;
 	}
 
@@ -243,8 +245,8 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	unsigned long flags;
 
 	if (!net) {
-		DPRINT_ERR(NETVSC_DRV, "got receive callback but net device "
-				"not initialized yet");
+		netdev_err(net, "got receive callback but net device"
+			" not initialized yet\n");
 		return 0;
 	}
 
@@ -350,8 +352,7 @@ static int netvsc_probe(struct device *device)
 		free_netdev(net);
 		dev_set_drvdata(device, NULL);
 
-		DPRINT_ERR(NETVSC_DRV, "unable to add netvsc device (ret %d)",
-			   ret);
+		netdev_err(net, "unable to add netvsc device (ret %d)\n", ret);
 		return ret;
 	}
 
@@ -397,7 +398,7 @@ static int netvsc_remove(struct device *device)
 	int ret;
 
 	if (net == NULL) {
-		DPRINT_INFO(NETVSC, "no net device to remove");
+		dev_err(device, "No net device to remove\n");
 		return 0;
 	}
 
@@ -417,7 +418,7 @@ static int netvsc_remove(struct device *device)
 	ret = net_drv_obj->base.dev_rm(device_obj);
 	if (ret != 0) {
 		/* TODO: */
-		DPRINT_ERR(NETVSC, "unable to remove vsc device (ret %d)", ret);
+		netdev_err(net, "unable to remove vsc device (ret %d)\n", ret);
 	}
 
 	free_netdev(net);
@@ -446,16 +447,13 @@ static void netvsc_drv_exit(void)
 		/* Get the device */
 		ret = driver_for_each_device(&drv->driver, NULL,
 					     &current_dev, netvsc_drv_exit_cb);
-		if (ret)
-			DPRINT_WARN(NETVSC_DRV,
-				    "driver_for_each_device returned %d", ret);
 
 		if (current_dev == NULL)
 			break;
 
 		/* Initiate removal from the top-down */
-		DPRINT_INFO(NETVSC_DRV, "unregistering device (%p)...",
-			    current_dev);
+		dev_err(current_dev, "unregistering device (%s)...\n",
+			dev_name(current_dev));
 
 		device_unregister(current_dev);
 	}
@@ -509,7 +507,7 @@ MODULE_DEVICE_TABLE(dmi, hv_netvsc_dmi_table);
 
 static int __init netvsc_init(void)
 {
-	DPRINT_INFO(NETVSC_DRV, "Netvsc initializing....");
+	pr_info("initializing....");
 
 	if (!dmi_check_system(hv_netvsc_dmi_table))
 		return -ENODEV;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index d1b13dc..1678705 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/if_ether.h>
-
+#include <linux/netdevice.h>
 #include "logging.h"
 #include "hv_api.h"
 #include "netvsc_api.h"
@@ -294,10 +294,11 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 			memcpy(&request->response_msg, resp,
 			       resp->msg_len);
 		} else {
-			DPRINT_ERR(NETVSC, "rndis response buffer overflow "
-				  "detected (size %u max %zu)",
-				  resp->msg_len,
-				  sizeof(struct rndis_filter_packet));
+			dev_err(&dev->net_dev->dev->device,
+				"rndis response buffer overflow "
+				"detected (size %u max %zu)\n",
+				resp->msg_len,
+				sizeof(struct rndis_filter_packet));
 
 			if (resp->ndis_msg_type ==
 			    REMOTE_NDIS_RESET_CMPLT) {
@@ -314,10 +315,11 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 		request->wait_condition = 1;
 		wake_up(&request->wait_event);
 	} else {
-		DPRINT_ERR(NETVSC, "no rndis request found for this response "
-			   "(id 0x%x res type 0x%x)",
-			   resp->msg.init_complete.req_id,
-			   resp->ndis_msg_type);
+		dev_err(&dev->net_dev->dev->device,
+			"no rndis request found for this response "
+			"(id 0x%x res type 0x%x)\n",
+			resp->msg.init_complete.req_id,
+			resp->ndis_msg_type);
 	}
 }
 
@@ -380,15 +382,15 @@ static int rndis_filter_receive(struct hv_device *dev,
 
 	/* Make sure the rndis device state is initialized */
 	if (!net_dev->extension) {
-		DPRINT_ERR(NETVSC, "got rndis message but no rndis device..."
-			  "dropping this message!");
+		dev_err(&dev->device, "got rndis message but no rndis device - "
+			  "dropping this message!\n");
 		return -1;
 	}
 
 	rndis_dev = (struct rndis_device *)net_dev->extension;
 	if (rndis_dev->state == RNDIS_DEV_UNINITIALIZED) {
-		DPRINT_ERR(NETVSC, "got rndis message but rndis device "
-			   "uninitialized...dropping this message!");
+		dev_err(&dev->device, "got rndis message but rndis device "
+			   "uninitialized...dropping this message!\n");
 		return -1;
 	}
 
@@ -409,8 +411,8 @@ static int rndis_filter_receive(struct hv_device *dev,
 		kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset,
 			      KM_IRQ0);
 
-		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
-			   "bytes got %u)...dropping this message!",
+		dev_err(&dev->device, "invalid rndis message? (expected %u "
+			   "bytes got %u)...dropping this message!\n",
 			   rndis_hdr->msg_len,
 			   pkt->total_data_buflen);
 		return -1;
@@ -419,8 +421,8 @@ static int rndis_filter_receive(struct hv_device *dev,
 
 	if ((rndis_hdr->ndis_msg_type != REMOTE_NDIS_PACKET_MSG) &&
 	    (rndis_hdr->msg_len > sizeof(struct rndis_message))) {
-		DPRINT_ERR(NETVSC, "incoming rndis message buffer overflow "
-			   "detected (got %u, max %zu)...marking it an error!",
+		dev_err(&dev->device, "incoming rndis message buffer overflow "
+			   "detected (got %u, max %zu)..marking it an error!\n",
 			   rndis_hdr->msg_len,
 			   sizeof(struct rndis_message));
 	}
@@ -452,7 +454,8 @@ static int rndis_filter_receive(struct hv_device *dev,
 		rndis_filter_receive_indicate_status(rndis_dev, &rndis_msg);
 		break;
 	default:
-		DPRINT_ERR(NETVSC, "unhandled rndis message (type %u len %u)",
+		dev_err(&dev->device,
+			"unhandled rndis message (type %u len %u)\n",
 			   rndis_msg.ndis_msg_type,
 			   rndis_msg.msg_len);
 		break;
@@ -575,7 +578,8 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 		msecs_to_jiffies(2000));
 	if (request->wait_condition == 0) {
 		ret = -1;
-		DPRINT_ERR(NETVSC, "timeout before we got a set response...");
+		dev_err(&dev->net_dev->dev->device,
+			"timeout before we got a set response...\n");
 		/*
 		 * We cant deallocate the request since we may still receive a
 		 * send completion for it.
@@ -789,16 +793,15 @@ static int rndis_filte_device_add(struct hv_device *dev,
 		 */
 	}
 
-	DPRINT_INFO(NETVSC, "Device 0x%p mac addr %pM",
-		    rndisDevice, rndisDevice->hw_mac_adr);
-
 	memcpy(deviceInfo->mac_adr, rndisDevice->hw_mac_adr, ETH_ALEN);
 
 	rndis_filter_query_device_link_status(rndisDevice);
 
 	deviceInfo->link_state = rndisDevice->link_stat;
-	DPRINT_INFO(NETVSC, "Device 0x%p link state %s", rndisDevice,
-		    ((deviceInfo->link_state) ? ("down") : ("up")));
+
+	dev_info(&dev->device, "Device MAC %pM link state %s",
+		 rndisDevice->hw_mac_adr,
+		 ((deviceInfo->link_state) ? ("down\n") : ("up\n")));
 
 	return ret;
 }
-- 
1.6.0.2

