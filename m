Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0LJUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:01:18 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37011
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756887Ab0LJUAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:13 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 4/7] staging: hv: Convert camel cased functions in rndis_filter.c to lower cases
Date: Fri, 10 Dec 2010 12:03:57 -0800
Message-Id: <1292011440-21174-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |    2 +-
 drivers/staging/hv/netvsc_api.h   |    4 +-
 drivers/staging/hv/netvsc_drv.c   |    4 +-
 drivers/staging/hv/rndis_filter.c |  132 ++++++++++++++++++------------------
 drivers/staging/hv/rndis_filter.h |    2 +-
 5 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 781d7bd..5c327fc 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -202,7 +202,7 @@ int netvsc_initialize(struct hv_driver *drv)
 
 	driver->OnSend			= netvsc_send;
 
-	RndisFilterInit(driver);
+	rndis_filter_init(driver);
 	return 0;
 }
 
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index dbf154a..315271d 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -110,7 +110,7 @@ struct netvsc_device_info {
 
 /* Interface */
 int netvsc_initialize(struct hv_driver *drv);
-int RndisFilterOnOpen(struct hv_device *Device);
-int RndisFilterOnClose(struct hv_device *Device);
+int rndis_filter_open(struct hv_device *dev);
+int rndis_filter_close(struct hv_device *dev);
 
 #endif /* _NETVSC_API_H_ */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index cd3eef0..e47681e 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -81,7 +81,7 @@ static int netvsc_open(struct net_device *net)
 
 	if (netif_carrier_ok(net)) {
 		/* Open up the device */
-		ret = RndisFilterOnOpen(device_obj);
+		ret = rndis_filter_open(device_obj);
 		if (ret != 0) {
 			DPRINT_ERR(NETVSC_DRV,
 				   "unable to open device (ret %d).", ret);
@@ -104,7 +104,7 @@ static int netvsc_close(struct net_device *net)
 
 	netif_stop_queue(net);
 
-	ret = RndisFilterOnClose(device_obj);
+	ret = rndis_filter_close(device_obj);
 	if (ret != 0)
 		DPRINT_ERR(NETVSC_DRV, "unable to close device (ret %d).", ret);
 
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 28b7e7e..e560f38 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -81,25 +81,25 @@ struct rndis_filter_packet {
 };
 
 
-static int RndisFilterOnDeviceAdd(struct hv_device *dev,
+static int rndis_filte_device_add(struct hv_device *dev,
 				  void *additional_info);
 
-static int RndisFilterOnDeviceRemove(struct hv_device *dev);
+static int rndis_filter_device_remove(struct hv_device *dev);
 
-static void RndisFilterOnCleanup(struct hv_driver *drv);
+static void rndis_filter_cleanup(struct hv_driver *drv);
 
-static int RndisFilterOnSend(struct hv_device *dev,
+static int rndis_filter_send(struct hv_device *dev,
 			     struct hv_netvsc_packet *pkt);
 
-static void RndisFilterOnSendCompletion(void *ctx);
+static void rndis_filter_send_completion(void *ctx);
 
-static void RndisFilterOnSendRequestCompletion(void *ctx);
+static void rndis_filter_send_request_completion(void *ctx);
 
 
 /* The one and only */
 static struct rndis_filter_driver_object rndis_filter;
 
-static struct rndis_device *GetRndisDevice(void)
+static struct rndis_device *get_rndis_device(void)
 {
 	struct rndis_device *device;
 
@@ -116,7 +116,7 @@ static struct rndis_device *GetRndisDevice(void)
 	return device;
 }
 
-static struct rndis_request *GetRndisRequest(struct rndis_device *dev,
+static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 					     u32 msg_type,
 					     u32 msg_len)
 {
@@ -155,7 +155,7 @@ static struct rndis_request *GetRndisRequest(struct rndis_device *dev,
 	return request;
 }
 
-static void PutRndisRequest(struct rndis_device *dev,
+static void put_rndis_request(struct rndis_device *dev,
 			    struct rndis_request *req)
 {
 	unsigned long flags;
@@ -168,7 +168,7 @@ static void PutRndisRequest(struct rndis_device *dev,
 	kfree(req);
 }
 
-static void DumpRndisMessage(struct rndis_message *rndis_msg)
+static void dump_rndis_message(struct rndis_message *rndis_msg)
 {
 	switch (rndis_msg->NdisMessageType) {
 	case REMOTE_NDIS_PACKET_MSG:
@@ -242,7 +242,7 @@ static void DumpRndisMessage(struct rndis_message *rndis_msg)
 	}
 }
 
-static int RndisFilterSendRequest(struct rndis_device *dev,
+static int rndis_filter_send_request(struct rndis_device *dev,
 				  struct rndis_request *req)
 {
 	int ret;
@@ -263,14 +263,14 @@ static int RndisFilterSendRequest(struct rndis_device *dev,
 
 	packet->Completion.Send.SendCompletionContext = req;/* packet; */
 	packet->Completion.Send.OnSendCompletion =
-		RndisFilterOnSendRequestCompletion;
+		rndis_filter_send_request_completion;
 	packet->Completion.Send.SendCompletionTid = (unsigned long)dev;
 
 	ret = rndis_filter.inner_drv.OnSend(dev->net_dev->Device, packet);
 	return ret;
 }
 
-static void RndisFilterReceiveResponse(struct rndis_device *dev,
+static void rndis_filter_receive_response(struct rndis_device *dev,
 				       struct rndis_message *resp)
 {
 	struct rndis_request *request = NULL;
@@ -330,7 +330,7 @@ static void RndisFilterReceiveResponse(struct rndis_device *dev,
 	}
 }
 
-static void RndisFilterReceiveIndicateStatus(struct rndis_device *dev,
+static void rndis_filter_receive_indicate_status(struct rndis_device *dev,
 					     struct rndis_message *resp)
 {
 	struct rndis_indicate_status *indicate =
@@ -349,7 +349,7 @@ static void RndisFilterReceiveIndicateStatus(struct rndis_device *dev,
 	}
 }
 
-static void RndisFilterReceiveData(struct rndis_device *dev,
+static void rndis_filter_receive_data(struct rndis_device *dev,
 				   struct rndis_message *msg,
 				   struct hv_netvsc_packet *pkt)
 {
@@ -380,7 +380,7 @@ static void RndisFilterReceiveData(struct rndis_device *dev,
 						   pkt);
 }
 
-static int RndisFilterOnReceive(struct hv_device *dev,
+static int rndis_filter_receive(struct hv_device *dev,
 				struct hv_netvsc_packet	*pkt)
 {
 	struct netvsc_device *net_dev = dev->Extension;
@@ -445,12 +445,12 @@ static int RndisFilterOnReceive(struct hv_device *dev,
 
 	kunmap_atomic(rndis_hdr - pkt->PageBuffers[0].Offset, KM_IRQ0);
 
-	DumpRndisMessage(&rndis_msg);
+	dump_rndis_message(&rndis_msg);
 
 	switch (rndis_msg.NdisMessageType) {
 	case REMOTE_NDIS_PACKET_MSG:
 		/* data msg */
-		RndisFilterReceiveData(rndis_dev, &rndis_msg, pkt);
+		rndis_filter_receive_data(rndis_dev, &rndis_msg, pkt);
 		break;
 
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
@@ -459,12 +459,12 @@ static int RndisFilterOnReceive(struct hv_device *dev,
 	/* case REMOTE_NDIS_RESET_CMPLT: */
 	/* case REMOTE_NDIS_KEEPALIVE_CMPLT: */
 		/* completion msgs */
-		RndisFilterReceiveResponse(rndis_dev, &rndis_msg);
+		rndis_filter_receive_response(rndis_dev, &rndis_msg);
 		break;
 
 	case REMOTE_NDIS_INDICATE_STATUS_MSG:
 		/* notification msgs */
-		RndisFilterReceiveIndicateStatus(rndis_dev, &rndis_msg);
+		rndis_filter_receive_indicate_status(rndis_dev, &rndis_msg);
 		break;
 	default:
 		DPRINT_ERR(NETVSC, "unhandled rndis message (type %u len %u)",
@@ -476,7 +476,7 @@ static int RndisFilterOnReceive(struct hv_device *dev,
 	return 0;
 }
 
-static int RndisFilterQueryDevice(struct rndis_device *dev, u32 oid,
+static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 				  void *result, u32 *result_size)
 {
 	struct rndis_request *request;
@@ -489,7 +489,7 @@ static int RndisFilterQueryDevice(struct rndis_device *dev, u32 oid,
 		return -EINVAL;
 
 	*result_size = 0;
-	request = GetRndisRequest(dev, REMOTE_NDIS_QUERY_MSG,
+	request = get_rndis_request(dev, REMOTE_NDIS_QUERY_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_query_request));
 	if (!request) {
 		ret = -1;
@@ -503,7 +503,7 @@ static int RndisFilterQueryDevice(struct rndis_device *dev, u32 oid,
 	query->InformationBufferLength = 0;
 	query->DeviceVcHandle = 0;
 
-	ret = RndisFilterSendRequest(dev, request);
+	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
@@ -526,30 +526,30 @@ static int RndisFilterQueryDevice(struct rndis_device *dev, u32 oid,
 
 Cleanup:
 	if (request)
-		PutRndisRequest(dev, request);
+		put_rndis_request(dev, request);
 
 	return ret;
 }
 
-static int RndisFilterQueryDeviceMac(struct rndis_device *dev)
+static int rndis_filter_query_device_mac(struct rndis_device *dev)
 {
 	u32 size = ETH_ALEN;
 
-	return RndisFilterQueryDevice(dev,
+	return rndis_filter_query_device(dev,
 				      RNDIS_OID_802_3_PERMANENT_ADDRESS,
 				      dev->hw_mac_adr, &size);
 }
 
-static int RndisFilterQueryDeviceLinkStatus(struct rndis_device *dev)
+static int rndis_filter_query_device_link_status(struct rndis_device *dev)
 {
 	u32 size = sizeof(u32);
 
-	return RndisFilterQueryDevice(dev,
+	return rndis_filter_query_device(dev,
 				      RNDIS_OID_GEN_MEDIA_CONNECT_STATUS,
 				      &dev->link_stat, &size);
 }
 
-static int RndisFilterSetPacketFilter(struct rndis_device *dev,
+static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 				      u32 new_filter)
 {
 	struct rndis_request *request;
@@ -561,7 +561,7 @@ static int RndisFilterSetPacketFilter(struct rndis_device *dev,
 	/* ASSERT(RNDIS_MESSAGE_SIZE(struct rndis_set_request) + sizeof(u32) <= */
 	/* 	sizeof(struct rndis_message)); */
 
-	request = GetRndisRequest(dev, REMOTE_NDIS_SET_MSG,
+	request = get_rndis_request(dev, REMOTE_NDIS_SET_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_set_request) +
 			sizeof(u32));
 	if (!request) {
@@ -578,7 +578,7 @@ static int RndisFilterSetPacketFilter(struct rndis_device *dev,
 	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
 	       &new_filter, sizeof(u32));
 
-	ret = RndisFilterSendRequest(dev, request);
+	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
@@ -600,12 +600,12 @@ static int RndisFilterSetPacketFilter(struct rndis_device *dev,
 
 Cleanup:
 	if (request)
-		PutRndisRequest(dev, request);
+		put_rndis_request(dev, request);
 Exit:
 	return ret;
 }
 
-int RndisFilterInit(struct netvsc_driver *drv)
+int rndis_filter_init(struct netvsc_driver *drv)
 {
 	DPRINT_DBG(NETVSC, "sizeof(struct rndis_filter_packet) == %zd",
 		   sizeof(struct rndis_filter_packet));
@@ -635,17 +635,17 @@ int RndisFilterInit(struct netvsc_driver *drv)
 					drv->OnLinkStatusChanged;
 
 	/* Override */
-	drv->Base.OnDeviceAdd = RndisFilterOnDeviceAdd;
-	drv->Base.OnDeviceRemove = RndisFilterOnDeviceRemove;
-	drv->Base.OnCleanup = RndisFilterOnCleanup;
-	drv->OnSend = RndisFilterOnSend;
+	drv->Base.OnDeviceAdd = rndis_filte_device_add;
+	drv->Base.OnDeviceRemove = rndis_filter_device_remove;
+	drv->Base.OnCleanup = rndis_filter_cleanup;
+	drv->OnSend = rndis_filter_send;
 	/* Driver->QueryLinkStatus = RndisFilterQueryDeviceLinkStatus; */
-	drv->OnReceiveCallback = RndisFilterOnReceive;
+	drv->OnReceiveCallback = rndis_filter_receive;
 
 	return 0;
 }
 
-static int RndisFilterInitDevice(struct rndis_device *dev)
+static int rndis_filter_init_device(struct rndis_device *dev)
 {
 	struct rndis_request *request;
 	struct rndis_initialize_request *init;
@@ -653,7 +653,7 @@ static int RndisFilterInitDevice(struct rndis_device *dev)
 	u32 status;
 	int ret;
 
-	request = GetRndisRequest(dev, REMOTE_NDIS_INITIALIZE_MSG,
+	request = get_rndis_request(dev, REMOTE_NDIS_INITIALIZE_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_initialize_request));
 	if (!request) {
 		ret = -1;
@@ -669,7 +669,7 @@ static int RndisFilterInitDevice(struct rndis_device *dev)
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
-	ret = RndisFilterSendRequest(dev, request);
+	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0) {
 		dev->state = RNDIS_DEV_UNINITIALIZED;
 		goto Cleanup;
@@ -689,18 +689,18 @@ static int RndisFilterInitDevice(struct rndis_device *dev)
 
 Cleanup:
 	if (request)
-		PutRndisRequest(dev, request);
+		put_rndis_request(dev, request);
 
 	return ret;
 }
 
-static void RndisFilterHaltDevice(struct rndis_device *dev)
+static void rndis_filter_halt_device(struct rndis_device *dev)
 {
 	struct rndis_request *request;
 	struct rndis_halt_request *halt;
 
 	/* Attempt to do a rndis device halt */
-	request = GetRndisRequest(dev, REMOTE_NDIS_HALT_MSG,
+	request = get_rndis_request(dev, REMOTE_NDIS_HALT_MSG,
 				RNDIS_MESSAGE_SIZE(struct rndis_halt_request));
 	if (!request)
 		goto Cleanup;
@@ -710,24 +710,24 @@ static void RndisFilterHaltDevice(struct rndis_device *dev)
 	halt->RequestId = atomic_inc_return(&dev->new_req_id);
 
 	/* Ignore return since this msg is optional. */
-	RndisFilterSendRequest(dev, request);
+	rndis_filter_send_request(dev, request);
 
 	dev->state = RNDIS_DEV_UNINITIALIZED;
 
 Cleanup:
 	if (request)
-		PutRndisRequest(dev, request);
+		put_rndis_request(dev, request);
 	return;
 }
 
-static int RndisFilterOpenDevice(struct rndis_device *dev)
+static int rndis_filter_open_device(struct rndis_device *dev)
 {
 	int ret;
 
 	if (dev->state != RNDIS_DEV_INITIALIZED)
 		return 0;
 
-	ret = RndisFilterSetPacketFilter(dev,
+	ret = rndis_filter_set_packet_filter(dev,
 					 NDIS_PACKET_TYPE_BROADCAST |
 					 NDIS_PACKET_TYPE_ALL_MULTICAST |
 					 NDIS_PACKET_TYPE_DIRECTED);
@@ -737,21 +737,21 @@ static int RndisFilterOpenDevice(struct rndis_device *dev)
 	return ret;
 }
 
-static int RndisFilterCloseDevice(struct rndis_device *dev)
+static int rndis_filter_close_device(struct rndis_device *dev)
 {
 	int ret;
 
 	if (dev->state != RNDIS_DEV_DATAINITIALIZED)
 		return 0;
 
-	ret = RndisFilterSetPacketFilter(dev, 0);
+	ret = rndis_filter_set_packet_filter(dev, 0);
 	if (ret == 0)
 		dev->state = RNDIS_DEV_INITIALIZED;
 
 	return ret;
 }
 
-static int RndisFilterOnDeviceAdd(struct hv_device *dev,
+static int rndis_filte_device_add(struct hv_device *dev,
 				  void *additional_info)
 {
 	int ret;
@@ -759,7 +759,7 @@ static int RndisFilterOnDeviceAdd(struct hv_device *dev,
 	struct rndis_device *rndisDevice;
 	struct netvsc_device_info *deviceInfo = additional_info;
 
-	rndisDevice = GetRndisDevice();
+	rndisDevice = get_rndis_device();
 	if (!rndisDevice)
 		return -1;
 
@@ -786,7 +786,7 @@ static int RndisFilterOnDeviceAdd(struct hv_device *dev,
 	rndisDevice->net_dev = netDevice;
 
 	/* Send the rndis initialization message */
-	ret = RndisFilterInitDevice(rndisDevice);
+	ret = rndis_filter_init_device(rndisDevice);
 	if (ret != 0) {
 		/*
 		 * TODO: If rndis init failed, we will need to shut down the
@@ -795,7 +795,7 @@ static int RndisFilterOnDeviceAdd(struct hv_device *dev,
 	}
 
 	/* Get the mac address */
-	ret = RndisFilterQueryDeviceMac(rndisDevice);
+	ret = rndis_filter_query_device_mac(rndisDevice);
 	if (ret != 0) {
 		/*
 		 * TODO: shutdown rndis device and the channel
@@ -807,7 +807,7 @@ static int RndisFilterOnDeviceAdd(struct hv_device *dev,
 
 	memcpy(deviceInfo->MacAddr, rndisDevice->hw_mac_adr, ETH_ALEN);
 
-	RndisFilterQueryDeviceLinkStatus(rndisDevice);
+	rndis_filter_query_device_link_status(rndisDevice);
 
 	deviceInfo->LinkState = rndisDevice->link_stat;
 	DPRINT_INFO(NETVSC, "Device 0x%p link state %s", rndisDevice,
@@ -816,13 +816,13 @@ static int RndisFilterOnDeviceAdd(struct hv_device *dev,
 	return ret;
 }
 
-static int RndisFilterOnDeviceRemove(struct hv_device *dev)
+static int rndis_filter_device_remove(struct hv_device *dev)
 {
 	struct netvsc_device *net_dev = dev->Extension;
 	struct rndis_device *rndis_dev = net_dev->Extension;
 
 	/* Halt and release the rndis device */
-	RndisFilterHaltDevice(rndis_dev);
+	rndis_filter_halt_device(rndis_dev);
 
 	kfree(rndis_dev);
 	net_dev->Extension = NULL;
@@ -833,31 +833,31 @@ static int RndisFilterOnDeviceRemove(struct hv_device *dev)
 	return 0;
 }
 
-static void RndisFilterOnCleanup(struct hv_driver *drv)
+static void rndis_filter_cleanup(struct hv_driver *drv)
 {
 }
 
-int RndisFilterOnOpen(struct hv_device *dev)
+int rndis_filter_open(struct hv_device *dev)
 {
 	struct netvsc_device *netDevice = dev->Extension;
 
 	if (!netDevice)
 		return -EINVAL;
 
-	return RndisFilterOpenDevice(netDevice->Extension);
+	return rndis_filter_open_device(netDevice->Extension);
 }
 
-int RndisFilterOnClose(struct hv_device *dev)
+int rndis_filter_close(struct hv_device *dev)
 {
 	struct netvsc_device *netDevice = dev->Extension;
 
 	if (!netDevice)
 		return -EINVAL;
 
-	return RndisFilterCloseDevice(netDevice->Extension);
+	return rndis_filter_close_device(netDevice->Extension);
 }
 
-static int RndisFilterOnSend(struct hv_device *dev,
+static int rndis_filter_send(struct hv_device *dev,
 			     struct hv_netvsc_packet *pkt)
 {
 	int ret;
@@ -895,7 +895,7 @@ static int RndisFilterOnSend(struct hv_device *dev,
 				pkt->Completion.Send.SendCompletionContext;
 
 	/* Use ours */
-	pkt->Completion.Send.OnSendCompletion = RndisFilterOnSendCompletion;
+	pkt->Completion.Send.OnSendCompletion = rndis_filter_send_completion;
 	pkt->Completion.Send.SendCompletionContext = filterPacket;
 
 	ret = rndis_filter.inner_drv.OnSend(dev, pkt);
@@ -913,7 +913,7 @@ static int RndisFilterOnSend(struct hv_device *dev,
 	return ret;
 }
 
-static void RndisFilterOnSendCompletion(void *ctx)
+static void rndis_filter_send_completion(void *ctx)
 {
 	struct rndis_filter_packet *filterPacket = ctx;
 
@@ -922,7 +922,7 @@ static void RndisFilterOnSendCompletion(void *ctx)
 }
 
 
-static void RndisFilterOnSendRequestCompletion(void *ctx)
+static void rndis_filter_send_request_completion(void *ctx)
 {
 	/* Noop */
 }
diff --git a/drivers/staging/hv/rndis_filter.h b/drivers/staging/hv/rndis_filter.h
index 764b9bf..4da18f3 100644
--- a/drivers/staging/hv/rndis_filter.h
+++ b/drivers/staging/hv/rndis_filter.h
@@ -50,6 +50,6 @@
 
 /* Interface */
 
-extern int RndisFilterInit(struct netvsc_driver *driver);
+extern int rndis_filter_init(struct netvsc_driver *driver);
 
 #endif /* _RNDISFILTER_H_ */
-- 
1.6.3.2

