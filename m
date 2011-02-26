Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab1BZB5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:57:20 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53820
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751087Ab1BZB5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:57:19 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 2/6] Staging: hv: Rename vm_device to hyperv_device
Date: Fri, 25 Feb 2011 18:06:03 -0800
Message-Id: <1298685963-30831-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the vm_device abstraction as hyperv_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c        |    4 +-
 drivers/staging/hv/blkvsc_drv.c    |    8 ++--
 drivers/staging/hv/channel_mgmt.h  |    2 +-
 drivers/staging/hv/netvsc.c        |   56 +++++++++++++++++++----------------
 drivers/staging/hv/netvsc.h        |    2 +-
 drivers/staging/hv/netvsc_api.h    |   12 ++++----
 drivers/staging/hv/netvsc_drv.c    |   14 ++++----
 drivers/staging/hv/rndis_filter.c  |   18 ++++++------
 drivers/staging/hv/storvsc.c       |   36 ++++++++++++-----------
 drivers/staging/hv/storvsc_api.h   |    4 +-
 drivers/staging/hv/storvsc_drv.c   |   10 +++---
 drivers/staging/hv/vmbus.h         |    6 ++--
 drivers/staging/hv/vmbus_api.h     |    8 ++--
 drivers/staging/hv/vmbus_drv.c     |   50 ++++++++++++++++----------------
 drivers/staging/hv/vmbus_private.h |   12 ++++----
 15 files changed, 124 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index ecface3..47ccec2 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -35,8 +35,8 @@ static const struct hv_guid g_blk_device_type = {
 	}
 };
 
-static int blk_vsc_on_device_add(struct vm_device *device,
-				void *additional_info)
+static int
+blk_vsc_on_device_add(struct hyperv_device *device, void *additional_info)
 {
 	struct storvsc_device_info *device_info;
 	int ret = 0;
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 6d1a783..58ab0e8 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -95,7 +95,7 @@ struct blkvsc_request {
 /* Per device structure */
 struct block_device_context {
 	/* point back to our device context */
-	struct vm_device *device_ctx;
+	struct hyperv_device *device_ctx;
 	struct kmem_cache *request_pool;
 	spinlock_t lock;
 	struct gendisk *gd;
@@ -249,7 +249,7 @@ static int blkvsc_probe(struct device *device)
 				(struct blkvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
 	struct block_device_context *blkdev = NULL;
 	struct storvsc_device_info device_info;
@@ -733,7 +733,7 @@ static int blkvsc_remove(struct device *device)
 				(struct blkvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct block_device_context *blkdev = dev_get_drvdata(device);
 	unsigned long flags;
 	int ret;
@@ -848,7 +848,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 			void (*request_completion)(struct hv_storvsc_request *))
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
-	struct vm_device *device_ctx = blkdev->device_ctx;
+	struct hyperv_device *device_ctx = blkdev->device_ctx;
 	struct driver_context *driver_ctx =
 			driver_to_driver_context(device_ctx->device.driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index b3a9214..7b42883 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -228,7 +228,7 @@ enum vmbus_channel_state {
 struct vmbus_channel {
 	struct list_head listentry;
 
-	struct vm_device *device_obj;
+	struct hyperv_device *device_obj;
 
 	struct timer_list poll_timer; /* SA-111 workaround */
 	struct work_struct work;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index ff8e5be..7841cae 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -44,40 +44,41 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int netvsc_device_add(struct vm_device *device, void *additional_info);
+static int netvsc_device_add(struct hyperv_device *device,
+			void *additional_info);
 
-static int netvsc_device_remove(struct vm_device *device);
+static int netvsc_device_remove(struct hyperv_device *device);
 
 static void netvsc_cleanup(struct hv_driver *driver);
 
 static void netvsc_channel_cb(void *context);
 
-static int netvsc_init_send_buf(struct vm_device *device);
+static int netvsc_init_send_buf(struct hyperv_device *device);
 
-static int netvsc_init_recv_buf(struct vm_device *device);
+static int netvsc_init_recv_buf(struct hyperv_device *device);
 
 static int netvsc_destroy_send_buf(struct netvsc_device *net_device);
 
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device);
 
-static int netvsc_connect_vsp(struct vm_device *device);
+static int netvsc_connect_vsp(struct hyperv_device *device);
 
-static void netvsc_send_completion(struct vm_device *device,
+static void netvsc_send_completion(struct hyperv_device *device,
 				   struct vmpacket_descriptor *packet);
 
-static int netvsc_send(struct vm_device *device,
+static int netvsc_send(struct hyperv_device *device,
 			struct hv_netvsc_packet *packet);
 
-static void netvsc_receive(struct vm_device *device,
+static void netvsc_receive(struct hyperv_device *device,
 			    struct vmpacket_descriptor *packet);
 
 static void netvsc_receive_completion(void *context);
 
-static void netvsc_send_recv_completion(struct vm_device *device,
+static void netvsc_send_recv_completion(struct hyperv_device *device,
 					u64 transaction_id);
 
 
-static struct netvsc_device *alloc_net_device(struct vm_device *device)
+static struct netvsc_device *alloc_net_device(struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -103,7 +104,8 @@ static void free_net_device(struct netvsc_device *device)
 
 
 /* Get the net device object iff exists and its refcount > 1 */
-static struct netvsc_device *get_outbound_net_device(struct vm_device *device)
+static struct netvsc_device *
+get_outbound_net_device(struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -117,7 +119,8 @@ static struct netvsc_device *get_outbound_net_device(struct vm_device *device)
 }
 
 /* Get the net device object iff exists and its refcount > 0 */
-static struct netvsc_device *get_inbound_net_device(struct vm_device *device)
+static struct netvsc_device *
+get_inbound_net_device(struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -130,7 +133,7 @@ static struct netvsc_device *get_inbound_net_device(struct vm_device *device)
 	return net_device;
 }
 
-static void put_net_device(struct vm_device *device)
+static void put_net_device(struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -140,7 +143,7 @@ static void put_net_device(struct vm_device *device)
 }
 
 static struct netvsc_device *release_outbound_net_device(
-		struct vm_device *device)
+		struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -156,7 +159,7 @@ static struct netvsc_device *release_outbound_net_device(
 }
 
 static struct netvsc_device *release_inbound_net_device(
-		struct vm_device *device)
+		struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -200,7 +203,7 @@ int netvsc_initialize(struct hv_driver *drv)
 	return 0;
 }
 
-static int netvsc_init_recv_buf(struct vm_device *device)
+static int netvsc_init_recv_buf(struct hyperv_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
@@ -330,7 +333,7 @@ exit:
 	return ret;
 }
 
-static int netvsc_init_send_buf(struct vm_device *device)
+static int netvsc_init_send_buf(struct hyperv_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
@@ -572,7 +575,7 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 }
 
 
-static int netvsc_connect_vsp(struct vm_device *device)
+static int netvsc_connect_vsp(struct hyperv_device *device)
 {
 	int ret;
 	struct netvsc_device *net_device;
@@ -688,7 +691,8 @@ static void NetVscDisconnectFromVsp(struct netvsc_device *net_device)
  * netvsc_device_add - Callback when the device belonging to this
  * driver is added
  */
-static int netvsc_device_add(struct vm_device *device, void *additional_info)
+static int
+netvsc_device_add(struct hyperv_device *device, void *additional_info)
 {
 	int ret = 0;
 	int i;
@@ -781,7 +785,7 @@ cleanup:
 /*
  * netvsc_device_remove - Callback when the root bus device is removed
  */
-static int netvsc_device_remove(struct vm_device *device)
+static int netvsc_device_remove(struct hyperv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
@@ -837,7 +841,7 @@ static void netvsc_cleanup(struct hv_driver *drv)
 {
 }
 
-static void netvsc_send_completion(struct vm_device *device,
+static void netvsc_send_completion(struct hyperv_device *device,
 				   struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
@@ -886,7 +890,7 @@ static void netvsc_send_completion(struct vm_device *device,
 	put_net_device(device);
 }
 
-static int netvsc_send(struct vm_device *device,
+static int netvsc_send(struct hyperv_device *device,
 			struct hv_netvsc_packet *packet)
 {
 	struct netvsc_device *net_device;
@@ -940,7 +944,7 @@ static int netvsc_send(struct vm_device *device,
 	return ret;
 }
 
-static void netvsc_receive(struct vm_device *device,
+static void netvsc_receive(struct hyperv_device *device,
 			    struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
@@ -1137,7 +1141,7 @@ static void netvsc_receive(struct vm_device *device,
 	put_net_device(device);
 }
 
-static void netvsc_send_recv_completion(struct vm_device *device,
+static void netvsc_send_recv_completion(struct hyperv_device *device,
 					u64 transaction_id)
 {
 	struct nvsp_message recvcompMessage;
@@ -1186,7 +1190,7 @@ retry_send_cmplt:
 static void netvsc_receive_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = context;
-	struct vm_device *device = (struct vm_device *)packet->device;
+	struct hyperv_device *device = (struct hyperv_device *)packet->device;
 	struct netvsc_device *net_device;
 	u64 transaction_id = 0;
 	bool fsend_receive_comp = false;
@@ -1235,7 +1239,7 @@ static void netvsc_receive_completion(void *context)
 static void netvsc_channel_cb(void *context)
 {
 	int ret;
-	struct vm_device *device = context;
+	struct hyperv_device *device = context;
 	struct netvsc_device *net_device;
 	u32 bytes_recvd;
 	u64 request_id;
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index b2709eb..ea3a05f 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -293,7 +293,7 @@ struct nvsp_message {
 
 /* Per netvsc channel-specific */
 struct netvsc_device {
-	struct vm_device *dev;
+	struct hyperv_device *dev;
 
 	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index a9cfeff..e43ff7b 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -49,7 +49,7 @@ struct hv_netvsc_packet {
 	/* Bookkeeping stuff */
 	struct list_head list_ent;
 
-	struct vm_device *device;
+	struct hyperv_device *device;
 	bool is_data_pkt;
 
 	/*
@@ -93,12 +93,12 @@ struct netvsc_driver {
 	 * This is set by the caller to allow us to callback when we
 	 * receive a packet from the "wire"
 	 */
-	int (*recv_cb)(struct vm_device *dev,
+	int (*recv_cb)(struct hyperv_device *dev,
 				 struct hv_netvsc_packet *packet);
-	void (*link_status_change)(struct vm_device *dev, u32 status);
+	void (*link_status_change)(struct hyperv_device *dev, u32 status);
 
 	/* Specific to this driver */
-	int (*send)(struct vm_device *dev, struct hv_netvsc_packet *packet);
+	int (*send)(struct hyperv_device *dev, struct hv_netvsc_packet *packet);
 
 	void *ctx;
 };
@@ -110,7 +110,7 @@ struct netvsc_device_info {
 
 /* Interface */
 int netvsc_initialize(struct hv_driver *drv);
-int rndis_filter_open(struct vm_device *dev);
-int rndis_filter_close(struct vm_device *dev);
+int rndis_filter_open(struct hyperv_device *dev);
+int rndis_filter_close(struct hyperv_device *dev);
 
 #endif /* _NETVSC_API_H_ */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 055986f..31cbbab 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -44,7 +44,7 @@
 
 struct net_device_context {
 	/* point back to our device context */
-	struct vm_device *device_ctx;
+	struct hyperv_device *device_ctx;
 	unsigned long avail;
 };
 
@@ -76,7 +76,7 @@ static void netvsc_set_multicast_list(struct net_device *net)
 static int netvsc_open(struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct vm_device *device_obj = net_device_ctx->device_ctx;
+	struct hyperv_device *device_obj = net_device_ctx->device_ctx;
 	int ret = 0;
 
 	if (netif_carrier_ok(net)) {
@@ -99,7 +99,7 @@ static int netvsc_open(struct net_device *net)
 static int netvsc_close(struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct vm_device *device_obj = net_device_ctx->device_ctx;
+	struct hyperv_device *device_obj = net_device_ctx->device_ctx;
 	int ret;
 
 	netif_stop_queue(net);
@@ -223,7 +223,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 /*
  * netvsc_linkstatus_callback - Link up/down notification
  */
-static void netvsc_linkstatus_callback(struct vm_device *device_obj,
+static void netvsc_linkstatus_callback(struct hyperv_device *device_obj,
 				       unsigned int status)
 {
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
@@ -248,7 +248,7 @@ static void netvsc_linkstatus_callback(struct vm_device *device_obj,
  * netvsc_recv_callback -  Callback when we receive a packet from the
  * "wire" on the specified device.
  */
-static int netvsc_recv_callback(struct vm_device *device_obj,
+static int netvsc_recv_callback(struct hyperv_device *device_obj,
 				struct hv_netvsc_packet *packet)
 {
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
@@ -343,7 +343,7 @@ static int netvsc_probe(struct device *device)
 	struct netvsc_driver_context *net_drv_ctx =
 		(struct netvsc_driver_context *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info device_info;
@@ -414,7 +414,7 @@ static int netvsc_remove(struct device *device)
 	struct netvsc_driver_context *net_drv_ctx =
 		(struct netvsc_driver_context *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
 	int ret;
 
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e0b1b44..b718fa9 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -85,14 +85,14 @@ struct rndis_filter_packet {
 };
 
 
-static int rndis_filte_device_add(struct vm_device *dev,
+static int rndis_filte_device_add(struct hyperv_device *dev,
 				  void *additional_info);
 
-static int rndis_filter_device_remove(struct vm_device *dev);
+static int rndis_filter_device_remove(struct hyperv_device *dev);
 
 static void rndis_filter_cleanup(struct hv_driver *drv);
 
-static int rndis_filter_send(struct vm_device *dev,
+static int rndis_filter_send(struct hyperv_device *dev,
 			     struct hv_netvsc_packet *pkt);
 
 static void rndis_filter_send_completion(void *ctx);
@@ -376,7 +376,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 						   pkt);
 }
 
-static int rndis_filter_receive(struct vm_device *dev,
+static int rndis_filter_receive(struct hyperv_device *dev,
 				struct hv_netvsc_packet	*pkt)
 {
 	struct netvsc_device *net_dev = dev->ext;
@@ -754,7 +754,7 @@ static int rndis_filter_close_device(struct rndis_device *dev)
 	return ret;
 }
 
-static int rndis_filte_device_add(struct vm_device *dev,
+static int rndis_filte_device_add(struct hyperv_device *dev,
 				  void *additional_info)
 {
 	int ret;
@@ -817,7 +817,7 @@ static int rndis_filte_device_add(struct vm_device *dev,
 	return ret;
 }
 
-static int rndis_filter_device_remove(struct vm_device *dev)
+static int rndis_filter_device_remove(struct hyperv_device *dev)
 {
 	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev = net_dev->extension;
@@ -838,7 +838,7 @@ static void rndis_filter_cleanup(struct hv_driver *drv)
 {
 }
 
-int rndis_filter_open(struct vm_device *dev)
+int rndis_filter_open(struct hyperv_device *dev)
 {
 	struct netvsc_device *netDevice = dev->ext;
 
@@ -848,7 +848,7 @@ int rndis_filter_open(struct vm_device *dev)
 	return rndis_filter_open_device(netDevice->extension);
 }
 
-int rndis_filter_close(struct vm_device *dev)
+int rndis_filter_close(struct hyperv_device *dev)
 {
 	struct netvsc_device *netDevice = dev->ext;
 
@@ -858,7 +858,7 @@ int rndis_filter_close(struct vm_device *dev)
 	return rndis_filter_close_device(netDevice->extension);
 }
 
-static int rndis_filter_send(struct vm_device *dev,
+static int rndis_filter_send(struct hyperv_device *dev,
 			     struct hv_netvsc_packet *pkt)
 {
 	int ret;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 7b75ab5..6000b0d 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -38,7 +38,7 @@ struct storvsc_request_extension {
 	/* LIST_ENTRY ListEntry; */
 
 	struct hv_storvsc_request *request;
-	struct vm_device *device;
+	struct hyperv_device *device;
 
 	/* Synchronize the request/response if needed */
 	int wait_condition;
@@ -49,7 +49,7 @@ struct storvsc_request_extension {
 
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
-	struct vm_device *device;
+	struct hyperv_device *device;
 
 	/* 0 indicates the device is being destroyed */
 	atomic_t ref_count;
@@ -85,7 +85,8 @@ static const struct hv_guid gStorVscDeviceType = {
 };
 
 
-static inline struct storvsc_device *alloc_stor_device(struct vm_device *device)
+static inline struct storvsc_device *
+alloc_stor_device(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -110,7 +111,8 @@ static inline void free_stor_device(struct storvsc_device *device)
 }
 
 /* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct vm_device *device)
+static inline struct storvsc_device *
+get_stor_device(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -125,7 +127,7 @@ static inline struct storvsc_device *get_stor_device(struct vm_device *device)
 
 /* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *must_get_stor_device(
-					struct vm_device *device)
+					struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -138,7 +140,7 @@ static inline struct storvsc_device *must_get_stor_device(
 	return stor_device;
 }
 
-static inline void put_stor_device(struct vm_device *device)
+static inline void put_stor_device(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -151,7 +153,7 @@ static inline void put_stor_device(struct vm_device *device)
 
 /* Drop ref count to 1 to effectively disable get_stor_device() */
 static inline struct storvsc_device *release_stor_device(
-					struct vm_device *device)
+					struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -167,7 +169,7 @@ static inline struct storvsc_device *release_stor_device(
 
 /* Drop ref count to 0. No one can use stor_device object. */
 static inline struct storvsc_device *final_release_stor_device(
-			struct vm_device *device)
+			struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -182,7 +184,7 @@ static inline struct storvsc_device *final_release_stor_device(
 	return stor_device;
 }
 
-static int stor_vsc_channel_init(struct vm_device *device)
+static int stor_vsc_channel_init(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
@@ -363,7 +365,7 @@ cleanup:
 	return ret;
 }
 
-static void stor_vsc_on_io_completion(struct vm_device *device,
+static void stor_vsc_on_io_completion(struct hyperv_device *device,
 				  struct vstor_packet *vstor_packet,
 				  struct storvsc_request_extension *request_ext)
 {
@@ -427,7 +429,7 @@ static void stor_vsc_on_io_completion(struct vm_device *device,
 	put_stor_device(device);
 }
 
-static void stor_vsc_on_receive(struct vm_device *device,
+static void stor_vsc_on_receive(struct hyperv_device *device,
 			     struct vstor_packet *vstor_packet,
 			     struct storvsc_request_extension *request_ext)
 {
@@ -450,7 +452,7 @@ static void stor_vsc_on_receive(struct vm_device *device,
 
 static void stor_vsc_on_channel_callback(void *context)
 {
-	struct vm_device *device = (struct vm_device *)context;
+	struct hyperv_device *device = (struct hyperv_device *)context;
 	struct storvsc_device *stor_device;
 	u32 bytes_recvd;
 	u64 request_id;
@@ -510,7 +512,7 @@ static void stor_vsc_on_channel_callback(void *context)
 	return;
 }
 
-static int stor_vsc_connect_to_vsp(struct vm_device *device)
+static int stor_vsc_connect_to_vsp(struct hyperv_device *device)
 {
 	struct vmstorage_channel_properties props;
 	struct storvsc_driver_object *stor_driver;
@@ -544,7 +546,7 @@ static int stor_vsc_connect_to_vsp(struct vm_device *device)
  * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-static int stor_vsc_on_device_add(struct vm_device *device,
+static int stor_vsc_on_device_add(struct hyperv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
@@ -593,7 +595,7 @@ cleanup:
 /*
  * stor_vsc_on_device_remove - Callback when the our device is being removed
  */
-static int stor_vsc_on_device_remove(struct vm_device *device)
+static int stor_vsc_on_device_remove(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -627,7 +629,7 @@ static int stor_vsc_on_device_remove(struct vm_device *device)
 	return 0;
 }
 
-int stor_vsc_on_host_reset(struct vm_device *device)
+int stor_vsc_on_host_reset(struct hyperv_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
@@ -686,7 +688,7 @@ cleanup:
 /*
  * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
-static int stor_vsc_on_io_request(struct vm_device *device,
+static int stor_vsc_on_io_request(struct hyperv_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 8bed6f5..c2915b4 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -92,7 +92,7 @@ struct storvsc_driver_object {
 	u32 max_outstanding_req_per_channel;
 
 	/* Specific to this driver */
-	int (*on_io_request)(struct vm_device *device,
+	int (*on_io_request)(struct hyperv_device *device,
 			   struct hv_storvsc_request *request);
 };
 
@@ -104,7 +104,7 @@ struct storvsc_device_info {
 
 /* Interface */
 int stor_vsc_initialize(struct hv_driver *driver);
-int stor_vsc_on_host_reset(struct vm_device *device);
+int stor_vsc_on_host_reset(struct hyperv_device *device);
 int blk_vsc_initialize(struct hv_driver *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 216d8ff..2b9a097 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -43,7 +43,7 @@ struct host_device_context {
 	/* must be 1st field
 	 * FIXME this is a bug */
 	/* point back to our device context */
-	struct vm_device *device_ctx;
+	struct hyperv_device *device_ctx;
 	struct kmem_cache *request_pool;
 	unsigned int port;
 	unsigned char path;
@@ -226,7 +226,7 @@ static int storvsc_probe(struct device *device)
 				(struct storvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&storvsc_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
 	struct storvsc_device_info device_info;
@@ -310,7 +310,7 @@ static int storvsc_remove(struct device *device)
 			(struct storvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
-	struct vm_device *device_obj = device_to_vm_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct Scsi_Host *host = dev_get_drvdata(device);
 	struct host_device_context *host_device_ctx =
 			(struct host_device_context *)host->hostdata;
@@ -600,7 +600,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	int ret;
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
-	struct vm_device *device_ctx = host_device_ctx->device_ctx;
+	struct hyperv_device *device_ctx = host_device_ctx->device_ctx;
 	struct driver_context *driver_ctx =
 		driver_to_driver_context(device_ctx->device.driver);
 	struct storvsc_driver_context *storvsc_drv_ctx =
@@ -838,7 +838,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	int ret;
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
-	struct vm_device *device_ctx = host_device_ctx->device_ctx;
+	struct hyperv_device *device_ctx = host_device_ctx->device_ctx;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
 		    scmnd->device, device_ctx);
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index e56e61a..1ac7e56 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -43,7 +43,7 @@ struct driver_context {
 	void (*shutdown)(struct device *);
 };
 
-struct vm_device {
+struct hyperv_device {
 	char name[64];
 	struct work_struct probe_failed_work_item;
 	struct hv_guid class_id; /* device type id */
@@ -56,9 +56,9 @@ struct vm_device {
 };
 
 
-static inline struct vm_device *device_to_vm_device(struct device *d)
+static inline struct hyperv_device *device_to_hyperv_device(struct device *d)
 {
-	return container_of(d, struct vm_device, device);
+	return container_of(d, struct hyperv_device, device);
 }
 
 static inline struct driver_context *driver_to_driver_context(struct device_driver *d)
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index bf84fb0..260086f 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -56,7 +56,7 @@ struct hv_multipage_buffer {
 #pragma pack(pop)
 
 struct hv_driver;
-struct vm_device;
+struct hyperv_device;
 
 struct hv_dev_port_info {
 	u32 int_mask;
@@ -66,7 +66,7 @@ struct hv_dev_port_info {
 	u32 bytes_avail_towrite;
 };
 
-struct vm_device_info {
+struct hyperv_device_info {
 	u32 chn_id;
 	u32 chn_state;
 	struct hv_guid chn_type;
@@ -91,8 +91,8 @@ struct hv_driver {
 	/* the device type supported by this driver */
 	struct hv_guid class_id;
 
-	int (*dev_add)(struct vm_device *device, void *data);
-	int (*dev_rm)(struct vm_device *device);
+	int (*dev_add)(struct hyperv_device *device, void *data);
+	int (*dev_rm)(struct hyperv_device *device);
 	void (*cleanup)(struct hv_driver *driver);
 };
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 531b68d..38152df 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -54,7 +54,7 @@ struct vmbus_driver_context {
 	struct tasklet_struct event_dpc;
 
 	/* The bus root device */
-	struct vm_device device_ctx;
+	struct hyperv_device device_ctx;
 };
 
 static int vmbus_match(struct device *device, struct device_driver *driver);
@@ -145,12 +145,12 @@ static const struct hv_guid device_id = {
 	}
 };
 
-static struct vm_device *vmbus_device; /* vmbus root device */
+static struct hyperv_device *vmbus_device; /* vmbus root device */
 
 /*
  * vmbus_child_dev_add - Registers the child device with the vmbus
  */
-int vmbus_child_dev_add(struct vm_device *child_dev)
+int vmbus_child_dev_add(struct hyperv_device *child_dev)
 {
 	return vmbus_child_device_register(vmbus_device, child_dev);
 }
@@ -158,7 +158,7 @@ int vmbus_child_dev_add(struct vm_device *child_dev)
 /*
  * vmbus_dev_add - Callback when the root bus device is added
  */
-static int vmbus_dev_add(struct vm_device *dev, void *info)
+static int vmbus_dev_add(struct hyperv_device *dev, void *info)
 {
 	u32 *irqvector = info;
 	int ret;
@@ -183,7 +183,7 @@ static int vmbus_dev_add(struct vm_device *dev, void *info)
 /*
  * vmbus_dev_rm - Callback when the root bus device is removed
  */
-static int vmbus_dev_rm(struct vm_device *dev)
+static int vmbus_dev_rm(struct hyperv_device *dev)
 {
 	int ret = 0;
 
@@ -299,8 +299,8 @@ static int vmbus_on_isr(struct hv_driver *drv)
 	return ret;
 }
 
-static void get_channel_info(struct vm_device *device,
-			     struct vm_device_info *info)
+static void get_channel_info(struct hyperv_device *device,
+			     struct hyperv_device_info *info)
 {
 	struct vmbus_channel_debug_info debug_info;
 
@@ -354,10 +354,10 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
 				      char *buf)
 {
-	struct vm_device *device_ctx = device_to_vm_device(dev);
-	struct vm_device_info device_info;
+	struct hyperv_device *device_ctx = device_to_hyperv_device(dev);
+	struct hyperv_device_info device_info;
 
-	memset(&device_info, 0, sizeof(struct vm_device_info));
+	memset(&device_info, 0, sizeof(struct hyperv_device_info));
 
 	get_channel_info(device_ctx, &device_info);
 
@@ -464,7 +464,7 @@ static int vmbus_bus_init(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 	struct hv_driver *driver = &vmbus_drv.drv_obj;
-	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
+	struct hyperv_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
 	unsigned int vector;
 
@@ -535,7 +535,7 @@ static int vmbus_bus_init(void)
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
 	/* Call to bus driver to add the root device */
-	memset(dev_ctx, 0, sizeof(struct vm_device));
+	memset(dev_ctx, 0, sizeof(struct hyperv_device));
 
 	ret = driver->dev_add(dev_ctx, &vector);
 	if (ret != 0) {
@@ -590,7 +590,7 @@ static void vmbus_bus_exit(void)
 	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
-	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
+	struct hyperv_device *dev_ctx = &vmbus_drv.device_ctx;
 
 	/* Remove the root device */
 	if (driver->dev_rm)
@@ -667,14 +667,14 @@ EXPORT_SYMBOL(vmbus_child_driver_unregister);
  * vmbus_child_device_create - Creates and registers a new child device
  * on the vmbus.
  */
-struct vm_device *vmbus_child_device_create(struct hv_guid *type,
+struct hyperv_device *vmbus_child_device_create(struct hv_guid *type,
 					    struct hv_guid *instance,
 					    struct vmbus_channel *channel)
 {
-	struct vm_device *child_device_ctx;
+	struct hyperv_device *child_device_ctx;
 
 	/* Allocate the new child device */
-	child_device_ctx = kzalloc(sizeof(struct vm_device), GFP_KERNEL);
+	child_device_ctx = kzalloc(sizeof(struct hyperv_device), GFP_KERNEL);
 	if (!child_device_ctx) {
 		DPRINT_ERR(VMBUS_DRV,
 			"unable to allocate device_context for child device");
@@ -711,8 +711,8 @@ struct vm_device *vmbus_child_device_create(struct hv_guid *type,
 /*
  * vmbus_child_device_register - Register the child device on the specified bus
  */
-int vmbus_child_device_register(struct vm_device *root_device_obj,
-				struct vm_device *child_device_obj)
+int vmbus_child_device_register(struct hyperv_device *root_device_obj,
+				struct hyperv_device *child_device_obj)
 {
 	int ret = 0;
 	static atomic_t device_num = ATOMIC_INIT(0);
@@ -752,7 +752,7 @@ int vmbus_child_device_register(struct vm_device *root_device_obj,
  * vmbus_child_device_unregister - Remove the specified child device
  * from the vmbus.
  */
-void vmbus_child_device_unregister(struct vm_device *device_obj)
+void vmbus_child_device_unregister(struct hyperv_device *device_obj)
 {
 
 	DPRINT_INFO(VMBUS_DRV, "unregistering child device (%p)",
@@ -777,7 +777,7 @@ void vmbus_child_device_unregister(struct vm_device *device_obj)
  */
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
-	struct vm_device *device_ctx = device_to_vm_device(device);
+	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
 	int ret;
 
 	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
@@ -850,7 +850,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
 	struct driver_context *driver_ctx = driver_to_driver_context(driver);
-	struct vm_device *device_ctx = device_to_vm_device(device);
+	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
 
 	/* We found our driver ? */
 	if (memcmp(&device_ctx->class_id, &driver_ctx->class_id,
@@ -882,7 +882,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
  */
 static void vmbus_probe_failed_cb(struct work_struct *context)
 {
-	struct vm_device *device_ctx = (struct vm_device *)context;
+	struct hyperv_device *device_ctx = (struct hyperv_device *)context;
 
 	/*
 	 * Kick off the process of unregistering the device.
@@ -901,8 +901,8 @@ static int vmbus_probe(struct device *child_device)
 	int ret = 0;
 	struct driver_context *driver_ctx =
 			driver_to_driver_context(child_device->driver);
-	struct vm_device *device_ctx =
-			device_to_vm_device(child_device);
+	struct hyperv_device *device_ctx =
+			device_to_hyperv_device(child_device);
 
 	/* Let the specific open-source driver handles the probe if it can */
 	if (driver_ctx->probe) {
@@ -1008,7 +1008,7 @@ static void vmbus_bus_release(struct device *device)
  */
 static void vmbus_device_release(struct device *device)
 {
-	struct vm_device *device_ctx = device_to_vm_device(device);
+	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
 
 	kfree(device_ctx);
 
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 206218c..4a8f2e8 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -103,18 +103,18 @@ extern struct vmbus_connection vmbus_connection;
 
 /* General vmbus interface */
 
-struct vm_device *vmbus_child_device_create(struct hv_guid *type,
+struct hyperv_device *vmbus_child_device_create(struct hv_guid *type,
 					 struct hv_guid *instance,
 					 struct vmbus_channel *channel);
 
-int vmbus_child_dev_add(struct vm_device *device);
-int vmbus_child_device_register(struct vm_device *root_device_obj,
-				struct vm_device *child_device_obj);
-void vmbus_child_device_unregister(struct vm_device *device_obj);
+int vmbus_child_dev_add(struct hyperv_device *device);
+int vmbus_child_device_register(struct hyperv_device *root_device_obj,
+				struct hyperv_device *child_device_obj);
+void vmbus_child_device_unregister(struct hyperv_device *device_obj);
 
 /* static void */
 /* VmbusChildDeviceDestroy( */
-/* struct vm_device *); */
+/* struct hyperv_device *); */
 
 struct vmbus_channel *relid2channel(u32 relid);
 
-- 
1.5.5.6

