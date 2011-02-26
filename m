Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1BZB6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:58:15 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:49477
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750725Ab1BZB6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:58:14 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 4/6] Staging: hv:  Unify the hyperv driver abstractions
Date: Fri, 25 Feb 2011 18:07:03 -0800
Message-Id: <1298686023-30892-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch combines the two driver abstractions into
a single driver abstraction.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c       |    2 +-
 drivers/staging/hv/blkvsc_drv.c   |    2 +-
 drivers/staging/hv/netvsc.c       |    6 +++---
 drivers/staging/hv/netvsc_api.h   |    4 ++--
 drivers/staging/hv/netvsc_drv.c   |    2 +-
 drivers/staging/hv/rndis_filter.c |    4 ++--
 drivers/staging/hv/storvsc.c      |    4 ++--
 drivers/staging/hv/storvsc_api.h  |    6 +++---
 drivers/staging/hv/storvsc_drv.c  |    2 +-
 drivers/staging/hv/vmbus.h        |   10 +++++++++-
 drivers/staging/hv/vmbus_api.h    |   14 +-------------
 drivers/staging/hv/vmbus_drv.c    |   18 +++++++++---------
 12 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 47ccec2..d29af4b 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -63,7 +63,7 @@ blk_vsc_on_device_add(struct hyperv_device *device, void *additional_info)
 	return ret;
 }
 
-int blk_vsc_initialize(struct hv_driver *driver)
+int blk_vsc_initialize(struct driver_context *driver)
 {
 	struct storvsc_driver_object *stor_driver;
 	int ret = 0;
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 305a665..a280f83 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -171,7 +171,7 @@ static const struct block_device_operations block_ops = {
 /*
  * blkvsc_drv_init -  BlkVsc driver initialization.
  */
-static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
+static int blkvsc_drv_init(int (*drv_init)(struct driver_context *drv))
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
 	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7cf6999..6d8d0a3 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -49,7 +49,7 @@ netvsc_device_add(struct hyperv_device *device, void *additional_info);
 
 static int netvsc_device_remove(struct hyperv_device *device);
 
-static void netvsc_cleanup(struct hv_driver *driver);
+static void netvsc_cleanup(struct driver_context *driver);
 
 static void netvsc_channel_cb(void *context);
 
@@ -178,7 +178,7 @@ static struct netvsc_device *release_inbound_net_device(
 /*
  * netvsc_initialize - Main entry point
  */
-int netvsc_initialize(struct hv_driver *drv)
+int netvsc_initialize(struct driver_context *drv)
 {
 	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
 
@@ -837,7 +837,7 @@ static int netvsc_device_remove(struct hyperv_device *device)
 /*
  * netvsc_cleanup - Perform any cleanup when the driver is removed
  */
-static void netvsc_cleanup(struct hv_driver *drv)
+static void netvsc_cleanup(struct driver_context *drv)
 {
 }
 
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index e43ff7b..842f542 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -84,7 +84,7 @@ struct hv_netvsc_packet {
 struct netvsc_driver {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct hv_driver base;
+	struct driver_context base;
 
 	u32 ring_buf_size;
 	u32 req_ext_size;
@@ -109,7 +109,7 @@ struct netvsc_device_info {
 };
 
 /* Interface */
-int netvsc_initialize(struct hv_driver *drv);
+int netvsc_initialize(struct driver_context *drv);
 int rndis_filter_open(struct hyperv_device *dev);
 int rndis_filter_close(struct hyperv_device *dev);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index fc4eb9b..fbb32f7 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -490,7 +490,7 @@ static void netvsc_drv_exit(void)
 	return;
 }
 
-static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
+static int netvsc_drv_init(int (*drv_init)(struct driver_context *drv))
 {
 	struct netvsc_driver *net_drv_obj = &g_netvsc_drv.drv_obj;
 	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index b718fa9..a2b5f4d 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -90,7 +90,7 @@ static int rndis_filte_device_add(struct hyperv_device *dev,
 
 static int rndis_filter_device_remove(struct hyperv_device *dev);
 
-static void rndis_filter_cleanup(struct hv_driver *drv);
+static void rndis_filter_cleanup(struct driver_context *drv);
 
 static int rndis_filter_send(struct hyperv_device *dev,
 			     struct hv_netvsc_packet *pkt);
@@ -834,7 +834,7 @@ static int rndis_filter_device_remove(struct hyperv_device *dev)
 	return 0;
 }
 
-static void rndis_filter_cleanup(struct hv_driver *drv)
+static void rndis_filter_cleanup(struct driver_context *drv)
 {
 }
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6000b0d..c86bc68 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -781,14 +781,14 @@ static int stor_vsc_on_io_request(struct hyperv_device *device,
 /*
  * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
-static void stor_vsc_on_cleanup(struct hv_driver *driver)
+static void stor_vsc_on_cleanup(struct driver_context *driver)
 {
 }
 
 /*
  * stor_vsc_initialize - Main entry point
  */
-int stor_vsc_initialize(struct hv_driver *driver)
+int stor_vsc_initialize(struct driver_context *driver)
 {
 	struct storvsc_driver_object *stor_driver;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index c2915b4..b488d75 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -80,7 +80,7 @@ struct hv_storvsc_request {
 struct storvsc_driver_object {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct hv_driver base;
+	struct driver_context base;
 
 	/* Set by caller (in bytes) */
 	u32 ring_buffer_size;
@@ -103,8 +103,8 @@ struct storvsc_device_info {
 };
 
 /* Interface */
-int stor_vsc_initialize(struct hv_driver *driver);
+int stor_vsc_initialize(struct driver_context *driver);
 int stor_vsc_on_host_reset(struct hyperv_device *device);
-int blk_vsc_initialize(struct hv_driver *driver);
+int blk_vsc_initialize(struct driver_context *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c094578..282bd66 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -135,7 +135,7 @@ static struct scsi_host_template scsi_driver = {
 /*
  * storvsc_drv_init - StorVsc driver initialization.
  */
-static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
+static int storvsc_drv_init(int (*drv_init)(struct driver_context *drv))
 {
 	int ret;
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 1ac7e56..cad8b4c 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -29,8 +29,16 @@
 #include "vmbus_api.h"
 
 struct driver_context {
+	const char *name;
+
 	struct hv_guid class_id;
 
+	int (*dev_add)(struct hyperv_device *device, void *data);
+
+	int (*dev_rm)(struct hyperv_device *device);
+
+	void (*cleanup)(struct driver_context *driver);
+
 	struct device_driver driver;
 
 	/*
@@ -48,7 +56,7 @@ struct hyperv_device {
 	struct work_struct probe_failed_work_item;
 	struct hv_guid class_id; /* device type id */
 	struct hv_guid device_id; /* device instance id */
-	struct hv_driver *drv;
+	struct driver_context *drv;
 	int probe_error;
 	struct vmbus_channel *channel; /* associated channel to host*/
 	void    *ext;
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 260086f..0d8232e 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -55,7 +55,7 @@ struct hv_multipage_buffer {
 
 #pragma pack(pop)
 
-struct hv_driver;
+struct driver_context;
 struct hyperv_device;
 
 struct hv_dev_port_info {
@@ -84,16 +84,4 @@ struct hyperv_device_info {
 	struct hv_dev_port_info outbound;
 };
 
-/* Base driver object */
-struct hv_driver {
-	const char *name;
-
-	/* the device type supported by this driver */
-	struct hv_guid class_id;
-
-	int (*dev_add)(struct hyperv_device *device, void *data);
-	int (*dev_rm)(struct hyperv_device *device);
-	void (*cleanup)(struct hv_driver *driver);
-};
-
 #endif /* _VMBUS_API_H_ */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index a385bd2..3922a07 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,7 +47,7 @@ struct vmbus_driver_context {
 	/* The driver field is not used in here. Instead, the bus field is */
 	/* used to represent the driver */
 	struct driver_context drv_ctx;
-	struct hv_driver drv_obj;
+	struct driver_context drv_obj;
 
 	struct bus_type bus;
 	struct tasklet_struct msg_dpc;
@@ -196,7 +196,7 @@ static int vmbus_dev_rm(struct hyperv_device *dev)
 /*
  * vmbus_cleanup - Perform any cleanup when the driver is removed
  */
-static void vmbus_cleanup(struct hv_driver *drv)
+static void vmbus_cleanup(struct driver_context *drv)
 {
 	/* struct vmbus_driver *driver = (struct vmbus_driver *)drv; */
 
@@ -221,7 +221,7 @@ static void vmbus_onmessage_work(struct work_struct *work)
 /*
  * vmbus_on_msg_dpc - DPC routine to handle messages from the hypervisior
  */
-static void vmbus_on_msg_dpc(struct hv_driver *drv)
+static void vmbus_on_msg_dpc(struct driver_context *drv)
 {
 	int cpu = smp_processor_id();
 	void *page_addr = hv_context.synic_message_page[cpu];
@@ -267,7 +267,7 @@ static void vmbus_on_msg_dpc(struct hv_driver *drv)
 /*
  * vmbus_on_isr - ISR routine
  */
-static int vmbus_on_isr(struct hv_driver *drv)
+static int vmbus_on_isr(struct driver_context *drv)
 {
 	int ret = 0;
 	int cpu = smp_processor_id();
@@ -463,7 +463,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 static int vmbus_bus_init(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
+	struct driver_context *driver = &vmbus_drv.drv_obj;
 	struct hyperv_device *dev = &vmbus_drv.device_obj;
 	int ret;
 	unsigned int vector;
@@ -587,7 +587,7 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
+	struct driver_context *driver = &vmbus_drv.drv_obj;
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
 	struct hyperv_device *dev = &vmbus_drv.device_obj;
@@ -857,7 +857,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		   sizeof(struct hv_guid)) == 0) {
 		/*
 		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
-		 * it here to access the struct hv_driver field
+		 * it here to access the struct driver_context field
 		 */
 		struct vmbus_driver_context *vmbus_drv_ctx =
 			(struct vmbus_driver_context *)driver_ctx;
@@ -1020,7 +1020,7 @@ static void vmbus_device_release(struct device *device)
  */
 static void vmbus_msg_dpc(unsigned long data)
 {
-	struct hv_driver *driver = (struct hv_driver *)data;
+	struct driver_context *driver = (struct driver_context *)data;
 
 	/* Call to bus driver to handle interrupt */
 	vmbus_on_msg_dpc(driver);
@@ -1037,7 +1037,7 @@ static void vmbus_event_dpc(unsigned long data)
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
+	struct driver_context *driver = &vmbus_drv.drv_obj;
 	int ret;
 
 	/* Call to bus driver to handle interrupt */
-- 
1.5.5.6

