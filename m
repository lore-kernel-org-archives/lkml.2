Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab1BZB4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:56:44 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48635
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750725Ab1BZB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:56:43 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Date: Fri, 25 Feb 2011 18:05:30 -0800
Message-Id: <1298685930-30806-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V drivers have supported two device abstractions.
This patch implements a single device abstraction.
This simplifies the code and avoids duplication
of state.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c        |   17 ++++---
 drivers/staging/hv/blkvsc_drv.c    |   14 +++---
 drivers/staging/hv/channel_mgmt.c  |    1 +
 drivers/staging/hv/channel_mgmt.h  |    2 +-
 drivers/staging/hv/netvsc.c        |   55 ++++++++++++-----------
 drivers/staging/hv/netvsc.h        |    2 +-
 drivers/staging/hv/netvsc_api.h    |   12 +++---
 drivers/staging/hv/netvsc_drv.c    |   28 +++++-------
 drivers/staging/hv/rndis_filter.c  |   19 ++++----
 drivers/staging/hv/storvsc.c       |   37 ++++++++--------
 drivers/staging/hv/storvsc_api.h   |    4 +-
 drivers/staging/hv/storvsc_drv.c   |   21 ++++-----
 drivers/staging/hv/vmbus.h         |   13 +++---
 drivers/staging/hv/vmbus_api.h     |   29 ++----------
 drivers/staging/hv/vmbus_drv.c     |   84 +++++++++++++++---------------------
 drivers/staging/hv/vmbus_private.h |   12 +++---
 16 files changed, 157 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 7c8729b..ecface3 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -35,7 +35,8 @@ static const struct hv_guid g_blk_device_type = {
 	}
 };
 
-static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info)
+static int blk_vsc_on_device_add(struct vm_device *device,
+				void *additional_info)
 {
 	struct storvsc_device_info *device_info;
 	int ret = 0;
@@ -51,13 +52,13 @@ static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info
 	 * id. For IDE devices, the device instance id is formatted as
 	 * <bus id> * - <device id> - 8899 - 000000000000.
 	 */
-	device_info->path_id = device->dev_instance.data[3] << 24 |
-			     device->dev_instance.data[2] << 16 |
-			     device->dev_instance.data[1] << 8  |
-			     device->dev_instance.data[0];
+	device_info->path_id = device->device_id.data[3] << 24 |
+			     device->device_id.data[2] << 16 |
+			     device->device_id.data[1] << 8  |
+			     device->device_id.data[0];
 
-	device_info->target_id = device->dev_instance.data[5] << 8 |
-			       device->dev_instance.data[4];
+	device_info->target_id = device->device_id.data[5] << 8 |
+			       device->device_id.data[4];
 
 	return ret;
 }
@@ -73,7 +74,7 @@ int blk_vsc_initialize(struct hv_driver *driver)
 	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_blk_driver_name;
-	memcpy(&driver->dev_type, &g_blk_device_type, sizeof(struct hv_guid));
+	memcpy(&driver->class_id, &g_blk_device_type, sizeof(struct hv_guid));
 
 	stor_driver->request_ext_size = sizeof(struct storvsc_request_extension);
 
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 36a0adb..6d1a783 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -183,7 +183,7 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_init(&storvsc_drv_obj->base);
 
 	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = blkvsc_probe;
@@ -249,8 +249,7 @@ static int blkvsc_probe(struct device *device)
 				(struct blkvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
 
 	struct block_device_context *blkdev = NULL;
 	struct storvsc_device_info device_info;
@@ -282,7 +281,7 @@ static int blkvsc_probe(struct device *device)
 	/* ASSERT(sizeof(struct blkvsc_request_group) <= */
 	/* 	sizeof(struct blkvsc_request)); */
 
-	blkdev->request_pool = kmem_cache_create(dev_name(&device_ctx->device),
+	blkdev->request_pool = kmem_cache_create(dev_name(&device_obj->device),
 					sizeof(struct blkvsc_request) +
 					storvsc_drv_obj->request_ext_size, 0,
 					SLAB_HWCACHE_ALIGN, NULL);
@@ -299,7 +298,7 @@ static int blkvsc_probe(struct device *device)
 		goto Cleanup;
 	}
 
-	blkdev->device_ctx = device_ctx;
+	blkdev->device_ctx = device_obj;
 	/* this identified the device 0 or 1 */
 	blkdev->target = device_info.target_id;
 	/* this identified the ide ctrl 0 or 1 */
@@ -734,8 +733,7 @@ static int blkvsc_remove(struct device *device)
 				(struct blkvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
 	struct block_device_context *blkdev = dev_get_drvdata(device);
 	unsigned long flags;
 	int ret;
@@ -897,7 +895,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 	storvsc_req->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
 
-	ret = storvsc_drv_obj->on_io_request(&blkdev->device_ctx->device_obj,
+	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
 					   &blkvsc_req->request);
 	if (ret == 0)
 		blkdev->num_outstanding_reqs++;
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 0781c0e..8d81288 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -28,6 +28,7 @@
 #include <linux/completion.h>
 #include "hv_api.h"
 #include "logging.h"
+#include "vmbus.h"
 #include "vmbus_private.h"
 #include "utils.h"
 
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index 3368bf1..b3a9214 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -228,7 +228,7 @@ enum vmbus_channel_state {
 struct vmbus_channel {
 	struct list_head listentry;
 
-	struct hv_device *device_obj;
+	struct vm_device *device_obj;
 
 	struct timer_list poll_timer; /* SA-111 workaround */
 	struct work_struct work;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 20b1597..ff8e5be 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include "hv_api.h"
+#include "vmbus.h"
 #include "logging.h"
 #include "netvsc.h"
 #include "rndis_filter.h"
@@ -43,40 +44,40 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int netvsc_device_add(struct hv_device *device, void *additional_info);
+static int netvsc_device_add(struct vm_device *device, void *additional_info);
 
-static int netvsc_device_remove(struct hv_device *device);
+static int netvsc_device_remove(struct vm_device *device);
 
 static void netvsc_cleanup(struct hv_driver *driver);
 
 static void netvsc_channel_cb(void *context);
 
-static int netvsc_init_send_buf(struct hv_device *device);
+static int netvsc_init_send_buf(struct vm_device *device);
 
-static int netvsc_init_recv_buf(struct hv_device *device);
+static int netvsc_init_recv_buf(struct vm_device *device);
 
 static int netvsc_destroy_send_buf(struct netvsc_device *net_device);
 
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device);
 
-static int netvsc_connect_vsp(struct hv_device *device);
+static int netvsc_connect_vsp(struct vm_device *device);
 
-static void netvsc_send_completion(struct hv_device *device,
+static void netvsc_send_completion(struct vm_device *device,
 				   struct vmpacket_descriptor *packet);
 
-static int netvsc_send(struct hv_device *device,
+static int netvsc_send(struct vm_device *device,
 			struct hv_netvsc_packet *packet);
 
-static void netvsc_receive(struct hv_device *device,
+static void netvsc_receive(struct vm_device *device,
 			    struct vmpacket_descriptor *packet);
 
 static void netvsc_receive_completion(void *context);
 
-static void netvsc_send_recv_completion(struct hv_device *device,
+static void netvsc_send_recv_completion(struct vm_device *device,
 					u64 transaction_id);
 
 
-static struct netvsc_device *alloc_net_device(struct hv_device *device)
+static struct netvsc_device *alloc_net_device(struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -102,7 +103,7 @@ static void free_net_device(struct netvsc_device *device)
 
 
 /* Get the net device object iff exists and its refcount > 1 */
-static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
+static struct netvsc_device *get_outbound_net_device(struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -116,7 +117,7 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 }
 
 /* Get the net device object iff exists and its refcount > 0 */
-static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
+static struct netvsc_device *get_inbound_net_device(struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -129,7 +130,7 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 	return net_device;
 }
 
-static void put_net_device(struct hv_device *device)
+static void put_net_device(struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -139,7 +140,7 @@ static void put_net_device(struct hv_device *device)
 }
 
 static struct netvsc_device *release_outbound_net_device(
-		struct hv_device *device)
+		struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -155,7 +156,7 @@ static struct netvsc_device *release_outbound_net_device(
 }
 
 static struct netvsc_device *release_inbound_net_device(
-		struct hv_device *device)
+		struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -186,7 +187,7 @@ int netvsc_initialize(struct hv_driver *drv)
 		   sizeof(struct vmtransfer_page_packet_header));
 
 	drv->name = driver_name;
-	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
+	memcpy(&drv->class_id, &netvsc_device_type, sizeof(struct hv_guid));
 
 	/* Setup the dispatch table */
 	driver->base.dev_add	= netvsc_device_add;
@@ -199,7 +200,7 @@ int netvsc_initialize(struct hv_driver *drv)
 	return 0;
 }
 
-static int netvsc_init_recv_buf(struct hv_device *device)
+static int netvsc_init_recv_buf(struct vm_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
@@ -329,7 +330,7 @@ exit:
 	return ret;
 }
 
-static int netvsc_init_send_buf(struct hv_device *device)
+static int netvsc_init_send_buf(struct vm_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
@@ -571,7 +572,7 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 }
 
 
-static int netvsc_connect_vsp(struct hv_device *device)
+static int netvsc_connect_vsp(struct vm_device *device)
 {
 	int ret;
 	struct netvsc_device *net_device;
@@ -687,7 +688,7 @@ static void NetVscDisconnectFromVsp(struct netvsc_device *net_device)
  * netvsc_device_add - Callback when the device belonging to this
  * driver is added
  */
-static int netvsc_device_add(struct hv_device *device, void *additional_info)
+static int netvsc_device_add(struct vm_device *device, void *additional_info)
 {
 	int ret = 0;
 	int i;
@@ -780,7 +781,7 @@ cleanup:
 /*
  * netvsc_device_remove - Callback when the root bus device is removed
  */
-static int netvsc_device_remove(struct hv_device *device)
+static int netvsc_device_remove(struct vm_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
@@ -836,7 +837,7 @@ static void netvsc_cleanup(struct hv_driver *drv)
 {
 }
 
-static void netvsc_send_completion(struct hv_device *device,
+static void netvsc_send_completion(struct vm_device *device,
 				   struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
@@ -885,7 +886,7 @@ static void netvsc_send_completion(struct hv_device *device,
 	put_net_device(device);
 }
 
-static int netvsc_send(struct hv_device *device,
+static int netvsc_send(struct vm_device *device,
 			struct hv_netvsc_packet *packet)
 {
 	struct netvsc_device *net_device;
@@ -939,7 +940,7 @@ static int netvsc_send(struct hv_device *device,
 	return ret;
 }
 
-static void netvsc_receive(struct hv_device *device,
+static void netvsc_receive(struct vm_device *device,
 			    struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
@@ -1136,7 +1137,7 @@ static void netvsc_receive(struct hv_device *device,
 	put_net_device(device);
 }
 
-static void netvsc_send_recv_completion(struct hv_device *device,
+static void netvsc_send_recv_completion(struct vm_device *device,
 					u64 transaction_id)
 {
 	struct nvsp_message recvcompMessage;
@@ -1185,7 +1186,7 @@ retry_send_cmplt:
 static void netvsc_receive_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = context;
-	struct hv_device *device = (struct hv_device *)packet->device;
+	struct vm_device *device = (struct vm_device *)packet->device;
 	struct netvsc_device *net_device;
 	u64 transaction_id = 0;
 	bool fsend_receive_comp = false;
@@ -1234,7 +1235,7 @@ static void netvsc_receive_completion(void *context)
 static void netvsc_channel_cb(void *context)
 {
 	int ret;
-	struct hv_device *device = context;
+	struct vm_device *device = context;
 	struct netvsc_device *net_device;
 	u32 bytes_recvd;
 	u64 request_id;
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index 45d24b9..b2709eb 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -293,7 +293,7 @@ struct nvsp_message {
 
 /* Per netvsc channel-specific */
 struct netvsc_device {
-	struct hv_device *dev;
+	struct vm_device *dev;
 
 	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index b4bed36..a9cfeff 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -49,7 +49,7 @@ struct hv_netvsc_packet {
 	/* Bookkeeping stuff */
 	struct list_head list_ent;
 
-	struct hv_device *device;
+	struct vm_device *device;
 	bool is_data_pkt;
 
 	/*
@@ -93,12 +93,12 @@ struct netvsc_driver {
 	 * This is set by the caller to allow us to callback when we
 	 * receive a packet from the "wire"
 	 */
-	int (*recv_cb)(struct hv_device *dev,
+	int (*recv_cb)(struct vm_device *dev,
 				 struct hv_netvsc_packet *packet);
-	void (*link_status_change)(struct hv_device *dev, u32 status);
+	void (*link_status_change)(struct vm_device *dev, u32 status);
 
 	/* Specific to this driver */
-	int (*send)(struct hv_device *dev, struct hv_netvsc_packet *packet);
+	int (*send)(struct vm_device *dev, struct hv_netvsc_packet *packet);
 
 	void *ctx;
 };
@@ -110,7 +110,7 @@ struct netvsc_device_info {
 
 /* Interface */
 int netvsc_initialize(struct hv_driver *drv);
-int rndis_filter_open(struct hv_device *dev);
-int rndis_filter_close(struct hv_device *dev);
+int rndis_filter_open(struct vm_device *dev);
+int rndis_filter_close(struct vm_device *dev);
 
 #endif /* _NETVSC_API_H_ */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 03f9740..055986f 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -76,7 +76,7 @@ static void netvsc_set_multicast_list(struct net_device *net)
 static int netvsc_open(struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct hv_device *device_obj = &net_device_ctx->device_ctx->device_obj;
+	struct vm_device *device_obj = net_device_ctx->device_ctx;
 	int ret = 0;
 
 	if (netif_carrier_ok(net)) {
@@ -99,7 +99,7 @@ static int netvsc_open(struct net_device *net)
 static int netvsc_close(struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct hv_device *device_obj = &net_device_ctx->device_ctx->device_obj;
+	struct vm_device *device_obj = net_device_ctx->device_ctx;
 	int ret;
 
 	netif_stop_queue(net);
@@ -198,7 +198,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	packet->completion.send.send_completion_ctx = packet;
 	packet->completion.send.send_completion_tid = (unsigned long)skb;
 
-	ret = net_drv_obj->send(&net_device_ctx->device_ctx->device_obj,
+	ret = net_drv_obj->send(net_device_ctx->device_ctx,
 				  packet);
 	if (ret == 0) {
 		net->stats.tx_bytes += skb->len;
@@ -223,11 +223,10 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 /*
  * netvsc_linkstatus_callback - Link up/down notification
  */
-static void netvsc_linkstatus_callback(struct hv_device *device_obj,
+static void netvsc_linkstatus_callback(struct vm_device *device_obj,
 				       unsigned int status)
 {
-	struct vm_device *device_ctx = to_vm_device(device_obj);
-	struct net_device *net = dev_get_drvdata(&device_ctx->device);
+	struct net_device *net = dev_get_drvdata(&device_obj->device);
 
 	if (!net) {
 		DPRINT_ERR(NETVSC_DRV, "got link status but net device "
@@ -249,11 +248,10 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
  * netvsc_recv_callback -  Callback when we receive a packet from the
  * "wire" on the specified device.
  */
-static int netvsc_recv_callback(struct hv_device *device_obj,
+static int netvsc_recv_callback(struct vm_device *device_obj,
 				struct hv_netvsc_packet *packet)
 {
-	struct vm_device *device_ctx = to_vm_device(device_obj);
-	struct net_device *net = dev_get_drvdata(&device_ctx->device);
+	struct net_device *net = dev_get_drvdata(&device_obj->device);
 	struct sk_buff *skb;
 	void *data;
 	int i;
@@ -345,8 +343,7 @@ static int netvsc_probe(struct device *device)
 	struct netvsc_driver_context *net_drv_ctx =
 		(struct netvsc_driver_context *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info device_info;
@@ -363,7 +360,7 @@ static int netvsc_probe(struct device *device)
 	netif_carrier_off(net);
 
 	net_device_ctx = netdev_priv(net);
-	net_device_ctx->device_ctx = device_ctx;
+	net_device_ctx->device_ctx = device_obj;
 	net_device_ctx->avail = ring_size;
 	dev_set_drvdata(device, net);
 
@@ -417,9 +414,8 @@ static int netvsc_remove(struct device *device)
 	struct netvsc_driver_context *net_drv_ctx =
 		(struct netvsc_driver_context *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct net_device *net = dev_get_drvdata(&device_ctx->device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
+	struct net_device *net = dev_get_drvdata(&device_obj->device);
 	int ret;
 
 	if (net == NULL) {
@@ -508,7 +504,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_init(&net_drv_obj->base);
 
 	drv_ctx->driver.name = net_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &net_drv_obj->base.dev_type,
+	memcpy(&drv_ctx->class_id, &net_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = netvsc_probe;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e7189cd..e0b1b44 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -28,6 +28,7 @@
 
 #include "logging.h"
 #include "hv_api.h"
+#include "vmbus.h"
 #include "netvsc_api.h"
 #include "rndis_filter.h"
 
@@ -84,14 +85,14 @@ struct rndis_filter_packet {
 };
 
 
-static int rndis_filte_device_add(struct hv_device *dev,
+static int rndis_filte_device_add(struct vm_device *dev,
 				  void *additional_info);
 
-static int rndis_filter_device_remove(struct hv_device *dev);
+static int rndis_filter_device_remove(struct vm_device *dev);
 
 static void rndis_filter_cleanup(struct hv_driver *drv);
 
-static int rndis_filter_send(struct hv_device *dev,
+static int rndis_filter_send(struct vm_device *dev,
 			     struct hv_netvsc_packet *pkt);
 
 static void rndis_filter_send_completion(void *ctx);
@@ -375,7 +376,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 						   pkt);
 }
 
-static int rndis_filter_receive(struct hv_device *dev,
+static int rndis_filter_receive(struct vm_device *dev,
 				struct hv_netvsc_packet	*pkt)
 {
 	struct netvsc_device *net_dev = dev->ext;
@@ -753,7 +754,7 @@ static int rndis_filter_close_device(struct rndis_device *dev)
 	return ret;
 }
 
-static int rndis_filte_device_add(struct hv_device *dev,
+static int rndis_filte_device_add(struct vm_device *dev,
 				  void *additional_info)
 {
 	int ret;
@@ -816,7 +817,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	return ret;
 }
 
-static int rndis_filter_device_remove(struct hv_device *dev)
+static int rndis_filter_device_remove(struct vm_device *dev)
 {
 	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev = net_dev->extension;
@@ -837,7 +838,7 @@ static void rndis_filter_cleanup(struct hv_driver *drv)
 {
 }
 
-int rndis_filter_open(struct hv_device *dev)
+int rndis_filter_open(struct vm_device *dev)
 {
 	struct netvsc_device *netDevice = dev->ext;
 
@@ -847,7 +848,7 @@ int rndis_filter_open(struct hv_device *dev)
 	return rndis_filter_open_device(netDevice->extension);
 }
 
-int rndis_filter_close(struct hv_device *dev)
+int rndis_filter_close(struct vm_device *dev)
 {
 	struct netvsc_device *netDevice = dev->ext;
 
@@ -857,7 +858,7 @@ int rndis_filter_close(struct hv_device *dev)
 	return rndis_filter_close_device(netDevice->extension);
 }
 
-static int rndis_filter_send(struct hv_device *dev,
+static int rndis_filter_send(struct vm_device *dev,
 			     struct hv_netvsc_packet *pkt)
 {
 	int ret;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index e2ad729..7b75ab5 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include "hv_api.h"
+#include "vmbus.h"
 #include "logging.h"
 #include "storvsc_api.h"
 #include "vmbus_packet_format.h"
@@ -37,7 +38,7 @@ struct storvsc_request_extension {
 	/* LIST_ENTRY ListEntry; */
 
 	struct hv_storvsc_request *request;
-	struct hv_device *device;
+	struct vm_device *device;
 
 	/* Synchronize the request/response if needed */
 	int wait_condition;
@@ -48,7 +49,7 @@ struct storvsc_request_extension {
 
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
-	struct hv_device *device;
+	struct vm_device *device;
 
 	/* 0 indicates the device is being destroyed */
 	atomic_t ref_count;
@@ -84,7 +85,7 @@ static const struct hv_guid gStorVscDeviceType = {
 };
 
 
-static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
+static inline struct storvsc_device *alloc_stor_device(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -109,7 +110,7 @@ static inline void free_stor_device(struct storvsc_device *device)
 }
 
 /* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct hv_device *device)
+static inline struct storvsc_device *get_stor_device(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -124,7 +125,7 @@ static inline struct storvsc_device *get_stor_device(struct hv_device *device)
 
 /* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *must_get_stor_device(
-					struct hv_device *device)
+					struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -137,7 +138,7 @@ static inline struct storvsc_device *must_get_stor_device(
 	return stor_device;
 }
 
-static inline void put_stor_device(struct hv_device *device)
+static inline void put_stor_device(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -150,7 +151,7 @@ static inline void put_stor_device(struct hv_device *device)
 
 /* Drop ref count to 1 to effectively disable get_stor_device() */
 static inline struct storvsc_device *release_stor_device(
-					struct hv_device *device)
+					struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -166,7 +167,7 @@ static inline struct storvsc_device *release_stor_device(
 
 /* Drop ref count to 0. No one can use stor_device object. */
 static inline struct storvsc_device *final_release_stor_device(
-			struct hv_device *device)
+			struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -181,7 +182,7 @@ static inline struct storvsc_device *final_release_stor_device(
 	return stor_device;
 }
 
-static int stor_vsc_channel_init(struct hv_device *device)
+static int stor_vsc_channel_init(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
@@ -362,7 +363,7 @@ cleanup:
 	return ret;
 }
 
-static void stor_vsc_on_io_completion(struct hv_device *device,
+static void stor_vsc_on_io_completion(struct vm_device *device,
 				  struct vstor_packet *vstor_packet,
 				  struct storvsc_request_extension *request_ext)
 {
@@ -426,7 +427,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 	put_stor_device(device);
 }
 
-static void stor_vsc_on_receive(struct hv_device *device,
+static void stor_vsc_on_receive(struct vm_device *device,
 			     struct vstor_packet *vstor_packet,
 			     struct storvsc_request_extension *request_ext)
 {
@@ -449,7 +450,7 @@ static void stor_vsc_on_receive(struct hv_device *device,
 
 static void stor_vsc_on_channel_callback(void *context)
 {
-	struct hv_device *device = (struct hv_device *)context;
+	struct vm_device *device = (struct vm_device *)context;
 	struct storvsc_device *stor_device;
 	u32 bytes_recvd;
 	u64 request_id;
@@ -509,7 +510,7 @@ static void stor_vsc_on_channel_callback(void *context)
 	return;
 }
 
-static int stor_vsc_connect_to_vsp(struct hv_device *device)
+static int stor_vsc_connect_to_vsp(struct vm_device *device)
 {
 	struct vmstorage_channel_properties props;
 	struct storvsc_driver_object *stor_driver;
@@ -543,7 +544,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *device)
  * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-static int stor_vsc_on_device_add(struct hv_device *device,
+static int stor_vsc_on_device_add(struct vm_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
@@ -592,7 +593,7 @@ cleanup:
 /*
  * stor_vsc_on_device_remove - Callback when the our device is being removed
  */
-static int stor_vsc_on_device_remove(struct hv_device *device)
+static int stor_vsc_on_device_remove(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -626,7 +627,7 @@ static int stor_vsc_on_device_remove(struct hv_device *device)
 	return 0;
 }
 
-int stor_vsc_on_host_reset(struct hv_device *device)
+int stor_vsc_on_host_reset(struct vm_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
@@ -685,7 +686,7 @@ cleanup:
 /*
  * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
-static int stor_vsc_on_io_request(struct hv_device *device,
+static int stor_vsc_on_io_request(struct vm_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
@@ -804,7 +805,7 @@ int stor_vsc_initialize(struct hv_driver *driver)
 	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_driver_name;
-	memcpy(&driver->dev_type, &gStorVscDeviceType,
+	memcpy(&driver->class_id, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
 	stor_driver->request_ext_size =
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index fbf5755..8bed6f5 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -92,7 +92,7 @@ struct storvsc_driver_object {
 	u32 max_outstanding_req_per_channel;
 
 	/* Specific to this driver */
-	int (*on_io_request)(struct hv_device *device,
+	int (*on_io_request)(struct vm_device *device,
 			   struct hv_storvsc_request *request);
 };
 
@@ -104,7 +104,7 @@ struct storvsc_device_info {
 
 /* Interface */
 int stor_vsc_initialize(struct hv_driver *driver);
-int stor_vsc_on_host_reset(struct hv_device *device);
+int stor_vsc_on_host_reset(struct vm_device *device);
 int blk_vsc_initialize(struct hv_driver *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index a8427ff..216d8ff 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -32,6 +32,7 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 #include "hv_api.h"
+#include "vmbus.h"
 #include "logging.h"
 #include "version_info.h"
 #include "vmbus.h"
@@ -161,7 +162,7 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	}
 
 	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = storvsc_probe;
@@ -225,8 +226,7 @@ static int storvsc_probe(struct device *device)
 				(struct storvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&storvsc_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
 	struct storvsc_device_info device_info;
@@ -247,10 +247,10 @@ static int storvsc_probe(struct device *device)
 	memset(host_device_ctx, 0, sizeof(struct host_device_context));
 
 	host_device_ctx->port = host->host_no;
-	host_device_ctx->device_ctx = device_ctx;
+	host_device_ctx->device_ctx = device_obj;
 
 	host_device_ctx->request_pool =
-				kmem_cache_create(dev_name(&device_ctx->device),
+				kmem_cache_create(dev_name(&device_obj->device),
 					sizeof(struct storvsc_cmd_request) +
 					storvsc_drv_obj->request_ext_size, 0,
 					SLAB_HWCACHE_ALIGN, NULL);
@@ -310,8 +310,7 @@ static int storvsc_remove(struct device *device)
 			(struct storvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
-	struct vm_device *device_ctx = device_to_vm_device(device);
-	struct hv_device *device_obj = &device_ctx->device_obj;
+	struct vm_device *device_obj = device_to_vm_device(device);
 	struct Scsi_Host *host = dev_get_drvdata(device);
 	struct host_device_context *host_device_ctx =
 			(struct host_device_context *)host->hostdata;
@@ -752,7 +751,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 retry_request:
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_drv_obj->on_io_request(&device_ctx->device_obj,
+	ret = storvsc_drv_obj->on_io_request(device_ctx,
 					   &cmd_request->request);
 	if (ret == -1) {
 		/* no more space */
@@ -842,15 +841,15 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	struct vm_device *device_ctx = host_device_ctx->device_ctx;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
-		    scmnd->device, &device_ctx->device_obj);
+		    scmnd->device, device_ctx);
 
 	/* Invokes the vsc to reset the host/bus */
-	ret = stor_vsc_on_host_reset(&device_ctx->device_obj);
+	ret = stor_vsc_on_host_reset(device_ctx);
 	if (ret != 0)
 		return ret;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host reseted",
-		    scmnd->device, &device_ctx->device_obj);
+		    scmnd->device, device_ctx);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 42f2adb..e56e61a 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -44,18 +44,17 @@ struct driver_context {
 };
 
 struct vm_device {
+	char name[64];
 	struct work_struct probe_failed_work_item;
-	struct hv_guid class_id;
-	struct hv_guid device_id;
+	struct hv_guid class_id; /* device type id */
+	struct hv_guid device_id; /* device instance id */
+	struct hv_driver *drv;
 	int probe_error;
-	struct hv_device device_obj;
+	struct vmbus_channel *channel; /* associated channel to host*/
+	void    *ext;
 	struct device device;
 };
 
-static inline struct vm_device *to_vm_device(struct hv_device *d)
-{
-	return container_of(d, struct vm_device, device_obj);
-}
 
 static inline struct vm_device *device_to_vm_device(struct device *d)
 {
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 635ce22..bf84fb0 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -56,7 +56,7 @@ struct hv_multipage_buffer {
 #pragma pack(pop)
 
 struct hv_driver;
-struct hv_device;
+struct vm_device;
 
 struct hv_dev_port_info {
 	u32 int_mask;
@@ -66,7 +66,7 @@ struct hv_dev_port_info {
 	u32 bytes_avail_towrite;
 };
 
-struct hv_device_info {
+struct vm_device_info {
 	u32 chn_id;
 	u32 chn_state;
 	struct hv_guid chn_type;
@@ -89,30 +89,11 @@ struct hv_driver {
 	const char *name;
 
 	/* the device type supported by this driver */
-	struct hv_guid dev_type;
+	struct hv_guid class_id;
 
-	int (*dev_add)(struct hv_device *device, void *data);
-	int (*dev_rm)(struct hv_device *device);
+	int (*dev_add)(struct vm_device *device, void *data);
+	int (*dev_rm)(struct vm_device *device);
 	void (*cleanup)(struct hv_driver *driver);
 };
 
-/* Base device object */
-struct hv_device {
-	/* the driver for this device */
-	struct hv_driver *drv;
-
-	char name[64];
-
-	/* the device type id of this device */
-	struct hv_guid dev_type;
-
-	/* the device instance id of this device */
-	struct hv_guid dev_instance;
-
-	struct vmbus_channel *channel;
-
-	/* Device extension; */
-	void *ext;
-};
-
 #endif /* _VMBUS_API_H_ */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 459c707..531b68d 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -145,12 +145,12 @@ static const struct hv_guid device_id = {
 	}
 };
 
-static struct hv_device *vmbus_device; /* vmbus root device */
+static struct vm_device *vmbus_device; /* vmbus root device */
 
 /*
  * vmbus_child_dev_add - Registers the child device with the vmbus
  */
-int vmbus_child_dev_add(struct hv_device *child_dev)
+int vmbus_child_dev_add(struct vm_device *child_dev)
 {
 	return vmbus_child_device_register(vmbus_device, child_dev);
 }
@@ -158,15 +158,15 @@ int vmbus_child_dev_add(struct hv_device *child_dev)
 /*
  * vmbus_dev_add - Callback when the root bus device is added
  */
-static int vmbus_dev_add(struct hv_device *dev, void *info)
+static int vmbus_dev_add(struct vm_device *dev, void *info)
 {
 	u32 *irqvector = info;
 	int ret;
 
 	vmbus_device = dev;
 
-	memcpy(&vmbus_device->dev_type, &device_type, sizeof(struct hv_guid));
-	memcpy(&vmbus_device->dev_instance, &device_id,
+	memcpy(&vmbus_device->class_id, &device_type, sizeof(struct hv_guid));
+	memcpy(&vmbus_device->device_id, &device_id,
 	       sizeof(struct hv_guid));
 
 	/* strcpy(dev->name, "vmbus"); */
@@ -183,7 +183,7 @@ static int vmbus_dev_add(struct hv_device *dev, void *info)
 /*
  * vmbus_dev_rm - Callback when the root bus device is removed
  */
-static int vmbus_dev_rm(struct hv_device *dev)
+static int vmbus_dev_rm(struct vm_device *dev)
 {
 	int ret = 0;
 
@@ -299,8 +299,8 @@ static int vmbus_on_isr(struct hv_driver *drv)
 	return ret;
 }
 
-static void get_channel_info(struct hv_device *device,
-			     struct hv_device_info *info)
+static void get_channel_info(struct vm_device *device,
+			     struct vm_device_info *info)
 {
 	struct vmbus_channel_debug_info debug_info;
 
@@ -355,11 +355,11 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 				      char *buf)
 {
 	struct vm_device *device_ctx = device_to_vm_device(dev);
-	struct hv_device_info device_info;
+	struct vm_device_info device_info;
 
-	memset(&device_info, 0, sizeof(struct hv_device_info));
+	memset(&device_info, 0, sizeof(struct vm_device_info));
 
-	get_channel_info(&device_ctx->device_obj, &device_info);
+	get_channel_info(device_ctx, &device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
@@ -480,7 +480,7 @@ static int vmbus_bus_init(void)
 			sizeof(struct vmbus_channel_packet_multipage_buffer));
 
 	driver->name = driver_name;
-	memcpy(&driver->dev_type, &device_type, sizeof(struct hv_guid));
+	memcpy(&driver->class_id, &device_type, sizeof(struct hv_guid));
 
 	/* Setup dispatch table */
 	driver->dev_add	= vmbus_dev_add;
@@ -537,7 +537,7 @@ static int vmbus_bus_init(void)
 	/* Call to bus driver to add the root device */
 	memset(dev_ctx, 0, sizeof(struct vm_device));
 
-	ret = driver->dev_add(&dev_ctx->device_obj, &vector);
+	ret = driver->dev_add(dev_ctx, &vector);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to add vmbus root device");
@@ -551,10 +551,6 @@ static int vmbus_bus_init(void)
 	}
 	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
 	dev_set_name(&dev_ctx->device, "vmbus_0_0");
-	memcpy(&dev_ctx->class_id, &dev_ctx->device_obj.dev_type,
-		sizeof(struct hv_guid));
-	memcpy(&dev_ctx->device_id, &dev_ctx->device_obj.dev_instance,
-		sizeof(struct hv_guid));
 
 	/* No need to bind a driver to the root device. */
 	dev_ctx->device.parent = NULL;
@@ -598,7 +594,7 @@ static void vmbus_bus_exit(void)
 
 	/* Remove the root device */
 	if (driver->dev_rm)
-		driver->dev_rm(&dev_ctx->device_obj);
+		driver->dev_rm(dev_ctx);
 
 	if (driver->cleanup)
 		driver->cleanup(driver);
@@ -671,12 +667,11 @@ EXPORT_SYMBOL(vmbus_child_driver_unregister);
  * vmbus_child_device_create - Creates and registers a new child device
  * on the vmbus.
  */
-struct hv_device *vmbus_child_device_create(struct hv_guid *type,
+struct vm_device *vmbus_child_device_create(struct hv_guid *type,
 					    struct hv_guid *instance,
 					    struct vmbus_channel *channel)
 {
 	struct vm_device *child_device_ctx;
-	struct hv_device *child_device_obj;
 
 	/* Allocate the new child device */
 	child_device_ctx = kzalloc(sizeof(struct vm_device), GFP_KERNEL);
@@ -705,58 +700,50 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 		instance->data[12], instance->data[13],
 		instance->data[14], instance->data[15]);
 
-	child_device_obj = &child_device_ctx->device_obj;
-	child_device_obj->channel = channel;
-	memcpy(&child_device_obj->dev_type, type, sizeof(struct hv_guid));
-	memcpy(&child_device_obj->dev_instance, instance,
-	       sizeof(struct hv_guid));
+	child_device_ctx->channel = channel;
 
 	memcpy(&child_device_ctx->class_id, type, sizeof(struct hv_guid));
 	memcpy(&child_device_ctx->device_id, instance, sizeof(struct hv_guid));
 
-	return child_device_obj;
+	return child_device_ctx;
 }
 
 /*
  * vmbus_child_device_register - Register the child device on the specified bus
  */
-int vmbus_child_device_register(struct hv_device *root_device_obj,
-				struct hv_device *child_device_obj)
+int vmbus_child_device_register(struct vm_device *root_device_obj,
+				struct vm_device *child_device_obj)
 {
 	int ret = 0;
-	struct vm_device *root_device_ctx =
-				to_vm_device(root_device_obj);
-	struct vm_device *child_device_ctx =
-				to_vm_device(child_device_obj);
 	static atomic_t device_num = ATOMIC_INIT(0);
 
 	DPRINT_DBG(VMBUS_DRV, "child device (%p) registering",
-		   child_device_ctx);
+		   child_device_obj);
 
 	/* Set the device name. Otherwise, device_register() will fail. */
-	dev_set_name(&child_device_ctx->device, "vmbus_0_%d",
+	dev_set_name(&child_device_obj->device, "vmbus_0_%d",
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_ctx->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
-	child_device_ctx->device.parent = &root_device_ctx->device;
-	child_device_ctx->device.release = vmbus_device_release;
+	child_device_obj->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
+	child_device_obj->device.parent = &root_device_obj->device;
+	child_device_obj->device.release = vmbus_device_release;
 
 	/*
 	 * Register with the LDM. This will kick off the driver/device
 	 * binding...which will eventually call vmbus_match() and vmbus_probe()
 	 */
-	ret = device_register(&child_device_ctx->device);
+	ret = device_register(&child_device_obj->device);
 
 	/* vmbus_probe() error does not get propergate to device_register(). */
-	ret = child_device_ctx->probe_error;
+	ret = child_device_obj->probe_error;
 
 	if (ret)
 		DPRINT_ERR(VMBUS_DRV, "unable to register child device (%p)",
-			   &child_device_ctx->device);
+			   &child_device_obj->device);
 	else
 		DPRINT_INFO(VMBUS_DRV, "child device (%p) registered",
-			    &child_device_ctx->device);
+			    &child_device_obj->device);
 
 	return ret;
 }
@@ -765,21 +752,20 @@ int vmbus_child_device_register(struct hv_device *root_device_obj,
  * vmbus_child_device_unregister - Remove the specified child device
  * from the vmbus.
  */
-void vmbus_child_device_unregister(struct hv_device *device_obj)
+void vmbus_child_device_unregister(struct vm_device *device_obj)
 {
-	struct vm_device *device_ctx = to_vm_device(device_obj);
 
 	DPRINT_INFO(VMBUS_DRV, "unregistering child device (%p)",
-		    &device_ctx->device);
+		    &device_obj->device);
 
 	/*
 	 * Kick off the process of unregistering the device.
 	 * This will call vmbus_remove() and eventually vmbus_device_release()
 	 */
-	device_unregister(&device_ctx->device);
+	device_unregister(&device_obj->device);
 
 	DPRINT_INFO(VMBUS_DRV, "child device (%p) unregistered",
-		    &device_ctx->device);
+		    &device_obj->device);
 }
 
 /*
@@ -876,11 +862,11 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		struct vmbus_driver_context *vmbus_drv_ctx =
 			(struct vmbus_driver_context *)driver_ctx;
 
-		device_ctx->device_obj.drv = &vmbus_drv_ctx->drv_obj;
+		device_ctx->drv = &vmbus_drv_ctx->drv_obj;
 		DPRINT_INFO(VMBUS_DRV,
 			    "device object (%p) set to driver object (%p)",
-			    &device_ctx->device_obj,
-			    device_ctx->device_obj.drv);
+			    &device_ctx,
+			    device_ctx->drv);
 
 		match = 1;
 	}
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 9f505c4..206218c 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -103,18 +103,18 @@ extern struct vmbus_connection vmbus_connection;
 
 /* General vmbus interface */
 
-struct hv_device *vmbus_child_device_create(struct hv_guid *type,
+struct vm_device *vmbus_child_device_create(struct hv_guid *type,
 					 struct hv_guid *instance,
 					 struct vmbus_channel *channel);
 
-int vmbus_child_dev_add(struct hv_device *device);
-int vmbus_child_device_register(struct hv_device *root_device_obj,
-				struct hv_device *child_device_obj);
-void vmbus_child_device_unregister(struct hv_device *device_obj);
+int vmbus_child_dev_add(struct vm_device *device);
+int vmbus_child_device_register(struct vm_device *root_device_obj,
+				struct vm_device *child_device_obj);
+void vmbus_child_device_unregister(struct vm_device *device_obj);
 
 /* static void */
 /* VmbusChildDeviceDestroy( */
-/* struct hv_device *); */
+/* struct vm_device *); */
 
 struct vmbus_channel *relid2channel(u32 relid);
 
-- 
1.5.5.6

